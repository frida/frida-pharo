"
Hand-written value type for an icon carried in a Frida process/application's
parameters (an entry of the 'icons' array: format, width, height, image bytes).
Renders graphically in the GT inspector via #asForm.
"
Class {
	#name : 'FridaIcon',
	#superclass : 'Object',
	#instVars : [ 'format', 'width', 'height', 'image' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'instance creation' }
FridaIcon class >> fromDictionary: aDictionary [
	^ self new
		setFormat: (aDictionary at: 'format');
		setWidth: (aDictionary at: 'width');
		setHeight: (aDictionary at: 'height');
		setImage: (aDictionary at: 'image');
		yourself
]

{ #category : 'converting' }
FridaIcon >> asForm [
	^ format = 'png'
		ifTrue: [ self formFromPng ]
		ifFalse: [ self formFromRgba ]
]

{ #category : 'converting' }
FridaIcon >> formFromRgba [
	| form bits |
	form := Form extent: width @ height depth: 32.
	bits := form bits.
	1 to: width * height do: [ :pixel |
		| base |
		base := (pixel - 1) * 4.
		bits at: pixel put:
			((image at: base + 4) bitShift: 24)
			+ ((image at: base + 1) bitShift: 16)
			+ ((image at: base + 2) bitShift: 8)
			+ (image at: base + 3) ].
	^ form
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
FridaIcon >> format [
	^ format
]

{ #category : 'accessing' }
FridaIcon >> setFormat: aString [
	format := aString
]

{ #category : 'accessing' }
FridaIcon >> width [
	^ width
]

{ #category : 'accessing' }
FridaIcon >> setWidth: anInteger [
	width := anInteger
]

{ #category : 'accessing' }
FridaIcon >> height [
	^ height
]

{ #category : 'accessing' }
FridaIcon >> setHeight: anInteger [
	height := anInteger
]

{ #category : 'accessing' }
FridaIcon >> image [
	^ image
]

{ #category : 'accessing' }
FridaIcon >> setImage: aByteArray [
	image := aByteArray
]

{ #category : 'printing' }
FridaIcon >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('; print: width; nextPut: $x; print: height; nextPutAll: ' '; nextPutAll: format; nextPut: $)
]
