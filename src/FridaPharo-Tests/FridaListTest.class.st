"
Unit tests for FridaList's inspector ordering: entries that carry an icon sort
ahead of those that don't, alphabetically (case-insensitively) within each group.
"
Class {
	#name : 'FridaListTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'helpers' }
FridaListTest >> processNamed: aName withIcon: hasIcon [
	| parameters |
	parameters := Dictionary new.
	hasIcon ifTrue: [
		parameters at: 'icons' put: { {
			'format' -> 'rgba'. 'width' -> 16. 'height' -> 16.
			'image' -> (ByteArray new: 16 * 16 * 4) } asDictionary } ].
	^ FridaProcess new
		setName: aName;
		setParameters: parameters;
		yourself
]

{ #category : 'tests' }
FridaListTest >> testSortedForInspectorGroupsIconsFirstThenAlphabetical [
	| list names |
	list := FridaList withAll: {
		self processNamed: 'Zebra' withIcon: false.
		self processNamed: 'apple' withIcon: true.
		self processNamed: 'Mango' withIcon: true.
		self processNamed: 'banana' withIcon: false }.

	names := list itemsForInspector collect: [ :each | each name ].

	self assert: names asArray equals: #( 'apple' 'Mango' 'banana' 'Zebra' )
]

{ #category : 'tests' }
FridaListTest >> testItemsForInspectorKeepsNaturalOrderWhenNotOptedIn [
	"Elements that don't opt into sorting (e.g. devices) keep their natural order."
	| list |
	list := FridaList withAll: #( 'zulu' 'alpha' 'mike' ).
	self assert: list itemsForInspector asArray equals: #( 'zulu' 'alpha' 'mike' )
]
