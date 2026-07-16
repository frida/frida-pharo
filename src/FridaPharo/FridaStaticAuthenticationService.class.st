"
GENERATED binding for the Frida FridaStaticAuthenticationService GObject.
"
Class {
	#name : 'FridaStaticAuthenticationService',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaStaticAuthenticationService class >> newRaw: token [
	^ self ffiCall: #(void* frida_static_authentication_service_new (String token)) library: FridaLibrary
]

{ #category : 'generated' }
FridaStaticAuthenticationService class >> new: token [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw: token)
]

{ #category : 'generated' }
FridaStaticAuthenticationService >> tokenHash [
	^ self ffiCall: #(String frida_static_authentication_service_get_token_hash (self)) library: FridaLibrary
]

