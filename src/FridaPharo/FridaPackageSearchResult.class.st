"
GENERATED plain value snapshot of the Frida FridaPackageSearchResult.
"
Class {
	#name : 'FridaPackageSearchResult',
	#superclass : 'Object',
	#instVars : [ 'packages', 'total' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageSearchResult >> packages [
	^ packages
]

{ #category : 'generated' }
FridaPackageSearchResult >> setPackages: aValue [
	packages := aValue
]

{ #category : 'generated' }
FridaPackageSearchResult >> total [
	^ total
]

{ #category : 'generated' }
FridaPackageSearchResult >> setTotal: aValue [
	total := aValue
]

{ #category : 'generated' }
FridaPackageSearchResult class >> readPackagesRaw: aHandle [
	^ self ffiCall: #(void* frida_package_search_result_get_packages (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageSearchResult class >> readPackages: aHandle [
	| result |
	result := self readPackagesRaw: aHandle.
	^ (FridaPackageList fromBorrowedHandle: (result)) asArray
]

{ #category : 'generated' }
FridaPackageSearchResult class >> readTotal: aHandle [
	^ self ffiCall: #(uint frida_package_search_result_get_total (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageSearchResult class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setPackages: (self readPackages: aHandle).
	instance setTotal: (self readTotal: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaPackageSearchResult class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
]

