"
GENERATED binding for the Frida FridaSessionDetachReason enumeration.
"
Class {
	#name : 'FridaSessionDetachReason',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaSessionDetachReasonApplicationRequested', 'FridaSessionDetachReasonProcessReplaced', 'FridaSessionDetachReasonProcessTerminated', 'FridaSessionDetachReasonConnectionTerminated', 'FridaSessionDetachReasonDeviceLost' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSessionDetachReason class >> enumDecl [
	^ #(
			FridaSessionDetachReasonApplicationRequested 1
			FridaSessionDetachReasonProcessReplaced 0
			FridaSessionDetachReasonProcessTerminated 1
			FridaSessionDetachReasonConnectionTerminated 2
			FridaSessionDetachReasonDeviceLost 3
		)
]

{ #category : 'generated' }
FridaSessionDetachReason class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

