"
GENERATED binding for the Frida FridaApplication GObject.
"
Class {
	#name : 'FridaApplication',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaApplication >> identifier [
	^ self ffiCall: #(String frida_application_get_identifier (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplication >> name [
	^ self ffiCall: #(String frida_application_get_name (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplication >> pid [
	^ self ffiCall: #(uint frida_application_get_pid (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplication >> parametersRaw [
	^ self ffiCall: #(void* frida_application_get_parameters (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplication >> parameters [
	| result |
	result := self parametersRaw.
	^ self dictFromVardict: (result) owned: false
]

{ #category : 'generated' }
FridaApplication >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'identifier='; print: (self identifier) ] on: Error do: [ :e | aStream nextPutAll: 'identifier=?' ].
	[ aStream nextPutAll: ' pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'generated' }
FridaApplication class >> identityProperties [
	^ #(identifier pid)
]

