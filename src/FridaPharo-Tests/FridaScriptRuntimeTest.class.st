"
Verifies the generated FFIExternalEnumeration binding for FridaScriptRuntime.
"
Class {
	#name : 'FridaScriptRuntimeTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaScriptRuntimeTest >> testDeclaredValues [
	| decl |
	decl := FridaScriptRuntime enumDecl.
	self assert: (decl at: (decl indexOf: #FridaScriptRuntimeDefault) + 1) equals: 0.
	self assert: (decl at: (decl indexOf: #FridaScriptRuntimeQjs) + 1) equals: 1.
	self assert: (decl at: (decl indexOf: #FridaScriptRuntimeV8) + 1) equals: 2
]

{ #category : 'tests' }
FridaScriptRuntimeTest >> testEnumerationLookup [
	self assert: FridaScriptRuntime FridaScriptRuntimeQjs value equals: 1.
	self assert: FridaScriptRuntime FridaScriptRuntimeV8 value equals: 2
]
