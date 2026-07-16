"
GENERATED binding for the Frida FridaPackageInstallResult GObject.
"
Class {
	#name : 'FridaPackageInstallResult',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageInstallResult >> packagesRaw [
	^ self ffiCall: #(void* frida_package_install_result_get_packages (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallResult >> packages [
	| result |
	result := self packagesRaw.
	^ FridaPackageList fromBorrowedHandle: (result)
]

