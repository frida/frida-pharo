"
GType -> concrete Pharo class mapping: a handle wrapped through the base class
resolves to its concrete generated class (e.g. FridaDevice), so returned/
signal-delivered objects expose their concrete API.
"
Class {
	#name : 'FridaTypeMapTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaTypeMapTest >> testWrapResolvesConcreteClass [
	| device wrapped |
	device := Frida localDevice.
	wrapped := FridaObject wrapBorrowed: device getHandle.
	self assert: wrapped class == FridaDevice.
	"and the concrete API is usable on the base-wrapped handle"
	self assert: wrapped id isString
]
