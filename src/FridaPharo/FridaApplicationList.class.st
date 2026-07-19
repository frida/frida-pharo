"
GENERATED binding for the Frida FridaApplicationList GObject.
"
Class {
	#name : 'FridaApplicationList',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaApplicationList >> size [
	^ self ffiCall: #(int frida_application_list_size (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplicationList >> getRaw: index [
	^ self ffiCall: #(void* frida_application_list_get (self, int index)) library: FridaLibrary
]

{ #category : 'generated' }
FridaApplicationList >> get: index [
	| result |
	result := self getRaw: index.
	^ FridaApplication fromHandle: (result) owned: true
]

{ #category : 'generated' }
FridaApplicationList >> asArray [
	| result |
	result := Array new: self size.
	1 to: self size do: [ :i | result at: i put: (self get: i - 1) ].
	^ result
]

