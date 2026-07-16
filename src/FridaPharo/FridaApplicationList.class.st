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
	^ FridaApplication fromOwnedHandle: (result)
]

{ #category : 'generated' }
FridaApplicationList >> at: anIndex [
	^ self get: anIndex - 1
]

{ #category : 'generated' }
FridaApplicationList >> do: aBlock [
	0 to: self size - 1 do: [ :i | aBlock value: (self get: i) ]
]

{ #category : 'generated' }
FridaApplicationList >> collect: aBlock [
	^ self asArray collect: aBlock
]

{ #category : 'generated' }
FridaApplicationList >> asArray [
	| result |
	result := Array new: self size.
	1 to: self size do: [ :i | result at: i put: (self get: i - 1) ].
	^ result
]

{ #category : 'generated' }
FridaApplicationList >> isEmpty [
	^ self size = 0
]

{ #category : 'generated' }
FridaApplicationList >> isCollection [
	^ true
]

