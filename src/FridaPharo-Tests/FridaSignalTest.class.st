"
Generic GObject signal delivery: subscribe to a Session's `detached` signal,
detach, and assert the handler fires on the Pharo thread with the reason arg.
"
Class {
	#name : 'FridaSignalTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaSignalTest >> testSessionDetachedSignal [
	| device session reason fired subscription |
	device := Frida localDevice.
	session := device attach: 0.

	reason := nil.
	fired := Semaphore new.
	subscription := session onDetached: [ :detachReason :crash |
		reason := detachReason.
		fired signal ].

	session detach.

	[ (fired waitTimeoutSeconds: 10)
		ifTrue: [ self fail: 'detached signal not delivered within 10s' ].
		self assert: reason notNil ]
		ensure: [ subscription off ]
]
