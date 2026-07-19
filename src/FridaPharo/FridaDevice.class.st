"
GENERATED binding for the Frida FridaDevice GObject.
"
Class {
	#name : 'FridaDevice',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaDevice >> id [
	^ self ffiCall: #(String frida_device_get_id (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> name [
	^ self ffiCall: #(String frida_device_get_name (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> iconRaw [
	^ self ffiCall: #(void* frida_device_get_icon (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> icon [
	| result |
	result := self iconRaw.
	^ FridaObject valueFromVariant: (result) owned: false
]

{ #category : 'generated' }
FridaDevice >> dtype [
	^ self ffiCall: #(FridaDeviceType frida_device_get_dtype (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> busRaw [
	^ self ffiCall: #(void* frida_device_get_bus (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> bus [
	| result |
	result := self busRaw.
	^ FridaBus fromBorrowedHandle: (result)
]

{ #category : 'generated' }
FridaDevice >> isLost [
	^ self ffiCall: #(bool frida_device_is_lost (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> overrideOptionRaw: name marshalled0: marshalled0 errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_override_option (self, String name, void* marshalled0, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> overrideOption: name val: val [
	| marshalled0 errorHolder result |
	marshalled0 := FridaVariant encode: val.
	errorHolder := self newErrorHolder.
	result := self overrideOptionRaw: name marshalled0: marshalled0 errorHolder: errorHolder.
	FridaGlue variantUnref: marshalled0.
	self checkError: errorHolder.
	^ self
]

{ #category : 'generated' }
FridaDevice >> querySystemParameters: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self querySystemParametersBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self querySystemParametersFinish: asyncResult errorHolder: errorHolder ].
	^ FridaObject dictFromVardict: (raw) owned: true
]

{ #category : 'generated' }
FridaDevice >> querySystemParametersBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_query_system_parameters (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> querySystemParametersFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_query_system_parameters_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> querySystemParameters [
	^ self querySystemParameters: nil
]

{ #category : 'generated' }
FridaDevice >> getFrontmostApplication: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaFrontmostQueryOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self getFrontmostApplicationBegin: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self getFrontmostApplicationFinish: asyncResult errorHolder: errorHolder ].
	^ FridaApplication fromHandle: (raw) owned: true
]

{ #category : 'generated' }
FridaDevice >> getFrontmostApplicationBegin: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_get_frontmost_application (self, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> getFrontmostApplicationFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_get_frontmost_application_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> getFrontmostApplication: options [
	^ self getFrontmostApplication: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> getFrontmostApplication [
	^ self getFrontmostApplication: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> enumerateApplications: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaApplicationQueryOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self enumerateApplicationsBegin: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enumerateApplicationsFinish: asyncResult errorHolder: errorHolder ].
	^ (FridaApplicationList fromOwnedHandle: (raw)) asArray
]

{ #category : 'generated' }
FridaDevice >> enumerateApplicationsBegin: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_enumerate_applications (self, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enumerateApplicationsFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_enumerate_applications_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enumerateApplications: options [
	^ self enumerateApplications: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> enumerateApplications [
	^ self enumerateApplications: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> getProcessByPid: pid options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaProcessMatchOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self getProcessByPidBegin: pid marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self getProcessByPidFinish: asyncResult errorHolder: errorHolder ].
	^ FridaProcess fromHandle: (raw) owned: true
]

{ #category : 'generated' }
FridaDevice >> getProcessByPidBegin: pid marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_get_process_by_pid (self, uint pid, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> getProcessByPidFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_get_process_by_pid_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> getProcessByPid: pid options: options [
	^ self getProcessByPid: pid options: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> getProcessByPid: pid [
	^ self getProcessByPid: pid options: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> getProcessByName: name options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaProcessMatchOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self getProcessByNameBegin: name marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self getProcessByNameFinish: asyncResult errorHolder: errorHolder ].
	^ FridaProcess fromHandle: (raw) owned: true
]

{ #category : 'generated' }
FridaDevice >> getProcessByNameBegin: name marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_get_process_by_name (self, String name, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> getProcessByNameFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_get_process_by_name_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> getProcessByName: name options: options [
	^ self getProcessByName: name options: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> getProcessByName: name [
	^ self getProcessByName: name options: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> findProcessByPid: pid options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaProcessMatchOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self findProcessByPidBegin: pid marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self findProcessByPidFinish: asyncResult errorHolder: errorHolder ].
	^ FridaProcess fromHandle: (raw) owned: true
]

{ #category : 'generated' }
FridaDevice >> findProcessByPidBegin: pid marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_find_process_by_pid (self, uint pid, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> findProcessByPidFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_find_process_by_pid_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> findProcessByPid: pid options: options [
	^ self findProcessByPid: pid options: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> findProcessByPid: pid [
	^ self findProcessByPid: pid options: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> findProcessByName: name options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaProcessMatchOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self findProcessByNameBegin: name marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self findProcessByNameFinish: asyncResult errorHolder: errorHolder ].
	^ FridaProcess fromHandle: (raw) owned: true
]

{ #category : 'generated' }
FridaDevice >> findProcessByNameBegin: name marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_find_process_by_name (self, String name, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> findProcessByNameFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_find_process_by_name_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> findProcessByName: name options: options [
	^ self findProcessByName: name options: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> findProcessByName: name [
	^ self findProcessByName: name options: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> enumerateProcesses: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaProcessQueryOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self enumerateProcessesBegin: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enumerateProcessesFinish: asyncResult errorHolder: errorHolder ].
	^ (FridaProcessList fromOwnedHandle: (raw)) asArray
]

{ #category : 'generated' }
FridaDevice >> enumerateProcessesBegin: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_enumerate_processes (self, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enumerateProcessesFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_enumerate_processes_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enumerateProcesses: options [
	^ self enumerateProcesses: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> enumerateProcesses [
	^ self enumerateProcesses: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> enableSpawnGating: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaSpawnGatingOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self enableSpawnGatingBegin: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enableSpawnGatingFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaDevice >> enableSpawnGatingBegin: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_enable_spawn_gating (self, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enableSpawnGatingFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_enable_spawn_gating_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enableSpawnGating: options [
	^ self enableSpawnGating: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> enableSpawnGating [
	^ self enableSpawnGating: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> disableSpawnGating: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self disableSpawnGatingBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self disableSpawnGatingFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaDevice >> disableSpawnGatingBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_disable_spawn_gating (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> disableSpawnGatingFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_disable_spawn_gating_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> disableSpawnGating [
	^ self disableSpawnGating: nil
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingSpawn: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self enumeratePendingSpawnBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enumeratePendingSpawnFinish: asyncResult errorHolder: errorHolder ].
	^ (FridaSpawnList fromOwnedHandle: (raw)) asArray
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingSpawnBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_enumerate_pending_spawn (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingSpawnFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_enumerate_pending_spawn_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingSpawn [
	^ self enumeratePendingSpawn: nil
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingChildren: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self enumeratePendingChildrenBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self enumeratePendingChildrenFinish: asyncResult errorHolder: errorHolder ].
	^ (FridaChildList fromOwnedHandle: (raw)) asArray
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingChildrenBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_enumerate_pending_children (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingChildrenFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_enumerate_pending_children_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingChildren [
	^ self enumeratePendingChildren: nil
]

{ #category : 'generated' }
FridaDevice >> spawn: program options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaSpawnOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self spawnBegin: program marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self spawnFinish: asyncResult errorHolder: errorHolder ].
	^ raw
]

{ #category : 'generated' }
FridaDevice >> spawnBegin: program marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_spawn (self, String program, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> spawnFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(uint frida_device_spawn_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> spawn: program options: options [
	^ self spawn: program options: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> spawn: program [
	^ self spawn: program options: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> input: pid data: data cancellable: cancellable [
	| marshalled0 cancellableHandle raw |
	marshalled0 := self bytesFromByteArray: data.
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self inputBegin: pid marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self inputFinish: asyncResult errorHolder: errorHolder ].
	FridaGlue bytesUnref: marshalled0.
	^ self
]

{ #category : 'generated' }
FridaDevice >> inputBegin: pid marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_input (self, uint pid, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> inputFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_input_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> input: pid data: data [
	^ self input: pid data: data cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> resume: pid cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self resumeBegin: pid cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self resumeFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaDevice >> resumeBegin: pid cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_resume (self, uint pid, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> resumeFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_resume_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> resume: pid [
	^ self resume: pid cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> kill: pid cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self killBegin: pid cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self killFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaDevice >> killBegin: pid cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_kill (self, uint pid, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> killFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_kill_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> kill: pid [
	^ self kill: pid cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> attach: pid options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaSessionOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self attachBegin: pid marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self attachFinish: asyncResult errorHolder: errorHolder ].
	^ FridaSession fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaDevice >> attachBegin: pid marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_attach (self, uint pid, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> attachFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_attach_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> attach: pid options: options [
	^ self attach: pid options: options cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> attach: pid [
	^ self attach: pid options: nil cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> injectLibraryFile: pid path: path entrypoint: entrypoint data: data cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self injectLibraryFileBegin: pid path: path entrypoint: entrypoint data: data cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self injectLibraryFileFinish: asyncResult errorHolder: errorHolder ].
	^ raw
]

{ #category : 'generated' }
FridaDevice >> injectLibraryFileBegin: pid path: path entrypoint: entrypoint data: data cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_inject_library_file (self, uint pid, String path, String entrypoint, String data, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> injectLibraryFileFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(uint frida_device_inject_library_file_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> injectLibraryFile: pid path: path entrypoint: entrypoint data: data [
	^ self injectLibraryFile: pid path: path entrypoint: entrypoint data: data cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> injectLibraryBlob: pid blob: blob entrypoint: entrypoint data: data cancellable: cancellable [
	| marshalled0 cancellableHandle raw |
	marshalled0 := self bytesFromByteArray: blob.
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self injectLibraryBlobBegin: pid marshalled0: marshalled0 entrypoint: entrypoint data: data cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self injectLibraryBlobFinish: asyncResult errorHolder: errorHolder ].
	FridaGlue bytesUnref: marshalled0.
	^ raw
]

{ #category : 'generated' }
FridaDevice >> injectLibraryBlobBegin: pid marshalled0: marshalled0 entrypoint: entrypoint data: data cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_inject_library_blob (self, uint pid, void* marshalled0, String entrypoint, String data, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> injectLibraryBlobFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(uint frida_device_inject_library_blob_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> injectLibraryBlob: pid blob: blob entrypoint: entrypoint data: data [
	^ self injectLibraryBlob: pid blob: blob entrypoint: entrypoint data: data cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> openChannel: address cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self openChannelBegin: address cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self openChannelFinish: asyncResult errorHolder: errorHolder ].
	^ FridaIOStream fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaDevice >> openChannelBegin: address cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_open_channel (self, String address, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> openChannelFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_open_channel_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> openChannel: address [
	^ self openChannel: address cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> openService: address cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self openServiceBegin: address cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self openServiceFinish: asyncResult errorHolder: errorHolder ].
	^ FridaService fromOwnedHandle: (raw)
]

{ #category : 'generated' }
FridaDevice >> openServiceBegin: address cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_open_service (self, String address, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> openServiceFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_device_open_service_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> openService: address [
	^ self openService: address cancellable: nil
]

{ #category : 'generated' }
FridaDevice >> unpair: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self unpairBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self unpairFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaDevice >> unpairBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_device_unpair (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> unpairFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_device_unpair_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaDevice >> unpair [
	^ self unpair: nil
]

{ #category : 'generated' }
FridaDevice >> onSpawnGatingDisabled: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, FridaSpawnGatingDisabledReason reason, void* userData)) block: [ :instance :reason :userData | aBlock valueWithArguments: { reason } ].
	^ self connectSignal: 'spawn-gating-disabled' callback: callback
]

{ #category : 'generated' }
FridaDevice >> onSpawnAdded: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* spawn, void* userData)) block: [ :instance :spawn :userData | aBlock valueWithArguments: { FridaSpawn fromHandle: spawn owned: false } ].
	^ self connectSignal: 'spawn-added' callback: callback
]

{ #category : 'generated' }
FridaDevice >> onSpawnRemoved: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* spawn, void* userData)) block: [ :instance :spawn :userData | aBlock valueWithArguments: { FridaSpawn fromHandle: spawn owned: false } ].
	^ self connectSignal: 'spawn-removed' callback: callback
]

{ #category : 'generated' }
FridaDevice >> onChildAdded: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* child, void* userData)) block: [ :instance :child :userData | aBlock valueWithArguments: { FridaChild fromHandle: child owned: false } ].
	^ self connectSignal: 'child-added' callback: callback
]

{ #category : 'generated' }
FridaDevice >> onChildRemoved: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* child, void* userData)) block: [ :instance :child :userData | aBlock valueWithArguments: { FridaChild fromHandle: child owned: false } ].
	^ self connectSignal: 'child-removed' callback: callback
]

{ #category : 'generated' }
FridaDevice >> onProcessCrashed: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* crash, void* userData)) block: [ :instance :crash :userData | aBlock valueWithArguments: { FridaCrash fromHandle: crash owned: false } ].
	^ self connectSignal: 'process-crashed' callback: callback
]

{ #category : 'generated' }
FridaDevice >> onOutput: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, uint pid, int fd, void* data, void* userData)) block: [ :instance :pid :fd :data :userData | aBlock valueWithArguments: { pid . fd . FridaObject byteArrayFromBytes: data owned: false } ].
	^ self connectSignal: 'output' callback: callback
]

{ #category : 'generated' }
FridaDevice >> onUninjected: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, uint id, void* userData)) block: [ :instance :id :userData | aBlock valueWithArguments: { id } ].
	^ self connectSignal: 'uninjected' callback: callback
]

{ #category : 'generated' }
FridaDevice >> onLost: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, void* userData)) block: [ :instance :userData | aBlock valueWithArguments: { } ].
	^ self connectSignal: 'lost' callback: callback
]

{ #category : 'generated' }
FridaDevice >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'id='; print: (self id) ] on: Error do: [ :e | aStream nextPutAll: 'id=?' ].
	[ aStream nextPutAll: ' name='; print: (self name) ] on: Error do: [ :e | aStream nextPutAll: 'name=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'generated' }
FridaDevice class >> identityProperties [
	^ #(id name)
]

