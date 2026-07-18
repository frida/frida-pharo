"
Drives Frida's GLib main context from Pharo, so no C glue is needed to marry
Frida's event loop to the single-threaded Pharo VM.

Frida is initialised with the GLib runtime (see FridaObject), which means it
runs no background thread of its own and schedules everything on the calling
thread's thread-default GMainContext (frida_get_main_context returns
g_main_context_get_thread_default under the GLib runtime). So this class creates
a dedicated context and pushes it as the thread-default of the Pharo VM thread;
a single FridaMainLoop process then owns that context and repeats:

  prepare / query   -- on the VM thread: what to wait for
  g_poll            -- on a dedicated worker thread: block until ready
  check / dispatch  -- on the VM thread: run the ready sources

Because dispatch runs on the VM thread, every source callback -- async
completions (GAsyncReadyCallback) and signal closures (g_signal_connect) alike
-- runs where Smalltalk is safe to execute. The blocking wait is GLib's own
g_poll (FridaMainLoopWorkerLibrary), which hides all platform detail (plain poll
on Linux, kqueue on Darwin); the GPollFD buffer is passed straight through
query -> g_poll -> check as an opaque blob, so GLib internals never leak here.
"
Class {
	#name : 'FridaMainLoop',
	#superclass : 'Object',
	#instVars : [ 'context', 'running' ],
	#classVars : [ 'Default' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'accessing' }
FridaMainLoop class >> default [
	^ Default ifNil: [ Default := self new start ]
]

{ #category : 'accessing' }
FridaMainLoop class >> reset [
	Default ifNotNil: [ :loop | loop stop ].
	Default := nil
]

{ #category : 'running' }
FridaMainLoop >> start [
	context := self primNewContext.
	self primPushThreadDefault: context.
	running := true.
	[ self runLoop ] fork.
	^ self
]

{ #category : 'running' }
FridaMainLoop >> stop [
	running := false.
	self primWakeup: context
]

{ #category : 'running' }
FridaMainLoop >> wakeup [
	"Break the loop out of g_poll. Frida attaches its sources on the VM thread,
	 which owns the context, so GLib elides the wakeup it would send to a foreign
	 owner; the poll runs on the worker thread and would otherwise sleep until
	 unrelated fd traffic arrives. Callers about to wait for a freshly scheduled
	 operation wake the loop so it re-polls and picks the new source up."
	self primWakeup: context
]

{ #category : 'running' }
FridaMainLoop >> runLoop [
	| priorityHolder timeoutHolder fds |
	priorityHolder := ExternalAddress allocate: 4.
	timeoutHolder := ExternalAddress allocate: 4.
	fds := ExternalAddress allocate: 8192.
	[ running ] whileTrue: [ | maxPriority fdCount |
		self primPrepare: context priority: priorityHolder.
		maxPriority := priorityHolder signedLongAt: 1.
		fdCount := self primQuery: context max: maxPriority timeout: timeoutHolder fds: fds count: 200.
		self primPoll: fds count: fdCount timeout: (timeoutHolder signedLongAt: 1).
		self primCheck: context max: maxPriority fds: fds count: fdCount.
		self primDispatch: context ].
	priorityHolder free.
	timeoutHolder free.
	fds free.
	self primPopThreadDefault: context.
	self primUnref: context
]

{ #category : 'primitives' }
FridaMainLoop >> primNewContext [
	^ self ffiCall: #(void* g_main_context_new()) library: FridaLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primPushThreadDefault: aContext [
	"Also acquires the context for this (the Pharo VM) thread."
	^ self ffiCall: #(void g_main_context_push_thread_default (void* aContext)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primWakeup: aContext [
	^ self ffiCall: #(void g_main_context_wakeup (void* aContext)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primPrepare: aContext priority: aPriorityHolder [
	^ self ffiCall: #(bool g_main_context_prepare (void* aContext, int* aPriorityHolder)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primQuery: aContext max: maxPriority timeout: aTimeoutHolder fds: fds count: fdCount [
	^ self ffiCall: #(int g_main_context_query (void* aContext, int maxPriority, int* aTimeoutHolder, void* fds, int fdCount)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primPoll: fds count: fdCount timeout: aTimeout [
	"GLib's own g_poll, on the dedicated worker so the VM thread stays live."
	^ self ffiCall: #(int g_poll (void* fds, uint fdCount, int aTimeout)) library: FridaMainLoopWorkerLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primCheck: aContext max: maxPriority fds: fds count: fdCount [
	^ self ffiCall: #(bool g_main_context_check (void* aContext, int maxPriority, void* fds, int fdCount)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primDispatch: aContext [
	^ self ffiCall: #(void g_main_context_dispatch (void* aContext)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primPopThreadDefault: aContext [
	^ self ffiCall: #(void g_main_context_pop_thread_default (void* aContext)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaMainLoop >> primUnref: aContext [
	^ self ffiCall: #(void g_main_context_unref (void* aContext)) library: FridaLibrary
]
