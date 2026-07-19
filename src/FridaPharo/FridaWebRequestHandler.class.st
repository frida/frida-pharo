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
FridaWebRequestHandler >> handleRequest: request cancellable: cancellable [
	| marshalled0 cancellableHandle raw |
	marshalled0 := request isNil ifTrue: [ ExternalAddress null ] ifFalse: [ request getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self handleRequestBegin: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self handleRequestFinish: asyncResult errorHolder: errorHolder ].
	^ FridaWebResponse fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaWebRequestHandler >> handleRequestBegin: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_web_request_handler_handle_request (self, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequestHandler >> handleRequestFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_web_request_handler_handle_request_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequestHandler >> handleRequest: request [
	^ self handleRequest: request cancellable: nil
]

