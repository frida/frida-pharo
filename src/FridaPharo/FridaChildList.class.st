"
GENERATED binding for the Frida FridaChildList GObject.
"
Class {
	#name : 'FridaChildList',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaChildList >> size [
	^ self ffiCall: #(int frida_child_list_size (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChildList >> getRaw: index [
	^ self ffiCall: #(void* frida_child_list_get (self, int index)) library: FridaLibrary
]

{ #category : 'generated' }
FridaChildList >> get: index [
	| result |
	result := self getRaw: index.
	^ FridaChild fromHandle: (result) owned: true
]

{ #category : 'generated' }
FridaChildList >> asArray [
	| result |
	result := Array new: self size.
	1 to: self size do: [ :i | result at: i put: (self get: i - 1) ].
	^ result
]

{ #category : 'generated' }
FridaChildList >> asFridaList [
	^ FridaList withAll: self asArray
]

