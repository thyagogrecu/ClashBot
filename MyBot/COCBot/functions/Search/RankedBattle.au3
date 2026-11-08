; #FUNCTION# ===========================================================================================================
; Name ..........: Ranked Battle
; Author ........: Phael
; Description ...: Detects and joins available ranked battles.
; Remarks .......: Preserves Ranked Battle and Clan Castle wait settings after completion.
; ======================================================================================================================

Func JoinRankedBattle(ByRef $sResult)
	$sResult = "Error"
	Local $bRankedBattle = False, $aMatch, $aButton

	; === RANKED STATE DETECTION ===
	For $i = 1 To 20
		If Not $g_bRunState Then Return False
		If _Sleep(50) Then Return False
		SetDebugLog("Searching for Ranked Battle button #" & $i, $COLOR_DEBUG)
		$aButton = QuickMIS("CNX", $g_sImgRankedBattleSearch, 300, 420, 560, 550)
		If Not IsArray($aButton) And $i >= 3 And _RBD_IsRankedMatchButtonVisible() Then
			Local $aFallbackMatch[1][3] = [["Match", 425, 496]]
			$aButton = $aFallbackMatch
		EndIf
		If IsArray($aButton) And UBound($aButton) > 0 Then

			For $z = 0 To UBound($aButton) - 1
				If $aButton[$z][0] = "SignUp" Then
					SetLog("Sign Up Button Detected", $COLOR_DEBUG)
					Click($aButton[$z][1], $aButton[$z][2], 1, 0, "SignUp Ranked Battle")
					If _Sleep(1500) Then Return False
					If QuickMIS("BC1", $g_sImgRankedBattleSearch, 500, 460, 710, 530) Then
						Click($g_iQuickMISX, $g_iQuickMISY, 1, 0, "SignUp Ranked Battle [2]")
						SetLog("Signing In For Ranked Battle", $COLOR_ACTION)
						ContinueLoop 2
					EndIf
				EndIf
				If $aButton[$z][0] = "SignedUp" Then
					SetLog("Signed Up Button Detected", $COLOR_DEBUG)
					SetLog("Signup Confirmed!", $COLOR_SUCCESS)
					If _Sleep(500) Then Return False
					ExitLoop 2
				EndIf
				If $aButton[$z][0] = "Completed" Then
					SetLog("Ranked Attacks Completed", $COLOR_SUCCESS)
					$sResult = "Completed"
					If _Sleep(500) Then Return False
					ExitLoop 2
				EndIf
				If $aButton[$z][0] = "Match" Then
					SetLog("Ranked Match Button Detected", $COLOR_INFO)
					$aMatch = getMatchRemain()
					If UBound($aMatch) > 1 Then
						SetLog("Ranked Matches: " & $aMatch[0] & "/" & $aMatch[1], $COLOR_INFO)
						SetLog("Remaining Matches: " & ($aMatch[1] - $aMatch[0]), $COLOR_INFO)
						If Number($aMatch[1]) > 0 And Number($aMatch[0]) = Number($aMatch[1]) Then
							SetLog("All Ranked Attacks Used", $COLOR_SUCCESS)
							$sResult = "Completed"
							ExitLoop 2
						EndIf
					EndIf
					
					Click($aButton[$z][1], $aButton[$z][2], 1, 0, "Find a Match Ranked Battle")
					If _Sleep(1000) Then Return False

					; === MATCH START ===
					If _Sleep(1500) Then Return False ; Wait for popup to appear
					Local $iGrnX = Random(700, 770, 1)
					Local $iGrnY = Random(530, 540, 1)
					Click($iGrnX, $iGrnY)
					_Sleep(1000) ; Wait for clouds

					; === MATCH CONFIRMATION ===
					If _Sleep(500) Then Return False
					If Not _RBD_IsConfirmationOpen() Then
						SetLog("Ranked Battle confirmation button not detected", $COLOR_WARNING)
						Return False
					EndIf
					Click(Random(520, 530, 1), Random(445, 455, 1), 1, 0, "Confirm Ranked Battle Attack")
					_Sleep(500) ; Wait for confirmation
					If _RBD_IsRankedMatchButtonVisible() Then
						SetLog("Ranked Battle selection remained open; match not started", $COLOR_WARNING)
						Return False
					EndIf
					
					$bRankedBattle = True
					$g_iSpecialBattleMode = $eSpecialBattleRanked
					SetLog("Ranked Battle Initiated!", $COLOR_SUCCESS)
					$sResult = "Started"
					Return True
				EndIf
			Next
		EndIf
	Next
	Return False
EndFunc   ;==>JoinRankedBattle

Func _RBD_IsRankedMatchButtonVisible()
	Return _ColorCheck(_GetPixelColor(370, 496, True), Hex(0xF9AD2C, 6), 25) And _
			_ColorCheck(_GetPixelColor(480, 496, True), Hex(0xF9AD2C, 6), 25)
EndFunc   ;==>_RBD_IsRankedMatchButtonVisible

Func _RBD_IsNormalFindMatchButtonVisible()
	Return _ColorCheck(_GetPixelColor(65, 500, True), Hex(0xF9AD2C, 6), 25) And _
			_ColorCheck(_GetPixelColor(255, 500, True), Hex(0xF9AD2C, 6), 25)
EndFunc   ;==>_RBD_IsNormalFindMatchButtonVisible

Func _RBD_IsConfirmationOpen()
	Return _ColorCheck(_GetPixelColor(465, 430, True), Hex(0xE3FA8C, 6), 30) And _
			_ColorCheck(_GetPixelColor(580, 430, True), Hex(0xE3FA8C, 6), 30) And _
			_ColorCheck(_GetPixelColor(520, 470, True), Hex(0x6CBB1F, 6), 30) And _
			_ColorCheck(_GetPixelColor(300, 470, True), Hex(0xDE5323, 6), 30)
EndFunc   ;==>_RBD_IsConfirmationOpen

; #FUNCTION# ===========================================================================================================
; Name ..........: TestRankedBattle
; Description ...: Opens the Ranked Battle confirmation and detects its button without confirming the attack.
; Remarks .......: Leaves the confirmation window open for visual inspection.
; ======================================================================================================================

Func TestRankedBattle()
	SetLog("Checking Ranked Battle Confirmation", $COLOR_INFO)
	If IsMainPage(1) Then
		Local $aAttackButton = findButton("AttackButton", Default, 1, True)
		If Not IsArray($aAttackButton) Then
			SetLog("Main Attack button not detected", $COLOR_WARNING)
			Return False
		EndIf
		Click(Random(45, 80, 1), Random(625 + $g_iBottomOffsetY, 645 + $g_iBottomOffsetY, 1), 1, 130, "#RBTEST")
		If _Sleep(800) Then Return False
	EndIf

	Local $aButtons = QuickMIS("CNX", $g_sImgRankedBattleSearch, 300, 420, 560, 550)
	Local $iMatchX = 0, $iMatchY = 0, $bCompleted = False
	If IsArray($aButtons) Then
		For $i = 0 To UBound($aButtons) - 1
			If $aButtons[$i][0] = "Completed" Then $bCompleted = True
			If $aButtons[$i][0] = "Match" Then
				$iMatchX = $aButtons[$i][1]
				$iMatchY = $aButtons[$i][2]
				ExitLoop
			EndIf
		Next
	EndIf
	If $iMatchX = 0 And _RBD_IsRankedMatchButtonVisible() Then
		$iMatchX = 425
		$iMatchY = 496
	EndIf
	If $iMatchX = 0 Then
		Local $aCompletedCount = getMatchRemain()
		If UBound($aCompletedCount) >= 2 Then
			SetLog("Ranked Matches: " & $aCompletedCount[0] & "/" & $aCompletedCount[1], $COLOR_INFO)
			SetLog("Remaining Matches: " & (Number($aCompletedCount[1]) - Number($aCompletedCount[0])), $COLOR_INFO)
		Else
			SetLog("Ranked Matches: OCR failed", $COLOR_WARNING)
		EndIf
		If $bCompleted Or (UBound($aCompletedCount) >= 2 And Number($aCompletedCount[0]) = Number($aCompletedCount[1])) Then
			SetLog("Ranked Attacks Completed", $COLOR_SUCCESS)
			Return True
		Else
			SetLog("Ranked Match button not detected; ranked status unconfirmed", $COLOR_WARNING)
		EndIf
		Return False
	EndIf

	Local $aMatchCount = getMatchRemain()
	If UBound($aMatchCount) >= 2 Then
		SetLog("Ranked Matches: " & $aMatchCount[0] & "/" & $aMatchCount[1], $COLOR_INFO)
		SetLog("Remaining Matches: " & (Number($aMatchCount[1]) - Number($aMatchCount[0])), $COLOR_INFO)
	Else
		SetLog("Ranked Matches: OCR failed", $COLOR_WARNING)
	EndIf

	Click($iMatchX, $iMatchY, 1, 0, "#RBTEST")
	If _Sleep(1500) Then Return False
	If Not _ColorCheck(_GetPixelColor(700, 537, True), Hex(0xB2E57A, 6), 35) Then
		SetLog("My Army Attack button not detected", $COLOR_WARNING)
		Return False
	EndIf
	Click(700, 537, 1, 0, "#RBTEST")
	If _Sleep(800) Then Return False
	If _ColorCheck(_GetPixelColor(700, 537, True), Hex(0xB2E57A, 6), 35) Then
		SetLog("My Army remained open", $COLOR_WARNING)
		Return False
	EndIf

	If Not _RBD_IsConfirmationOpen() Then
		SetLog("Confirmation button not detected; test stopped without clicking", $COLOR_WARNING)
		Return False
	EndIf
	SetLog("Confirmation button detected at 525,450; test stopped without clicking", $COLOR_SUCCESS)
	Return True
EndFunc   ;==>TestRankedBattle



; #FUNCTION# ===========================================================================================================
; Name ..........: _RBD_CloseBattleSelection
; Description ...: Dismisses the slide-out battle selection panel by clicking the exposed village area.
; Remarks .......: The panel has no close X. Does not start a battle or change the halt command.
; ======================================================================================================================
Func _RBD_CloseBattleSelection()
	For $iAttempt = 1 To 3
		If Not __RunBotCanContinue() Then Return False
		If Not _RBD_IsNormalFindMatchButtonVisible() And Not _RBD_IsRankedMatchButtonVisible() And IsMainPage(1) Then Return True
		Click(650, 300, 1, 120, "Close Battle Selection")
		If _Sleep(500) Then Return False
	Next
	Local $bClosed = Not _RBD_IsNormalFindMatchButtonVisible() And Not _RBD_IsRankedMatchButtonVisible() And IsMainPage(1)
	If Not $bClosed Then SetLog("Could not close battle selection after ranked completion", $COLOR_WARNING)
	Return $bClosed
EndFunc   ;==>_RBD_CloseBattleSelection
