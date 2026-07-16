"
GENERATED binding for the Frida FridaDeviceList GObject.
"
Class {
	#name : 'FridaDeviceList',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaDeviceList >> size [
	^ self ffiCall: #(int frida_device_list_size (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceList >> getRaw: index [
	^ self ffiCall: #(void* frida_device_list_get (self, int index)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceList >> get: index [
	| result |
	result := self getRaw: index.
	^ FridaDevice fromOwnedHandle: (result)
]

{ #category : 'generated' }
FridaDeviceList >> at: anIndex [
	^ self get: anIndex - 1
]

{ #category : 'generated' }
FridaDeviceList >> do: aBlock [
	0 to: self size - 1 do: [ :i | aBlock value: (self get: i) ]
]

{ #category : 'generated' }
FridaDeviceList >> collect: aBlock [
	^ self asArray collect: aBlock
]

{ #category : 'generated' }
FridaDeviceList >> asArray [
	| result |
	result := Array new: self size.
	1 to: self size do: [ :i | result at: i put: (self get: i - 1) ].
	^ result
]

{ #category : 'generated' }
FridaDeviceList >> isEmpty [
	^ self size = 0
]

{ #category : 'generated' }
FridaDeviceList >> isCollection [
	^ true
]

