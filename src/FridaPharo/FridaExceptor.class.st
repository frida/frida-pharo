"
GENERATED binding for the Frida FridaExceptor enumeration.
"
Class {
	#name : 'FridaExceptor',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaExceptorFull', 'FridaExceptorHandlerOnly', 'FridaExceptorOff' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaExceptor class >> enumDecl [
	^ #(
			FridaExceptorFull 0
			FridaExceptorHandlerOnly 1
			FridaExceptorOff 2
		)
]

{ #category : 'generated' }
FridaExceptor class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

