; #FUNCTION# ===========================================================================================================
; Name ..........: Script Rotation
; Author ........: Phael
; Description ...: Rotates CSV attack scripts and Saved Recipes across three recipe phases.
; Remarks .......: Each recipe runs for 2-5 completed attacks. State is isolated per account and disabled mode preserves normal flow.
; ======================================================================================================================

#include-once

; === ATTACK MODE OVERRIDES ===
Func ScriptRotationIsActive()
	Return $g_bScriptRotationEnable
EndFunc   ;==>ScriptRotationIsActive

Func GetEffectiveAttackAlgorithm($iMode)
	If ScriptRotationIsActive() And ($iMode = $DB Or $iMode = $LB) Then Return 1
	Return $g_aiAttackAlgorithm[$iMode]
EndFunc   ;==>GetEffectiveAttackAlgorithm

Func GetEffectiveAttackSiege($iMode)
	If ScriptRotationIsActive() And ($iMode = $DB Or $iMode = $LB) Then Return $g_aiScriptRotationDeploySiege[ScriptRotationGetPhase()]
	Return $g_aiAttackUseSiege[$iMode]
EndFunc   ;==>GetEffectiveAttackSiege

Func GetAttackCSVScriptName($iMode)
	If ScriptRotationIsActive() And ($iMode = $DB Or $iMode = $LB) Then
		Local $iPhase = ScriptRotationGetPhase()
		If $g_asScriptRotationScript[$iPhase] <> "" Then Return $g_asScriptRotationScript[$iPhase]
	EndIf
	Return $g_sAttackScrScriptName[$iMode]
EndFunc   ;==>GetAttackCSVScriptName

; === ACCOUNT AND PHASE STATE ===
Func ScriptRotationGetAccountIndex()
	If $g_iCurAccount >= 0 And $g_iCurAccount < $g_iSwitchAccMaxAccounts Then Return $g_iCurAccount
	Return 0
EndFunc   ;==>ScriptRotationGetAccountIndex

Func ScriptRotationGetPhase()
	Local $iAccount = ScriptRotationGetAccountIndex()
	If Not $g_abScriptRotationPhaseInitialized[$iAccount] Then
		$g_aiScriptRotationPhase[$iAccount] = ScriptRotationGetRandomPhase()
		$g_abScriptRotationPhaseInitialized[$iAccount] = True
	EndIf
	If $g_aiScriptRotationPhase[$iAccount] = $eScriptRotationTertiary And $g_asScriptRotationScript[$eScriptRotationTertiary] = "" Then
		$g_aiScriptRotationPhase[$iAccount] = ScriptRotationGetRandomPhase()
		$g_aiScriptRotationAttackCount[$iAccount] = 0
		$g_aiScriptRotationAttackTarget[$iAccount] = 0
	EndIf
	Return $g_aiScriptRotationPhase[$iAccount]
EndFunc   ;==>ScriptRotationGetPhase

; === PHASE SELECTION ===
Func ScriptRotationGetRandomPhase($iExcludePhase = -1)
	Local $aiAvailable[3] = [$eScriptRotationPrimary, $eScriptRotationSecondary, $eScriptRotationTertiary]
	Local $iAvailable = 2
	If $g_asScriptRotationScript[$eScriptRotationTertiary] <> "" Then $iAvailable = 3

	If $iExcludePhase >= 0 And $iAvailable > 1 Then
		Local $aiCandidates[2], $iCandidates = 0
		For $i = 0 To $iAvailable - 1
			If $aiAvailable[$i] <> $iExcludePhase Then
				$aiCandidates[$iCandidates] = $aiAvailable[$i]
				$iCandidates += 1
			EndIf
		Next
		Return $aiCandidates[Random(0, $iCandidates - 1, 1)]
	EndIf

	Return $aiAvailable[Random(0, $iAvailable - 1, 1)]
EndFunc   ;==>ScriptRotationGetRandomPhase

Func ScriptRotationGetNextPhase($iPhase)
	Return ScriptRotationGetRandomPhase($iPhase)
EndFunc   ;==>ScriptRotationGetNextPhase

Func ScriptRotationGetAttackTarget()
	Local $iAccount = ScriptRotationGetAccountIndex()
	If $g_aiScriptRotationAttackTarget[$iAccount] < $g_iScriptRotationMinAttacks Or $g_aiScriptRotationAttackTarget[$iAccount] > $g_iScriptRotationMaxAttacks Then _
		$g_aiScriptRotationAttackTarget[$iAccount] = Random($g_iScriptRotationMinAttacks, $g_iScriptRotationMaxAttacks, 1)
	Return $g_aiScriptRotationAttackTarget[$iAccount]
EndFunc   ;==>ScriptRotationGetAttackTarget

; === RECIPE STATE ===
Func ScriptRotationIsRecipeApplied()
	Local $iAccount = ScriptRotationGetAccountIndex()
	Return $g_abScriptRotationRecipeApplied[$iAccount] And $g_asScriptRotationRecipeProfile[$iAccount] = $g_sProfileCurrentName
EndFunc   ;==>ScriptRotationIsRecipeApplied

Func ScriptRotationInvalidateRecipe()
	Local $iAccount = ScriptRotationGetAccountIndex()
	$g_abScriptRotationRecipeApplied[$iAccount] = False
	$g_asScriptRotationRecipeProfile[$iAccount] = ""
EndFunc   ;==>ScriptRotationInvalidateRecipe

; === RECIPE APPLICATION ===
Func ScriptRotationUseSavedRecipe()
	If Not ScriptRotationIsActive() Then Return False
	ScriptRotationInvalidateRecipe()
	If Not OpenArmyOverview(False, "ScriptRotationUseSavedRecipe()") Then Return False
	Local $iPhase = ScriptRotationGetPhase()
	Local $iRecipe = $iPhase + 1
	Local $sScriptName = GetAttackCSVScriptName($DB)
	Local $iUseY = 231 + $g_iMidOffsetY + ($iPhase * 146)
	Local $sUseArea = GetDiamondFromRect2(680, $iUseY - 30, 825, $iUseY + 65)
	Local $aArmyTabActive[4] = [200, 145 + $g_iMidOffsetY, 0xBD8F66, 30]
	Local $bApplied = False

	For $iAttempt = 1 To 3
		Click(430, 161 + $g_iMidOffsetY, 1, 120)
		Local $aUseButton = 0
		For $iUseAttempt = 1 To 8
			$aUseButton = decodeSingleCoord(findImage("Use", $g_sImgImgLocButtons & "\Use*", $sUseArea, 1, True))
			If IsArray($aUseButton) And UBound($aUseButton) = 2 Then ExitLoop
			If _Sleep(250) Then Return False
		Next
		If Not IsArray($aUseButton) Then ContinueLoop
		If UBound($aUseButton) <> 2 Then ContinueLoop

		SetLog("Script Rotation: " & $sScriptName & " Applied" & ($iAttempt > 1 ? " (Retry " & $iAttempt & ")" : ""), $COLOR_ACTION)
		ClickP($aUseButton, 1, 120)
		If _Sleep(700) Then Return False

		; Confirmation is only displayed when Clan Castle troops would be replaced.
		For $iConfirm = 0 To 7
			If _CheckPixel($aArmyTabActive, True) Then ExitLoop
			Local $aiOkayButton = findButton("Okay", Default, 1, True)
			If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
				ClickP($aiOkayButton, 1, 120)
				ExitLoop
			EndIf
			If _Sleep(250) Then Return False
		Next

		If _WaitForCheckPixel($aArmyTabActive, True, Default, "Script Rotation: My Army", Default, True) Then
			$bApplied = True
			ExitLoop
		EndIf
	Next
	If Not $bApplied Then
		SetLog("Script Rotation: Failed To Apply Saved Recipe " & $iRecipe & " After 3 Attempts", $COLOR_ERROR)
		btnStop()
		Return False
	EndIf

	Local $iAccount = ScriptRotationGetAccountIndex()
	$g_abScriptRotationRecipeApplied[$iAccount] = True
	$g_asScriptRotationRecipeProfile[$iAccount] = $g_sProfileCurrentName
	Return True
EndFunc   ;==>ScriptRotationUseSavedRecipe

; === ATTACK COMPLETION ===
Func ScriptRotationRegisterCompletedAttack()
	$g_bScriptRotationPhaseChanged = False
	If Not ScriptRotationIsActive() Then Return False

	Local $iAccount = ScriptRotationGetAccountIndex()
	Local $iPhase = ScriptRotationGetPhase()
	Local $iAttackTarget = ScriptRotationGetAttackTarget()
	$g_aiScriptRotationAttackCount[$iAccount] += 1
	If $g_aiScriptRotationAttackCount[$iAccount] < $iAttackTarget Then
		Return False
	EndIf

	$g_aiScriptRotationPhase[$iAccount] = ScriptRotationGetNextPhase($iPhase)
	$g_aiScriptRotationAttackCount[$iAccount] = 0
	$g_aiScriptRotationAttackTarget[$iAccount] = Random($g_iScriptRotationMinAttacks, $g_iScriptRotationMaxAttacks, 1)
	ScriptRotationInvalidateRecipe()
	$g_bFullArmy = False
	$g_bFullArmySpells = False
	$g_bIsFullArmywithHeroesAndSpells = False
	$g_iActualTrainSkip = 0
	Local $sPhase = "Recipe 01"
	Switch $g_aiScriptRotationPhase[$iAccount]
		Case $eScriptRotationSecondary
			$sPhase = "Recipe 02"
		Case $eScriptRotationTertiary
			$sPhase = "Recipe 03"
	EndSwitch
	SetLog("Script Rotation: " & $sPhase & " Selected", $COLOR_ACTION)
	$g_bScriptRotationPhaseChanged = True
	Return True
EndFunc   ;==>ScriptRotationRegisterCompletedAttack


; #FUNCTION# ===========================================================================================================
; Name ..........: TestScriptRotation
; Description ...: Opens Saved Recipes, randomly selects a detected Use button and confirms the selected recipe.
; Remarks .......: Requires Army Overview already open. Applies a real recipe without advancing rotation phases or attack counters.
; ======================================================================================================================
Func TestScriptRotation()
	SetLog(_PadStringCenter(" Test ScriptRotation Begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)
	If Not $g_bRunState Then Return False
	SetLog("Script Rotation Test: Opening Saved Recipes", $COLOR_INFO)
	Click(430, 192 + $g_iGAME_HEIGHT - 732, 1, 120, "Test ScriptRotation: Saved Recipes")
	If _Sleep(500) Then Return False

	Local $aCandidates[3][3], $iCount = 0
	For $iAttempt = 1 To 8
		$iCount = 0
		For $iRecipe = 0 To 2
			If Not $g_bRunState Then Return False
			Local $iUseY = 231 + $g_iMidOffsetY + ($iRecipe * 146)
			Local $sUseArea = GetDiamondFromRect2(680, $iUseY - 30, 825, $iUseY + 65)
			Local $aUse = decodeSingleCoord(findImage("Use", $g_sImgImgLocButtons & "\Use*", $sUseArea, 1, True))
			If Not IsArray($aUse) Then ContinueLoop
			If UBound($aUse) <> 2 Then ContinueLoop
			$aCandidates[$iCount][0] = $iRecipe + 1
			$aCandidates[$iCount][1] = $aUse[0]
			$aCandidates[$iCount][2] = $aUse[1]
			$iCount += 1
		Next
		If $iCount > 0 Then ExitLoop
		If _Sleep(250) Then Return False
	Next
	If $iCount = 0 Then
		SetLog("Script Rotation Test: No Use button found", $COLOR_WARNING)
		SetLog(_PadStringCenter(" Test ScriptRotation End ", 52, "="), $COLOR_INFO)
		Return False
	EndIf

	Local $iSelected = Random(0, $iCount - 1, 1)
	Local $aSelected[2] = [$aCandidates[$iSelected][1], $aCandidates[$iSelected][2]]
	SetLog("Script Rotation Test: Found " & $iCount & " Use Buttons; Selecting Recipe " & $aCandidates[$iSelected][0], $COLOR_INFO)
	ScriptRotationInvalidateRecipe()
	ClickP($aSelected, 1, 120, "Test ScriptRotation: Use Recipe")
	If _Sleep(700) Then Return False

	Local $aArmyTabActive[4] = [200, 180 + $g_iGAME_HEIGHT - 732, 0x7E4B2D, 15]
	For $iConfirm = 0 To 7
		If _CheckPixel($aArmyTabActive, True) Then ExitLoop
		Local $aOkay = findButton("Okay", Default, 1, True)
		If IsArray($aOkay) And UBound($aOkay) = 2 Then
			ClickP($aOkay, 1, 120, "Test ScriptRotation: Confirm Recipe")
			ExitLoop
		EndIf
		If _Sleep(250) Then Return False
	Next
	Local $bApplied = _WaitForCheckPixel($aArmyTabActive, True, Default, "Test ScriptRotation: My Army", Default, True)
	If $bApplied Then
		SetLog("Script Rotation Test: Recipe " & $aCandidates[$iSelected][0] & " Applied", $COLOR_SUCCESS)
	Else
		SetLog("Script Rotation Test: Recipe application not confirmed", $COLOR_WARNING)
	EndIf
	SetLog(_PadStringCenter(" Test ScriptRotation End ", 52, "="), $COLOR_INFO)
	Return $bApplied
EndFunc   ;==>TestScriptRotation
