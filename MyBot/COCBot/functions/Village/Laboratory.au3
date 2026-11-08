; #FUNCTION# ====================================================================================================================
; Name ..........: Laboratory
; Description ...:
; Syntax ........: Laboratory()
; Parameters ....:
; Return values .: None
; Author ........: summoner
; Modified ......: KnowJack (06/2015), Sardo (08/2015), Monkeyhunter(04/2016), MMHK(06/2018), Chilly-Chill (12/2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Laboratory()             - Status Check + Normal Upgrade Flow
; Laboratory(False, True)  - Status/GUI Check Only

Local $iSlotWidth = 108, $iDistBetweenSlots = 14 ; use for logic to upgrade troops.. good for generic-ness
Local $iYMidPoint = Random(475, 485, 1) ;Space between rows in lab screen.  CHANGE ONLY WITH EXTREME CAUTION.
Local $iPicsPerPage = 12, $iPages = 6 ; used to know exactly which page the users choice is on
Local $sLabTroopsSection = "70,365,795,600"
Local $sLabTroopsSectionDiam = GetDiamondFromRect($sLabTroopsSection)

Func _UTL_GetLabIndex($iTroopEnum)
	Local $sShortName = _UTL_GetEnumShortName($iTroopEnum)
	If $sShortName = "" Then Return -1
	Return _UTL_GetLabIndexByShortName($sShortName)
EndFunc   ;==>_UTL_GetLabIndex

Func _UTL_GetLabIndexByShortName($sShortName)
	For $iLabIndex = 1 To UBound($g_avLabTroops, $UBOUND_ROWS) - 1
		If $g_avLabTroops[$iLabIndex][2] = $sShortName Then Return $iLabIndex
	Next
	Return -1
EndFunc   ;==>_UTL_GetLabIndexByShortName

Func _UTL_GetEnumShortName($iTroopEnum)
	If $iTroopEnum >= $eBarb And $iTroopEnum <= $eGDrag Then Return $g_asTroopShortNames[$iTroopEnum]
	If $iTroopEnum >= $eLSpell And $iTroopEnum <= $eASpell Then Return $g_asSpellShortNames[$iTroopEnum - $eLSpell]
	If $iTroopEnum >= $eWallW And $iTroopEnum <= $eSkyW Then
		If $iTroopEnum = $eWallW Then Return "Siege"
		Return $g_asSiegeMachineShortNames[$iTroopEnum - $eWallW]
	EndIf
	Return ""
EndFunc   ;==>_UTL_GetEnumShortName

Func _UTL_OpenLabAndReadCost($aCoords, ByRef $iCost)
	$iCost = 0
	Local $aSlotClick = GetLabSlotClickCoords($aCoords)
	ClickP($aSlotClick)
	If _Sleep(1500) Then Return "Unknown"

	Local $sCost = getCostsUpgrade(552, 541 + $g_iMidOffsetY)
	If $sCost = "" Then $sCost = getCostsUpgrade(552, 532 + $g_iMidOffsetY)
	If $sCost <> "" Then
		$iCost = Number(StringRegExpReplace($sCost, "[^0-9]", ""))
		CloseWindow()
		If _Sleep(500) Then Return "Unknown"
		Return ($iCost > 0 ? "Available" : "Unknown")
	EndIf

	$sCost = getCostsUpgradeRed(552, 541 + $g_iMidOffsetY)
	If $sCost = "" Then $sCost = getCostsUpgradeRed(552, 532 + $g_iMidOffsetY)
	$iCost = Number(StringRegExpReplace($sCost, "[^0-9]", ""))

	CloseWindow() ; test only: never confirm the upgrade
	If _Sleep(500) Then Return "Unknown"

	If $iCost > 0 Then Return "Insufficient Resources"
	Return "Unknown"
EndFunc   ;==>_UTL_OpenLabAndReadCost

Func Laboratory($debug = False, $bStatusOnly = False)
	Local $bContinueUpgrade = False

	; Normal flow also performs the status check first. When Stopped, it keeps
	; the Research window open and continues directly to the upgrade scan.
	If Not $bStatusOnly And $g_bAutoLabUpgradeEnable Then VillageReport(False, False, False)

	If True Then
			Local Static $iLastTimeChecked[$g_iSwitchAccMaxAccounts]
			If $g_bFirstStart Then $iLastTimeChecked[$g_iCurAccount] = ""
		
			; Check if is a valid date and Calculated the number of minutes from remain time Lab and now
			If _DateIsValid($g_sLabUpgradeTime) And _DateIsValid($iLastTimeChecked[$g_iCurAccount]) Then
				Local $iLabTime = _DateDiff('n', _NowCalc(), $g_sLabUpgradeTime)
				Local $iLastCheck = _DateDiff('n', $iLastTimeChecked[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
				SetDebugLog("Lab LabUpgradeTime: " & $g_sLabUpgradeTime & ", Lab DateCalc: " & $iLabTime)
				SetDebugLog("Lab LastCheck: " & $iLastTimeChecked[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
				; A check each from 2 to 5 hours [2*60 = 120 to 5*60 = 300] or when Lab research time finishes
				Local $iDelayToCheck = Random(120, 300, 1)
				If _DateIsValid($bLabAssistantUsedTime) Then
					Local $DiffLabAssistantUsedTime = _DateDiff('n', $bLabAssistantUsedTime, _NowCalc())
					If $DiffLabAssistantUsedTime > 60 Then ; One Hour after using Lab Assistant (Because I cant' find the formula !)
						$iDelayToCheck = 0 ; Check Right Now
						$bLabAssistantUsedTime = 0
					EndIf
				EndIf
				If $iLabTime > 0 And $iLastCheck <= $iDelayToCheck Then Return
			EndIf
		
			ClearScreen()
		
			If $g_iTownHallLevel < 3 Then
				SetDebugLog("TH reads as Lvl " & $g_iTownHallLevel & ", has no Lab.")
				;============Hide Red  Hide Green  Show Gray==
				GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
				GUICtrlSetData($g_hLbLLabTime, "")
				;============================================
				Return
			EndIf
		
			SetLog("Checking Lab Status", $COLOR_INFO)
			Local $aiSavedLaboratoryPos = $g_aiLaboratoryPos
			Local $bLaboratorySelected = ImgLocateLab(True, True)
			If Not $bLaboratorySelected Then
				$g_aiLaboratoryPos = $aiSavedLaboratoryPos
				If $g_aiLaboratoryPos[0] <= 0 Or $g_aiLaboratoryPos[1] <= 0 Then Return
				SetLog("Laboratory Position: (" & $g_aiLaboratoryPos[0] & "," & $g_aiLaboratoryPos[1] & ")", $COLOR_SUCCESS)
			EndIf
		
			;=================Section 2 Lab Gui
		
			; If $g_bAutoLabUpgradeEnable = True Then  ====>>>> TODO : or use this or make a checkbox on GUI
			; make sure lab is located, if not locate lab
			If $g_aiLaboratoryPos[0] <= 0 Or $g_aiLaboratoryPos[1] <= 0 Then
				SetLog("Laboratory Location is unknown!", $COLOR_ERROR)
				;============Hide Red  Hide Green  Show Gray==
				GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
				GUICtrlSetData($g_hLbLLabTime, "")
				;============================================
				Return
			EndIf
		
			If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilder, 240, 0, 450, 60, True))) > 1 Then
				$GobBuilderPresent = True
				$GobBuilderOffsetRunning = 375
			Else
				$GobBuilderPresent = False
				$GobBuilderOffsetRunning = 0
			EndIf
		
			If Not $bLaboratorySelected Then
				BuildingClickP($g_aiLaboratoryPos, "#0197")
				If _Sleep(1500) Then Return
			EndIf
			; Find Research Button
		
			Local $sBuildingInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
			If IsArray($sBuildingInfo) And UBound($sBuildingInfo) > 0 Then
				SetLog("Laboratory Level: " & $sBuildingInfo[2], $COLOR_INFO)
			EndIf
		
			$iLastTimeChecked[$g_iCurAccount] = _NowCalc()
		
			Local $aResearchButton = findButton("Research", Default, 1, True)
			If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
				If $g_bDebugImageSave Then SaveDebugImage("LabUpgrade") ; Debug Only
				ClickP($aResearchButton)
				If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
				If Not $GobBuilderPresent Then ; Just in case
					If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilderLab, 420, 115 + $g_iMidOffsetY, 575, 195 + $g_iMidOffsetY, True))) > 1 Or _
							UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilder, 420, 115 + $g_iMidOffsetY, 490, 175 + $g_iMidOffsetY, True))) > 1 Then
						$GobBuilderPresent = True
						$GobBuilderOffsetRunning = 375
					EndIf
				EndIf
			Else
				SetLog("Laboratory research button not found!", $COLOR_ERROR)
				ClearScreen()
				;===========Hide Red  Hide Green  Show Gray==
				GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
				GUICtrlSetData($g_hLbLLabTime, "")
				;===========================================
				Return
			EndIf
		
			Local $IsRunning = False
			Local $IsStopped = False
		
			For $i = 0 To 5
				If _IsLabUpgradeStoppedGui() Then ; Look for purple/gray idle status in the upper right of the lab window.
					$IsStopped = True
					ExitLoop
				EndIf
				If _IsLabUpgradeRunningGui() Then ; Look for green in the upper right finish-upgrade area of the lab window.
					$IsRunning = True
					ExitLoop
				EndIf
				If _Sleep(500) Then Return
			Next
		
			; check for upgrade in process - look for green in finish upgrade with gems button
			If $IsRunning Then
				SetLog("Status: Running")
				;==========Hide Red  Show Green Hide Gray===
				GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabGreen, $GUI_SHOW)
				;===========================================
				If _Sleep($DELAYLABORATORY2) Then Return
				If $GobBuilderPresent Then
					Local $sLabTimeOCR = getRemainTLaboratoryGob(245, 200 + $g_iMidOffsetY)
				Else
					Local $sLabTimeOCR = getRemainTLaboratory2(250, 200 + $g_iMidOffsetY)
				EndIf
				Local $iLabFinishTime = 0
				If $sLabTimeOCR <> "" Then $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False) + 1
				SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
				If $iLabFinishTime > 0 Then
					$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
					SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
					$g_iLaboratoryElixirCost = 0
					$g_iLaboratoryDElixirCost = 0
					LabStatusGUIUpdate() ; Update GUI flag
				EndIf
		
				If _Sleep(1000) Then Return
				If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
				CloseWindow()
				Return False
			ElseIf $IsStopped Then
				SetLog("Status: Stopped")
				If $g_bNotifyTGEnable And $g_bNotifyAlertLaboratoryIdle Then NotifyPushToTelegram($g_sNotifyOrigin & " | " & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_01", "Laboratory Idle") & "%0A" & GetTranslatedFileIni("MBR Func_Notify", "Laboratory-Idle_Info_02", "Laboratory has stopped"))
				;========Show Red  Hide Green  Hide Gray=====
				GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabRed, $GUI_SHOW)
				GUICtrlSetData($g_hLbLLabTime, "")
				;============================================
				$g_sLabUpgradeTime = ""
				If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats

				; Status-only keeps the former behavior. Normal flow reuses the open Research window.
				If $bStatusOnly Then
					CloseWindow()
					ClearScreen()
					Return True
				EndIf

				If Not $g_bAutoLabUpgradeEnable Then
					CloseWindow()
					ClearScreen()
					Return
				EndIf

				$bContinueUpgrade = True
			Else
				SetLog("Unable to determine Laboratory Status", $COLOR_INFO)
				;========Hide Red  Hide Green  Show Gray======
				GUICtrlSetState($g_hPicLabGreen, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
				GUICtrlSetState($g_hPicLabGray, $GUI_SHOW)
				GUICtrlSetData($g_hLbLLabTime, "")
				;=============================================
				CloseWindow()
				$iLastTimeChecked[$g_iCurAccount] = ""
				Return
			EndIf
	EndIf

	; Reaching this point means the status check above confirmed Stopped and
	; the Research window is still open. Continue directly with the upgrade scan.
	If Not $bContinueUpgrade Then Return False
	If Not $g_bRunState Then Return

	; Lab upgrade is not in progress and not upgreading, so we need to start a upgrade.
	Local $iCurPage = 1
	Local $sCostResult
	Global $bUserChoice = False

	; Single scan for all priorities
	Local $iBestPriority = -1
	Local $aBestCoords
	Local $sBestCost
	Local $iBestPage = -1
	Local $iCurrentPage = 1
	Local $bAnyPriority = False
	For $iPriority = 0 To 2
		If $g_aiLabUpgradePriority[$iPriority] = 0 Then
			$bAnyPriority = True
			ExitLoop
		EndIf
	Next

	; Any is a direct search on the currently visible page. Do not navigate the
	; laboratory pages when the user explicitly accepts any available upgrade.
	If $bAnyPriority Then
		SetLog("Any priority selected, searching current page first")
		Local $aAnyUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True)
		If UBound($aAnyUpgrades, 1) >= 1 Then
			For $i = 0 To UBound($aAnyUpgrades, 1) - 1
				Local $aAnyTroop = $aAnyUpgrades[$i]
				Local $aAnyCoords = decodeSingleCoord($aAnyTroop[1])
				Local $sAnyCost = GetLabCostResult($aAnyCoords)
				If $sAnyCost = "" Then ContinueLoop
				If StringSplit($sAnyCost, "1")[0] = StringLen($sAnyCost) + 1 Or StringSplit($sAnyCost, "1")[1] = "0" Then ContinueLoop
				Return LaboratoryUpgrade($aAnyTroop[0], $aAnyCoords, $sAnyCost, $debug)
			Next
		EndIf
		SetLog("No available upgrade found on the current laboratory page", $COLOR_INFO)
		CloseWindow()
		Return False
	EndIf

	For $iPage = 1 To $iPages
		SetDebugLog("Scanning page " & $iPage & " for all priorities")
		Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True)

		If UBound($aPageUpgrades, 1) >= 1 Then
			For $iPriority = 0 To 2
				If $g_aiLabUpgradePriority[$iPriority] = 0 Then ContinueLoop
				If $iBestPriority <> -1 And $iPriority > $iBestPriority Then ContinueLoop ; already have a better (lower number) priority

				Local $sTargetShortName = $g_avLabTroops[$g_aiLabUpgradePriority[$iPriority]][2]
				For $i = 0 To UBound($aPageUpgrades, 1) - 1
					Local $aTempTroopArray = $aPageUpgrades[$i]
					If $aTempTroopArray[0] = $sTargetShortName Then
						Local $aCoords = decodeSingleCoord($aTempTroopArray[1])
						$sCostResult = GetLabCostResult($aCoords)
						If $sCostResult <> "" And StringSplit($sCostResult, "1")[0] <> StringLen($sCostResult) + 1 And StringSplit($sCostResult, "1")[1] <> "0" Then
							; can upgrade
							If $iBestPriority = -1 Or $iPriority < $iBestPriority Then
								$iBestPriority = $iPriority
								$aBestCoords = $aCoords
								$sBestCost = $sCostResult
								$iBestPage = $iPage
								SetLog("Found " & $g_avLabTroops[$g_aiLabUpgradePriority[$iPriority]][0] & " upgrade on page " & $iPage)
							EndIf
						EndIf
					EndIf
				Next
			Next
		EndIf

		; Navigate to next page if not last
		If $iPage < $iPages Then
			LabNextPage($iCurrentPage, $iPages, $iYMidPoint)
			$iCurrentPage += 1
			If _Sleep(1000) Then Return
		EndIf
	Next

	; If found a priority to upgrade
	If $iBestPriority <> -1 Then
		; Navigate to the page of the best upgrade by closing and reopening lab, then going forward
		LabGotoFirstPage()
		If _Sleep($DELAYLABORATORY5) Then Return
		BuildingClickP($g_aiLaboratoryPos, "#0197")
		If _Sleep($DELAYLABORATORY5) Then Return
		If Not FindResearchButton() Then Return False
		Local $iCurrentPage = 1
		For $i = 1 To $iBestPage - 1
			LabNextPage($iCurrentPage, $iPages, $iYMidPoint)
			$iCurrentPage += 1
			If _Sleep(1000) Then Return
		Next
		Return LaboratoryUpgrade($g_avLabTroops[$g_aiLabUpgradePriority[$iBestPriority]][0], $aBestCoords, $sBestCost, $debug)
	EndIf

	; No priorities upgraded, use any upgrade
	SetLog("No priority upgrades available, upgrading any available troop")
	
	; Any upgrade logic - backward search from last page to first
	Local $iFallbackCurPage = $iPages
	Local $iFallbackSearchPage = $iPages
	
	While ($iFallbackSearchPage >= 1)
		SetDebugLog("Searching any available upgrade on page " & $iFallbackSearchPage)
		Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True)
		If UBound($aPageUpgrades, 1) >= 1 Then ; if we found any troops
			SetDebugLog("Found upgrades on page #" & $iFallbackSearchPage & ", trying the first one")
			Local $aTempTroopArray = $aPageUpgrades[0] ; Take the first available upgrade

			Local $aCoords = decodeSingleCoord($aTempTroopArray[1])
			Local $sCostResult = GetLabCostResult($aCoords) ; get cost of the current upgrade option

			If $sCostResult = "" Then ; not enough resources
				SetLog("Not enough resources for upgrade", $COLOR_INFO)
				CloseWindow()
				Return False
			ElseIf StringSplit($sCostResult, "1")[0] = StringLen($sCostResult) + 1 Or StringSplit($sCostResult, "1")[1] = "0" Then ; max level if all ones returned from ocr or if the first letter is a 0.
				SetLog("All available troops are already at max level", $COLOR_INFO)
				CloseWindow()
				Return False
			Else
				Return LaboratoryUpgrade($aTempTroopArray[0], $aCoords, $sCostResult, $debug) ; return whether or not we successfully upgraded
			EndIf
		EndIf

		; Navigate to previous page for next search
		If $iFallbackSearchPage > 1 Then
			LabPreviousPage($iFallbackCurPage, $iPages, $iYMidPoint)
			$iFallbackCurPage -= 1
			If _Sleep(1000) Then Return
		EndIf
		
		$iFallbackSearchPage -= 1
	WEnd

	; If We got to here without returning, then nothing available for upgrade
	SetLog("Nothing available for upgrade at the moment, try again later")
	CloseWindow()

	Return False ; No upgrade started
EndFunc   ;==>Laboratory

; start a given upgrade
Func LaboratoryUpgrade($name, $aCoords, $sCostResult, $debug = False)
	SetLog($name & " Upgrade Cost: " & _NumberFormat($sCostResult, True), $COLOR_INFO)
	Local $aSlotClick = GetLabSlotClickCoords($aCoords)
	SetDebugLog("Selecting laboratory slot at (" & $aSlotClick[0] & "," & $aSlotClick[1] & ")")
	ClickP($aSlotClick) ; click the center of the troop card
	If _Sleep(2000) Then Return

	If Not SetLabUpgradeTime($name) Then
		SetLog("Unable to confirm laboratory upgrade window, upgrade cancelled", $COLOR_ERROR)
		Return False
	EndIf
	If _Sleep($DELAYLABUPGRADE1) Then Return

	If $debug = True Then ; if debugging, do not actually click it
		SetLog("[debug mode] - Start Upgrade, Click (" & 630 & "," & 565 + $g_iMidOffsetY & ")", $COLOR_ACTION)
		CloseWindow()
		Return True ; return true as if we really started a upgrade
	Else
		Click(630, 545 + $g_iMidOffsetY, 1, 120, "#0202") ; Everything is good - Click the upgrade button
		If _Sleep(500) Then Return
		If isGemOpen(True) = False Then ; check for gem window
			; success
			SetLog($name & " Upgrade Started", $COLOR_SUCCESS)
			GUICtrlSetState($g_hPicLabGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicLabGreen, $GUI_SHOW)
			LabStatusGUIUpdate()
			;If doing a user specific upgrade, set to "any" for next time.
			;Bad if user wanted to upgrade it multiple levels.
			If $bUserChoice Then
				SetLog("Clearing user's upgrade choice", $COLOR_INFO)
				;HArchH Set the global that gets saved to building.ini
				$g_iCmbLaboratory = 0 ;Set global
				_GUICtrlComboBox_SetCurSel($g_hCmbLaboratory, $g_iCmbLaboratory) ;Apply to the GUI in case it gets saved again.
				SaveBuildingConfig() ;Try to save for the future.
			EndIf
			If _Sleep(350) Then Return
			CloseWindow2()
			If _Sleep(1000) Then Return
			PushMsg("LabSuccess")
			ChkLabUpgradeInProgress($name)
			If _Sleep($DELAYLABUPGRADE2) Then Return
			CloseWindow()
			Return True ; upgrade started
		Else
			SetLog("Oops, Gems required for " & $name & " Upgrade, try again", $COLOR_ERROR)
			Return False
		EndIf
	EndIf
EndFunc   ;==>LaboratoryUpgrade

Func GetLabSlotClickCoords($aCoords)
	Local $iSectionLeft = Int(StringSplit($sLabTroopsSection, ",")[1])
	Local $iColumn = Ceiling((Int($aCoords[0]) - $iSectionLeft) / ($iSlotWidth + $iDistBetweenSlots))
	If $iColumn < 1 Then $iColumn = 1
	If $iColumn > 6 Then $iColumn = 6
	Local $iClickX = $iSectionLeft + ($iColumn - 1) * ($iSlotWidth + $iDistBetweenSlots) + Int($iSlotWidth / 2)
	Local $iClickY = (Int($aCoords[1]) < $iYMidPoint ? 405 : 528) + $g_iMidOffsetY
	Local $aClick[2] = [$iClickX, $iClickY]
	Return $aClick
EndFunc   ;==>GetLabSlotClickCoords

; get the time for the selected upgrade
Func SetLabUpgradeTime($sTrooopName)
	Local $Result = getLabUpgradeTime2(730, 544 + $g_iMidOffsetY) ; Try to read white text showing time for upgrade
	If $Result = "" Then $Result = getLabUpgradeTime2(730, 532 + $g_iMidOffsetY) ; Discount/shifted text
	If $Result = "" Then $Result = getLabUpgradeTime2(717, 544 + $g_iMidOffsetY)
	If $Result = "" Then $Result = getLabUpgradeTime2(717, 532 + $g_iMidOffsetY)
	If $Result = "" Then
		If _Sleep(1000) Then Return False
		$Result = getLabUpgradeTime2(730, 544 + $g_iMidOffsetY) ; Retry after window animation
		If $Result = "" Then $Result = getLabUpgradeTime2(730, 532 + $g_iMidOffsetY)
		If $Result = "" Then $Result = getLabUpgradeTime2(717, 544 + $g_iMidOffsetY)
		If $Result = "" Then $Result = getLabUpgradeTime2(717, 532 + $g_iMidOffsetY)
	EndIf
	Local $iLabFinishTime = ConvertOCRTime("Lab Time", $Result, False)
	SetDebugLog($sTrooopName & " Upgrade OCR Time = " & $Result & ", $iLabFinishTime = " & $iLabFinishTime & " m", $COLOR_INFO)
	Local $StartTime = _NowCalc() ; what is date:time now
	SetDebugLog($sTrooopName & " Upgrade Started @ " & $StartTime, $COLOR_SUCCESS)
	If $iLabFinishTime > 0 Then
		$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), $StartTime)
		; Log moved to ChkLabUpgradeInProgress to avoid duplicate
		$g_iLaboratoryElixirCost = 0
		$g_iLaboratoryDElixirCost = 0
	Else
		SetLog("Error processing upgrade time required, try again!", $COLOR_WARNING)
		Return False
	EndIf
	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
	Return True ; success
EndFunc   ;==>SetLabUpgradeTime

; get the cost of a upgrade based on its coords
; find image slot that we found so that we can read the cost to see if we can upgrade it... slots read 1-12 top to bottom so barb = 1, arch = 2, giant = 3, etc...
Func GetLabCostResult($aCoords)
	SetDebugLog("Getting lab cost")
	SetDebugLog("$iYMidPoint=" & $iYMidPoint)
	Local $iCurSlotOnPage, $iCurSlotsToTheRight, $sCostResult
	$iCurSlotsToTheRight = Ceiling((Int($aCoords[0]) - Int(StringSplit($sLabTroopsSection, ",")[1])) / ($iSlotWidth + $iDistBetweenSlots))
	If Int($aCoords[1]) < $iYMidPoint Then ; first row
		SetDebugLog("First row")
		$iCurSlotOnPage = 2 * $iCurSlotsToTheRight - 1
		SetDebugLog("$iCurSlotOnPage=" & $iCurSlotOnPage)
		$sCostResult = getLabUpgrdResourceWhtNew(Int(StringSplit($sLabTroopsSection, ",")[1]) + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots) + 4, 420 + $g_iMidOffsetY)
		If $sCostResult = "" Then
			Local $XCoord = Int(StringSplit($sLabTroopsSection, ",")[1]) + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots) + 4
			Local $YCoord = 420 + $g_iMidOffsetY
			If QuickMIS("BC1", $g_sImgElixirDrop, $XCoord + 77, $YCoord - 4, $XCoord + 110, $YCoord + 18) Then
				Local $g_iLaboratoryElixirCostOld = $g_iLaboratoryElixirCost
				Local $g_iLaboratoryElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord)
				If $g_iLaboratoryElixirCostNew <= $g_iLaboratoryElixirCostOld Or $g_iLaboratoryElixirCostOld = 0 Then $g_iLaboratoryElixirCost = $g_iLaboratoryElixirCostNew
			Else
				Local $g_iLaboratoryDElixirCostOld = $g_iLaboratoryDElixirCost
				Local $g_iLaboratoryDElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord)
				If $g_iLaboratoryDElixirCostNew <= $g_iLaboratoryDElixirCostOld Or $g_iLaboratoryDElixirCostOld = 0 Then $g_iLaboratoryDElixirCost = $g_iLaboratoryDElixirCostNew
			EndIf
		EndIf
	Else ; second row
		SetDebugLog("Second row")
		$iCurSlotOnPage = 2 * $iCurSlotsToTheRight
		SetDebugLog("$iCurSlotOnPage=" & $iCurSlotOnPage)
		$sCostResult = getLabUpgrdResourceWhtNew(Int(StringSplit($sLabTroopsSection, ",")[1]) + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots) + 4, 543 + $g_iMidOffsetY)
		If $sCostResult = "" Then
			Local $XCoord = Int(StringSplit($sLabTroopsSection, ",")[1]) + ($iCurSlotsToTheRight - 1) * ($iSlotWidth + $iDistBetweenSlots) + 4
			Local $YCoord = 543 + $g_iMidOffsetY
			If QuickMIS("BC1", $g_sImgElixirDrop, $XCoord + 77, $YCoord - 4, $XCoord + 110, $YCoord + 18) Then
				Local $g_iLaboratoryElixirCostOld = $g_iLaboratoryElixirCost
				Local $g_iLaboratoryElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord)
				If $g_iLaboratoryElixirCostNew <= $g_iLaboratoryElixirCostOld Or $g_iLaboratoryElixirCostOld = 0 Then $g_iLaboratoryElixirCost = $g_iLaboratoryElixirCostNew
			Else
				Local $g_iLaboratoryDElixirCostOld = $g_iLaboratoryDElixirCost
				Local $g_iLaboratoryDElixirCostNew = getLabUpgrdResourceRed($XCoord, $YCoord)
				If $g_iLaboratoryDElixirCostNew <= $g_iLaboratoryDElixirCostOld Or $g_iLaboratoryDElixirCostOld = 0 Then $g_iLaboratoryDElixirCost = $g_iLaboratoryDElixirCostNew
			EndIf
		EndIf
	EndIf
	SetDebugLog("Cost found is " & $sCostResult)
	Return $sCostResult
EndFunc   ;==>GetLabCostResult

Func LabNextPage($iCurPage, $iPages, $iYMidPoint)
	If $iCurPage >= $iPages Then Return ; nothing left to scroll
	SetDebugLog("Drag to next full page")
	ClickDrag(720, 480, 100, 480, 10)
EndFunc   ;==>LabNextPage

Func LabPreviousPage($iCurPage, $iPages, $iYMidPoint)
	If $iCurPage <= 1 Then Return ; nothing left to scroll back
	SetDebugLog("Drag to previous full page from page " & $iCurPage)
	; Always drag from left to right to go back pages
	ClickDrag(100, 480, 720, 480, 10)
EndFunc   ;==>LabPreviousPage

Func LabGotoFirstPage()
	SetDebugLog("Going back to first page by closing lab window")
	CloseWindow()
	If _Sleep($DELAYLABORATORY3) Then Return
EndFunc   ;==>LabGotoFirstPage

; #FUNCTION# ===========================================================================================================
; Name ..........: _ReadNormalLabSlotAvailability
; Description ...: Resolves which research slot is free when the village counter displays 1/2.
; Remarks .......: Reads the normal slot in Research without assigning or finishing any upgrade.
; ======================================================================================================================
Func _ReadNormalLabSlotAvailability()
	If Not $g_bRunState Or Not IsMainPage(1) Then Return ""
	Local $sResult = "", $bResearchOpen = False
	Local $aSavedPos = $g_aiLaboratoryPos
	Local $bSavedGoblin = $GobBuilderPresent, $iSavedOffset = $GobBuilderOffsetRunning
	Do
		If Not ImgLocateLab(True, True) Then
			$g_aiLaboratoryPos = $aSavedPos
			If $g_aiLaboratoryPos[0] <= 0 Or $g_aiLaboratoryPos[1] <= 0 Then ExitLoop
			BuildingClickP($g_aiLaboratoryPos, "Lab Slot Check")
			If _Sleep(500) Then ExitLoop
		EndIf
		Local $aResearch = findButton("Research", Default, 1, True)
		If Not IsArray($aResearch) Or UBound($aResearch) <> 2 Then ExitLoop
		ClickP($aResearch, 1, 120, "Lab Slot Check")
		$bResearchOpen = True
		If _Sleep($DELAYLABORATORY1) Then ExitLoop
		$GobBuilderPresent = True
		$GobBuilderOffsetRunning = 375
		For $iAttempt = 1 To 3
			If _IsLabUpgradeStoppedGui() Then
				$sResult = "1#1"
				ExitLoop
			EndIf
			If _IsLabUpgradeRunningGui() Then
				$sResult = "0#1"
				ExitLoop
			EndIf
			If _Sleep(250) Then ExitLoop
		Next
	Until True
	$GobBuilderPresent = $bSavedGoblin
	$GobBuilderOffsetRunning = $iSavedOffset
	If $g_bRunState Then
		If $bResearchOpen Then
			CloseWindow()
		Else
			ClearScreen()
		EndIf
	EndIf
	Return $sResult
EndFunc   ;==>_ReadNormalLabSlotAvailability

Func _LabStatusColorFound($iX, $iY, $sColor, $iVariation = 25, $iRadiusX = 10, $iRadiusY = 10)
	Return IsArray(_PixelSearch($iX - $iRadiusX, $iY - $iRadiusY, $iX + $iRadiusX, $iY + $iRadiusY, $sColor, $iVariation, True))
EndFunc   ;==>_LabStatusColorFound

Func _IsLabUpgradeRunningGui()
	Local $iX = 775 - $GobBuilderOffsetRunning
	Local $iY = ($GobBuilderPresent ? 280 : 135) + $g_iMidOffsetY

	If _LabStatusColorFound($iX, $iY, Hex(0xA1CA6B, 6), 30, 16, 14) Then Return True
	If _LabStatusColorFound($iX, $iY, Hex(0xBED79A, 6), 30, 16, 14) Then Return True
	If _LabStatusColorFound($iX, $iY, Hex(0x8BD43A, 6), 35, 16, 14) Then Return True
	If _LabStatusColorFound($iX, $iY, Hex(0x77C83A, 6), 35, 16, 14) Then Return True

	Return False
EndFunc   ;==>_IsLabUpgradeRunningGui

Func _IsLabUpgradeStoppedGui()
	Local $iX = 775 - $GobBuilderOffsetRunning
	Local $iY = ($GobBuilderPresent ? 280 : 170) + $g_iMidOffsetY

	If _LabStatusColorFound($iX, $iY, Hex(0x8089AF, 6), 28, 16, 14) Then Return True
	If _LabStatusColorFound($iX, $iY, Hex(0x6F789F, 6), 30, 16, 14) Then Return True
	If _LabStatusColorFound($iX, $iY, Hex(0x949BC0, 6), 30, 16, 14) Then Return True

	Return False
EndFunc   ;==>_IsLabUpgradeStoppedGui

; check the lab to see if something is upgrading in the lab already
Func ChkLabUpgradeInProgress($name = "")
	; The regular laboratory idle panel takes priority when the Goblin Researcher
	; is running in the adjacent green panel.
	If _IsLabUpgradeStoppedGui() Then
		SetDebugLog("Regular laboratory is stopped", $COLOR_DEBUG)
		Return False
	EndIf

	; check for upgrade in process - look for green in finish upgrade with gems button
	SetDebugLog("_GetPixelColor(X, Y): " & _GetPixelColor(775 - $GobBuilderOffsetRunning, ($GobBuilderPresent ? 280 : 135) + $g_iMidOffsetY, True) & ":A1CA6B", $COLOR_DEBUG)
	If _IsLabUpgradeRunningGui() Then ; Look for green in the upper right finish-upgrade area of the lab window.
		SetLog("Laboratory upgrade in progress, waiting for completion")
		If _Sleep($DELAYLABORATORY2) Then Return
		; upgrade in process and time not recorded so update completion time!
		If $GobBuilderPresent Then
			Local $sLabTimeOCR = getRemainTLaboratoryGob(245, 205 + $g_iMidOffsetY)
		Else
			Local $sLabTimeOCR = getRemainTLaboratory2(250, 205 + $g_iMidOffsetY)
		EndIf
		Local $iLabFinishTime = 0
		If $sLabTimeOCR <> "" Then $iLabFinishTime = ConvertOCRTime("Lab Time", $sLabTimeOCR, False) + 1
		SetDebugLog("$sLabTimeOCR: " & $sLabTimeOCR & ", $iLabFinishTime = " & $iLabFinishTime & " m")
		If $iLabFinishTime > 0 Then
			$g_sLabUpgradeTime = _DateAdd('n', Ceiling($iLabFinishTime), _NowCalc())
			If @error Then _logErrorDateAdd(@error)
			SetLog("Research will finish in " & $sLabTimeOCR & " (" & $g_sLabUpgradeTime & ")")
			$g_iLaboratoryElixirCost = 0
			$g_iLaboratoryDElixirCost = 0
			LabStatusGUIUpdate() ; Update GUI flag
		ElseIf $g_bDebugSetLog Then
			SetLog("Invalid getRemainTLaboratory OCR", $COLOR_DEBUG)
		EndIf
		If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save") ; saving $asLabUpgradeTime[$g_iCurAccount] = $g_sLabUpgradeTime for instantly displaying in multi-stats
		Return True
	EndIf
	Return False ; returns False if no upgrade in progress
EndFunc   ;==>ChkLabUpgradeInProgress

; checks our global variable to see if we know of something already upgrading
Func ChkUpgradeInProgress()
	Local $TimeDiff ; time remaining on lab upgrade
	If $g_sLabUpgradeTime <> "" Then $TimeDiff = _DateDiff("n", _NowCalc(), $g_sLabUpgradeTime) ; what is difference between end time and now in minutes?
	If @error Then _logErrorDateDiff(@error)
	SetDebugLog($g_avLabTroops[$g_iCmbLaboratory][0] & " Lab end time: " & $g_sLabUpgradeTime & ", DIFF= " & $TimeDiff, $COLOR_DEBUG)

	If Not $g_bRunState Then Return
	If $TimeDiff <= 0 Then
		SetLog("Checking available troop upgrades")
	Else
		SetLog("Laboratory upgrade in progress, waiting for completion")
		$g_iLaboratoryElixirCost = 0
		$g_iLaboratoryDElixirCost = 0
		Return True
	EndIf
	Return False ; we currently do not know of any upgrades in progress
EndFunc   ;==>ChkUpgradeInProgress

; Find Research Button
Func FindResearchButton()
	Local $aResearchButton = findButton("Research", Default, 1, True)
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		If $g_bDebugImageSave Then SaveDebugImage("LabUpgrade") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	EndIf

	$aResearchButton = _FindResearchButtonDynamic()
	If IsArray($aResearchButton) And UBound($aResearchButton, 1) = 2 Then
		SetDebugLog("Laboratory research button found by dynamic fallback")
		If $g_bDebugImageSave Then SaveDebugImage("LabUpgradeDynamic") ; Debug Only
		ClickP($aResearchButton)
		If _Sleep($DELAYLABORATORY1) Then Return ; Wait for window to open
		Return True
	EndIf

	SetLog("Laboratory research button not found!", $COLOR_ERROR)
	ClearScreen()
	Return False
EndFunc   ;==>FindResearchButton

Func _FindResearchButtonDynamic()
	; The Research button shifts when the laboratory is busy/upgrading.
	; Use the green plus badge on the Research slot as an anchor, then click the slot center.
	Local $aSearchArea[4] = [575, 570 + $g_iMidOffsetY, 680, 650 + $g_iMidOffsetY]
	Local $aColors[6] = [Hex(0xA6EF45, 6), Hex(0x94E13B, 6), Hex(0x83D532, 6), Hex(0x76C82F, 6), Hex(0x69BA2A, 6), Hex(0xB5F05D, 6)]
	Local $aPixel = 0

	For $i = 0 To UBound($aColors) - 1
		$aPixel = _PixelSearch($aSearchArea[0], $aSearchArea[1], $aSearchArea[2], $aSearchArea[3], $aColors[$i], 35, True)
		If IsArray($aPixel) Then
			Local $aButton[2] = [Int($aPixel[0]) - 15, Int($aPixel[1]) + 23]
			If $aButton[0] < 575 Then $aButton[0] = 575
			If $aButton[0] > 650 Then $aButton[0] = 650
			If $aButton[1] < 590 + $g_iMidOffsetY Then $aButton[1] = 615 + $g_iMidOffsetY
			If $aButton[1] > 640 + $g_iMidOffsetY Then $aButton[1] = 615 + $g_iMidOffsetY
			SetDebugLog("Dynamic Research button anchor: " & $aPixel[0] & "," & $aPixel[1] & " click: " & $aButton[0] & "," & $aButton[1])
			Return $aButton
		EndIf
	Next

	; Last safe fallback for the shifted Research slot shown while the lab/building is upgrading.
	If _LabStatusColorFound(635, 595 + $g_iMidOffsetY, Hex(0x83D532, 6), 45, 35, 25) Then
		Local $aFallback[2] = [620, 615 + $g_iMidOffsetY]
		SetDebugLog("Dynamic Research button fixed fallback click: " & $aFallback[0] & "," & $aFallback[1])
		Return $aFallback
	EndIf

	Return 0
EndFunc   ;==>_FindResearchButtonDynamic

Func TestLaboratory($iTroopEnum = -1)
	Local $bSingleUpgrade = ($iTroopEnum <> -1)
	Local $sTargetName = "", $sTargetShortName = ""

	If $bSingleUpgrade Then
		Local $iLabIndex = _UTL_GetLabIndex($iTroopEnum)
		If $iLabIndex < 1 Then
			SetLog("[Laboratory Enum]: Not supported (" & $iTroopEnum & ")", $COLOR_ERROR)
			Return False
		EndIf

		$sTargetName = $g_avLabTroops[$iLabIndex][0]
		$sTargetShortName = $g_avLabTroops[$iLabIndex][2]
		SetLog("[Laboratory Test]: " & $sTargetName, $COLOR_INFO)
	Else
		SetLog("[Laboratory Test]: Scanning upgrades", $COLOR_INFO)
	EndIf

	Local $aDetected[UBound($g_avLabTroops, $UBOUND_ROWS)]
	Local $bFound = False

	For $iPage = 1 To $iPages
		Local $aPageUpgrades = findMultiple($g_sImgLabResearch, $sLabTroopsSectionDiam, $sLabTroopsSectionDiam, 0, 1000, 0, "objectname,objectpoints", True)
		If UBound($aPageUpgrades, 1) >= 1 Then
			For $iMatch = 0 To UBound($aPageUpgrades, 1) - 1
				Local $aMatch = $aPageUpgrades[$iMatch]
				Local $sShortName = $aMatch[0]

				If $bSingleUpgrade And $sShortName <> $sTargetShortName Then ContinueLoop

				Local $iDetectedIndex = _UTL_GetLabIndexByShortName($sShortName)
				If $iDetectedIndex < 1 Then ContinueLoop
				If Not $bSingleUpgrade And $aDetected[$iDetectedIndex] Then ContinueLoop

				Local $aCoords = decodeSingleCoord($aMatch[1])
				If Not IsArray($aCoords) Or UBound($aCoords) <> 2 Then ContinueLoop

				Local $sName = $g_avLabTroops[$iDetectedIndex][0]
				SetLog("[Laboratory Image]: " & $sShortName, $COLOR_INFO)
				SetLog("[" & $sName & " Position]: (" & $aCoords[0] & "," & $aCoords[1] & ")", $COLOR_INFO)

				If $bSingleUpgrade Then
					Local $iCost = 0
					Local $sState = _UTL_OpenLabAndReadCost($aCoords, $iCost)
					If $iCost > 0 Then SetLog("[Laboratory Cost]: " & $iCost, $COLOR_INFO)
					Local $iColor = $COLOR_WARNING
					If $sState = "Available" Then $iColor = $COLOR_SUCCESS
					If $sState = "Insufficient Resources" Then $iColor = $COLOR_DEBUG
					SetLog("[" & $sName & " Upgrade]: " & $sState, $iColor)
					Return True
				Else
					; General scan intentionally does not OCR cost or open the troop window.
					$aDetected[$iDetectedIndex] = True
					$bFound = True
				EndIf
			Next
		EndIf

		If $iPage < $iPages Then
			LabNextPage($iPage, $iPages, $iYMidPoint)
			If _Sleep(1000) Then Return False
		EndIf
	Next

	If $bSingleUpgrade Then
		SetLog("[Laboratory Image]: " & $sTargetShortName, $COLOR_INFO)
		SetLog("[" & $sTargetName & " Image]: Not detected", $COLOR_ERROR)
		Return False
	EndIf

	Return $bFound
EndFunc   ;==>TestLaboratory
