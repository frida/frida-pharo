"
GENERATED binding for the Frida FridaTypeCheckMode enumeration.
"
Class {
	#name : 'FridaTypeCheckMode',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaTypeCheckModeFull', 'FridaTypeCheckModeNone' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaTypeCheckMode class >> enumDecl [
	^ #(
			FridaTypeCheckModeFull 0
			FridaTypeCheckModeNone 1
		)
]

{ #category : 'generated' }
FridaTypeCheckMode class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaTypeCheckMode class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaTypeCheckMode class >> symbolValues [
	^ { #full -> FridaTypeCheckModeFull. #none -> FridaTypeCheckModeNone } asDictionary
]

