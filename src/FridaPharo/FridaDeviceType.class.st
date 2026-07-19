"
GENERATED binding for the Frida FridaDeviceType enumeration.
"
Class {
	#name : 'FridaDeviceType',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaDeviceTypeLocal', 'FridaDeviceTypeRemote', 'FridaDeviceTypeUsb' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaDeviceType class >> enumDecl [
	^ #(
			FridaDeviceTypeLocal 0
			FridaDeviceTypeRemote 1
			FridaDeviceTypeUsb 2
		)
]

{ #category : 'generated' }
FridaDeviceType class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

{ #category : 'generated' }
FridaDeviceType class >> fromSymbol: aSymbol [
	^ self symbolValues at: aSymbol
]

{ #category : 'generated' }
FridaDeviceType class >> symbolValues [
	^ { #local -> FridaDeviceTypeLocal. #remote -> FridaDeviceTypeRemote. #usb -> FridaDeviceTypeUsb } asDictionary
]

