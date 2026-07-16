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
FridaBus >> attach [
	| raw |
	raw := self asyncBegin: 'frida_bus_attach' finish: 'frida_bus_attach_finish'.
	^ self
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

