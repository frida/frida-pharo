"
GENERATED binding for the Frida FridaScriptOptions GObject.
"
Class {
	#name : 'FridaScriptOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaScriptOptions class >> newRaw [
	^ self ffiCall: #(void* frida_script_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaScriptOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

{ #category : 'generated' }
FridaScriptOptions >> name [
	^ self ffiCall: #(String frida_script_options_get_name (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions >> snapshotRaw [
	^ self ffiCall: #(void* frida_script_options_get_snapshot (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions >> snapshot [
	| result |
	result := self snapshotRaw.
	^ FridaObject byteArrayFromBytes: (result) owned: false
]

{ #category : 'generated' }
FridaScriptOptions >> snapshotTransport [
	^ self ffiCall: #(FridaSnapshotTransport frida_script_options_get_snapshot_transport (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions >> runtime [
	^ self ffiCall: #(FridaScriptRuntime frida_script_options_get_runtime (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions >> nameRaw: aValue [
	^ self ffiCall: #(void frida_script_options_set_name (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions >> name: aValue [
	self nameRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaScriptOptions >> snapshotRaw: value [
	^ self ffiCall: #(void frida_script_options_set_snapshot (self, void* value)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions >> snapshot: aValue [
	| value |
	value := self bytesFromByteArray: aValue.
	self snapshotRaw: value.
	FridaGlue bytesUnref: value.
	^ self
]

{ #category : 'generated' }
FridaScriptOptions >> snapshotTransportRaw: aValue [
	^ self ffiCall: #(void frida_script_options_set_snapshot_transport (self, FridaSnapshotTransport aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions >> snapshotTransport: aValue [
	self snapshotTransportRaw: (FridaSnapshotTransport fromSymbol: aValue).
	^ self
]

{ #category : 'generated' }
FridaScriptOptions >> runtimeRaw: aValue [
	^ self ffiCall: #(void frida_script_options_set_runtime (self, FridaScriptRuntime aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScriptOptions >> runtime: aValue [
	self runtimeRaw: (FridaScriptRuntime fromSymbol: aValue).
	^ self
]

