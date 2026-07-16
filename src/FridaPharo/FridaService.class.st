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
	raw := self asyncBegin: 'frida_service_activate' finish: 'frida_service_activate_finish'.
	^ self
]

{ #category : 'generated' }
FridaService >> cancel [
	| raw |
	raw := self asyncBegin: 'frida_service_cancel' finish: 'frida_service_cancel_finish'.
	^ self
]

{ #category : 'generated' }
FridaService >> request: parameters [
	| raw |
	raw := self asyncBegin: 'frida_service_request' finish: 'frida_service_request_finish' args: { { #variant. parameters } }.
	^ self valueFromVariant: raw owned: true
]

