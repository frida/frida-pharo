"
GENERATED binding for the Frida FridaOutputFormat enumeration.
"
Class {
	#name : 'FridaOutputFormat',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaOutputFormatUnescaped', 'FridaOutputFormatHexBytes', 'FridaOutputFormatCString' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaOutputFormat class >> enumDecl [
	^ #(
			FridaOutputFormatUnescaped 0
			FridaOutputFormatHexBytes 1
			FridaOutputFormatCString 2
		)
]

{ #category : 'generated' }
FridaOutputFormat class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaOutputFormat class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaOutputFormat class >> symbolValues [
	^ { #unescaped -> FridaOutputFormatUnescaped. #hexBytes -> FridaOutputFormatHexBytes. #cString -> FridaOutputFormatCString } asDictionary
]

