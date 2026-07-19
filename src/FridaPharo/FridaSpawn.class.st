"
GENERATED binding for the Frida FridaSpawn GObject.
"
Class {
	#name : 'FridaSpawn',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSpawn >> pid [
	^ self ffiCall: #(uint frida_spawn_get_pid (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawn >> identifier [
	^ self ffiCall: #(String frida_spawn_get_identifier (self)) library: FridaLibrary
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

