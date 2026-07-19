"
GENERATED binding for the Frida FridaRelayKind enumeration.
"
Class {
	#name : 'FridaRelayKind',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaRelayKindTurnUdp', 'FridaRelayKindTurnTcp', 'FridaRelayKindTurnTls' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaRelayKind class >> enumDecl [
	^ #(
			FridaRelayKindTurnUdp 0
			FridaRelayKindTurnTcp 1
			FridaRelayKindTurnTls 2
		)
]

{ #category : 'generated' }
FridaRelayKind class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaRelayKind class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaRelayKind class >> symbolValues [
	^ { #turnUdp -> FridaRelayKindTurnUdp. #turnTcp -> FridaRelayKindTurnTcp. #turnTls -> FridaRelayKindTurnTls } asDictionary
]

