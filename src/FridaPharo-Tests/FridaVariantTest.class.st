"
GVariant codec round-trip: a nested Dictionary -> GVariant -> back, covering
a{sv} dicts, arrays, strings, ints, booleans, doubles and byte arrays.
"
Class {
	#name : 'FridaVariantTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaVariantTest >> testNestedRoundTrip [
	| original handle decoded |
	original := Dictionary new.
	original at: 'name' put: 'frida'.
	original at: 'count' put: 42.
	original at: 'enabled' put: true.
	original at: 'ratio' put: 1.5.
	original at: 'tags' put: #( 'a' 'b' 'c' ).
	original at: 'blob' put: #[ 1 2 3 4 ].

	handle := FridaVariant encode: original.
	decoded := FridaVariant decode: handle.
	FridaGlue variantUnref: handle.

	self assert: (decoded at: 'name') equals: 'frida'.
	self assert: (decoded at: 'count') equals: 42.
	self assert: (decoded at: 'enabled') equals: true.
	self assert: (decoded at: 'ratio') equals: 1.5.
	self assert: (decoded at: 'tags') asArray equals: #( 'a' 'b' 'c' ).
	self assert: (decoded at: 'blob') equals: #[ 1 2 3 4 ]
]
