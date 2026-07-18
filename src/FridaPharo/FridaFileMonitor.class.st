"
GENERATED binding for the Frida FridaFileMonitor GObject.
"
Class {
	#name : 'FridaFileMonitor',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaFileMonitor class >> newRaw: path [
	^ self ffiCall: #(void* frida_file_monitor_new (String path)) library: FridaLibrary
]

{ #category : 'generated' }
FridaFileMonitor class >> new: path [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw: path)
]

{ #category : 'generated' }
FridaFileMonitor >> path [
	^ self ffiCall: #(String frida_file_monitor_get_path (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaFileMonitor >> enable [
	| raw |
	raw := self asyncCall: [ :onReady | self enableBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enableFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaFileMonitor >> enableBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_file_monitor_enable (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaFileMonitor >> enableFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_file_monitor_enable_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaFileMonitor >> disable [
	| raw |
	raw := self asyncCall: [ :onReady | self disableBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self disableFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaFileMonitor >> disableBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_file_monitor_disable (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaFileMonitor >> disableFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_file_monitor_disable_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

