"
Script RPC facade, mirroring the other bindings' script.exports.

Built on the working message signal + script post: an rpc call posts
['frida:rpc', id, 'call', name, args] as JSON and the message handler demuxes
the matching ['frida:rpc', id, 'ok'|'error', ...] reply.

API choice (noted for review): an explicit, unambiguous message-based call --
`exports call: 'add' withArguments: #(3 4)` -- rather than a doesNotUnderstand:
proxy, since JS function names and argument shapes don't map cleanly onto
Smalltalk keyword selectors. A DNU sugar layer could be added later.
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
	| id request |
	id := mutex critical: [ nextId := nextId + 1 ].
	request := FridaRpcRequest new.
	mutex critical: [ pending at: id put: request ].
	script
		post: (STONJSON toString: { 'frida:rpc'. id. 'call'. aFunctionName. anArgumentArray })
		data: nil.
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
FridaRpcExports >> handleMessage: aJsonString [
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
		ifTrue: [ request resolve: (payload at: 4 ifAbsent: [ nil ]) ]
		ifFalse: [ request reject: (payload at: 4 ifAbsent: [ 'error' ]) ]
]

{ #category : 'private' }
FridaRpcExports >> startOn: aScript [
	script := aScript.
	pending := Dictionary new.
	nextId := 0.
	mutex := Mutex new.
	subscription := aScript onMessage: [ :json :data | self handleMessage: json ].
	^ self
]
