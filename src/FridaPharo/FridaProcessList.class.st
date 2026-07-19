"
GENERATED binding for the Frida FridaProcessList GObject.
"
Class {
	#name : 'FridaProcessList',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaProcessList >> size [
	^ self ffiCall: #(int frida_process_list_size (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessList >> getRaw: index [
	^ self ffiCall: #(void* frida_process_list_get (self, int index)) library: FridaLibrary
]

{ #category : 'generated' }
FridaProcessList >> get: index [
	| result |
	result := self getRaw: index.
	^ FridaProcess fromHandle: (result) owned: true
]

{ #category : 'generated' }
FridaProcessList >> at: anIndex [
	^ self get: anIndex - 1
]

{ #category : 'generated' }
FridaProcessList >> do: aBlock [
	0 to: self size - 1 do: [ :i | aBlock value: (self get: i) ]
]

{ #category : 'generated' }
FridaProcessList >> collect: aBlock [
	^ self asArray collect: aBlock
]

{ #category : 'generated' }
FridaProcessList >> asArray [
	| result |
	result := Array new: self size.
	1 to: self size do: [ :i | result at: i put: (self get: i - 1) ].
	^ result
]

{ #category : 'generated' }
FridaProcessList >> isEmpty [
	^ self size = 0
]

{ #category : 'generated' }
FridaProcessList >> isCollection [
	^ true
]

