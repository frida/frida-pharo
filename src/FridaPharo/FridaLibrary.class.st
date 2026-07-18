"
Hand-written uFFI binding to the frida-core shared library.

frida-core ships as a static archive, but uFFI needs a shared library, so we use
a single ``libfrida-core`` linked from frida-core's published devkit (see
tools/build-lib.sh and the release workflow). The path is resolved once, in
order:

  1. the FRIDA_CORE_LIB environment variable (a developer's local build);
  2. a previously downloaded copy in the per-image cache;
  3. otherwise the prebuilt for this platform + pinned frida version is fetched
     from the frida-pharo GitHub release, checksum-verified, and cached.

So a first-time user just loads the baseline and calls Frida -- nothing to
compile, no environment to set.
"
Class {
	#name : 'FridaLibrary',
	#superclass : 'FFILibrary',
	#classVars : [ 'ResolvedPath' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'accessing' }
FridaLibrary class >> coreVersion [
	"The frida-core release the prebuilt libraries are fetched from."
	^ '17.16.1'
]

{ #category : 'resolving' }
FridaLibrary class >> resolvedLibraryPath [
	^ ResolvedPath ifNil: [ ResolvedPath := self resolveLibraryPath ]
]

{ #category : 'resolving' }
FridaLibrary class >> reset [
	"Forget the resolved path; the next call resolves (and maybe downloads) again."
	ResolvedPath := nil
]

{ #category : 'resolving' }
FridaLibrary class >> resolveLibraryPath [
	^ (OSEnvironment current at: 'FRIDA_CORE_LIB' ifAbsent: [ nil ])
		ifNil: [ self ensureCachedLibrary fullName ]
]

{ #category : 'resolving' }
FridaLibrary class >> ensureCachedLibrary [
	| file |
	file := self cacheDirectory / self libraryFileName.
	file exists ifFalse: [ self downloadLibraryTo: file ].
	^ file
]

{ #category : 'resolving' }
FridaLibrary class >> cacheDirectory [
	^ (FileLocator imageDirectory / 'frida-pharo') ensureCreateDirectory
]

{ #category : 'resolving' }
FridaLibrary class >> libraryFileName [
	^ 'libfrida-core-' , self coreVersion , '-' , self platformSlug , '.' , self librarySuffix
]

{ #category : 'resolving' }
FridaLibrary class >> librarySuffix [
	Smalltalk os isMacOS ifTrue: [ ^ 'dylib' ].
	Smalltalk os isWindows ifTrue: [ ^ 'dll' ].
	^ 'so'
]

{ #category : 'resolving' }
FridaLibrary class >> platformSlug [
	"frida's own release slug, e.g. macos-arm64 / linux-x86_64."
	| os |
	os := Smalltalk os isMacOS
		ifTrue: [ 'macos' ]
		ifFalse: [ Smalltalk os isWindows ifTrue: [ 'windows' ] ifFalse: [ 'linux' ] ].
	^ os , '-' , self architectureSlug
]

{ #category : 'resolving' }
FridaLibrary class >> architectureSlug [
	| arch |
	arch := (Smalltalk vm getSystemAttribute: 1003) asLowercase.
	arch = 'aarch64' ifTrue: [ ^ 'arm64' ].
	arch = 'amd64' ifTrue: [ ^ 'x86_64' ].
	^ arch
]

{ #category : 'downloading' }
FridaLibrary class >> downloadLibraryTo: aFile [
	| expected partial actual |
	expected := self expectedChecksumFor: self libraryFileName.
	partial := aFile parent / (aFile basename , '.partial').
	Transcript show: 'frida-pharo: fetching ' , self libraryFileName , ' from the ' , self coreVersion , ' release...'; cr; flush.
	ZnClient new
		enforceHttpSuccess: true;
		url: (self assetUrlFor: self libraryFileName);
		downloadTo: partial.
	actual := (SHA256 new hashMessage: partial binaryReadStream upToEnd) hex asLowercase.
	actual = expected ifFalse: [
		partial ensureDelete.
		^ self error: 'frida-pharo: checksum mismatch for ' , self libraryFileName ].
	partial renameTo: aFile basename.
	^ aFile
]

{ #category : 'downloading' }
FridaLibrary class >> expectedChecksumFor: aName [
	"The SHA256SUMS asset holds one `<hex>  <name>` line per prebuilt."
	| sums line |
	sums := (ZnClient new
		enforceHttpSuccess: true;
		get: (self assetUrlFor: 'SHA256SUMS')) asString.
	line := sums lines
		detect: [ :each | each endsWith: aName ]
		ifNone: [ ^ self error: 'frida-pharo: no checksum for ' , aName , ' in the ' , self coreVersion , ' release' ].
	^ (line substrings: ' ') first asLowercase
]

{ #category : 'downloading' }
FridaLibrary class >> assetUrlFor: aName [
	^ 'https://github.com/frida/frida-pharo/releases/download/core-' , self coreVersion , '/' , aName
]

{ #category : 'accessing' }
FridaLibrary >> macLibraryName [
	^ self class resolvedLibraryPath
]

{ #category : 'accessing' }
FridaLibrary >> unixLibraryName [
	^ self class resolvedLibraryPath
]

{ #category : 'accessing' }
FridaLibrary >> win32LibraryName [
	^ self class resolvedLibraryPath
]
