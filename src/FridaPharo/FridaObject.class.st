"
Hand-written base class for every generated Frida GObject wrapper.

Wraps an opaque Frida* pointer (via FFIExternalObject's #handle) and manages its
GObject refcount: owned handles are unref'd when the Pharo wrapper is finalized;
borrowed handles are ref'd on wrap. Also hosts the cross-thread async round-trip
(#asyncBegin:finish:) used by every generated async method.

Note: uFFI compiles any method containing #ffiCall: as the raw callout, so each
C call lives alone in a #prim* primitive and the logic lives in its caller.
"
Class {
	#name : 'FridaObject',
	#superclass : 'FFIExternalObject',
	#classVars : [ 'Initialized' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'primitives' }
FridaObject class >> primInit [
	^ self ffiCall: #(void frida_init()) library: FridaLibrary
]

{ #category : 'primitives' }
FridaObject class >> primRef: aHandle [
	^ self ffiCall: #(void* g_object_ref (void* aHandle)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaObject class >> primUnref: aHandle [
	^ self ffiCall: #(void g_object_unref (void* aHandle)) library: FridaLibrary
]

{ #category : 'initialization' }
FridaObject class >> ensureFridaInitialized [
	Initialized ifNotNil: [ ^ self ].
	self primInit.
	Initialized := true
]

{ #category : 'refcounting' }
FridaObject class >> ref: aHandle [
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ self ].
	self primRef: aHandle
]

{ #category : 'refcounting' }
FridaObject class >> unref: aHandle [
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ self ].
	self primUnref: aHandle
]

{ #category : 'finalization' }
FridaObject class >> finalizationRegistry [
	^ FinalizationRegistry default
]

{ #category : 'wrapping' }
FridaObject class >> fromBorrowedHandle: aHandle [
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	self ref: aHandle.
	^ (self fromHandle: aHandle) registerForRelease
]

{ #category : 'wrapping' }
FridaObject class >> fromHandle: aHandle [
	^ self basicNew
		setHandle: aHandle;
		yourself
]

{ #category : 'wrapping' }
FridaObject class >> fromOwnedHandle: aHandle [
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	^ (self fromHandle: aHandle) registerForRelease
]

{ #category : 'wrapping' }
FridaObject class >> concreteClassForHandle: aHandle [
	"Resolve the concrete generated class from the instance's GObject type name,
	 which equals the Pharo class name (e.g. 'FridaDevice'). Falls back to the
	 receiver when unknown."
	| typeName |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ self ].
	typeName := FridaGlue instanceTypeName: aHandle.
	typeName ifNil: [ ^ self ].
	^ Smalltalk globals at: typeName asSymbol ifAbsent: [ self ]
]

{ #category : 'wrapping' }
FridaObject class >> wrapBorrowed: aHandle [
	"Like #fromBorrowedHandle: but wraps as the runtime concrete class."
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	^ (self concreteClassForHandle: aHandle) fromBorrowedHandle: aHandle
]

{ #category : 'wrapping' }
FridaObject class >> wrapOwned: aHandle [
	"Like #fromOwnedHandle: but wraps as the runtime concrete class."
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	^ (self concreteClassForHandle: aHandle) fromOwnedHandle: aHandle
]

{ #category : 'async' }
FridaObject >> asyncBegin: beginSymbol finish: finishSymbol [
	^ self asyncBegin: beginSymbol finish: finishSymbol args: #()
]

{ #category : 'async' }
FridaObject >> asyncBegin: beginSymbol finish: finishSymbol args: anArgList [
	"Schedule beginSymbol (with anArgList marshalled onto the operation) on
	 Frida's own thread; block this Pharo process on a Semaphore until the
	 completion callback has run finishSymbol on Frida's thread; then return the
	 raw result pointer (or raise FridaError). anArgList is an ordered collection
	 of #(kind value) pairs where kind is #int, #string, #pointer, #bytes,
	 #variant or #vardict. Reference-typed args (bytes/variant/vardict) are built
	 here and owned by the operation, which frees them after _finish. Only the
	 wrapping of the raw result happens back here on the Pharo thread."
	| sem index op errorHandle raw message code |
	FridaObject ensureFridaInitialized.
	sem := Semaphore new.
	index := Smalltalk registerExternalObject: sem.
	op := FridaGlue
		operationForIndex: index
		self: self getHandle
		begin: beginSymbol
		finish: finishSymbol
		cancellable: ExternalAddress null.
	anArgList doWithIndex: [ :pair :position | | kind value slot |
		kind := pair first.
		value := pair second.
		slot := position - 1.
		kind == #int ifTrue: [ FridaGlue operation: op setIntArg: slot value: value ].
		kind == #string ifTrue: [ FridaGlue operation: op setStringArg: slot value: value ].
		kind == #pointer ifTrue: [ FridaGlue operation: op setPointerArg: slot value: value ].
		kind == #bytes ifTrue: [ FridaGlue operation: op setOwnedArg: slot value: (self bytesFromByteArray: value) freeKind: 1 ].
		kind == #variant ifTrue: [ FridaGlue operation: op setOwnedArg: slot value: (FridaVariant encode: value) freeKind: 2 ].
		kind == #vardict ifTrue: [ FridaGlue operation: op setOwnedArg: slot value: (FridaVardict encode: value) freeKind: 3 ] ].
	FridaGlue schedule: op.
	sem wait.
	Smalltalk unregisterExternalObject: sem.
	errorHandle := FridaGlue errorOf: op.
	(errorHandle isNil or: [ errorHandle isNull ]) ifFalse: [
		message := FridaGlue errorMessage: errorHandle.
		code := FridaGlue errorCode: errorHandle.
		FridaGlue free: op.
		^ FridaError signalMessage: message code: code ].
	raw := FridaGlue resultOf: op.
	FridaGlue free: op.
	^ raw
]

{ #category : 'errors' }
FridaObject >> checkError: anErrorHolder [
	"Read the GError* written into anErrorHolder by a throwing sync call; free the
	 holder, and raise FridaError if an error was set."
	| gerror message code |
	gerror := anErrorHolder pointerAt: 1.
	anErrorHolder free.
	(gerror isNil or: [ gerror isNull ]) ifTrue: [ ^ self ].
	message := FridaGlue errorMessage: gerror.
	code := FridaGlue errorCode: gerror.
	FridaGlue errorFree: gerror.
	^ FridaError signalMessage: message code: code
]

{ #category : 'marshalling' }
FridaObject >> bytesFromByteArray: aByteArrayOrNil [
	"ByteArray -> a fresh GBytes* (copies); nil -> NULL. Caller unrefs its ref."
	aByteArrayOrNil ifNil: [ ^ ExternalAddress null ].
	^ FridaGlue bytesNew: aByteArrayOrNil size: aByteArrayOrNil size
]

{ #category : 'marshalling' }
FridaObject >> strvFromArray: anArrayOrNil [
	"Array of String -> a fresh NULL-terminated gchar** (copies); nil -> NULL.
	 Caller frees with FridaGlue strvFree:."
	| strv |
	anArrayOrNil ifNil: [ ^ ExternalAddress null ].
	strv := FridaGlue strvNew: anArrayOrNil size.
	anArrayOrNil doWithIndex: [ :string :i | FridaGlue strv: strv set: i - 1 value: string ].
	^ strv
]

{ #category : 'marshalling' }
FridaObject >> valueFromVariant: aVariantHandle owned: isOwned [
	"GVariant* -> Pharo value; unref when we own the reference."
	| value |
	(aVariantHandle isNil or: [ aVariantHandle isNull ]) ifTrue: [ ^ nil ].
	value := FridaVariant decode: aVariantHandle.
	isOwned ifTrue: [ FridaGlue variantUnref: aVariantHandle ].
	^ value
]

{ #category : 'marshalling' }
FridaObject >> dictFromVardict: aTableHandle owned: isOwned [
	"GHashTable<utf8,GVariant>* -> Dictionary; unref when we own the reference."
	| value |
	(aTableHandle isNil or: [ aTableHandle isNull ]) ifTrue: [ ^ nil ].
	value := FridaVardict decode: aTableHandle.
	isOwned ifTrue: [ FridaGlue vardictUnref: aTableHandle ].
	^ value
]

{ #category : 'marshalling' }
FridaObject >> stringFromCharPointer: aHandle owned: isOwned [
	"gchar* -> String (copies). g_free only when we own it."
	| string |
	(aHandle isNil or: [ aHandle isNull ]) ifTrue: [ ^ nil ].
	string := aHandle readString.
	isOwned ifTrue: [ FridaGlue gfree: aHandle ].
	^ string
]

{ #category : 'marshalling' }
FridaObject >> byteArrayFromBytes: aBytesHandle owned: isOwned [
	"GBytes* -> ByteArray (copies). Unrefs only when we own the reference."
	| size bytes |
	(aBytesHandle isNil or: [ aBytesHandle isNull ]) ifTrue: [ ^ nil ].
	size := FridaGlue bytesSize: aBytesHandle.
	bytes := ByteArray new: size.
	size > 0 ifTrue: [ FridaGlue bytes: aBytesHandle copyTo: bytes ].
	isOwned ifTrue: [ FridaGlue bytesUnref: aBytesHandle ].
	^ bytes
]

{ #category : 'marshalling' }
FridaObject >> arrayFromStrv: aStrvHandle owned: isOwned [
	"gchar** -> Array of String (copies). g_strfreev only when we own it; a
	 container-owned strv (transfer none) must not be freed."
	| length result |
	(aStrvHandle isNil or: [ aStrvHandle isNull ]) ifTrue: [ ^ #() ].
	length := FridaGlue strvLength: aStrvHandle.
	result := Array new: length.
	1 to: length do: [ :i | result at: i put: (FridaGlue strv: aStrvHandle get: i - 1) ].
	isOwned ifTrue: [ FridaGlue strvFree: aStrvHandle ].
	^ result
]

{ #category : 'errors' }
FridaObject >> newErrorHolder [
	"A zeroed one-pointer buffer to pass as a GError**."
	| holder |
	holder := ExternalAddress allocate: 8.
	holder pointerAt: 1 put: ExternalAddress null.
	^ holder
]

{ #category : 'signals' }
FridaObject >> on: aSignalName do: aBlock [
	"Subscribe to any GObject signal on this object; the block receives an Array
	 of the decoded signal arguments, delivered on the Pharo thread. Returns a
	 FridaSignalSubscription; send it #off to unsubscribe."
	^ FridaSignalSubscription onObject: self signal: aSignalName do: aBlock
]

{ #category : 'finalization' }
FridaObject >> finalize [
	FridaObject unref: self getHandle
]

{ #category : 'finalization' }
FridaObject >> registerForRelease [
	self class finalizationRegistry add: self.
	^ self
]
