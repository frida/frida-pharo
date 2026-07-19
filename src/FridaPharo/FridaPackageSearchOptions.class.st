"
GENERATED binding for the Frida FridaPackageSearchOptions GObject.
"
Class {
	#name : 'FridaPackageSearchOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageSearchOptions class >> newRaw [
	^ self ffiCall: #(void* frida_package_search_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageSearchOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaPackageSearchOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

{ #category : 'generated' }
FridaPackageSearchOptions >> offset [
	^ self ffiCall: #(uint frida_package_search_options_get_offset (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageSearchOptions >> limit [
	^ self ffiCall: #(uint frida_package_search_options_get_limit (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageSearchOptions >> offsetRaw: aValue [
	^ self ffiCall: #(void frida_package_search_options_set_offset (self, uint aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageSearchOptions >> offset: aValue [
	self offsetRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaPackageSearchOptions >> limitRaw: aValue [
	^ self ffiCall: #(void frida_package_search_options_set_limit (self, uint aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageSearchOptions >> limit: aValue [
	self limitRaw: aValue.
	^ self
]

