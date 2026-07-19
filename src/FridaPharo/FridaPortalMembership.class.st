"
GENERATED binding for the Frida FridaPortalMembership GObject.
"
Class {
	#name : 'FridaPortalMembership',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPortalMembership >> terminate: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self terminateBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self terminateFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaPortalMembership >> terminateBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_portal_membership_terminate (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalMembership >> terminateFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_portal_membership_terminate_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalMembership >> terminate [
	^ self terminate: nil
]

