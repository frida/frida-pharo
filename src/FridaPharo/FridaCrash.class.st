"
GENERATED binding for the Frida FridaCrash GObject.
"
Class {
	#name : 'FridaCrash',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaCrash >> pid [
	^ self ffiCall: #(uint frida_crash_get_pid (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash >> processName [
	^ self ffiCall: #(String frida_crash_get_process_name (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash >> summary [
	^ self ffiCall: #(String frida_crash_get_summary (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash >> report [
	^ self ffiCall: #(String frida_crash_get_report (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash >> parametersRaw [
	^ self ffiCall: #(void* frida_crash_get_parameters (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCrash >> parameters [
	| result |
	result := self parametersRaw.
	^ self dictFromVardict: (result) owned: false
]

{ #category : 'generated' }
FridaCrash >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	[ aStream nextPutAll: ' processName='; print: (self processName) ] on: Error do: [ :e | aStream nextPutAll: 'processName=?' ].
	aStream nextPutAll: ')'
]

