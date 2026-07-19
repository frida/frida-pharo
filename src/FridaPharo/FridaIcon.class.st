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
	^ format = 'png'
		ifTrue: [ self formFromPng ]
		ifFalse: [ self formFromRgba ]
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
