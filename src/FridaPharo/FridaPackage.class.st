"
GENERATED binding for the Frida FridaPackage GObject.
"
Class {
	#name : 'FridaPackage',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackage >> name [
	^ self ffiCall: #(String frida_package_get_name (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackage >> version [
	^ self ffiCall: #(String frida_package_get_version (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackage >> description [
	^ self ffiCall: #(String frida_package_get_description (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackage >> url [
	^ self ffiCall: #(String frida_package_get_url (self)) library: FridaLibrary
]

