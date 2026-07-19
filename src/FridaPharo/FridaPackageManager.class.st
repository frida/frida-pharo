"
GENERATED binding for the Frida FridaPackageManager GObject.
"
Class {
	#name : 'FridaPackageManager',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageManager class >> newRaw [
	^ self ffiCall: #(void* frida_package_manager_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaPackageManager >> registry [
	^ self ffiCall: #(String frida_package_manager_get_registry (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager >> registryRaw: aValue [
	^ self ffiCall: #(void frida_package_manager_set_registry (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager >> registry: aValue [
	self registryRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaPackageManager >> search: query options: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaPackageSearchOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self searchBegin: query marshalled0: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self searchFinish: asyncResult errorHolder: errorHolder ].
	^ FridaPackageSearchResult fromHandle: (raw) owned: true
]

{ #category : 'generated' }
FridaPackageManager >> searchBegin: query marshalled0: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_package_manager_search (self, String query, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager >> searchFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_package_manager_search_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager >> search: query options: options [
	^ self search: query options: options cancellable: nil
]

{ #category : 'generated' }
FridaPackageManager >> search: query [
	^ self search: query options: nil cancellable: nil
]

{ #category : 'generated' }
FridaPackageManager >> install: options cancellable: cancellable [
	| options0 marshalled0 cancellableHandle raw |
	options0 := options isNil ifTrue: [ nil ] ifFalse: [ FridaPackageInstallOptions configuredBy: options ].
	marshalled0 := options0 isNil ifTrue: [ ExternalAddress null ] ifFalse: [ options0 getHandle ].
	cancellableHandle := cancellable isNil ifTrue: [ ExternalAddress null ] ifFalse: [ cancellable getHandle ].
	raw := self asyncCall: [ :onReady | self installBegin: marshalled0 cancellable: cancellableHandle onReady: onReady userData: ExternalAddress null ] finish: [ :asyncResult :errorHolder | self installFinish: asyncResult errorHolder: errorHolder ].
	^ FridaPackageInstallResult fromHandle: (raw) owned: true
]

{ #category : 'generated' }
FridaPackageManager >> installBegin: marshalled0 cancellable: cancellable onReady: onReady userData: userData [
	^ self ffiCall: #(void frida_package_manager_install (self, void* marshalled0, void* cancellable, void* onReady, void* userData)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager >> installFinish: asyncResult errorHolder: errorHolder [
	^ self ffiCall: #(void* frida_package_manager_install_finish (self, void* asyncResult, void* errorHolder)) library: FridaLibrary
]

{ #category : 'generated' }
FridaPackageManager >> install: options [
	^ self install: options cancellable: nil
]

{ #category : 'generated' }
FridaPackageManager >> install [
	^ self install: nil cancellable: nil
]

{ #category : 'generated' }
FridaPackageManager >> onInstallProgress: aBlock [
	| callback |
	callback := FFICallback signature: #(void (void* instance, FridaPackageInstallPhase phase, double fraction, String details, void* userData)) block: [ :instance :phase :fraction :details :userData | aBlock valueWithArguments: { phase . fraction . details } ].
	^ self connectSignal: 'install-progress' callback: callback
]

