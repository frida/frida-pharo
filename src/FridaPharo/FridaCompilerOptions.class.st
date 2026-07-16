"
GENERATED binding for the Frida FridaCompilerOptions GObject.
"
Class {
	#name : 'FridaCompilerOptions',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaCompilerOptions class >> newRaw [
	^ self ffiCall: #(void* frida_compiler_options_new ()) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions class >> new [
	FridaObject ensureFridaInitialized.
	^ self fromOwnedHandle: (self newRaw)
]

{ #category : 'generated' }
FridaCompilerOptions >> projectRoot [
	^ self ffiCall: #(String frida_compiler_options_get_project_root (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> outputFormat [
	^ self ffiCall: #(FridaOutputFormat frida_compiler_options_get_output_format (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> bundleFormat [
	^ self ffiCall: #(FridaBundleFormat frida_compiler_options_get_bundle_format (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> typeCheck [
	^ self ffiCall: #(FridaTypeCheckMode frida_compiler_options_get_type_check (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> sourceMaps [
	^ self ffiCall: #(FridaSourceMaps frida_compiler_options_get_source_maps (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> compression [
	^ self ffiCall: #(FridaJsCompression frida_compiler_options_get_compression (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> platform [
	^ self ffiCall: #(FridaJsPlatform frida_compiler_options_get_platform (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> projectRootRaw: aValue [
	^ self ffiCall: #(void frida_compiler_options_set_project_root (self, String aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> projectRoot: aValue [
	self projectRootRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaCompilerOptions >> outputFormatRaw: aValue [
	^ self ffiCall: #(void frida_compiler_options_set_output_format (self, FridaOutputFormat aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> outputFormat: aValue [
	self outputFormatRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaCompilerOptions >> bundleFormatRaw: aValue [
	^ self ffiCall: #(void frida_compiler_options_set_bundle_format (self, FridaBundleFormat aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> bundleFormat: aValue [
	self bundleFormatRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaCompilerOptions >> typeCheckRaw: aValue [
	^ self ffiCall: #(void frida_compiler_options_set_type_check (self, FridaTypeCheckMode aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> typeCheck: aValue [
	self typeCheckRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaCompilerOptions >> sourceMapsRaw: aValue [
	^ self ffiCall: #(void frida_compiler_options_set_source_maps (self, FridaSourceMaps aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> sourceMaps: aValue [
	self sourceMapsRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaCompilerOptions >> compressionRaw: aValue [
	^ self ffiCall: #(void frida_compiler_options_set_compression (self, FridaJsCompression aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> compression: aValue [
	self compressionRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaCompilerOptions >> platformRaw: aValue [
	^ self ffiCall: #(void frida_compiler_options_set_platform (self, FridaJsPlatform aValue)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> platform: aValue [
	self platformRaw: aValue.
	^ self
]

{ #category : 'generated' }
FridaCompilerOptions >> clearExternals [
	^ self ffiCall: #(void frida_compiler_options_clear_externals (self)) library: FridaLibrary
]

{ #category : 'generated' }
FridaCompilerOptions >> addExternal: external [
	^ self ffiCall: #(void frida_compiler_options_add_external (self, String external)) library: FridaLibrary
]

