"
The whole-stack milestone: args-carrying async (attach/createScript), sync +
facades, and the message signal delivered back on the Pharo thread.
"
Class {
	#name : 'FridaScriptMessageTest',
	#superclass : 'FridaTestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaScriptMessageTest >> testAttachCreateScriptReceivesMessage [
	| device session script received delivered subscription |
	device := Frida localDevice.
	session := device attach: 0.
	script := session createScript: 'send(1 + 2);' options: nil.

	received := nil.
	delivered := Semaphore new.
	subscription := script onMessage: [ :message :data |
		received := message.
		delivered signal ].

	script load.

	[ (delivered waitTimeoutSeconds: 10)
		ifTrue: [ self fail: 'no message delivered within 10s' ].
		self assert: (received includesSubstring: '"type":"send"').
		self assert: (received includesSubstring: '"payload":3') ]
		ensure: [ subscription off ]
]
