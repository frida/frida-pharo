"
Namespace-level Frida entry points. GENERATED - do not edit.
"
Class {
	#name : 'Frida',
	#superclass : 'Object',
	#classVars : [ 'DeviceManager' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
Frida class >> version [
	^ self ffiCall: #(String frida_version_string()) library: FridaLibrary
]

{ #category : 'facade' }
Frida class >> deviceManager [
	^ DeviceManager ifNil: [ DeviceManager := FridaDeviceManager new ]
]

{ #category : 'facade' }
Frida class >> closeDeviceManager [
	DeviceManager ifNil: [ ^ self ].
	DeviceManager close.
	DeviceManager := nil
]

{ #category : 'facade' }
Frida class >> localDevice [
	^ self deviceManager
		getDeviceByType: FridaDeviceType FridaDeviceTypeLocal
		timeout: 0
]

