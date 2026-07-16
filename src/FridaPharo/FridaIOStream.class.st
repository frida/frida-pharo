"
Hand-written wrapper for the GIOStream returned by FridaDevice>>openChannel:.

A thin FridaObject subclass: it owns the stream handle (refcounted like any
GObject) so the channel stays open for the wrapper's lifetime and is closed when
the wrapper is finalized.

Byte I/O (read:/write:/close) routes through the same schedule-on-frida-thread ->
semaphore -> marshal-on-pharo-thread path as every other async op (see
FridaObject>>asyncBegin:finish:args:). read:/write: target the stream's borrowed
GInputStream / GOutputStream and use a Pharo-owned scratch buffer that outlives
the cross-thread hop and is freed once the operation completes; close: acts on
the GIOStream itself.
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
	input := FridaObject fromBorrowedHandle: self primInputStream.
	buffer := ExternalAddress allocate: aCount.
	[ nread := (input
		asyncBegin: 'g_input_stream_read_async'
		finish: 'g_input_stream_read_finish'
		args: { { #pointer. buffer } . { #int. aCount } . { #int. 0 } }) asInteger.
	  result := ByteArray new: nread.
	  1 to: nread do: [ :i | result at: i put: (buffer unsignedByteAt: i) ] ]
		ensure: [ buffer free ].
	^ result
]

{ #category : 'io' }
FridaIOStream >> write: aByteArray [
	"Write aByteArray; answer the number of bytes actually written."
	| output size buffer nwritten |
	size := aByteArray size.
	output := FridaObject fromBorrowedHandle: self primOutputStream.
	buffer := ExternalAddress allocate: size.
	1 to: size do: [ :i | buffer unsignedByteAt: i put: (aByteArray at: i) ].
	[ nwritten := (output
		asyncBegin: 'g_output_stream_write_async'
		finish: 'g_output_stream_write_finish'
		args: { { #pointer. buffer } . { #int. size } . { #int. 0 } }) asInteger ]
		ensure: [ buffer free ].
	^ nwritten
]

{ #category : 'io' }
FridaIOStream >> close [
	self
		asyncBegin: 'g_io_stream_close_async'
		finish: 'g_io_stream_close_finish'
		args: { { #int. 0 } }.
	^ self
]
