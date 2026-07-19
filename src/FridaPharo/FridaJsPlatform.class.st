"
GENERATED binding for the Frida FridaJsPlatform enumeration.
"
Class {
	#name : 'FridaJsPlatform',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaJsPlatformGum', 'FridaJsPlatformBrowser', 'FridaJsPlatformNeutral' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaJsPlatform class >> enumDecl [
	^ #(
			FridaJsPlatformGum 0
			FridaJsPlatformBrowser 1
			FridaJsPlatformNeutral 2
		)
]

{ #category : 'generated' }
FridaJsPlatform class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaJsPlatform class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaJsPlatform class >> symbolValues [
	^ { #gum -> FridaJsPlatformGum. #browser -> FridaJsPlatformBrowser. #neutral -> FridaJsPlatformNeutral } asDictionary
]

