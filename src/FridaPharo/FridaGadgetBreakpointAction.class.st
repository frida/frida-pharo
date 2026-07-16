"
GENERATED binding for the Frida FridaGadgetBreakpointAction enumeration.
"
Class {
	#name : 'FridaGadgetBreakpointAction',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaGadgetBreakpointActionInvokeReturn', 'FridaGadgetBreakpointActionResume', 'FridaGadgetBreakpointActionDetach', 'FridaGadgetBreakpointActionPagePlan' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaGadgetBreakpointAction class >> enumDecl [
	^ #(
			FridaGadgetBreakpointActionInvokeReturn 0
			FridaGadgetBreakpointActionResume 1
			FridaGadgetBreakpointActionDetach 2
			FridaGadgetBreakpointActionPagePlan 3
		)
]

{ #category : 'generated' }
FridaGadgetBreakpointAction class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

