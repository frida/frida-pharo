"
Base class for tests that touch Frida's device manager. Closes the shared
manager after each test so no frida-helper subprocess leaks past the run.
"
Class {
	#name : 'FridaTestCase',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'running' }
FridaTestCase >> tearDown [
	super tearDown.
	Frida closeDeviceManager
]
