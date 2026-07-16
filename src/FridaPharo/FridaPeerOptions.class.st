"
GENERATED binding for the Frida FridaPeerOptions GObject.
"
Class {
	#name : 'FridaPeerOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPeerOptions class >> newRaw [
	^ self ffiCall: #(void* frida_peer_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaPeerOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaPeerOptions >> stunServer [
	^ self ffiCall: #(String frida_peer_options_get_stun_server (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPeerOptions >> stunServerRaw: aValue [
	^ self ffiCall: #(void frida_peer_options_set_stun_server (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPeerOptions >> stunServer: aValue [
	self stunServerRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaPeerOptions >> clearRelays [
	^ self ffiCall: #(void frida_peer_options_clear_relays (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPeerOptions >> addRelay: relay [
	^ self ffiCall: #(void frida_peer_options_add_relay (self, FridaRelay relay)) library: FridaLibrary
]

