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
		spec
			package: 'FridaPharo';
			package: 'FridaPharo-Tests' with: [ spec requires: 'FridaPharo' ].
		spec
			group: 'core' with: #('FridaPharo');
			group: 'tests' with: #('FridaPharo-Tests');
			group: 'default' with: #('FridaPharo' 'FridaPharo-Tests') ]
]
