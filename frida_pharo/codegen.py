from __future__ import annotations

from typing import Dict, List, Optional

from frida_bindgen_core import TransferOwnership
from frida_bindgen_core.naming import to_camel_case as _to_camel_case


def to_camel_case(name: str) -> str:
    # GObject property/parameter names may be hyphenated (e.g. "parent-pid");
    # normalise to a legal Smalltalk selector fragment.
    return _to_camel_case(name.replace("-", "_"))

from .model import Model

PACKAGE = "FridaPharo"
GENERATED_TAG = "generated"

# --- GIR primitive -> uFFI type token -------------------------------------
# Pure language-level mapping (Pharo/uFFI), driven entirely by the generic GIR
# type model; nothing Frida-specific lives here.
_SCALAR_TOKENS = {
    "gboolean": "bool",
    "gint": "int",
    "gint8": "int8",
    "gint16": "int16",
    "gint32": "int32",
    "gint64": "longlong",
    "guint": "uint",
    "guint8": "uint8",
    "guint16": "uint16",
    "guint32": "uint32",
    "guint64": "ulonglong",
    "gfloat": "float",
    "gdouble": "double",
    "GType": "ulonglong",
}


class Mapped:
    """A GIR type resolved to how Pharo should marshal it."""

    def __init__(self, kind: str, token: str, pharo_class: Optional[str] = None,
                 is_list: bool = False):
        self.kind = kind  # scalar | string | object | enum | void
        self.token = token
        self.pharo_class = pharo_class
        self.is_list = is_list


def _map_type(type, model) -> Optional[Mapped]:
    if type is None:
        return Mapped("void", "void")

    name = type.name
    if name == "utf8":
        return Mapped("string", "String")
    if name == "utf8[]":
        return Mapped("strv", "void*")
    if name in ("GLib.Bytes",):
        return Mapped("bytes", "void*")
    if name == "GLib.Variant":
        return Mapped("variant", "void*")
    if name == "GLib.HashTable":
        # frida models its a{sv}-style tables as GHashTable<utf8, GVariant>.
        return Mapped("vardict", "void*")
    if name in _SCALAR_TOKENS:
        return Mapped("scalar", _SCALAR_TOKENS[name])

    bare = name.split(".", maxsplit=1)[-1]
    enum = model.enumerations.get(bare)
    if enum is not None:
        return Mapped("enum", enum.pharo_name, enum.pharo_name)

    obj = model.object_types.get(bare)
    if obj is not None and obj.c_type.startswith("Frida"):
        return Mapped("object", obj.pharo_name, obj.pharo_name,
                      is_list=obj.is_frida_list)

    external = model.customizations.external_object_types.get(name)
    if external is not None:
        return Mapped("object", external, external)

    # Everything else (GVariant, GBytes, strv, options, structs, GObject base,
    # out-params, ...) is not handled by this bootstrap slice yet.
    return None


def _is_emitted_object(obj) -> bool:
    return obj.c_type.startswith("Frida")


def generate_all(model: Model) -> Dict[str, str]:
    """Return a mapping of Tonel filename -> source for every generated class."""
    artefacts: Dict[str, str] = {}

    frida = _emit_frida_facade(model)
    artefacts["Frida.class.st"] = frida

    dropped = set(model.customizations.dropped_enumerations)
    for enum in model.enumerations.values():
        if enum.pharo_name in dropped:
            continue
        artefacts[f"{enum.pharo_name}.class.st"] = _emit_enumeration(enum)

    for obj in model.object_types.values():
        if not _is_emitted_object(obj):
            continue
        artefacts[f"{obj.pharo_name}.class.st"] = _emit_object_type(obj, model)

    return artefacts


def _facade_sections(model, target: str) -> List[str]:
    """Data-driven hand-authored convenience methods targeting `target`."""
    sections = []
    for fm in model.customizations.facade_methods:
        if fm.target != target:
            continue
        side = f"{target} class >> " if fm.class_side else f"{target} >> "
        sections.append(_method(f"{side}{fm.selector}", fm.category, fm.body))
    return sections


def _emit_frida_facade(model: Model) -> str:
    functions = model.customizations.namespace_functions

    methods = []
    for fn in functions:
        signature = "".join(f"{t} " for t in fn.arg_typings)
        call = f"#({fn.return_typing} {fn.c_symbol}({signature.strip()}))"
        methods.append(
            _method(
                f"Frida class >> {fn.pharo_name}",
                GENERATED_TAG,
                [f"^ self ffiCall: {call} library: FridaLibrary"],
            )
        )
    methods.extend(_facade_sections(model, "Frida"))

    return _class_file(
        name="Frida",
        superclass="Object",
        comment="Namespace-level Frida entry points. GENERATED - do not edit.",
        body_sections=methods,
        shared_variables=list(model.customizations.facade_class_vars.get("Frida", [])),
    )


def _emit_enumeration(enum) -> str:
    members = enum.pharo_members
    shared = ", ".join(f"'{name}'" for name, _ in members)

    decl_lines = ["^ #("]
    for name, value in members:
        decl_lines.append(f"\t\t{name} {value}")
    decl_lines.append("\t)")

    enum_decl = _method(
        f"{enum.pharo_name} class >> enumDecl",
        GENERATED_TAG,
        decl_lines,
    )

    # Class-side #initialize is run by the code loader at install time; it
    # populates the shared variables and generates the per-member accessors.
    initialize = _method(
        f"{enum.pharo_name} class >> initialize",
        GENERATED_TAG,
        ["self initializeEnumeration.", "self rebuildEnumAccessors"],
    )

    return _class_file(
        name=enum.pharo_name,
        superclass="FFIExternalEnumeration",
        comment=f"GENERATED binding for the Frida {enum.c_type} enumeration.",
        shared_variables=[name for name, _ in members],
        body_sections=[enum_decl, initialize],
    )


def _emit_object_type(obj, model) -> str:
    parent = obj.parent
    if parent is not None and _is_emitted_object(parent):
        superclass = parent.pharo_name
    else:
        superclass = "FridaObject"

    sections: List[str] = []

    for ctor in obj.constructors:
        section = _emit_constructor(obj, ctor, model)
        if section is not None:
            sections.append(section)

    for prop in obj.properties:
        section = _emit_property_getter(obj, prop, model)
        if section is not None:
            sections.append(section)

    for prop in obj.properties:
        section = _emit_property_setter(obj, prop, model)
        if section is not None:
            sections.append(section)

    prop_getter_ids = {p.getter for p in obj.properties}
    for meth in obj.methods:
        if meth.is_property_accessor or meth.c_identifier.split(f"{_c_prefix(obj)}_", 1)[-1] in prop_getter_ids:
            continue
        section = _emit_method(obj, meth, model)
        if section is not None:
            sections.append(section)

    for signal in obj.signals:
        section = _emit_signal_method(obj, signal, model)
        if section is not None:
            sections.append(section)

    if obj.is_frida_list:
        sections.extend(_emit_list_protocol(obj))

    print_section = _emit_print_on(obj, model)
    if print_section is not None:
        sections.append(print_section)

    identity_section = _emit_identity_properties(obj, model)
    if identity_section is not None:
        sections.append(identity_section)

    sections.extend(_facade_sections(model, obj.pharo_name))

    return _class_file(
        name=obj.pharo_name,
        superclass=superclass,
        comment=f"GENERATED binding for the Frida {obj.c_type} GObject.",
        body_sections=sections,
    )


def _emit_print_on(obj, model) -> Optional[str]:
    """Emit a #printOn: showing the type's identifying properties.

    The property list per type is data (customizations.print_specs); the emitter
    is type-agnostic. Every printed selector is read defensively so a half-built
    or released wrapper never raises from the inspector.
    """
    spec = next((s for s in model.customizations.print_specs
                 if s.target == obj.pharo_name), None)
    if spec is None:
        return None

    statements = ["super printOn: aStream",
                  "aStream nextPutAll: ' ('"]
    for i, prop in enumerate(spec.properties):
        sep = "" if i == 0 else " "
        statements.append(
            f"[ aStream nextPutAll: '{sep}{prop}='; print: (self {prop}) ] "
            f"on: Error do: [ :e | aStream nextPutAll: '{prop}=?' ]")
    statements.append("aStream nextPutAll: ')'")
    # Smalltalk statements are period-separated; the last carries none.
    lines = [s + "." for s in statements[:-1]] + [statements[-1]]
    return _method(f"{obj.pharo_name} >> printOn: aStream", GENERATED_TAG, lines)


def _emit_identity_properties(obj, model) -> Optional[str]:
    """Emit a class-side #identityProperties (the print spec's selectors) so the
    moldable inspector can column a list and tabulate an element generically,
    from the same customizations.print_specs that drive printOn:."""
    spec = next((s for s in model.customizations.print_specs
                 if s.target == obj.pharo_name), None)
    if spec is None:
        return None
    literal = "#(" + " ".join(spec.properties) + ")"
    return _method(f"{obj.pharo_name} class >> identityProperties", GENERATED_TAG,
                   [f"^ {literal}"])


def _emit_list_protocol(obj) -> List[str]:
    """Pharo collection protocol for a Frida `*List` GObject.

    Every list type exposes the generic ``size`` / ``get:`` accessors (emitted
    from its .gir methods); expressed in terms of those, the collection sugar is
    entirely type-agnostic. The underlying ``get:`` is 0-based; Pharo idiom is
    1-based, so ``at:`` and ``do:`` bridge that here.
    """
    return [
        _method(f"{obj.pharo_name} >> at: anIndex", GENERATED_TAG,
                ["^ self get: anIndex - 1"]),
        _method(f"{obj.pharo_name} >> do: aBlock", GENERATED_TAG,
                ["0 to: self size - 1 do: [ :i | aBlock value: (self get: i) ]"]),
        _method(f"{obj.pharo_name} >> collect: aBlock", GENERATED_TAG,
                ["^ self asArray collect: aBlock"]),
        _method(f"{obj.pharo_name} >> asArray", GENERATED_TAG,
                ["| result |",
                 "result := Array new: self size.",
                 "1 to: self size do: [ :i | result at: i put: (self get: i - 1) ].",
                 "^ result"]),
        _method(f"{obj.pharo_name} >> isEmpty", GENERATED_TAG,
                ["^ self size = 0"]),
        _method(f"{obj.pharo_name} >> isCollection", GENERATED_TAG,
                ["^ true"]),
    ]


def _c_prefix(obj) -> str:
    # e.g. FridaDeviceManager -> frida_device_manager
    from frida_bindgen_core.naming import to_snake_case

    return to_snake_case(obj.c_type)


def _emit_constructor(obj, ctor, model) -> Optional[str]:
    params = _map_parameters(ctor.parameters, model)
    if params is None:
        return None

    base = to_camel_case(ctor.name)
    selector = _selector(base, params)
    raw_selector = _selector(base + "Raw", params)
    arg_spec = _ffi_arg_spec(None, params)

    # A method containing #ffiCall: is compiled by uFFI as the raw callout, so
    # the C call must live alone in its own primitive; wrapping happens in the
    # caller.
    prim = _method(
        f"{obj.pharo_name} class >> {raw_selector}",
        GENERATED_TAG,
        [f"^ self ffiCall: #(void* {ctor.c_identifier} ({arg_spec})) library: FridaLibrary"],
    )
    # frida_init() must run before the first frida/GLib call; constructors are
    # the entry point, so ensure it here.
    wrapper = _method(
        f"{obj.pharo_name} class >> {selector}",
        GENERATED_TAG,
        [
            "FridaObject ensureFridaInitialized.",
            f"^ self fromOwnedHandle: ({_send('self', base + 'Raw', params)})",
        ],
    )
    return prim + "\n" + wrapper


def _emit_property_getter(obj, prop, model) -> Optional[str]:
    mapped = _map_type(prop.type, model)
    if mapped is None:
        return None
    getter_c = f"{_c_prefix(obj)}_{prop.getter}"
    base = to_camel_case(prop.name)
    return _emit_returning_call(obj, base, getter_c, [], mapped,
                                TransferOwnership.none)


def _emit_property_setter(obj, prop, model) -> Optional[str]:
    if prop.setter is None or not prop.writable or prop.construct_only:
        return None
    mapped = _map_type(prop.type, model)
    if mapped is None:
        return None

    setter_c = f"{_c_prefix(obj)}_{prop.setter}"
    base = to_camel_case(prop.name)

    if mapped.kind == "strv":
        # strv setters take a paired (gchar** value, gint length).
        prim = _method(
            f"{obj.pharo_name} >> {base}Raw: value length: length",
            GENERATED_TAG,
            [f"^ self ffiCall: #(void {setter_c} (self, void* value, int length)) library: FridaLibrary"],
        )
        wrapper = _method(
            f"{obj.pharo_name} >> {base}: anArray",
            GENERATED_TAG,
            [
                "| strv |",
                "strv := self strvFromArray: anArray.",
                "self " + base + "Raw: strv length: (anArray ifNil: [ 0 ] ifNotNil: [ :a | a size ]).",
                "FridaGlue strvFree: strv.",
                "^ self",
            ],
        )
        return prim + "\n" + wrapper

    if mapped.kind in ("bytes", "variant", "vardict"):
        prim = _method(
            f"{obj.pharo_name} >> {base}Raw: value",
            GENERATED_TAG,
            [f"^ self ffiCall: #(void {setter_c} (self, void* value)) library: FridaLibrary"],
        )
        if mapped.kind == "bytes":
            build, free = "self bytesFromByteArray: aValue", "FridaGlue bytesUnref: value"
        elif mapped.kind == "variant":
            build, free = "FridaVariant encode: aValue", "FridaGlue variantUnref: value"
        else:
            build, free = "FridaVardict encode: aValue", "FridaGlue vardictUnref: value"
        body = ["| value |",
                f"value := {build}.",
                f"self {base}Raw: value.",
                f"{free}.",
                "^ self"]
        wrapper = _method(f"{obj.pharo_name} >> {base}: aValue", GENERATED_TAG, body)
        return prim + "\n" + wrapper

    if mapped.kind == "object":
        # Marshal nil -> NULL and pass the handle.
        prim = _method(
            f"{obj.pharo_name} >> {base}Raw: aHandle",
            GENERATED_TAG,
            [f"^ self ffiCall: #(void {setter_c} (self, void* aHandle)) library: FridaLibrary"],
        )
        wrapper = _method(
            f"{obj.pharo_name} >> {base}: aValue",
            GENERATED_TAG,
            [
                "self "
                + base
                + "Raw: (aValue isNil ifTrue: [ ExternalAddress null ] ifFalse: [ aValue getHandle ]).",
                "^ self",
            ],
        )
        return prim + "\n" + wrapper

    # Scalar/string/enum: single-value setter (returns self).
    prim = _method(
        f"{obj.pharo_name} >> {base}Raw: aValue",
        GENERATED_TAG,
        [f"^ self ffiCall: #(void {setter_c} (self, {mapped.token} aValue)) library: FridaLibrary"],
    )
    wrapper = _method(
        f"{obj.pharo_name} >> {base}: aValue",
        GENERATED_TAG,
        [f"self {base}Raw: aValue.", "^ self"],
    )
    return prim + "\n" + wrapper


def _emit_method(obj, meth, model) -> Optional[str]:
    if meth.is_async:
        return _emit_async_method(obj, meth, model)

    params = _map_parameters(meth.parameters, model)
    if params is None:
        return None

    ret = meth.return_value.type if meth.return_value is not None else None
    mapped = _map_type(ret, model)
    if mapped is None:
        return None

    transfer = (meth.return_value.transfer_ownership
                if meth.return_value is not None else TransferOwnership.none)
    base = to_camel_case(meth.name)

    return _emit_returning_call(obj, base, meth.c_identifier, params, mapped,
                                transfer, instance=True, throws=meth.throws)


def _emit_async_method(obj, meth, model) -> Optional[str]:
    # The cancellable is passed as NULL, so it is not a Pharo parameter.
    in_params = [p for p in meth.input_parameters
                 if p.type.name != "Gio.Cancellable"]

    params = []
    for p in in_params:
        mapped = _map_type(p.type, model)
        if mapped is None or mapped.kind == "strv":
            return None
        params.append((to_camel_case(p.name), mapped))

    ret = meth.return_value.type if meth.return_value is not None else None
    mapped = _map_type(ret, model)
    if mapped is None:
        return None
    transfer = (meth.return_value.transfer_ownership
                if meth.return_value is not None else TransferOwnership.none)

    prefix = f"{obj.pharo_name} >> "
    base = to_camel_case(meth.name)

    # Reference-typed args are built before _begin and freed after _finish, as in
    # the synchronous emitter; the rest pass straight through (uFFI marshals
    # FFIExternalObject handles and enum values). The result is delivered by the
    # generated _finish prim, called on the VM thread inside FridaMainLoop's
    # dispatch via FridaObject>>asyncCall:finish:.
    prologue, epilogue, begin_params = [], [], []
    marshalled = 0
    for name, m in params:
        if m.kind == "bytes":
            local = f"marshalled{marshalled}"
            marshalled += 1
            prologue.append(f"{local} := self bytesFromByteArray: {name}.")
            epilogue.append(f"FridaGlue bytesUnref: {local}.")
            begin_params.append((local, Mapped("pointer", "void*")))
        elif m.kind == "variant":
            local = f"marshalled{marshalled}"
            marshalled += 1
            prologue.append(f"{local} := FridaVariant encode: {name}.")
            epilogue.append(f"FridaGlue variantUnref: {local}.")
            begin_params.append((local, Mapped("pointer", "void*")))
        elif m.kind == "vardict":
            local = f"marshalled{marshalled}"
            marshalled += 1
            prologue.append(f"{local} := FridaVardict encode: {name}.")
            epilogue.append(f"FridaGlue vardictUnref: {local}.")
            begin_params.append((local, Mapped("pointer", "void*")))
        elif m.kind == "object":
            local = f"marshalled{marshalled}"
            marshalled += 1
            prologue.append(f"{local} := {name} isNil ifTrue: [ ExternalAddress null ] ifFalse: [ {name} getHandle ].")
            begin_params.append((local, Mapped("pointer", "void*")))
        else:
            begin_params.append((name, m))

    trailer = [("cancellable", Mapped("pointer", "void*")),
               ("onReady", Mapped("pointer", "void*")),
               ("userData", Mapped("pointer", "void*"))]
    begin_prim_params = begin_params + trailer
    begin_base = base + "Begin"
    begin_prim = _method(
        f"{prefix}{_selector(begin_base, begin_prim_params)}",
        GENERATED_TAG,
        [f"^ self ffiCall: #(void {meth.c_identifier} "
         f"({_ffi_arg_spec('self', begin_prim_params)})) library: FridaLibrary"],
    )

    ret_token = ("void*" if mapped.kind in ("object", "strv", "bytes", "variant", "vardict")
                 else (mapped.token or "void"))
    finish_base = base + "Finish"
    finish_prim_params = [("asyncResult", Mapped("pointer", "void*")),
                          ("errorHolder", Mapped("pointer", "void*"))]
    finish_prim = _method(
        f"{prefix}{_selector(finish_base, finish_prim_params)}",
        GENERATED_TAG,
        [f"^ self ffiCall: #({ret_token} {meth.finish_c_identifier} "
         f"({_ffi_arg_spec('self', finish_prim_params)})) library: FridaLibrary"],
    )

    begin_send = _async_begin_send(begin_base, begin_prim_params)
    temps = [f"marshalled{i}" for i in range(marshalled)] + ["raw"]
    lines = ["| " + " ".join(temps) + " |"]
    lines += prologue
    lines.append(
        f"raw := self asyncCall: [ :onReady | {begin_send} ] "
        f"finish: [ :asyncResult :errorHolder | self {finish_base}: asyncResult errorHolder: errorHolder ].")
    lines += epilogue
    if mapped.kind == "void":
        lines.append("^ self")
    else:
        lines.append(f"^ {_return_wrap_expr(mapped, transfer, 'raw')}")
    wrapper = _method(f"{prefix}{_selector(base, params)}", GENERATED_TAG, lines)
    return wrapper + "\n" + begin_prim + "\n" + finish_prim


def _emit_signal_method(obj, signal, model) -> Optional[str]:
    # The C handler receives (instance, <signal args>, user_data). Build a typed
    # uFFI callback that decodes each arg and evaluates the user block on the VM
    # thread (during FridaMainLoop's dispatch). Answer a FridaSignalSubscription
    # whose #off disconnects the handler and releases the callback.
    cb_params, decoded = [], []
    for p in signal.parameters:
        mapped = _map_type(p.type, model)
        if mapped is None:
            return None
        name = to_camel_case(p.name)
        if mapped.kind == "object":
            cb_params.append((name, "void*"))
            decoded.append(f"FridaObject wrapBorrowed: {name}")
        elif mapped.kind == "string":
            cb_params.append((name, "String"))
            decoded.append(name)
        elif mapped.kind == "bytes":
            cb_params.append((name, "void*"))
            decoded.append(f"self byteArrayFromBytes: {name} owned: false")
        elif mapped.kind == "variant":
            cb_params.append((name, "void*"))
            decoded.append(f"self valueFromVariant: {name} owned: false")
        elif mapped.kind == "vardict":
            cb_params.append((name, "void*"))
            decoded.append(f"self dictFromVardict: {name} owned: false")
        elif mapped.kind in ("scalar", "enum"):
            cb_params.append((name, mapped.token))
            decoded.append(name)
        else:
            return None

    camel = to_camel_case(signal.c_name)
    selector = "on" + camel[0].upper() + camel[1:] + ": aBlock"
    sig = "void (void* instance"
    for name, token in cb_params:
        sig += f", {token} {name}"
    sig += ", void* userData)"
    block_head = ":instance"
    for name, _ in cb_params:
        block_head += f" :{name}"
    block_head += " :userData"
    args_literal = "{ " + " . ".join(decoded) + " }" if decoded else "{ }"
    body = [
        "| callback |",
        f"callback := FFICallback signature: #({sig}) block: [ {block_head} | aBlock valueWithArguments: {args_literal} ].",
        f"^ self connectSignal: '{signal.name}' callback: callback",
    ]
    return _method(f"{obj.pharo_name} >> {selector}", GENERATED_TAG, body)


def _async_begin_send(begin_base, begin_prim_params) -> str:
    """The _begin send inside the onReady block: the cancellable and user_data
    slots become NULL, onReady becomes the block argument, and the remaining
    args pass through by their marshalled names."""
    values = {"cancellable": "ExternalAddress null",
              "onReady": "onReady",
              "userData": "ExternalAddress null"}
    first_name = begin_prim_params[0][0]
    parts = [f"self {begin_base}: {values.get(first_name, first_name)}"]
    for name, _ in begin_prim_params[1:]:
        parts.append(f"{name}: {values.get(name, name)}")
    return " ".join(parts)


def _return_wrap_expr(mapped, transfer, value_expr: str) -> str:
    """Wrap a raw ffiCall result expression per the return kind."""
    owned = "true" if transfer == TransferOwnership.full else "false"
    if mapped.kind == "object":
        wrap = ("fromOwnedHandle:" if transfer == TransferOwnership.full
                else "fromBorrowedHandle:")
        wrapped = f"{mapped.pharo_class} {wrap} ({value_expr})"
        if mapped.is_list:
            return f"({wrapped}) asArray"
        return wrapped
    if mapped.kind == "strv":
        return f"self arrayFromStrv: ({value_expr}) owned: {owned}"
    if mapped.kind == "bytes":
        return f"self byteArrayFromBytes: ({value_expr}) owned: {owned}"
    if mapped.kind == "variant":
        return f"self valueFromVariant: ({value_expr}) owned: {owned}"
    if mapped.kind == "vardict":
        return f"self dictFromVardict: ({value_expr}) owned: {owned}"
    if mapped.kind == "boolean":
        return f"({value_expr}) ~= 0"
    return value_expr


def _emit_returning_call(obj, base, c_identifier, params, mapped, transfer,
                         instance: bool = True, throws: bool = False) -> str:
    """Emit a synchronous call, marshalling GBytes params, GError (throws) and
    the return value. Uses a single method on the fast path (no param/return
    marshalling), otherwise a raw #ffiCall: primitive plus a wrapping caller."""
    prefix = f"{obj.pharo_name} >> " if instance else f"{obj.pharo_name} class >> "
    self_token = "self" if instance else None

    # Per-parameter marshalling: GBytes/GVariant inputs are built before the
    # call and freed after; everything else passes straight through.
    prologue, epilogue = [], []
    prim_params = []   # (ffi_name, mapped) -> drives prim selector + ffi arg spec
    marshalled_locals = 0
    for name, m in params:
        if m.kind == "bytes":
            local = f"marshalled{marshalled_locals}"
            marshalled_locals += 1
            prologue.append(f"{local} := self bytesFromByteArray: {name}.")
            epilogue.append(f"FridaGlue bytesUnref: {local}.")
            prim_params.append((local, Mapped("pointer", "void*")))
        elif m.kind == "variant":
            local = f"marshalled{marshalled_locals}"
            marshalled_locals += 1
            prologue.append(f"{local} := FridaVariant encode: {name}.")
            epilogue.append(f"FridaGlue variantUnref: {local}.")
            prim_params.append((local, Mapped("pointer", "void*")))
        elif m.kind == "vardict":
            local = f"marshalled{marshalled_locals}"
            marshalled_locals += 1
            prologue.append(f"{local} := FridaVardict encode: {name}.")
            epilogue.append(f"FridaGlue vardictUnref: {local}.")
            prim_params.append((local, Mapped("pointer", "void*")))
        else:
            prim_params.append((name, m))

    # A gchar** return conveys its element count through a trailing
    # `gint * length` out-parameter (GIR `(array length=...)`). It is stripped
    # from the user-facing parameter list, but the C ABI still mandates the
    # pointer: omitting it leaves the callee writing the count through an
    # uninitialised argument slot, corrupting memory. Pass a throwaway holder;
    # #arrayFromStrv: recovers the count by NUL-scanning the strv instead.
    strv_length_holder = mapped.kind == "strv"
    if strv_length_holder:
        prologue.append("lengthHolder := ExternalAddress allocate: 4.")
        epilogue.append("lengthHolder free.")
        prim_params.append(("lengthHolder", Mapped("pointer", "void*")))

    result_needs_wrap = mapped.kind in ("object", "strv", "bytes", "variant", "vardict", "boolean")
    needs_wrapper = throws or result_needs_wrap or marshalled_locals > 0

    if throws:
        prim_params.append(("errorHolder", Mapped("pointer", "void*")))

    ret_token = "void*" if mapped.kind in ("object", "strv", "bytes", "variant", "vardict") else (mapped.token or "void")
    arg_spec = _ffi_arg_spec(self_token, prim_params)

    if not needs_wrapper:
        return _method(
            f"{prefix}{_selector(base, params)}",
            GENERATED_TAG,
            [f"^ self ffiCall: #({ret_token} {c_identifier} ({arg_spec})) library: FridaLibrary"],
        )

    raw_base = base + "Raw"
    prim = _method(
        f"{prefix}{_selector(raw_base, prim_params)}",
        GENERATED_TAG,
        [f"^ self ffiCall: #({ret_token} {c_identifier} ({arg_spec})) library: FridaLibrary"],
    )

    temps = [f"marshalled{i}" for i in range(marshalled_locals)]
    if strv_length_holder:
        temps.append("lengthHolder")
    if throws:
        temps.append("errorHolder")
    temps.append("result")
    lines = ["| " + " ".join(temps) + " |"]
    lines += prologue
    if throws:
        lines.append("errorHolder := self newErrorHolder.")
    lines.append(f"result := {_send('self', raw_base, prim_params)}.")
    lines += epilogue
    if throws:
        lines.append("self checkError: errorHolder.")
    if mapped.kind == "void":
        lines.append("^ self")
    else:
        lines.append(f"^ {_return_wrap_expr(mapped, transfer, 'result')}")
    wrapper = _method(f"{prefix}{_selector(base, params)}", GENERATED_TAG, lines)
    return prim + "\n" + wrapper


def _send(receiver, selector_base, params) -> str:
    if not params:
        return f"{receiver} {selector_base}"
    parts = [f"{selector_base}: {params[0][0]}"]
    for name, _ in params[1:]:
        parts.append(f"{name}: {name}")
    return f"{receiver} " + " ".join(parts)


def _map_parameters(parameters, model):
    """Return [(pharo_name, Mapped)] or None if any parameter is unsupported."""
    result = []
    for p in parameters:
        if p.direction.value != "in":
            return None
        mapped = _map_type(p.type, model)
        if mapped is None:
            return None
        # GBytes inputs are marshalled (ByteArray -> GBytes) in the sync emitter;
        # strv inputs (gchar** + length param) are still a follow-up.
        if mapped.kind == "strv":
            return None
        result.append((to_camel_case(p.name), mapped))
    return result


def _selector(base, params) -> str:
    if not params:
        return base
    parts = [f"{base}: {params[0][0]}"]
    for name, _ in params[1:]:
        parts.append(f"{name}: {name}")
    return " ".join(parts)


def _ffi_arg_spec(self_token, params) -> str:
    tokens = []
    if self_token is not None:
        tokens.append(self_token)
    for name, mapped in params:
        tokens.append(f"{mapped.token} {name}")
    return ", ".join(tokens)


def _class_file(
    name: str,
    superclass: str,
    comment: str,
    body_sections: List[str],
    shared_variables: List[str] | None = None,
) -> str:
    lines = []
    if comment:
        lines.append('"')
        lines.append(comment)
        lines.append('"')
    lines.append("Class {")
    lines.append(f"\t#name : '{name}',")
    lines.append(f"\t#superclass : '{superclass}',")
    if shared_variables:
        shared = ", ".join(f"'{v}'" for v in shared_variables)
        lines.append(f"\t#classVars : [ {shared} ],")
    lines.append(f"\t#category : '{PACKAGE}',")
    lines.append(f"\t#package : '{PACKAGE}'")
    lines.append("}")
    lines.append("")
    for section in body_sections:
        lines.append(section)
    return "\n".join(lines) + "\n"


def _method(signature: str, category: str, body_lines: List[str]) -> str:
    lines = [f"{{ #category : '{category}' }}", f"{signature} ["]
    for bl in body_lines:
        lines.append(f"\t{bl}")
    lines.append("]")
    lines.append("")
    return "\n".join(lines)
