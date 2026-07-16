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
	| raw |
	raw := self asyncBegin: 'frida_rpc_peer_post_rpc_message' finish: 'frida_rpc_peer_post_rpc_message_finish' args: { { #string. json } . { #bytes. data } }.
	^ self
]

