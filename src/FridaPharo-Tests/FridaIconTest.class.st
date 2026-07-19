"
FridaIcon builds a Pharo Form from a parameters 'icons' entry, so the GT
inspector can render it graphically.
"
Class {
	#name : 'FridaIconTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaIconTest >> testRgbaAsForm [
	| icon form |
	icon := FridaIcon fromDictionary: {
		'format' -> 'rgba'.
		'width' -> 2.
		'height' -> 1.
		'image' -> #[ 255 0 0 255 0 255 0 255 ] } asDictionary.
	form := icon asForm.
	self assert: form extent equals: 2 @ 1.
	self assert: (form pixelValueAt: 0 @ 0) equals: 16rFFFF0000.
	self assert: (form pixelValueAt: 1 @ 0) equals: 16rFF00FF00
]
