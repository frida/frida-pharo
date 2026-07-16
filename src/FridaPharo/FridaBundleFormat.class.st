"
GENERATED binding for the Frida FridaBundleFormat enumeration.
"
Class {
	#name : 'FridaBundleFormat',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaBundleFormatEsm', 'FridaBundleFormatIife' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaBundleFormat class >> enumDecl [
	^ #(
			FridaBundleFormatEsm 0
			FridaBundleFormatIife 1
		)
]

{ #category : 'generated' }
FridaBundleFormat class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

