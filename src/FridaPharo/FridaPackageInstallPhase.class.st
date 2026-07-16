"
GENERATED binding for the Frida FridaPackageInstallPhase enumeration.
"
Class {
	#name : 'FridaPackageInstallPhase',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaPackageInstallPhaseInitializing', 'FridaPackageInstallPhasePreparingDependencies', 'FridaPackageInstallPhaseResolvingPackage', 'FridaPackageInstallPhaseFetchingResource', 'FridaPackageInstallPhasePackageAlreadyInstalled', 'FridaPackageInstallPhaseDownloadingPackage', 'FridaPackageInstallPhasePackageInstalled', 'FridaPackageInstallPhaseResolvingAndInstallingAll', 'FridaPackageInstallPhaseComplete' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaPackageInstallPhase class >> enumDecl [
	^ #(
			FridaPackageInstallPhaseInitializing 0
			FridaPackageInstallPhasePreparingDependencies 1
			FridaPackageInstallPhaseResolvingPackage 2
			FridaPackageInstallPhaseFetchingResource 3
			FridaPackageInstallPhasePackageAlreadyInstalled 4
			FridaPackageInstallPhaseDownloadingPackage 5
			FridaPackageInstallPhasePackageInstalled 6
			FridaPackageInstallPhaseResolvingAndInstallingAll 7
			FridaPackageInstallPhaseComplete 8
		)
]

{ #category : 'generated' }
FridaPackageInstallPhase class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

