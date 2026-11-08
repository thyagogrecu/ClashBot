; #FUNCTION# ===========================================================================================================
; Name ..........: AutoUpgrade
; Author ........: Phael
; Description ...: Dispatches Builder and Laboratory upgrades when available.
; Remarks .......: Called by the main maintenance flow, independently of VillageReport.
; ======================================================================================================================
#include "AutoPetUpgrade.au3"
Func AutoUpgrade()
	If Not $g_bRunState Or (Not $g_bAutoUpgradeEnabled And Not $g_bAutoLabUpgradeAutoEnabled And Not $g_bAutoPetUpgradeEnabled) Then Return 0
	SetLog("Checking Auto Upgrade", $COLOR_INFO)
	If Not _AUpgradeReturnToMenu() Then
		SetLog("AutoUpgrade: Upgrade menu not detected", $COLOR_WARNING)
		Return 0
	EndIf
	Local $iStarted = 0
	If $g_bAutoUpgradeEnabled Then
		Local $bBuilderCountValid = _AUpgradeRefreshMenuBuilders(False)
		Local $iAvailableBuilders = $bBuilderCountValid ? _AUpgradeGetAvailableBuilders() : 0
		SetLog("Available Builders: " & $iAvailableBuilders)
		If $bBuilderCountValid Then SetLog("Reserved Builders: " & _AUpgradeGetReservedBuilders())
		If $bBuilderCountValid And $iAvailableBuilders > 0 Then $iStarted += _AutoUpgradeBuilders($iAvailableBuilders)
	EndIf
	If $g_bAutoLabUpgradeAutoEnabled And $g_bRunState Then $iStarted += AutoLabUpgrade(True)
	If $g_bAutoPetUpgradeEnabled And $g_bRunState Then $iStarted += AutoPetUpgrade(True)
	If $g_bRunState And _AUpgradeMenuVisible() Then CloseWindow()
	If $iStarted > 0 And $g_bRunState And IsMainPage(1) Then
		ZoomOutSimple(Default, Default, Default, True)
		ZoomOut()
	EndIf
	Return $iStarted
EndFunc   ;==>AutoUpgrade

; #FUNCTION# ===========================================================================================================
; Name ..........: _AutoUpgradeBuilders
; Description ...: Starts affordable suggested upgrades until no unreserved builder remains.
; Remarks .......: Called by AutoUpgrade after the main flow reads builder availability.
; ======================================================================================================================

Func _AutoUpgradeBuilders($iInitialAvailableBuilders)
	If Not $g_bRunState Or Not $g_bAutoUpgradeEnabled Then Return 0
	If Not _AUpgradeEnsureBuilderMenuOpen() Then
		SetLog("AutoUpgrade: Upgrade menu not detected", $COLOR_WARNING)
		Return 0
	EndIf
	If $iInitialAvailableBuilders < 1 Then Return 0

	Local $iStarted = 0
	Local $aSkippedSuggestions[0]
	If Not _AUpgradeApplyBuilderFilters(True, False) Then
		SetLog("AutoUpgrade: Could not apply configured filters", $COLOR_ERROR)
		_AUpgradeReturnToMenu()
		Return 0
	EndIf
	SetLog("Filters: " & _AUpgradeFilterName($g_iAutoUpgradeResourceFilter, "Default|Gold|Elixir|Dark") & " | " & _AUpgradeFilterName($g_iAutoUpgradeTypeFilter, "Default|Army|Defense|Hero|Resource|Permanent") & " | " & _AUpgradeFilterName($g_iAutoUpgradeSorting, "Default|Cost Max|Cost Min"), $COLOR_INFO)

	While $g_bRunState
		Local $iAvailableBuilders = _AUpgradeGetAvailableBuilders()
		If $iAvailableBuilders < 1 Then ExitLoop
		If Not _AUpgradeEnsureBuilderMenuOpen() Then ExitLoop
		If Not _AUpgradeClickBuilderMenu() Then ExitLoop
		If _Sleep(450) Then ExitLoop

		Local $aRows = _AUpgradeGetSuggestionRows()
		If Not IsArray($aRows) Then
			SetLog("AutoUpgrade: No visible upgrade suggestion found", $COLOR_WARNING)
			_AUpgradeReturnToMenu()
			ExitLoop
		EndIf

		Local $iStartedBeforeRows = $iStarted, $bStopBuilderScan = False, $bTryNextSuggestion = False
		For $i = 0 To UBound($aRows) - 1
			Local $sSuggestionKey = StringLower($aRows[$i][0]) & "@" & $aRows[$i][2], $bSuggestionSkipped = False
			For $iSkipped = 0 To UBound($aSkippedSuggestions) - 1
				If $aSkippedSuggestions[$iSkipped] = $sSuggestionKey Then
					$bSuggestionSkipped = True
					ExitLoop
				EndIf
			Next
			If $bSuggestionSkipped Then ContinueLoop
			Local $sCostState = _AUpgradeGetCostPixelState($aRows[$i][1], $aRows[$i][2])
			Local $sResourceName = _AUpgradeGetResourceName($aRows[$i][0])
			If $sCostState = "Insufficient" Then
				SetDebugLog($aRows[$i][0] & " - Insufficient Resources", $COLOR_DEBUG)
				SetLog("Upgrade Skipped: " & $sResourceName & " Insufficient", $COLOR_DEBUG)
				ContinueLoop
			EndIf
			If $sCostState <> "Affordable" Then
				SetDebugLog($aRows[$i][0] & " - Cost Color Unknown", $COLOR_DEBUG)
				SetLog("Upgrade Skipped: " & $sResourceName & " Cost Color Unknown", $COLOR_DEBUG)
				ContinueLoop
			EndIf
			Local $iRowX = $aRows[$i][1], $iRowY = $aRows[$i][2]
			Local $sSelectedResource = $sResourceName
			Local $iFreeBuildersBeforeUpgrade = $g_iFreeBuilderCount
			SetDebugLog($aRows[$i][0] & " detected at " & $iRowX & "," & $iRowY, $COLOR_DEBUG)
			Click(Random($iRowX - 3, $iRowX + 3, 1), Random($iRowY - 3, $iRowY + 3, 1), 1, 120, "#AUTOUPGRADE")
			If _Sleep(650) Then
				$bStopBuilderScan = True
				ExitLoop
			EndIf

			If _UST_IsStationUpgradePanelOpen() Then
				SetLog("Craft Station Upgrade Detected", $COLOR_ACTION)
				If UpgradeStation() > 0 Then
					$iStarted += 1
					SetLog("Craft Station Upgrade Started", $COLOR_SUCCESS)
					SetLog("Free Builders Remaining: " & $g_iFreeBuilderCount, $COLOR_SUCCESS)
				EndIf
				$bStopBuilderScan = True
				ExitLoop
			EndIf

			If Not _AUpgradeIsClassicConfirmationOpen() Then
				SetLog("Upgrade Skipped: " & $sSelectedResource & " Screen Not Detected", $COLOR_DEBUG)
				ReDim $aSkippedSuggestions[UBound($aSkippedSuggestions) + 1]
				$aSkippedSuggestions[UBound($aSkippedSuggestions) - 1] = $sSuggestionKey
				_AUpgradeReturnToMenu()
				$bTryNextSuggestion = True
				ExitLoop
			EndIf
			SetLog($sSelectedResource & " Upgrade Selected", $COLOR_ACTION)
			Click(Random(620, 632, 1), Random(548 + $g_iMidOffsetY, 558 + $g_iMidOffsetY, 1), 1, 120, "#AUTOUPGRADE")
			If _Sleep(350) Then ExitLoop
			_AUpgradeHandleTownHallWarning()
			Local $bUpgradeStarted = False, $bConfirmationClosed = False
			For $iConfirmTry = 0 To 4
				If _Sleep(600) Then ExitLoop
				If Not _AUpgradeIsClassicConfirmationOpen() Then
					$bConfirmationClosed = True
					ExitLoop
				EndIf
			Next
			If _AUpgradeReturnToMenu() Then
				For $iBuilderTry = 0 To 4
					If _AUpgradeRefreshMenuBuilders(False) And $g_iFreeBuilderCount < $iFreeBuildersBeforeUpgrade Then
						$bUpgradeStarted = True
						ExitLoop
					EndIf
					If $iBuilderTry < 4 And _Sleep(300) Then ExitLoop
				Next
			EndIf
			If Not $bUpgradeStarted Then
				If Not $bConfirmationClosed Then
					SetLog("AutoUpgrade: Confirmation remained open; upgrade not counted", $COLOR_ERROR)
				Else
					SetLog("AutoUpgrade: Builder count did not confirm the upgrade", $COLOR_ERROR)
				EndIf
				$bStopBuilderScan = True
				ExitLoop
			EndIf

			$iStarted += 1
			SetLog($sSelectedResource & " Upgrade Started", $COLOR_SUCCESS)
			SetLog("Free Builders Remaining: " & $g_iFreeBuilderCount, $COLOR_SUCCESS)
			ExitLoop
		Next
		If $bStopBuilderScan Then ExitLoop
		If $bTryNextSuggestion Then ContinueLoop
		If $iStarted = $iStartedBeforeRows Then ExitLoop
		If Not _AUpgradeEnsureBuilderMenuOpen() Then ExitLoop
	WEnd

	If $iStarted = 0 Then SetLog("No upgrade started")
	If $g_bRunState Then _AUpgradeReturnToMenu()
	Return $iStarted
EndFunc   ;==>_AutoUpgradeBuilders

; #FUNCTION# ===========================================================================================================
; Name ..........: UpgradeStation
; Description ...: Starts an available Craft Station upgrade selected through AutoUpgrade.
; Remarks .......: Checks the currently opened defense first, then falls back to scanning the defense list.
; ======================================================================================================================

Func UpgradeStation()
	If Not _UST_IsStationUpgradePanelOpen() Then Return -1
	Local $aDefenseName[3] = ["Hot Candle", "Hero Hunter", "Cake-A-Pult"]
	Local $aDefenseX[3] = [120, 210, 300]
	Local $aUpgradeY[3] = [203, 300, 397]

	; Let the station detail finish opening before reading the currently selected defense.
	If _Sleep(800) Then Return -1
	Local $iCurrentDefenseResult = _AUpgradeCraftStationTryDefense(_UST_GetSelectedDefenseName(), False)
	If $iCurrentDefenseResult <> 0 Then Return $iCurrentDefenseResult

	If _UST_ReturnToDefensePanel() And _Sleep($DELAYRESPOND) Then Return -1
	For $iDefense = 0 To 2
		If _AUpgradeGetAvailableBuilders() < 1 Then ExitLoop
		Click($aDefenseX[$iDefense], 528 + $g_iMidOffsetY, 1, 120, "#AUTOUPGRADE")
		If _Sleep(800) Then Return -1
		If Not _UST_IsStationPanelOpen() Then ExitLoop
		Local $iDefenseResult = _AUpgradeCraftStationTryDefense($aDefenseName[$iDefense])
		If $iDefenseResult <> 0 Then Return $iDefenseResult
	Next

	SetLog("No Craft Station upgrade available", $COLOR_DEBUG)
	If _UST_IsStationPanelOpen() Then CloseWindow2()
	If _Sleep($DELAYRESPOND) Then Return -1
	Return 0
EndFunc   ;==>UpgradeStation

Func _AUpgradeCraftStationTryDefense($sDefenseName, $bLogState = True)
	Local $aUpgradeY[3] = [203, 300, 397]
	If Not _UST_IsStationPanelOpen() Then Return -1
	Local $iPreselectedUpgrade = -1
	For $iUpgrade = 0 To UBound($aUpgradeY) - 1
		If _UST_IsSelectedUpgradeConfirmation($aUpgradeY[$iUpgrade]) Then
			$iPreselectedUpgrade = $iUpgrade
			ExitLoop
		EndIf
	Next
	Local $iFirstUpgrade = 0, $iLastUpgrade = UBound($aUpgradeY) - 1
	If $iPreselectedUpgrade >= 0 Then
		$iFirstUpgrade = $iPreselectedUpgrade
		$iLastUpgrade = $iPreselectedUpgrade
	EndIf

	For $iUpgrade = $iFirstUpgrade To $iLastUpgrade
		Local $bConfirmationAlreadyOpen = ($iUpgrade = $iPreselectedUpgrade)
		If Not $bConfirmationAlreadyOpen And (_UST_GetButtonResource($aUpgradeY[$iUpgrade]) = "Gem" Or _UST_IsUpgradeRowHighlighted($aUpgradeY[$iUpgrade])) Then
			If $bLogState Then SetLog($sDefenseName & " Upgrade " & ($iUpgrade + 1) & ": Running", $COLOR_INFO)
			ContinueLoop
		EndIf
		If Not $bConfirmationAlreadyOpen And _UST_IsUpgradeMaxLevel($aUpgradeY[$iUpgrade]) Then
			If $bLogState Then SetLog($sDefenseName & " Upgrade " & ($iUpgrade + 1) & ": Max Level", $COLOR_SUCCESS)
			ContinueLoop
		EndIf
		If Not $bConfirmationAlreadyOpen And _UST_IsUpgradeInsufficientResources($aUpgradeY[$iUpgrade]) Then
			If $bLogState Then SetLog($sDefenseName & " Upgrade " & ($iUpgrade + 1) & ": Insufficient Resources", $COLOR_WARNING)
			ContinueLoop
		EndIf
		If Not $bConfirmationAlreadyOpen And Not IsArray(_UST_FindUpgradeButton($aUpgradeY[$iUpgrade])) Then
			If $bLogState And _UST_IsUpgradeButtonDisabled($aUpgradeY[$iUpgrade]) Then SetLog($sDefenseName & " Upgrade " & ($iUpgrade + 1) & ": Unavailable", $COLOR_WARNING)
			ContinueLoop
		EndIf

		Local $aUpgradeDetails = _UST_ReadUpgradeDetails($aUpgradeY[$iUpgrade])
		If Not $bConfirmationAlreadyOpen Then
			Click(752, $aUpgradeY[$iUpgrade] + $g_iMidOffsetY, 1, 120, "#AUTOUPGRADE")
			If _Sleep($DELAYRESPOND * 2) Then Return -1
			Local $bConfirmReady = False
			For $iConfirmTry = 0 To 2
				If _UST_IsUpgradeConfirmReady($aUpgradeY[$iUpgrade]) Then
					$bConfirmReady = True
					ExitLoop
				EndIf
				If $iConfirmTry < 2 And _Sleep(250) Then Return -1
			Next
			If Not $bConfirmReady Then
				SetLog("AutoUpgrade: Craft Station confirmation not detected", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("CraftingStationConfirmNotDetected")
				CloseWindow2()
				Return -1
			EndIf
		EndIf
		If $aUpgradeDetails[0] = "" Or $aUpgradeDetails[1] = "" Then $aUpgradeDetails = _UST_ReadUpgradeDetails($aUpgradeY[$iUpgrade])

		SetLog("Craft Station Upgrade Selected", $COLOR_ACTION)
		If _Sleep(1000) Then Return -1
		Click(752, $aUpgradeY[$iUpgrade] + $g_iMidOffsetY, 1, 120, "#AUTOUPGRADE")
		If _Sleep($DELAYRESPOND * 2) Then Return -1
		If isGemOpen(True) Then
			SetLog("Craft Station upgrade failed! Gem Window popped up!", $COLOR_ERROR)
			Return -1
		EndIf
		If Not _UST_IsStationPanelOpen() Or Not _UST_IsDefensePanelRunning() Then
			SetLog("AutoUpgrade: Craft Station upgrade did not start", $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugImage("CraftingStationUpgradeNotRunning")
			Return -1
		EndIf

		_UST_RegisterUpgradeStats($aUpgradeDetails[0], $aUpgradeDetails[1])
		$g_iFreeBuilderCount -= 1
		CloseWindow2()
		CloseWindow2()
		If _Sleep($DELAYRESPOND) Then Return -1
		_AUpgradeRefreshMenuBuilders(False)
		Return 1
	Next
	Return 0
EndFunc   ;==>_AUpgradeCraftStationTryDefense

; === CRAFT STATION DETECTION ===
Func _UST_IsStationPanelOpen()
	Local $aClose = _PixelSearch(785, 105 + $g_iMidOffsetY, 825, 145 + $g_iMidOffsetY, Hex(0xE85762, 6), 35)
	If Not IsArray($aClose) Then $aClose = _PixelSearch(785, 105 + $g_iMidOffsetY, 825, 145 + $g_iMidOffsetY, Hex(0xF05A64, 6), 45)
	If Not IsArray($aClose) Then $aClose = _PixelSearch(785, 105 + $g_iMidOffsetY, 825, 145 + $g_iMidOffsetY, Hex(0xF38E8D, 6), 45)
	If Not IsArray($aClose) Then $aClose = _PixelSearch(785, 105 + $g_iMidOffsetY, 825, 145 + $g_iMidOffsetY, Hex(0xF02227, 6), 35)
	Return IsArray($aClose)
EndFunc   ;==>_UST_IsStationPanelOpen

Func _UST_IsStationUpgradePanelOpen()
	If Not _UST_IsStationPanelOpen() Then Return False
	Local $aOverview = _PixelSearch(735, 550 + $g_iMidOffsetY, 795, 600 + $g_iMidOffsetY, Hex(0x8BD43A, 6), 25)
	Return IsArray($aOverview)
EndFunc   ;==>_UST_IsStationUpgradePanelOpen

Func _UST_ReturnToDefensePanel()
	If Not _UST_IsDefenseDetailPanelOpen() Then Return False
	Click(75, 132, 1, 120, "#AUTOUPGRADE")
	Return True
EndFunc   ;==>_UST_ReturnToDefensePanel

Func _UST_IsDefenseDetailPanelOpen()
	Return IsArray(_PixelSearch(35, 105, 115, 160, Hex(0x8BD43A, 6), 35))
EndFunc   ;==>_UST_IsDefenseDetailPanelOpen

Func _UST_GetSelectedDefenseName()
	Local $aDefenseName[3] = ["Hot Candle", "Hero Hunter", "Cake-A-Pult"]
	Local $aCheckLeft[3] = [140, 225, 315]
	Local $aCheckRight[3] = [161, 251, 344]
	For $iDefense = 0 To 2
		If IsArray(_PixelSearch($aCheckLeft[$iDefense], 512 + $g_iMidOffsetY, $aCheckRight[$iDefense], 540 + $g_iMidOffsetY, Hex(0x8FE41C, 6), 45)) Then Return $aDefenseName[$iDefense]
	Next
	Return "Current Defense"
EndFunc   ;==>_UST_GetSelectedDefenseName

Func _UST_FindUpgradeButton($iButtonY)
	Local $iTop = $iButtonY - 22 + $g_iMidOffsetY
	Local $iBottom = $iButtonY + 22 + $g_iMidOffsetY
	Local $aButton = _PixelSearch(700, $iTop, 810, $iBottom, Hex(0x77C83A, 6), 40)
	If Not IsArray($aButton) Then $aButton = _PixelSearch(700, $iTop, 810, $iBottom, Hex(0x8ED94A, 6), 40)
	If Not IsArray($aButton) Then $aButton = _PixelSearch(700, $iTop, 810, $iBottom, Hex(0xB7EA62, 6), 40)
	If Not IsArray($aButton) Then $aButton = _PixelSearch(700, $iTop, 810, $iBottom, Hex(0x9DE54F, 6), 40)
	If Not IsArray($aButton) Then $aButton = _PixelSearch(700, $iTop, 810, $iBottom, Hex(0x5BAF27, 6), 40)
	Return $aButton
EndFunc   ;==>_UST_FindUpgradeButton

Func _UST_IsUpgradeMaxLevel($iButtonY)
	Local $aMaxLevel = decodeSingleCoord(FindImageInPlace2("StationMaxLevel", $ImgHeroMaxLevel, 630, $iButtonY - 30 + $g_iMidOffsetY, 820, $iButtonY + 30 + $g_iMidOffsetY, True))
	If IsArray($aMaxLevel) And UBound($aMaxLevel) = 2 Then Return True
	Local $iY = $iButtonY + $g_iMidOffsetY
	Local $aLeft = _PixelSearch(580, $iY - 18, 650, $iY + 18, Hex(0xFFD44A, 6), 18)
	Local $aRight = _PixelSearch(700, $iY - 18, 780, $iY + 18, Hex(0xFFD44A, 6), 18)
	Return IsArray($aLeft) And IsArray($aRight)
EndFunc   ;==>_UST_IsUpgradeMaxLevel

Func _UST_IsUpgradeButtonDisabled($iButtonY)
	Local $iY = $iButtonY + $g_iMidOffsetY
	Local $aDisabled = _PixelSearch(700, $iY - 15, 765, $iY + 15, Hex(0xD6D6D6, 6), 10)
	If Not IsArray($aDisabled) Then $aDisabled = _PixelSearch(700, $iY - 15, 765, $iY + 15, Hex(0xAFAFAF, 6), 10)
	Return IsArray($aDisabled) And Not IsArray(_UST_FindUpgradeButton($iButtonY))
EndFunc   ;==>_UST_IsUpgradeButtonDisabled

Func _UST_IsUpgradeInsufficientResources($iButtonY)
	Local $iY = $iButtonY + $g_iMidOffsetY
	Return IsArray(_PixelSearch(700, $iY - 5, 790, $iY + 15, Hex(0xFF887F, 6), 18))
EndFunc   ;==>_UST_IsUpgradeInsufficientResources

Func _UST_IsUpgradeRowHighlighted($iButtonY)
	Local $iTop = $iButtonY - 10 + $g_iMidOffsetY
	Local $iBottom = $iButtonY + 10 + $g_iMidOffsetY
	Local $aHighlight = _PixelSearch(635, $iTop, 695, $iBottom, Hex(0x9CE31C, 6), 30)
	If Not IsArray($aHighlight) Then $aHighlight = _PixelSearch(635, $iTop, 695, $iBottom, Hex(0xAEEB2A, 6), 30)
	If Not IsArray($aHighlight) Then $aHighlight = _PixelSearch(635, $iTop, 695, $iBottom, Hex(0x8FD514, 6), 30)
	If Not IsArray($aHighlight) Then $aHighlight = _PixelSearch(635, $iTop, 695, $iBottom, Hex(0xBDF23C, 6), 30)
	Return IsArray($aHighlight)
EndFunc   ;==>_UST_IsUpgradeRowHighlighted

Func _UST_IsDefensePanelRunning()
	Local $aUpgradeY[3] = [203, 300, 397]
	For $iUpgrade = 0 To 2
		If _UST_GetButtonResource($aUpgradeY[$iUpgrade]) = "Gem" Then Return True
		If _UST_IsUpgradeRowHighlighted($aUpgradeY[$iUpgrade]) Then Return True
	Next
	Return False
EndFunc   ;==>_UST_IsDefensePanelRunning

Func _UST_GetButtonResource($iButtonY)
	Local $iTop = $iButtonY - 22 + $g_iMidOffsetY
	Local $iBottom = $iButtonY + 22 + $g_iMidOffsetY
	Local $sResource = QuickMIS("N1", $g_sImgResourceIcon, 760, $iTop, 815, $iBottom)
	If $sResource = "Gem" Then Return $sResource
	$sResource = QuickMIS("N1", $g_sImgAUpgradeRes, 760, $iTop, 815, $iBottom)
	Return $sResource
EndFunc   ;==>_UST_GetButtonResource

Func _UST_IsUpgradeConfirmReady($iButtonY)
	If Not _UST_IsStationPanelOpen() Then Return False
	Local $aBack = _PixelSearch(35, 105, 115, 160, Hex(0x8BD43A, 6), 35)
	Return IsArray($aBack) And IsArray(_UST_FindUpgradeButton($iButtonY))
EndFunc   ;==>_UST_IsUpgradeConfirmReady

Func _UST_IsSelectedUpgradeConfirmation($iButtonY)
	If Not _UST_IsDefenseDetailPanelOpen() Then Return False
	If Not _UST_IsUpgradeRowHighlighted($iButtonY) Then Return False
	If _UST_GetButtonResource($iButtonY) = "Gem" Then Return False
	Return IsArray(_UST_FindUpgradeButton($iButtonY))
EndFunc   ;==>_UST_IsSelectedUpgradeConfirmation

Func _UST_ReadUpgradeDetails($iButtonY)
	Local $aDetails[2] = ["", ""]
	Local $iTop = $iButtonY - 24 + $g_iMidOffsetY
	Local $iBottom = $iButtonY + 24 + $g_iMidOffsetY
	$aDetails[0] = QuickMIS("N1", $g_sImgAUpgradeRes, 680, $iTop, 815, $iBottom)
	If $aDetails[0] = "none" Or $aDetails[0] = -1 Then $aDetails[0] = ""
	$aDetails[1] = getCostsUpgrade(690, $iButtonY - 9 + $g_iMidOffsetY)
	If $aDetails[1] = "" Then $aDetails[1] = getCostsUpgrade(700, $iButtonY - 9 + $g_iMidOffsetY)
	If $aDetails[1] = "" Then $aDetails[1] = getCostsUpgrade(680, $iButtonY - 9 + $g_iMidOffsetY)
	Return $aDetails
EndFunc   ;==>_UST_ReadUpgradeDetails

Func _UST_RegisterUpgradeStats($sResource, $iCost)
	Switch $sResource
		Case "Gold"
			$g_iNbrOfBuildingsUppedGold += 1
			$g_iCostGoldBuilding += Number($iCost)
		Case "Elixir"
			$g_iNbrOfBuildingsUppedElixir += 1
			$g_iCostElixirBuilding += Number($iCost)
		Case "Dark Elixir", "DarkElixir"
			$g_iNbrOfBuildingsUppedDElixir += 1
			$g_iCostDElixirBuilding += Number($iCost)
		Case Else
			SetDebugLog("Craft Station stats skipped: resource not detected", $COLOR_DEBUG)
			Return
	EndSwitch
	If Number($iCost) <= 0 Then SetDebugLog("Craft Station upgrade cost not detected", $COLOR_DEBUG)
	UpdateStats()
EndFunc   ;==>_UST_RegisterUpgradeStats

; #FUNCTION# ===========================================================================================================
; Name ..........: AutoLabUpgrade
; Description ...: Starts one affordable suggested upgrade in the Laboratory.
; Remarks .......: Dispatched by AutoUpgrade when the Laboratory is available.
; ======================================================================================================================

Func AutoLabUpgrade($bKeepMenuOpen = False)
	If Not $g_bRunState Or Not $g_bAutoLabUpgradeAutoEnabled Then Return 0
	Local $iStarted = _AutoLabUpgradeMenu()
	If $g_bRunState And _AUpgradeReturnToMenu() And Not $bKeepMenuOpen Then CloseWindow()
	Return $iStarted
EndFunc   ;==>AutoLabUpgrade

; #FUNCTION# ===========================================================================================================
; Name ..........: _AutoLabUpgradeMenu
; Description ...: Runs Laboratory upgrades within the shared upgrade menu session.
; ======================================================================================================================
Func _AutoLabUpgradeMenu()
	If Not $g_bRunState Or Not $g_bAutoLabUpgradeAutoEnabled Then Return 0
	If Not _AUpgradeEnsureBuilderMenuOpen() Then
		SetLog("AutoLabUpgrade: Upgrade menu not detected", $COLOR_WARNING)
		Return 0
	EndIf

	Local $sLabCount = _AUpgradeMenuLabAvailability()
	If $sLabCount = "0#1" Or $sLabCount = "1#1" Then SetLog("Available Research: " & StringLeft($sLabCount, 1))
	If $sLabCount <> "1#1" Then
		If $sLabCount = "" Then
			SetLog("AutoLabUpgrade: Laboratory availability not detected", $COLOR_WARNING)

		EndIf
		Return 0
	EndIf
	SetLog("Checking Auto Lab Upgrade", $COLOR_INFO)

	If Not _AUpgradeApplyLabFilters(True, False) Then
		SetLog("AutoLabUpgrade: Could not apply configured filters", $COLOR_ERROR)
		_AUpgradeReturnToMenu()
		Return 0
	EndIf
	Local $iResourceFilter = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeResource)
	Local $iTypeFilter = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeType)
	Local $iSortingFilter = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeSorting)
	If $iResourceFilter < 0 Or $iResourceFilter > 2 Then $iResourceFilter = 0
	If $iTypeFilter < 0 Or $iTypeFilter > 3 Then $iTypeFilter = 0
	If $iSortingFilter < 0 Or $iSortingFilter > 2 Then $iSortingFilter = 0
	SetLog("Filters: " & _AUpgradeFilterName($iResourceFilter, "Default|Elixir|Dark") & " | " & _AUpgradeFilterName($iTypeFilter, "Default|Troops|Spells|Sieges") & " | " & _AUpgradeFilterName($iSortingFilter, "Default|Cost Max|Cost Min"), $COLOR_INFO)
	If _Sleep(350) Then Return 0

	Local $aRows = _AUpgradeGetSuggestionRows()
	If Not IsArray($aRows) Then
		SetLog("AutoLabUpgrade: No visible Laboratory upgrade suggestion found", $COLOR_WARNING)
		_AUpgradeReturnToMenu()
		Return 0
	EndIf

	Local $iRow = -1
	For $i = 0 To UBound($aRows) - 1
		Local $sResource = StringLower($aRows[$i][0])
		If StringLeft($sResource, 6) <> "elixir" And StringLeft($sResource, 4) <> "dark" Then ContinueLoop
		Local $sCostState = _AUpgradeGetCostPixelState($aRows[$i][1], $aRows[$i][2])
		Local $sResourceName = StringLeft($sResource, 4) = "dark" ? "Dark" : "Elixir"
		If $sCostState = "Insufficient" Then
			SetDebugLog($sResourceName & " - Insufficient Resources", $COLOR_DEBUG)
			SetLog("Upgrade Skipped: " & $sResourceName & " Insufficient", $COLOR_DEBUG)
			ContinueLoop
		EndIf
		If $sCostState <> "Affordable" Then
			SetDebugLog($sResourceName & " - Cost Color Unknown", $COLOR_DEBUG)
			SetLog("Upgrade Skipped: " & $sResourceName & " Cost Color Unknown", $COLOR_DEBUG)
			ContinueLoop
		EndIf
		$iRow = $i
		ExitLoop
	Next
	If $iRow < 0 Then
		SetLog("No upgrade started")
		_AUpgradeReturnToMenu()
		Return 0
	EndIf

	Local $iRowX = $aRows[$iRow][1], $iRowY = $aRows[$iRow][2] - 12
	Local $sResource = StringLower($aRows[$iRow][0])
	Local $sSelectedResource = StringLeft($sResource, 4) = "dark" ? "Dark" : "Elixir"
	SetDebugLog($aRows[$iRow][0] & " detected at " & $iRowX & "," & $iRowY, $COLOR_DEBUG)
	SetLog($sSelectedResource & " Upgrade Selected", $COLOR_ACTION)
	Click(Random($iRowX - 3, $iRowX + 3, 1), Random($iRowY - 3, $iRowY + 3, 1), 1, 120, "#AUTOLABUPGRADE")
	If _Sleep(650) Then Return 0

	If Not _AUpgradeIsClassicConfirmationOpen() Then
		SetLog("AutoLabUpgrade: Laboratory upgrade confirmation not detected", $COLOR_ERROR)
		_AUpgradeReturnToMenu()
		Return 0
	EndIf

	Click(Random(620, 632, 1), Random(548 + $g_iMidOffsetY, 558 + $g_iMidOffsetY, 1), 1, 120, "#AUTOLABUPGRADE")
	Local $bWaitAborted = _Sleep(750)
	_AUpgradeReturnToMenu()
	If $bWaitAborted Then Return 0

	Local $sLabCountAfterUpgrade = _AUpgradeMenuLabAvailability()
	If $sLabCountAfterUpgrade <> "0#1" Then
		SetLog("AutoLabUpgrade: Upgrade not registered; Laboratory remains available", $COLOR_ERROR)
		Return 0
	EndIf

	SetLog($sSelectedResource & " Upgrade Started", $COLOR_SUCCESS)
	SetLog("Laboratory Available: 0/1", $COLOR_SUCCESS)
	Return 1
EndFunc   ;==>_AutoLabUpgradeMenu

Func _AUpgradeGetAvailableBuilders()
	Local $iAvailableBuilders = $g_iFreeBuilderCount - _AUpgradeGetReservedBuilders()
	Return $iAvailableBuilders > 0 ? $iAvailableBuilders : 0
EndFunc   ;==>_AUpgradeGetAvailableBuilders

Func _AUpgradeGetReservedBuilders()
	Return ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) + ReservedBuildersForBuildings(False) + ReservedBuildersForHeroes(False)
EndFunc   ;==>_AUpgradeGetReservedBuilders

Func _AUpgradeGetResourceName($sImageName)
	Local $sResource = StringLower($sImageName)
	If StringLeft($sResource, 4) = "gold" Then Return "Gold"
	If StringLeft($sResource, 6) = "elixir" Then Return "Elixir"
	If StringLeft($sResource, 4) = "dark" Then Return "Dark Elixir"
	Return "Resource"
EndFunc   ;==>_AUpgradeGetResourceName
Func _AUpgradeEnsureBuilderMenuOpen()
	For $iTry = 0 To 1
		If Not $g_bRunState Then Return False
		If _AUpgradeMenuVisible() Then Return True
		If Not IsMainPage(1) Then Return False
		If Not _AUpgradeClickImage($g_sImgAUpgradeBuild, 750, 620, 855, 710, "#AUBUILD") Then Return False
		If _Sleep(700) Then Return False
	Next
	Return _AUpgradeMenuVisible()
EndFunc   ;==>_AUpgradeEnsureBuilderMenuOpen

Func _AUpgradeClickBuilderMenu()
	Click(544, $g_iGAME_HEIGHT - 58, 1, 120, "#AUBUILDER")
	If _Sleep(350) Then Return False
	Return QuickMIS("BFI", $g_sImgAUpgradeMenu & "Titles\BuilderMenuTitle*", 580, 0, 790, 50)
EndFunc   ;==>_AUpgradeClickBuilderMenu

Func _AUpgradeClickImage($sImage, $iLeft, $iTop, $iRight, $iBottom, $sClickTag)
	If Not QuickMIS("BFI", $sImage, $iLeft, $iTop, $iRight, $iBottom) Then Return False
	Click(Random($g_iQuickMISX - 3, $g_iQuickMISX + 3, 1), Random($g_iQuickMISY - 3, $g_iQuickMISY + 3, 1), 1, 120, $sClickTag)
	Return True
EndFunc   ;==>_AUpgradeClickImage

Func _AUpgradeFilterPanelOpen()
	Return IsArray(_PixelSearch(140, 68, 146, 74, Hex(0x7F5C3E, 6), 12))
EndFunc   ;==>_AUpgradeFilterPanelOpen

Func _AUpgradeIsClassicConfirmationOpen()
	If Not IsArray(_PixelSearch(794, 112 + $g_iMidOffsetY, 820, 154 + $g_iMidOffsetY, Hex(0xF02227, 6), 55)) Then Return False
	Return IsArray(_PixelSearch(550, 508 + $g_iMidOffsetY, 706, 578 + $g_iMidOffsetY, Hex(0x8BD43A, 6), 30))
EndFunc   ;==>_AUpgradeIsClassicConfirmationOpen

Func _AUpgradeHandleTownHallWarning()
	Local $aContinueButton = findButton("Continue", Default, 1, True, False, False)
	If Not IsArray($aContinueButton) Or UBound($aContinueButton) < 2 Then Return False
	SetLog("Town Hall upgrade warning detected", $COLOR_INFO)
	ClickP($aContinueButton, 1, 120, "#AUTOUPGRADE")
	If _Sleep(800) Then Return False
	SetLog("Town Hall upgrade warning confirmed", $COLOR_SUCCESS)
	Return True
EndFunc   ;==>_AUpgradeHandleTownHallWarning

Func _AUpgradeFilterOptionSelected($iX, $iY)
	Return IsArray(_PixelSearch($iX + 7, $iY + 6, $iX + 18, $iY + 22, Hex(0xE7A11F, 6), 38))
EndFunc   ;==>_AUpgradeFilterOptionSelected

Func _AUpgradeApplyFilterGroup($aX, $aY, $iSelected)
	For $i = 0 To UBound($aX) - 1
		Local $bActive = _AUpgradeFilterOptionSelected($aX[$i], $aY[$i])
		If ($i = $iSelected And Not $bActive) Or ($i <> $iSelected And $bActive) Then
			Click(Random($aX[$i] + 57, $aX[$i] + 67, 1), Random($aY[$i] + 17, $aY[$i] + 27, 1), 1, 120, "#AUFILTER")
			If _Sleep(180) Then Return False
			Local $bNowActive = _AUpgradeFilterOptionSelected($aX[$i], $aY[$i])
			If $bNowActive <> ($i = $iSelected) Then
				SetLog("Upgrade filter selection could not be verified", $COLOR_ERROR)
				Return False
			EndIf
		EndIf
	Next
	Return True
EndFunc   ;==>_AUpgradeApplyFilterGroup

Func _AUpgradeFilterName($iIndex, $sNames)
	Local $aNames = StringSplit($sNames, "|", 2)
	If $iIndex < 0 Or $iIndex >= UBound($aNames) Then Return "Default"
	Return $aNames[$iIndex]
EndFunc   ;==>_AUpgradeFilterName

Func _AUpgradeGetSuggestionRows()
	Local $aFoundRows = QuickMIS("CNX", $g_sImgAUpgradeMenu & "Resources\", 780, 50 + $g_iMidOffsetY, 859, 650 + $g_iMidOffsetY)
	If Not IsArray($aFoundRows) Then Return -1
	_ArraySort($aFoundRows, 0, 0, 0, 2)
	Local $aRows[0][4]
	For $iRow = 0 To UBound($aFoundRows) - 1
		Local $sResource = StringLower($aFoundRows[$iRow][0])
		Local $sResourceType = ""
		If StringLeft($sResource, 4) = "gold" Then
			$sResourceType = "gold"
		ElseIf StringLeft($sResource, 6) = "elixir" Then
			$sResourceType = "elixir"
		ElseIf StringLeft($sResource, 4) = "dark" Then
			$sResourceType = "dark"
		EndIf
		If $sResourceType = "" Then ContinueLoop
		If StringLeft($sResource, 6) = "goldbb" Or StringLeft($sResource, 8) = "elixirbb" Then ContinueLoop
		SetDebugLog("AutoUpgrade raw icon match: " & $aFoundRows[$iRow][0] & " at " & $aFoundRows[$iRow][1] & "," & $aFoundRows[$iRow][2], $COLOR_DEBUG)
		If _AUpgradeIsNewSuggestion(Number($aFoundRows[$iRow][2])) Then
			SetDebugLog("AutoUpgrade skipped green New suggestion at " & $aFoundRows[$iRow][1] & "," & $aFoundRows[$iRow][2], $COLOR_DEBUG)
			ContinueLoop
		EndIf
		Local $bDuplicateRow = False
		For $iExisting = 0 To UBound($aRows) - 1
			Local $sExistingResource = StringLower($aRows[$iExisting][0])
			If StringLeft($sExistingResource, StringLen($sResourceType)) = $sResourceType And Abs(Number($aRows[$iExisting][2]) - Number($aFoundRows[$iRow][2])) <= 24 Then
				$bDuplicateRow = True
				ExitLoop
			EndIf
		Next
		If $bDuplicateRow Then ContinueLoop
		ReDim $aRows[UBound($aRows) + 1][4]
		For $iColumn = 0 To 3
			$aRows[UBound($aRows) - 1][$iColumn] = $aFoundRows[$iRow][$iColumn]
		Next
	Next
	If UBound($aRows) = 0 Then Return -1
	For $iRow = 0 To UBound($aRows) - 1
		SetDebugLog("AutoUpgrade cascade row " & ($iRow + 1) & ": " & $aRows[$iRow][0] & " at " & $aRows[$iRow][1] & "," & $aRows[$iRow][2], $COLOR_DEBUG)
	Next
	Return $aRows
EndFunc   ;==>_AUpgradeGetSuggestionRows

Func _AUpgradeIsNewSuggestion($iRowY)
	; New upgrade names use bright green text; regular suggestions use white text.
	Local $aGreenName = _PixelSearch(555, $iRowY - 24, 700, $iRowY + 16, Hex(0xB4F756, 6), 38)
	Return IsArray($aGreenName)
EndFunc   ;==>_AUpgradeIsNewSuggestion

Func _AUpgradeGetCostPixelState($iRowX, $iRowY)
	Local $iCostX = $iRowX - 130
	Local $iCostY = $iRowY - 9
	Local $aRedCost = _PixelSearch($iCostX, $iCostY, $iCostX + 119, $iCostY + 17, Hex(0xFF887F, 6), 24)
	If IsArray($aRedCost) Then Return "Insufficient"
	Local $aWhiteCost = _PixelSearch($iCostX, $iCostY, $iCostX + 119, $iCostY + 17, Hex(0xFFFFFF, 6), 24)
	If IsArray($aWhiteCost) Then Return "Affordable"
	Return "Unknown"
EndFunc   ;==>_AUpgradeGetCostPixelState

Func _AUpgradeSuggestionPosition($iRow)
	Switch $iRow + 1
		Case 1
			Return "First Available"
		Case 2
			Return "Second Available"
		Case 3
			Return "Third Available"
		Case Else
			Return "Suggestion #" & ($iRow + 1)
	EndSwitch
EndFunc   ;==>_AUpgradeSuggestionPosition

; === TEST FUNCTIONS ===
; #FUNCTION# ===========================================================================================================
; Name ..........: TestAutoUpgrade
; Description ...: Tests upgrade suggestion detection and confirmation screen classification.
; Remarks .......: Stops before final confirmation; $bConfirm is retained only for call compatibility.
; ======================================================================================================================

Func TestAutoUpgrade($bConfirm = False)
	If Not _AUpgradeReturnToMenu() Then Return False
	If Not TestAutoUpgradeFilter() Then Return False
	If _Sleep(350) Then Return False

	Local $aRows = _AUpgradeGetSuggestionRows()
	If Not IsArray($aRows) Then
		SetLog("TestAutoUpgrade: No visible upgrade suggestion found", $COLOR_ERROR)
		Return False
	EndIf
	Local $iRow = -1
	For $i = 0 To UBound($aRows) - 1
		If StringLower($aRows[$i][0]) = "gem" Then ContinueLoop
		Local $sCostState = _AUpgradeGetCostPixelState($aRows[$i][1], $aRows[$i][2])
		If $sCostState = "Insufficient" Then
			SetLog("[Upgrade Skipped]: " & $aRows[$i][0] & " - Insufficient Resources", $COLOR_WARNING)
			ContinueLoop
		EndIf
		If $sCostState = "Unknown" Then
			SetLog("[Upgrade Skipped]: " & $aRows[$i][0] & " - Cost Color Unknown", $COLOR_WARNING)
			ContinueLoop
		EndIf
		$iRow = $i
		ExitLoop
	Next
	If $iRow < 0 Then
		SetLog("TestAutoUpgrade: No affordable upgrade with a white cost detected", $COLOR_ERROR)
		Return False
	EndIf
	Local $sSuggestionPosition = _AUpgradeSuggestionPosition($iRow)
	Local $iRowX = $aRows[$iRow][1], $iRowY = $aRows[$iRow][2]
	SetLog("[Upgrade Icon]: " & $aRows[$iRow][0] & " detected at " & $iRowX & "," & $iRowY, $COLOR_INFO)
	Click(Random($iRowX - 3, $iRowX + 3, 1), Random($iRowY - 3, $iRowY + 3, 1), 1, 120, "#AUTEST")
	If _Sleep(650) Then Return False

	If _UST_IsStationUpgradePanelOpen() Then
		SetLog("[Suggestion Selected]: " & $sSuggestionPosition, $COLOR_INFO)
		Return TestAutoUpgradeStation()
	EndIf

	If _AUpgradeIsClassicConfirmationOpen() Then
		SetLog("[Suggestion Selected]: " & $sSuggestionPosition, $COLOR_INFO)
		SetLog("[Upgrade Screen]: Classic Upgrade", $COLOR_INFO)
		SetLog("Classic upgrade confirmation detected", $COLOR_INFO)
		SetLog("Upgrade not started; test stopped before confirmation", $COLOR_INFO)
		Return True
	EndIf

	SetLog("[Suggestion Selected]: " & $sSuggestionPosition, $COLOR_INFO)
	SetLog("[Upgrade Type]: Unresolved", $COLOR_WARNING)
	SetLog("TestAutoUpgrade: Neither classic confirmation nor Crafting Station screen detected", $COLOR_ERROR)
	Return False
EndFunc   ;==>TestAutoUpgrade

; #FUNCTION# ===========================================================================================================
; Name ..........: TestAutoUpgradeStation
; Description ...: Detects an available Crafting Station upgrade without confirming it.
; Remarks .......: Requires the Crafting Station upgrade screen to be open; ignores GUI option checkboxes.
; ======================================================================================================================

Func TestAutoUpgradeStation()
	If Not _UST_IsStationUpgradePanelOpen() Then
		SetLog("TestAutoUpgradeStation: Craft Station screen not detected", $COLOR_ERROR)
		Return False
	EndIf
	SetLog("[Upgrade Screen]: Craft Station", $COLOR_INFO)
	SetLog("Craft Station upgrade screen detected", $COLOR_WARNING)
	Local $aDefenseName[3] = ["Hot Candle", "Hero Hunter", "Cake-A-Pult"]
	Local $aDefenseX[3] = [120, 210, 300]

	; Let the station detail finish opening before reading the currently selected defense.
	If _Sleep(800) Then Return False
	Local $sSelectedDefense = _UST_GetSelectedDefenseName()
	Local $iCurrentResult = _AUpgradeTestCraftStationPanel($sSelectedDefense)
	If $iCurrentResult > 0 Then Return True
	If $iCurrentResult < 0 Then Return False
	If _UST_ReturnToDefensePanel() And _Sleep($DELAYRESPOND) Then Return False

	For $iDefense = 0 To 2
		Click($aDefenseX[$iDefense], 528 + $g_iMidOffsetY, 1, 120, "#AUTESTSTATION")
		If _Sleep(800) Then Return False
		If Not _UST_IsStationPanelOpen() Then
			SetLog("TestAutoUpgradeStation: Station screen lost while scanning", $COLOR_ERROR)
			Return False
		EndIf
		Local $iDefenseResult = _AUpgradeTestCraftStationPanel($aDefenseName[$iDefense])
		If $iDefenseResult > 0 Then Return True
		If $iDefenseResult < 0 Then Return False
	Next
	SetLog("TestAutoUpgradeStation: No affordable Craft Station upgrade found", $COLOR_WARNING)
	Return False
EndFunc   ;==>TestAutoUpgradeStation

Func _AUpgradeTestCraftStationPanel($sDefenseName)
	Local $aUpgradeY[3] = [203, 300, 397]
	If Not _UST_IsStationPanelOpen() Then Return -1
	For $iUpgrade = 0 To UBound($aUpgradeY) - 1
		If _UST_IsSelectedUpgradeConfirmation($aUpgradeY[$iUpgrade]) Then
			SetLog("[Craft Station Upgrade]: " & $sDefenseName & " Upgrade " & ($iUpgrade + 1) & " Detected", $COLOR_INFO)
			SetLog("Craft Station upgrade confirmation detected", $COLOR_WARNING)
			SetLog("Upgrade not started; test stopped before confirmation", $COLOR_WARNING)
			Return 1
		EndIf
	Next

	For $iUpgrade = 0 To 2
		If _UST_GetButtonResource($aUpgradeY[$iUpgrade]) = "Gem" Or _UST_IsUpgradeRowHighlighted($aUpgradeY[$iUpgrade]) Then
			SetLog($sDefenseName & " Upgrade " & ($iUpgrade + 1) & ": Running", $COLOR_INFO)
			ContinueLoop
		EndIf
		If _UST_IsUpgradeMaxLevel($aUpgradeY[$iUpgrade]) Then
			SetLog($sDefenseName & " Upgrade " & ($iUpgrade + 1) & ": Max Level", $COLOR_SUCCESS)
			ContinueLoop
		EndIf
		If _UST_IsUpgradeInsufficientResources($aUpgradeY[$iUpgrade]) Then
			SetLog($sDefenseName & " Upgrade " & ($iUpgrade + 1) & ": Insufficient Resources", $COLOR_DEBUG)
			ContinueLoop
		EndIf
		If Not IsArray(_UST_FindUpgradeButton($aUpgradeY[$iUpgrade])) Then ContinueLoop

		Click(752, $aUpgradeY[$iUpgrade] + $g_iMidOffsetY, 1, 120, "#AUTESTSTATION")
		If _Sleep($DELAYRESPOND * 2) Then Return -1
		Local $bConfirmDetected = False
		For $iConfirmTry = 0 To 2
			If _UST_IsUpgradeConfirmReady($aUpgradeY[$iUpgrade]) Then
				$bConfirmDetected = True
				ExitLoop
			EndIf
			If $iConfirmTry < 2 And _Sleep(250) Then Return -1
		Next
		If Not $bConfirmDetected Then
			SetLog("TestAutoUpgradeStation: Upgrade confirmation not detected", $COLOR_ERROR)
			Return -1
		EndIf

		SetLog("[Craft Station Upgrade]: " & $sDefenseName & " Upgrade " & ($iUpgrade + 1) & " Detected", $COLOR_INFO)
		SetLog("Craft Station upgrade confirmation detected", $COLOR_WARNING)
		SetLog("Upgrade not started; test stopped before confirmation", $COLOR_WARNING)
		Return 1
	Next
	Return 0
EndFunc   ;==>_AUpgradeTestCraftStationPanel

; #FUNCTION# ===========================================================================================================
; Name ..........: TestUpgradeStation
; Description ...: Reads every upgrade option for each Craft Station defense.
; Remarks .......: Requires the Craft Station screen to be open; does not select or confirm upgrades.
; ======================================================================================================================

Func TestUpgradeStation()
	If Not _UST_IsStationPanelOpen() Then
		SetLog("TestUpgradeStation: Craft Station screen not detected", $COLOR_ERROR)
		Return False
	EndIf

	Local $aDefenseName[3] = ["Hot Candle", "Hero Hunter", "Cake-A-Pult"]
	Local $aDefenseX[3] = [120, 210, 300]
	Local $aUpgradeY[3] = [203, 300, 397]
	If _UST_ReturnToDefensePanel() And _Sleep($DELAYRESPOND) Then Return False

	For $iDefense = 0 To UBound($aDefenseName) - 1
		Click($aDefenseX[$iDefense], 528 + $g_iMidOffsetY, 1, 120, "#AUTESTSTATION")
		If _Sleep(800) Then Return False
		If Not _UST_IsStationPanelOpen() Then
			SetLog("TestUpgradeStation: Station screen lost while scanning", $COLOR_ERROR)
			Return False
		EndIf

		SetLog($aDefenseName[$iDefense] & " Upgrade Options:", $COLOR_INFO)
		For $iUpgrade = 0 To UBound($aUpgradeY) - 1
			Local $sStatus = "Not Detected"
			If _UST_IsUpgradeMaxLevel($aUpgradeY[$iUpgrade]) Then
				$sStatus = "Max Level"
			ElseIf _UST_GetButtonResource($aUpgradeY[$iUpgrade]) = "Gem" Or _UST_IsUpgradeRowHighlighted($aUpgradeY[$iUpgrade]) Then
				$sStatus = "Running"
			ElseIf _UST_IsUpgradeInsufficientResources($aUpgradeY[$iUpgrade]) Then
				$sStatus = "Insufficient Resources"
			ElseIf IsArray(_UST_FindUpgradeButton($aUpgradeY[$iUpgrade])) Then
				$sStatus = "Available"
			ElseIf _UST_IsUpgradeButtonDisabled($aUpgradeY[$iUpgrade]) Then
				$sStatus = "Unavailable"
			EndIf
			SetLog($aDefenseName[$iDefense] & " Upgrade " & ($iUpgrade + 1) & ": " & $sStatus, $COLOR_DEBUG)
		Next
	Next

	If _UST_ReturnToDefensePanel() And _Sleep($DELAYRESPOND) Then Return False
	Return True
EndFunc   ;==>TestUpgradeStation

; #FUNCTION# ===========================================================================================================
; Name ..........: TestAutoLabUpgrade
; Description ...: Tests Laboratory upgrade suggestion detection and confirmation.
; Remarks .......: Stops before final confirmation; $bConfirm is retained only for call compatibility.
; ======================================================================================================================

Func TestAutoLabUpgrade($bConfirm = False)
	If Not _AUpgradeReturnToMenu() Then Return False
	If Not TestAutoLabUpgradeFilter() Then Return False
	If _Sleep(350) Then Return False

	Local $aRows = _AUpgradeGetSuggestionRows()
	If Not IsArray($aRows) Then
		SetLog("TestAutoLabUpgrade: No visible Laboratory upgrade suggestion found", $COLOR_ERROR)
		Return False
	EndIf

	Local $iRow = -1
	For $i = 0 To UBound($aRows) - 1
		Local $sResource = StringLower($aRows[$i][0])
		If StringLeft($sResource, 6) <> "elixir" And StringLeft($sResource, 4) <> "dark" Then ContinueLoop
		Local $sCostState = _AUpgradeGetCostPixelState($aRows[$i][1], $aRows[$i][2])
		If $sCostState = "Insufficient" Then
			SetLog("[Upgrade Skipped]: " & $aRows[$i][0] & " - Insufficient Resources", $COLOR_WARNING)
			ContinueLoop
		EndIf
		If $sCostState = "Unknown" Then
			SetLog("[Upgrade Skipped]: " & $aRows[$i][0] & " - Cost Color Unknown", $COLOR_WARNING)
			ContinueLoop
		EndIf
		$iRow = $i
		ExitLoop
	Next
	If $iRow < 0 Then
		SetLog("TestAutoLabUpgrade: No affordable Laboratory upgrade with a white cost detected", $COLOR_ERROR)
		Return False
	EndIf

	Local $sSuggestionPosition = _AUpgradeSuggestionPosition($iRow)
	Local $iRowX = $aRows[$iRow][1], $iRowY = $aRows[$iRow][2] - 12
	SetLog("[Upgrade Icon]: " & $aRows[$iRow][0] & " detected at " & $iRowX & "," & $iRowY, $COLOR_INFO)
	Click(Random($iRowX - 3, $iRowX + 3, 1), Random($iRowY - 3, $iRowY + 3, 1), 1, 120, "#AUTESTLAB")
	If _Sleep(650) Then Return False

	If _AUpgradeIsClassicConfirmationOpen() Then
		SetLog("[Suggestion Selected]: " & $sSuggestionPosition, $COLOR_INFO)
		SetLog("[Upgrade Screen]: Laboratory Upgrade", $COLOR_INFO)
		SetLog("Laboratory upgrade confirmation detected", $COLOR_INFO)
		SetLog("Upgrade not started; test stopped before confirmation", $COLOR_INFO)
		Return True
	EndIf

	SetLog("[Suggestion Selected]: " & $sSuggestionPosition, $COLOR_INFO)
	SetLog("[Upgrade Type]: Unresolved", $COLOR_WARNING)
	SetLog("TestAutoLabUpgrade: Laboratory upgrade confirmation not detected", $COLOR_ERROR)
	Return False
EndFunc   ;==>TestAutoLabUpgrade

Func _AUpgradeApplyBuilderFilters($bSuppressLog = False, $bTestMode = False)
	If Not _AUpgradeEnsureBuilderMenuOpen() Then
		SetLog($bTestMode ? "TestAutoUpgradeFilter: Builder menu not detected" : "AutoUpgrade: Builder menu not detected", $COLOR_ERROR)
		Return False
	EndIf

	If _AUpgradeFilterPanelOpen() Then
		Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AUFILTER")
		If _Sleep(350) Then Return False
		If _AUpgradeFilterPanelOpen() Then Return False
	EndIf
	If Not _AUpgradeClickBuilderMenu() Then
		SetLog($bTestMode ? "TestAutoUpgradeFilter: Builder upgrade tab not detected" : "AutoUpgrade: Builder upgrade tab not detected", $COLOR_ERROR)
		Return False
	EndIf
	If _Sleep(350) Then Return False
	Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AUFILTER")
	If _Sleep(350) Then Return False
	If Not _AUpgradeFilterPanelOpen() Then
		SetLog($bTestMode ? "TestAutoUpgradeFilter: Filter panel not detected" : "AutoUpgrade: Filter panel not detected", $COLOR_ERROR)
		Return False
	EndIf

	Local $iResource = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeResource)
	Local $iType = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeType)
	Local $iSorting = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeSorting)
	If $iResource < 0 Or $iResource > 3 Then $iResource = 0
	If $iType < 0 Or $iType > 5 Then $iType = 0
	If $iSorting < 0 Or $iSorting > 2 Then $iSorting = 0

	Local $aResourceX[3] = [153, 290, 427], $aResourceY[3] = [114, 114, 114]
	Local $aTypeX[6] = [153, 290, 427, 153, 290, 427], $aTypeY[6] = [199, 199, 199, 252, 252, 252]
	Local $aSortingX[2] = [153, 290], $aSortingY[2] = [334, 334]

	If Not _AUpgradeApplyFilterGroup($aResourceX, $aResourceY, $iResource - 1) Then Return False
	Local $iTypeFilterIndex = $iType - 1
	If $iType = 5 Then $iTypeFilterIndex = 5 ; Permanent remains the sixth game filter; New is intentionally skipped.
	If Not _AUpgradeApplyFilterGroup($aTypeX, $aTypeY, $iTypeFilterIndex) Then Return False
	If Not _AUpgradeApplyFilterGroup($aSortingX, $aSortingY, $iSorting - 1) Then Return False

	$g_iAutoUpgradeResourceFilter = $iResource
	$g_iAutoUpgradeTypeFilter = $iType
	$g_iAutoUpgradeSorting = $iSorting
	If Not _AUpgradeFilterPanelOpen() Then Return False
	Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AUFILTER")
	If _Sleep(350) Then Return False
	If Not $bSuppressLog Then
		SetLog("[Resource Filter]: " & _AUpgradeFilterName($iResource, "Default|Gold|Elixir|Dark"), $COLOR_INFO)
		SetLog("[Type Filter]: " & _AUpgradeFilterName($iType, "Default|Army|Defense|Hero|Resource|Permanent"), $COLOR_INFO)
		SetLog("[Sorting]: " & _AUpgradeFilterName($iSorting, "Default|Cost Max|Cost Min"), $COLOR_INFO)
	EndIf
	Return True
EndFunc   ;==>_AUpgradeApplyBuilderFilters

Func TestAutoUpgradeFilter($bSuppressLog = False)
	Return _AUpgradeApplyBuilderFilters($bSuppressLog, True)
EndFunc   ;==>TestAutoUpgradeFilter

Func _AUpgradeApplyLabFilters($bSuppressLog = False, $bTestMode = False)
	If Not _AUpgradeEnsureBuilderMenuOpen() Then
		SetLog($bTestMode ? "TestAutoLabUpgradeFilter: Builder menu not detected" : "AutoLabUpgrade: Builder menu not detected", $COLOR_ERROR)
		Return False
	EndIf
	For $iCloseFilterTry = 0 To 1
		If Not _AUpgradeFilterPanelOpen() Then ExitLoop
		Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AULABFILTER")
		If _Sleep(350) Then Return False
	Next
	If _AUpgradeFilterPanelOpen() Then
		SetLog("AutoLabUpgrade: Could not close the current filter panel", $COLOR_ERROR)
		Return False
	EndIf
	Click(636, $g_iGAME_HEIGHT - 58, 1, 120, "#AULABMENU")
	If _Sleep(450) Then Return False
	If Not QuickMIS("BFI", $g_sImgAUpgradeMenu & "Titles\LabMenuTitle*", 590, 0, 780, 50) Then
		SetLog($bTestMode ? "TestAutoLabUpgradeFilter: Laboratory menu image not detected" : "AutoLabUpgrade: Laboratory menu image not detected", $COLOR_ERROR)
		Return False
	EndIf
	If _Sleep(450) Then Return False
	Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AULABFILTER")
	If _Sleep(350) Then Return False
	If Not _AUpgradeFilterPanelOpen() Then
		SetLog($bTestMode ? "TestAutoLabUpgradeFilter: Filter panel not detected" : "AutoLabUpgrade: Filter panel not detected", $COLOR_ERROR)
		Return False
	EndIf

	Local $iResource = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeResource)
	Local $iType = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeType)
	Local $iSorting = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeSorting)
	If $iResource < 0 Or $iResource > 2 Then $iResource = 0
	If $iType < 0 Or $iType > 3 Then $iType = 0
	If $iSorting < 0 Or $iSorting > 2 Then $iSorting = 0

	Local $aResourceX[2] = [153, 290], $aResourceY[2] = [114, 114]
	Local $aTypeX[3] = [153, 290, 427], $aTypeY[3] = [199, 199, 199]
	Local $aSortingX[2] = [153, 290], $aSortingY[2] = [334, 334]
	If Not _AUpgradeApplyFilterGroup($aResourceX, $aResourceY, $iResource - 1) Then Return False
	If Not _AUpgradeApplyFilterGroup($aTypeX, $aTypeY, $iType - 1) Then Return False
	If Not _AUpgradeApplyFilterGroup($aSortingX, $aSortingY, $iSorting - 1) Then Return False
	If Not _AUpgradeFilterPanelOpen() Then
		SetLog($bTestMode ? "TestAutoLabUpgradeFilter: Filter panel closed while applying filters" : "AutoLabUpgrade: Filter panel closed while applying filters", $COLOR_ERROR)
		Return False
	EndIf
	Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AULABFILTER")
	If _Sleep(350) Then Return False
	If _AUpgradeFilterPanelOpen() Then
		Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AULABFILTER")
		If _Sleep(350) Then Return False
	EndIf
	If _AUpgradeFilterPanelOpen() Then
		SetLog($bTestMode ? "TestAutoLabUpgradeFilter: Could not close filter panel after applying filters" : "AutoLabUpgrade: Could not close filter panel after applying filters", $COLOR_ERROR)
		Return False
	EndIf

	$g_iAutoLabUpgradeResourceFilter = ($iResource = 0 ? 2 : $iResource - 1)
	$g_iAutoLabUpgradeTypeFilter = ($iType = 0 ? 3 : $iType - 1)
	$g_iAutoLabUpgradeSorting = ($iSorting = 0 ? 2 : $iSorting - 1)
	If Not $bSuppressLog Then
		SetLog("[Laboratory Resource Filter]: " & _AUpgradeFilterName($iResource, "Default|Elixir|Dark"), $COLOR_INFO)
		SetLog("[Laboratory Type Filter]: " & _AUpgradeFilterName($iType, "Default|Troops|Spells|Sieges"), $COLOR_INFO)
		SetLog("[Laboratory Sorting]: " & _AUpgradeFilterName($iSorting, "Default|Cost Max|Cost Min"), $COLOR_INFO)
	EndIf
	Return True
EndFunc   ;==>_AUpgradeApplyLabFilters

Func TestAutoLabUpgradeFilter($bSuppressLog = False)
	Return _AUpgradeApplyLabFilters($bSuppressLog, True)
EndFunc   ;==>TestAutoLabUpgradeFilter

; #FUNCTION# ===========================================================================================================
; Name ..........: RunVillageUpgrades
; Description ...: Runs enabled Home Village upgrades in priority order at explicit cycle entry points.
; Remarks .......: Shared by normal and Rush cycles; checks availability on every call without a cooldown.
; ======================================================================================================================
Func RunVillageUpgrades()
	If Not $g_bRunState Or $g_bRestart Or $g_bRestartRunBot Then Return False
	If isOnBuilderBase(True) Or Not IsMainPage(1) Then Return False

	Local $bBuildings = False
	For $i = 0 To UBound($g_abBuildingUpgradeEnable) - 1
		If $g_abBuildingUpgradeEnable[$i] Then
			$bBuildings = True
			ExitLoop
		EndIf
	Next
	Local $bHeroes = $g_bUpgradeKingEnable Or $g_bUpgradeQueenEnable Or $g_bUpgradePrinceEnable Or $g_bUpgradeWardenEnable Or $g_bUpgradeChampionEnable Or $g_bUpgradeDukeEnable
	Local $bBuildersValid = False
	If $bBuildings Or $bHeroes Or $g_bAutoUpgradeWallsEnable Then $bBuildersValid = _AUpgradeRefreshMenuBuilders()
	If $bBuildersValid And $g_iFreeBuilderCount > 0 Then
		If $bBuildings Then UpgradeBuilding()
		If Not __RunBotStepReady() Then Return False
		If $bHeroes And $g_iFreeBuilderCount > 0 Then UpgradeHeroes()
		If Not __RunBotStepReady() Then Return False
	EndIf
	If $g_bAutoUpgradeEnabled Or $g_bAutoLabUpgradeAutoEnabled Or $g_bAutoPetUpgradeEnabled Then AutoUpgrade()
	If Not __RunBotStepReady() Then Return False
	If $g_bAutoUpgradeWallsEnable And $bBuildersValid And $g_iFreeBuilderCount > 0 Then
		TakeWardenValues()
		If Not __RunBotStepReady() Then Return False
		If UpgradeWallResourcesReady() Then UpgradeWall(True)
	EndIf
	Return __RunBotCanContinue()
EndFunc   ;==>RunVillageUpgrades
