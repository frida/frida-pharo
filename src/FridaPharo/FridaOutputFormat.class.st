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

