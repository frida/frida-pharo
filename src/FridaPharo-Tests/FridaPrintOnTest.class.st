"
The generated #printOn: shows a type's identifying properties (data-driven per
customization.print_specs), so the inspector/debugger display something useful.
"
Class {
	#name : 'FridaPrintOnTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaPrintOnTest >> testDevicePrintStringIncludesIdentity [
	| device printed |
	device := Frida localDevice.
	printed := device printString.
	self assert: (printed includesSubstring: 'FridaDevice').
	self assert: (printed includesSubstring: 'id=').
	self assert: (printed includesSubstring: 'name=').
	"local device id is the literal 'local'"
	self assert: (printed includesSubstring: 'local')
]

{ #category : 'tests' }
FridaPrintOnTest >> testProcessPrintStringIncludesPid [
	| device processes printed |
	device := Frida localDevice.
	processes := device enumerateProcesses: nil.
	printed := (processes at: 1) printString.
	self assert: (printed includesSubstring: 'FridaProcess').
	self assert: (printed includesSubstring: 'pid=').
	self assert: (printed includesSubstring: 'name=')
]
