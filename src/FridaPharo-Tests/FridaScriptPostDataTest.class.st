"
Exercises the GBytes `data` arg on frida_script_post: post a binary blob
alongside the JSON message and assert the script sees its byte length, proving
the ByteArray -> GBytes marshalling (and its freeing) round-trips.
"
Class {
	#name : 'FridaScriptPostDataTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaScriptPostDataTest >> testPostWithDataDeliversBytes [
	| device session script received delivered subscription |
	device := Frida localDevice.
	session := device attach: 0.
	script := session createScript: 'recv("input", function (message, data) { send("len=" + data.byteLength); });'.

	received := nil.
	delivered := Semaphore new.
	subscription := script onMessage: [ :message :data |
		received := message.
		delivered signal ].

	script load.
	script post: '{"type":"input"}' data: #[1 2 3 4 5].

	[ (delivered waitTimeoutSeconds: 10)
		ifTrue: [ self fail: 'no message delivered within 10s' ].
		self assert: (received includesSubstring: 'len=5') ]
		ensure: [ subscription off ]
]
