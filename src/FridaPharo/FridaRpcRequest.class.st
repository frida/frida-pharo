"
One in-flight RPC call. The caller blocks on #waitResult until the message
handler resolves or rejects it.
"
Class {
	#name : 'FridaRpcRequest',
	#superclass : 'Object',
	#instVars : [ 'semaphore', 'value', 'failure', 'state' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'initialization' }
FridaRpcRequest >> initialize [
	super initialize.
	semaphore := Semaphore new.
	state := #pending
]

{ #category : 'resolving' }
FridaRpcRequest >> reject: aReason [
	failure := aReason.
	state := #error.
	semaphore signal
]

{ #category : 'resolving' }
FridaRpcRequest >> resolve: aValue [
	value := aValue.
	state := #ok.
	semaphore signal
]

{ #category : 'accessing' }
FridaRpcRequest >> waitResult [
	semaphore wait.
	state = #error ifTrue: [
		^ FridaError signalMessage: 'RPC error: ', failure printString code: 0 ].
	^ value
]
