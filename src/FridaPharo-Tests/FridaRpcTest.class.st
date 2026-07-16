"
Script RPC round-trip: attach to self, load a script exporting an `add`
function, and call it over the message/post transport, asserting 3 + 4 = 7.
"
Class {
	#name : 'FridaRpcTest',
	#superclass : 'TestCase',
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
