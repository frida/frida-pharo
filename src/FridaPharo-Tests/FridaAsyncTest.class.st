"
End-to-end test of the async model: constructs a DeviceManager, enumerates
devices via the schedule-on-Frida's-thread + semaphore round-trip, and reads a
property off a wrapped Frida GObject on the Pharo thread.
"
Class {
	#name : 'FridaAsyncTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaAsyncTest >> testConstructDeviceManager [
	| manager |
	manager := FridaDeviceManager new.
	self assert: manager notNil.
	self deny: manager getHandle isNull
]

{ #category : 'tests' }
FridaAsyncTest >> testAsyncErrorRaisesFridaError [
	"A GError produced on Frida's thread is marshalled into a FridaError on the
	 Pharo thread."
	| manager |
	manager := FridaDeviceManager new.
	manager close.
	self
		should: [ manager enumerateDevices ]
		raise: FridaError
		withExceptionDo: [ :e | self assert: e messageText isString ]
]

{ #category : 'tests' }
FridaAsyncTest >> testEnumerateDevicesReturnsLocal [
	| manager devices device |
	manager := FridaDeviceManager new.
	devices := manager enumerateDevices.
	self assert: devices size >= 1.
	device := devices first.
	self assert: device id isString.
	self deny: device id isEmpty
]
