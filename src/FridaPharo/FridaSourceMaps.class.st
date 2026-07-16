"
GENERATED binding for the Frida FridaSourceMaps enumeration.
"
Class {
	#name : 'FridaSourceMaps',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaSourceMapsIncluded', 'FridaSourceMapsOmitted' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSourceMaps class >> enumDecl [
	^ #(
			FridaSourceMapsIncluded 0
			FridaSourceMapsOmitted 1
		)
]

{ #category : 'generated' }
FridaSourceMaps class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

