"
GENERATED binding for the Frida FridaAuthenticationService GObject.
"
Class {
	#name : 'FridaAuthenticationService',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaAuthenticationService >> authenticate: token cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self authenticateBegin: token cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self authenticateFinish: asyncResult errorHolder: errorHolder ].
	^ raw
]

{ #category : 'generated' }
FridaAuthenticationService >> authenticateBegin: token cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_authentication_service_authenticate (self, String token, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaAuthenticationService >> authenticateFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(String frida_authentication_service_authenticate_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaAuthenticationService >> authenticate: token [
	^ self authenticate: token cancellable: nil
]

