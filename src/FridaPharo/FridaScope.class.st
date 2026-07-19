"
GENERATED binding for the Frida FridaScope enumeration.
"
Class {
	#name : 'FridaScope',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaScopeMinimal', 'FridaScopeMetadata', 'FridaScopeFull' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaScope class >> enumDecl [
	^ #(
			FridaScopeMinimal 0
			FridaScopeMetadata 1
			FridaScopeFull 2
		)
]

{ #category : 'generated' }
FridaScope class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaScope class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaScope class >> symbolValues [
	^ { #minimal -> FridaScopeMinimal. #metadata -> FridaScopeMetadata. #full -> FridaScopeFull } asDictionary
]

