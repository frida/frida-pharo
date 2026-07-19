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
	| marshalled0 raw |
	marshalled0 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self buildBegin: entrypoint marshalled0: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self buildFinish: asyncResult errorHolder: errorHolder ].
	^ raw
]

{ #category : 'generated' }
FridaCompiler >> buildBegin: entrypoint marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_compiler_build (self, String entrypoint, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompiler >> buildFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(String frida_compiler_build_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompiler >> watch: entrypoint options: options [
	| marshalled0 raw |
	marshalled0 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self watchBegin: entrypoint marshalled0: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self watchFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaCompiler >> watchBegin: entrypoint marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_compiler_watch (self, String entrypoint, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompiler >> watchFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_compiler_watch_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompiler >> onStarting: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* userData)) block: [ :instance :userData | aBlock valueWithArguments: { } ].
	^ self connectSignal: 'starting' callback: callback
]

{ #category : 'generated' }
FridaCompiler >> onFinished: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* userData)) block: [ :instance :userData | aBlock valueWithArguments: { } ].
	^ self connectSignal: 'finished' callback: callback
]

{ #category : 'generated' }
FridaCompiler >> onOutput: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, String bundle, void* userData)) block: [ :instance :bundle :userData | aBlock valueWithArguments: { bundle } ].
	^ self connectSignal: 'output' callback: callback
]

{ #category : 'generated' }
FridaCompiler >> onDiagnostics: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* diagnostics, void* userData)) block: [ :instance :diagnostics :userData | aBlock valueWithArguments: { FridaObject valueFromVariant: diagnostics owned: false } ].
	^ self connectSignal: 'diagnostics' callback: callback
]

