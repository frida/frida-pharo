"
Hand-written wrapper for a GCancellable, passed to any async Frida call to
cancel it. Create one with #new, hand it to a call via its trailing
#cancellable: argument, and #cancel it from another process to abort the
operation (the pending call then raises a FridaError).
"
Class {
	#name : 'FridaCancellable',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'instance creation' }
FridaCancellable class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: self primNew
]

{ #category : 'primitives' }
FridaCancellable class >> primNew [
	^ self ffiCall: #(void* g_cancellable_new ()) library: FridaLibrary
]

{ #category : 'operations' }
FridaCancellable >> cancel [
	^ self ffiCall: #(void g_cancellable_cancel (self)) library: FridaLibrary
]

{ #category : 'testing' }
FridaCancellable >> isCancelled [
	^ self ffiCall: #(bool g_cancellable_is_cancelled (self)) library: FridaLibrary
]

{ #category : 'operations' }
FridaCancellable >> reset [
	^ self ffiCall: #(void g_cancellable_reset (self)) library: FridaLibrary
]
