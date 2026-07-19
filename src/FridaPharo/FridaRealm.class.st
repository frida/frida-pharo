"
GENERATED binding for the Frida FridaRealm enumeration.
"
Class {
	#name : 'FridaRealm',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaRealmNative', 'FridaRealmEmulated' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaRealm class >> enumDecl [
	^ #(
			FridaRealmNative 0
			FridaRealmEmulated 1
		)
]

{ #category : 'generated' }
FridaRealm class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaRealm class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaRealm class >> symbolValues [
	^ { #native -> FridaRealmNative. #emulated -> FridaRealmEmulated } asDictionary
]

