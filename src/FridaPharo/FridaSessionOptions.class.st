"
GENERATED binding for the Frida FridaSessionOptions GObject.
"
Class {
	#name : 'FridaSessionOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaSessionOptions class >> newRaw [
	^ self ffiCall: #(void* frida_session_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaSessionOptions >> realm [
	^ self ffiCall: #(FridaRealm frida_session_options_get_realm (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> persistTimeout [
	^ self ffiCall: #(uint frida_session_options_get_persist_timeout (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> emulatedAgentPath [
	^ self ffiCall: #(String frida_session_options_get_emulated_agent_path (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> exceptor [
	^ self ffiCall: #(FridaExceptor frida_session_options_get_exceptor (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> unwindBroker [
	^ self ffiCall: #(bool frida_session_options_get_unwind_broker (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> exitMonitor [
	^ self ffiCall: #(bool frida_session_options_get_exit_monitor (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> threadSuspendMonitor [
	^ self ffiCall: #(bool frida_session_options_get_thread_suspend_monitor (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> realmRaw: aValue [
	^ self ffiCall: #(void frida_session_options_set_realm (self, FridaRealm aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> realm: aValue [
	self realmRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSessionOptions >> persistTimeoutRaw: aValue [
	^ self ffiCall: #(void frida_session_options_set_persist_timeout (self, uint aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> persistTimeout: aValue [
	self persistTimeoutRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSessionOptions >> emulatedAgentPathRaw: aValue [
	^ self ffiCall: #(void frida_session_options_set_emulated_agent_path (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> emulatedAgentPath: aValue [
	self emulatedAgentPathRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSessionOptions >> exceptorRaw: aValue [
	^ self ffiCall: #(void frida_session_options_set_exceptor (self, FridaExceptor aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> exceptor: aValue [
	self exceptorRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSessionOptions >> unwindBrokerRaw: aValue [
	^ self ffiCall: #(void frida_session_options_set_unwind_broker (self, bool aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> unwindBroker: aValue [
	self unwindBrokerRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSessionOptions >> exitMonitorRaw: aValue [
	^ self ffiCall: #(void frida_session_options_set_exit_monitor (self, bool aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> exitMonitor: aValue [
	self exitMonitorRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSessionOptions >> threadSuspendMonitorRaw: aValue [
	^ self ffiCall: #(void frida_session_options_set_thread_suspend_monitor (self, bool aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> threadSuspendMonitor: aValue [
	self threadSuspendMonitorRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaSessionOptions >> clearLinkerNotifierOffsets [
	^ self ffiCall: #(void frida_session_options_clear_linker_notifier_offsets (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaSessionOptions >> addLinkerNotifierOffset: offset [
	^ self ffiCall: #(void frida_session_options_add_linker_notifier_offset (self, uint offset)) library: FridaLibrary
]

