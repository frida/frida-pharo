"
GENERATED binding for the Frida FridaProcess GObject.
"
Class {
	#name : 'FridaProcess',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaProcess >> pid [
	^ self ffiCall: #(uint frida_process_get_pid (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcess >> name [
	^ self ffiCall: #(String frida_process_get_name (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcess >> parametersRaw [
	^ self ffiCall: #(void* frida_process_get_parameters (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcess >> parameters [
	| result |
	result := self parametersRaw.
	^ self dictFromVardict: (result) owned: false
]

{ #category : 'generated' }
FridaProcess >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	[ aStream nextPutAll: ' name='; print: (self name) ] on: Error do: [ :e | aStream nextPutAll: 'name=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'generated' }
FridaProcess class >> identityProperties [
	^ #(pid name)
]

