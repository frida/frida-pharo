"
Options ergonomics: a configuration block explodes into the generated options
GObject, so callers set options with real setters instead of building one by
hand.
"
Class {
	#name : 'FridaOptionsTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaOptionsTest >> testConfiguredByAppliesSetters [
	| options |
	options := FridaSpawnOptions configuredBy: [ :o |
		o argv: #('/bin/sh' '-c' 'true').
		o cwd: '/tmp' ].
	self assert: options argv equals: #('/bin/sh' '-c' 'true').
	self assert: options cwd equals: '/tmp'
]

{ #category : 'tests' }
FridaOptionsTest >> testConfiguredByEmptyBlock [
	self assert: (FridaSpawnOptions configuredBy: [ :o | ]) notNil
]

{ #category : 'tests' }
FridaOptionsTest >> testDefaultOptionsOverloadExists [
	"An options-taking method gets a no-options overload that passes nil."
	self assert: (FridaDevice canUnderstand: #enumerateProcesses).
	self assert: (FridaDevice canUnderstand: #spawn:)
]
