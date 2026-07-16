"
GENERATED binding for the Frida FridaStdio enumeration.
"
Class {
	#name : 'FridaStdio',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaStdioInherit', 'FridaStdioPipe' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaStdio class >> enumDecl [
	^ #(
			FridaStdioInherit 0
			FridaStdioPipe 1
		)
]

{ #category : 'generated' }
FridaStdio class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

