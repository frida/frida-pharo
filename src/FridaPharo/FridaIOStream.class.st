"
Hand-written wrapper for the GIOStream returned by FridaDevice>>openChannel:.

A thin FridaObject subclass: it owns the stream handle (refcounted like any
GObject) so the channel stays open for the wrapper's lifetime and is closed when
the wrapper is finalized.

Byte I/O (read:/write:/close) drives the GIO async calls through the same
FridaObject>>asyncCall:finish: loop as every generated async method, calling the
GInputStream / GOutputStream / GIOStream entry points directly. read:/write: use
a Pharo-owned scratch buffer that outlives the operation and is freed once it
completes; close: acts on the GIOStream itself.
"
Class {
	#name : 'FridaIOStream',
	#superclass : 'FridaObject',
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'primitives' }
FridaIOStream >> primInputStream [
	^ self ffiCall: #(void* g_io_stream_get_input_stream (self)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaIOStream >> primOutputStream [
	^ self ffiCall: #(void* g_io_stream_get_output_stream (self)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaIOStream >> primIsClosed [
	^ self ffiCall: #(bool g_io_stream_is_closed (self)) library: FridaLibrary
]

{ #category : 'testing' }
FridaIOStream >> isClosed [
	^ self primIsClosed
]

{ #category : 'io' }
FridaIOStream >> read: aCount [
	"Read up to aCount bytes; answer a ByteArray of the bytes actually read (its
	 size is the count returned by g_input_stream_read_finish, 0 at end-of-stream)."
	| input buffer nread result |
	input := self primInputStream.
	buffer := ExternalAddress allocate: aCount.
	[ nread := self
		asyncCall: [ :callback | self primRead: input into: buffer count: aCount callback: callback ]
		finish: [ :asyncResult :errorHolder | self primReadFinish: input result: asyncResult error: errorHolder ].
	  result := ByteArray new: nread.
	  1 to: nread do: [ :i | result at: i put: (buffer unsignedByteAt: i) ] ]
		ensure: [ buffer free ].
	^ result
]

{ #category : 'primitives' }
FridaIOStream >> primRead: anInputStream into: aBuffer count: aCount callback: aCallback [
	^ self primRead: anInputStream into: aBuffer count: aCount priority: 0 cancellable: ExternalAddress null callback: aCallback userData: ExternalAddress null
]

{ #category : 'primitives' }
FridaIOStream >> primRead: anInputStream into: aBuffer count: aCount priority: aPriority cancellable: aCancellable callback: aCallback userData: aUserData [
	^ self ffiCall: #(void g_input_stream_read_async (void* anInputStream, void* aBuffer, ulonglong aCount, int aPriority, void* aCancellable, void* aCallback, void* aUserData)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaIOStream >> primReadFinish: anInputStream result: anAsyncResult error: anErrorHolder [
	^ self ffiCall: #(longlong g_input_stream_read_finish (void* anInputStream, void* anAsyncResult, void* anErrorHolder)) library: FridaLibrary
]

{ #category : 'io' }
FridaIOStream >> write: aByteArray [
	"Write aByteArray; answer the number of bytes actually written."
	| output size buffer nwritten |
	size := aByteArray size.
	output := self primOutputStream.
	buffer := ExternalAddress allocate: size.
	1 to: size do: [ :i | buffer unsignedByteAt: i put: (aByteArray at: i) ].
	[ nwritten := self
		asyncCall: [ :callback | self primWrite: output from: buffer count: size callback: callback ]
		finish: [ :asyncResult :errorHolder | self primWriteFinish: output result: asyncResult error: errorHolder ] ]
		ensure: [ buffer free ].
	^ nwritten
]

{ #category : 'primitives' }
FridaIOStream >> primWrite: anOutputStream from: aBuffer count: aCount callback: aCallback [
	^ self primWrite: anOutputStream from: aBuffer count: aCount priority: 0 cancellable: ExternalAddress null callback: aCallback userData: ExternalAddress null
]

{ #category : 'primitives' }
FridaIOStream >> primWrite: anOutputStream from: aBuffer count: aCount priority: aPriority cancellable: aCancellable callback: aCallback userData: aUserData [
	^ self ffiCall: #(void g_output_stream_write_async (void* anOutputStream, void* aBuffer, ulonglong aCount, int aPriority, void* aCancellable, void* aCallback, void* aUserData)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaIOStream >> primWriteFinish: anOutputStream result: anAsyncResult error: anErrorHolder [
	^ self ffiCall: #(longlong g_output_stream_write_finish (void* anOutputStream, void* anAsyncResult, void* anErrorHolder)) library: FridaLibrary
]

{ #category : 'io' }
FridaIOStream >> close [
	self
		asyncCall: [ :callback | self primClose: callback ]
		finish: [ :asyncResult :errorHolder | self primCloseFinish: asyncResult error: errorHolder ].
	^ self
]

{ #category : 'primitives' }
FridaIOStream >> primClose: aCallback [
	^ self primClosePriority: 0 cancellable: ExternalAddress null callback: aCallback userData: ExternalAddress null
]

{ #category : 'primitives' }
FridaIOStream >> primClosePriority: aPriority cancellable: aCancellable callback: aCallback userData: aUserData [
	^ self ffiCall: #(void g_io_stream_close_async (self, int aPriority, void* aCancellable, void* aCallback, void* aUserData)) library: FridaLibrary
]

{ #category : 'primitives' }
FridaIOStream >> primCloseFinish: anAsyncResult error: anErrorHolder [
	^ self ffiCall: #(bool g_io_stream_close_finish (self, void* anAsyncResult, void* anErrorHolder)) library: FridaLibrary
]
