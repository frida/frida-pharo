"
GENERATED binding for the Frida FridaBuildOptions GObject.
"
Class {
	#name : 'FridaBuildOptions',
	#superclass : 'FridaCompilerOptions',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaBuildOptions class >> newRaw [
	^ self ffiCall: #(void* frida_build_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaBuildOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

