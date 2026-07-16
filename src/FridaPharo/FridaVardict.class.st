"
GHashTable<utf8, GVariant> <-> Pharo Dictionary, built on the FridaVariant codec.

encode: Dictionary -> a GHashTable* the caller owns (unref after passing to C);
the table owns its keys and (sunk) GVariant values. decode: GHashTable* handle
-> Dictionary of decoded values.
"
Class {
	#name : 'FridaVardict',
	#superclass : 'Object',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'encoding' }
FridaVardict class >> encode: aDictionary [
	"Return a GHashTable* the caller owns (FridaGlue vardictUnref: after use)."
	| table |
	FridaObject ensureFridaInitialized.
	table := FridaGlue vardictNew.
	aDictionary ifNotNil: [
		aDictionary keysAndValuesDo: [ :key :value |
			"vardictInsert takes ownership of the sunk variant, so we do not unref it."
			FridaGlue vardict: table insertKey: key asString value: (FridaVariant encode: value) ] ].
	^ table
]

{ #category : 'decoding' }
FridaVardict class >> decode: aTableHandle [
	| keysHandle count dictionary key |
	(aTableHandle isNil or: [ aTableHandle isNull ]) ifTrue: [ ^ nil ].
	keysHandle := FridaGlue vardictDupKeys: aTableHandle.
	count := FridaGlue strvLength: keysHandle.
	dictionary := Dictionary new.
	1 to: count do: [ :i |
		key := FridaGlue strv: keysHandle get: i - 1.
		"lookup returns a borrowed GVariant owned by the table; do not unref."
		dictionary at: key put: (FridaVariant decode: (FridaGlue vardict: aTableHandle lookup: key)) ].
	FridaGlue strvFree: keysHandle.
	^ dictionary
]
