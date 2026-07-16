"
GENERATED binding for the Frida FridaXnuMachTrap enumeration.
"
Class {
	#name : 'FridaXnuMachTrap',
	#superclass : 'FFIExternalEnumeration',
	#classVars : [ 'FridaXnuMachTrapMachVmAllocate', 'FridaXnuMachTrapMachVmPurgableControl', 'FridaXnuMachTrapMachVmDeallocate', 'FridaXnuMachTrapTaskDyldProcessInfoNotifyGet', 'FridaXnuMachTrapMachVmProtect', 'FridaXnuMachTrapMachVmMap', 'FridaXnuMachTrapMachPortAllocate', 'FridaXnuMachTrapMachPortDeallocate', 'FridaXnuMachTrapMachPortModRefs', 'FridaXnuMachTrapMachPortMoveMember', 'FridaXnuMachTrapMachPortInsertRight', 'FridaXnuMachTrapMachPortInsertMember', 'FridaXnuMachTrapMachPortExtractMember', 'FridaXnuMachTrapMachPortConstruct', 'FridaXnuMachTrapMachPortDestruct', 'FridaXnuMachTrapMachReplyPort', 'FridaXnuMachTrapThreadSelf', 'FridaXnuMachTrapTaskSelf', 'FridaXnuMachTrapHostSelf', 'FridaXnuMachTrapMachMsg', 'FridaXnuMachTrapMachMsgOverwrite', 'FridaXnuMachTrapSemaphoreSignal', 'FridaXnuMachTrapSemaphoreSignalAll', 'FridaXnuMachTrapSemaphoreSignalThread', 'FridaXnuMachTrapSemaphoreWait', 'FridaXnuMachTrapSemaphoreWaitSignal', 'FridaXnuMachTrapSemaphoreTimedwait', 'FridaXnuMachTrapSemaphoreTimedwaitSignal', 'FridaXnuMachTrapMachPortGetAttributes', 'FridaXnuMachTrapMachPortGuard', 'FridaXnuMachTrapMachPortUnguard', 'FridaXnuMachTrapMachGenerateActivityId', 'FridaXnuMachTrapTaskNameForPid', 'FridaXnuMachTrapTaskForPid', 'FridaXnuMachTrapPidForTask', 'FridaXnuMachTrapMachMsg2', 'FridaXnuMachTrapMacxSwapon', 'FridaXnuMachTrapMacxSwapoff', 'FridaXnuMachTrapThreadGetSpecialReplyPort', 'FridaXnuMachTrapMacxTriggers', 'FridaXnuMachTrapMacxBackingStoreSuspend', 'FridaXnuMachTrapMacxBackingStoreRecovery', 'FridaXnuMachTrapPfzExit', 'FridaXnuMachTrapSwtchPri', 'FridaXnuMachTrapSwtch', 'FridaXnuMachTrapThreadSwitch', 'FridaXnuMachTrapClockSleep', 'FridaXnuMachTrapMachVmReclaimUpdateKernelAccounting', 'FridaXnuMachTrapHostCreateMachVoucher', 'FridaXnuMachTrapMachVoucherExtractAttrRecipe', 'FridaXnuMachTrapMachPortType', 'FridaXnuMachTrapMachPortRequestNotification', 'FridaXnuMachTrapExclavesCtl', 'FridaXnuMachTrapMachTimebaseInfo', 'FridaXnuMachTrapMachWaitUntil', 'FridaXnuMachTrapMkTimerCreate', 'FridaXnuMachTrapMkTimerDestroy', 'FridaXnuMachTrapMkTimerArm', 'FridaXnuMachTrapMkTimerCancel', 'FridaXnuMachTrapMkTimerArmLeeway', 'FridaXnuMachTrapDebugControlPortForPid', 'FridaXnuMachTrapIokitUserClient' ],
	#category : 'FridaPharo',
	#package : 'FridaPharo'
}

{ #category : 'generated' }
FridaXnuMachTrap class >> enumDecl [
	^ #(
			FridaXnuMachTrapMachVmAllocate -10
			FridaXnuMachTrapMachVmPurgableControl -11
			FridaXnuMachTrapMachVmDeallocate -12
			FridaXnuMachTrapTaskDyldProcessInfoNotifyGet -13
			FridaXnuMachTrapMachVmProtect -14
			FridaXnuMachTrapMachVmMap -15
			FridaXnuMachTrapMachPortAllocate -16
			FridaXnuMachTrapMachPortDeallocate -18
			FridaXnuMachTrapMachPortModRefs -19
			FridaXnuMachTrapMachPortMoveMember -20
			FridaXnuMachTrapMachPortInsertRight -21
			FridaXnuMachTrapMachPortInsertMember -22
			FridaXnuMachTrapMachPortExtractMember -23
			FridaXnuMachTrapMachPortConstruct -24
			FridaXnuMachTrapMachPortDestruct -25
			FridaXnuMachTrapMachReplyPort -26
			FridaXnuMachTrapThreadSelf -27
			FridaXnuMachTrapTaskSelf -28
			FridaXnuMachTrapHostSelf -29
			FridaXnuMachTrapMachMsg -31
			FridaXnuMachTrapMachMsgOverwrite -32
			FridaXnuMachTrapSemaphoreSignal -33
			FridaXnuMachTrapSemaphoreSignalAll -34
			FridaXnuMachTrapSemaphoreSignalThread -35
			FridaXnuMachTrapSemaphoreWait -36
			FridaXnuMachTrapSemaphoreWaitSignal -37
			FridaXnuMachTrapSemaphoreTimedwait -38
			FridaXnuMachTrapSemaphoreTimedwaitSignal -39
			FridaXnuMachTrapMachPortGetAttributes -40
			FridaXnuMachTrapMachPortGuard -41
			FridaXnuMachTrapMachPortUnguard -42
			FridaXnuMachTrapMachGenerateActivityId -43
			FridaXnuMachTrapTaskNameForPid -44
			FridaXnuMachTrapTaskForPid -45
			FridaXnuMachTrapPidForTask -46
			FridaXnuMachTrapMachMsg2 -47
			FridaXnuMachTrapMacxSwapon -48
			FridaXnuMachTrapMacxSwapoff -49
			FridaXnuMachTrapThreadGetSpecialReplyPort -50
			FridaXnuMachTrapMacxTriggers -51
			FridaXnuMachTrapMacxBackingStoreSuspend -52
			FridaXnuMachTrapMacxBackingStoreRecovery -53
			FridaXnuMachTrapPfzExit -58
			FridaXnuMachTrapSwtchPri -59
			FridaXnuMachTrapSwtch -60
			FridaXnuMachTrapThreadSwitch -61
			FridaXnuMachTrapClockSleep -62
			FridaXnuMachTrapMachVmReclaimUpdateKernelAccounting -63
			FridaXnuMachTrapHostCreateMachVoucher -70
			FridaXnuMachTrapMachVoucherExtractAttrRecipe -72
			FridaXnuMachTrapMachPortType -76
			FridaXnuMachTrapMachPortRequestNotification -77
			FridaXnuMachTrapExclavesCtl -88
			FridaXnuMachTrapMachTimebaseInfo -89
			FridaXnuMachTrapMachWaitUntil -90
			FridaXnuMachTrapMkTimerCreate -91
			FridaXnuMachTrapMkTimerDestroy -92
			FridaXnuMachTrapMkTimerArm -93
			FridaXnuMachTrapMkTimerCancel -94
			FridaXnuMachTrapMkTimerArmLeeway -95
			FridaXnuMachTrapDebugControlPortForPid -96
			FridaXnuMachTrapIokitUserClient -100
		)
]

{ #category : 'generated' }
FridaXnuMachTrap class >> initialize [
	self initializeEnumeration.
	self rebuildEnumAccessors
]

