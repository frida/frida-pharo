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
FridaService >> activate: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self activateBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self activateFinish: asyncResult errorHolder: errorHolder ].
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
FridaService >> activate [
	^ self activate: nil
]

{ #category : 'generated' }
FridaService >> cancel: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self cancelBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self cancelFinish: asyncResult errorHolder: errorHolder ].
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
FridaService >> cancel [
	^ self cancel: nil
]

{ #category : 'generated' }
FridaService >> request: parameters cancellable: cancellable [
	| marshalled0 cancellableHandle raw |
	marshalled0 := FridaVariant encode: parameters.
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self requestBegin: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self requestFinish: asyncResult errorHolder: errorHolder ].
	FridaGlue variantUnref: marshalled0.
	^ FridaObject valueFromVariant: (raw) owned: true
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
FridaService >> request: parameters [
	^ self request: parameters cancellable: nil
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
	callback := FFICallback signature: #(void (void* instance, void* message, void* userData)) block: [ :instance :message :userData | aBlock valueWithArguments: { FridaObject valueFromVariant: message owned: false } ].
	^ self connectSignal: 'message' callback: callback
]

