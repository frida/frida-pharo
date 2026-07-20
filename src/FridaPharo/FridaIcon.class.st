"
Hand-written value type for an icon carried in a Frida process/application's
parameters (an entry of the 'icons' array). An 'rgba' icon carries its width,
height and raw pixels; a 'png' icon carries only the encoded bytes, its
dimensions living inside them. Renders graphically in the GT inspector.
"
Class {
	#name : 'FridaIcon',
	#superclass : 'Object',
	#instVars : [ 'format', 'width', 'height', 'image', 'form' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'instance creation' }
FridaIcon class >> fromDictionary: aDictionary [
	^ self new
		setFormat: (aDictionary at: 'format');
		setWidth: (aDictionary at: 'width' ifAbsent: [ nil ]);
		setHeight: (aDictionary at: 'height' ifAbsent: [ nil ]);
		setImage: (aDictionary at: 'image');
		yourself
]

{ #category : 'converting' }
FridaIcon >> asForm [
	^ form ifNil: [ form := self decodeForm ]
]

{ #category : 'converting' }
FridaIcon >> decodeForm [
	"A Pharo Form is straight alpha, but frida's rgba icons and the PNGs Apple's
	 device APIs hand back are both premultiplied, which makes anti-aliased edges
	 look blended against black over a light background. Undo it when detected;
	 genuinely-straight icons (e.g. Android's) are left alone."
	| decoded |
	decoded := format = 'png'
		ifTrue: [ self formFromPng ]
		ifFalse: [ self formFromRgba ].
	^ (self isPremultiplied: decoded)
		ifTrue: [ self straightAlpha: decoded ]
		ifFalse: [ decoded ]
]

{ #category : 'converting' }
FridaIcon >> formFromRgba [
	| decoded bits |
	decoded := Form extent: width @ height depth: 32.
	bits := decoded bits.
	1 to: width * height do: [ :pixel |
		| base |
		base := (pixel - 1) * 4.
		bits at: pixel put:
			((image at: base + 4) bitShift: 24)
			+ ((image at: base + 1) bitShift: 16)
			+ ((image at: base + 2) bitShift: 8)
			+ (image at: base + 3) ].
	^ decoded
]

{ #category : 'converting' }
FridaIcon >> formFromPng [
	^ ImageReadWriter formFromStream: image readStream
]

{ #category : 'converting' }
FridaIcon >> isPremultiplied: aForm [
	"Premultiplied data never has a colour channel exceeding its alpha."
	aForm bits do: [ :pixel |
		| alpha |
		alpha := (pixel bitShift: -24) bitAnd: 255.
		(((pixel bitShift: -16) bitAnd: 255) > alpha
			or: [ ((pixel bitShift: -8) bitAnd: 255) > alpha
			or: [ (pixel bitAnd: 255) > alpha ] ]) ifTrue: [ ^ false ] ].
	^ true
]

{ #category : 'converting' }
FridaIcon >> straightAlpha: aForm [
	| result inBits outBits |
	result := Form extent: aForm extent depth: 32.
	inBits := aForm bits.
	outBits := result bits.
	1 to: inBits size do: [ :i |
		| pixel alpha |
		pixel := inBits at: i.
		alpha := (pixel bitShift: -24) bitAnd: 255.
		outBits at: i put:
			(alpha bitShift: 24)
			+ ((self straighten: ((pixel bitShift: -16) bitAnd: 255) over: alpha) bitShift: 16)
			+ ((self straighten: ((pixel bitShift: -8) bitAnd: 255) over: alpha) bitShift: 8)
			+ (self straighten: (pixel bitAnd: 255) over: alpha) ].
	^ result
]

{ #category : 'converting' }
FridaIcon >> straighten: aChannel over: anAlpha [
	^ anAlpha = 0 ifTrue: [ 0 ] ifFalse: [ (aChannel * 255 // anAlpha) min: 255 ]
]

{ #category : 'inspecting' }
FridaIcon >> gtImageFor: aView [
	<gtView>
	^ aView explicit
		title: 'Icon';
		priority: 20;
		stencil: [ self asForm asElement ]
]

{ #category : 'accessing' }
FridaIcon >> width [
	^ width ifNil: [ self asForm width ]
]

{ #category : 'accessing' }
FridaIcon >> height [
	^ height ifNil: [ self asForm height ]
]

{ #category : 'accessing' }
FridaIcon >> format [
	^ format
]

{ #category : 'accessing' }
FridaIcon >> image [
	^ image
]

{ #category : 'accessing' }
FridaIcon >> setFormat: aString [
	format := aString
]

{ #category : 'accessing' }
FridaIcon >> setWidth: anIntegerOrNil [
	width := anIntegerOrNil
]

{ #category : 'accessing' }
FridaIcon >> setHeight: anIntegerOrNil [
	height := anIntegerOrNil
]

{ #category : 'accessing' }
FridaIcon >> setImage: aByteArray [
	image := aByteArray
]

{ #category : 'printing' }
FridaIcon >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('; nextPutAll: format; nextPut: $)
]
