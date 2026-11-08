; #FUNCTION# ====================================================================================================================
; Name ..........: PetHouse
; Description ...: Upgrade Pets
; Author ........: GrumpyHog (2021-04)
; Modified ......: Moebius (09/2024)
; Remarks .......: This file is part of MyBot Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Returns True or False
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......:
; ===============================================================================================================================
; PetHouse()             - Normal Status + Upgrade Flow
; PetHouse(False, True)  - Status/GUI Check Only

Func _UPT_GetPetCardX($iPet)
	Local $iStartX = ($iPet >= 8 ? 85 : 40)
	Local $iSearchX = $iStartX + (Mod($iPet, 4) * 182)
	Local $aBlackBorder = _MultiPixelSearch2($iSearchX, 500 + $g_iMidOffsetY, $iSearchX + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
	If Not IsArray($aBlackBorder) Then Return -1
	Return $aBlackBorder[0] + 10
EndFunc   ;==>_UPT_GetPetCardX

Func _UPT_GetPetUpgradeState($iPet, $iCardX, $bUpgradeRunning, ByRef $iCostOCR, $bReadOCR = False)
	$iCostOCR = 0
	If $iCardX < 0 Then Return "Unknown"

	Local $sCardColor = _GetPixelColor($iCardX, 380 + $g_iMidOffsetY, True)
	If _ColorCheck($sCardColor, Hex(0xC8BEAD, 6), 15) Then
		Local $iPetLevel = getPetsLevel($iCardX, 544 + $g_iMidOffsetY)
		If $iPetLevel < 1 Or $iPetLevel > $g_aiPetMaxLevels[$iPet] Then Return "Unknown"
		If $iPetLevel >= $g_aiPetMaxLevels[$iPet] Then Return "Max Level"
		If $bUpgradeRunning Then Return "Unavailable"

		Local $iCost = 0
		If $bReadOCR Then $iCostOCR = _UPT_OpenPetAndReadCost($iCardX)
		$iCost = $iCostOCR
		If $iCost <= 0 Then
			$iCost = 1000 * Number($g_aiPetUpgradeCostPerLevel[$iPet][$iPetLevel])
			$iCost = Int($iCost - ($iCost * Number($g_iBuilderBoostDiscount) / 100))
		EndIf

		If $iCost > Number($g_aiCurrentLoot[$eLootDarkElixir]) Then Return "Insufficient Resources"
		Return "Available"
	EndIf

	If _ColorCheck($sCardColor, Hex(0xB7B7B7, 6), 15) Then Return "Locked"
	Return "Unknown"
EndFunc   ;==>_UPT_GetPetUpgradeState

Func _UPT_OpenPetAndReadCost($iCardX)
	Click($iCardX + 67, 502 + $g_iMidOffsetY)
	If _Sleep(1500) Then Return 0

	Local $sCost = getCostsUpgrade(552, 541 + $g_iMidOffsetY)
	If $sCost = "" Then $sCost = getCostsUpgrade(552, 532 + $g_iMidOffsetY)
	If $sCost = "" Then $sCost = getCostsUpgradeRed(552, 541 + $g_iMidOffsetY)
	If $sCost = "" Then $sCost = getCostsUpgradeRed(552, 532 + $g_iMidOffsetY)

	CloseWindow() ; test only: never confirm the upgrade
	If _Sleep(500) Then Return 0

	Return Number(StringRegExpReplace($sCost, "[^0-9]", ""))
EndFunc   ;==>_UPT_OpenPetAndReadCost

Func _UPT_LogPetUpgradeState($sPetName, $sState)
	Local $iColor = $COLOR_DEBUG
	Switch $sState
		Case "Available", "Max Level"
			$iColor = $COLOR_SUCCESS
		Case "Running"
			$iColor = $COLOR_INFO
		Case "Unavailable", "Locked"
			$iColor = $COLOR_WARNING
		Case "Insufficient Resources"
			$iColor = $COLOR_DEBUG
	EndSwitch
	SetLog("[" & $sPetName & " Upgrade]: " & $sState, $iColor)
EndFunc   ;==>_UPT_LogPetUpgradeState

Func PetHouse($test = False, $bStatusOnly = False)
	If $g_iTownHallLevel < 14 Then
		SetLog("Town Hall level read as " & $g_iTownHallLevel & ", Pet House not available")
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		Return
	EndIf

	Local Static $iLastTimeChecked[$g_iSwitchAccMaxAccounts]
	If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""

	Local $bUpgradePets = False
	For $i = 0 To $ePetCount - 1
		If $g_bUpgradePetsEnable[$i] Then
			$bUpgradePets = True
			ExitLoop
		EndIf
	Next

	; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
	If _DateIsValid($g_sPetUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
		Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sPetUpgradeTime)
		Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Pet House PetUpgradeTime: " & $g_sPetUpgradeTime & ", Pet DateCalc: " & $iLabTime)
		SetDebugLog("Pet House LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each 6 hours [6*60 = 360] or when Lab research time finishes
		If $iLabTime > 0 And $iLastCheck <= 360 Then Return
	EndIf

	; not enough Dark Elixir for upgrade -
	If Not $bStatusOnly And Number($g_aiCurrentLoot[$eLootDarkElixir]) < Number($g_iMinDark4PetUpgrade) And Not _DateIsValid($g_sPetUpgradeTime) Then
		If Number($g_iMinDark4PetUpgrade) <> 999999 Then
			SetLog("Current DE Storage: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir], True))
			SetLog("Minimum DE for Pet upgrade: " & _NumberFormat($g_iMinDark4PetUpgrade, True))
			Return
		Else
			If _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
				Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
				; A check each from 3 to 4 hours [3*60 = 180 to 4*60 = 240] To check if new pet is available
				Local $iDelayToCheck = Random(180, 240, 1)
				If $iLastCheck <= $iDelayToCheck Then
					SetLog("No pets available for upgrade")
					Return
				EndIf
			EndIf
		EndIf
	EndIf

	ClearScreen()
	If _Sleep(1500) Then Return ; Delay AFTER the click Away Prevents lots of coc restarts

	SetLog("Checking Pet Status", $COLOR_INFO)
	Local $aiStatusSavedPetHousePos = $g_aiPetHousePos
	Local $bStatusPetHouseSelected = ImgLocatePetHouse(True, True)
	If Not $bStatusPetHouseSelected Then
		$g_aiPetHousePos = $aiStatusSavedPetHousePos
		If $g_aiPetHousePos[0] <= 0 Or $g_aiPetHousePos[1] <= 0 Then Return
		SetLog("Pet House Position: (" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & ")", $COLOR_SUCCESS)
	EndIf

	;=================Section 2 Lab Gui

	; If $g_bAutoLabUpgradeEnable = True Then  ====>>>> TODO : or use this or make a checkbox on GUI
	; make sure lab is located, if not locate lab
	If $g_aiPetHousePos[0] <= 0 Or $g_aiPetHousePos[1] <= 0 Then
		SetLog("Pet House Location is unknown!", $COLOR_ERROR)
		;============Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		Return
	EndIf

	If $g_bDebugSetLog Then SetDebugLog("Pet House (x,y): " & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1])

	If Not $bStatusPetHouseSelected Then
		BuildingClickP($g_aiPetHousePos, "#0197")
		If _Sleep(1500) Then Return
	EndIf
	; Find Research Button

	Local $aStatusBuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
	If IsArray($aStatusBuildingInfo) And UBound($aStatusBuildingInfo) > 0 Then
		SetLog("Pet House Level: " & $aStatusBuildingInfo[2], $COLOR_INFO)
	EndIf

	If Not FindPetsButton() Then
		ClearScreen()
		;===========Hide Red  Hide Green  Show Gray==
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;===========================================
		Return
	EndIf

	If Not IsPetHousePage() Then
		SetLog("Pet House Window did not open!", $COLOR_ERROR)
		Return
	EndIf

	$iLastTimeChecked[$g_iCurAccount] = _NowCalc()

	Local $IsRunning = False
	Local $IsStopped = False
	Local $bContinuePetUpgrade = False
	Local $iPage = 0

	For $i = 0 To 5
		If _IsPetUpgradeRunningGui() Then ; Look for green in the finish-upgrade area of the pet house window.
			$IsRunning = True
			ExitLoop
		EndIf
		If _IsPetUpgradeStoppedGui() Then ; Look for the idle paw in the Pet House window.
			$IsStopped = True
			ExitLoop
		EndIf
		If _Sleep(500) Then Return
	Next

	; check for upgrade in process - look for green in finish upgrade with gems button
	If $IsRunning Then ; Look for light green in upper right corner of lab window.
		SetLog("Status: Running")
		;==========Hide Red  Show Green Hide Gray===
		GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
		;===========================================
		If _Sleep($DELAYLABORATORY2) Then Return
		Local $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
		Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
		SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
		If $iPetFinishTime > 0 Then
			$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
			SetLog("Pet House will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
		EndIf
		$g_iMinDark4PetUpgrade = 0
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asPetLabUpgradeTime[$g_iCurAccount] = $g_sPetUpgradeTime for instantly displaying in multi-stats
		CloseWindow()
		Return False
	ElseIf $IsStopped Then ; Look for the paw in the Pet House window.
		SetLog("Status: Stopped")
		;If $g_bNotifyTGEnable And $g_bNotifyAlertLaboratoryIdle Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_01", "Laboratory Idle") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_02", "Laboratory has Stopped"))
		;========Show Red  Hide Green  Hide Gray=====
		GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;============================================
		$g_sPetUpgradeTime = ""
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asPetLabUpgradeTime[$g_iCurAccount] = $g_sPetUpgradeTime for instantly displaying in multi-stats

		; Keep the page reached by the status scan so the upgrade flow does not repeat unnecessary drags.
		$g_iMinDark4PetUpgrade = GetMinDark4PetUpgrade($aStatusBuildingInfo[2], $iPage)

		If $bStatusOnly Then
			CloseWindow()
			Return True
		EndIf

		; No enabled pet: status/GUI was updated, no upgrade flow is required.
		If Not $bUpgradePets Then
			CloseWindow()
			Return
		EndIf

		$bContinuePetUpgrade = True
	Else
		SetLog("Unable to determine Pet House Status", $COLOR_INFO)
		;========Hide Red  Hide Green  Show Gray======
		GUICtrlSetState($g_hPicPetGreen, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPetGray, $GUI_SHOW)
		GUICtrlSetData($g_hLbLPetTime, "")
		;=============================================
		CloseWindow()
		$iLastTimeChecked[$g_iCurAccount] = ""
		Return
	EndIf

	If Not $bContinuePetUpgrade Then Return


	; Normal Pet House upgrade flow - Pet House page is already open from status check
	If Not $g_bRunState Then Return

	Local $BuildingInfo = $aStatusBuildingInfo

	If Not IsArray($BuildingInfo) Or UBound($BuildingInfo) = 0 Then
		SetLog("Unable to read Pet House Level", $COLOR_ERROR)
		CloseWindow()
		Return False
	EndIf

	Local $iPetLevelxCoordStart = 40
	Local $iPetLevelxCoordStart2 = 85
	Local $iPetSlotWidth = 182

	For $i = 0 To $ePetCount - 1
		$g_ePetLevels[$i] = $g_aiPetMaxLevels[$i]
		; check if pet upgrade enabled
		If Not $g_bUpgradePetsEnable[$i] Then ContinueLoop

		Local $iPetIndex = $i
		DragPetHouse($iPetIndex, $iPage)

		Switch $g_iTownHallLevel
				Case 14
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case Else
							$g_ePetLevels[$i] = 10
					EndSwitch
				Case 15
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case 5
							If $i > 0 And $i <= 4 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 5 Then
								ContinueLoop
							EndIf
						Case 6
							If $i > 0 And $i <= 5 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 6 Then
								ContinueLoop
							EndIf
						Case 7
							If $i > 0 And $i <> 2 And $i <= 6 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 7 Then
								ContinueLoop
							EndIf
						Case 8
							If $i > 0 And $i <> 2 And $i <= 7 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 8 Then
								ContinueLoop
							EndIf
						Case Else
							If $i = 1 Or $i = 3 Then $g_ePetLevels[$i] = 10
					EndSwitch
				Case 16
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case 5
							If $i > 0 And $i <= 4 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 5 Then
								ContinueLoop
							EndIf
						Case 6
							If $i > 0 And $i <= 5 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 6 Then
								ContinueLoop
							EndIf
						Case 7
							If $i > 0 And $i <> 2 And $i <= 6 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 7 Then
								ContinueLoop
							EndIf
						Case 8
							If $i > 0 And $i <> 2 And $i <= 7 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 8 Then
								ContinueLoop
							EndIf
						Case 9
							If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
							If $i > 8 Then ContinueLoop
						Case 10
							If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
							If $i > 9 Then ContinueLoop
					EndSwitch
				Case 17
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case 5
							If $i > 0 And $i <= 4 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 5 Then
								ContinueLoop
							EndIf
						Case 6
							If $i > 0 And $i <= 5 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 6 Then
								ContinueLoop
							EndIf
						Case 7
							If $i > 0 And $i <> 2 And $i <= 6 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 7 Then
								ContinueLoop
							EndIf
						Case 8
							If $i > 0 And $i <> 2 And $i <= 7 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 8 Then
								ContinueLoop
							EndIf
						Case 9
							If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
							If $i > 8 Then ContinueLoop
						Case 10
							If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
							If $i > 9 Then ContinueLoop
					EndSwitch
				Case 18
					Switch $BuildingInfo[2]
						Case 1
							$g_ePetLevels[$i] = 10
							If $i > 0 Then ContinueLoop
						Case 2
							$g_ePetLevels[$i] = 10
							If $i > 1 Then ContinueLoop
						Case 3
							If $i <= 2 Then
								$g_ePetLevels[$i] = 10
							Else
								ContinueLoop
							EndIf
						Case 4
							If $i <= 3 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i > 3 Then
								ContinueLoop
							EndIf
						Case 5
							If $i > 0 And $i <= 4 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 5 Then
								ContinueLoop
							EndIf
						Case 6
							If $i > 0 And $i <= 5 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 6 Then
								ContinueLoop
							EndIf
						Case 7
							If $i > 0 And $i <> 2 And $i <= 6 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 7 Then
								ContinueLoop
							EndIf
						Case 8
							If $i > 0 And $i <> 2 And $i <= 7 Then
								$g_ePetLevels[$i] = 10
							ElseIf $i >= 8 Then
								ContinueLoop
							EndIf
						Case 9
							If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
							If $i > 8 Then ContinueLoop
						Case 10
							If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
							If $i > 9 Then ContinueLoop
						Case 11
							If $i = 5 Then $g_ePetLevels[$i] = 10
							If $i > 10 Then ContinueLoop
						Case 12
							If $i = 11 Then $g_ePetLevels[$i] = 10
							If $i > 11 Then ContinueLoop
					EndSwitch
			EndSwitch

		Switch $i
			Case 0 To 3
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart + ($i * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart + ($i * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
			Case 4 To 7
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart + (($i - 4) * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart + (($i - 4) * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
			Case 8 To 11
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart2 + (($i - 8) * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart2 + (($i - 8) * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
		EndSwitch
		If IsArray($aBlackBorder) Then
			Local $iPetLevelxCoord = $aBlackBorder[0] + 10
		Else
			ContinueLoop
		EndIf

		; check if pet upgrade unlocked
		If _ColorCheck(_GetPixelColor($iPetLevelxCoord, 380 + $g_iMidOffsetY, True), Hex(0xC8BEAD, 6), 15) Then
			; get the Pet Level
			Local $iPetLevel = getPetsLevel($iPetLevelxCoord, 544 + $g_iMidOffsetY)
			If Not ($iPetLevel > 0 And $iPetLevel <= $g_ePetLevels[$i]) Then ;If detected level is not between 1 and 10 Or 15, To Prevent Crash
				If $g_bDebugSetLog Then SetDebugLog("Pet Level OCR Misdetection, Detected Level is : " & $iPetLevel, $COLOR_WARNING)
				ContinueLoop
			EndIf
			If $iPetLevel < $g_ePetLevels[$i] Then
				SetLog($g_asPetNames[$i] & " Level: " & $iPetLevel)
			Else
				SetLog($g_asPetNames[$i] & " Level: " & $g_ePetLevels[$i] & " (Max)", $COLOR_SUCCESS)
				MarkMaxLevelPetUpgrade($i)
			EndIf
			If $iPetLevel = $g_ePetLevels[$i] Then ContinueLoop
			If _Sleep($DELAYLABORATORY2) Then Return
			; get DE requirement to upgrade Pet
			Local $iDarkElixirReq = 1000 * Number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel])
			$iDarkElixirReq = Int($iDarkElixirReq - ($iDarkElixirReq * Number($g_iBuilderBoostDiscount) / 100))
			SetLog("Dark Elixir Requirement: " & _NumberFormat($iDarkElixirReq, True), $COLOR_INFO)
			If $iDarkElixirReq < $g_aiCurrentLoot[$eLootDarkElixir] Then
				SetLog($g_asPetNames[$i] & " Upgrade Started", $COLOR_SUCCESS)
				; Randomise X,Y click
				Local $iX = Random($iPetLevelxCoord + 60, $iPetLevelxCoord + 75, 1)
				Local $iY = Random(495 + $g_iMidOffsetY, 510 + $g_iMidOffsetY, 1)
				Click($iX, $iY)
				; wait for ungrade window to open
				If _Sleep(1500) Then Return
				If _ColorCheck(_GetPixelColor(570, 525 + $g_iMidOffsetY, True), Hex(0xD6F889, 6), 20) Then
					Local $RedZero = _PixelSearch(610, 548 + $g_iMidOffsetY, 650, 552 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20)
					If IsArray($RedZero) Then     ; Check for Red Zero = means not enough loot!
						SetLog("Not enough loot to upgrade pet!", $COLOR_ERROR)
						For $i = 0 To 1
							CloseWindow()
						Next
						Return False
					Else
						If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only
						; check if this just a test
						If Not $test Then
							Click(630, 540 + $g_iMidOffsetY) ; click upgrade
							If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to close
							; Just incase the buy Gem Window pop up!
							If isGemOpen(True) Then
								SetDebugLog("Not enough Dark Elixir to upgrade: " & $g_asPetNames[$i], $COLOR_DEBUG)
								For $i = 0 To 1
									CloseWindow()
								Next
								Return False
							EndIf
							CloseWindow() ; close pet upgrade window
							; Update gui
							;==========Hide Red  Show Green Hide Gray===
							GUICtrlSetState($g_hPicPetGray, $GUI_HIDE)
							GUICtrlSetState($g_hPicPetRed, $GUI_HIDE)
							GUICtrlSetState($g_hPicPetGreen, $GUI_SHOW)
							;===========================================
							If _Sleep($DELAYLABORATORY1) Then Return
							Local $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
							Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
							SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
							If $iPetFinishTime > 0 Then
								$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
								SetLog("Pet house will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
							EndIf
						Else
							CloseWindow() ; close pet upgrade window
						EndIf
						If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asPetLabUpgradeTime[$g_iCurAccount] = $g_sPetUpgradeTime for instantly displaying in multi-stats
						CloseWindow()
						Return True
					EndIf
				EndIf
				SetLog("Failed to find Confirm Button", $COLOR_ERROR)
			EndIf
			SetLog("Upgrade Failed - Not Enough Dark Elixir", $COLOR_ERROR)
		ElseIf _ColorCheck(_GetPixelColor($iPetLevelxCoord, 380 + $g_iMidOffsetY, True), Hex(0xABABAB, 6), 20) Then
			SetLog($g_asPetNames[$i] & ": Locked", $COLOR_DEBUG)
		EndIf
	Next
	SetLog("Pet Upgrade Unavailable", $COLOR_DEBUG)
	CloseWindow()
	Return
EndFunc   ;==>PetHouse

Func _PetStatusColorFound($iX, $iY, $sColor, $iVariation = 25, $iRadiusX = 10, $iRadiusY = 10)
	Return IsArray(_PixelSearch($iX - $iRadiusX, $iY - $iRadiusY, $iX + $iRadiusX, $iY + $iRadiusY, $sColor, $iVariation, True))
EndFunc   ;==>_PetStatusColorFound

; #FUNCTION# ===========================================================================================================
; Name ..........: MarkMaxLevelPetUpgrade
; Description ...: Records the maximum pet level without changing the user upgrade selection.
; ======================================================================================================================
Func MarkMaxLevelPetUpgrade($iPet)
	$g_bPetMaxLevel[$iPet] = True
EndFunc   ;==>MarkMaxLevelPetUpgrade

Func _IsPetUpgradeRunningGui()
	Local $iX = 805
	Local $iY = 215 + $g_iMidOffsetY

	If _PetStatusColorFound($iX, $iY, Hex(0xBED79A, 6), 30, 18, 14) Then Return True
	If _PetStatusColorFound($iX, $iY, Hex(0xA1CA6B, 6), 30, 18, 14) Then Return True
	If _PetStatusColorFound($iX, $iY, Hex(0x8BD43A, 6), 35, 18, 14) Then Return True
	If _PetStatusColorFound($iX, $iY, Hex(0x77C83A, 6), 35, 18, 14) Then Return True

	Return False
EndFunc   ;==>_IsPetUpgradeRunningGui

Func _IsPetUpgradeStoppedGui()
	Local $iX = 150
	Local $iY = 270 + $g_iMidOffsetY

	If _PetStatusColorFound($iX, $iY, Hex(0xCFB138, 6), 30, 18, 18) Then Return True
	If _PetStatusColorFound($iX, $iY, Hex(0xD9BC42, 6), 35, 18, 18) Then Return True
	If _PetStatusColorFound($iX, $iY, Hex(0xB99B2F, 6), 35, 18, 18) Then Return True

	Return False
EndFunc   ;==>_IsPetUpgradeStoppedGui

; check the Pet House to see if a Pet is upgrading already
Func CheckPetUpgrade()
	; check for upgrade in process - look for green in finish upgrade with gems button
	If $g_bDebugSetLog Then SetLog("_GetPixelColor(805, 215): " & _GetPixelColor(805, 215 + $g_iMidOffsetY, True) & ":BED79A", $COLOR_DEBUG)
	If _IsPetUpgradeRunningGui() Then
		SetLog("Pet house upgrade in progress, waiting for completion")
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		Local $sPetTimeOCR = getPetUpgradeTime(235, 242 + $g_iMidOffsetY)
		Local $iPetFinishTime = ConvertOCRTime("Lab Time", $sPetTimeOCR, False)
		SetDebugLog("$sPetTimeOCR: " & $sPetTimeOCR & ", $iPetFinishTime = " & $iPetFinishTime & " m")
		If $iPetFinishTime > 0 Then
			$g_sPetUpgradeTime = _DateAdd('n', Ceiling($iPetFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Pet upgrade will finish in " & $sPetTimeOCR & " (" & $g_sPetUpgradeTime & ")")
			; LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetLog Then
			SetLog("PetLabUpgradeInProgress - Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asPetLabUpgradeTime[$g_iCurAccount] = $g_sPetUpgradeTime for instantly displaying in multi-stats
		CloseWindow()
		Return True
	EndIf
	Return False ; returns False if no upgrade in progress
EndFunc   ;==>CheckPetUpgrade

; checks our global variable to see if we know of something already upgrading
Func PetUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sPetUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sPetUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	;SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][0] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking Pet House", $COLOR_INFO)
	Else
		SetLog("Pet upgrade in progress, waiting for completion")
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc   ;==>PetUpgradeInProgress

Func FindPetsButton()
	Local $aPetsButton = findButton("Pets", Default, 1, True)
	If IsArray($aPetsButton) And UBound($aPetsButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("PetHouse") ; Debug Only
		ClickP($aPetsButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	EndIf

	$aPetsButton = _FindPetsButtonDynamic()
	If IsArray($aPetsButton) And UBound($aPetsButton, 1) = 2 Then
		SetDebugLog("Pet House pets button found by dynamic fallback")
		If $g_bDebugImageSave Then SaveDebugImage("PetHouseDynamic") ; Debug Only
		ClickP($aPetsButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	EndIf

	SetLog("Cannot find the pets button!", $COLOR_ERROR)
	CloseWindow()
	Return False
EndFunc   ;==>FindPetsButton

Func _FindPetsButtonDynamic()
	; The Pets button can shift when the lower action bar changes.
	; Scan the full action bar from right to left and use the rightmost green plus badge as the Pets anchor.
	Local $aColors[6] = [Hex(0xA6EF45, 6), Hex(0x94E13B, 6), Hex(0x83D532, 6), Hex(0x76C82F, 6), Hex(0x69BA2A, 6), Hex(0xB5F05D, 6)]
	Local $aPixel = 0

	For $iX = 700 To 245 Step -25
		For $i = 0 To UBound($aColors) - 1
			$aPixel = _PixelSearch($iX, 565 + $g_iMidOffsetY, $iX + 35, 650 + $g_iMidOffsetY, $aColors[$i], 35, True)
			If IsArray($aPixel) Then
				Local $aButton[2] = [Int($aPixel[0]) - 15, Int($aPixel[1]) + 23]

				If $aButton[0] < 235 Then $aButton[0] = 235
				If $aButton[0] > 705 Then $aButton[0] = 705
				If $aButton[1] < 590 + $g_iMidOffsetY Then $aButton[1] = 615 + $g_iMidOffsetY
				If $aButton[1] > 640 + $g_iMidOffsetY Then $aButton[1] = 615 + $g_iMidOffsetY

				SetDebugLog("Dynamic Pets button anchor: " & $aPixel[0] & "," & $aPixel[1] & " click: " & $aButton[0] & "," & $aButton[1])
				Return $aButton
			EndIf
		Next
	Next

	; Last safe fallback for the shifted Pets slot shown while the Pet House/building is upgrading.
	If _PetStatusColorFound(635, 595 + $g_iMidOffsetY, Hex(0x83D532, 6), 45, 35, 25) Then
		Local $aFallback[2] = [620, 615 + $g_iMidOffsetY]
		SetDebugLog("Dynamic Pets button fixed fallback click: " & $aFallback[0] & "," & $aFallback[1])
		Return $aFallback
	EndIf

	Return 0
EndFunc   ;==>_FindPetsButtonDynamic

; called from main loop to get an early status for indictors in bot bottom
; run every if no upgradeing pet


Func GetMinDark4PetUpgrade($PetHouseLevel, ByRef $iPage)
	Local $iPetLevelxCoordStart = 40
	Local $iPetLevelxCoordStart2 = 85
	Local $iPetSlotWidth = 182
	Local $iMinDark4PetUpgrade = 999999

	For $i = 0 To $ePetCount - 1
		$g_ePetLevels[$i] = $g_aiPetMaxLevels[$i]
		; check if pet upgrade enabled
		If Not $g_bUpgradePetsEnable[$i] Then ContinueLoop

		DragPetHouse($i, $iPage)

		Switch $g_iTownHallLevel
			Case 14
				Switch $PetHouseLevel
					Case 1
						$g_ePetLevels[$i] = 10
						If $i > 0 Then ContinueLoop
					Case 2
						$g_ePetLevels[$i] = 10
						If $i > 1 Then ContinueLoop
					Case 3
						If $i <= 2 Then
							$g_ePetLevels[$i] = 10
						Else
							ContinueLoop
						EndIf
					Case 4
						If $i <= 3 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i > 3 Then
							ContinueLoop
						EndIf
				EndSwitch
			Case 15
				Switch $PetHouseLevel
					Case 1
						$g_ePetLevels[$i] = 10
						If $i > 0 Then ContinueLoop
					Case 2
						$g_ePetLevels[$i] = 10
						If $i > 1 Then ContinueLoop
					Case 3
						If $i <= 2 Then
							$g_ePetLevels[$i] = 10
						Else
							ContinueLoop
						EndIf
					Case 4
						If $i <= 3 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i > 3 Then
							ContinueLoop
						EndIf
					Case 5
						If $i > 0 And $i <= 4 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 5 Then
							ContinueLoop
						EndIf
					Case 6
						If $i > 0 And $i <= 5 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 6 Then
							ContinueLoop
						EndIf
					Case 7
						If $i > 0 And $i <> 2 And $i <= 6 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 7 Then
							ContinueLoop
						EndIf
					Case 8
						If $i > 0 And $i <> 2 And $i <= 7 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 8 Then
							ContinueLoop
						EndIf
					Case Else
						If $i = 1 Or $i = 3 Then $g_ePetLevels[$i] = 10
				EndSwitch
			Case 16
				Switch $PetHouseLevel
					Case 1
						$g_ePetLevels[$i] = 10
						If $i > 0 Then ContinueLoop
					Case 2
						$g_ePetLevels[$i] = 10
						If $i > 1 Then ContinueLoop
					Case 3
						If $i <= 2 Then
							$g_ePetLevels[$i] = 10
						Else
							ContinueLoop
						EndIf
					Case 4
						If $i <= 3 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i > 3 Then
							ContinueLoop
						EndIf
					Case 5
						If $i > 0 And $i <= 4 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 5 Then
							ContinueLoop
						EndIf
					Case 6
						If $i > 0 And $i <= 5 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 6 Then
							ContinueLoop
						EndIf
					Case 7
						If $i > 0 And $i <> 2 And $i <= 6 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 7 Then
							ContinueLoop
						EndIf
					Case 8
						If $i > 0 And $i <> 2 And $i <= 7 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 8 Then
							ContinueLoop
						EndIf
					Case 9
						If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
						If $i > 8 Then ContinueLoop
					Case 10
						If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
						If $i > 9 Then ContinueLoop
				EndSwitch
			Case 17, 18
				Switch $PetHouseLevel
					Case 1
						$g_ePetLevels[$i] = 10
						If $i > 0 Then ContinueLoop
					Case 2
						$g_ePetLevels[$i] = 10
						If $i > 1 Then ContinueLoop
					Case 3
						If $i <= 2 Then
							$g_ePetLevels[$i] = 10
						Else
							ContinueLoop
						EndIf
					Case 4
						If $i <= 3 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i > 3 Then
							ContinueLoop
						EndIf
					Case 5
						If $i > 0 And $i <= 4 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 5 Then
							ContinueLoop
						EndIf
					Case 6
						If $i > 0 And $i <= 5 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 6 Then
							ContinueLoop
						EndIf
					Case 7
						If $i > 0 And $i <> 2 And $i <= 6 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 7 Then
							ContinueLoop
						EndIf
					Case 8
						If $i > 0 And $i <> 2 And $i <= 7 Then
							$g_ePetLevels[$i] = 10
						ElseIf $i >= 8 Then
							ContinueLoop
						EndIf
					Case 9
						If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
						If $i > 8 Then ContinueLoop
					Case 10
						If $i = 3 Or $i = 4 Or $i = 5 Then $g_ePetLevels[$i] = 10
						If $i > 9 Then ContinueLoop
					Case 11
						If $i = 5 Then $g_ePetLevels[$i] = 10
						If $i > 10 Then ContinueLoop
					Case 12
						If $i = 11 Then $g_ePetLevels[$i] = 10
						If $i > 11 Then ContinueLoop
				EndSwitch
		EndSwitch

		Switch $i
			Case 0 To 3
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart + ($i * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart + ($i * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
			Case 4 To 7
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart + (($i - 4) * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart + (($i - 4) * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
			Case 8 To 11
				Local $aBlackBorder = _MultiPixelSearch2($iPetLevelxCoordStart2 + (($i - 8) * $iPetSlotWidth), 500 + $g_iMidOffsetY, $iPetLevelxCoordStart2 + (($i - 8) * $iPetSlotWidth) + 15, 500 + $g_iMidOffsetY, 1, 1, Hex(0x0D0D0D, 6), 15)
		EndSwitch
		If IsArray($aBlackBorder) Then
			Local $iPetLevelxCoord = $aBlackBorder[0] + 10
		Else
			ContinueLoop
		EndIf

		; check if pet upgrade enabled and unlocked
		If _ColorCheck(_GetPixelColor($iPetLevelxCoord, 380 + $g_iMidOffsetY, True), Hex(0xC8BEAD, 6), 15) Then

			; get the Pet Level
			Local $iPetLevel = getPetsLevel($iPetLevelxCoord, 544 + $g_iMidOffsetY)
			If Not ($iPetLevel > 0 And $iPetLevel <= $g_ePetLevels[$i]) Then ;If detected level is not between 1 and 10 Or 15, To Prevent Crash
				If $g_bDebugSetLog Then SetDebugLog("Pet Level OCR Misdetection, Detected Level is : " & $iPetLevel, $COLOR_WARNING)
				ContinueLoop
			EndIf

			If $iPetLevel < $g_ePetLevels[$i] Then
				SetLog($g_asPetNames[$i] & " Level: " & $iPetLevel)
			Else
				SetLog($g_asPetNames[$i] & " Level: " & $g_ePetLevels[$i] & " (Max)", $COLOR_SUCCESS)
				MarkMaxLevelPetUpgrade($i)
			EndIf
			If $iPetLevel = $g_ePetLevels[$i] Then ContinueLoop

			If _Sleep($DELAYLABORATORY2) Then Return

			; get DE requirement to upgrade Pet
			Local $iDarkElixirReq = (1000 * Number($g_aiPetUpgradeCostPerLevel[$i][$iPetLevel]))
			$iDarkElixirReq = Int($iDarkElixirReq - ($iDarkElixirReq * Number($g_iBuilderBoostDiscount) / 100))

			SetLog("Dark Elixir Requirement: " & _NumberFormat($iDarkElixirReq, True), $COLOR_INFO)

			If $iDarkElixirReq < $iMinDark4PetUpgrade Then
				$iMinDark4PetUpgrade = $iDarkElixirReq
			EndIf
		ElseIf _ColorCheck(_GetPixelColor($iPetLevelxCoord, 380 + $g_iMidOffsetY, True), Hex(0xB7B7B7, 6), 15) Then
			SetLog($g_asPetNames[$i] & ": Locked", $COLOR_DEBUG)
		EndIf
	Next

	Return $iMinDark4PetUpgrade
EndFunc   ;==>GetMinDark4PetUpgrade

Func DragPetHouse($iPetIndex, ByRef $iPage)
	Local $iY1
	Local $iY2
	Local $iPageTarget
	Local $bLoop = 0

	Switch $iPetIndex
		Case 0 To 3
			$iPageTarget = 0
		Case 4 To 7
			$iPageTarget = 1
		Case 8 To 11
			$iPageTarget = 2
	EndSwitch

	While 1

		If $iPage = $iPageTarget Then ExitLoop

		Local $iYPoint = Random(500 + $g_iMidOffsetY, 530 + $g_iMidOffsetY, 1)

		If $iPage < $iPageTarget Then
			If $iPage = 0 Then
				ClickDrag(770, $iYPoint, 190, $iYPoint, 300)
				SetDebugLog("Moving from page 0 to 1")
			Else
				ClickDrag(770, $iYPoint, 190, $iYPoint, 300)
				SetDebugLog("Moving from page 1 to 2")
			EndIf
			If _Sleep(Random(1800, 2500, 1)) Then Return
			$iPage += 1
		EndIf

		If $iPage > $iPageTarget Then
			If $iPage = 2 Then
				ClickDrag(190, $iYPoint, 770, $iYPoint, 300)
				SetDebugLog("Moving from page 2 to 1")
			Else
				ClickDrag(190, $iYPoint, 770, $iYPoint, 300)
				SetDebugLog("Moving from page 1 to 0")
			EndIf
			If _Sleep(Random(1800, 2500, 1)) Then Return
			$iPage -= 1
		EndIf

		$bLoop += 1
		If $bLoop = 10 Then ExitLoop

	WEnd

EndFunc   ;==>DragPetHouse

Func TestPetHouse($iPetEnum = -1)
	If Not IsPetHousePage() Then
		SetLog("[Pet House]: Window not detected", $COLOR_ERROR)
		Return False
	EndIf

	Local $bSinglePet = ($iPetEnum <> -1)
	If $bSinglePet And ($iPetEnum < $ePetLassi Or $iPetEnum >= $ePetCount) Then
		SetLog("[Pet Enum]: Not supported (" & $iPetEnum & ")", $COLOR_ERROR)
		Return False
	EndIf

	If $bSinglePet Then
		SetLog("[Pet House Test]: " & $g_asPetNames[$iPetEnum], $COLOR_INFO)
	Else
		SetLog("[Pet House Test]: Scanning upgrades", $COLOR_INFO)
	EndIf

	Local $bUpgradeRunning = _IsPetUpgradeRunningGui()
	If $bUpgradeRunning Then SetLog("[Pet House Upgrade]: Running", $COLOR_INFO)

	Local $iPage = 0
	Local $iFirstPet = 0, $iLastPet = $ePetCount - 1
	If $bSinglePet Then
		$iFirstPet = $iPetEnum
		$iLastPet = $iPetEnum
	EndIf

	For $iPet = $iFirstPet To $iLastPet
		DragPetHouse($iPet, $iPage)
		Local $iCardX = _UPT_GetPetCardX($iPet)
		Local $iCost = 0
		Local $sState = _UPT_GetPetUpgradeState($iPet, $iCardX, $bUpgradeRunning, $iCost, $bSinglePet)
		_UPT_LogPetUpgradeState($g_asPetNames[$iPet], $sState)
		If $bSinglePet And $iCost > 0 Then SetLog("[" & $g_asPetNames[$iPet] & " Cost]: " & _NumberFormat($iCost, True) & " Dark Elixir", $COLOR_INFO)
	Next

	Return True
EndFunc   ;==>TestPetHouse
