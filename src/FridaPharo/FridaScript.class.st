"
GENERATED binding for the Frida FridaScript GObject.
"
Class {
	#name : 'FridaScript',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaScript >> isDestroyed [
	^ self ffiCall: #(bool frida_script_is_destroyed (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> load [
	| raw |
	raw := self asyncBegin: 'frida_script_load' finish: 'frida_script_load_finish'.
	^ self
]

{ #category : 'generated' }
FridaScript >> interrupt [
	| raw |
	raw := self asyncBegin: 'frida_script_interrupt' finish: 'frida_script_interrupt_finish'.
	^ self
]

{ #category : 'generated' }
FridaScript >> unload [
	| raw |
	raw := self asyncBegin: 'frida_script_unload' finish: 'frida_script_unload_finish'.
	^ self
]

{ #category : 'generated' }
FridaScript >> terminate [
	| raw |
	raw := self asyncBegin: 'frida_script_terminate' finish: 'frida_script_terminate_finish'.
	^ self
]

{ #category : 'generated' }
FridaScript >> eternalize [
	| raw |
	raw := self asyncBegin: 'frida_script_eternalize' finish: 'frida_script_eternalize_finish'.
	^ self
]

{ #category : 'generated' }
FridaScript >> postRaw: json marshalled0: marshalled0 [
	^ self ffiCall: #(void frida_script_post (self, String json, void* marshalled0)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> post: json data: data [
	| marshalled0 result |
	marshalled0 := self bytesFromByteArray: data.
	result := self postRaw: json marshalled0: marshalled0.
	FridaGlue bytesUnref: marshalled0.
	^ self
]

{ #category : 'generated' }
FridaScript >> enableDebugger: port [
	| raw |
	raw := self asyncBegin: 'frida_script_enable_debugger' finish: 'frida_script_enable_debugger_finish' args: { { #int. port } }.
	^ self
]

{ #category : 'generated' }
FridaScript >> disableDebugger [
	| raw |
	raw := self asyncBegin: 'frida_script_disable_debugger' finish: 'frida_script_disable_debugger_finish'.
	^ self
]

{ #category : 'facade' }
FridaScript >> onMessage: aBlock [
	^ FridaSignalSubscription onScriptMessage: self do: aBlock
]

{ #category : 'facade' }
FridaScript >> exports [
	^ FridaRpcExports on: self
]

{ #category : 'facade' }
FridaScript >> post: json [
	^ self post: json data: nil
]

