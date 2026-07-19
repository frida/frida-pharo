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

{ #category : 'generated' }
FridaSpawnGatingDisabledReason class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaSpawnGatingDisabledReason class >> symbolValues [
	^ { #applicationRequested -> FridaSpawnGatingDisabledReasonApplicationRequested. #watchdogTimeout -> FridaSpawnGatingDisabledReasonWatchdogTimeout } asDictionary
]

