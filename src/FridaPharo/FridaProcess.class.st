"
GENERATED plain value snapshot of the Frida FridaProcess.
"
Class {
	#name : 'FridaProcess',
	#superclass : 'Object',
	#instVars : [ 'pid', 'name', 'parameters' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaProcess >> pid [
	^ pid
]

{ #category : 'generated' }
FridaProcess >> setPid: aValue [
	pid := aValue
]

{ #category : 'generated' }
FridaProcess >> name [
	^ name
]

{ #category : 'generated' }
FridaProcess >> setName: aValue [
	name := aValue
]

{ #category : 'generated' }
FridaProcess >> parameters [
	^ parameters
]

{ #category : 'generated' }
FridaProcess >> setParameters: aValue [
	parameters := aValue
]

{ #category : 'generated' }
FridaProcess class >> readPid: aHandle [
	^ self ffiCall: #(uint frida_process_get_pid (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcess class >> readName: aHandle [
	^ self ffiCall: #(String frida_process_get_name (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcess class >> readParametersRaw: aHandle [
	^ self ffiCall: #(void* frida_process_get_parameters (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcess class >> readParameters: aHandle [
	| result |
	result := self readParametersRaw: aHandle.
	^ FridaObject dictFromVardict: (result) owned: false
]

{ #category : 'generated' }
FridaProcess class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setPid: (self readPid: aHandle).
	instance setName: (self readName: aHandle).
	instance setParameters: (self readParameters: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaProcess class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
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

{ #category : 'accessing' }
FridaProcess >> icons [
	^ (self parameters at: 'icons' ifAbsent: [ #() ]) collect: [ :each | FridaIcon fromDictionary: each ]
]

{ #category : 'inspecting' }
FridaProcess >> gtIconFor: aView [
	<gtView>
	| icon |
	icon := self icons detectMax: [ :each | each width ].
	icon ifNil: [ ^ aView empty ].
	^ aView explicit
		title: 'Icon';
		priority: 15;
		stencil: [ icon asForm asElement ]
]

