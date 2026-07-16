"
Hand-written uFFI binding to the frida-core shared library.

frida-core is built as a static archive; we link it (plus its bundled GLib/Gum
and SDK dependencies) into a single ``libfrida-core.dylib`` that uFFI can
dlopen. See the repository Makefile target ``dylib`` for exactly how it is
produced. The absolute path is provided at runtime via the FRIDA_CORE_DYLIB
environment variable so the loop stays reproducible across machines.
"
Class {
	#name : 'FridaLibrary',
	#superclass : 'FFILibrary',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'accessing' }
FridaLibrary >> macLibraryName [
	^ self resolvedLibraryName
]

{ #category : 'accessing' }
FridaLibrary >> resolvedLibraryName [
	^ OSEnvironment current
		at: 'FRIDA_CORE_DYLIB'
		ifAbsent: [ 'libfrida-core.dylib' ]
]

{ #category : 'accessing' }
FridaLibrary >> unixLibraryName [
	^ self resolvedLibraryName
]
