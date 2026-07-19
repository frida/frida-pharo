"
End-to-end test of the async model: enumerates devices via the shared device
manager (schedule-on-Frida's-thread + semaphore round-trip) and reads a property
off a wrapped Frida GObject on the Pharo thread.
"
Class {
	#name : 'FridaAsyncTest',
	#superclass : 'FridaTestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaAsyncTest >> testDeviceManagerAvailable [
	| manager |
	manager := Frida deviceManager.
	self assert: manager notNil.
	self deny: manager getHandle isNull
]

{ #category : 'tests' }
FridaAsyncTest >> testAsyncErrorRaisesFridaError [
	"A GError produced on Frida's thread is marshalled into a FridaError on the
	 Pharo thread."
	| manager |
	manager := Frida deviceManager.
	Frida closeDeviceManager.
	self
		should: [ manager enumerateDevices ]
		raise: FridaError
		withExceptionDo: [ :e | self assert: e messageText isString ]
]

{ #category : 'tests' }
FridaAsyncTest >> testEnumerateDevicesReturnsLocal [
	| devices device |
	devices := Frida deviceManager enumerateDevices.
	self assert: devices size >= 1.
	device := devices first.
	self assert: device id isString.
	self deny: device id isEmpty
]
