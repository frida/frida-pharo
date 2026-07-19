"
GENERATED binding for the Frida FridaControlServiceOptions GObject.
"
Class {
	#name : 'FridaControlServiceOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaControlServiceOptions class >> newRaw [
	^ self ffiCall: #(void* frida_control_service_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlServiceOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaControlServiceOptions class >> configuredBy: aBlock [
	| options |
	options := self new.
	aBlock value: options.
	^ options
]

{ #category : 'generated' }
FridaControlServiceOptions >> enablePreload [
	^ self ffiCall: #(bool frida_control_service_options_get_enable_preload (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlServiceOptions >> reportCrashes [
	^ self ffiCall: #(bool frida_control_service_options_get_report_crashes (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlServiceOptions >> enablePreloadRaw: aValue [
	^ self ffiCall: #(void frida_control_service_options_set_enable_preload (self, bool aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlServiceOptions >> enablePreload: aValue [
	self enablePreloadRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaControlServiceOptions >> reportCrashesRaw: aValue [
	^ self ffiCall: #(void frida_control_service_options_set_report_crashes (self, bool aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaControlServiceOptions >> reportCrashes: aValue [
	self reportCrashesRaw: aValue.
	^ self
]

