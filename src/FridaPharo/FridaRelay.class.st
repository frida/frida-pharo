"
GENERATED binding for the Frida FridaRelay GObject.
"
Class {
	#name : 'FridaRelay',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaRelay class >> newRaw: address username: username password: password kind: kind [
	^ self ffiCall: #(void* frida_relay_new (String address, String username, String password, FridaRelayKind kind)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRelay class >> new: address username: username password: password kind: kind [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw: address username: username password: password kind: kind)
]

{ #category : 'generated' }
FridaRelay >> address [
	^ self ffiCall: #(String frida_relay_get_address (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRelay >> username [
	^ self ffiCall: #(String frida_relay_get_username (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRelay >> password [
	^ self ffiCall: #(String frida_relay_get_password (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRelay >> kind [
	^ self ffiCall: #(FridaRelayKind frida_relay_get_kind (self)) library: FridaLibrary
]

