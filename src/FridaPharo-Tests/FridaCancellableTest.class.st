"
Cancellation: a FridaCancellable passed to an async call's trailing
#cancellable: argument aborts the operation, which then raises a FridaError.
"
Class {
	#name : 'FridaCancellableTest',
	#superclass : 'FridaTestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaCancellableTest >> testTracksCancelledState [
	| cancellable |
	cancellable := FridaCancellable new.
	self deny: cancellable isCancelled.
	cancellable cancel.
	self assert: cancellable isCancelled.
	cancellable reset.
	self deny: cancellable isCancelled
]

{ #category : 'tests' }
FridaCancellableTest >> testCancelledOperationRaises [
	| cancellable |
	cancellable := FridaCancellable new.
	cancellable cancel.
	self
		should: [ Frida deviceManager enumerateDevices: cancellable ]
		raise: FridaError
]
