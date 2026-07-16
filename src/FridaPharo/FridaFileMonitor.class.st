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
	raw := self asyncBegin: 'frida_file_monitor_enable' finish: 'frida_file_monitor_enable_finish'.
	^ self
]

{ #category : 'generated' }
FridaFileMonitor >> disable [
	| raw |
	raw := self asyncBegin: 'frida_file_monitor_disable' finish: 'frida_file_monitor_disable_finish'.
	^ self
]

