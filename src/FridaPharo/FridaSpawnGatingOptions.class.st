"
GENERATED binding for the Frida FridaSpawnGatingOptions GObject.
"
Class {
	#name : 'FridaSpawnGatingOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSpawnGatingOptions class >> newRaw [
	^ self ffiCall: #(void* frida_spawn_gating_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnGatingOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaSpawnGatingOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

{ #category : 'generated' }
FridaSpawnGatingOptions >> scope [
	^ self ffiCall: #(FridaSpawnGatingScope frida_spawn_gating_options_get_scope (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnGatingOptions >> scopeRaw: aValue [
	^ self ffiCall: #(void frida_spawn_gating_options_set_scope (self, FridaSpawnGatingScope aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnGatingOptions >> scope: aValue [
	self scopeRaw: (FridaSpawnGatingScope fromSymbol: aValue).
	^ self
]

