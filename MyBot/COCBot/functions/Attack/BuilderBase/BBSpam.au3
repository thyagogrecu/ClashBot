; #FUNCTION# ===========================================================================================================
; Name ..........: Builder Base Spam
; Author ........: Phael
; Description ...: Runs Builder Base attacks while monitoring resource limits.
; Remarks .......: Stops when Builder Base storage limits are reached or the mode or run state is disabled.
; ======================================================================================================================
Func BBSpamCycle()
	; === VALIDATION ===
	If Not $g_bBBSpamEnabled Then Return

	If Not $g_bRunState Then
		DisableBBSpam("Bot is not running")
		Return
	EndIf

	; === INITIALIZATION ===
	$g_bBBSpamRunning = True
	SetLog("» BB SPAM MODE ENABLED «", $COLOR_INFO)

	; === BASE SWITCHING ===
	; try switching a few times instead of giving up immediately
	Local $iSwitchAttempts = 0, $iMaxAttempts = 3
	While $iSwitchAttempts < $iMaxAttempts
		If SwitchBetweenBases(True, True) And isOnBuilderBase() Then
			ExitLoop
		EndIf
		$iSwitchAttempts += 1
		SetLog("Base switch attempt " & $iSwitchAttempts & " failed, retrying...", $COLOR_WARNING)
		Sleep(1000)
	WEnd
	
	If $iSwitchAttempts >= $iMaxAttempts Then
		DisableBBSpam("Failed to switch to Builder Base")
		Return
	EndIf
	
	; === INITIAL RESOURCE UPDATE ===
	BuilderBaseReport()
	If Not $g_bRunState Then Return

	; === DONATION HANDLING ===
	If $g_bChkDonate Then
		DonateCC()
		If Not $g_bRunState Then Return
		If _Sleep(500) Then Return
	EndIf

	; === BUILDER BASE UPGRADES ===
	If Not RunBuilderBaseUpgrades() Then Return

	; Clock Tower Boost
	If $g_bChkStartClockTowerBoost Then
		ClockTowerBoost()
		If Not $g_bRunState Then Return
	EndIf

	; Clear Yard Obstacles
	If $g_bChkCleanBBYard Then
		CleanBBYard()
		If Not $g_bRunState Then Return
	EndIf

	; === MAIN SPAM LOOP ===
	While $g_bBBSpamEnabled And $g_bRunState
		; Increment cycle counter
		$g_iBBSpamCycles += 1

		; === PRE-ATTACK LOOT COLLECTION ===
		CollectBuilderBase(False, False, False)
		If _Sleep($DELAYRUNBOT3) Then ExitLoop

		; === RESOURCE MONITORING ===
		BuilderBaseReport(True, True)
		SetLog("BB Loot: Gold " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB]) & ", Elixir " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB]), $COLOR_INFO)
		If _Sleep($DELAYRUNBOT3) Then ExitLoop

		; === RESOURCE FULL CHECK ===
		Local $bGoldFull = ($g_iBBSpamGoldThreshold > 0 ? ($g_aiCurrentLootBB[$eLootGoldBB] >= $g_iBBSpamGoldThreshold) : CheckBBGoldStorageFull())
		Local $bElixirFull = ($g_iBBSpamElixirThreshold > 0 ? ($g_aiCurrentLootBB[$eLootElixirBB] >= $g_iBBSpamElixirThreshold) : CheckBBElixirStorageFull())

		If $bGoldFull And $bElixirFull Then
			Local $bIgnoreResources = $g_bChkBBIgnoreFullStorages
			If $bIgnoreResources Then
				SetLog("Resources maxed out, ignoring limit and continuing attacks")
			Else
				DisableBBSpam("Resources maxed out")
				ExitLoop
			EndIf
		EndIf

		; === ATTACK EXECUTION ===
		AttackBB()
		If Not $g_bRunState Then
			ExitLoop
		EndIf
		If checkObstacles() Then
			ExitLoop
		EndIf
		If $g_bRestart = True Then
			ExitLoop
		EndIf

		; === POST-ATTACK LOOT COLLECTION ===
		CollectBuilderBase(False, False, False)
		If _Sleep($DELAYRUNBOT3) Then ExitLoop

		; === POST-ATTACK RESOURCE UPDATE ===
		BuilderBaseReport(True, True)
		SetLog("BB Loot After Collect: Gold " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB]) & ", Elixir " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB]), $COLOR_INFO)
		If _Sleep($DELAYRUNBOT3) Then ExitLoop

		; === DONATION HANDLING ===
		If $g_bChkDonate Then
			DonateCC()
			If Not $g_bRunState Then ExitLoop
			If _Sleep(500) Then ExitLoop
		EndIf

		; === POST-ATTACK UPGRADES ===
		Local $bBOBUpgradesEnabled = $g_bDoubleCannonUpgrade Or $g_bArcherTowerUpgrade Or $g_bMultiMortarUpgrade Or $g_bAnyDefUpgrade Or $g_bBattleMachineUpgrade Or $g_bBattlecopterUpgrade
		If $bBOBUpgradesEnabled Or $g_bAutoUpgradeBBEnabled Or $g_bAutoStarUpgradeBBEnabled Or $g_bAutoStarLabUpgradeEnable Then
			If Not RunBuilderBaseUpgrades(True) Then ExitLoop
			BuilderBaseReport(True, False)
			If Not __RunBotStepReady() Then ExitLoop
		EndIf

		; === POST-ATTACK RESOURCE CHECK ===
		Local $bGoldFullAfter = ($g_iBBSpamGoldThreshold > 0 ? ($g_aiCurrentLootBB[$eLootGoldBB] >= $g_iBBSpamGoldThreshold) : CheckBBGoldStorageFull())
		Local $bElixirFullAfter = ($g_iBBSpamElixirThreshold > 0 ? ($g_aiCurrentLootBB[$eLootElixirBB] >= $g_iBBSpamElixirThreshold) : CheckBBElixirStorageFull())

		If $bGoldFullAfter And $bElixirFullAfter Then
			Local $bIgnoreResources = $g_bChkBBIgnoreFullStorages
			If $bIgnoreResources Then
				SetLog("Resources maxed out, ignoring limit and continuing attacks", $COLOR_INFO)
			Else
				DisableBBSpam("Resources maxed out")
				ExitLoop
			EndIf
		EndIf

		SetDebugLog("BBSpamCycle: Cycle #" & $g_iBBSpamCycles & " complete, starting next cycle", $COLOR_DEBUG)
	WEnd

	; === CLEANUP ===
	SwitchBetweenBases()
	checkMainScreen(False)
	$g_bBBSpamRunning = False
EndFunc   ;==>BBSpamCycle
