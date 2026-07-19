"
GENERATED binding for the Frida FridaSession GObject.
"
Class {
	#name : 'FridaSession',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSession >> pid [
	^ self ffiCall: #(uint frida_session_get_pid (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> persistTimeout [
	^ self ffiCall: #(uint frida_session_get_persist_timeout (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> isDetached [
	^ self ffiCall: #(bool frida_session_is_detached (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> detach: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self detachBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self detachFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaSession >> detachBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_detach (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> detachFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_session_detach_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> detach [
	^ self detach: nil
]

{ #category : 'generated' }
FridaSession >> resume: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self resumeBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self resumeFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaSession >> resumeBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_resume (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> resumeFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_session_resume_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> resume [
	^ self resume: nil
]

{ #category : 'generated' }
FridaSession >> enableChildGating: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self enableChildGatingBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enableChildGatingFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaSession >> enableChildGatingBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_enable_child_gating (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> enableChildGatingFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_session_enable_child_gating_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> enableChildGating [
	^ self enableChildGating: nil
]

{ #category : 'generated' }
FridaSession >> disableChildGating: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self disableChildGatingBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self disableChildGatingFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaSession >> disableChildGatingBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_disable_child_gating (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> disableChildGatingFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_session_disable_child_gating_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> disableChildGating [
	^ self disableChildGating: nil
]

{ #category : 'generated' }
FridaSession >> createScript: source options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaScriptOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self createScriptBegin: source marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self createScriptFinish: asyncResult errorHolder: errorHolder ].
	^ FridaScript fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaSession >> createScriptBegin: source marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_create_script (self, String source, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> createScriptFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_session_create_script_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> createScript: source options: options [
	^ self createScript: source options: options cancellable: nil
]

{ #category : 'generated' }
FridaSession >> createScript: source [
	^ self createScript: source options: nil cancellable: nil
]

{ #category : 'generated' }
FridaSession >> createScriptFromBytes: bytes options: options cancellable: cancellable [
	| options0 marshalled0 marshalled1 cancellableHandle raw |
	marshalled0 := self bytesFromByteArray: bytes.
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaScriptOptions configuredBy: options ].
	marshalled1 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self createScriptFromBytesBegin: marshalled0 marshalled1: marshalled1 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self createScriptFromBytesFinish: asyncResult errorHolder: errorHolder ].
	FridaGlue bytesUnref: marshalled0.
	^ FridaScript fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaSession >> createScriptFromBytesBegin: marshalled0 marshalled1: marshalled1 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_create_script_from_bytes (self, void* marshalled0, void* marshalled1, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> createScriptFromBytesFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_session_create_script_from_bytes_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> createScriptFromBytes: bytes options: options [
	^ self createScriptFromBytes: bytes options: options cancellable: nil
]

{ #category : 'generated' }
FridaSession >> createScriptFromBytes: bytes [
	^ self createScriptFromBytes: bytes options: nil cancellable: nil
]

{ #category : 'generated' }
FridaSession >> compileScript: source options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaScriptOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self compileScriptBegin: source marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self compileScriptFinish: asyncResult errorHolder: errorHolder ].
	^ FridaObject byteArrayFromBytes: (raw) owned: true
]

{ #category : 'generated' }
FridaSession >> compileScriptBegin: source marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_compile_script (self, String source, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> compileScriptFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_session_compile_script_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> compileScript: source options: options [
	^ self compileScript: source options: options cancellable: nil
]

{ #category : 'generated' }
FridaSession >> compileScript: source [
	^ self compileScript: source options: nil cancellable: nil
]

{ #category : 'generated' }
FridaSession >> snapshotScript: embedScript options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaSnapshotOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self snapshotScriptBegin: embedScript marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self snapshotScriptFinish: asyncResult errorHolder: errorHolder ].
	^ FridaObject byteArrayFromBytes: (raw) owned: true
]

{ #category : 'generated' }
FridaSession >> snapshotScriptBegin: embedScript marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_snapshot_script (self, String embedScript, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> snapshotScriptFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_session_snapshot_script_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> snapshotScript: embedScript options: options [
	^ self snapshotScript: embedScript options: options cancellable: nil
]

{ #category : 'generated' }
FridaSession >> snapshotScript: embedScript [
	^ self snapshotScript: embedScript options: nil cancellable: nil
]

{ #category : 'generated' }
FridaSession >> setupPeerConnection: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaPeerOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self setupPeerConnectionBegin: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self setupPeerConnectionFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaSession >> setupPeerConnectionBegin: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_setup_peer_connection (self, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> setupPeerConnectionFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_session_setup_peer_connection_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> setupPeerConnection: options [
	^ self setupPeerConnection: options cancellable: nil
]

{ #category : 'generated' }
FridaSession >> setupPeerConnection [
	^ self setupPeerConnection: nil cancellable: nil
]

{ #category : 'generated' }
FridaSession >> joinPortal: address options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaPortalOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self joinPortalBegin: address marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self joinPortalFinish: asyncResult errorHolder: errorHolder ].
	^ FridaPortalMembership fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaSession >> joinPortalBegin: address marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_session_join_portal (self, String address, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> joinPortalFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_session_join_portal_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSession >> joinPortal: address options: options [
	^ self joinPortal: address options: options cancellable: nil
]

{ #category : 'generated' }
FridaSession >> joinPortal: address [
	^ self joinPortal: address options: nil cancellable: nil
]

{ #category : 'generated' }
FridaSession >> onDetached: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, FridaSessionDetachReason reason, void* crash, void* userData)) block: [ :instance :reason :crash :userData | aBlock valueWithArguments: { reason . FridaCrash fromHandle: crash owned: false } ].
	^ self connectSignal: 'detached' callback: callback
]

{ #category : 'generated' }
FridaSession >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'generated' }
FridaSession class >> identityProperties [
	^ #(pid)
]

