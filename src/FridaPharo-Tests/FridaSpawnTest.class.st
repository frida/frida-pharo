"
spawn -> resume -> kill of /bin/sh on the local device, exercising scalar async
returns (the spawned pid) and int-arg async ops.
"
Class {
	#name : 'FridaSpawnTest',
	#superclass : 'FridaTestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaSpawnTest >> testSpawnResumeKill [
	| device pid |
	device := Frida localDevice.
	pid := device spawn: '/bin/sh'.
	self assert: (pid isKindOf: Integer).
	self assert: pid > 0.
	[ device resume: pid ] ensure: [ device kill: pid ]
]
