; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttackBB
; Description ...: This file controls attacking preparation of the builders base
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Chilly-Chill (04-2019)
; Modified ......: Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CheckBBGoldStorageFull($SetLog = True)
	Local $aBBGoldFull[4] = [650, 29, 0xE7C00D, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBGoldFull, True, Default, "BB Gold Full") Then
		If $SetLog Then SetLog("BB Gold Storages: Full", $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>CheckBBGoldStorageFull

Func CheckBBElixirStorageFull($SetLog = True)
	Local $aBBElixirFull[4] = [650, 66, 0x8027FF, 10]
	If _Sleep(500) Then Return
	If _CheckPixel($aBBElixirFull, True, Default, "BB Elixir Full") Then
		If $SetLog Then SetLog("BB Elixir Storages: Full", $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>CheckBBElixirStorageFull

Func PrepareAttackBB($AttackCount, ByRef $bStarsUnavailable)
	$bStarsUnavailable = False

	If $g_bChkForceAttackOnClanGames And $g_bIsBBevent Then
		SetLog("Builder Base Challenge: " & $CurrentActiveChallenge, $COLOR_ACTION)
		SetLog("Clan Games Detected - Forcing BB Attack", $COLOR_DEBUG)
		SetLog("Attack, no matter what!", $COLOR_DEBUG)
		CheckLootAvail()
		CheckBBGoldStorageFull()
		CheckBBElixirStorageFull()
		If Not ClickAttack() Then Return False
		If _Sleep(1500) Then Return
		CheckMachReady()
		Return True
	EndIf

	If Not $g_bRunState Then Return ; Stop Button

	If $g_bChkBBTrophyRange Then
		If ($g_aiCurrentLootBB[$eLootTrophyBB] > $g_iTxtBBTrophyUpperLimit Or $g_aiCurrentLootBB[$eLootTrophyBB] < $g_iTxtBBTrophyLowerLimit) Then
			SetLog("Trophies out of range.")
			SetDebugLog("Current Trophies: " & $g_aiCurrentLootBB[$eLootTrophyBB] & " Lower Limit: " & $g_iTxtBBTrophyLowerLimit & " Upper Limit: " & $g_iTxtBBTrophyUpperLimit)
			If _Sleep(1500) Then Return
			Return False
		EndIf
	EndIf
	
	Local $bStarsAvailable = False
	If $g_bChkBBStarsAvailable And Not $g_bBBSpamRunning Then
		$bStarsAvailable = CheckLootAvail()
		If Not $bStarsAvailable Then
			$bStarsUnavailable = True
			If _Sleep(1500) Then Return
			Return False
		EndIf
	EndIf

	; When enabled, only attack with stars available. Available stars take
	; priority over the storage halt, even when both storages are full.
	; BBSpam handles full storages and checks stars only when both are full.
	If $g_bChkBBHaltOnStoragesFull And Not $bStarsAvailable And Not $g_bBBSpamRunning Then
		If CheckBBGoldStorageFull() And CheckBBElixirStorageFull() Then
			If _Sleep(1500) Then Return
			Return False
		EndIf
	EndIf
	If Not ClickAttack() Then Return False
	If _Sleep(1000) Then Return

	Return True ; returns true if all checks succeed
EndFunc   ;==>PrepareAttackBB

Func CheckLootAvail($SetLog = True)
	If $SetLog Then SetLog("Checking Stars Available", $COLOR_INFO)
	Local $bRet = False, $iRemainStars = 0, $iMaxStars = 0
	Local $sStars = _ReadBBStarsOCR()

	If $g_bDebugSetLog Then SetLog("Stars: " & $sStars, $COLOR_DEBUG2)
	If $sStars <> "" And StringInStr($sStars, "#") Then
		Local $aStars = StringSplit($sStars, "#", $STR_NOCOUNT)
		If IsArray($aStars) Then
			$iRemainStars = $aStars[0]
			$iMaxStars = $aStars[1]
		EndIf
		If Number($iRemainStars) >= 0 And Number($iRemainStars) <= Number($iMaxStars) And Number($iMaxStars) > 0 Then
			If $SetLog Then SetLog("Stars Available: " & $iRemainStars & "/" & $iMaxStars, $COLOR_INFO)
			$bRet = True
		Else
			SetLog("Stars Unavailable")
		EndIf
	EndIf
	Return $bRet
EndFunc   ;==>CheckLootAvail

; #FUNCTION# ===========================================================================================================
; Name ..........: _ReadBBStarsOCR
; Description ...: Reads the Builder Base available-stars counter with the dedicated OCR and updated builder fallback.
; Remarks .......: Returns the OCR current/maximum separator as #.
; ======================================================================================================================

Func _ReadBBStarsOCR()
	Local $aOffsets[5] = [0, -3, 3, -6, 6]
	Local $aLanguages[3] = ["coc-BBAttackAvail", "coc-Builders", "coc-t-b"]
	Local $sStars = ""
	For $i = 0 To UBound($aOffsets) - 1
		For $j = 0 To UBound($aLanguages) - 1
			$sStars = StringStripWS(StringReplace(getOcrAndCapture($aLanguages[$j], $aBBStars[0], $aBBStars[1] + $aOffsets[$i], 60, 28, True), "/", "#"), $STR_STRIPALL)
			If $aLanguages[$j] = "coc-t-b" And Not StringRegExp($sStars, "^\d+#\d+$") Then
				Local $sStarDigits = StringRegExpReplace($sStars, "\D", "")
				If StringLen($sStarDigits) = 3 And StringRight($sStarDigits, 2) = "11" Then $sStars = StringLeft($sStarDigits, 1) & "#11"
				If StringLen($sStarDigits) = 4 And StringRight($sStarDigits, 2) = "11" Then $sStars = StringLeft($sStarDigits, 2) & "#11"
			EndIf
			If StringRegExp($sStars, "^\d+#\d+$") Then Return $sStars
		Next
	Next
	; The star icon can confuse OCR at the edge of the counter; read numerator and denominator separately as a fallback.
	For $i = 0 To UBound($aOffsets) - 1
		Local $sCurrent = StringRegExpReplace(getOcrAndCapture("coc-t-b", $aBBStars[0], $aBBStars[1] + $aOffsets[$i], 17, 28, True), "\D", "")
		Local $sMaximum = StringRegExpReplace(getOcrAndCapture("coc-t-b", $aBBStars[0] + 19, $aBBStars[1] + $aOffsets[$i], 25, 28, True), "\D", "")
		If StringIsDigit($sCurrent) And StringIsDigit($sMaximum) And Number($sCurrent) <= Number($sMaximum) And Number($sMaximum) > 0 Then Return $sCurrent & "#" & $sMaximum
	Next
	Return $sStars
EndFunc   ;==>_ReadBBStarsOCR

Func CheckMachReady()
	Local $bRet = False
	If QuickMis("BC1", $g_sImgBBMachReady, 125, 275 + $g_iMidOffsetY, 180, 325 + $g_iMidOffsetY) Then
		$bRet = True
		SetDebugLog("Battle Machine: Ready", $COLOR_SUCCESS)
	EndIf
	Return $bRet
EndFunc   ;==>CheckMachReady

Func CheckArmyReady()
	Local $i = 0
	Local $bReady = True, $bNeedTrain = False, $bTraining = False

	If _ColorCheck(_GetPixelColor(123, 245 + $g_iMidOffsetY, True), Hex(0xE84E52, 6), 20) Then
		SetLog("Army is not ready", $COLOR_DEBUG)
		$bNeedTrain = True ;need train, so will train cannon cart
		$bReady = False
	EndIf

	If Not $bReady And $bNeedTrain Then
		SetLog("Train to fill army", $COLOR_INFO)
		ClickAway()
		If _Sleep(2000) Then Return
		ClickP($aArmyTrainButton, 1, 120, "BB Train Button")

		If _Sleep(1000) Then Return ; wait for window
		For $i = 1 To 5
			SetLog("Waiting for Army Window #" & $i, $COLOR_ACTION)
			If _Sleep(500) Then Return
			If QuickMis("BC1", $g_sImgGeneralCloseButton, 790, 120 + $g_iMidOffsetY, 835, 165 + $g_iMidOffsetY) Then ExitLoop
		Next

		Local $Camp = QuickMIS("CNX", $g_sImgFillCamp, 45, 210 + $g_iMidOffsetY, 800, 250 + $g_iMidOffsetY)
		For $i = 1 To UBound($Camp)
			If QuickMIS("BC1", $g_sImgFillTrain, 45, 390 + $g_iMidOffsetY, 800, 550 + $g_iMidOffsetY) Then
				SetLog("Fill ArmyCamp with : " & $g_iQuickMISName, $COLOR_DEBUG)
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(500) Then Return
			EndIf
		Next

		$Camp = QuickMIS("CNX", $g_sImgFillCamp, 45, 210 + $g_iMidOffsetY, 800, 250 + $g_iMidOffsetY)
		If UBound($Camp) > 0 Then
			$bReady = False
		Else
			$bReady = True
		EndIf

		ClickAway("Left")
		If _Sleep(1000) Then Return ; wait for window close
		ClickAttack()
	EndIf

	If Not $bReady Then
		SetDebugLog("Army: Not Ready",	$COLOR_DEBUG)
	Else
		SetDebugLog("Army: Ready", $COLOR_SUCCESS)
	EndIf
	Return $bReady
EndFunc   ;==>CheckArmyReady

Func CheckForSlots()
	ClickP($aArmyTrainButton, 1, 120, "BB Train Button")
	If _Sleep(1000) Then Return
	Local $aDetectedSlots = QuickMIS("CNX", $g_sImgDirBBTroops, 45, 220 + $g_iMidOffsetY, 608, 310 + $g_iMidOffsetY)
	If IsArray($aDetectedSlots) And UBound($aDetectedSlots) > 0 Then
		If UBound($aDetectedSlots) < 5 Then
			$iStartSlotMem = 27
		Else
			$iStartSlotMem = 21
		EndIf
	Else
		$iStartSlotMem = 21
	EndIf
	Local $aDetectedSlotsR = QuickMIS("CNX", $g_sImgDirBBTroops, 608, 220 + $g_iMidOffsetY, 815, 310 + $g_iMidOffsetY)
	If IsArray($aDetectedSlotsR) And UBound($aDetectedSlotsR) > 0 Then
		If UBound($aDetectedSlots) + UBound($aDetectedSlotsR) < 5 Then
			$iStartSlotMem2 = 27
		Else
			$iStartSlotMem2 = 21
		EndIf
	Else
		$iStartSlotMem2 = $iStartSlotMem
	EndIf
	SetDebugLog("Total Troop Slots Detected : " & UBound($aDetectedSlots) + UBound($aDetectedSlotsR), $COLOR_DEBUG2)
	If _Sleep(1000) Then Return
	ClickAway("Left")
	If _Sleep(1000) Then Return ; wait for window close
EndFunc   ;==>CheckForSlots

Func ClickAttack($bSuppressLog = False)
	; The Start Attack window may already be open after a previous attempt.
	If IsBBFindNowVisible() Then Return True

	Local $aCoords

	For $i = 1 To 3
		$aCoords = findButton("AttackButton")
		If IsArray($aCoords) And UBound($aCoords) >= 2 Then
			SetDebugLog("Builder Base Battle button found at " & $aCoords[0] & "," & $aCoords[1])
			PureClick($aCoords[0], $aCoords[1])
			ExitLoop
		EndIf
		If _Sleep(250) Then Return False
	Next

	Local $bBattleFound = IsArray($aCoords)
	If $bBattleFound Then $bBattleFound = UBound($aCoords) >= 2
	If Not $bBattleFound Then
		If IsMainPageBuilderBase(1) Then
			SetDebugLog("Builder Base Battle image not found; using fixed button position", $COLOR_DEBUG)
			Click(Random(45, 80, 1), Random(625 + $g_iBottomOffsetY, 645 + $g_iBottomOffsetY, 1), 1, 120, "Builder Base Battle")
			$bBattleFound = True
		Else
			If Not $bSuppressLog Then SetLog("Can not find button for Builders Base Battle button", $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	Return True
EndFunc   ;==>ClickAttack

Func ReturnHomeDropTrophyBB($bOnlySurender = False)
	SetLog("Returning Home", $COLOR_SUCCESS)

	For $i = 1 To 15
		Select
			Case IsBBAttackPage() = True
				Click(65, 540 + $g_iMidOffsetY) ;click surrender
				If _Sleep(1000) Then Return
			Case QuickMIS("BC1", $g_sImgBBReturnHome, 380, 510 + $g_iMidOffsetY, 480, 570 + $g_iMidOffsetY) = True
				If $bOnlySurender Then
					Return True
				EndIf
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(3000) Then Return
			Case QuickMIS("BC1", $g_sImgBBAttackBonus, 360, 450 + $g_iMidOffsetY, 500, 510 + $g_iMidOffsetY) = True
				SetLog("Congratulations chief, stars bonus awarded!", $COLOR_SUCCESS)
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(2000) Then Return
				Return True
			Case isOnBuilderBase() = True
				Return True
			Case IsOKCancelPage() = True
				ClickOkay("BB Attack Surrender") ; Click Okay to Confirm surrender
				If _Sleep(1000) Then Return
		EndSelect
		If _Sleep(500) Then Return
	Next

	SetLog("Failed to return home after surrendering", $COLOR_ERROR)
	Return False
EndFunc   ;==>ReturnHomeDropTrophyBB
