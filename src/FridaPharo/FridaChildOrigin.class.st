"
GENERATED binding for the Frida FridaChildOrigin enumeration.
"
Class {
	#name : 'FridaChildOrigin',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaChildOriginFork', 'FridaChildOriginExec', 'FridaChildOriginSpawn' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaChildOrigin class >> enumDecl [
	^ #(
			FridaChildOriginFork 0
			FridaChildOriginExec 1
			FridaChildOriginSpawn 2
		)
]

{ #category : 'generated' }
FridaChildOrigin class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaChildOrigin class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaChildOrigin class >> symbolValues [
	^ { #fork -> FridaChildOriginFork. #exec -> FridaChildOriginExec. #spawn -> FridaChildOriginSpawn } asDictionary
]

