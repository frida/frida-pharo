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
	^ self valueFromVariant: (result) owned: false
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
FridaDevice >> querySystemParameters [
	| raw |
	raw := self asyncBegin: 'frida_device_query_system_parameters' finish: 'frida_device_query_system_parameters_finish'.
	^ self dictFromVardict: raw owned: true
]

{ #category : 'generated' }
FridaDevice >> getFrontmostApplication: options [
	| raw |
	raw := self asyncBegin: 'frida_device_get_frontmost_application' finish: 'frida_device_get_frontmost_application_finish' args: { { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaApplication fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> enumerateApplications: options [
	| raw |
	raw := self asyncBegin: 'frida_device_enumerate_applications' finish: 'frida_device_enumerate_applications_finish' args: { { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaApplicationList fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> getProcessByPid: pid options: options [
	| raw |
	raw := self asyncBegin: 'frida_device_get_process_by_pid' finish: 'frida_device_get_process_by_pid_finish' args: { { #int. pid } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaProcess fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> getProcessByName: name options: options [
	| raw |
	raw := self asyncBegin: 'frida_device_get_process_by_name' finish: 'frida_device_get_process_by_name_finish' args: { { #string. name } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaProcess fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> findProcessByPid: pid options: options [
	| raw |
	raw := self asyncBegin: 'frida_device_find_process_by_pid' finish: 'frida_device_find_process_by_pid_finish' args: { { #int. pid } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaProcess fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> findProcessByName: name options: options [
	| raw |
	raw := self asyncBegin: 'frida_device_find_process_by_name' finish: 'frida_device_find_process_by_name_finish' args: { { #string. name } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaProcess fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> enumerateProcesses: options [
	| raw |
	raw := self asyncBegin: 'frida_device_enumerate_processes' finish: 'frida_device_enumerate_processes_finish' args: { { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaProcessList fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> enableSpawnGating: options [
	| raw |
	raw := self asyncBegin: 'frida_device_enable_spawn_gating' finish: 'frida_device_enable_spawn_gating_finish' args: { { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ self
]

{ #category : 'generated' }
FridaDevice >> disableSpawnGating [
	| raw |
	raw := self asyncBegin: 'frida_device_disable_spawn_gating' finish: 'frida_device_disable_spawn_gating_finish'.
	^ self
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingSpawn [
	| raw |
	raw := self asyncBegin: 'frida_device_enumerate_pending_spawn' finish: 'frida_device_enumerate_pending_spawn_finish'.
	^ FridaSpawnList fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> enumeratePendingChildren [
	| raw |
	raw := self asyncBegin: 'frida_device_enumerate_pending_children' finish: 'frida_device_enumerate_pending_children_finish'.
	^ FridaChildList fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> spawn: program options: options [
	| raw |
	raw := self asyncBegin: 'frida_device_spawn' finish: 'frida_device_spawn_finish' args: { { #string. program } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ raw asInteger
]

{ #category : 'generated' }
FridaDevice >> input: pid data: data [
	| raw |
	raw := self asyncBegin: 'frida_device_input' finish: 'frida_device_input_finish' args: { { #int. pid } . { #bytes. data } }.
	^ self
]

{ #category : 'generated' }
FridaDevice >> resume: pid [
	| raw |
	raw := self asyncBegin: 'frida_device_resume' finish: 'frida_device_resume_finish' args: { { #int. pid } }.
	^ self
]

{ #category : 'generated' }
FridaDevice >> kill: pid [
	| raw |
	raw := self asyncBegin: 'frida_device_kill' finish: 'frida_device_kill_finish' args: { { #int. pid } }.
	^ self
]

{ #category : 'generated' }
FridaDevice >> attach: pid options: options [
	| raw |
	raw := self asyncBegin: 'frida_device_attach' finish: 'frida_device_attach_finish' args: { { #int. pid } . { #pointer. (options isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options getHandle ]) } }.
	^ FridaSession fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> injectLibraryFile: pid path: path entrypoint: entrypoint data: data [
	| raw |
	raw := self asyncBegin: 'frida_device_inject_library_file' finish: 'frida_device_inject_library_file_finish' args: { { #int. pid } . { #string. path } . { #string. entrypoint } . { #string. data } }.
	^ raw asInteger
]

{ #category : 'generated' }
FridaDevice >> injectLibraryBlob: pid blob: blob entrypoint: entrypoint data: data [
	| raw |
	raw := self asyncBegin: 'frida_device_inject_library_blob' finish: 'frida_device_inject_library_blob_finish' args: { { #int. pid } . { #bytes. blob } . { #string. entrypoint } . { #string. data } }.
	^ raw asInteger
]

{ #category : 'generated' }
FridaDevice >> openChannel: address [
	| raw |
	raw := self asyncBegin: 'frida_device_open_channel' finish: 'frida_device_open_channel_finish' args: { { #string. address } }.
	^ FridaIOStream fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> openService: address [
	| raw |
	raw := self asyncBegin: 'frida_device_open_service' finish: 'frida_device_open_service_finish' args: { { #string. address } }.
	^ FridaService fromOwnedHandle: raw
]

{ #category : 'generated' }
FridaDevice >> unpair [
	| raw |
	raw := self asyncBegin: 'frida_device_unpair' finish: 'frida_device_unpair_finish'.
	^ self
]

{ #category : 'generated' }
FridaDevice >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' ('.
	[ aStream nextPutAll: 'id='; print: (self id) ] on: Error do: [ :e | aStream nextPutAll: 'id=?' ].
	[ aStream nextPutAll: ' name='; print: (self name) ] on: Error do: [ :e | aStream nextPutAll: 'name=?' ].
	aStream nextPutAll: ')'
]

{ #category : 'facade' }
FridaDevice >> spawn: program [
	^ self spawn: program options: nil
]

{ #category : 'facade' }
FridaDevice >> attach: pid [
	^ self attach: pid options: nil
]

{ #category : 'facade' }
FridaDevice >> findProcessByName: name [
	^ self findProcessByName: name options: nil
]

{ #category : 'facade' }
FridaDevice >> findProcessByPid: pid [
	^ self findProcessByPid: pid options: nil
]

