"
GENERATED binding for the Frida FridaCompiler GObject.
"
Class {
	#name : 'FridaCompiler',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaCompiler class >> newRaw: manager [
	^ self ffiCall: #(void* frida_compiler_new (FridaDeviceManager manager)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompiler class >> new: manager [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw: manager)
]

{ #category : 'generated' }
FridaCompiler >> build: entrypoint options: options [
	| raw |
	raw := self asyncBegin: 'frida_compiler_build' finish: 'frida_compiler_build_finish' args: { { #string. entrypoint } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ self stringFromCharPointer: raw owned: true
]

{ #category : 'generated' }
FridaCompiler >> watch: entrypoint options: options [
	| raw |
	raw := self asyncBegin: 'frida_compiler_watch' finish: 'frida_compiler_watch_finish' args: { { #string. entrypoint } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ self
]

