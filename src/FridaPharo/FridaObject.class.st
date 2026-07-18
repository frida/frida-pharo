"
Hand-written base class for every generated Frida GObject wrapper.

Wraps an opaque Frida* pointer (via FFIExternalObject's #handle) and manages its
GObject refcount: owned handles are unref'd when the Pharo wrapper is finalized;
borrowed handles are ref'd on wrap. Also hosts the async round-trip
(#asyncCall:finish:) that every generated async method drives on FridaMainLoop.

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
FridaObject class >> primInitWithRuntime: aRuntime [
	"FRIDA_RUNTIME_GLIB = 0: Frida runs no thread of its own and schedules on the
	 default GMainContext, which FridaMainLoop drives from Pharo."
	^ self ffiCall: #(void frida_init_with_runtime (int aRuntime)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaObject class >> primRef: aHandle [
	^ self ffiCall: #(void* g_object_ref (void* aHandle)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaObject >> primConnect: aSignalName handler: aHandler data: aData destroy: aNotify flags: aFlags [
	^ self ffiCall: #(ulong g_signal_connect_data (self, String aSignalName, void* aHandler, void* aData, void* aNotify, int aFlags)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaObject >> primDisconnect: aHandlerId [
	^ self ffiCall: #(void g_signal_handler_disconnect (self, ulong aHandlerId)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaObject class >> primUnref: aHandle [
	^ self ffiCall: #(void g_object_unref (void* aHandle)) library: FridaLibrary
]

{ #category : 'initialization' }
FridaObject class >> ensureFridaInitialized [
	Initialized ifNotNil: [ ^ self ].
	self primInitWithRuntime: 0.
	FridaMainLoop default.
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
FridaObject >> asyncCall: beginBlock finish: finishBlock [
	"Drive an async _begin/_finish pair on the Frida main loop (no C glue).
	 beginBlock is evaluated with a GAsyncReadyCallback handle and issues the
	 _begin call, scheduling the operation on the default GMainContext. When it
	 completes, FridaMainLoop's dispatch invokes the callback on the VM thread;
	 finishBlock runs there with the GAsyncResult and a GError** holder, calls
	 _finish, and answers the raw result. This process blocks on a Semaphore until
	 then, then raises FridaError if _finish set an error, else answers the raw
	 result. Reference-typed args (GBytes/GVariant/vardict) are built and freed by
	 the generated caller around this send."
	| sem callback errorHolder result |
	FridaObject ensureFridaInitialized.
	sem := Semaphore new.
	errorHolder := self newErrorHolder.
	callback := FFICallback
		signature: #(void (void* source, void* asyncResult, void* userData))
		block: [ :source :asyncResult :userData |
			result := finishBlock value: asyncResult value: errorHolder.
			sem signal ].
	beginBlock value: callback getHandle.
	FridaMainLoop default wakeup.
	sem wait.
	self checkError: errorHolder.
	^ result
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
FridaObject >> connectSignal: aSignalName callback: aCallback [
	"Connect a retained typed FFICallback (built by a generated onXxx: connector)
	 to aSignalName. The callback fires on the VM thread during FridaMainLoop's
	 dispatch. Answer a FridaSignalSubscription; send it #off to disconnect and
	 release the callback."
	| handlerId |
	FridaObject ensureFridaInitialized.
	handlerId := self primConnect: aSignalName handler: aCallback getHandle data: ExternalAddress null destroy: ExternalAddress null flags: 0.
	^ FridaSignalSubscription source: self handlerId: handlerId callback: aCallback
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
