"
Exception raised when a Frida async operation completes with a GError.
"
Class {
	#name : 'FridaError',
	#superclass : 'Error',
	#instVars : [ 'code' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'signalling' }
FridaError class >> signalMessage: aMessage code: aCode [
	^ self new
		code: aCode;
		signal: aMessage
]

{ #category : 'accessing' }
FridaError >> code [
	^ code
]

{ #category : 'accessing' }
FridaError >> code: aCode [
	code := aCode
]
