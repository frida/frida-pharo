"
GENERATED binding for the Frida FridaPackageInstallOptions GObject.
"
Class {
	#name : 'FridaPackageInstallOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageInstallOptions class >> newRaw [
	^ self ffiCall: #(void* frida_package_install_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaPackageInstallOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

{ #category : 'generated' }
FridaPackageInstallOptions >> projectRoot [
	^ self ffiCall: #(String frida_package_install_options_get_project_root (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions >> role [
	^ self ffiCall: #(FridaPackageRole frida_package_install_options_get_role (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions >> projectRootRaw: aValue [
	^ self ffiCall: #(void frida_package_install_options_set_project_root (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions >> projectRoot: aValue [
	self projectRootRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaPackageInstallOptions >> roleRaw: aValue [
	^ self ffiCall: #(void frida_package_install_options_set_role (self, FridaPackageRole aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions >> role: aValue [
	self roleRaw: (FridaPackageRole fromSymbol: aValue).
	^ self
]

{ #category : 'generated' }
FridaPackageInstallOptions >> clearSpecs [
	^ self ffiCall: #(void frida_package_install_options_clear_specs (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions >> addSpec: spec [
	^ self ffiCall: #(void frida_package_install_options_add_spec (self, String spec)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions >> clearOmits [
	^ self ffiCall: #(void frida_package_install_options_clear_omits (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions >> addOmitRaw: marshalled0 [
	^ self ffiCall: #(void frida_package_install_options_add_omit (self, FridaPackageRole marshalled0)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageInstallOptions >> addOmit: role [
	| marshalled0 result |
	marshalled0 := FridaPackageRole fromSymbol: role.
	result := self addOmitRaw: marshalled0.
	^ self
]

