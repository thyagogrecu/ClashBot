; #FUNCTION# ===========================================================================================================
; Name ..........: Revenge Battle
; Author ........: Phael
; Description ...: Detects and starts available revenge attacks from the attack log.
; Remarks .......: Applies a one-hour retry cooldown when no revenge attack is available.
; ======================================================================================================================
Func JoinRevengeBattle()
	; === VALIDATION ===
	If Not $g_bEnableRevengeBattle Then Return False
	If Not $g_bRunState Then Return False
	If Not IsMainPage() Then Return False

	; === REVENGE COOLDOWN ===
	If $g_sNextRevengeTime <> "" Then
		Local $iLeft = _DateDiff('s', _NowCalc(), $g_sNextRevengeTime)
		If $iLeft > 0 Then
			SetLog("Revenge Cooldown Active (" & $iLeft & "s remaining)", $COLOR_DEBUG)
			Return False
		Else
			$g_sNextRevengeTime = "" ; Expired, clear timer
		EndIf
	EndIf

	If Not IsMainPage() Then Return False

	SetLog("Checking Revenge Attacks", $COLOR_INFO)

	; === LOG NAVIGATION ===
	Local $aBattleLogButton
	For $i = 0 To 2
		$aBattleLogButton = FindButton("AttackButton")
		If IsArray($aBattleLogButton) And UBound($aBattleLogButton) = 2 Then ExitLoop
		If _Sleep(500) Then Return False
	Next
	If Not IsArray($aBattleLogButton) Or UBound($aBattleLogButton) <> 2 Then
		SetLog("Cannot find Battle button", $COLOR_ERROR)
		Return False
	EndIf

	ClickP($aBattleLogButton, 1, 120, "Open Battle Screen")
	If _Sleep(1000) Then Return False

	Click(Random(92, 102, 1), Random(212, 222, 1), 1, 120, "Click Battle Log")
	If _Sleep(1000) Then Return False

	Click(Random(280, 400, 1), Random(190, 200, 1), 1, 0, "Click Defense Log Tab")
	If _Sleep(500) Then Return False

	; === REVENGE DETECTION ===
	Local $sRevengeArea = GetDiamondFromRect2(685, 250, 815, 310)
	Local $aRevengeButton = decodeSingleCoord(findImage("Revenge", $g_sImgImgLocButtons & "\Revenge*", $sRevengeArea, 1, True))
	If Not $g_bRunState Then Return False
	If IsArray($aRevengeButton) And UBound($aRevengeButton) = 2 Then
		SetLog("Revenge Available (Slot 1)", $COLOR_SUCCESS)
		ClickP($aRevengeButton, 1)
		$g_iSpecialBattleMode = $eSpecialBattleRevenge
		$g_sNextRevengeTime = ""
		If _WaitRevengeTransition() Then
			SetLog("Revenge Battle Initiated!", $COLOR_SUCCESS)
		Else
			SetLog("Revenge button clicked; continuing as initiated", $COLOR_WARNING)
		EndIf
		Return True
	EndIf
	SetLog("Revenge Attacks Unavailable", $COLOR_DEBUG)
	
	; === RETRY COOLDOWN ===
	$g_sNextRevengeTime = _DateAdd('h', 1, _NowCalc())
	SetLog("Next Revenge Check @ " & $g_sNextRevengeTime, $COLOR_DEBUG)
	
	CloseWindow()
	If _Sleep(500) Then Return False

	; Continue directly from the Battle screen into the normal multiplayer search.
	Click(Random(140, 200, 1), Random(480, 500, 1), 1, 120, "Find a Match after Revenge")
	If _Sleep(1500) Then Return False
	Click(Random(700, 770, 1), Random(530, 540, 1), 1, 120, "Confirm Normal Match")
	If Not _WaitRevengeTransition(True) Then
		SetLog("Normal search transition after Revenge failed", $COLOR_ERROR)
		$g_bCloudsActive = False
		Return -1
	EndIf
	$g_bCloudsActive = True
	Return 2
EndFunc   ;==>JoinRevengeBattle

; #FUNCTION# ===========================================================================================================
; Name ..........: _WaitRevengeTransition
; Description ...: Confirms that Revenge or its normal-search fallback left the Battle screen.
; Remarks .......: Accepts cloud-search text, an enemy attack screen, or the shield confirmation page.
; ======================================================================================================================

Func _WaitRevengeTransition($bAllowShieldPage = False)
	Local $aEndBattleButton
	For $i = 1 To 30
		If Not $g_bRunState Then Return False
		If IsAttackPage(False) Or chkSearchText() Then Return True
		If _CheckPixel($aSurrenderButton, $g_bCapturePixel) Then
			$aEndBattleButton = FindButton("EndBattle", Default, 1, True)
			If IsArray($aEndBattleButton) And UBound($aEndBattleButton, 1) = 2 Then Return True
		EndIf
		If $bAllowShieldPage And IsAttackWhileShieldPage(False) Then Return True
		If _Sleep(250) Then Return False
	Next
	Return False
EndFunc   ;==>_WaitRevengeTransition

; #FUNCTION# ===========================================================================================================
; Name ..........: TestRevengeBattle
; Description ...: Tests navigation from the Main Village to the first available Revenge button.
; Remarks .......: Stops after clicking Revenge and does not execute attack preparation or deployment.
; ======================================================================================================================

Func TestRevengeBattle()
	SetLog(_PadStringCenter(" Test Revenge Battle Start Begin (" & $g_sBotVersion & ")", 54, "="), $COLOR_INFO)

	If Not $g_bRunState Then Return False
	ClearScreen()
	If Not IsMainPage() Then
		SetLog("[Revenge Battle Test]: Main Village not found", $COLOR_ERROR)
		Return False
	EndIf

	Local $aButton
	For $i = 0 To 2
		$aButton = FindButton("AttackButton")
		If IsArray($aButton) And UBound($aButton) = 2 Then ExitLoop
		If _Sleep(500) Then Return False
	Next
	If Not IsArray($aButton) Or UBound($aButton) <> 2 Then
		SetLog("[Revenge Battle Test]: Battle button not found", $COLOR_ERROR)
		Return False
	EndIf

	ClickP($aButton, 1, 120, "Test Revenge: Open Battle")
	If _Sleep(1000) Then Return False

	Click(Random(92, 102, 1), Random(212, 222, 1), 1, 120, "Test Revenge: Open Battle Log")
	If _Sleep(1000) Then Return False
	Click(Random(280, 400, 1), Random(190, 200, 1), 1, 0, "Test Revenge: Defense Log")
	If _Sleep(500) Then Return False

	Local $sRevengeArea = GetDiamondFromRect2(685, 250, 815, 310)
	Local $aRevengeButton = decodeSingleCoord(findImage("Revenge", $g_sImgImgLocButtons & "\Revenge*", $sRevengeArea, 1, True))
	If Not $g_bRunState Then Return False
	If IsArray($aRevengeButton) And UBound($aRevengeButton) = 2 Then
		SetLog("[Revenge Battle Test]: Revenge Button Found", $COLOR_SUCCESS)
		ClickP($aRevengeButton, 1, 0, "Test Revenge: Click Revenge")
		If Not _WaitRevengeTransition() Then
			SetLog("[Revenge Battle Test]: Attack Screen Transition Failed", $COLOR_ERROR)
			Return False
		EndIf
		SetLog(_PadStringCenter(" Test Revenge Battle Start End: SUCCESS ", 52, "="), $COLOR_SUCCESS)
		Return True
	EndIf
	SetLog("[Revenge Battle Test]: No Revenge Button Available", $COLOR_WARNING)
	SetLog(_PadStringCenter(" Test Revenge Battle Start End: FAILED ", 52, "="), $COLOR_INFO)
	Return False
EndFunc   ;==>TestRevengeBattle
