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
FridaInjector >> close: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self closeBegin: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self closeFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaInjector >> closeBegin: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_injector_close (self, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> closeFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_injector_close_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> close [
	^ self close: nil
]

{ #category : 'generated' }
FridaInjector >> injectLibraryFile: pid path: path entrypoint: entrypoint data: data cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self injectLibraryFileBegin: pid path: path entrypoint: entrypoint data: data cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self injectLibraryFileFinish: asyncResult errorHolder: errorHolder ].
	^ raw
]

{ #category : 'generated' }
FridaInjector >> injectLibraryFileBegin: pid path: path entrypoint: entrypoint data: data cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_injector_inject_library_file (self, uint pid, String path, String entrypoint, String data, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> injectLibraryFileFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(uint frida_injector_inject_library_file_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> injectLibraryFile: pid path: path entrypoint: entrypoint data: data [
	^ self injectLibraryFile: pid path: path entrypoint: entrypoint data: data cancellable: nil
]

{ #category : 'generated' }
FridaInjector >> injectLibraryBlob: pid blob: blob entrypoint: entrypoint data: data cancellable: cancellable [
	| marshalled0 cancellableHandle raw |
	marshalled0 := self bytesFromByteArray: blob.
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self injectLibraryBlobBegin: pid marshalled0: marshalled0 entrypoint: entrypoint data: data cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self injectLibraryBlobFinish: asyncResult errorHolder: errorHolder ].
	FridaGlue bytesUnref: marshalled0.
	^ raw
]

{ #category : 'generated' }
FridaInjector >> injectLibraryBlobBegin: pid marshalled0: marshalled0 entrypoint: entrypoint data: data cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_injector_inject_library_blob (self, uint pid, void* marshalled0, String entrypoint, String data, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> injectLibraryBlobFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(uint frida_injector_inject_library_blob_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> injectLibraryBlob: pid blob: blob entrypoint: entrypoint data: data [
	^ self injectLibraryBlob: pid blob: blob entrypoint: entrypoint data: data cancellable: nil
]

{ #category : 'generated' }
FridaInjector >> demonitor: id cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self demonitorBegin: id cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self demonitorFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaInjector >> demonitorBegin: id cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_injector_demonitor (self, uint id, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> demonitorFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_injector_demonitor_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> demonitor: id [
	^ self demonitor: id cancellable: nil
]

{ #category : 'generated' }
FridaInjector >> demonitorAndCloneState: id cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self demonitorAndCloneStateBegin: id cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self demonitorAndCloneStateFinish: asyncResult errorHolder: errorHolder ].
	^ raw
]

{ #category : 'generated' }
FridaInjector >> demonitorAndCloneStateBegin: id cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_injector_demonitor_and_clone_state (self, uint id, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> demonitorAndCloneStateFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(uint frida_injector_demonitor_and_clone_state_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> demonitorAndCloneState: id [
	^ self demonitorAndCloneState: id cancellable: nil
]

{ #category : 'generated' }
FridaInjector >> recreateThread: pid id: id cancellable: cancellable [
	| cancellableHandle raw |
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self recreateThreadBegin: pid id: id cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self recreateThreadFinish: asyncResult errorHolder: errorHolder ].
	^ self
]

{ #category : 'generated' }
FridaInjector >> recreateThreadBegin: pid id: id cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_injector_recreate_thread (self, uint pid, uint id, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> recreateThreadFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void frida_injector_recreate_thread_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaInjector >> recreateThread: pid id: id [
	^ self recreateThread: pid id: id cancellable: nil
]

{ #category : 'generated' }
FridaInjector >> onUninjected: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, uint id, void* userData)) block: [ :instance :id :userData | aBlock valueWithArguments: { id } ].
	^ self connectSignal: 'uninjected' callback: callback
]

