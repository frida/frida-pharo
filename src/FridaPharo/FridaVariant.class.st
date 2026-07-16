"
Recursive GVariant <-> Pharo marshaller.

decode: GVariant* handle -> Pharo value; encode: Pharo value -> a sunk GVariant*
the caller owns (unref after use). Mapping:
  a{sv} <-> Dictionary
  av / tuples <-> Array
  ay <-> ByteArray
  s/o/g <-> String, b <-> Boolean, d <-> Float, y/n/q/i/u/x/t/h <-> Integer.
"
Class {
	#name : 'FridaVariant',
	#superclass : 'Object',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'decoding' }
FridaVariant class >> decode: aVariantHandle [
	| typeString |
	(aVariantHandle isNil or: [ aVariantHandle isNull ]) ifTrue: [ ^ nil ].
	typeString := FridaGlue variantTypeString: aVariantHandle.
	typeString = 'v' ifTrue: [ ^ self decodeBoxed: aVariantHandle ].
	typeString = 'ay' ifTrue: [ ^ self decodeBytes: aVariantHandle ].
	(typeString beginsWith: 'a{') ifTrue: [ ^ self decodeDictionary: aVariantHandle ].
	((typeString beginsWith: 'a') or: [ typeString beginsWith: '(' ])
		ifTrue: [ ^ self decodeArray: aVariantHandle ].
	^ self decodeScalar: aVariantHandle typeString: typeString
]

{ #category : 'decoding' }
FridaVariant class >> decodeArray: aVariantHandle [
	| count array child |
	count := FridaGlue variantChildCount: aVariantHandle.
	array := Array new: count.
	1 to: count do: [ :i |
		child := FridaGlue variant: aVariantHandle child: i - 1.
		array at: i put: (self decode: child).
		FridaGlue variantUnref: child ].
	^ array
]

{ #category : 'decoding' }
FridaVariant class >> decodeBoxed: aVariantHandle [
	| inner value |
	inner := FridaGlue variantUnbox: aVariantHandle.
	value := self decode: inner.
	FridaGlue variantUnref: inner.
	^ value
]

{ #category : 'decoding' }
FridaVariant class >> decodeBytes: aVariantHandle [
	| size bytes |
	size := FridaGlue variantSize: aVariantHandle.
	bytes := ByteArray new: size.
	size > 0 ifTrue: [ FridaGlue variant: aVariantHandle copyDataTo: bytes ].
	^ bytes
]

{ #category : 'decoding' }
FridaVariant class >> decodeDictionary: aVariantHandle [
	| count dictionary entry keyHandle valueHandle |
	count := FridaGlue variantChildCount: aVariantHandle.
	dictionary := Dictionary new.
	1 to: count do: [ :i |
		entry := FridaGlue variant: aVariantHandle child: i - 1.
		keyHandle := FridaGlue variant: entry child: 0.
		valueHandle := FridaGlue variant: entry child: 1.
		dictionary at: (self decode: keyHandle) put: (self decode: valueHandle).
		FridaGlue variantUnref: keyHandle.
		FridaGlue variantUnref: valueHandle.
		FridaGlue variantUnref: entry ].
	^ dictionary
]

{ #category : 'decoding' }
FridaVariant class >> decodeScalar: aVariantHandle typeString: typeString [
	typeString = 'b' ifTrue: [ ^ (FridaGlue variantBoolean: aVariantHandle) ~= 0 ].
	typeString = 'd' ifTrue: [ ^ FridaGlue variantDouble: aVariantHandle ].
	('sog' includes: typeString first) ifTrue: [ ^ FridaGlue variantString: aVariantHandle ].
	^ FridaGlue variantInt: aVariantHandle
]

{ #category : 'encoding' }
FridaVariant class >> encode: aValue [
	"Return a sunk GVariant* the caller owns (unref after passing to C)."
	FridaObject ensureFridaInitialized.
	aValue isNil ifTrue: [ ^ self encodeDictionary: Dictionary new ].
	(aValue == true or: [ aValue == false ])
		ifTrue: [ ^ FridaGlue variantNewBoolean: (aValue ifTrue: [ 1 ] ifFalse: [ 0 ]) ].
	aValue isString ifTrue: [ ^ FridaGlue variantNewString: aValue ].
	(aValue isKindOf: ByteArray) ifTrue: [ ^ FridaGlue variantNewBytes: aValue size: aValue size ].
	aValue isInteger ifTrue: [ ^ FridaGlue variantNewInt64: aValue ].
	aValue isFloat ifTrue: [ ^ FridaGlue variantNewDouble: aValue ].
	(aValue isKindOf: Dictionary) ifTrue: [ ^ self encodeDictionary: aValue ].
	(aValue isKindOf: SequenceableCollection) ifTrue: [ ^ self encodeArray: aValue ].
	^ self error: 'FridaVariant cannot encode ', aValue printString
]

{ #category : 'encoding' }
FridaVariant class >> encodeArray: aCollection [
	| builder |
	builder := FridaGlue variantBuilderNewArray.
	aCollection do: [ :each | | element |
		element := self encode: each.
		FridaGlue variantBuilder: builder addValue: element.
		FridaGlue variantUnref: element ].
	^ FridaGlue variantBuilderEnd: builder
]

{ #category : 'encoding' }
FridaVariant class >> encodeDictionary: aDictionary [
	| builder |
	builder := FridaGlue variantBuilderNewDict.
	aDictionary keysAndValuesDo: [ :key :value | | encoded |
		encoded := self encode: value.
		FridaGlue variantBuilder: builder addKey: key asString value: encoded.
		FridaGlue variantUnref: encoded ].
	^ FridaGlue variantBuilderEnd: builder
]
