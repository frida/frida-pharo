"
FridaDevice>>openChannel: was previously skipped because its async result is a
GIOStream (a non-Frida GObject). Wiring Gio.IOStream -> FridaIOStream as data in
customization.external_object_types un-skips it. A live channel needs a remote
endpoint, so this test verifies the generation wiring rather than a round-trip;
IOStream byte I/O remains a documented follow-up.
"
Class {
	#name : 'FridaOpenChannelWiringTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaOpenChannelWiringTest >> testDeviceUnderstandsOpenChannel [
	self assert: (FridaDevice canUnderstand: #openChannel:)
]

{ #category : 'tests' }
FridaOpenChannelWiringTest >> testGeneratedMethodWrapsAsIoStream [
	| source |
	source := (FridaDevice >> #openChannel:cancellable:) sourceCode.
	self assert: (source includesSubstring: 'FridaIOStream fromOwnedHandle:')
]

{ #category : 'tests' }
FridaOpenChannelWiringTest >> testIoStreamIsFridaObject [
	self assert: (FridaIOStream inheritsFrom: FridaObject).
	self assert: (FridaIOStream canUnderstand: #isClosed)
]
