"
GENERATED binding for the Frida FridaAuthenticationService GObject.
"
Class {
	#name : 'FridaAuthenticationService',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaAuthenticationService >> authenticate: token [
	| raw |
	raw := self asyncBegin: 'frida_authentication_service_authenticate' finish: 'frida_authentication_service_authenticate_finish' args: { { #string. token } }.
	^ self stringFromCharPointer: raw owned: true
]

