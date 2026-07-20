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
FridaIconTest >> testRgbaUndoesPremultipliedAlpha [
	"A half-opaque red edge pixel arrives premultiplied (127 127 0 0 128) and must
	 decode back to full-intensity red at alpha 0.5, not the darkened 127."
	| icon form pixel |
	icon := FridaIcon fromDictionary: {
		'format' -> 'rgba'.
		'width' -> 1.
		'height' -> 1.
		'image' -> #[ 127 0 0 128 ] } asDictionary.
	form := icon asForm.
	pixel := form pixelValueAt: 0 @ 0.
	self assert: ((pixel bitShift: -24) bitAnd: 16rFF) equals: 128.
	self assert: (((pixel bitShift: -16) bitAnd: 16rFF) >= 253)
]

{ #category : 'tests' }
FridaIconTest >> testKeepsStraightAlphaWhenNotPremultiplied [
	"A bright semi-transparent pixel (colour channel above its alpha) is genuine
	 straight alpha, e.g. an Android icon, and must be left untouched."
	| icon pixel |
	icon := FridaIcon fromDictionary: {
		'format' -> 'rgba'. 'width' -> 1. 'height' -> 1.
		'image' -> #[ 255 0 0 128 ] } asDictionary.
	pixel := icon asForm pixelValueAt: 0 @ 0.
	self assert: ((pixel bitShift: -24) bitAnd: 16rFF) equals: 128.
	self assert: ((pixel bitShift: -16) bitAnd: 16rFF) equals: 255
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
