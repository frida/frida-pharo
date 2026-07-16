"
GENERATED binding for the Frida FridaApplicationQueryOptions GObject.
"
Class {
	#name : 'FridaApplicationQueryOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaApplicationQueryOptions class >> newRaw [
	^ self ffiCall: #(void* frida_application_query_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplicationQueryOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaApplicationQueryOptions >> scope [
	^ self ffiCall: #(FridaScope frida_application_query_options_get_scope (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplicationQueryOptions >> scopeRaw: aValue [
	^ self ffiCall: #(void frida_application_query_options_set_scope (self, FridaScope aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplicationQueryOptions >> scope: aValue [
	self scopeRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaApplicationQueryOptions >> selectIdentifier: identifier [
	^ self ffiCall: #(void frida_application_query_options_select_identifier (self, String identifier)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplicationQueryOptions >> hasSelectedIdentifiers [
	^ self ffiCall: #(bool frida_application_query_options_has_selected_identifiers (self)) library: FridaLibrary
]

