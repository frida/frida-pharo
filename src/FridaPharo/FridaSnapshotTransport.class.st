"
GENERATED binding for the Frida FridaSnapshotTransport enumeration.
"
Class {
	#name : 'FridaSnapshotTransport',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaSnapshotTransportInline', 'FridaSnapshotTransportSharedMemory' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSnapshotTransport class >> enumDecl [
	^ #(
			FridaSnapshotTransportInline 0
			FridaSnapshotTransportSharedMemory 1
		)
]

{ #category : 'generated' }
FridaSnapshotTransport class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

