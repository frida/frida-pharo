"
GENERATED plain value snapshot of the Frida FridaPackageInstallResult.
"
Class {
	#name : 'FridaPackageInstallResult',
	#superclass : 'Object',
	#instVars : [ 'packages' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageInstallResult >> packages [
	^ packages
]

{ #category : 'generated' }
FridaPackageInstallResult >> setPackages: aValue [
	packages := aValue
]

{ #category : 'generated' }
FridaPackageInstallResult class >> readPackagesRaw: aHandle [
	^ self ffiCall: #(void* frida_package_install_result_get_packages (void* aHandle)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallResult class >> readPackages: aHandle [
	| result |
	result := self readPackagesRaw: aHandle.
	^ (FridaPackageList fromBorrowedHandle: (result)) asFridaList
]

{ #category : 'generated' }
FridaPackageInstallResult class >> fromHandle: aHandle owned: isOwned [
	| instance |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	instance := self new.
	instance setPackages: (self readPackages: aHandle).
	isOwned ifTrue: [ FridaObject unref: aHandle ].
	^ instance
]

{ #category : 'generated' }
FridaPackageInstallResult class >> fromHandle: aHandle [
	^ self fromHandle: aHandle owned: true
]

