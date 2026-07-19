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
	raw := self asyncCall: [ :onReady | self closeBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self closeFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaDeviceManager >> closeBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_manager_close (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> closeFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_manager_close_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> getDeviceById: id timeout: timeout [
	| raw |
	raw := self asyncCall: [ :onReady | self getDeviceByIdBegin: id timeout: timeout cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self getDeviceByIdFinish: asyncResult errorHolder: errorHolder ].
	^ FridaDevice fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaDeviceManager >> getDeviceByIdBegin: id timeout: timeout cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_manager_get_device_by_id (self, String id, int timeout, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> getDeviceByIdFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_manager_get_device_by_id_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> getDeviceByType: type timeout: timeout [
	| raw |
	raw := self asyncCall: [ :onReady | self getDeviceByTypeBegin: type timeout: timeout cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self getDeviceByTypeFinish: asyncResult errorHolder: errorHolder ].
	^ FridaDevice fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaDeviceManager >> getDeviceByTypeBegin: type timeout: timeout cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_manager_get_device_by_type (self, FridaDeviceType type, int timeout, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> getDeviceByTypeFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_manager_get_device_by_type_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> findDeviceById: id timeout: timeout [
	| raw |
	raw := self asyncCall: [ :onReady | self findDeviceByIdBegin: id timeout: timeout cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self findDeviceByIdFinish: asyncResult errorHolder: errorHolder ].
	^ FridaDevice fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaDeviceManager >> findDeviceByIdBegin: id timeout: timeout cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_manager_find_device_by_id (self, String id, int timeout, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> findDeviceByIdFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_manager_find_device_by_id_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> findDeviceByType: type timeout: timeout [
	| raw |
	raw := self asyncCall: [ :onReady | self findDeviceByTypeBegin: type timeout: timeout cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self findDeviceByTypeFinish: asyncResult errorHolder: errorHolder ].
	^ FridaDevice fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaDeviceManager >> findDeviceByTypeBegin: type timeout: timeout cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_manager_find_device_by_type (self, FridaDeviceType type, int timeout, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> findDeviceByTypeFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_manager_find_device_by_type_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> enumerateDevices [
	| raw |
	raw := self asyncCall: [ :onReady | self enumerateDevicesBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enumerateDevicesFinish: asyncResult errorHolder: errorHolder ].
	^ (FridaDeviceList fromOwnedHandle: (raw)) asArray
]

{ #category : 'generated' }
FridaDeviceManager >> enumerateDevicesBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_manager_enumerate_devices (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> enumerateDevicesFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_manager_enumerate_devices_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> addRemoteDevice: address options: options [
	| marshalled0 raw |
	marshalled0 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self addRemoteDeviceBegin: address marshalled0: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self addRemoteDeviceFinish: asyncResult errorHolder: errorHolder ].
	^ FridaDevice fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaDeviceManager >> addRemoteDeviceBegin: address marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_manager_add_remote_device (self, String address, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> addRemoteDeviceFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_manager_add_remote_device_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> removeRemoteDevice: address [
	| raw |
	raw := self asyncCall: [ :onReady | self removeRemoteDeviceBegin: address cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self removeRemoteDeviceFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaDeviceManager >> removeRemoteDeviceBegin: address cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_manager_remove_remote_device (self, String address, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> removeRemoteDeviceFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_manager_remove_remote_device_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDeviceManager >> onAdded: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* device, void* userData)) block: [ :instance :device :userData | aBlock valueWithArguments: { FridaObject wrapBorrowed: device } ].
	^ self connectSignal: 'added' callback: callback
]

{ #category : 'generated' }
FridaDeviceManager >> onRemoved: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* device, void* userData)) block: [ :instance :device :userData | aBlock valueWithArguments: { FridaObject wrapBorrowed: device } ].
	^ self connectSignal: 'removed' callback: callback
]

{ #category : 'generated' }
FridaDeviceManager >> onChanged: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* userData)) block: [ :instance :userData | aBlock valueWithArguments: { } ].
	^ self connectSignal: 'changed' callback: callback
]

