"
GENERATED binding for the Frida FridaPortalMembership GObject.
"
Class {
	#name : 'FridaPortalMembership',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPortalMembership >> terminate [
	| raw |
	raw := self asyncBegin: 'frida_portal_membership_terminate' finish: 'frida_portal_membership_terminate_finish'.
	^ self
]

