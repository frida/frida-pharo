"
GENERATED binding for the Frida FridaSpawnGatingScope enumeration.
"
Class {
	#name : 'FridaSpawnGatingScope',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaSpawnGatingScopeDefault', 'FridaSpawnGatingScopeApplications', 'FridaSpawnGatingScopeProcesses' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSpawnGatingScope class >> enumDecl [
	^ #(
			FridaSpawnGatingScopeDefault 0
			FridaSpawnGatingScopeApplications 1
			FridaSpawnGatingScopeProcesses 2
		)
]

{ #category : 'generated' }
FridaSpawnGatingScope class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

