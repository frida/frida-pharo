"
A live subscription to a Frida GObject signal.

The C glue connects a handler on Frida's thread that enqueues each payload and
signals a delivery Semaphore. This object owns a dedicated Pharo listener
process that waits on that Semaphore, drains the queue, and evaluates the user
block on the Pharo thread -- so signal handlers run in normal single-threaded
Pharo, never on Frida's foreign thread.
"
Class {
	#name : 'FridaSignalSubscription',
	#superclass : 'Object',
	#instVars : [ 'glueHandle', 'semaphore', 'semaphoreIndex', 'process', 'block', 'kind' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'instance creation' }
FridaSignalSubscription class >> onObject: aFridaObject signal: aSignalName do: aBlock [
	"Subscribe to an arbitrary GObject signal; the block receives an Array of the
	 decoded signal arguments."
	^ self new startOn: aFridaObject signal: aSignalName do: aBlock
]

{ #category : 'instance creation' }
FridaSignalSubscription class >> onScriptMessage: aScript do: aBlock [
	^ self new startOnScriptMessage: aScript do: aBlock
]

{ #category : 'private' }
FridaSignalSubscription >> drain [
	kind == #message ifTrue: [ ^ self drainMessages ].
	^ self drainSignals
]

{ #category : 'private' }
FridaSignalSubscription >> drainMessages [
	"Poll until the queue is empty. uFFI maps a NULL String return to an empty
	 string, and Frida payloads are always non-empty JSON, so an empty result is
	 the drained sentinel."
	| message |
	[ message := FridaGlue subscriptionPoll: glueHandle.
	  message notNil and: [ message isNotEmpty ] ]
		whileTrue: [ block value: message ]
]

{ #category : 'private' }
FridaSignalSubscription >> drainSignals [
	| event |
	[ event := FridaGlue signalPoll: glueHandle.
	  event notNil and: [ event isNull not ] ]
		whileTrue: [ block value: (self decodeEvent: event) ]
]

{ #category : 'private' }
FridaSignalSubscription >> decodeEvent: anEvent [
	"Build an Array of Pharo values from a generic signal event, then free it.
	 Object args are wrapped as their runtime concrete class via #wrapOwned:."
	| count args |
	count := FridaGlue eventArgCount: anEvent.
	args := Array new: count.
	1 to: count do: [ :i | | tag |
		tag := FridaGlue event: anEvent argTag: i - 1.
		args at: i put: (tag caseOf: {
			[ 1 ] -> [ FridaGlue event: anEvent argInt: i - 1 ].
			[ 2 ] -> [ FridaGlue event: anEvent argString: i - 1 ].
			[ 3 ] -> [ FridaObject wrapOwned: (FridaGlue event: anEvent argObject: i - 1) ].
			[ 4 ] -> [ (FridaGlue event: anEvent argInt: i - 1) ~= 0 ] }
			otherwise: [ nil ]) ].
	FridaGlue eventFree: anEvent.
	^ args
]

{ #category : 'controlling' }
FridaSignalSubscription >> off [
	process ifNotNil: [ :p | p terminate. process := nil ].
	glueHandle ifNotNil: [ :h | FridaGlue subscriptionDisconnect: h. glueHandle := nil ].
	semaphore ifNotNil: [ Smalltalk unregisterExternalObject: semaphore. semaphore := nil ]
]

{ #category : 'private' }
FridaSignalSubscription >> runLoop [
	[ true ] whileTrue: [
		semaphore wait.
		self drain ]
]

{ #category : 'private' }
FridaSignalSubscription >> startOn: aFridaObject signal: aSignalName do: aBlock [
	kind := #generic.
	block := aBlock.
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	glueHandle := FridaGlue signalConnect: aFridaObject getHandle name: aSignalName index: semaphoreIndex.
	process := [ self runLoop ] forkAt: Processor userSchedulingPriority.
	^ self
]

{ #category : 'private' }
FridaSignalSubscription >> startOnScriptMessage: aScript do: aBlock [
	kind := #message.
	block := aBlock.
	semaphore := Semaphore new.
	semaphoreIndex := Smalltalk registerExternalObject: semaphore.
	glueHandle := FridaGlue connectMessage: aScript getHandle index: semaphoreIndex.
	process := [ self runLoop ] forkAt: Processor userSchedulingPriority.
	^ self
]
