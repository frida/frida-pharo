"
GENERATED binding for the Frida FridaProcessMatchOptions GObject.
"
Class {
	#name : 'FridaProcessMatchOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaProcessMatchOptions class >> newRaw [
	^ self ffiCall: #(void* frida_process_match_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessMatchOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaProcessMatchOptions >> timeout [
	^ self ffiCall: #(int frida_process_match_options_get_timeout (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessMatchOptions >> scope [
	^ self ffiCall: #(FridaScope frida_process_match_options_get_scope (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessMatchOptions >> timeoutRaw: aValue [
	^ self ffiCall: #(void frida_process_match_options_set_timeout (self, int aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessMatchOptions >> timeout: aValue [
	self timeoutRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaProcessMatchOptions >> scopeRaw: aValue [
	^ self ffiCall: #(void frida_process_match_options_set_scope (self, FridaScope aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessMatchOptions >> scope: aValue [
	self scopeRaw: aValue.
	^ self
]

