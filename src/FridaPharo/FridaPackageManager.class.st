"
GENERATED binding for the Frida FridaPackageManager GObject.
"
Class {
	#name : 'FridaPackageManager',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageManager class >> newRaw [
	^ self ffiCall: #(void* frida_package_manager_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaPackageManager >> registry [
	^ self ffiCall: #(String frida_package_manager_get_registry (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager >> registryRaw: aValue [
	^ self ffiCall: #(void frida_package_manager_set_registry (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager >> registry: aValue [
	self registryRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaPackageManager >> search: query options: options [
	| raw |
	raw := self asyncBegin: 'frida_package_manager_search' finish: 'frida_package_manager_search_finish' args: { { #string. query } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaPackageSearchResult fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaPackageManager >> install: options [
	| raw |
	raw := self asyncBegin: 'frida_package_manager_install' finish: 'frida_package_manager_install_finish' args: { { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaPackageInstallResult fromOwnedHandle: raw
]

