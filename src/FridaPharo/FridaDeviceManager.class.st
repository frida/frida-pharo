"
GENERATED binding for the Frida FridaDeviceManager GObject.
"
Class {
	#name : 'FridaDeviceManager',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaDeviceManager class >> newRaw [
	^ self ffiCall: #(void* frida_device_manager_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaDeviceManager class >> withNonlocalBackendsOnlyRaw [
	^ self ffiCall: #(void* frida_device_manager_new_with_nonlocal_backends_only ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager class >> withNonlocalBackendsOnly [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self withNonlocalBackendsOnlyRaw)
]

{ #category : 'generated' }
FridaDeviceManager class >> withSocketBackendOnlyRaw [
	^ self ffiCall: #(void* frida_device_manager_new_with_socket_backend_only ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager class >> withSocketBackendOnly [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self withSocketBackendOnlyRaw)
]

{ #category : 'generated' }
FridaDeviceManager >> close [
	| raw |
	raw := self asyncBegin: 'frida_device_manager_close' finish: 'frida_device_manager_close_finish'.
	^ self
]

{ #category : 'generated' }
FridaDeviceManager >> getDeviceById: id timeout: timeout [
	| raw |
	raw := self asyncBegin: 'frida_device_manager_get_device_by_id' finish: 'frida_device_manager_get_device_by_id_finish' args: { { #string. id } . { #int. timeout } }.
	^ FridaDevice fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDeviceManager >> getDeviceByType: type timeout: timeout [
	| raw |
	raw := self asyncBegin: 'frida_device_manager_get_device_by_type' finish: 'frida_device_manager_get_device_by_type_finish' args: { { #int. type value } . { #int. timeout } }.
	^ FridaDevice fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDeviceManager >> findDeviceById: id timeout: timeout [
	| raw |
	raw := self asyncBegin: 'frida_device_manager_find_device_by_id' finish: 'frida_device_manager_find_device_by_id_finish' args: { { #string. id } . { #int. timeout } }.
	^ FridaDevice fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDeviceManager >> findDeviceByType: type timeout: timeout [
	| raw |
	raw := self asyncBegin: 'frida_device_manager_find_device_by_type' finish: 'frida_device_manager_find_device_by_type_finish' args: { { #int. type value } . { #int. timeout } }.
	^ FridaDevice fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDeviceManager >> enumerateDevices [
	| raw |
	raw := self asyncBegin: 'frida_device_manager_enumerate_devices' finish: 'frida_device_manager_enumerate_devices_finish'.
	^ FridaDeviceList fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDeviceManager >> addRemoteDevice: address options: options [
	| raw |
	raw := self asyncBegin: 'frida_device_manager_add_remote_device' finish: 'frida_device_manager_add_remote_device_finish' args: { { #string. address } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaDevice fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDeviceManager >> removeRemoteDevice: address [
	| raw |
	raw := self asyncBegin: 'frida_device_manager_remove_remote_device' finish: 'frida_device_manager_remove_remote_device_finish' args: { { #string. address } }.
	^ self
]

