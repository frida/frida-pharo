"
GENERATED binding for the Frida FridaSpawnOptions GObject.
"
Class {
	#name : 'FridaSpawnOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSpawnOptions class >> newRaw [
	^ self ffiCall: #(void* frida_spawn_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaSpawnOptions >> argvRaw: lengthHolder [
	^ self ffiCall: #(void* frida_spawn_options_get_argv (self, void* lengthHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> argv [
	| lengthHolder result |
	lengthHolder := ExternalAddress allocate: 4.
	result := self argvRaw: lengthHolder.
	lengthHolder free.
	^ self arrayFromStrv: (result) owned: false
]

{ #category : 'generated' }
FridaSpawnOptions >> envpRaw: lengthHolder [
	^ self ffiCall: #(void* frida_spawn_options_get_envp (self, void* lengthHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> envp [
	| lengthHolder result |
	lengthHolder := ExternalAddress allocate: 4.
	result := self envpRaw: lengthHolder.
	lengthHolder free.
	^ self arrayFromStrv: (result) owned: false
]

{ #category : 'generated' }
FridaSpawnOptions >> envRaw: lengthHolder [
	^ self ffiCall: #(void* frida_spawn_options_get_env (self, void* lengthHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> env [
	| lengthHolder result |
	lengthHolder := ExternalAddress allocate: 4.
	result := self envRaw: lengthHolder.
	lengthHolder free.
	^ self arrayFromStrv: (result) owned: false
]

{ #category : 'generated' }
FridaSpawnOptions >> cwd [
	^ self ffiCall: #(String frida_spawn_options_get_cwd (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> stdio [
	^ self ffiCall: #(FridaStdio frida_spawn_options_get_stdio (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> auxRaw [
	^ self ffiCall: #(void* frida_spawn_options_get_aux (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> aux [
	| result |
	result := self auxRaw.
	^ self dictFromVardict: (result) owned: false
]

{ #category : 'generated' }
FridaSpawnOptions >> argvRaw: value length: length [
	^ self ffiCall: #(void frida_spawn_options_set_argv (self, void* value, int length)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> argv: anArray [
	| strv |
	strv := self strvFromArray: anArray.
	self argvRaw: strv length: (anArray ifNil: [ 0 ] ifNotNil: [ :a | a size ]).
	FridaGlue strvFree: strv.
	^ self
]

{ #category : 'generated' }
FridaSpawnOptions >> envpRaw: value length: length [
	^ self ffiCall: #(void frida_spawn_options_set_envp (self, void* value, int length)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> envp: anArray [
	| strv |
	strv := self strvFromArray: anArray.
	self envpRaw: strv length: (anArray ifNil: [ 0 ] ifNotNil: [ :a | a size ]).
	FridaGlue strvFree: strv.
	^ self
]

{ #category : 'generated' }
FridaSpawnOptions >> envRaw: value length: length [
	^ self ffiCall: #(void frida_spawn_options_set_env (self, void* value, int length)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> env: anArray [
	| strv |
	strv := self strvFromArray: anArray.
	self envRaw: strv length: (anArray ifNil: [ 0 ] ifNotNil: [ :a | a size ]).
	FridaGlue strvFree: strv.
	^ self
]

{ #category : 'generated' }
FridaSpawnOptions >> cwdRaw: aValue [
	^ self ffiCall: #(void frida_spawn_options_set_cwd (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> cwd: aValue [
	self cwdRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSpawnOptions >> stdioRaw: aValue [
	^ self ffiCall: #(void frida_spawn_options_set_stdio (self, FridaStdio aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> stdio: aValue [
	self stdioRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSpawnOptions >> auxRaw: value [
	^ self ffiCall: #(void frida_spawn_options_set_aux (self, void* value)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnOptions >> aux: aValue [
	| value |
	value := FridaVardict encode: aValue.
	self auxRaw: value.
	FridaGlue vardictUnref: value.
	^ self
]

