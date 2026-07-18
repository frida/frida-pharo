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
	raw := self asyncCall: [ :onReady | self startBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self startFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaControlService >> startBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_control_service_start (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlService >> startFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_control_service_start_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlService >> stop [
	| raw |
	raw := self asyncCall: [ :onReady | self stopBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self stopFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaControlService >> stopBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_control_service_stop (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlService >> stopFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_control_service_stop_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

