"
End-to-end smoke test of the FFI path: calls frida_version_string() through
the generated Frida facade and the hand-written FridaLibrary.
"
Class {
	#name : 'FridaVersionTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaVersionTest >> testVersionIsNonEmptyString [
	| v |
	v := Frida version.
	self assert: v isString.
	self deny: v isEmpty
]

{ #category : 'tests' }
FridaVersionTest >> testVersionMatchesCore [
	"When the harness passes the frida-core version via FRIDA_EXPECTED_VERSION,
	 assert the FFI call returns exactly that."
	| expected |
	expected := OSEnvironment current at: 'FRIDA_EXPECTED_VERSION' ifAbsent: [ nil ].
	expected ifNil: [ ^ self skip ].
	self assert: Frida version equals: expected
]
