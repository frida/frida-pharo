"
GENERATED plain value snapshot of the Frida FridaWebRequest.
"
Class {
	#name : 'FridaWebRequest',
	#superclass : 'Object',
	#instVars : [ 'method', 'path', 'queryString', 'body' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaWebRequest >> method [
	^ method
]

{ #category : 'generated' }
FridaWebRequest >> setMethod: aValue [
	method := aValue
]

{ #category : 'generated' }
FridaWebRequest >> path [
	^ path
]

{ #category : 'generated' }
FridaWebRequest >> setPath: aValue [
	path := aValue
]

{ #category : 'generated' }
FridaWebRequest >> queryString [
	^ queryString
]

{ #category : 'generated' }
FridaWebRequest >> setQueryString: aValue [
	queryString := aValue
]

{ #category : 'generated' }
FridaWebRequest >> body [
	^ body
]

{ #category : 'generated' }
FridaWebRequest >> setBody: aValue [
	body := aValue
]

{ #category : 'generated' }
FridaWebRequest class >> readMethod: aHandle [
	^ self ffiCall: #(String frida_web_request_get_method (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequest class >> readPath: aHandle [
	^ self ffiCall: #(String frida_web_request_get_path (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequest class >> readQueryString: aHandle [
	^ self ffiCall: #(String frida_web_request_get_query_string (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequest class >> readBodyRaw: aHandle [
	^ self ffiCall: #(void* frida_web_request_get_body (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaWebRequest class >> readBody: aHandle [
	| result |
	result := self readBodyRaw: aHandle.
	^ FridaObject byteArrayFromBytes: (result) owned: false
]

{ #category : 'generated' }
FridaWebRequest class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setMethod: (self readMethod: aHandle).
	instance setPath: (self readPath: aHandle).
	instance setQueryString: (self readQueryString: aHandle).
	instance setBody: (self readBody: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaWebRequest class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
]

