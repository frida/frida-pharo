"
The frida-core library bound to a dedicated worker thread. Same shared object as
FridaLibrary, but calls issued through it run on a private TFWorker instead of
the Pharo VM thread. FridaMainLoop uses it for the one long-lived, blocking
g_poll: the poll parks on the worker while the VM thread stays live to schedule
other Pharo processes. A dedicated worker (not TFWorker default) keeps that
permanent block from starving unrelated threaded FFI calls.
"
Class {
	#name : 'FridaMainLoopWorkerLibrary',
	#superclass : 'FridaLibrary',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'accessing' }
FridaMainLoopWorkerLibrary >> runner [
	^ TFWorker named: 'frida-main-loop'
]
