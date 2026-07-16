"
GENERATED binding for the Frida FridaWebRequest GObject.
"
Class {
	#name : 'FridaWebRequest',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaWebRequest >> method [
	^ self ffiCall: #(String frida_web_request_get_method (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequest >> path [
	^ self ffiCall: #(String frida_web_request_get_path (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequest >> queryString [
	^ self ffiCall: #(String frida_web_request_get_query_string (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequest >> bodyRaw [
	^ self ffiCall: #(void* frida_web_request_get_body (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequest >> body [
	| result |
	result := self bodyRaw.
	^ self byteArrayFromBytes: (result) owned: false
]

