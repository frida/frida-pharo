"
uFFI binding to libfrida-pharo-glue.dylib, the C bridge that schedules async
ops onto Frida's thread and hands results back via signalSemaphoreWithIndex.
Path is provided at runtime through the FRIDA_PHARO_GLUE environment variable.
"
Class {
	#name : 'FridaGlueLibrary',
	#superclass : 'FFILibrary',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'accessing' }
FridaGlueLibrary >> macLibraryName [
	^ self resolvedLibraryName
]

{ #category : 'accessing' }
FridaGlueLibrary >> resolvedLibraryName [
	^ OSEnvironment current
		at: 'FRIDA_PHARO_GLUE'
		ifAbsent: [ 'libfrida-pharo-glue.dylib' ]
]

{ #category : 'accessing' }
FridaGlueLibrary >> unixLibraryName [
	^ self resolvedLibraryName
]
