"
GENERATED binding for the Frida FridaJsCompression enumeration.
"
Class {
	#name : 'FridaJsCompression',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaJsCompressionNone', 'FridaJsCompressionTerser' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaJsCompression class >> enumDecl [
	^ #(
			FridaJsCompressionNone 0
			FridaJsCompressionTerser 1
		)
]

{ #category : 'generated' }
FridaJsCompression class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

