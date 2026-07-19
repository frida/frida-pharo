"
GENERATED plain value snapshot of the Frida FridaCrash.
"
Class {
	#name : 'FridaCrash',
	#superclass : 'Object',
	#instVars : [ 'pid', 'processName', 'summary', 'report', 'parameters' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaCrash >> pid [
	^ pid
]

{ #category : 'generated' }
FridaCrash >> setPid: aValue [
	pid := aValue
]

{ #category : 'generated' }
FridaCrash >> processName [
	^ processName
]

{ #category : 'generated' }
FridaCrash >> setProcessName: aValue [
	processName := aValue
]

{ #category : 'generated' }
FridaCrash >> summary [
	^ summary
]

{ #category : 'generated' }
FridaCrash >> setSummary: aValue [
	summary := aValue
]

{ #category : 'generated' }
FridaCrash >> report [
	^ report
]

{ #category : 'generated' }
FridaCrash >> setReport: aValue [
	report := aValue
]

{ #category : 'generated' }
FridaCrash >> parameters [
	^ parameters
]

{ #category : 'generated' }
FridaCrash >> setParameters: aValue [
	parameters := aValue
]

{ #category : 'generated' }
FridaCrash class >> readPid: aHandle [
	^ self ffiCall: #(uint frida_crash_get_pid (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash class >> readProcessName: aHandle [
	^ self ffiCall: #(String frida_crash_get_process_name (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash class >> readSummary: aHandle [
	^ self ffiCall: #(String frida_crash_get_summary (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash class >> readReport: aHandle [
	^ self ffiCall: #(String frida_crash_get_report (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash class >> readParametersRaw: aHandle [
	^ self ffiCall: #(void* frida_crash_get_parameters (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash class >> readParameters: aHandle [
	| result |
	result := self readParametersRaw: aHandle.
	^ FridaObject dictFromVardict: (result) owned: false
]

{ #category : 'generated' }
FridaCrash class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setPid: (self readPid: aHandle).
	instance setProcessName: (self readProcessName: aHandle).
	instance setSummary: (self readSummary: aHandle).
	instance setReport: (self readReport: aHandle).
	instance setParameters: (self readParameters: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaCrash class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
]

{ #category : 'generated' }
FridaCrash >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	[ aStream nextPutAll: ' processName='; print: (self processName) ] on: Error do: [ :e | aStream nextPutAll: 'processName=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'generated' }
FridaCrash class >> identityProperties [
	^ #(pid processName)
]

