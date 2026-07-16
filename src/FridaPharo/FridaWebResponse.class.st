"
GENERATED binding for the Frida FridaWebResponse GObject.
"
Class {
	#name : 'FridaWebResponse',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaWebResponse class >> newRaw: status body: body [
	^ self ffiCall: #(void* frida_web_response_new (uint status, void* body)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebResponse class >> new: status body: body [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw: status body: body)
]

{ #category : 'generated' }
FridaWebResponse >> status [
	^ self ffiCall: #(uint frida_web_response_get_status (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebResponse >> bodyRaw [
	^ self ffiCall: #(void* frida_web_response_get_body (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebResponse >> body [
	| result |
	result := self bodyRaw.
	^ self byteArrayFromBytes: (result) owned: false
]

{ #category : 'generated' }
FridaWebResponse >> addHeader: name val: val [
	^ self ffiCall: #(void frida_web_response_add_header (self, String name, String val)) library: FridaLibrary
]

