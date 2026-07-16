"
GENERATED binding for the Frida FridaChild GObject.
"
Class {
	#name : 'FridaChild',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaChild >> pid [
	^ self ffiCall: #(uint frida_child_get_pid (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild >> parentPid [
	^ self ffiCall: #(uint frida_child_get_parent_pid (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild >> origin [
	^ self ffiCall: #(FridaChildOrigin frida_child_get_origin (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild >> identifier [
	^ self ffiCall: #(String frida_child_get_identifier (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild >> path [
	^ self ffiCall: #(String frida_child_get_path (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild >> argvRaw: lengthHolder [
	^ self ffiCall: #(void* frida_child_get_argv (self, void* lengthHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild >> argv [
	| lengthHolder result |
	lengthHolder := ExternalAddress allocate: 4.
	result := self argvRaw: lengthHolder.
	lengthHolder free.
	^ self arrayFromStrv: (result) owned: false
]

{ #category : 'generated' }
FridaChild >> envpRaw: lengthHolder [
	^ self ffiCall: #(void* frida_child_get_envp (self, void* lengthHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChild >> envp [
	| lengthHolder result |
	lengthHolder := ExternalAddress allocate: 4.
	result := self envpRaw: lengthHolder.
	lengthHolder free.
	^ self arrayFromStrv: (result) owned: false
]

{ #category : 'generated' }
FridaChild >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	[ aStream nextPutAll: ' identifier='; print: (self identifier) ] on: Error do: [ :e | aStream nextPutAll: 'identifier=?' ].
	aStream nextPutAll: ')'
]

