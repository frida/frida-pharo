"
GENERATED binding for the Frida FridaRuntime enumeration.
"
Class {
	#name : 'FridaRuntime',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaRuntimeGlib', 'FridaRuntimeOther' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaRuntime class >> enumDecl [
	^ #(
			FridaRuntimeGlib 0
			FridaRuntimeOther 1
		)
]

{ #category : 'generated' }
FridaRuntime class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaRuntime class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaRuntime class >> symbolValues [
	^ { #glib -> FridaRuntimeGlib. #other -> FridaRuntimeOther } asDictionary
]

