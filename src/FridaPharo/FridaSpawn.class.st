"
GENERATED plain value snapshot of the Frida FridaSpawn.
"
Class {
	#name : 'FridaSpawn',
	#superclass : 'Object',
	#instVars : [ 'pid', 'identifier' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSpawn >> pid [
	^ pid
]

{ #category : 'generated' }
FridaSpawn >> setPid: aValue [
	pid := aValue
]

{ #category : 'generated' }
FridaSpawn >> identifier [
	^ identifier
]

{ #category : 'generated' }
FridaSpawn >> setIdentifier: aValue [
	identifier := aValue
]

{ #category : 'generated' }
FridaSpawn class >> readPid: aHandle [
	^ self ffiCall: #(uint frida_spawn_get_pid (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawn class >> readIdentifier: aHandle [
	^ self ffiCall: #(String frida_spawn_get_identifier (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawn class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setPid: (self readPid: aHandle).
	instance setIdentifier: (self readIdentifier: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaSpawn class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
]

{ #category : 'generated' }
FridaSpawn >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	[ aStream nextPutAll: ' identifier='; print: (self identifier) ] on: Error do: [ :e | aStream nextPutAll: 'identifier=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'generated' }
FridaSpawn class >> identityProperties [
	^ #(pid identifier)
]

