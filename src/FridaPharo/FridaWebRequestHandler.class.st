"
GENERATED binding for the Frida FridaWebRequestHandler GObject.
"
Class {
	#name : 'FridaWebRequestHandler',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaWebRequestHandler >> handleRequest: request [
	| raw |
	raw := self asyncBegin: 'frida_web_request_handler_handle_request' finish: 'frida_web_request_handler_handle_request_finish' args: { { #pointer. (request isNil ifTrue: [ ExternalAddress null ] ifFalse: [ request getHandle ]) } }.
	^ FridaWebResponse fromOwnedHandle: raw
]

