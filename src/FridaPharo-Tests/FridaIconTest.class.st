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

{ #category : 'tests' }
FridaIconTest >> testPngDictionaryOmitsDimensions [
	"A png icon carries only the encoded bytes; width/height are absent."
	| icon |
	icon := FridaIcon fromDictionary: {
		'format' -> 'png'.
		'image' -> #[ 137 80 78 71 ] } asDictionary.
	self assert: icon format equals: 'png'.
	self assert: icon image equals: #[ 137 80 78 71 ]
]
