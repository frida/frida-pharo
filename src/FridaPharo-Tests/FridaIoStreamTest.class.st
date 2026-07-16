"
FridaIOStream byte I/O (read:/write:/close) is wired through the standard async
path onto the GIO stream entry points. A live round-trip needs a channel to a
remote peer (FridaDevice>>openChannel: only yields a stream against a device that
serves channels -- the local device does not), so this suite verifies what is
reachable on a stock macOS/Linux box: that the GIO symbols the wiring dlsym()s
survived the static link, and that the I/O protocol is present and typed.

A live read/write/close round-trip is deliberately NOT faked here; it is an
integration test to add once a channel-serving endpoint (e.g. a frida-portal or
a remote frida-server) is available in the harness.
"
Class {
	#name : 'FridaIoStreamTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaIoStreamTest >> testGioStreamSymbolsPresent [
	"Guards against dead-stripping: every begin/finish symbol the byte-I/O wiring
	 resolves at runtime must be present in the linked library."
	#( 'g_io_stream_get_input_stream'
	   'g_io_stream_get_output_stream'
	   'g_io_stream_close_async'
	   'g_io_stream_close_finish'
	   'g_input_stream_read_async'
	   'g_input_stream_read_finish'
	   'g_output_stream_write_async'
	   'g_output_stream_write_finish' )
		do: [ :name |
			self assert: (FridaGlue symbolAvailable: name) description: name, ' is not linked in' ]
]

{ #category : 'tests' }
FridaIoStreamTest >> testIoStreamRespondsToIoProtocol [
	self assert: (FridaIOStream canUnderstand: #read:).
	self assert: (FridaIOStream canUnderstand: #write:).
	self assert: (FridaIOStream canUnderstand: #close).
	self assert: (FridaIOStream inheritsFrom: FridaObject)
]
