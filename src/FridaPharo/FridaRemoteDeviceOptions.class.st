"
GENERATED binding for the Frida FridaRemoteDeviceOptions GObject.
"
Class {
	#name : 'FridaRemoteDeviceOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaRemoteDeviceOptions class >> newRaw [
	^ self ffiCall: #(void* frida_remote_device_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaRemoteDeviceOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaRemoteDeviceOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> origin [
	^ self ffiCall: #(String frida_remote_device_options_get_origin (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> token [
	^ self ffiCall: #(String frida_remote_device_options_get_token (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> keepaliveInterval [
	^ self ffiCall: #(int frida_remote_device_options_get_keepalive_interval (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> originRaw: aValue [
	^ self ffiCall: #(void frida_remote_device_options_set_origin (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> origin: aValue [
	self originRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> tokenRaw: aValue [
	^ self ffiCall: #(void frida_remote_device_options_set_token (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> token: aValue [
	self tokenRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> keepaliveIntervalRaw: aValue [
	^ self ffiCall: #(void frida_remote_device_options_set_keepalive_interval (self, int aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaRemoteDeviceOptions >> keepaliveInterval: aValue [
	self keepaliveIntervalRaw: aValue.
	^ self
]

