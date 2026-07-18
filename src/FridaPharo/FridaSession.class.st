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
FridaSession >> detach [
	| raw |
	raw := self asyncCall: [ :onReady | self detachBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self detachFinish: asyncResult errorHolder: errorHolder ].
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
FridaSession >> resume [
	| raw |
	raw := self asyncCall: [ :onReady | self resumeBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self resumeFinish: asyncResult errorHolder: errorHolder ].
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
FridaSession >> enableChildGating [
	| raw |
	raw := self asyncCall: [ :onReady | self enableChildGatingBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enableChildGatingFinish: asyncResult errorHolder: errorHolder ].
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
FridaSession >> disableChildGating [
	| raw |
	raw := self asyncCall: [ :onReady | self disableChildGatingBegin: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self disableChildGatingFinish: asyncResult errorHolder: errorHolder ].
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
FridaSession >> createScript: source options: options [
	| marshalled0 raw |
	marshalled0 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self createScriptBegin: source marshalled0: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self createScriptFinish: asyncResult errorHolder: errorHolder ].
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
FridaSession >> createScriptFromBytes: bytes options: options [
	| marshalled0 marshalled1 raw |
	marshalled0 := self bytesFromByteArray: bytes.
	marshalled1 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self createScriptFromBytesBegin: marshalled0 marshalled1: marshalled1 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self createScriptFromBytesFinish: asyncResult errorHolder: errorHolder ].
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
FridaSession >> compileScript: source options: options [
	| marshalled0 raw |
	marshalled0 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self compileScriptBegin: source marshalled0: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self compileScriptFinish: asyncResult errorHolder: errorHolder ].
	^ self byteArrayFromBytes: (raw) owned: true
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
FridaSession >> snapshotScript: embedScript options: options [
	| marshalled0 raw |
	marshalled0 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self snapshotScriptBegin: embedScript marshalled0: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self snapshotScriptFinish: asyncResult errorHolder: errorHolder ].
	^ self byteArrayFromBytes: (raw) owned: true
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
FridaSession >> setupPeerConnection: options [
	| marshalled0 raw |
	marshalled0 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self setupPeerConnectionBegin: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self setupPeerConnectionFinish: asyncResult errorHolder: errorHolder ].
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
FridaSession >> joinPortal: address options: options [
	| marshalled0 raw |
	marshalled0 := options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ].
	raw := self asyncCall: [ :onReady | self joinPortalBegin: address marshalled0: marshalled0 cancellable: ExternalAddress null onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self joinPortalFinish: asyncResult errorHolder: errorHolder ].
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
FridaSession >> onDetached: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, FridaSessionDetachReason reason, void* crash, void* userData)) block: [ :instance :reason :crash :userData | aBlock valueWithArguments: { reason . FridaObject wrapBorrowed: crash } ].
	^ self connectSignal: 'detached' callback: callback
]

{ #category : 'generated' }
FridaSession >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'pid='; print: (self pid) ] on: Error do: [ :e | aStream nextPutAll: 'pid=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'facade' }
FridaSession >> createScript: source [
	^ self createScript: source options: nil
]

