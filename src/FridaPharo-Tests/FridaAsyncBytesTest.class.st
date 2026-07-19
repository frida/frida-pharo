"
Async reference-typed input params: an async method taking a GBytes builds it,
hands ownership to the operation across the cross-thread schedule, and frees it
after _finish. Exercised via createScriptFromBytes: with invalid bytecode, which
must surface as a FridaError (proving the bytes were marshalled and delivered)
rather than crashing.
"
Class {
	#name : 'FridaAsyncBytesTest',
	#superclass : 'FridaTestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaAsyncBytesTest >> testCreateScriptFromBytesMarshalsGBytes [
	| device session |
	device := Frida localDevice.
	session := device attach: 0.
	self
		should: [ session createScriptFromBytes: #[ 1 2 3 4 ] options: nil ]
		raise: FridaError
]
