"
Hand-written collection returned by the enumerate* facades. It is an ordinary
OrderedCollection -- do:, select:, collect:, at:, asArray all behave as usual --
that additionally renders its elements' icons inline in the GT inspector when the
elements carry any (processes and applications do).

Filter to only the entries that have an icon with e.g.

	device enumerateProcesses select: [ :each | each hasIcon ]
"
Class {
	#name : 'FridaList',
	#superclass : 'OrderedCollection',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'inspecting' }
FridaList >> gtIconItemsFor: aView [
	<gtView>
	(self anySatisfy: [ :each | each respondsTo: #preferredIcon ]) ifFalse: [ ^ aView empty ].
	^ aView columnedList
		title: 'Items';
		priority: 5;
		items: [ self itemsForInspector ];
		column: 'Icon' icon: [ :each | self iconElementFor: each ] width: 44;
		column: 'Item' text: [ :each | each printString ]
]

{ #category : 'inspecting' }
FridaList >> itemsForInspector [
	"Entries that opt in (processes, applications) sort with icon-bearing ones first,
	 alphabetical by name within each group; everything else keeps its natural order."
	self sortsForInspector ifFalse: [ ^ self ].
	^ self asSortedCollection: [ :a :b |
		a hasIcon = b hasIcon
			ifTrue: [ (a name ifNil: [ '' ]) asLowercase <= (b name ifNil: [ '' ]) asLowercase ]
			ifFalse: [ a hasIcon ] ]
]

{ #category : 'inspecting' }
FridaList >> sortsForInspector [
	^ self notEmpty
		and: [ (self anyOne respondsTo: #fridaListSortsByName) and: [ self anyOne fridaListSortsByName ] ]
]

{ #category : 'inspecting' }
FridaList >> iconElementFor: anElement [
	| icon form scaled |
	icon := (anElement respondsTo: #preferredIcon) ifTrue: [ anElement preferredIcon ] ifFalse: [ nil ].
	icon isNil ifTrue: [ ^ BlElement new ].
	form := icon asForm.
	scaled := form asElement.
	scaled transformDo: [ :t | t scaleBy: 32.0 / (form width max: form height) ].
	^ BlElement new
		size: 32 @ 32;
		margin: (BlInsets top: 4 left: 2 bottom: 4 right: 6);
		clipChildren: true;
		layout: BlLinearLayout horizontal alignCenter;
		addChild: scaled;
		yourself
]
