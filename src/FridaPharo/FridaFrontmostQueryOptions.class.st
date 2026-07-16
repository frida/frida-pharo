"
GENERATED binding for the Frida FridaFrontmostQueryOptions GObject.
"
Class {
	#name : 'FridaFrontmostQueryOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaFrontmostQueryOptions class >> newRaw [
	^ self ffiCall: #(void* frida_frontmost_query_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaFrontmostQueryOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaFrontmostQueryOptions >> scope [
	^ self ffiCall: #(FridaScope frida_frontmost_query_options_get_scope (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaFrontmostQueryOptions >> scopeRaw: aValue [
	^ self ffiCall: #(void frida_frontmost_query_options_set_scope (self, FridaScope aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaFrontmostQueryOptions >> scope: aValue [
	self scopeRaw: aValue.
	^ self
]

