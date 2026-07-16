"
GENERATED binding for the Frida FridaPackageRole enumeration.
"
Class {
	#name : 'FridaPackageRole',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaPackageRoleRuntime', 'FridaPackageRoleDevelopment', 'FridaPackageRoleOptional', 'FridaPackageRolePeer' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageRole class >> enumDecl [
	^ #(
			FridaPackageRoleRuntime 0
			FridaPackageRoleDevelopment 1
			FridaPackageRoleOptional 2
			FridaPackageRolePeer 3
		)
]

{ #category : 'generated' }
FridaPackageRole class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

