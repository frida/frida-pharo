"
GENERATED binding for the Frida FridaPortalService GObject.
"
Class {
	#name : 'FridaPortalService',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPortalService class >> newRaw: clusterParams controlParams: controlParams [
	^ self ffiCall: #(void* frida_portal_service_new (FridaEndpointParameters clusterParams, FridaEndpointParameters controlParams)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService class >> new: clusterParams controlParams: controlParams [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw: clusterParams controlParams: controlParams)
]

{ #category : 'generated' }
FridaPortalService >> deviceRaw [
	^ self ffiCall: #(void* frida_portal_service_get_device (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> device [
	| result |
	result := self deviceRaw.
	^ FridaDevice fromBorrowedHandle: (result)
]

{ #category : 'generated' }
FridaPortalService >> clusterParamsRaw [
	^ self ffiCall: #(void* frida_portal_service_get_cluster_params (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> clusterParams [
	| result |
	result := self clusterParamsRaw.
	^ FridaEndpointParameters fromBorrowedHandle: (result)
]

{ #category : 'generated' }
FridaPortalService >> controlParamsRaw [
	^ self ffiCall: #(void* frida_portal_service_get_control_params (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> controlParams [
	| result |
	result := self controlParamsRaw.
	^ FridaEndpointParameters fromBorrowedHandle: (result)
]

{ #category : 'generated' }
FridaPortalService >> addClusterEndpointRaw: endpointParams errorHolder: errorHolder [
	^ self ffiCall: #(void frida_portal_service_add_cluster_endpoint (self, FridaEndpointParameters endpointParams, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> addClusterEndpoint: endpointParams [
	| errorHolder result |
	errorHolder := self newErrorHolder.
	result := self addClusterEndpointRaw: endpointParams errorHolder: errorHolder.
	self checkError: errorHolder.
	^ self
]

{ #category : 'generated' }
FridaPortalService >> addControlEndpointRaw: endpointParams errorHolder: errorHolder [
	^ self ffiCall: #(void frida_portal_service_add_control_endpoint (self, FridaEndpointParameters endpointParams, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> addControlEndpoint: endpointParams [
	| errorHolder result |
	errorHolder := self newErrorHolder.
	result := self addControlEndpointRaw: endpointParams errorHolder: errorHolder.
	self checkError: errorHolder.
	^ self
]

{ #category : 'generated' }
FridaPortalService >> start [
	| raw |
	raw := self asyncBegin: 'frida_portal_service_start' finish: 'frida_portal_service_start_finish'.
	^ self
]

{ #category : 'generated' }
FridaPortalService >> stop [
	| raw |
	raw := self asyncBegin: 'frida_portal_service_stop' finish: 'frida_portal_service_stop_finish'.
	^ self
]

{ #category : 'generated' }
FridaPortalService >> kick: connectionId [
	^ self ffiCall: #(void frida_portal_service_kick (self, uint connectionId)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> postRaw: connectionId json: json marshalled0: marshalled0 [
	^ self ffiCall: #(void frida_portal_service_post (self, uint connectionId, String json, void* marshalled0)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> post: connectionId json: json data: data [
	| marshalled0 result |
	marshalled0 := self bytesFromByteArray: data.
	result := self postRaw: connectionId json: json marshalled0: marshalled0.
	FridaGlue bytesUnref: marshalled0.
	^ self
]

{ #category : 'generated' }
FridaPortalService >> narrowcastRaw: tag json: json marshalled0: marshalled0 [
	^ self ffiCall: #(void frida_portal_service_narrowcast (self, String tag, String json, void* marshalled0)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> narrowcast: tag json: json data: data [
	| marshalled0 result |
	marshalled0 := self bytesFromByteArray: data.
	result := self narrowcastRaw: tag json: json marshalled0: marshalled0.
	FridaGlue bytesUnref: marshalled0.
	^ self
]

{ #category : 'generated' }
FridaPortalService >> broadcastRaw: json marshalled0: marshalled0 [
	^ self ffiCall: #(void frida_portal_service_broadcast (self, String json, void* marshalled0)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> broadcast: json data: data [
	| marshalled0 result |
	marshalled0 := self bytesFromByteArray: data.
	result := self broadcastRaw: json marshalled0: marshalled0.
	FridaGlue bytesUnref: marshalled0.
	^ self
]

{ #category : 'generated' }
FridaPortalService >> tag: connectionId tag: tag [
	^ self ffiCall: #(void frida_portal_service_tag (self, uint connectionId, String tag)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPortalService >> untag: connectionId tag: tag [
	^ self ffiCall: #(void frida_portal_service_untag (self, uint connectionId, String tag)) library: FridaLibrary
]

