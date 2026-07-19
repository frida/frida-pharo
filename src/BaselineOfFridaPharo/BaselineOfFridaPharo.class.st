Class {
	#name : 'BaselineOfFridaPharo',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfFridaPharo',
	#package : 'BaselineOfFridaPharo'
}

{ #category : 'baselines' }
BaselineOfFridaPharo >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec postLoadDoIt: #initializeEnumerations.
		spec
			package: 'FridaPharo';
			package: 'FridaPharo-Tests' with: [ spec requires: 'FridaPharo' ].
		spec
			group: 'core' with: #('FridaPharo');
			group: 'tests' with: #('FridaPharo-Tests');
			group: 'default' with: #('FridaPharo' 'FridaPharo-Tests') ]
]

{ #category : 'actions' }
BaselineOfFridaPharo >> initializeEnumerations [
	"Metacello loads classes without sending their class-side #initialize, so the
	 generated enumerations never build their accessors. Do it after load."
	(FFIExternalEnumeration allSubclasses
		select: [ :each | each package name = 'FridaPharo' ])
		do: [ :each | each initialize ]
]
