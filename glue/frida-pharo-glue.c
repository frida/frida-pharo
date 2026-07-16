/*
 * frida-pharo-glue: the tiny C bridge that lets the single-threaded Pharo VM
 * consume frida-core's async-from-a-foreign-thread C API safely.
 *
 * How Frida actually works: frida-core starts its own background thread and
 * runs its GMainContext there. The model, matching the other bindings:
 *
 *   1. Schedule the frida_*_begin() call onto frida's own thread by attaching a
 *      g_idle source to frida_get_main_context(). The _start runs on frida's
 *      thread.
 *   2. The GAsyncReadyCallback fires on frida's thread. It calls frida_*_finish()
 *      RIGHT THERE (on frida's thread), producing the raw result (a FridaXxx*
 *      GObject / scalar / string) and a GError*. It stashes both and then
 *      signalSemaphoreWithIndex(i) to wake Pharo. It must NOT touch the VM.
 *   3. The Pharo process that was wait:ing wakes and MARSHALS the raw result
 *      into Pharo objects on the Pharo thread (wrap the GObject, convert the
 *      scalar/string, or raise the mapped exception from GError).
 *
 * So: scheduling + _start + _finish all run on frida's thread; only turning the
 * raw C result into Pharo objects happens on the Pharo thread.
 *
 * The frida symbols and signalSemaphoreWithIndex are resolved dynamically
 * (dlsym RTLD_DEFAULT) so the glue links only against libfrida-core for GLib.
 */

#include <dlfcn.h>
#include <string.h>
#include <glib.h>
#include <glib-object.h>
#include <gio/gio.h>

typedef int (*FridaPharoSignalFunc) (int semaphore_index);
typedef GMainContext * (*FridaGetMainContextFunc) (void);

/* Every frida_*_finish has the shape RET (self, GAsyncResult*, GError**). On
 * arm64/x86-64 the return (pointer, bool, int or enum) comes back in the return
 * register, so one uniform prototype captures them all; void finishes just
 * leave a value we ignore. No finish returns a struct by value. */
typedef guint64 (*FridaFinishFunc) (gpointer, gpointer, GError **);

typedef void (*FridaBeginFunc0) (gpointer, gpointer, GAsyncReadyCallback, gpointer);
typedef void (*FridaBeginFunc1) (gpointer, gpointer, gpointer, GAsyncReadyCallback, gpointer);
typedef void (*FridaBeginFunc2) (gpointer, gpointer, gpointer, gpointer, GAsyncReadyCallback, gpointer);
typedef void (*FridaBeginFunc3) (gpointer, gpointer, gpointer, gpointer, gpointer, GAsyncReadyCallback, gpointer);

typedef struct _FridaPharoOperation FridaPharoOperation;

struct _FridaPharoOperation
{
  /* set up by Pharo before scheduling */
  int semaphore_index;
  gpointer self;
  char * begin_symbol;
  char * finish_symbol;
  gpointer args[3];
  char * owned_strings[3];  /* strdup'd string args, freed with the operation */
  int owned_free_kind[3];   /* how to free an owned reference arg (see enum below) */
  int n_args;
  gpointer cancellable;

  /* filled in on frida's thread once complete */
  guint64 result_value;
  GError * error;
};

static FridaPharoSignalFunc
frida_pharo_signal_func (void)
{
  static FridaPharoSignalFunc func = NULL;
  if (func == NULL)
    func = (FridaPharoSignalFunc) dlsym (RTLD_DEFAULT, "signalSemaphoreWithIndex");
  return func;
}

static GMainContext *
frida_pharo_main_context (void)
{
  static FridaGetMainContextFunc func = NULL;
  if (func == NULL)
    func = (FridaGetMainContextFunc) dlsym (RTLD_DEFAULT, "frida_get_main_context");
  return (func != NULL) ? func () : NULL;
}

/* --- Operation lifecycle (called from Pharo) ------------------------------ */

FridaPharoOperation *
frida_pharo_operation_new (int semaphore_index,
                           gpointer self,
                           const char * begin_symbol,
                           const char * finish_symbol,
                           gpointer cancellable)
{
  FridaPharoOperation * op = g_slice_new0 (FridaPharoOperation);
  op->semaphore_index = semaphore_index;
  op->self = self;
  op->begin_symbol = g_strdup (begin_symbol);
  op->finish_symbol = g_strdup (finish_symbol);
  op->cancellable = cancellable;
  return op;
}

static void
frida_pharo_operation_note_arg (FridaPharoOperation * op, int index)
{
  if (index + 1 > op->n_args)
    op->n_args = index + 1;
}

/* Integer/enum arg: pass the value in a pointer-sized slot (value lives in the
 * register on the platforms we target). */
void
frida_pharo_operation_set_int_arg (FridaPharoOperation * op, int index, gint64 value)
{
  op->args[index] = (gpointer) (gssize) value;
  frida_pharo_operation_note_arg (op, index);
}

/* Pointer arg: an object handle or NULL. */
void
frida_pharo_operation_set_pointer_arg (FridaPharoOperation * op, int index, gpointer value)
{
  op->args[index] = value;
  frida_pharo_operation_note_arg (op, index);
}

/* String arg: copied here so it survives the cross-thread hop to frida's
 * thread; freed in frida_pharo_operation_free. */
void
frida_pharo_operation_set_string_arg (FridaPharoOperation * op, int index, const char * value)
{
  op->owned_strings[index] = g_strdup (value);
  op->args[index] = op->owned_strings[index];
  frida_pharo_operation_note_arg (op, index);
}

/* Owned reference arg (GBytes/GVariant/GHashTable), pre-built by Pharo. The
 * operation keeps it alive across the cross-thread hop and drops our reference
 * in frida_pharo_operation_free once _finish has run. free_kind: 1=g_bytes_unref,
 * 2=g_variant_unref, 3=g_hash_table_unref. */
enum
{
  FRIDA_PHARO_FREE_NONE = 0,
  FRIDA_PHARO_FREE_BYTES = 1,
  FRIDA_PHARO_FREE_VARIANT = 2,
  FRIDA_PHARO_FREE_VARDICT = 3
};

void
frida_pharo_operation_set_owned_arg (FridaPharoOperation * op, int index, gpointer value, int free_kind)
{
  op->args[index] = value;
  op->owned_free_kind[index] = free_kind;
  frida_pharo_operation_note_arg (op, index);
}

static void
frida_pharo_free_owned (gpointer value, int free_kind)
{
  if (value == NULL)
    return;
  switch (free_kind)
  {
    case FRIDA_PHARO_FREE_BYTES:   g_bytes_unref (value); break;
    case FRIDA_PHARO_FREE_VARIANT: g_variant_unref (value); break;
    case FRIDA_PHARO_FREE_VARDICT: g_hash_table_unref (value); break;
    default: break;
  }
}

guint64
frida_pharo_operation_get_result (FridaPharoOperation * op)
{
  return op->result_value;
}

GError *
frida_pharo_operation_get_error (FridaPharoOperation * op)
{
  return op->error;
}

void
frida_pharo_operation_free (FridaPharoOperation * op)
{
  int i;

  g_free (op->begin_symbol);
  g_free (op->finish_symbol);
  for (i = 0; i != 3; i++)
  {
    g_free (op->owned_strings[i]);
    frida_pharo_free_owned (op->args[i], op->owned_free_kind[i]);
  }
  if (op->error != NULL)
    g_error_free (op->error);
  g_slice_free (FridaPharoOperation, op);
}

/* --- Completion, on frida's thread --------------------------------------- */

static void
frida_pharo_on_ready (GObject * source_object,
                      GAsyncResult * res,
                      gpointer user_data)
{
  FridaPharoOperation * op = user_data;
  FridaFinishFunc finish;
  FridaPharoSignalFunc signal_func;

  (void) source_object;

  finish = (FridaFinishFunc) dlsym (RTLD_DEFAULT, op->finish_symbol);
  op->result_value = finish (op->self, res, &op->error);

  signal_func = frida_pharo_signal_func ();
  if (signal_func != NULL)
    signal_func (op->semaphore_index);
}

/* --- Scheduling the _start onto frida's thread --------------------------- */

static gboolean
frida_pharo_perform_start (gpointer data)
{
  FridaPharoOperation * op = data;
  FridaBeginFunc0 begin = (FridaBeginFunc0) dlsym (RTLD_DEFAULT, op->begin_symbol);

  switch (op->n_args)
  {
    case 0:
      begin (op->self, op->cancellable, frida_pharo_on_ready, op);
      break;
    case 1:
      ((FridaBeginFunc1) begin) (op->self, op->args[0], op->cancellable,
          frida_pharo_on_ready, op);
      break;
    case 2:
      ((FridaBeginFunc2) begin) (op->self, op->args[0], op->args[1],
          op->cancellable, frida_pharo_on_ready, op);
      break;
    case 3:
      ((FridaBeginFunc3) begin) (op->self, op->args[0], op->args[1], op->args[2],
          op->cancellable, frida_pharo_on_ready, op);
      break;
  }

  return G_SOURCE_REMOVE;
}

void
frida_pharo_operation_schedule (FridaPharoOperation * op)
{
  GSource * source = g_idle_source_new ();
  g_source_set_callback (source, frida_pharo_perform_start, op, NULL);
  g_source_attach (source, frida_pharo_main_context ());
  g_source_unref (source);
}

/* --- GError helpers (read on the Pharo thread) --------------------------- */

const char *
frida_pharo_error_message (GError * error)
{
  return (error != NULL) ? error->message : NULL;
}

int
frida_pharo_error_code (GError * error)
{
  return (error != NULL) ? error->code : 0;
}

void
frida_pharo_error_free (GError * error)
{
  if (error != NULL)
    g_error_free (error);
}

void
frida_pharo_gfree (gpointer p)
{
  g_free (p);
}

/* Whether a symbol is resolvable in the loaded image. Used by the tests to
 * assert that the GIO stream entry points the FridaIOStream byte-I/O wiring
 * dlsym()s (g_input_stream_read_async and friends) actually survived the
 * static link / dead-strip, without needing a live channel to prove it. */
int
frida_pharo_symbol_available (const char * name)
{
  return dlsym (RTLD_DEFAULT, name) != NULL;
}

/* The GObject type name of an instance (e.g. "FridaDevice"), which equals the
 * concrete generated Pharo class name -- used to wrap handles as their concrete
 * type rather than the base class. */
const char *
frida_pharo_instance_type_name (gpointer instance)
{
  if (instance == NULL)
    return NULL;
  return g_type_name (G_TYPE_FROM_INSTANCE (instance));
}

/* --- strv (gchar**) <-> Pharo Array of String --------------------------- */

int
frida_pharo_strv_length (gchar ** strv)
{
  int n = 0;
  if (strv != NULL)
    while (strv[n] != NULL)
      n++;
  return n;
}

const char *
frida_pharo_strv_get (gchar ** strv, int index)
{
  return strv[index];
}

void
frida_pharo_strv_free (gchar ** strv)
{
  typedef void (* StrvFreeFunc) (gchar **);
  StrvFreeFunc f = (StrvFreeFunc) dlsym (RTLD_DEFAULT, "g_strfreev");
  if (f != NULL && strv != NULL)
    f (strv);
}

/* Build a NULL-terminated gchar** of the given length for strv input params.
 * Filled with frida_pharo_strv_set, freed with frida_pharo_strv_free. */
gchar **
frida_pharo_strv_new (int length)
{
  return g_new0 (gchar *, length + 1);
}

void
frida_pharo_strv_set (gchar ** strv, int index, const char * value)
{
  strv[index] = g_strdup (value);
}

/* --- GBytes <-> Pharo ByteArray ----------------------------------------- */

gsize
frida_pharo_bytes_size (gpointer bytes)
{
  typedef gsize (* GetSizeFunc) (gpointer);
  GetSizeFunc f = (GetSizeFunc) dlsym (RTLD_DEFAULT, "g_bytes_get_size");
  return (bytes != NULL && f != NULL) ? f (bytes) : 0;
}

/* Copy the GBytes payload into a caller-provided buffer (a pinned Pharo
 * ByteArray of the right size). */
void
frida_pharo_bytes_copy_to (gpointer bytes, void * dest)
{
  typedef gconstpointer (* GetDataFunc) (gpointer, gsize *);
  GetDataFunc f = (GetDataFunc) dlsym (RTLD_DEFAULT, "g_bytes_get_data");
  gsize size = 0;
  gconstpointer data;
  if (bytes == NULL || f == NULL)
    return;
  data = f (bytes, &size);
  if (data != NULL && size != 0)
    memcpy (dest, data, size);
}

void
frida_pharo_bytes_unref (gpointer bytes)
{
  typedef void (* UnrefFunc) (gpointer);
  UnrefFunc f = (UnrefFunc) dlsym (RTLD_DEFAULT, "g_bytes_unref");
  if (bytes != NULL && f != NULL)
    f (bytes);
}

/* Build a GBytes (copying) from a Pharo ByteArray, for GBytes input params. */
gpointer
frida_pharo_bytes_new (void * data, gsize size)
{
  typedef gpointer (* NewFunc) (gconstpointer, gsize);
  NewFunc f = (NewFunc) dlsym (RTLD_DEFAULT, "g_bytes_new");
  return (f != NULL) ? f (data, size) : NULL;
}

/* --- Signals -------------------------------------------------------------
 * A GObject signal (e.g. FridaScript::message) is emitted on frida's thread. We
 * connect a pure-C handler that enqueues the payload on a thread-safe
 * GAsyncQueue and signalSemaphoreWithIndex() a delivery semaphore. A dedicated
 * Pharo listener process waits on that semaphore, drains the queue with
 * frida_pharo_subscription_poll(), and dispatches on the Pharo thread. This
 * starts with the message signal (JSON string, optional GBytes data); other
 * signals are a follow-up (generic GClosure marshalling). */

typedef struct _FridaPharoSubscription FridaPharoSubscription;
typedef struct _FridaPharoMessage FridaPharoMessage;

struct _FridaPharoSubscription
{
  GAsyncQueue * queue;
  int semaphore_index;
  gulong handler_id;
  gpointer source;
};

struct _FridaPharoMessage
{
  char * text;
  void * data;      /* copied GBytes payload, or NULL */
  gsize data_size;
};

static void
frida_pharo_message_free (gpointer p)
{
  FridaPharoMessage * m = p;
  g_free (m->text);
  g_free (m->data);
  g_free (m);
}

/* Runs on frida's thread. Matches FridaScript::message (self, message, data). */
static void
frida_pharo_on_script_message (gpointer source,
                               const char * message,
                               gpointer data,       /* GBytes* */
                               gpointer user_data)
{
  FridaPharoSubscription * sub = user_data;
  FridaPharoMessage * m;
  FridaPharoSignalFunc signal_func;

  (void) source;

  m = g_new0 (FridaPharoMessage, 1);
  m->text = g_strdup (message);
  if (data != NULL)
  {
    gsize size = 0;
    typedef gconstpointer (* GBytesGetDataFunc) (gpointer, gsize *);
    GBytesGetDataFunc get_data =
        (GBytesGetDataFunc) dlsym (RTLD_DEFAULT, "g_bytes_get_data");
    gconstpointer bytes = get_data (data, &size);
    if (bytes != NULL && size != 0)
    {
      m->data = g_memdup2 (bytes, size);
      m->data_size = size;
    }
  }

  g_async_queue_push (sub->queue, m);

  signal_func = frida_pharo_signal_func ();
  if (signal_func != NULL)
    signal_func (sub->semaphore_index);
}

FridaPharoSubscription *
frida_pharo_script_connect_message (gpointer script, int semaphore_index)
{
  FridaPharoSubscription * sub = g_slice_new0 (FridaPharoSubscription);
  sub->queue = g_async_queue_new_full (frida_pharo_message_free);
  sub->semaphore_index = semaphore_index;
  sub->source = script;
  sub->handler_id = g_signal_connect_data (script, "message",
      G_CALLBACK (frida_pharo_on_script_message), sub, NULL, 0);
  return sub;
}

/* Pop the next queued message text (Pharo copies it to a String); NULL when the
 * queue is drained. */
const char *
frida_pharo_subscription_poll (FridaPharoSubscription * sub)
{
  FridaPharoMessage * m = g_async_queue_try_pop (sub->queue);
  static __thread char * last = NULL;  /* keep alive until next poll */
  g_free (last);
  last = NULL;
  if (m == NULL)
    return NULL;
  last = g_strdup (m->text);
  frida_pharo_message_free (m);
  return last;
}

void
frida_pharo_subscription_disconnect (FridaPharoSubscription * sub)
{
  typedef void (* SignalHandlerDisconnectFunc) (gpointer, gulong);
  SignalHandlerDisconnectFunc disconnect =
      (SignalHandlerDisconnectFunc) dlsym (RTLD_DEFAULT, "g_signal_handler_disconnect");
  if (disconnect != NULL && sub->handler_id != 0)
    disconnect (sub->source, sub->handler_id);
  g_async_queue_unref (sub->queue);
  g_slice_free (FridaPharoSubscription, sub);
}

/* --- Generic signals -----------------------------------------------------
 * Beyond FridaScript::message, connect any GObject signal with a generic
 * GClosure marshaller. On frida's thread it decodes each signal argument from
 * its GValue into a small tagged union, enqueues the event, and signals the
 * delivery semaphore; the Pharo listener polls the event and reads the args via
 * the accessors below (wrapping object handles on the Pharo thread). Argument
 * kinds covered: int/uint/enum/flags (int), boolean, string, GObject. */

typedef struct _FridaPharoSignalArg FridaPharoSignalArg;
typedef struct _FridaPharoSignalEvent FridaPharoSignalEvent;

enum
{
  FRIDA_PHARO_ARG_NONE = 0,
  FRIDA_PHARO_ARG_INT = 1,
  FRIDA_PHARO_ARG_STRING = 2,
  FRIDA_PHARO_ARG_OBJECT = 3,
  FRIDA_PHARO_ARG_BOOLEAN = 4
};

struct _FridaPharoSignalArg
{
  int tag;
  gint64 int_value;
  char * string_value;
  gpointer object_value;
};

struct _FridaPharoSignalEvent
{
  int n_args;
  FridaPharoSignalArg args[8];
};

static void
frida_pharo_signal_event_free (gpointer p)
{
  FridaPharoSignalEvent * ev = p;
  int i;
  for (i = 0; i != ev->n_args; i++)
  {
    if (ev->args[i].tag == FRIDA_PHARO_ARG_STRING)
      g_free (ev->args[i].string_value);
    else if (ev->args[i].tag == FRIDA_PHARO_ARG_OBJECT && ev->args[i].object_value != NULL)
      g_object_unref (ev->args[i].object_value);
  }
  g_free (ev);
}

static void
frida_pharo_signal_marshal (GClosure * closure,
                            GValue * return_value,
                            guint n_param_values,
                            const GValue * param_values,
                            gpointer invocation_hint,
                            gpointer marshal_data)
{
  FridaPharoSubscription * sub = closure->data;
  FridaPharoSignalEvent * ev;
  FridaPharoSignalFunc signal_func;
  guint i;

  (void) return_value;
  (void) invocation_hint;
  (void) marshal_data;

  ev = g_new0 (FridaPharoSignalEvent, 1);

  /* param_values[0] is the emitting instance; the signal args follow. */
  for (i = 1; i != n_param_values && ev->n_args != 8; i++)
  {
    const GValue * v = &param_values[i];
    GType fundamental = G_TYPE_FUNDAMENTAL (G_VALUE_TYPE (v));
    FridaPharoSignalArg * a = &ev->args[ev->n_args++];

    switch (fundamental)
    {
      case G_TYPE_INT:     a->tag = FRIDA_PHARO_ARG_INT; a->int_value = g_value_get_int (v); break;
      case G_TYPE_UINT:    a->tag = FRIDA_PHARO_ARG_INT; a->int_value = g_value_get_uint (v); break;
      case G_TYPE_INT64:   a->tag = FRIDA_PHARO_ARG_INT; a->int_value = g_value_get_int64 (v); break;
      case G_TYPE_UINT64:  a->tag = FRIDA_PHARO_ARG_INT; a->int_value = g_value_get_uint64 (v); break;
      case G_TYPE_ENUM:    a->tag = FRIDA_PHARO_ARG_INT; a->int_value = g_value_get_enum (v); break;
      case G_TYPE_FLAGS:   a->tag = FRIDA_PHARO_ARG_INT; a->int_value = g_value_get_flags (v); break;
      case G_TYPE_BOOLEAN: a->tag = FRIDA_PHARO_ARG_BOOLEAN; a->int_value = g_value_get_boolean (v); break;
      case G_TYPE_STRING:  a->tag = FRIDA_PHARO_ARG_STRING; a->string_value = g_strdup (g_value_get_string (v)); break;
      case G_TYPE_OBJECT:
      {
        gpointer o = g_value_get_object (v);
        a->tag = FRIDA_PHARO_ARG_OBJECT;
        a->object_value = (o != NULL) ? g_object_ref (o) : NULL;
        break;
      }
      default: a->tag = FRIDA_PHARO_ARG_NONE; break;
    }
  }

  g_async_queue_push (sub->queue, ev);

  signal_func = frida_pharo_signal_func ();
  if (signal_func != NULL)
    signal_func (sub->semaphore_index);
}

FridaPharoSubscription *
frida_pharo_signal_connect (gpointer source, const char * signal_name, int semaphore_index)
{
  FridaPharoSubscription * sub = g_slice_new0 (FridaPharoSubscription);
  GClosure * closure;

  sub->queue = g_async_queue_new_full (frida_pharo_signal_event_free);
  sub->semaphore_index = semaphore_index;
  sub->source = source;

  closure = g_closure_new_simple (sizeof (GClosure), sub);
  g_closure_set_marshal (closure, frida_pharo_signal_marshal);
  sub->handler_id = g_signal_connect_closure (source, signal_name, closure, FALSE);

  return sub;
}

/* Pop the next event (or NULL). Caller reads args, then frees it. */
FridaPharoSignalEvent *
frida_pharo_signal_poll (FridaPharoSubscription * sub)
{
  return g_async_queue_try_pop (sub->queue);
}

int
frida_pharo_signal_event_arg_count (FridaPharoSignalEvent * ev)
{
  return ev->n_args;
}

int
frida_pharo_signal_event_arg_tag (FridaPharoSignalEvent * ev, int index)
{
  return ev->args[index].tag;
}

gint64
frida_pharo_signal_event_arg_int (FridaPharoSignalEvent * ev, int index)
{
  return ev->args[index].int_value;
}

const char *
frida_pharo_signal_event_arg_string (FridaPharoSignalEvent * ev, int index)
{
  return ev->args[index].string_value;
}

/* Transfer the object ref to the caller (Pharo wraps it as owned). */
gpointer
frida_pharo_signal_event_arg_object (FridaPharoSignalEvent * ev, int index)
{
  gpointer o = ev->args[index].object_value;
  ev->args[index].object_value = NULL;
  return o;
}

void
frida_pharo_signal_event_free_public (FridaPharoSignalEvent * ev)
{
  frida_pharo_signal_event_free (ev);
}

/* --- GVariant <-> Pharo --------------------------------------------------
 * Introspection + construction primitives; the recursive walk lives in the
 * Pharo FridaVariant marshaller. Covers a{sv} dicts, arrays/tuples, the scalar
 * types and 'ay' byte arrays. */

const char *
frida_pharo_variant_type_string (GVariant * v)
{
  return g_variant_get_type_string (v);
}

int
frida_pharo_variant_n_children (GVariant * v)
{
  return (int) g_variant_n_children (v);
}

GVariant *
frida_pharo_variant_child (GVariant * v, int index)
{
  return g_variant_get_child_value (v, index);
}

GVariant *
frida_pharo_variant_unbox (GVariant * v)
{
  return g_variant_get_variant (v);
}

void
frida_pharo_variant_unref (GVariant * v)
{
  if (v != NULL)
    g_variant_unref (v);
}

const char *
frida_pharo_variant_get_string (GVariant * v)
{
  return g_variant_get_string (v, NULL);
}

int
frida_pharo_variant_get_boolean (GVariant * v)
{
  return g_variant_get_boolean (v);
}

double
frida_pharo_variant_get_double (GVariant * v)
{
  return g_variant_get_double (v);
}

gint64
frida_pharo_variant_get_int (GVariant * v)
{
  switch (g_variant_classify (v))
  {
    case G_VARIANT_CLASS_BYTE:   return g_variant_get_byte (v);
    case G_VARIANT_CLASS_INT16:  return g_variant_get_int16 (v);
    case G_VARIANT_CLASS_UINT16: return g_variant_get_uint16 (v);
    case G_VARIANT_CLASS_INT32:  return g_variant_get_int32 (v);
    case G_VARIANT_CLASS_UINT32: return g_variant_get_uint32 (v);
    case G_VARIANT_CLASS_INT64:  return g_variant_get_int64 (v);
    case G_VARIANT_CLASS_UINT64: return (gint64) g_variant_get_uint64 (v);
    case G_VARIANT_CLASS_HANDLE: return g_variant_get_handle (v);
    default:                     return 0;
  }
}

gsize
frida_pharo_variant_get_size (GVariant * v)
{
  return g_variant_get_size (v);
}

void
frida_pharo_variant_copy_data (GVariant * v, void * dest)
{
  gsize size = g_variant_get_size (v);
  gconstpointer data = g_variant_get_data (v);
  if (data != NULL && size != 0)
    memcpy (dest, data, size);
}

/* Construction (each returns a sunk, full reference the caller owns). */

GVariant *
frida_pharo_variant_new_string (const char * s)
{
  return g_variant_ref_sink (g_variant_new_string (s));
}

GVariant *
frida_pharo_variant_new_int64 (gint64 i)
{
  return g_variant_ref_sink (g_variant_new_int64 (i));
}

GVariant *
frida_pharo_variant_new_boolean (int b)
{
  return g_variant_ref_sink (g_variant_new_boolean (b));
}

GVariant *
frida_pharo_variant_new_double (double d)
{
  return g_variant_ref_sink (g_variant_new_double (d));
}

GVariant *
frida_pharo_variant_new_bytes (const void * data, gsize size)
{
  return g_variant_ref_sink (
      g_variant_new_fixed_array (G_VARIANT_TYPE_BYTE, data, size, 1));
}

GVariantBuilder *
frida_pharo_variant_builder_new_dict (void)
{
  return g_variant_builder_new (G_VARIANT_TYPE ("a{sv}"));
}

void
frida_pharo_variant_builder_add_entry (GVariantBuilder * b, const char * key, GVariant * value)
{
  g_variant_builder_add (b, "{sv}", key, value);
}

GVariantBuilder *
frida_pharo_variant_builder_new_array (void)
{
  return g_variant_builder_new (G_VARIANT_TYPE ("av"));
}

void
frida_pharo_variant_builder_add_value (GVariantBuilder * b, GVariant * value)
{
  g_variant_builder_add (b, "v", value);
}

GVariant *
frida_pharo_variant_builder_end (GVariantBuilder * b)
{
  GVariant * v = g_variant_ref_sink (g_variant_builder_end (b));
  g_variant_builder_unref (b);
  return v;
}

/* --- vardict: GHashTable<utf8, GVariant> <-> Pharo Dictionary ------------
 * frida's `aux`/message-shaped params use a{sv}-style hash tables. Built on the
 * GVariant codec: the table owns its keys (g_free) and values (g_variant_unref). */

GHashTable *
frida_pharo_vardict_new (void)
{
  return g_hash_table_new_full (g_str_hash, g_str_equal, g_free,
      (GDestroyNotify) g_variant_unref);
}

/* Takes ownership of value (a sunk GVariant); the table unref's it on destroy. */
void
frida_pharo_vardict_insert (GHashTable * table, const char * key, GVariant * value)
{
  g_hash_table_insert (table, g_strdup (key), value);
}

void
frida_pharo_vardict_unref (GHashTable * table)
{
  if (table != NULL)
    g_hash_table_unref (table);
}

/* Owned (deep-copied) NULL-terminated key array; free with g_strfreev. */
gchar **
frida_pharo_vardict_dup_keys (GHashTable * table)
{
  guint length = 0;
  gchar ** keys = (gchar **) g_hash_table_get_keys_as_array (table, &length);
  gchar ** duplicate = g_strdupv (keys);
  g_free (keys);
  return duplicate;
}

/* Borrowed GVariant (owned by the table); do not unref. */
GVariant *
frida_pharo_vardict_lookup (GHashTable * table, const char * key)
{
  return g_hash_table_lookup (table, key);
}
