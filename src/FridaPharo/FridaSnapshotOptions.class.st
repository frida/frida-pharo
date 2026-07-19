"
GENERATED binding for the Frida FridaSnapshotOptions GObject.
"
Class {
	#name : 'FridaSnapshotOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSnapshotOptions class >> newRaw [
	^ self ffiCall: #(void* frida_snapshot_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaSnapshotOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaSnapshotOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

{ #category : 'generated' }
FridaSnapshotOptions >> warmupScript [
	^ self ffiCall: #(String frida_snapshot_options_get_warmup_script (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSnapshotOptions >> runtime [
	^ self ffiCall: #(FridaScriptRuntime frida_snapshot_options_get_runtime (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSnapshotOptions >> warmupScriptRaw: aValue [
	^ self ffiCall: #(void frida_snapshot_options_set_warmup_script (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSnapshotOptions >> warmupScript: aValue [
	self warmupScriptRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSnapshotOptions >> runtimeRaw: aValue [
	^ self ffiCall: #(void frida_snapshot_options_set_runtime (self, FridaScriptRuntime aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSnapshotOptions >> runtime: aValue [
	self runtimeRaw: (FridaScriptRuntime fromSymbol: aValue).
	^ self
]

