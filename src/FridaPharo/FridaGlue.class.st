"
Pointer-level data-marshalling helpers built directly on GLib via uFFI (no C
glue): GError, GBytes, gchar**, GVariant and the a{sv} vardict. One #ffiCall: per
#prim* method; the logic (pointer arithmetic, GLib function-pointer wiring, the
GVariant ref dance) lives in the plain callers.
"
Class {
	#name : 'FridaGlue',
	#superclass : 'Object',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'primitives' }
FridaGlue class >> glibFunction: aName [
	"Address of an exported GLib function, for passing as a C callback pointer."
	^ ExternalAddress loadSymbol: aName from: FridaLibrary
]

{ #category : 'errors' }
FridaGlue class >> errorCode: anErrorHandle [
	"GError.code is the gint at byte offset 4 (after the GQuark domain)."
	^ anErrorHandle signedLongAt: 5
]

{ #category : 'errors' }
FridaGlue class >> errorMessage: anErrorHandle [
	"GError.message is the gchar* at byte offset 8."
	^ (anErrorHandle pointerAt: 9) readString utf8Decoded
]

{ #category : 'errors' }
FridaGlue class >> errorFree: anErrorHandle [
	^ self ffiCall: #(void g_error_free (void* anErrorHandle)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> gfree: aHandle [
	^ self ffiCall: #(void g_free (void* aHandle)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> instanceTypeName: aHandle [
	"g_type_name (G_TYPE_FROM_INSTANCE (aHandle)): the instance's g_class pointer
	 is at offset 0, and that class's GType is at its own offset 0."
	| gclass gtype |
	gclass := aHandle pointerAt: 1.
	gtype := gclass unsignedLongLongAt: 1.
	^ self typeName: gtype
]

{ #category : 'marshalling' }
FridaGlue class >> typeName: aGType [
	^ self ffiCall: #(String g_type_name (ulong aGType)) library: FridaLibrary
]

{ #category : 'diagnostics' }
FridaGlue class >> symbolAvailable: aName [
	^ [ (self glibFunction: aName) isNull not ] on: Error do: [ false ]
]

{ #category : 'variant decode' }
FridaGlue class >> variantTypeString: aVariant [
	^ self ffiCall: #(String g_variant_get_type_string (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantChildCount: aVariant [
	^ self ffiCall: #(int g_variant_n_children (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variant: aVariant child: anIndex [
	^ self ffiCall: #(void* g_variant_get_child_value (void* aVariant, ulonglong anIndex)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantUnbox: aVariant [
	^ self ffiCall: #(void* g_variant_get_variant (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantUnref: aVariant [
	^ self ffiCall: #(void g_variant_unref (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantString: aVariant [
	^ self variantString: aVariant length: ExternalAddress null
]

{ #category : 'variant decode' }
FridaGlue class >> variantString: aVariant length: aLengthOut [
	^ self ffiCall: #(String g_variant_get_string (void* aVariant, void* aLengthOut)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantBoolean: aVariant [
	^ self ffiCall: #(int g_variant_get_boolean (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantDouble: aVariant [
	^ self ffiCall: #(double g_variant_get_double (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantInt: aVariant [
	"g_variant_classify returns the type's ASCII class code; dispatch to the
	 width-correct getter (mirrors the C switch)."
	| class |
	class := self variantClassify: aVariant.
	class = $y asInteger ifTrue: [ ^ self variantByte: aVariant ].
	class = $n asInteger ifTrue: [ ^ self variantInt16: aVariant ].
	class = $q asInteger ifTrue: [ ^ self variantUint16: aVariant ].
	class = $i asInteger ifTrue: [ ^ self variantInt32: aVariant ].
	class = $u asInteger ifTrue: [ ^ self variantUint32: aVariant ].
	class = $x asInteger ifTrue: [ ^ self variantInt64: aVariant ].
	class = $t asInteger ifTrue: [ ^ self variantUint64: aVariant ].
	class = $h asInteger ifTrue: [ ^ self variantHandle: aVariant ].
	^ 0
]

{ #category : 'variant decode' }
FridaGlue class >> variantClassify: aVariant [
	^ self ffiCall: #(int g_variant_classify (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantByte: aVariant [
	^ self ffiCall: #(uchar g_variant_get_byte (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantInt16: aVariant [
	^ self ffiCall: #(short g_variant_get_int16 (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantUint16: aVariant [
	^ self ffiCall: #(ushort g_variant_get_uint16 (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantInt32: aVariant [
	^ self ffiCall: #(int g_variant_get_int32 (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantUint32: aVariant [
	^ self ffiCall: #(uint g_variant_get_uint32 (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantInt64: aVariant [
	^ self ffiCall: #(longlong g_variant_get_int64 (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantUint64: aVariant [
	^ self ffiCall: #(ulonglong g_variant_get_uint64 (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantHandle: aVariant [
	^ self ffiCall: #(int g_variant_get_handle (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantSize: aVariant [
	^ self ffiCall: #(ulonglong g_variant_get_size (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variant: aVariant copyDataTo: aByteArray [
	| data |
	data := self variantData: aVariant.
	1 to: aByteArray size do: [ :i | aByteArray at: i put: (data unsignedByteAt: i) ]
]

{ #category : 'variant decode' }
FridaGlue class >> variantData: aVariant [
	^ self ffiCall: #(void* g_variant_get_data (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewString: aString [
	^ self variantRefSink: (self variantNewStringRaw: aString)
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewStringRaw: aString [
	^ self ffiCall: #(void* g_variant_new_string (String aString)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewInt64: aValue [
	^ self variantRefSink: (self variantNewInt64Raw: aValue)
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewInt64Raw: aValue [
	^ self ffiCall: #(void* g_variant_new_int64 (longlong aValue)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewBoolean: aValue [
	^ self variantRefSink: (self variantNewBooleanRaw: aValue)
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewBooleanRaw: aValue [
	^ self ffiCall: #(void* g_variant_new_boolean (int aValue)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewDouble: aValue [
	^ self variantRefSink: (self variantNewDoubleRaw: aValue)
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewDoubleRaw: aValue [
	^ self ffiCall: #(void* g_variant_new_double (double aValue)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewBytes: aByteArray size: aSize [
	"G_VARIANT_TYPE_BYTE is the type string 'y'; element size 1."
	^ self variantRefSink: (self variantNewFixedArray: 'y' data: aByteArray count: aSize elementSize: 1)
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewFixedArray: aType data: aByteArray count: aCount elementSize: anElementSize [
	^ self ffiCall: #(void* g_variant_new_fixed_array (String aType, void* aByteArray, ulonglong aCount, ulonglong anElementSize)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantRefSink: aVariant [
	^ self ffiCall: #(void* g_variant_ref_sink (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewVariant: aVariant [
	^ self ffiCall: #(void* g_variant_new_variant (void* aVariant)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewDictEntryKey: aKeyVariant value: aValueVariant [
	^ self ffiCall: #(void* g_variant_new_dict_entry (void* aKeyVariant, void* aValueVariant)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderNewDict [
	^ self variantBuilderNew: 'a{sv}'
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderNewArray [
	^ self variantBuilderNew: 'av'
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderNew: aType [
	^ self ffiCall: #(void* g_variant_builder_new (String aType)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilder: aBuilder addKey: aKey value: aValue [
	"An a{sv} element is a {sv} dict entry (added directly); its value is boxed
	 as a variant ('v'), matching g_variant_builder_add(b,'{sv}',...)."
	self
		variantBuilder: aBuilder
		addElement: (self
			variantNewDictEntryKey: (self variantNewStringRaw: aKey)
			value: (self variantNewVariant: aValue))
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilder: aBuilder addValue: aValue [
	"An av element is the value boxed as a variant ('v')."
	self variantBuilder: aBuilder addElement: (self variantNewVariant: aValue)
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilder: aBuilder addElement: aVariant [
	^ self ffiCall: #(void g_variant_builder_add_value (void* aBuilder, void* aVariant)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderEnd: aBuilder [
	| result |
	result := self variantRefSink: (self variantBuilderEndRaw: aBuilder).
	self variantBuilderUnref: aBuilder.
	^ result
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderEndRaw: aBuilder [
	^ self ffiCall: #(void* g_variant_builder_end (void* aBuilder)) library: FridaLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderUnref: aBuilder [
	^ self ffiCall: #(void g_variant_builder_unref (void* aBuilder)) library: FridaLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardictNew [
	"a{sv}: keys owned (g_free), values owned (g_variant_unref)."
	^ self
		vardictNewHash: (self glibFunction: 'g_str_hash')
		equal: (self glibFunction: 'g_str_equal')
		keyDestroy: (self glibFunction: 'g_free')
		valueDestroy: (self glibFunction: 'g_variant_unref')
]

{ #category : 'vardict' }
FridaGlue class >> vardictNewHash: aHashFunc equal: anEqualFunc keyDestroy: aKeyDestroy valueDestroy: aValueDestroy [
	^ self ffiCall: #(void* g_hash_table_new_full (void* aHashFunc, void* anEqualFunc, void* aKeyDestroy, void* aValueDestroy)) library: FridaLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardict: aTable insertKey: aKey value: aVariant [
	"The table owns its keys, so hand it a fresh g_strdup copy."
	self vardict: aTable insertOwnedKey: (self strdup: aKey) value: aVariant
]

{ #category : 'vardict' }
FridaGlue class >> vardict: aTable insertOwnedKey: aKey value: aVariant [
	^ self ffiCall: #(void g_hash_table_insert (void* aTable, void* aKey, void* aVariant)) library: FridaLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardictUnref: aTable [
	^ self ffiCall: #(void g_hash_table_unref (void* aTable)) library: FridaLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardictDupKeys: aTable [
	"Shallow key array (borrowed) -> deep NULL-terminated copy; free the shallow one."
	| keys duplicate |
	keys := self vardictKeysAsArray: aTable length: ExternalAddress null.
	duplicate := self strdupv: keys.
	self gfree: keys.
	^ duplicate
]

{ #category : 'vardict' }
FridaGlue class >> vardictKeysAsArray: aTable length: aLengthOut [
	^ self ffiCall: #(void* g_hash_table_get_keys_as_array (void* aTable, void* aLengthOut)) library: FridaLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardict: aTable lookup: aKey [
	^ self ffiCall: #(void* g_hash_table_lookup (void* aTable, String aKey)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strdup: aString [
	^ self ffiCall: #(void* g_strdup (String aString)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strdupv: aStrvHandle [
	^ self ffiCall: #(void* g_strdupv (void* aStrvHandle)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> bytes: aBytesHandle copyTo: aByteArray [
	| data |
	data := self bytesData: aBytesHandle size: ExternalAddress null.
	1 to: aByteArray size do: [ :i | aByteArray at: i put: (data unsignedByteAt: i) ]
]

{ #category : 'marshalling' }
FridaGlue class >> bytesData: aBytesHandle size: aSizeOut [
	^ self ffiCall: #(void* g_bytes_get_data (void* aBytesHandle, void* aSizeOut)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> bytesNew: aByteArray size: aSize [
	^ self ffiCall: #(void* g_bytes_new (void* aByteArray, ulonglong aSize)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> bytesSize: aBytesHandle [
	^ self ffiCall: #(ulonglong g_bytes_get_size (void* aBytesHandle)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> bytesUnref: aBytesHandle [
	^ self ffiCall: #(void g_bytes_unref (void* aBytesHandle)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strvFree: aStrvHandle [
	^ self ffiCall: #(void g_strfreev (void* aStrvHandle)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strv: aStrvHandle get: anIndex [
	"Element anIndex (0-based) is the gchar* at byte offset anIndex * pointer-size."
	^ (aStrvHandle pointerAt: anIndex * 8 + 1) readString utf8Decoded
]

{ #category : 'marshalling' }
FridaGlue class >> strvLength: aStrvHandle [
	^ self ffiCall: #(uint g_strv_length (void* aStrvHandle)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strvNew: aLength [
	"A NULL-terminated gchar** of aLength slots (+1 for the terminator)."
	^ self allocateZeroed: aLength + 1 * 8
]

{ #category : 'marshalling' }
FridaGlue class >> allocateZeroed: aByteCount [
	^ self ffiCall: #(void* g_malloc0 (ulonglong aByteCount)) library: FridaLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strv: aStrvHandle set: anIndex value: aString [
	aStrvHandle pointerAt: anIndex * 8 + 1 put: (self strdup: aString)
]
