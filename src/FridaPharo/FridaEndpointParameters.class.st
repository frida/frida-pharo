"
GENERATED binding for the Frida FridaEndpointParameters GObject.
"
Class {
	#name : 'FridaEndpointParameters',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaEndpointParameters >> address [
	^ self ffiCall: #(String frida_endpoint_parameters_get_address (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaEndpointParameters >> port [
	^ self ffiCall: #(uint16 frida_endpoint_parameters_get_port (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaEndpointParameters >> origin [
	^ self ffiCall: #(String frida_endpoint_parameters_get_origin (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaEndpointParameters >> authServiceRaw [
	^ self ffiCall: #(void* frida_endpoint_parameters_get_auth_service (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaEndpointParameters >> authService [
	| result |
	result := self authServiceRaw.
	^ FridaAuthenticationService fromBorrowedHandle: (result)
]

{ #category : 'generated' }
FridaEndpointParameters >> requestHandlerRaw [
	^ self ffiCall: #(void* frida_endpoint_parameters_get_request_handler (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaEndpointParameters >> requestHandler [
	| result |
	result := self requestHandlerRaw.
	^ FridaWebRequestHandler fromBorrowedHandle: (result)
]

{ #category : 'generated' }
FridaEndpointParameters >> requestHandlerRaw: aHandle [
	^ self ffiCall: #(void frida_endpoint_parameters_set_request_handler (self, void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaEndpointParameters >> requestHandler: aValue [
	self requestHandlerRaw: (aValue isNil ifTrue: [ ExternalAddress null ] ifFalse: [ aValue getHandle ]).
	^ self
]

