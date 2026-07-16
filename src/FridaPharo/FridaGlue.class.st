"
Thin uFFI primitive wrappers over libfrida-pharo-glue.dylib. One #ffiCall: per
method (uFFI compiles the whole method as the callout), orchestrated by
FridaObject>>asyncBegin:finish:.
"
Class {
	#name : 'FridaGlue',
	#superclass : 'Object',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'operations' }
FridaGlue class >> errorCode: anErrorHandle [
	^ self ffiCall: #(int frida_pharo_error_code (void* anErrorHandle)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> errorMessage: anErrorHandle [
	^ self ffiCall: #(String frida_pharo_error_message (void* anErrorHandle)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> errorOf: anOperation [
	^ self ffiCall: #(void* frida_pharo_operation_get_error (void* anOperation)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> free: anOperation [
	^ self ffiCall: #(void frida_pharo_operation_free (void* anOperation)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> operationForIndex: anIndex self: aHandle begin: aBeginSymbol finish: aFinishSymbol cancellable: aCancellable [
	^ self ffiCall: #(void* frida_pharo_operation_new (int anIndex, void* aHandle, String aBeginSymbol, String aFinishSymbol, void* aCancellable)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> operation: anOperation setIntArg: anIndex value: aValue [
	^ self ffiCall: #(void frida_pharo_operation_set_int_arg (void* anOperation, int anIndex, longlong aValue)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> operation: anOperation setPointerArg: anIndex value: aHandle [
	^ self ffiCall: #(void frida_pharo_operation_set_pointer_arg (void* anOperation, int anIndex, void* aHandle)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> operation: anOperation setStringArg: anIndex value: aString [
	^ self ffiCall: #(void frida_pharo_operation_set_string_arg (void* anOperation, int anIndex, String aString)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> operation: anOperation setOwnedArg: anIndex value: aHandle freeKind: aFreeKind [
	^ self ffiCall: #(void frida_pharo_operation_set_owned_arg (void* anOperation, int anIndex, void* aHandle, int aFreeKind)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> resultOf: anOperation [
	^ self ffiCall: #(void* frida_pharo_operation_get_result (void* anOperation)) library: FridaGlueLibrary
]

{ #category : 'operations' }
FridaGlue class >> schedule: anOperation [
	^ self ffiCall: #(void frida_pharo_operation_schedule (void* anOperation)) library: FridaGlueLibrary
]

{ #category : 'errors' }
FridaGlue class >> errorFree: anErrorHandle [
	^ self ffiCall: #(void frida_pharo_error_free (void* anErrorHandle)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> gfree: aHandle [
	^ self ffiCall: #(void frida_pharo_gfree (void* aHandle)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> instanceTypeName: aHandle [
	^ self ffiCall: #(String frida_pharo_instance_type_name (void* aHandle)) library: FridaGlueLibrary
]

{ #category : 'diagnostics' }
FridaGlue class >> symbolAvailableRaw: aName [
	^ self ffiCall: #(int frida_pharo_symbol_available (String aName)) library: FridaGlueLibrary
]

{ #category : 'diagnostics' }
FridaGlue class >> symbolAvailable: aName [
	^ (self symbolAvailableRaw: aName) ~= 0
]

{ #category : 'variant decode' }
FridaGlue class >> variantTypeString: aVariant [
	^ self ffiCall: #(String frida_pharo_variant_type_string (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantChildCount: aVariant [
	^ self ffiCall: #(int frida_pharo_variant_n_children (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variant: aVariant child: anIndex [
	^ self ffiCall: #(void* frida_pharo_variant_child (void* aVariant, int anIndex)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantUnbox: aVariant [
	^ self ffiCall: #(void* frida_pharo_variant_unbox (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantUnref: aVariant [
	^ self ffiCall: #(void frida_pharo_variant_unref (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantString: aVariant [
	^ self ffiCall: #(String frida_pharo_variant_get_string (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantBoolean: aVariant [
	^ self ffiCall: #(int frida_pharo_variant_get_boolean (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantDouble: aVariant [
	^ self ffiCall: #(double frida_pharo_variant_get_double (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantInt: aVariant [
	^ self ffiCall: #(longlong frida_pharo_variant_get_int (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variantSize: aVariant [
	^ self ffiCall: #(ulonglong frida_pharo_variant_get_size (void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'variant decode' }
FridaGlue class >> variant: aVariant copyDataTo: aByteArray [
	^ self ffiCall: #(void frida_pharo_variant_copy_data (void* aVariant, void* aByteArray)) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewString: aString [
	^ self ffiCall: #(void* frida_pharo_variant_new_string (String aString)) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewInt64: aValue [
	^ self ffiCall: #(void* frida_pharo_variant_new_int64 (longlong aValue)) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewBoolean: aValue [
	^ self ffiCall: #(void* frida_pharo_variant_new_boolean (int aValue)) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewDouble: aValue [
	^ self ffiCall: #(void* frida_pharo_variant_new_double (double aValue)) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantNewBytes: aByteArray size: aSize [
	^ self ffiCall: #(void* frida_pharo_variant_new_bytes (void* aByteArray, ulonglong aSize)) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderNewDict [
	^ self ffiCall: #(void* frida_pharo_variant_builder_new_dict ()) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilder: aBuilder addKey: aKey value: aValue [
	^ self ffiCall: #(void frida_pharo_variant_builder_add_entry (void* aBuilder, String aKey, void* aValue)) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderNewArray [
	^ self ffiCall: #(void* frida_pharo_variant_builder_new_array ()) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilder: aBuilder addValue: aValue [
	^ self ffiCall: #(void frida_pharo_variant_builder_add_value (void* aBuilder, void* aValue)) library: FridaGlueLibrary
]

{ #category : 'variant encode' }
FridaGlue class >> variantBuilderEnd: aBuilder [
	^ self ffiCall: #(void* frida_pharo_variant_builder_end (void* aBuilder)) library: FridaGlueLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardictNew [
	^ self ffiCall: #(void* frida_pharo_vardict_new ()) library: FridaGlueLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardict: aTable insertKey: aKey value: aVariant [
	^ self ffiCall: #(void frida_pharo_vardict_insert (void* aTable, String aKey, void* aVariant)) library: FridaGlueLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardictUnref: aTable [
	^ self ffiCall: #(void frida_pharo_vardict_unref (void* aTable)) library: FridaGlueLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardictDupKeys: aTable [
	^ self ffiCall: #(void* frida_pharo_vardict_dup_keys (void* aTable)) library: FridaGlueLibrary
]

{ #category : 'vardict' }
FridaGlue class >> vardict: aTable lookup: aKey [
	^ self ffiCall: #(void* frida_pharo_vardict_lookup (void* aTable, String aKey)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> bytes: aBytesHandle copyTo: aByteArray [
	^ self ffiCall: #(void frida_pharo_bytes_copy_to (void* aBytesHandle, void* aByteArray)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> bytesNew: aByteArray size: aSize [
	^ self ffiCall: #(void* frida_pharo_bytes_new (void* aByteArray, ulonglong aSize)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> bytesSize: aBytesHandle [
	^ self ffiCall: #(ulonglong frida_pharo_bytes_size (void* aBytesHandle)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> bytesUnref: aBytesHandle [
	^ self ffiCall: #(void frida_pharo_bytes_unref (void* aBytesHandle)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strvFree: aStrvHandle [
	^ self ffiCall: #(void frida_pharo_strv_free (void* aStrvHandle)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strv: aStrvHandle get: anIndex [
	^ self ffiCall: #(String frida_pharo_strv_get (void* aStrvHandle, int anIndex)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strvLength: aStrvHandle [
	^ self ffiCall: #(int frida_pharo_strv_length (void* aStrvHandle)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strvNew: aLength [
	^ self ffiCall: #(void* frida_pharo_strv_new (int aLength)) library: FridaGlueLibrary
]

{ #category : 'marshalling' }
FridaGlue class >> strv: aStrvHandle set: anIndex value: aString [
	^ self ffiCall: #(void frida_pharo_strv_set (void* aStrvHandle, int anIndex, String aString)) library: FridaGlueLibrary
]

{ #category : 'signals' }
FridaGlue class >> connectMessage: aScriptHandle index: aSemaphoreIndex [
	^ self ffiCall: #(void* frida_pharo_script_connect_message (void* aScriptHandle, int aSemaphoreIndex)) library: FridaGlueLibrary
]

{ #category : 'signals' }
FridaGlue class >> subscriptionDisconnect: aSubscription [
	^ self ffiCall: #(void frida_pharo_subscription_disconnect (void* aSubscription)) library: FridaGlueLibrary
]

{ #category : 'signals' }
FridaGlue class >> subscriptionPoll: aSubscription [
	^ self ffiCall: #(String frida_pharo_subscription_poll (void* aSubscription)) library: FridaGlueLibrary
]

{ #category : 'generic signals' }
FridaGlue class >> signalConnect: aSourceHandle name: aSignalName index: aSemaphoreIndex [
	^ self ffiCall: #(void* frida_pharo_signal_connect (void* aSourceHandle, String aSignalName, int aSemaphoreIndex)) library: FridaGlueLibrary
]

{ #category : 'generic signals' }
FridaGlue class >> signalPoll: aSubscription [
	^ self ffiCall: #(void* frida_pharo_signal_poll (void* aSubscription)) library: FridaGlueLibrary
]

{ #category : 'generic signals' }
FridaGlue class >> eventArgCount: anEvent [
	^ self ffiCall: #(int frida_pharo_signal_event_arg_count (void* anEvent)) library: FridaGlueLibrary
]

{ #category : 'generic signals' }
FridaGlue class >> event: anEvent argTag: anIndex [
	^ self ffiCall: #(int frida_pharo_signal_event_arg_tag (void* anEvent, int anIndex)) library: FridaGlueLibrary
]

{ #category : 'generic signals' }
FridaGlue class >> event: anEvent argInt: anIndex [
	^ self ffiCall: #(longlong frida_pharo_signal_event_arg_int (void* anEvent, int anIndex)) library: FridaGlueLibrary
]

{ #category : 'generic signals' }
FridaGlue class >> event: anEvent argString: anIndex [
	^ self ffiCall: #(String frida_pharo_signal_event_arg_string (void* anEvent, int anIndex)) library: FridaGlueLibrary
]

{ #category : 'generic signals' }
FridaGlue class >> event: anEvent argObject: anIndex [
	^ self ffiCall: #(void* frida_pharo_signal_event_arg_object (void* anEvent, int anIndex)) library: FridaGlueLibrary
]

{ #category : 'generic signals' }
FridaGlue class >> eventFree: anEvent [
	^ self ffiCall: #(void frida_pharo_signal_event_free_public (void* anEvent)) library: FridaGlueLibrary
]
