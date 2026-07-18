"
GENERATED binding for the Frida FridaService GObject.
"
Class {
	#name : 'FridaService',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaService >> isClosed [
	^ self ffiCall: #(bool frida_service_is_closed (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaService >> activate [
	| raw |
	raw := self asyncCall: [ :onReady | self activateBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self activateFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaService >> activateBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_service_activate (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaService >> activateFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_service_activate_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaService >> cancel [
	| raw |
	raw := self asyncCall: [ :onReady | self cancelBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self cancelFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaService >> cancelBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_service_cancel (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaService >> cancelFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_service_cancel_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaService >> request: parameters [
	| marshalled0 raw |
	marshalled0 := FridaVariant encode: parameters.
	raw := self asyncCall: [ :onReady | self requestBegin: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self requestFinish: asyncResult errorHolder: errorHolder ].
	FridaGlue variantUnref: marshalled0.
	^ self valueFromVariant: (raw) owned: true
]

{ #category : 'generated' }
FridaService >> requestBegin: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_service_request (self, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaService >> requestFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_service_request_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaService >> onClose: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* userData)) block: [ :instance :userData | aBlock valueWithArguments: { } ].
	^ self connectSignal: 'close' callback: callback
]

{ #category : 'generated' }
FridaService >> onMessage: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* message, void* userData)) block: [ :instance :message :userData | aBlock valueWithArguments: { self valueFromVariant: message owned: false } ].
	^ self connectSignal: 'message' callback: callback
]

