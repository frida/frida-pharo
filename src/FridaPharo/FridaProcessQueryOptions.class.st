"
GENERATED binding for the Frida FridaProcessQueryOptions GObject.
"
Class {
	#name : 'FridaProcessQueryOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaProcessQueryOptions class >> newRaw [
	^ self ffiCall: #(void* frida_process_query_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessQueryOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaProcessQueryOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

{ #category : 'generated' }
FridaProcessQueryOptions >> scope [
	^ self ffiCall: #(FridaScope frida_process_query_options_get_scope (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessQueryOptions >> scopeRaw: aValue [
	^ self ffiCall: #(void frida_process_query_options_set_scope (self, FridaScope aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessQueryOptions >> scope: aValue [
	self scopeRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaProcessQueryOptions >> selectPid: pid [
	^ self ffiCall: #(void frida_process_query_options_select_pid (self, uint pid)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessQueryOptions >> hasSelectedPids [
	^ self ffiCall: #(bool frida_process_query_options_has_selected_pids (self)) library: FridaLibrary
]

