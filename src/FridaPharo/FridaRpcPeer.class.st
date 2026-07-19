"
GENERATED binding for the Frida FridaRpcPeer GObject.
"
Class {
	#name : 'FridaRpcPeer',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaRpcPeer >> postRpcMessage: json data: data cancellable: cancellable [
	| marshalled0 cancellableHandle raw |
	marshalled0 := self bytesFromByteArray: data.
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self postRpcMessageBegin: json marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self postRpcMessageFinish: asyncResult errorHolder: errorHolder ].
	FridaGlue bytesUnref: marshalled0.
	^ self
]

{ #category : 'generated' }
FridaRpcPeer >> postRpcMessageBegin: json marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_rpc_peer_post_rpc_message (self, String json, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRpcPeer >> postRpcMessageFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_rpc_peer_post_rpc_message_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRpcPeer >> postRpcMessage: json data: data [
	^ self postRpcMessage: json data: data cancellable: nil
]

{ #category : 'generated' }
FridaRpcPeer >> postRpcMessage: json [
	^ self postRpcMessage: json data: nil cancellable: nil
]

