"
Enumerate the local device's processes and exercise the generated Pharo
collection protocol on the returned FridaProcessList (do:, asArray, at:, size).
The current process is always present, so the list is non-empty and every
element is a live FridaProcess whose pid/name marshal back.
"
Class {
	#name : 'FridaProcessListTest',
	#superclass : 'FridaTestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaProcessListTest >> testEnumerateProcessesCollectionProtocol [
	| device processes viaDo pids names |
	device := Frida localDevice.
	processes := device enumerateProcesses: nil.

	self deny: processes isEmpty.
	self assert: processes size > 0.

	"do: visits every element."
	viaDo := OrderedCollection new.
	processes do: [ :each | viaDo add: each ].
	self assert: viaDo size equals: processes size.

	"asArray/collect: yield the same cardinality and typed elements."
	pids := processes collect: [ :each | each pid ].
	self assert: pids size equals: processes size.
	self assert: (pids allSatisfy: [ :pid | pid isKindOf: Integer ]).

	names := processes asArray collect: [ :each | each name ].
	self assert: (names allSatisfy: [ :name | name isKindOf: String ]).

	"at: is 1-based and agrees with do: ordering."
	self assert: (processes at: 1) pid equals: viaDo first pid
]
