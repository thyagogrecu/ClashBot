; #FUNCTION# ===========================================================================================================
; Name ..........: Attack Cycle
; Author ........: Phael
; Description ...: Executes initial and routine attack cycles with their village tasks.
; Remarks .......: Normal mode respects the configured attack count. Rush mode continues until an explicit stop condition.
; ======================================================================================================================
Func AttackCycle($bIsInitial = False)
	If Not $g_bRunState Then Return

	; === CYCLE INITIALIZATION ===
	Local $iPerformed = 0
	Local $iAttackCount = ProfileSwitchAccountEnabled() ? ($g_iCmbMaxInARow + 1) : $INITIAL_ATTACK_COUNT
	If Not $g_bRushAttackRunning Then SetLog("» STARTING ATTACK CYCLE «", $COLOR_SUCCESS)

	; === MAIN ATTACK LOOP ===
	; Normal mode uses the configured limit; Rush runs until an exit condition is reached.
	Local $iAttempt = 0
	While ($g_bRushAttackRunning ? ($g_bRushAttackEnabled And $g_bRunState And Not $g_bRestart And Not $g_bBotPaused And Not __AttackCycleIsHaltMode()) : ($iPerformed < $iAttackCount Or $g_aiRankedBattleHaltState[$g_iCurAccount] = 1))
		If $g_bRushAttackRunning And __AttackCycleShouldStop() Then ExitLoop
		If Not $g_bRushAttackRunning And __AttackCycleShouldStop() Then ExitLoop

		; === SCRIPT ROTATION PREPARATION ===
		If ScriptRotationIsActive() And Not ScriptRotationIsRecipeApplied() Then
			TrainSystem()
			If Not $g_bRunState Then Return
			If Not ScriptRotationIsRecipeApplied() Then
				If Not $g_bRushAttackRunning Then Return
				If _Sleep(15000) Then Return
				ContinueLoop
			EndIf
		EndIf
		SetLog("Attack Sequence: " & ($iPerformed + 1) & ($g_bRushAttackRunning ? "" : "/" & $iAttackCount), $COLOR_ACTION)

		; === VILLAGE PREPARATION ===
		ClearScreen()
		If $g_bRushAttackRunning And __AttackCycleHasUpgradeEnabled() Then
			$g_iFreeBuilderCount = 0
			VillageReport(False, True, False)
			If Not $g_bRunState Then Return
		EndIf
		
		; === TROOP REQUEST HANDLING ===
		If Not $g_bRushAttackRunning And $g_bRequestTroopsEnable Then
			RequestCC()
			If Not $g_bRunState Then Return
			If _Sleep(500) Then Return
		EndIf

		If Not $g_bRushAttackRunning Then
			; === DONATION HANDLING ===
			If $g_bChkDonate Then
				DonateCC()
				If Not $g_bRunState Then Return
				If _Sleep(500) Then Return
			EndIf
		EndIf

		; === VILLAGE UPGRADES ===
		If Not RunVillageUpgrades() Then Return

		Local $bAllowEmptyCastle = False
		If Not $g_bRushAttackRunning Then
			; === CLAN CASTLE WAIT HANDLING ===
			If $g_bSearchCastleWaitEnable Then
				If $g_bCakeCCRequestSucceeded Then
					SetLog("Reinforcement ready, skipping troop wait")

				Else
					If Not IsFullClanCastle(False) Then
						SetLog("Waiting for troops before attacking")
						Local $hCCWaitTimer = __TimerInit()
						If Not $g_bRunState Then Return
						Local $iMaxWaitMs = 15 * 60 * 1000
						Local $iCCSwitchWaitMs = Random(60000, 180000, 1)
						Local $iLastWaitLogMinute = 0
						Local $bCCSwitchAttempted = False
						While __TimerDiff($hCCWaitTimer) < $iMaxWaitMs
							If Not $g_bRunState Then Return
						
							; Donate troops while waiting
							If $g_bChkDonate Then
								DonateCC()
								If _Sleep(500) Then Return
							EndIf
							If _Sleep(Random(0, 60000, 1)) Then Return
						
							; Check if CC is now full
							If IsFullClanCastle(False) Then
								SetLog("Clan Castle wait finished, ready to attack!", $COLOR_SUCCESS)
								If Not $g_bRunState Then Return
								ExitLoop
							EndIf
						
							; Continue waiting and donating
							If Not $g_bRunState Then Return
							Local $iElapsedWaitMinute = Floor(__TimerDiff($hCCWaitTimer) / 60000)
							If $iElapsedWaitMinute > $iLastWaitLogMinute Then
								$iLastWaitLogMinute = $iElapsedWaitMinute
								SetLog("Still waiting for troops (" & $iElapsedWaitMinute & " min elapsed)")
							EndIf
							If Not $bCCSwitchAttempted And __TimerDiff($hCCWaitTimer) >= $iCCSwitchWaitMs And $g_bSwitchAccWaitForCC And ProfileSwitchAccountEnabled() Then
								$bCCSwitchAttempted = True
								$g_bWaitForCCTroopSpell = True
								Local $bWasFirstStart = $g_bFirstStart
								$g_bFirstStart = False
								If CheckSwitchAcc() Then Return
								$g_bFirstStart = $bWasFirstStart
								$g_bWaitForCCTroopSpell = False
							EndIf
						WEnd
						If __TimerDiff($hCCWaitTimer) >= $iMaxWaitMs Then
							SetLog("Maximum wait time reached, attacking anyway", $COLOR_ACTION)
							$bAllowEmptyCastle = True
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		
		; === ATTACK EXECUTION ===
		AttackMain($bAllowEmptyCastle)
		$g_bCakeCCRequestSucceeded = False
		
		; === SEQUENCE MANAGEMENT ===
		; Track performed attacks
		Local $bAttackWasPerformed = $g_bAttackPerformed
		If $bAttackWasPerformed Then
			$iPerformed += 1
			If Not $g_bRushAttackRunning And Not __RunClanGamesIfDue(True) Then Return
		EndIf
		$g_bAttackPerformed = False ; Reset for next attack
		If ScriptRotationIsActive() And $g_bScriptRotationPhaseChanged Then
			TrainSystem()
			If Not $g_bRunState Then Return
			If Not ScriptRotationIsRecipeApplied() Then Return
			$g_bScriptRotationPhaseChanged = False
		EndIf
		If Not $bAttackWasPerformed And __AttackCycleIsHaltMode() Then ExitLoop
		; Return control to runBot when the normal search is not ready, so TrainSystem can refresh the army state.
		If Not $bAttackWasPerformed And Not $g_bRushAttackRunning Then Return

		; Stop the cycle only after a real completed attack, without forcing screen checks inside the attack flow
		If $bAttackWasPerformed And ($g_bRushAttackRunning Or $iPerformed < $iAttackCount Or $g_aiRankedBattleHaltState[$g_iCurAccount] = 1) Then
			If __AttackCycleShouldStop(False) Then ExitLoop
		EndIf

		If $g_bRushAttackRunning Or $iPerformed < $iAttackCount Or $g_aiRankedBattleHaltState[$g_iCurAccount] = 1 Then
			If $g_bRushAttackRunning And (Not $g_bRushAttackEnabled Or $g_bRestart Or $g_bBotPaused) Then ExitLoop
			If Not $g_bRushAttackRunning And SmartPause() Then ExitLoop
			If Not $g_bRushAttackRunning And $g_bRestart Then $g_bRestart = False
			If Not $g_bRushAttackRunning And Not ($g_iAttackDelayMin = 0 And $g_iAttackDelayMax = 0) Then
				Local $iWaitTime = Random($g_iAttackDelayMin, $g_iAttackDelayMax, 1)
				SetLog("Waiting " & Round($iWaitTime / 1000) & " seconds before next attack", $COLOR_INFO)
				If _Sleep($iWaitTime) Then Return
			EndIf
			If Not $g_bRunState Then Return
		Else
			SetLog("» ATTACK CYCLE COMPLETED (" & $iPerformed & "/" & $iAttackCount & ") «", $COLOR_SUCCESS)
			ExitLoop
		EndIf

		; === OUT-OF-GOLD CHECK ===
		If $g_bOutOfGold Then
			SetLog("Switching To Halt Attack: Stay Online/Collect Mode", $COLOR_ACTION)
			$g_bFirstStart = True ; Reset First time flag to ensure army balancing when returns to training
			Return
		EndIf
		If _Sleep($DELAYRUNBOT1) Then Return
		$iAttempt += 1
	WEnd

	; === POST-CYCLE HANDLING ===
	If $g_bRushAttackRunning Then Return

	If __AttackCycleIsHaltMode() Then
		If $g_bChkEnableBBAttack And $g_bChkBBStarsAvailable Then
			BuilderBase()
			If Not $g_bRunState Then Return
		EndIf
		If ProfileSwitchAccountEnabled() Then
			If checkSwitchAcc() Then Return
			If Not $g_bRunState Then Return
		EndIf
		Return
	EndIf

	If ($g_aiAttackedCount - $g_aiAttackedCountSwitch[$g_iCurAccount] >= $g_iCmbMaxInARow) Or Not ProfileSwitchAccountEnabled() Then
		If ($g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_bChkEnableBBAttack) Then
			BuilderBase()
			If Not $g_bRunState Then Return
		EndIf
		If ProfileSwitchAccountEnabled() Then
			If checkSwitchAcc() Then Return
			If Not $g_bRunState Then Return
		EndIf
	EndIf
EndFunc   ;==>AttackCycle

Func RushAttackCycle()
	If Not $g_bRushAttackEnabled Or Not $g_bRunState Then Return
	$g_bRushAttackRunning = True
	$g_iCommandStop = -1

	SetLog("» RUSH ATTACK MODE ENABLED «", $COLOR_INFO)

	$g_aiRankedBattleHaltState[$g_iCurAccount] = 0
	While $g_bRushAttackEnabled And $g_bRunState
		AttackCycle(False)
		If Not $g_bRushAttackEnabled Or Not $g_bRunState Or $g_bBotPaused Then ExitLoop
		If $g_bRestart Then
			$g_bRestart = False
			ContinueLoop
		EndIf
		If $g_bOutOfGold Then
			DisableRushAttack("Out of gold")
			ExitLoop
		EndIf
		If __AttackCycleIsHaltMode() Then
			DisableRushAttack("Halt attack condition reached")
			ExitLoop
		EndIf
	WEnd
	$g_bRushAttackRunning = False
EndFunc   ;==>RushAttackCycle

Func __AttackCycleHasUpgradeEnabled()
	If $g_bUpgradeKingEnable Or $g_bUpgradeQueenEnable Or $g_bUpgradePrinceEnable Or $g_bUpgradeWardenEnable Or $g_bUpgradeChampionEnable Or $g_bUpgradeDukeEnable Then Return True
	If $g_bAutoUpgradeEnabled Or $g_bAutoLabUpgradeAutoEnabled Or $g_bAutoUpgradeBBEnabled Or $g_bAutoStarUpgradeBBEnabled Or $g_bAutoUpgradeWallsEnable Then Return True

	For $iUpgradeSlot = 0 To UBound($g_abBuildingUpgradeEnable) - 1
		If $g_abBuildingUpgradeEnable[$iUpgradeSlot] Then Return True
	Next
	Return False
EndFunc   ;==>__AttackCycleHasUpgradeEnabled

Func __AttackCycleShouldStop($bLogStorage = True)
	If Not $g_bRunState Then Return True

	If BotCommand($bLogStorage) Then Return True

	If __AttackCycleIsHaltMode() Then
		If Not $g_bRushAttackRunning And __AttackCycleShouldContinueForStarBonus() Then Return False
		SetLog("Attack Cycle Interrupted - Halt Attack Condition Reached", $COLOR_ACTION)
		Return True
	EndIf

	Return False
EndFunc   ;==>__AttackCycleShouldStop

Func __AttackCycleIsHaltMode()
	Return ($g_iCommandStop = 0 Or $g_iCommandStop = 3)
EndFunc   ;==>__AttackCycleIsHaltMode

Func __AttackCycleShouldContinueForStarBonus()
	If $g_aiRankedBattleHaltState[$g_iCurAccount] = 2 Then Return False
	If $g_iCommandStop <> 0 Then Return False
	If $g_iCmbBotCond > 3 Then Return False
	If Not $g_bCollectStarBonus Then Return False
	If Not StarBonusSearch() Then Return False

	SetLog("Star bonus available, continue attacking to collect it")
	Return True
EndFunc   ;==>__AttackCycleShouldContinueForStarBonus
