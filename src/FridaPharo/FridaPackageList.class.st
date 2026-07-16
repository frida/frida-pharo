"
GENERATED binding for the Frida FridaPackageList GObject.
"
Class {
	#name : 'FridaPackageList',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageList >> size [
	^ self ffiCall: #(int frida_package_list_size (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageList >> getRaw: index [
	^ self ffiCall: #(void* frida_package_list_get (self, int index)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageList >> get: index [
	| result |
	result := self getRaw: index.
	^ FridaPackage fromOwnedHandle: (result)
]

{ #category : 'generated' }
FridaPackageList >> at: anIndex [
	^ self get: anIndex - 1
]

{ #category : 'generated' }
FridaPackageList >> do: aBlock [
	0 to: self size - 1 do: [ :i | aBlock value: (self get: i) ]
]

{ #category : 'generated' }
FridaPackageList >> collect: aBlock [
	^ self asArray collect: aBlock
]

{ #category : 'generated' }
FridaPackageList >> asArray [
	| result |
	result := Array new: self size.
	1 to: self size do: [ :i | result at: i put: (self get: i - 1) ].
	^ result
]

{ #category : 'generated' }
FridaPackageList >> isEmpty [
	^ self size = 0
]

{ #category : 'generated' }
FridaPackageList >> isCollection [
	^ true
]

