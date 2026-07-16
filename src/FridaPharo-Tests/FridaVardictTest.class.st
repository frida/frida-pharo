"
vardict (GHashTable<utf8,GVariant>) round-trip through SpawnOptions>>aux:
set an aux Dictionary and read it back.
"
Class {
	#name : 'FridaVardictTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaVardictTest >> testAuxRoundTrip [
	| options aux back |
	options := FridaSpawnOptions new.
	aux := Dictionary new.
	aux at: 'uid' put: 501.
	aux at: 'name' put: 'frida'.
	aux at: 'enabled' put: true.
	aux at: 'tags' put: #( 'a' 'b' ).

	options aux: aux.
	back := options aux.

	self assert: (back at: 'uid') equals: 501.
	self assert: (back at: 'name') equals: 'frida'.
	self assert: (back at: 'enabled') equals: true.
	self assert: (back at: 'tags') asArray equals: #( 'a' 'b' )
]
