"
GENERATED binding for the Frida FridaWatchOptions GObject.
"
Class {
	#name : 'FridaWatchOptions',
	#superclass : 'FridaCompilerOptions',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaWatchOptions class >> newRaw [
	^ self ffiCall: #(void* frida_watch_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaWatchOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaWatchOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

