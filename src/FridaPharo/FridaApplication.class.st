"
GENERATED plain value snapshot of the Frida FridaApplication.
"
Class {
	#name : 'FridaApplication',
	#superclass : 'Object',
	#instVars : [ 'identifier', 'name', 'pid', 'parameters' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaApplication >> identifier [
	^ identifier
]

{ #category : 'generated' }
FridaApplication >> setIdentifier: aValue [
	identifier := aValue
]

{ #category : 'generated' }
FridaApplication >> name [
	^ name
]

{ #category : 'generated' }
FridaApplication >> setName: aValue [
	name := aValue
]

{ #category : 'generated' }
FridaApplication >> pid [
	^ pid
]

{ #category : 'generated' }
FridaApplication >> setPid: aValue [
	pid := aValue
]

{ #category : 'generated' }
FridaApplication >> parameters [
	^ parameters
]

{ #category : 'generated' }
FridaApplication >> setParameters: aValue [
	parameters := aValue
]

{ #category : 'generated' }
FridaApplication class >> readIdentifier: aHandle [
	^ self ffiCall: #(String frida_application_get_identifier (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplication class >> readName: aHandle [
	^ self ffiCall: #(String frida_application_get_name (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplication class >> readPid: aHandle [
	^ self ffiCall: #(uint frida_application_get_pid (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplication class >> readParametersRaw: aHandle [
	^ self ffiCall: #(void* frida_application_get_parameters (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplication class >> readParameters: aHandle [
	| result |
	result := self readParametersRaw: aHandle.
	^ FridaObject dictFromVardict: (result) owned: false
]

{ #category : 'generated' }
FridaApplication class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setIdentifier: (self readIdentifier: aHandle).
	instance setName: (self readName: aHandle).
	instance setPid: (self readPid: aHandle).
	instance setParameters: (self readParameters: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaApplication class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
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

{ #category : 'accessing' }
FridaApplication >> icons [
	^ (self parameters at: 'icons' ifAbsent: [ #() ]) collect: [ :each | FridaIcon fromDictionary: each ]
]

{ #category : 'inspecting' }
FridaApplication >> gtIconFor: aView [
	<gtView>
	| icon |
	icon := self icons detectMax: [ :each | each width ].
	icon ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Icon';
		priority: 15;
		stencil: [ icon asForm asElement ]
]

