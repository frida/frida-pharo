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

