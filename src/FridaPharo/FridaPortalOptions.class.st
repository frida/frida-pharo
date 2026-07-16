"
GENERATED binding for the Frida FridaPortalOptions GObject.
"
Class {
	#name : 'FridaPortalOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPortalOptions class >> newRaw [
	^ self ffiCall: #(void* frida_portal_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaPortalOptions >> token [
	^ self ffiCall: #(String frida_portal_options_get_token (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalOptions >> aclRaw: lengthHolder [
	^ self ffiCall: #(void* frida_portal_options_get_acl (self, void* lengthHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalOptions >> acl [
	| lengthHolder result |
	lengthHolder := ExternalAddress allocate: 4.
	result := self aclRaw: lengthHolder.
	lengthHolder free.
	^ self arrayFromStrv: (result) owned: false
]

{ #category : 'generated' }
FridaPortalOptions >> tokenRaw: aValue [
	^ self ffiCall: #(void frida_portal_options_set_token (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalOptions >> token: aValue [
	self tokenRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaPortalOptions >> aclRaw: value length: length [
	^ self ffiCall: #(void frida_portal_options_set_acl (self, void* value, int length)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalOptions >> acl: anArray [
	| strv |
	strv := self strvFromArray: anArray.
	self aclRaw: strv length: (anArray ifNil: [ 0 ] ifNotNil: [ :a | a size ]).
	FridaGlue strvFree: strv.
	^ self
]

