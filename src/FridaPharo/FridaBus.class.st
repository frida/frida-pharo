"
GENERATED binding for the Frida FridaBus GObject.
"
Class {
	#name : 'FridaBus',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaBus >> isDetached [
	^ self ffiCall: #(bool frida_bus_is_detached (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaBus >> attach: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self attachBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self attachFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaBus >> attachBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_bus_attach (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaBus >> attachFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_bus_attach_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaBus >> attach [
	^ self attach: nil
]

{ #category : 'generated' }
FridaBus >> postRaw: json marshalled0: marshalled0 [
	^ self ffiCall: #(void frida_bus_post (self, String json, void* marshalled0)) library: FridaLibrary
]

{ #category : 'generated' }
FridaBus >> post: json data: data [
	| marshalled0 result |
	marshalled0 := self bytesFromByteArray: data.
	result := self postRaw: json marshalled0: marshalled0.
	FridaGlue bytesUnref: marshalled0.
	^ self
]

{ #category : 'generated' }
FridaBus >> post: json [
	^ self post: json data: nil
]

{ #category : 'generated' }
FridaBus >> onDetached: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* userData)) block: [ :instance :userData | aBlock valueWithArguments: { } ].
	^ self connectSignal: 'detached' callback: callback
]

{ #category : 'generated' }
FridaBus >> onMessage: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, String json, void* data, void* userData)) block: [ :instance :json :data :userData | aBlock valueWithArguments: { json . FridaObject byteArrayFromBytes: data owned: false } ].
	^ self connectSignal: 'message' callback: callback
]

