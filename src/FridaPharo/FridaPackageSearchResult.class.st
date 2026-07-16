"
GENERATED binding for the Frida FridaPackageSearchResult GObject.
"
Class {
	#name : 'FridaPackageSearchResult',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageSearchResult >> packagesRaw [
	^ self ffiCall: #(void* frida_package_search_result_get_packages (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageSearchResult >> packages [
	| result |
	result := self packagesRaw.
	^ FridaPackageList fromBorrowedHandle: (result)
]

{ #category : 'generated' }
FridaPackageSearchResult >> total [
	^ self ffiCall: #(uint frida_package_search_result_get_total (self)) library: FridaLibrary
]

