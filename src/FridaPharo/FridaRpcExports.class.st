"
Script RPC facade, mirroring the other bindings' script.exports.

Built on the working message signal + script post: an rpc call posts
['frida:rpc', id, 'call', name, args] as JSON and the message handler demuxes
the matching ['frida:rpc', id, 'ok'|'error', ...] reply.

Call an export by sending it as a message: the first keyword is the JS function
name, the arguments become the positional args, and a unary send is a no-arg
call -- `exports readMemory: address size: count` -> readMemory(address, count).
A trailing ByteArray argument is sent as the binary payload, and an ArrayBuffer
reply comes back as a ByteArray. For a JS name that is not a legal selector,
`exports call: aName withArguments: anArray` does the same thing explicitly.
"
Class {
	#name : 'FridaRpcExports',
	#superclass : 'Object',
	#instVars : [ 'script', 'subscription', 'pending', 'nextId', 'mutex' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'instance creation' }
FridaRpcExports class >> on: aScript [
	^ self new startOn: aScript
]

{ #category : 'calling' }
FridaRpcExports >> call: aFunctionName withArguments: anArgumentArray [
	| id request jsonArguments data |
	(anArgumentArray notEmpty and: [ anArgumentArray last isKindOf: ByteArray ])
		ifTrue: [ jsonArguments := anArgumentArray allButLast. data := anArgumentArray last ]
		ifFalse: [ jsonArguments := anArgumentArray. data := nil ].
	id := mutex critical: [ nextId := nextId + 1 ].
	request := FridaRpcRequest new.
	mutex critical: [ pending at: id put: request ].
	script
		post: (STONJSON toString: { 'frida:rpc'. id. 'call'. aFunctionName. jsonArguments })
		data: data.
	^ request waitResult
]

{ #category : 'controlling' }
FridaRpcExports >> close [
	subscription ifNotNil: [ :s | s off. subscription := nil ]
]

{ #category : 'calling' }
FridaRpcExports >> doesNotUnderstand: aMessage [
	"Sugar: `exports add: 3 and: 4` -> call 'add' withArguments: #(3 4). The JS
	 function name is the selector's first keyword (JS args are positional, so
	 later keyword names are ignored); unary sends call a no-arg function."
	| functionName |
	functionName := aMessage selector asString copyUpTo: $:.
	^ self call: functionName withArguments: aMessage arguments
]

{ #category : 'private' }
FridaRpcExports >> handleMessage: aJsonString data: aByteArrayOrNil [
	| message payload id status request |
	message := STONJSON fromString: aJsonString.
	(message at: 'type' ifAbsent: [ nil ]) = 'send' ifFalse: [ ^ self ].
	payload := message at: 'payload' ifAbsent: [ nil ].
	(payload isArray and: [ payload size >= 3 and: [ (payload at: 1) = 'frida:rpc' ] ])
		ifFalse: [ ^ self ].
	id := payload at: 2.
	status := payload at: 3.
	request := mutex critical: [ pending removeKey: id ifAbsent: [ nil ] ].
	request ifNil: [ ^ self ].
	status = 'ok'
		ifTrue: [ request resolve: (self resultFrom: payload data: aByteArrayOrNil) ]
		ifFalse: [ request reject: (payload at: 4 ifAbsent: [ 'error' ]) ]
]

{ #category : 'private' }
FridaRpcExports >> resultFrom: payload data: aByteArrayOrNil [
	"A binary reply carries its bytes out of band: bare ByteArray when the export
	 returned an ArrayBuffer, or { value. bytes } when it returned a pair."
	aByteArrayOrNil ifNil: [ ^ payload at: 4 ifAbsent: [ nil ] ].
	^ payload size >= 5
		ifTrue: [ { payload at: 5. aByteArrayOrNil } ]
		ifFalse: [ aByteArrayOrNil ]
]

{ #category : 'private' }
FridaRpcExports >> startOn: aScript [
	script := aScript.
	pending := Dictionary new.
	nextId := 0.
	mutex := Mutex new.
	subscription := aScript onMessage: [ :json :data | self handleMessage: json data: data ].
	^ self
]
