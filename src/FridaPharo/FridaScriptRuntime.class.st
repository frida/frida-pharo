"
GENERATED binding for the Frida FridaScriptRuntime enumeration.
"
Class {
	#name : 'FridaScriptRuntime',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaScriptRuntimeDefault', 'FridaScriptRuntimeQjs', 'FridaScriptRuntimeV8' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaScriptRuntime class >> enumDecl [
	^ #(
			FridaScriptRuntimeDefault 0
			FridaScriptRuntimeQjs 1
			FridaScriptRuntimeV8 2
		)
]

{ #category : 'generated' }
FridaScriptRuntime class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

