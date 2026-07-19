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
FridaScript >> load: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self loadBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self loadFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaScript >> loadBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_script_load (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> loadFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_script_load_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> load [
	^ self load: nil
]

{ #category : 'generated' }
FridaScript >> interrupt: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self interruptBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self interruptFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaScript >> interruptBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_script_interrupt (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> interruptFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_script_interrupt_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> interrupt [
	^ self interrupt: nil
]

{ #category : 'generated' }
FridaScript >> unload: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self unloadBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self unloadFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaScript >> unloadBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_script_unload (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> unloadFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_script_unload_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> unload [
	^ self unload: nil
]

{ #category : 'generated' }
FridaScript >> terminate: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self terminateBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self terminateFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaScript >> terminateBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_script_terminate (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> terminateFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_script_terminate_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> terminate [
	^ self terminate: nil
]

{ #category : 'generated' }
FridaScript >> eternalize: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self eternalizeBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self eternalizeFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaScript >> eternalizeBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_script_eternalize (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> eternalizeFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_script_eternalize_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> eternalize [
	^ self eternalize: nil
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
FridaScript >> post: json [
	^ self post: json data: nil
]

{ #category : 'generated' }
FridaScript >> enableDebugger: port cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self enableDebuggerBegin: port cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enableDebuggerFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaScript >> enableDebuggerBegin: port cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_script_enable_debugger (self, uint16 port, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> enableDebuggerFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_script_enable_debugger_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> enableDebugger: port [
	^ self enableDebugger: port cancellable: nil
]

{ #category : 'generated' }
FridaScript >> disableDebugger: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self disableDebuggerBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self disableDebuggerFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaScript >> disableDebuggerBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_script_disable_debugger (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> disableDebuggerFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_script_disable_debugger_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaScript >> disableDebugger [
	^ self disableDebugger: nil
]

{ #category : 'generated' }
FridaScript >> onDestroyed: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* userData)) block: [ :instance :userData | aBlock valueWithArguments: { } ].
	^ self connectSignal: 'destroyed' callback: callback
]

{ #category : 'generated' }
FridaScript >> onMessage: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, String json, void* data, void* userData)) block: [ :instance :json :data :userData | aBlock valueWithArguments: { json . FridaObject byteArrayFromBytes: data owned: false } ].
	^ self connectSignal: 'message' callback: callback
]

{ #category : 'facade' }
FridaScript >> exports [
	^ FridaRpcExports on: self
]

{ #category : 'facade' }
FridaScript >> post: json [
	^ self post: json data: nil
]

