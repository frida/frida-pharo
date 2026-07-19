"
GENERATED plain value snapshot of the Frida FridaPackage.
"
Class {
	#name : 'FridaPackage',
	#superclass : 'Object',
	#instVars : [ 'name', 'version', 'description', 'url' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackage >> name [
	^ name
]

{ #category : 'generated' }
FridaPackage >> setName: aValue [
	name := aValue
]

{ #category : 'generated' }
FridaPackage >> version [
	^ version
]

{ #category : 'generated' }
FridaPackage >> setVersion: aValue [
	version := aValue
]

{ #category : 'generated' }
FridaPackage >> description [
	^ description
]

{ #category : 'generated' }
FridaPackage >> setDescription: aValue [
	description := aValue
]

{ #category : 'generated' }
FridaPackage >> url [
	^ url
]

{ #category : 'generated' }
FridaPackage >> setUrl: aValue [
	url := aValue
]

{ #category : 'generated' }
FridaPackage class >> readName: aHandle [
	^ self ffiCall: #(String frida_package_get_name (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackage class >> readVersion: aHandle [
	^ self ffiCall: #(String frida_package_get_version (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackage class >> readDescription: aHandle [
	^ self ffiCall: #(String frida_package_get_description (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackage class >> readUrl: aHandle [
	^ self ffiCall: #(String frida_package_get_url (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackage class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setName: (self readName: aHandle).
	instance setVersion: (self readVersion: aHandle).
	instance setDescription: (self readDescription: aHandle).
	instance setUrl: (self readUrl: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaPackage class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
]

