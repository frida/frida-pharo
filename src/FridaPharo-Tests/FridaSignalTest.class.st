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
	| device session args fired subscription |
	device := Frida localDevice.
	session := device attach: 0.

	args := nil.
	fired := Semaphore new.
	subscription := session on: 'detached' do: [ :signalArgs |
		args := signalArgs.
		fired signal ].

	session detach.

	[ (fired waitTimeoutSeconds: 10)
		ifTrue: [ self fail: 'detached signal not delivered within 10s' ].
		self assert: args isArray.
		self assert: args notEmpty.
		"first arg is the FridaSessionDetachReason, decoded to an Integer"
		self assert: (args first isKindOf: Integer) ]
		ensure: [ subscription off ]
]
