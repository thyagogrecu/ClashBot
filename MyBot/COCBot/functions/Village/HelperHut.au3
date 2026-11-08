; #FUNCTION# ====================================================================================================================
; Name ..........: HelperHut.au3
; Description ...: This file controls Helper Hut and Assignments
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Moebius14 (11/2024)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func HelperHut()
	Select
		Case $g_bChkAppBuilder = 0 And $g_bChkLabAssistant = 0
			Return
		Case $g_bChkAppBuilder > 0 And $g_bChkLabAssistant = 0
			AppBuilder()
		Case $g_bChkAppBuilder = 0 And $g_bChkLabAssistant > 0
			LabAssistant()
		Case $g_bChkAppBuilder > 0 And $g_bChkLabAssistant > 0
			_HelperHutBoth()
	EndSelect

EndFunc   ;==>HelperHut

; #FUNCTION# ===========================================================================================================
; Name ..........: TestHelperHut
; Description ...: Opens the specified assistant card and reads both assistant levels in screen order.
; Remarks .......: Accepts "Lab" or "Builder"; does not assign either assistant.
; ======================================================================================================================

Func TestHelperHut($sAssistant)
	Local $sFirstTab = "", $sSecondTab = ""
	Switch StringLower($sAssistant)
		Case "lab"
			$sFirstTab = "LabAssist"
			$sSecondTab = "BuildersApp"
		Case "builder"
			$sFirstTab = "BuildersApp"
			$sSecondTab = "LabAssist"
		Case Else
			SetLog('Use TestHelperHut("Lab") or TestHelperHut("Builder")', $COLOR_ERROR)
			Return False
	EndSwitch

	If Not _OpenHelperHut() Then Return False
	Local $aButton = FindButton($sFirstTab)
	If Not IsArray($aButton) Or UBound($aButton) <> 2 Then
		SetLog($sAssistant & " assistant button not detected", $COLOR_WARNING)
		ClearScreen()
		Return False
	EndIf

	Click($aButton[0], 545 + $g_iBottomOffsetY)
	If _Sleep(Random(1500, 2000, 1)) Then Return False
	WaitForClanMessage("BuildersApprenticeTop")
	If Not _IsHelperHutAssistantOpen() Then
		SetLog("Assistant window not detected", $COLOR_WARNING)
		ClearScreen()
		Return False
	EndIf

	Local $sLabAssistantLevel = "", $sBuilderApprenticeLevel = ""
	For $i = 0 To 1
		Local $sCurrentTab = $i = 0 ? $sFirstTab : $sSecondTab
		If $i = 1 Then
			If Not _SelectHelperHutTab($sCurrentTab) Then
				CloseWindow()
				Return False
			EndIf
		EndIf

		Local $iMaxLevel = $sCurrentTab = "BuildersApp" ? 8 : 12
		Local $sLevel = StringRegExpReplace(_ReadHelperHutLevelOCR(), "[^0-9]", "")
		If Not StringIsDigit($sLevel) Or Number($sLevel) < 1 Or Number($sLevel) > $iMaxLevel Then $sLevel = ""
		If $sCurrentTab = "LabAssist" Then
			$sLabAssistantLevel = $sLevel
			SetLog("[Lab Assistant Level]: " & ($sLevel <> "" ? $sLevel : "OCR failed"), $sLevel <> "" ? $COLOR_INFO : $COLOR_ERROR)
		Else
			$sBuilderApprenticeLevel = $sLevel
			SetLog("[Builder's Apprentice Level]: " & ($sLevel <> "" ? $sLevel : "OCR failed"), $sLevel <> "" ? $COLOR_INFO : $COLOR_ERROR)
		EndIf
	Next

	CloseWindow()
	Return $sLabAssistantLevel <> "" And $sBuilderApprenticeLevel <> ""
EndFunc   ;==>TestHelperHut

Func _ReadHelperHutLevelOCR()
	Local $iTop = 173 + $g_iMidOffsetY
	Local $aOcrAttempts[4][4] = [["coc-uptime", 650, 169, 74], ["coc-uptime2", 650, 169, 74], ["coc-uptime", 654, 169, 66], ["coc-uptime2", 654, 169, 66]]
	For $i = 0 To UBound($aOcrAttempts) - 1
		Local $sLevel = StringRegExpReplace(getOcrAndCapture($aOcrAttempts[$i][0], $aOcrAttempts[$i][1], $iTop, $aOcrAttempts[$i][3], 30, True), "[^0-9]", "")
		If StringRegExp($sLevel, "^([1-8]|[1-9][0-9])$") And Number($sLevel) <= 12 Then Return $sLevel
	Next
	Return ""
EndFunc   ;==>_ReadHelperHutLevelOCR

; #FUNCTION# ===========================================================================================================
; Name ..........: _LogHelperHutCooldown
; Description ...: Logs assistant cooldown state, remaining time, and absolute availability.
; Remarks .......: Used by Lab Assistant and Builder's Apprentice routines.
; ======================================================================================================================

Func _LogHelperHutCooldown($sWaitTime, $sAvailableAt)
	SetLog("Cooldown Time", $COLOR_SUCCESS)
	SetLog("Will be available in " & $sWaitTime)
	SetLog("Available at " & $sAvailableAt)
EndFunc   ;==>_LogHelperHutCooldown

Func _SelectHelperHutTab($sTab)
	Local $sTabImage
	Switch $sTab
		Case "LabAssist"
			$sTabImage = $g_sImgMiniLabAssistHead
		Case "BuildersApp"
			$sTabImage = $g_sImgMiniBuilderAppHead
		Case Else
			Return False
	EndSwitch

	For $iAttempt = 1 To 2
		Local $aTab = decodeSingleCoord(FindImageInPlace2("HelperHutTab", $sTabImage, 45, 510 + $g_iMidOffsetY, 390, 610 + $g_iMidOffsetY, True))
		If IsArray($aTab) And UBound($aTab) = 2 Then
			ClickP($aTab, 1, 120, "HelperHutTab")
			If _Sleep(800) Then Return False
			WaitForClanMessage("BuildersApprenticeMid")
			Return True
		EndIf
		If $iAttempt < 2 And _Sleep(200) Then Return False
	Next

	SetLog("Helper Hut tab button not found: " & $sTab, $COLOR_WARNING)
	Return False
EndFunc   ;==>_SelectHelperHutTab

; #FUNCTION# ===========================================================================================================
; Name ..........: _IsHelperHutAssistantOpen
; Description ...: Detects the assistant window using its tabs, with the existing close model as fallback.
; ======================================================================================================================
Func _IsHelperHutAssistantOpen()
	Local $sArea = GetDiamondFromRect2(45, 510, 390, 640)
	Local $aTab = decodeSingleCoord(findImage("HelperHutLabTab", $g_sImgMiniLabAssistHead, $sArea, 1, True))
	If IsArray($aTab) And UBound($aTab) = 2 Then Return True
	$aTab = decodeSingleCoord(findImage("HelperHutBuilderTab", $g_sImgMiniBuilderAppHead, $sArea, 1, True))
	If IsArray($aTab) And UBound($aTab) = 2 Then Return True
	Return QuickMIS("BC1", $g_sImgGeneralCloseButton, 770, 100, 845, 130 + $g_iMidOffsetY)
EndFunc   ;==>_IsHelperHutAssistantOpen

Func _OpenHelperHut()
	Local $aiSavedHelperHutPos = $g_aiHelperHutPos
	If ImgLocateHelperHut(True, True) Then Return True
	$g_aiHelperHutPos = $aiSavedHelperHutPos
	If $g_aiHelperHutPos[0] <= 0 Or $g_aiHelperHutPos[1] <= 0 Then Return False
	SetLog("Helper Hut Position: (" & $g_aiHelperHutPos[0] & "," & $g_aiHelperHutPos[1] & ")", $COLOR_SUCCESS)

	BuildingClick($g_aiHelperHutPos[0], $g_aiHelperHutPos[1])
	If _Sleep($DELAYBUILDINGINFO1) Then Return False
	Local $BuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
	Return StringInStr($BuildingInfo[1], "Helper", $STR_NOCASESENSEBASIC) > 0
EndFunc   ;==>_OpenHelperHut

; #FUNCTION# ===========================================================================================================
; Name ..........: _OpenHelperHutAssistant
; Description ...: Opens either available assistant card and reports the tab initially displayed.
; Remarks .......: Optionally selects the requested tab after opening the assistant window.
; ======================================================================================================================

Func _OpenHelperHutAssistant($sTab, ByRef $sOpenedTab, $bSelectRequested = True)
	If _IsHelperHutAssistantOpen() Then
		If $bSelectRequested Then
			If Not _SelectHelperHutTab($sTab) Then Return False
			$sOpenedTab = $sTab
			Return True
		EndIf
		CloseWindow()
	EndIf
	If Not _OpenHelperHut() Then Return False

	Local $aButton = FindButton($sTab)
	Local $bOtherCard = Not (IsArray($aButton) And UBound($aButton) = 2)
	$sOpenedTab = $sTab
	If $bOtherCard Then
		$sOpenedTab = $sTab = "LabAssist" ? "BuildersApp" : "LabAssist"
		$aButton = FindButton($sOpenedTab)
		If Not IsArray($aButton) Or UBound($aButton) <> 2 Then
			ClearScreen()
			Return False
		EndIf
	EndIf

	Click($aButton[0], 545 + $g_iBottomOffsetY)
	If _Sleep(Random(1500, 2000, 1)) Then Return False
	WaitForClanMessage("BuildersApprenticeTop")
	If Not _IsHelperHutAssistantOpen() Then
		CloseWindow2()
		ClearScreen()
		Return False
	EndIf

	If $bOtherCard And $bSelectRequested Then Return _SelectHelperHutTab($sTab)
	Return True
EndFunc   ;==>_OpenHelperHutAssistant

Func AppBuilder()

	If $g_iTownHallLevel < 10 Then
		Return
	EndIf

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[$g_iSwitchAccMaxAccounts]
	Local Static $bUnderTime[$g_iSwitchAccMaxAccounts]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bUnderTime[$g_iCurAccount] = False
	EndIf

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec, $iDay

	If _DateIsValid($g_sAvailableAppBuilder) Then
		$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffAppBuilder > 0 Then

			$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $bUnderTime[$g_iCurAccount] = True Then
				SetLog("Current upgrade time too small", $COLOR_DEBUG1)
				SetLog("Next check in " & $sWaitTime, $COLOR_ACTION)
			Else
				_LogHelperHutCooldown($sWaitTime, $g_sAvailableAppBuilder)
			EndIf
			Return
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableAppBuilder) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then Return
		EndIf
	EndIf

	If Not _OpenHelperHut() Then Return

	Local $BuildersApp = FindButton("BuildersApp")
	If IsArray($BuildersApp) And UBound($BuildersApp) = 2 Then
		Click($BuildersApp[0], 545 + $g_iBottomOffsetY)
		If _Sleep(Random(1500, 2000, 1)) Then Return
	Else
		ClearScreen()
		Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	If Not _IsHelperHutAssistantOpen() Then
		SetLog("Builder's Apprentice Window Didn't Open", $COLOR_DEBUG1)
		CloseWindow2()
		If _Sleep(Random(1500, 2000, 1)) Then Return
		ClearScreen()
		Return
	EndIf

	WaitForClanMessage("BuildersApprenticeMid")
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 730, 520 + $g_iMidOffsetY, 815, 560 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Builder's Apprentice is Locked", $COLOR_ERROR)
		CloseWindow()
		Return
	EndIf

	Local $sLevelOCR = _ReadHelperHutLevelOCR()
	Local $bXMultiplier = Number(StringRegExpReplace($sLevelOCR, "[^0-9]", ""))
	If $bXMultiplier < 1 Or $bXMultiplier > 8 Then
		SetLog("Builder's Apprentice level OCR failed; using conservative level 1", $COLOR_WARNING)
		$bXMultiplier = 1
	Else
		SetLog("Builder's Apprentice Level: " & $bXMultiplier, $COLOR_INFO)
	EndIf

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniBuilderApp", $g_sImgMiniBuilderAppHead, 45, 510 + $g_iMidOffsetY, 390, 610 + $g_iMidOffsetY, True))
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniBuilderApp", $g_sImgMiniBuilderAppHead, 45, 510 + $g_iMidOffsetY, 390, 610 + $g_iMidOffsetY, True))
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	If $g_bChkAppBuilder = 2 Then MoveToBottom()

	WaitForClanMessage("BuildersApprenticeMid")

	Local $GreenAssignButtons = QuickMIS("CNX", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY)
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		If $g_bChkAppBuilder = 1 Then
			_ArraySort($GreenAssignButtons, 0, 0, 0, 2)
		Else
			_ArraySort($GreenAssignButtons, 1, 0, 0, 2)
		EndIf
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 4, 114, 16, True)
			Local $iRemainingTime = ConvertOCRTime("Upgrade Time", $bRemainingUpTimeOCR, False)
			SetDebugLog("Remaining Up OCR Time = " & $bRemainingUpTimeOCR & ", $iRemainingTime = " & $iRemainingTime & " m", $COLOR_INFO)
			Local $bBAGranted = False
			Switch $bXMultiplier
				Case 1 To 3
					If $iRemainingTime > $bXMultiplier * 60 Then $bBAGranted = True
				Case 4
					If $iRemainingTime > ($bXMultiplier - 1) * 60 Then $bBAGranted = True
				Case 5, 6
					If $iRemainingTime > ($bXMultiplier - 2) * 60 Then $bBAGranted = True
				Case 7, 8
					If $iRemainingTime > ($bXMultiplier - 3) * 60 Then $bBAGranted = True
			EndSwitch
			If $iRemainingTime = 0 Then $bBAGranted = True ; In Case
			If $bBAGranted Then
				If $iRemainingTime > 0 Then
					; Must be in ms !
					If $iRemainingTime > $bXMultiplier * 60 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
					EndIf
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iDay = Floor($iRemainingTime / 1440)
					$iHour = Floor(Mod($iRemainingTime, 1440) / 60)
					$iMin = Mod($iRemainingTime, 60)
					If $iDay > 0 Then $sWaitTime &= $iDay & "d"
					If $iHour > 0 Then $sWaitTime &= $iHour & "h"
					If $iMin > 0 Then $sWaitTime &= $iMin & "m"

					SetLog("Current upgrade will finish in " & $bRemainingUpTimeOCR)

					$sWaitTime = ""
					$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
					If $iDay > 0 Then
						$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
					Else
						$iHour = Floor(Floor($iWaitSec / 60 / 60))
					EndIf
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iDay = 1 Then $sWaitTime &= $iDay & " day "
					If $iDay > 1 Then $sWaitTime &= $iDay & " days "
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				EndIf

				Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $bUnderTime[$g_iCurAccount] = True Then $bUnderTime[$g_iCurAccount] = False
				ExitLoop
			Else
				If $iRemainingTime > 0 Then
					$iWaitTime = $iRemainingTime * 60 * 1000
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					Switch $bXMultiplier
						Case 1 To 3
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & $bXMultiplier & " Hour" & ($bXMultiplier > 1 ? "s)" : ")"))
						Case 4
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 1) & " Hours)")
						Case 5, 6
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 2) & " Hours)")
						Case 7, 8
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 3) & " Hours)")
					EndSwitch

					If $g_bChkAppBuilder = 1 Or ($g_bChkAppBuilder = 2 And $i = UBound($GreenAssignButtons) - 1) Then
						Local $StartTime = _NowCalc() ; what is date:time now
						$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iRemainingTime), $StartTime)
						SetLog("Builder's Apprentice next check @ " & $g_sAvailableAppBuilder)
						$bUnderTime[$g_iCurAccount] = True
					Else
						SetLog("Check next upgrade...", $COLOR_INFO)
						If _Sleep(1000) Then Return
						ContinueLoop
					EndIf
				Else
					$g_sAvailableAppBuilder = 0
					$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				EndIf
				CloseWindow()
				Return
			EndIf
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			If $iAppBuilderAvailTime > 60 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		Else
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			If $iAppBuilderAvailTime > 1380 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		EndIf
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iAppBuilderAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				_LogHelperHutCooldown($sWaitTime, $g_sAvailableAppBuilder)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		CloseWindow()
		Return
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 470 + $g_iMidOffsetY, 520, 530 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iAppBuilderAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [480 + $g_iMidOffsetY, 520 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Builder's Apprentice Assigned", $COLOR_ACTION)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			$iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			If $iAppBuilderAvailTime > 60 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
			$iAppBuilderAvailTime += 1320
			SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		EndIf
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				_LogHelperHutCooldown($sWaitTime, $g_sAvailableAppBuilder)

			EndIf
		Else
			SetLog("Error processing time read!", $COLOR_WARNING)
			$g_sAvailableAppBuilder = 0
			$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
		EndIf
	Else
		WaitForClanMessage("BuildersApprenticeConfirm")
		CloseWindow2(1) ; Close If a window is open
		If _Sleep(1000) Then Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	CloseWindow()
EndFunc   ;==>AppBuilder

Func LabAssistant()

	If $g_iTownHallLevel < 9 Then
		Return
	EndIf

	If _DateIsValid($g_sLabUpgradeTime) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
		If $iLabTime <= 20 Then Return     ; Less than 20 min -> Return
	EndIf

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[$g_iSwitchAccMaxAccounts]
	Local Static $bUnderTime[$g_iSwitchAccMaxAccounts]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bUnderTime[$g_iCurAccount] = False
	EndIf

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec, $iDay

	If _DateIsValid($g_sAvailableLabAssistant) Then
		$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffLabAssistant > 0 Then

			$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $bUnderTime[$g_iCurAccount] = True Then
				SetLog("Current upgrade time too small", $COLOR_DEBUG1)
				SetLog("Next check in " & $sWaitTime, $COLOR_ACTION)
			Else
				_LogHelperHutCooldown($sWaitTime, $g_sAvailableLabAssistant)
			EndIf
			Return
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableLabAssistant) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc())     ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then Return
		EndIf
	EndIf

	If Not _OpenHelperHut() Then Return

	Local $LabAssist = FindButton("LabAssist")
	If IsArray($LabAssist) And UBound($LabAssist) = 2 Then
		Click($LabAssist[0], 545 + $g_iBottomOffsetY)
		If _Sleep(Random(1500, 2000, 1)) Then Return
	Else
		ClearScreen()
		Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	If Not _IsHelperHutAssistantOpen() Then
		SetLog("Lab Assistant window didn't open", $COLOR_DEBUG1)
		CloseWindow2()
		If _Sleep(Random(1500, 2000, 1)) Then Return
		ClearScreen()
		Return
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	WaitForClanMessage("BuildersApprenticeMid")
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 730, 520 + $g_iMidOffsetY, 815, 560 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Lab Assistant is Locked", $COLOR_ERROR)
		CloseWindow()
		Return
	EndIf

	Local $sLevelOCR = _ReadHelperHutLevelOCR()
	Local $bXMultiplier = Number(StringRegExpReplace($sLevelOCR, "[^0-9]", ""))
	If $bXMultiplier = "" Or $bXMultiplier < 1 Or $bXMultiplier > 12 Then $bXMultiplier = 1 ; In Case
	SetLog("Lab Assistant Level: " & $bXMultiplier, $COLOR_INFO)

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniLabAssistHead", $g_sImgMiniLabAssistHead, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY, True)) ; Recurrence
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	Local $GreenAssignButtons = _FindLabAssistantAssignButtons()
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		If $g_bChkLabAssistant = 1 Then
			_ArraySort($GreenAssignButtons, 0, 0, 0, 2)
		Else
			_ArraySort($GreenAssignButtons, 1, 0, 0, 2)
		EndIf
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 4, 114, 16, True)
			Local $iRemainingTime = ConvertOCRTime("Upgrade Time", $bRemainingUpTimeOCR, False)
			SetDebugLog("Remaining Up OCR Time = " & $bRemainingUpTimeOCR & ", $iRemainingTime = " & $iRemainingTime & " m", $COLOR_INFO)
			Local $bBAGranted = False
			Switch $bXMultiplier
				Case 1 To 3
					If $iRemainingTime > $bXMultiplier * 60 Then $bBAGranted = True
				Case 4
					If $iRemainingTime > ($bXMultiplier - 1) * 60 Then $bBAGranted = True
				Case 5, 6
					If $iRemainingTime > ($bXMultiplier - 2) * 60 Then $bBAGranted = True
				Case 7 To 10
					If $iRemainingTime > ($bXMultiplier - 3) * 60 Then $bBAGranted = True
				Case 11, 12
					If $iRemainingTime > ($bXMultiplier - 4) * 60 Then $bBAGranted = True
			EndSwitch
			If $iRemainingTime = 0 Then $bBAGranted = True ; In Case
			If $bBAGranted Then
				If $iRemainingTime > 0 Then
					; Must be in ms !
					If $iRemainingTime > $bXMultiplier * 60 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
					EndIf
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
					If $iDay > 0 Then
						$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
					Else
						$iHour = Floor(Floor($iWaitSec / 60 / 60))
					EndIf
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iDay = 1 Then $sWaitTime &= $iDay & " day "
					If $iDay > 1 Then $sWaitTime &= $iDay & " days "
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					SetLog("Current upgrade will finish in " & $bRemainingUpTimeOCR)
					$bLabAssistantUsedTime = _NowCalc()
				EndIf

				Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $bUnderTime[$g_iCurAccount] = True Then $bUnderTime[$g_iCurAccount] = False
				ExitLoop
			Else
				If $iRemainingTime > 0 Then
					$iWaitTime = $iRemainingTime * 60 * 1000
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					Switch $bXMultiplier
						Case 1 To 3
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & $bXMultiplier & " Hour" & ($bXMultiplier > 1 ? "s)" : ")"))
						Case 4
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 1) & " Hours)")
						Case 5, 6
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 2) & " Hours)")
						Case 7 To 10
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 3) & " Hours)")
						Case 11, 12
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 4) & " Hours)")
					EndSwitch

					If $g_bChkLabAssistant = 1 Or ($g_bChkLabAssistant = 2 And $i = UBound($GreenAssignButtons) - 1) Then
						Local $StartTime = _NowCalc() ; what is date:time now
						$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iRemainingTime), $StartTime)
						SetLog("Assistant next check @ " & $g_sAvailableLabAssistant)
						$bUnderTime[$g_iCurAccount] = True
					Else
						SetLog("Check next upgrade...", $COLOR_INFO)
						If _Sleep(1000) Then Return
						ContinueLoop
					EndIf
				Else
					$g_sAvailableLabAssistant = 0
					$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				EndIf
				CloseWindow()
				Return
			EndIf
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			If $iLabAssistantAvailTime > 60 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		Else
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			If $iLabAssistantAvailTime > 1380 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
		EndIf
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iLabAssistantAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iLabAssistantAvailTime = " & $iLabAssistantAvailTime & " m", $COLOR_INFO)
		If $iLabAssistantAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iLabAssistantAvailTime), $StartTime)
			$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffLabAssistant > 0 Then

				$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				_LogHelperHutCooldown($sWaitTime, $g_sAvailableLabAssistant)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		CloseWindow()
		Return
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 470 + $g_iMidOffsetY, 520, 530 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iLabAssistantAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [480 + $g_iMidOffsetY, 520 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Lab Assistant Assigned", $COLOR_ACTION)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			$iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			If $iLabAssistantAvailTime > 60 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				CloseWindow()
				Return
			EndIf
			$iLabAssistantAvailTime += 1320
			SetDebugLog("Available OCR Time = " & $Result & ", $iLabAssistantAvailTime = " & $iLabAssistantAvailTime & " m", $COLOR_INFO)
		EndIf
		If $iLabAssistantAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iLabAssistantAvailTime), $StartTime)
			$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffLabAssistant > 0 Then

				$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				_LogHelperHutCooldown($sWaitTime, $g_sAvailableLabAssistant)

			EndIf
		Else
			SetLog("Error processing time read!", $COLOR_WARNING)
			$g_sAvailableLabAssistant = 0
			$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
		EndIf
	Else
		WaitForClanMessage("BuildersApprenticeConfirm")
		CloseWindow2(1) ; Close If a window is open
		If _Sleep(1000) Then Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	CloseWindow()
EndFunc   ;==>LabAssistant

Func _HelperHutBoth()

	If $g_iTownHallLevel < 9 Then
		Return
	EndIf

	Local $iLabCooldown = _DateIsValid($g_sAvailableLabAssistant) ? _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) : 0
	Local $iBuilderCooldown = _DateIsValid($g_sAvailableAppBuilder) ? _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) : 0
	If $iLabCooldown > 0 And $iBuilderCooldown > 0 Then
		Local $aiCooldown[2] = [$iLabCooldown, $iBuilderCooldown]
		Local $sWaitTime, $iWaitSec, $iHour, $iMin
		For $iAssistant = 0 To 1
			$iWaitSec = $aiCooldown[$iAssistant] * 60
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			$sWaitTime = ""
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "
			If $iAssistant = 0 Then
				SetLog("Lab Assistant Unavailable", $COLOR_DEBUG)
				SetLog("Will be available in " & $sWaitTime)
				SetLog("Available at " & $g_sAvailableLabAssistant)
			Else
				SetLog("Builder's Apprentice Unavailable", $COLOR_DEBUG)
				SetLog("Will be available in " & $sWaitTime)
				SetLog("Available at " & $g_sAvailableAppBuilder)
			EndIf
		Next
		Return
	EndIf

	Local $sOpenedTab = ""
	If Not _OpenHelperHutAssistant("LabAssist", $sOpenedTab, False) Then Return

	If _Sleep(500) Then Return
	If Not $g_bRunState Then Return

	If $sOpenedTab <> "LabAssist" Then
		If Not _SelectHelperHutTab("LabAssist") Then
			CloseWindow()
			Return
		EndIf
	EndIf
	HelperHutLab(True, True)
	If Not $g_bRunState Then Return
	If Not _SelectHelperHutTab("BuildersApp") Then
		CloseWindow()
		Return
	EndIf
	HelperHutApp(True, True, True)
	If $g_bRunState And Not IsMainPage(1) Then CloseWindow()
EndFunc   ;==>_HelperHutBoth

Func HelperHutLab($bCurrentTab = False, $bKeepWindowOpen = False)

	If _DateIsValid($g_sLabUpgradeTime) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
		If $iLabTime <= 20 Then Return True ; Less than 20 min -> Return
	EndIf

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[$g_iSwitchAccMaxAccounts]
	Local Static $bUnderTime[$g_iSwitchAccMaxAccounts]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bUnderTime[$g_iCurAccount] = False
	EndIf

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec, $iDay

	If _DateIsValid($g_sAvailableLabAssistant) Then
		$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffLabAssistant > 0 Then

			$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $bUnderTime[$g_iCurAccount] = True Then
				SetLog("Current upgrade time too small", $COLOR_DEBUG1)
				SetLog("Next check in " & $sWaitTime, $COLOR_ACTION)
			Else
				SetLog("Lab Assistant Unavailable", $COLOR_INFO)
				_LogHelperHutCooldown($sWaitTime, $g_sAvailableLabAssistant)
			EndIf
			Return True
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableLabAssistant) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc())     ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then Return True
		EndIf
	EndIf

	Local $bHelperHutWindowOpen = $bCurrentTab Or _IsHelperHutAssistantOpen()
	If $bHelperHutWindowOpen Then
		If Not $bCurrentTab Then
			If Not _SelectHelperHutTab("LabAssist") Then Return True
		EndIf
	Else
		Local $sOpenedTab = ""
		If Not _OpenHelperHutAssistant("LabAssist", $sOpenedTab) Then
			SetLog("Lab Assistant window didn't open", $COLOR_DEBUG1)
			Return True
		EndIf
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	WaitForClanMessage("BuildersApprenticeMid")
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 730, 520 + $g_iMidOffsetY, 815, 560 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Lab Assistant is Locked", $COLOR_ERROR)
		Return False
	EndIf

	Local $sLevelOCR = _ReadHelperHutLevelOCR()
	Local $bXMultiplier = Number(StringRegExpReplace($sLevelOCR, "[^0-9]", ""))
	If $bXMultiplier = "" Or $bXMultiplier < 1 Or $bXMultiplier > 12 Then $bXMultiplier = 1 ; In Case
	SetLog("Lab Assistant Level: " & $bXMultiplier, $COLOR_INFO)

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniLabAssistHead", $g_sImgMiniLabAssistHead, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY, True)) ; Recurrence
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	Local $GreenAssignButtons = _FindLabAssistantAssignButtons()
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		If $g_bChkLabAssistant = 1 Then
			_ArraySort($GreenAssignButtons, 0, 0, 0, 2)
		Else
			_ArraySort($GreenAssignButtons, 1, 0, 0, 2)
		EndIf
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 4, 114, 16, True)
			Local $iRemainingTime = ConvertOCRTime("Upgrade Time", $bRemainingUpTimeOCR, False)
			SetDebugLog("Remaining Up OCR Time = " & $bRemainingUpTimeOCR & ", $iRemainingTime = " & $iRemainingTime & " m", $COLOR_INFO)
			Local $bBAGranted = False
			Switch $bXMultiplier
				Case 1 To 3
					If $iRemainingTime > $bXMultiplier * 60 Then $bBAGranted = True
				Case 4
					If $iRemainingTime > ($bXMultiplier - 1) * 60 Then $bBAGranted = True
				Case 5, 6
					If $iRemainingTime > ($bXMultiplier - 2) * 60 Then $bBAGranted = True
				Case 7 To 10
					If $iRemainingTime > ($bXMultiplier - 3) * 60 Then $bBAGranted = True
				Case 11, 12
					If $iRemainingTime > ($bXMultiplier - 4) * 60 Then $bBAGranted = True
			EndSwitch
			If $iRemainingTime = 0 Then $bBAGranted = True ; In Case
			If $bBAGranted Then
				If $iRemainingTime > 0 Then
					; Must be in ms !
					If $iRemainingTime > $bXMultiplier * 60 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
					EndIf
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
					If $iDay > 0 Then
						$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
					Else
						$iHour = Floor(Floor($iWaitSec / 60 / 60))
					EndIf
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iDay = 1 Then $sWaitTime &= $iDay & " day "
					If $iDay > 1 Then $sWaitTime &= $iDay & " days "
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					SetLog("Current upgrade will finish in " & $bRemainingUpTimeOCR)
					$bLabAssistantUsedTime = _NowCalc()
				EndIf

				Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $bUnderTime[$g_iCurAccount] = True Then $bUnderTime[$g_iCurAccount] = False
				ExitLoop
			Else
				If $iRemainingTime > 0 Then
					$iWaitTime = $iRemainingTime * 60 * 1000
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					Switch $bXMultiplier
						Case 1 To 3
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & $bXMultiplier & " Hour" & ($bXMultiplier > 1 ? "s)" : ")"))
						Case 4
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 1) & " Hours)")
						Case 5, 6
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 2) & " Hours)")
						Case 7 To 10
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 3) & " Hours)")
						Case 11, 12
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 4) & " Hours)")
					EndSwitch

					If $g_bChkLabAssistant = 1 Or ($g_bChkLabAssistant = 2 And $i = UBound($GreenAssignButtons) - 1) Then
						Local $StartTime = _NowCalc() ; what is date:time now
						$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iRemainingTime), $StartTime)
						SetLog("Assistant next check @ " & $g_sAvailableLabAssistant)
						$bUnderTime[$g_iCurAccount] = True
					Else
						SetLog("Check next upgrade...", $COLOR_INFO)
						If _Sleep(1000) Then Return
						ContinueLoop
					EndIf
				Else
					$g_sAvailableLabAssistant = 0
					$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				EndIf
				Return False
			EndIf
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			If $iLabAssistantAvailTime > 60 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				Return False
			EndIf
		Else
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			If $iLabAssistantAvailTime > 1380 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				Return False
			EndIf
		EndIf
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iLabAssistantAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iLabAssistantAvailTime = " & $iLabAssistantAvailTime & " m", $COLOR_INFO)
		If $iLabAssistantAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iLabAssistantAvailTime), $StartTime)
			$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffLabAssistant > 0 Then

				$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				_LogHelperHutCooldown($sWaitTime, $g_sAvailableLabAssistant)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		Return False
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 470 + $g_iMidOffsetY, 520, 530 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iLabAssistantAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [480 + $g_iMidOffsetY, 520 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Lab Assistant Assigned", $COLOR_ACTION)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			$iLabAssistantAvailTime = ConvertOCRTime("LabAssist Time", $Result, False)
			If $iLabAssistantAvailTime > 60 Then
				$g_sAvailableLabAssistant = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				Return False
			EndIf
			$iLabAssistantAvailTime += 1320
			SetDebugLog("Available OCR Time = " & $Result & ", $iLabAssistantAvailTime = " & $iLabAssistantAvailTime & " m", $COLOR_INFO)
		EndIf
		If $iLabAssistantAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableLabAssistant = _DateAdd('n', Ceiling($iLabAssistantAvailTime), $StartTime)
			$TimeDiffLabAssistant = _DateDiff('n', _NowCalc(), $g_sAvailableLabAssistant) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffLabAssistant > 0 Then

				$iWaitTime = $TimeDiffLabAssistant * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				_LogHelperHutCooldown($sWaitTime, $g_sAvailableLabAssistant)

			EndIf
		Else
			SetLog("Error processing time read!", $COLOR_WARNING)
			$g_sAvailableLabAssistant = 0
			$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
		EndIf
	Else
		If $bKeepWindowOpen Then Return True
		WaitForClanMessage("BuildersApprenticeConfirm")
		CloseWindow2(1) ; Close If a window is open
		If _Sleep(1000) Then Return True
		Return Not _IsHelperHutAssistantOpen()
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
EndFunc   ;==>HelperHutLab

Func HelperHutApp($bToOpen = False, $bCurrentTab = False, $bKeepWindowOpen = False)

	If $g_iTownHallLevel < 10 Then
		If Not $bToOpen And Not $bKeepWindowOpen Then CloseWindow()
		Return
	EndIf

	If Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[$g_iSwitchAccMaxAccounts]
	Local Static $bUnderTime[$g_iSwitchAccMaxAccounts]
	If $g_bFirstStart Then
		$iLastTimeChecked[$g_iCurAccount] = ""
		$bUnderTime[$g_iCurAccount] = False
	EndIf

	Local $iWaitTime = 0
	Local $sWaitTime = ""
	Local $iMin, $iHour, $iWaitSec, $iDay

	If _DateIsValid($g_sAvailableAppBuilder) Then
		$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder)
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
		If $TimeDiffAppBuilder > 0 Then

			$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
			$sWaitTime = ""

			$iWaitSec = Round($iWaitTime / 1000)
			$iHour = Floor(Floor($iWaitSec / 60) / 60)
			$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
			If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
			If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

			If $bUnderTime[$g_iCurAccount] = True Then
				SetLog("Current upgrade time too small", $COLOR_DEBUG1)
				SetLog("Next check in " & $sWaitTime, $COLOR_ACTION)
			Else
				SetLog("Builder's Apprentice Unavailable", $COLOR_INFO)
				_LogHelperHutCooldown($sWaitTime, $g_sAvailableAppBuilder)
			EndIf
			If Not $bToOpen And Not $bKeepWindowOpen Then CloseWindow()
			Return
		EndIf
	Else
		If Not _DateIsValid($g_sAvailableAppBuilder) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
			Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
			SetDebugLog("Builder's App LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
			; A check each from 2 to 4 hours [2*60 = 120 to 4*60 = 240]
			Local $iDelayToCheck = Random(120, 240, 1)
			If $iLastCheck <= $iDelayToCheck Then
				If Not $bToOpen And Not $bKeepWindowOpen Then CloseWindow()
				Return
			EndIf
		EndIf
	EndIf

	Local $bHelperHutWindowOpen = $bCurrentTab Or _IsHelperHutAssistantOpen()
	If Not $bHelperHutWindowOpen Then
		Local $sOpenedTab = ""
		If Not _OpenHelperHutAssistant("BuildersApp", $sOpenedTab) Then
			SetLog("Builder's Apprentice Window Didn't Open", $COLOR_DEBUG1)
			If Not $bKeepWindowOpen Then CloseWindow()
			Return
		EndIf
	Else
		If Not $bCurrentTab Then
			If Not _SelectHelperHutTab("BuildersApp") Then Return
		EndIf
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	WaitForClanMessage("BuildersApprenticeMid")
	Local $aiLocked = decodeSingleCoord(FindImageInPlace2("Locked", $ImgLocked, 730, 520 + $g_iMidOffsetY, 815, 560 + $g_iMidOffsetY, True))
	If IsArray($aiLocked) And UBound($aiLocked) = 2 Then
		SetLog("Builder's Apprentice is Locked", $COLOR_ERROR)
		If Not $bKeepWindowOpen Then CloseWindow()
		Return
	EndIf

	Local $sLevelOCR = _ReadHelperHutLevelOCR()
	Local $bXMultiplier = Number(StringRegExpReplace($sLevelOCR, "[^0-9]", ""))
	If $bXMultiplier < 1 Or $bXMultiplier > 8 Then
		SetLog("Builder's Apprentice level OCR failed; using conservative level 1", $COLOR_WARNING)
		$bXMultiplier = 1
	Else
		SetLog("Builder's Apprentice Level: " & $bXMultiplier, $COLOR_INFO)
	EndIf
	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	WaitForClanMessage("BuildersApprenticeMid")

	Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniBuilderApp", $g_sImgMiniBuilderAppHead, 45, 510 + $g_iMidOffsetY, 390, 610 + $g_iMidOffsetY, True))
	If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
		ClickP($MiniHead)
		If _Sleep(1000) Then Return
		Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
		If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
			ClickP($aConfirmButton)
			If _Sleep(1000) Then Return
		Else
			Click(530, 415 + $g_iMidOffsetY)
			If _Sleep(1000) Then Return
		EndIf
	EndIf

	If $g_bChkAppBuilder = 2 Then MoveToBottom()

	WaitForClanMessage("BuildersApprenticeMid")

	Local $GreenAssignButtons = QuickMIS("CNX", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY)
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then
		If $g_bChkAppBuilder = 1 Then
			_ArraySort($GreenAssignButtons, 0, 0, 0, 2)
		Else
			_ArraySort($GreenAssignButtons, 1, 0, 0, 2)
		EndIf
		For $i = 0 To UBound($GreenAssignButtons) - 1
			Local $bRemainingUpTimeOCR = getOcrAndCapture("coc-BAUpgradeTime", $GreenAssignButtons[$i][1] - 166, $GreenAssignButtons[$i][2] - 4, 114, 16, True)
			Local $iRemainingTime = ConvertOCRTime("Upgrade Time", $bRemainingUpTimeOCR, False)
			SetDebugLog("Remaining Up OCR Time = " & $bRemainingUpTimeOCR & ", $iRemainingTime = " & $iRemainingTime & " m", $COLOR_INFO) ; 460
			Local $bBAGranted = False
			Switch $bXMultiplier
				Case 1 To 3
					If $iRemainingTime > $bXMultiplier * 60 Then $bBAGranted = True
				Case 4
					If $iRemainingTime > ($bXMultiplier - 1) * 60 Then $bBAGranted = True
				Case 5, 6
					If $iRemainingTime > ($bXMultiplier - 2) * 60 Then $bBAGranted = True
				Case 7, 8
					If $iRemainingTime > ($bXMultiplier - 3) * 60 Then $bBAGranted = True
			EndSwitch
			If $iRemainingTime = 0 Then $bBAGranted = True ; In Case
			If $bBAGranted Then
				If $iRemainingTime > 0 Then
					; Must be in ms !
					If $iRemainingTime > $bXMultiplier * 60 Then
						$iWaitTime = ($iRemainingTime - (60 * $bXMultiplier)) * 60 * 1000
					Else
						$iWaitTime = ($iRemainingTime / $bXMultiplier) * 60 * 1000
					EndIf
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iDay = Floor(Mod(Floor($iWaitSec / 60 / 60 / 24), 24))
					If $iDay > 0 Then
						$iHour = Floor(Floor(($iWaitSec / 60) - ($iDay * 1440)) / 60)
					Else
						$iHour = Floor(Floor($iWaitSec / 60 / 60))
					EndIf
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iDay = 1 Then $sWaitTime &= $iDay & " day "
					If $iDay > 1 Then $sWaitTime &= $iDay & " days "
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					SetLog("Current upgrade will finish in " & $bRemainingUpTimeOCR)

				EndIf

				Click($GreenAssignButtons[$i][1], $GreenAssignButtons[$i][2]) ;Click Assign
				If _Sleep(Random(1500, 2000, 1)) Then Return
				If $bUnderTime[$g_iCurAccount] = True Then $bUnderTime[$g_iCurAccount] = False
				ExitLoop
			Else
				If $iRemainingTime > 0 Then
					$iWaitTime = $iRemainingTime * 60 * 1000
					$sWaitTime = ""

					$iWaitSec = Round($iWaitTime / 1000)
					$iHour = Floor(Floor($iWaitSec / 60) / 60)
					$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
					If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
					If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

					Switch $bXMultiplier
						Case 1 To 3
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & $bXMultiplier & " Hour" & ($bXMultiplier > 1 ? "s)" : ")"))
						Case 4
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 1) & " Hours)")
						Case 5, 6
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 2) & " Hours)")
						Case 7, 8
							SetLog("Current upgrade will finish in " & $sWaitTime & " (Less Than " & ($bXMultiplier - 3) & " Hours)")
					EndSwitch

					If $g_bChkAppBuilder = 1 Or ($g_bChkAppBuilder = 2 And $i = UBound($GreenAssignButtons) - 1) Then
						Local $StartTime = _NowCalc() ; what is date:time now
						$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iRemainingTime), $StartTime)
						SetLog("Builder's Apprentice next check @ " & $g_sAvailableAppBuilder)
						$bUnderTime[$g_iCurAccount] = True
					Else
						SetLog("Check next upgrade...", $COLOR_INFO)
						If _Sleep(1000) Then Return
						ContinueLoop
					EndIf
				Else
					$g_sAvailableAppBuilder = 0
					$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				EndIf
				If Not $bKeepWindowOpen Then CloseWindow()
				Return
			EndIf
		Next
	Else
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			If $iAppBuilderAvailTime > 60 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				If Not $bKeepWindowOpen Then CloseWindow()
				Return
			EndIf
		Else
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			Local $iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			If $iAppBuilderAvailTime > 1380 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				If Not $bKeepWindowOpen Then CloseWindow()
				Return
			EndIf
		EndIf
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then $iAppBuilderAvailTime += 1320
		SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				_LogHelperHutCooldown($sWaitTime, $g_sAvailableAppBuilder)

			EndIf
		Else
			SetLog("No upgrade in progress", $COLOR_INFO)
		EndIf
		If Not $bKeepWindowOpen Then CloseWindow()
		Return
	EndIf

	Local $aConfirmButton = decodeSingleCoord(FindImageInPlace2("ConfirmButton", $ImgConfirmButton, 360, 470 + $g_iMidOffsetY, 520, 530 + $g_iMidOffsetY, True))
	If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
		Local $iAppBuilderAvailTime = 0
		Local $CoordsX[2] = [390, 480]
		Local $CoordsY[2] = [480 + $g_iMidOffsetY, 520 + $g_iMidOffsetY]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 180, "ConfirmButton") ;Click Confirm
		SetLog("Builder's Apprentice Assigned", $COLOR_ACTION)
		If _Sleep(Random(2000, 2500, 1)) Then Return
		WaitForClanMessage("BuildersApprenticeMid")
		Local $aiJobinProgress = decodeSingleCoord(FindImageInPlace2("JobInProgress", $ImgJobInProgress, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))
		If IsArray($aiJobinProgress) And UBound($aiJobinProgress) = 2 Then
			Local $Result = getBldgUpgradeTime(715, 545 + $g_iMidOffsetY)
			If $g_bDebugImageSave Then SaveDebugImage($Result & "_", Default, False)
			SetLog("Job In Progress", $COLOR_SUCCESS)
			$iAppBuilderAvailTime = ConvertOCRTime("BuildersApp Time", $Result, False)
			If $iAppBuilderAvailTime > 60 Then
				$g_sAvailableAppBuilder = 0
				$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
				SetLog("Error processing time read!", $COLOR_WARNING)
				WaitForClanMessage("BuildersApprenticeTop")
				If Not $bKeepWindowOpen Then CloseWindow()
				Return
			EndIf
			$iAppBuilderAvailTime += 1320
			SetDebugLog("Available OCR Time = " & $Result & ", $iAppBuilderAvailTime = " & $iAppBuilderAvailTime & " m", $COLOR_INFO)
		EndIf
		If $iAppBuilderAvailTime > 0 Then
			Local $StartTime = _NowCalc() ; what is date:time now
			$g_sAvailableAppBuilder = _DateAdd('n', Ceiling($iAppBuilderAvailTime), $StartTime)
			$TimeDiffAppBuilder = _DateDiff('n', _NowCalc(), $g_sAvailableAppBuilder) ; what is difference between end time and now in minutes?
			If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
			If $TimeDiffAppBuilder > 0 Then

				$iWaitTime = $TimeDiffAppBuilder * 60 * 1000
				$sWaitTime = ""

				$iWaitSec = Round($iWaitTime / 1000)
				$iHour = Floor(Floor($iWaitSec / 60) / 60)
				$iMin = Floor(Mod(Floor($iWaitSec / 60), 60))
				If $iHour > 0 Then $sWaitTime &= $iHour & " hours "
				If $iMin > 0 Then $sWaitTime &= $iMin & " minutes "

				_LogHelperHutCooldown($sWaitTime, $g_sAvailableAppBuilder)

			EndIf
		Else
			SetLog("Error processing time read!", $COLOR_WARNING)
			$g_sAvailableAppBuilder = 0
			$iLastTimeChecked[$g_iCurAccount] = "" ; Check Again Next Loop
		EndIf
	Else
		WaitForClanMessage("BuildersApprenticeConfirm")
		If Not $bKeepWindowOpen Then CloseWindow2(1)
		If _Sleep(1000) Then Return
	EndIf

	WaitForClanMessage("BuildersApprenticeTop")
	If Not $bKeepWindowOpen Then CloseWindow()
EndFunc   ;==>HelperHutApp

Func _FindLabAssistantAssignButtons()
	Local $GreenAssignButtons = QuickMIS("CNX", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 500 + $g_iMidOffsetY)
	If IsArray($GreenAssignButtons) And UBound($GreenAssignButtons) > 0 And UBound($GreenAssignButtons, $UBOUND_COLUMNS) > 1 Then Return $GreenAssignButtons

	Local $aGreenPixel = _PixelSearch(720, 290 + $g_iMidOffsetY, 815, 500 + $g_iMidOffsetY, Hex(0x8DDF2F, 6), 45, True)
	If Not IsArray($aGreenPixel) Or UBound($aGreenPixel) < 2 Then Return $GreenAssignButtons

	Local $aFallbackButtons[0][4]
	_ArrayAdd($aFallbackButtons, "Assign|" & $aGreenPixel[0] & "|" & $aGreenPixel[1] & "|0")
	SetDebugLog("Lab Assistant Assign fallback found at " & $aGreenPixel[0] & "," & $aGreenPixel[1], $COLOR_DEBUG1)
	Return $aFallbackButtons
EndFunc   ;==>_FindLabAssistantAssignButtons

Func MoveToBottom()

	If Not QuickMIS("BC1", $g_sImgGreenAssignButton, 690, 230 + $g_iMidOffsetY, 840, 320 + $g_iMidOffsetY) Then Return

	Local $aiPassMini = False, $bFirstLoop = 0
	While 1
		If UBound(decodeSingleCoord(FindImageInPlace2("Assign", $ImgAssignMini, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))) = 2 Then
			$aiPassMini = True
			ExitLoop
		Else
			If UBound(decodeSingleCoord(FindImageInPlace2("OnGoing", $ImgOnGoingMini, 390, 220 + $g_iMidOffsetY, 490, 280 + $g_iMidOffsetY, True))) = 2 Then
				$aiPassMini = True
				ExitLoop
			Else
				If _Sleep(100) Then ExitLoop
			EndIf
		EndIf
		If $bFirstLoop = 20 Then ExitLoop
		$bFirstLoop += 1
	WEnd

	If $aiPassMini Then

		Local $aiWhitePixelSearchOutline = False, $bSecondLoop = 0
		While 1
			If IsArray(_PixelSearch(190, 482 + $g_iMidOffsetY, 194, 492 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
				$aiWhitePixelSearchOutline = True
				ExitLoop
			Else
				If _Sleep(100) Then ExitLoop
			EndIf
			If $bSecondLoop = 20 Then ExitLoop
			$bSecondLoop += 1
		WEnd

		If $aiWhitePixelSearchOutline Then

			Local $aiWhitePixelSearchArrow = False, $bThirdLoop = 0
			While 1
				If IsArray(_PixelSearch(610, 482 + $g_iMidOffsetY, 625, 498 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
					$aiWhitePixelSearchArrow = True
					ExitLoop
				Else
					If _Sleep(100) Then ExitLoop
				EndIf
				If $bThirdLoop = 25 Then ExitLoop
				$bThirdLoop += 1
			WEnd

			If $aiWhitePixelSearchArrow Then

				ClickDrag(Random(500, 680, 1), Random(460, 480, 1), Random(500, 680, 1), Random(350, 370, 1), 200)
				If _Sleep(Random(2000, 2500, 1)) Then Return

				Local $MiniHead = decodeSingleCoord(FindImageInPlace2("MiniBuilderApp", $g_sImgMiniBuilderAppHead, 45, 510 + $g_iMidOffsetY, 390, 610 + $g_iMidOffsetY, True))
				If IsArray($MiniHead) And UBound($MiniHead) = 2 Then
					ClickP($MiniHead)
					If _Sleep(1000) Then Return
					Local $aConfirmButton = findButton("ConfirmButton", Default, 1, True)
					If IsArray($aConfirmButton) And UBound($aConfirmButton) = 2 Then
						ClickP($aConfirmButton)
						If _Sleep(1000) Then Return
					Else
						Click(530, 415 + $g_iMidOffsetY)
						If _Sleep(1000) Then Return
					EndIf
				EndIf

			EndIf

		EndIf

	EndIf

EndFunc   ;==>MoveToBottom
