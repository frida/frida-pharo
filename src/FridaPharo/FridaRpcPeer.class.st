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
FridaRpcPeer >> postRpcMessage: json data: data [
	| marshalled0 raw |
	marshalled0 := self bytesFromByteArray: data.
	raw := self asyncCall: [ :onReady | self postRpcMessageBegin: json marshalled0: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self postRpcMessageFinish: asyncResult errorHolder: errorHolder ].
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

