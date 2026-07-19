"
GENERATED plain value snapshot of the Frida FridaChild.
"
Class {
	#name : 'FridaChild',
	#superclass : 'Object',
	#instVars : [ 'pid', 'parentPid', 'origin', 'identifier', 'path', 'argv', 'envp' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaChild >> pid [
	^ pid
]

{ #category : 'generated' }
FridaChild >> setPid: aValue [
	pid := aValue
]

{ #category : 'generated' }
FridaChild >> parentPid [
	^ parentPid
]

{ #category : 'generated' }
FridaChild >> setParentPid: aValue [
	parentPid := aValue
]

{ #category : 'generated' }
FridaChild >> origin [
	^ origin
]

{ #category : 'generated' }
FridaChild >> setOrigin: aValue [
	origin := aValue
]

{ #category : 'generated' }
FridaChild >> identifier [
	^ identifier
]

{ #category : 'generated' }
FridaChild >> setIdentifier: aValue [
	identifier := aValue
]

{ #category : 'generated' }
FridaChild >> path [
	^ path
]

{ #category : 'generated' }
FridaChild >> setPath: aValue [
	path := aValue
]

{ #category : 'generated' }
FridaChild >> argv [
	^ argv
]

{ #category : 'generated' }
FridaChild >> setArgv: aValue [
	argv := aValue
]

{ #category : 'generated' }
FridaChild >> envp [
	^ envp
]

{ #category : 'generated' }
FridaChild >> setEnvp: aValue [
	envp := aValue
]

{ #category : 'generated' }
FridaChild class >> readPid: aHandle [
	^ self ffiCall: #(uint frida_child_get_pid (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild class >> readParentPid: aHandle [
	^ self ffiCall: #(uint frida_child_get_parent_pid (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild class >> readOrigin: aHandle [
	^ self ffiCall: #(FridaChildOrigin frida_child_get_origin (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild class >> readIdentifier: aHandle [
	^ self ffiCall: #(String frida_child_get_identifier (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild class >> readPath: aHandle [
	^ self ffiCall: #(String frida_child_get_path (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild class >> readArgvRaw: aHandle lengthHolder: lengthHolder [
	^ self ffiCall: #(void* frida_child_get_argv (void* aHandle, void* lengthHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild class >> readArgv: aHandle [
	| lengthHolder result |
	lengthHolder := ExternalAddress allocate: 4.
	result := self readArgvRaw: aHandle lengthHolder: lengthHolder.
	lengthHolder free.
	^ FridaObject arrayFromStrv: (result) owned: false
]

{ #category : 'generated' }
FridaChild class >> readEnvpRaw: aHandle lengthHolder: lengthHolder [
	^ self ffiCall: #(void* frida_child_get_envp (void* aHandle, void* lengthHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild class >> readEnvp: aHandle [
	| lengthHolder result |
	lengthHolder := ExternalAddress allocate: 4.
	result := self readEnvpRaw: aHandle lengthHolder: lengthHolder.
	lengthHolder free.
	^ FridaObject arrayFromStrv: (result) owned: false
]

{ #category : 'generated' }
FridaChild class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setPid: (self readPid: aHandle).
	instance setParentPid: (self readParentPid: aHandle).
	instance setOrigin: (self readOrigin: aHandle).
	instance setIdentifier: (self readIdentifier: aHandle).
	instance setPath: (self readPath: aHandle).
	instance setArgv: (self readArgv: aHandle).
	instance setEnvp: (self readEnvp: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaChild class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
]

{ #category : 'generated' }
FridaChild >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	[ aStream nextPutAll: ' identifier='; print: (self identifier) ] on: Error do: [ :e | aStream nextPutAll: 'identifier=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'generated' }
FridaChild class >> identityProperties [
	^ #(pid identifier)
]

