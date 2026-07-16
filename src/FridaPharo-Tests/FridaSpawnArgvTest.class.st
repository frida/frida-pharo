"
strv input: spawn /bin/sh with an explicit argv (via SpawnOptions) that writes a
file, then assert the file appeared after resume -- proving the gchar**+length
argv actually took effect.
"
Class {
	#name : 'FridaSpawnArgvTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaSpawnArgvTest >> testSpawnWithArgvWritesFile [
	| device options marker file pid remaining |
	marker := '/tmp/frida_pharo_spawn_', 1000000 atRandom printString, '.txt'.
	file := marker asFileReference.
	file ensureDelete.

	device := Frida localDevice.
	options := FridaSpawnOptions new.
	options argv: { '/bin/sh'. '-c'. 'echo ok > ', marker }.

	pid := device spawn: '/bin/sh' options: options.
	device resume: pid.

	remaining := 100.
	[ file exists not and: [ remaining > 0 ] ]
		whileTrue: [ remaining := remaining - 1. (Delay forMilliseconds: 50) wait ].

	[ self assert: file exists.
	  self assert: (file contents trimBoth) equals: 'ok' ]
		ensure: [ file ensureDelete ]
]
