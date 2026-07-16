"
GENERATED binding for the Frida FridaControlService GObject.
"
Class {
	#name : 'FridaControlService',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaControlService class >> newRaw: endpointParams options: options [
	^ self ffiCall: #(void* frida_control_service_new (FridaEndpointParameters endpointParams, FridaControlServiceOptions options)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlService class >> new: endpointParams options: options [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw: endpointParams options: options)
]

{ #category : 'generated' }
FridaControlService >> endpointParamsRaw [
	^ self ffiCall: #(void* frida_control_service_get_endpoint_params (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlService >> endpointParams [
	| result |
	result := self endpointParamsRaw.
	^ FridaEndpointParameters fromBorrowedHandle: (result)
]

{ #category : 'generated' }
FridaControlService >> start [
	| raw |
	raw := self asyncBegin: 'frida_control_service_start' finish: 'frida_control_service_start_finish'.
	^ self
]

{ #category : 'generated' }
FridaControlService >> stop [
	| raw |
	raw := self asyncBegin: 'frida_control_service_stop' finish: 'frida_control_service_stop_finish'.
	^ self
]

