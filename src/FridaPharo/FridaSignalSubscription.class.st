"
A live subscription to a Frida GObject signal, returned by the generated onXxx:
connectors (and FridaObject>>connectSignal:callback:).

It holds the typed FFICallback so GLib keeps invoking it for as long as the
subscription is live; #off disconnects the handler and drops the callback, both
stopping delivery and letting the callback be collected.
"
Class {
	#name : 'FridaSignalSubscription',
	#superclass : 'Object',
	#instVars : [ 'source', 'handlerId', 'callback' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'instance creation' }
FridaSignalSubscription class >> source: aSource handlerId: aHandlerId callback: aCallback [
	^ self new setSource: aSource handlerId: aHandlerId callback: aCallback
]

{ #category : 'controlling' }
FridaSignalSubscription >> off [
	handlerId ifNil: [ ^ self ].
	source primDisconnect: handlerId.
	handlerId := nil.
	callback := nil
]

{ #category : 'initialization' }
FridaSignalSubscription >> setSource: aSource handlerId: aHandlerId callback: aCallback [
	source := aSource.
	handlerId := aHandlerId.
	callback := aCallback
]
