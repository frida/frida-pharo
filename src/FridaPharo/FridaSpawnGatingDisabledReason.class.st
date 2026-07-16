"
GENERATED binding for the Frida FridaSpawnGatingDisabledReason enumeration.
"
Class {
	#name : 'FridaSpawnGatingDisabledReason',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaSpawnGatingDisabledReasonApplicationRequested', 'FridaSpawnGatingDisabledReasonWatchdogTimeout' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSpawnGatingDisabledReason class >> enumDecl [
	^ #(
			FridaSpawnGatingDisabledReasonApplicationRequested 1
			FridaSpawnGatingDisabledReasonWatchdogTimeout 0
		)
]

{ #category : 'generated' }
FridaSpawnGatingDisabledReason class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

