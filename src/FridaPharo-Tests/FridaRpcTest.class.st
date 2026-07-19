"
Script RPC round-trip: attach to self, load a script exporting an `add`
function, and call it over the message/post transport, asserting 3 + 4 = 7.
"
Class {
	#name : 'FridaRpcTest',
	#superclass : 'FridaTestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaRpcTest >> testExportsRoundTrip [
	| device session script exports result |
	device := Frida localDevice.
	session := device attach: 0.
	script := session createScript: 'rpc.exports = { add(a, b) { return a + b; } };' options: nil.
	script load.
	exports := script exports.
	[ result := exports call: 'add' withArguments: #( 3 4 ) ]
		ensure: [ exports close ].
	self assert: result equals: 7
]

{ #category : 'tests' }
FridaRpcTest >> testBinaryRoundTrip [
	"A trailing ByteArray argument travels as the message's binary payload, and an
	 ArrayBuffer return comes back as a ByteArray."
	| device session script exports result |
	device := Frida localDevice.
	session := device attach: 0.
	script := session createScript: 'rpc.exports = { reverse(data) { const b = new Uint8Array(data); b.reverse(); return b.buffer; } };' options: nil.
	script load.
	exports := script exports.
	[ result := exports call: 'reverse' withArguments: { #[ 1 2 3 4 ] } ]
		ensure: [ exports close ].
	self assert: result equals: #[ 4 3 2 1 ]
]

{ #category : 'tests' }
FridaRpcTest >> testBinaryPairReturn [
	"An export returning [ value, ArrayBuffer ] arrives as { value. bytes }."
	| device session script exports result |
	device := Frida localDevice.
	session := device attach: 0.
	script := session createScript: 'rpc.exports = { meta() { return ["tag", new Uint8Array([9, 8, 7]).buffer]; } };' options: nil.
	script load.
	exports := script exports.
	[ result := exports call: 'meta' withArguments: #() ]
		ensure: [ exports close ].
	self assert: result first equals: 'tag'.
	self assert: result second equals: #[ 9 8 7 ]
]

{ #category : 'tests' }
FridaRpcTest >> testExportsDoesNotUnderstandSugar [
	| device session script exports result |
	device := Frida localDevice.
	session := device attach: 0.
	script := session createScript: 'rpc.exports = { add(a, b) { return a + b; } };' options: nil.
	script load.
	exports := script exports.
	[ result := exports add: 3 and: 4 ]
		ensure: [ exports close ].
	self assert: result equals: 7
]
