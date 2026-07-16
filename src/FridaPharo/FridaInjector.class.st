"
GENERATED binding for the Frida FridaInjector GObject.
"
Class {
	#name : 'FridaInjector',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaInjector >> close [
	| raw |
	raw := self asyncBegin: 'frida_injector_close' finish: 'frida_injector_close_finish'.
	^ self
]

{ #category : 'generated' }
FridaInjector >> injectLibraryFile: pid path: path entrypoint: entrypoint data: data [
	| raw |
	raw := self asyncBegin: 'frida_injector_inject_library_file' finish: 'frida_injector_inject_library_file_finish' args: { { #int. pid } . { #string. path } . { #string. entrypoint } . { #string. data } }.
	^ raw asInteger
]

{ #category : 'generated' }
FridaInjector >> injectLibraryBlob: pid blob: blob entrypoint: entrypoint data: data [
	| raw |
	raw := self asyncBegin: 'frida_injector_inject_library_blob' finish: 'frida_injector_inject_library_blob_finish' args: { { #int. pid } . { #bytes. blob } . { #string. entrypoint } . { #string. data } }.
	^ raw asInteger
]

{ #category : 'generated' }
FridaInjector >> demonitor: id [
	| raw |
	raw := self asyncBegin: 'frida_injector_demonitor' finish: 'frida_injector_demonitor_finish' args: { { #int. id } }.
	^ self
]

{ #category : 'generated' }
FridaInjector >> demonitorAndCloneState: id [
	| raw |
	raw := self asyncBegin: 'frida_injector_demonitor_and_clone_state' finish: 'frida_injector_demonitor_and_clone_state_finish' args: { { #int. id } }.
	^ raw asInteger
]

{ #category : 'generated' }
FridaInjector >> recreateThread: pid id: id [
	| raw |
	raw := self asyncBegin: 'frida_injector_recreate_thread' finish: 'frida_injector_recreate_thread_finish' args: { { #int. pid } . { #int. id } }.
	^ self
]

