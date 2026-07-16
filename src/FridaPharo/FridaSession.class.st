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
	raw := self asyncBegin: 'frida_session_detach' finish: 'frida_session_detach_finish'.
	^ self
]

{ #category : 'generated' }
FridaSession >> resume [
	| raw |
	raw := self asyncBegin: 'frida_session_resume' finish: 'frida_session_resume_finish'.
	^ self
]

{ #category : 'generated' }
FridaSession >> enableChildGating [
	| raw |
	raw := self asyncBegin: 'frida_session_enable_child_gating' finish: 'frida_session_enable_child_gating_finish'.
	^ self
]

{ #category : 'generated' }
FridaSession >> disableChildGating [
	| raw |
	raw := self asyncBegin: 'frida_session_disable_child_gating' finish: 'frida_session_disable_child_gating_finish'.
	^ self
]

{ #category : 'generated' }
FridaSession >> createScript: source options: options [
	| raw |
	raw := self asyncBegin: 'frida_session_create_script' finish: 'frida_session_create_script_finish' args: { { #string. source } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaScript fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaSession >> createScriptFromBytes: bytes options: options [
	| raw |
	raw := self asyncBegin: 'frida_session_create_script_from_bytes' finish: 'frida_session_create_script_from_bytes_finish' args: { { #bytes. bytes } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaScript fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaSession >> compileScript: source options: options [
	| raw |
	raw := self asyncBegin: 'frida_session_compile_script' finish: 'frida_session_compile_script_finish' args: { { #string. source } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ self byteArrayFromBytes: raw owned: true
]

{ #category : 'generated' }
FridaSession >> snapshotScript: embedScript options: options [
	| raw |
	raw := self asyncBegin: 'frida_session_snapshot_script' finish: 'frida_session_snapshot_script_finish' args: { { #string. embedScript } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ self byteArrayFromBytes: raw owned: true
]

{ #category : 'generated' }
FridaSession >> setupPeerConnection: options [
	| raw |
	raw := self asyncBegin: 'frida_session_setup_peer_connection' finish: 'frida_session_setup_peer_connection_finish' args: { { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ self
]

{ #category : 'generated' }
FridaSession >> joinPortal: address options: options [
	| raw |
	raw := self asyncBegin: 'frida_session_join_portal' finish: 'frida_session_join_portal_finish' args: { { #string. address } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaPortalMembership fromOwnedHandle: raw
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

