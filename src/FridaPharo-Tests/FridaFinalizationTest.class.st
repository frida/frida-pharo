"
Finalization-under-GC stress: allocate and drop many wrapped GObjects (each
registering an unref-on-finalize), use each, then force GC so the finalizers
run. Asserts the loop completes and GC does not crash on the balanced unrefs.
"
Class {
	#name : 'FridaFinalizationTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaFinalizationTest >> testAllocateDropManyThenGc [
	| used |
	FridaObject ensureFridaInitialized.
	used := 0.
	5000 timesRepeat: [ | options |
		options := FridaSpawnOptions new.
		options cwd: '/tmp'.
		options cwd = '/tmp' ifTrue: [ used := used + 1 ] ].
	Smalltalk garbageCollect.
	Smalltalk garbageCollect.
	self assert: used equals: 5000
]
