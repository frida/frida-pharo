"
Exercises the strv (gchar** -> Array of String) return marshalling path.
"
Class {
	#name : 'FridaMarshallingTest',
	#superclass : 'TestCase',
	#category : 'FridaPharo-Tests',
	#package : 'FridaPharo-Tests'
}

{ #category : 'tests' }
FridaMarshallingTest >> testStrvReturnMarshalsToArray [
	| options argv |
	options := FridaSpawnOptions new.
	argv := options argv.
	"Unset argv comes back as an empty Array; the point is the gchar** decode
	 path runs and yields an Array of Strings without leaking/crashing."
	self assert: argv isArray.
	self assert: (argv allSatisfy: [ :each | each isString ])
]
