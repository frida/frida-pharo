"
GENERATED binding for the Frida FridaSpawnList GObject.
"
Class {
	#name : 'FridaSpawnList',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSpawnList >> size [
	^ self ffiCall: #(int frida_spawn_list_size (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnList >> getRaw: index [
	^ self ffiCall: #(void* frida_spawn_list_get (self, int index)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSpawnList >> get: index [
	| result |
	result := self getRaw: index.
	^ FridaSpawn fromHandle: (result) owned: true
]

{ #category : 'generated' }
FridaSpawnList >> at: anIndex [
	^ self get: anIndex - 1
]

{ #category : 'generated' }
FridaSpawnList >> do: aBlock [
	0 to: self size - 1 do: [ :i | aBlock value: (self get: i) ]
]

{ #category : 'generated' }
FridaSpawnList >> collect: aBlock [
	^ self asArray collect: aBlock
]

{ #category : 'generated' }
FridaSpawnList >> asArray [
	| result |
	result := Array new: self size.
	1 to: self size do: [ :i | result at: i put: (self get: i - 1) ].
	^ result
]

{ #category : 'generated' }
FridaSpawnList >> isEmpty [
	^ self size = 0
]

{ #category : 'generated' }
FridaSpawnList >> isCollection [
	^ true
]

