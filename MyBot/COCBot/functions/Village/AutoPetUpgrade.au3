; #FUNCTION# ===========================================================================================================
; Name ..........: AutoPetUpgrade
; Author ........: Phael
; Description ...: Starts one affordable Pet upgrade from the Builder menu.
; Remarks .......: Tests stop before the final confirmation. Menu coordinates use the native 860x732 layout.
; ======================================================================================================================
Func AutoPetUpgrade($bKeepMenuOpen = False)
	If Not $g_bRunState Or Not $g_bAutoPetUpgradeEnabled Then Return 0
	Local $iStarted = _AutoPetUpgrade(False)
	If $g_bRunState And _AUpgradeReturnToMenu() And Not $bKeepMenuOpen Then CloseWindow()
	Return $iStarted
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _AUpgradeMenuVisible
; Description ...: Validates a Home Village upgrade tab by its title.
; ======================================================================================================================
Func _AUpgradeMenuVisible()
	Return QuickMIS("BC1", $g_sImgAUpgradeMenu & "Titles\", 580, 0, 790, 50)
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _AUpgradeReturnToMenu
; Description ...: Restores the upgrade menu after a confirmation without closing an already visible menu.
; Remarks .......: Recovery is bounded and reopens the menu only when the game returned to the village.
; ======================================================================================================================
Func _AUpgradeReturnToMenu()
	For $iTry = 0 To 3
		If Not $g_bRunState Then Return False
		If _AUpgradeMenuVisible() Then Return True
		If IsMainPage(1) Then Return _AUpgradeEnsureBuilderMenuOpen()
		If $iTry = 3 Then ExitLoop
		CloseWindow()
		If _Sleep(250) Then Return False
	Next
	Return False
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _AUpgradeReadMenuCount
; Description ...: Reads a free/total counter below a Builder menu tab.
; ======================================================================================================================
Func _AUpgradeReadMenuCount($iX, $iMaxTotal)
	Local $aOffsets[3] = [0, -1, 1]
	For $i = 0 To UBound($aOffsets) - 1
		Local $sCount = _NormalizeBuilderCount(StringReplace(getOcrAndCapture("coc-upgrademenu-count", $iX, $g_iGAME_HEIGHT - 41 + $aOffsets[$i], 35, 20, True), "-", ""))
		If Not StringRegExp($sCount, "^\d#\d$") Then ContinueLoop
		Local $aCount = StringSplit($sCount, "#", 2)
		If Number($aCount[1]) <= $iMaxTotal Then Return $sCount
	Next
	Return ""
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _AUpgradeNormalMenuCount
; Description ...: Excludes an available paid Goblin slot using the icon above the counter.
; Remarks .......: Unknown or conflicting icons never authorize an upgrade.
; ======================================================================================================================
Func _AUpgradeNormalMenuCount($sCount, $bLaboratory = False)
	If Not StringRegExp($sCount, "^\d#\d$") Then Return ""
	Local $aCount = StringSplit($sCount, "#", 2)
	Local $iFree = Number($aCount[0]), $iTotal = Number($aCount[1])
	Local $iExtra = $bLaboratory ? ($iTotal = 2 ? 1 : 0) : ($iTotal = 7 ? 1 : 0)
	If $iFree = 0 Then Return "0#" & ($iTotal - $iExtra)
	Local $iLeft = $bLaboratory ? 611 : 519
	Local $iRight = $bLaboratory ? 661 : 569
	Local $sNormal = $bLaboratory ? "LabMenuIcon*" : "BuilderMenuIcon*"
	Local $bGoblin = QuickMIS("BFI", $g_sImgAUpgradeMenu & "Icons\GoblinMenuIcon*", $iLeft, $g_iGAME_HEIGHT - 80, $iRight, $g_iGAME_HEIGHT - 42)
	Local $bNormal = QuickMIS("BFI", $g_sImgAUpgradeMenu & "Icons\" & $sNormal, $iLeft, $g_iGAME_HEIGHT - 80, $iRight, $g_iGAME_HEIGHT - 42)
	If $bGoblin = $bNormal Then
		SetDebugLog("AutoUpgrade: " & ($bLaboratory ? "Laboratory" : "Builder") & " slot icon unknown or conflicting", $COLOR_DEBUG)
		Return ""
	EndIf
	If $bGoblin Then
		If $iExtra = 0 Then Return ""
		$iFree -= 1
	EndIf
	If $iFree > $iTotal - $iExtra Then Return ""
	Return $iFree & "#" & ($iTotal - $iExtra)
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _AUpgradeReadMenuAvailability
; Description ...: Reads Builder, Laboratory and Pet availability inside the open menu.
; Remarks .......: Available normal builders are resolved from the counter and tab icon.
; ======================================================================================================================
Func _AUpgradeReadMenuAvailability($bLog = False)
	If Not $g_bRunState Or Not _AUpgradeEnsureBuilderMenuOpen() Then Return -1
	Local $aCounts[3]
	$aCounts[0] = _AUpgradeReadMenuCount(528, 7)
	$aCounts[1] = _AUpgradeReadMenuCount(615, 2)
	$aCounts[2] = _AUpgradeReadMenuCount(800, 1)
	If $aCounts[0] <> "" Then
		Local $sNormalBuilders = _AUpgradeNormalMenuCount($aCounts[0])
		If $sNormalBuilders = "" Then
			$aCounts[0] = ""
			$g_iFreeBuilderCount = 0
		Else
			Local $aBuilders = StringSplit($sNormalBuilders, "#", 2)
			$g_iFreeBuilderCount = Number($aBuilders[0])
			$g_iTotalBuilderCount = Number($aBuilders[1])
		EndIf
	EndIf
	If $bLog Then
		Local $aNames[3] = ["Builders", "Research", "Pets"]
		For $i = 0 To 2
			SetLog("Available " & $aNames[$i] & ": " & ($aCounts[$i] = "" ? "Unknown" : StringReplace($aCounts[$i], "#", "/")))
		Next
		Local $sNormalLab = _AUpgradeNormalMenuCount($aCounts[1], True)
		SetLog("Available Normal Builders: " & ($aCounts[0] = "" ? "Unknown" : $g_iFreeBuilderCount))
		SetLog("Available Normal Research: " & ($sNormalLab = "" ? "Unknown" : StringLeft($sNormalLab, 1)))
		SetLog("Reserved Builders: " & _AUpgradeGetReservedBuilders())
	EndIf
	Return $aCounts
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _AUpgradeRefreshMenuBuilders
; Description ...: Updates builder values from the menu and optionally returns to the village.
; ======================================================================================================================
Func _AUpgradeRefreshMenuBuilders($bClose = True)
	Local $aCounts = _AUpgradeReadMenuAvailability()
	Local $bValid = IsArray($aCounts)
	If $bValid Then $bValid = $aCounts[0] <> ""
	If $bClose Then CloseWindow()
	Return $bValid
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _AUpgradeMenuLabAvailability
; Description ...: Normalizes the menu research counter without assuming a paid slot is free.
; ======================================================================================================================
Func _AUpgradeMenuLabAvailability()
	Local $aCounts = _AUpgradeReadMenuAvailability()
	If Not IsArray($aCounts) Then Return ""
	Return _AUpgradeNormalMenuCount($aCounts[1], True)
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _AutoPetUpgrade
; Description ...: Selects the first affordable Dark Elixir suggestion and validates the occupied slot.
; ======================================================================================================================
Func _AutoPetUpgrade($bTest)
	If Not $g_bRunState Then Return 0
	Local $aCounts = _AUpgradeReadMenuAvailability()
	If Not IsArray($aCounts) Then Return 0
	If Not $bTest And $aCounts[2] <> "1#1" Then
		_AUpgradeReturnToMenu()
		Return 0
	EndIf
	SetLog("Checking Auto Pet Upgrade", $COLOR_INFO)
	Click(817, $g_iGAME_HEIGHT - 58, 1, 120, "#AUPETMENU")
	If _Sleep(500) Then Return 0
	If Not QuickMIS("BFI", $g_sImgAUpgradeMenu & "Titles\PetMenuTitle*", 590, 0, 780, 50) Then
		SetLog("AutoPetUpgrade: Pet menu not detected", $COLOR_ERROR)
		_AUpgradeReturnToMenu()
		Return 0
	EndIf
	Local $aRows = _AUpgradeGetSuggestionRows()
	If Not IsArray($aRows) Then
		SetLog("No upgrade started")
		_AUpgradeReturnToMenu()
		Return 0
	EndIf
	For $i = 0 To UBound($aRows) - 1
		If StringLeft(StringLower($aRows[$i][0]), 4) <> "dark" Then ContinueLoop
		If _AUpgradeGetCostPixelState($aRows[$i][1], $aRows[$i][2]) <> "Affordable" Then ContinueLoop
		SetLog("Dark Elixir Upgrade Selected", $COLOR_ACTION)
		Click(700, $aRows[$i][2] - 12, 1, 120, "#AUPETUPGRADE")
		If _Sleep(650) Then Return 0
		If Not _AUpgradeIsClassicConfirmationOpen() Then
			SetLog("AutoPetUpgrade: Pet upgrade confirmation not detected", $COLOR_ERROR)
			_AUpgradeReturnToMenu()
			Return 0
		EndIf
		If $bTest Then
			SetLog("Pet upgrade confirmation detected; upgrade not started", $COLOR_INFO)
			Return 1
		EndIf
		Click(626, 553 + $g_iMidOffsetY, 1, 120, "#AUPETUPGRADE")
		If _Sleep(750) Then Return 0
		_AUpgradeReturnToMenu()
		Local $aAfter = _AUpgradeReadMenuAvailability()
		Local $bStarted = False
		If IsArray($aAfter) Then $bStarted = $aAfter[2] = "0#1"
		_AUpgradeReturnToMenu()
		If Not $bStarted Then
			SetLog("AutoPetUpgrade: Upgrade not registered; Pet slot not confirmed", $COLOR_ERROR)
			Return 0
		EndIf
		SetLog("Dark Elixir Upgrade Started", $COLOR_SUCCESS)
		Return 1
	Next
	SetLog("No upgrade started")
	_AUpgradeReturnToMenu()
	Return 0
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: TestAutoPetUpgrade
; Description ...: Tests the real Pet menu flow and leaves final confirmation pending.
; ======================================================================================================================
Func TestAutoPetUpgrade()
	If Not _AUpgradeReturnToMenu() Then Return False
	Return _AutoPetUpgrade(True) = 1
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: TestVillageUpgradeMenu
; Description ...: Opens the Builder menu and reports all three availability counters without spending resources.
; ======================================================================================================================
Func TestVillageUpgradeMenu()
	If Not _AUpgradeReturnToMenu() Then Return False
	Local $aCounts = _AUpgradeReadMenuAvailability(True)
	If Not IsArray($aCounts) Then Return False
	Return $aCounts[0] <> "" And $aCounts[1] <> "" And $aCounts[2] <> ""
EndFunc


; #FUNCTION# ===========================================================================================================
; Name ..........: TestVillageUpgradeNavigation
; Description ...: Validates Builders, Laboratory and Pets tab transitions without selecting an upgrade.
; Remarks .......: Leaves the menu open on Builders. Does not spend resources or change GUI selections.
; ======================================================================================================================
Func TestVillageUpgradeNavigation()
	SetLog("Testing Village Upgrade Navigation", $COLOR_INFO)
	If Not _AUpgradeReturnToMenu() Then Return False
	If Not _AUpgradeClickBuilderMenu() Then Return False
	SetLog("Builder Menu Detected", $COLOR_INFO)
	Click(636, $g_iGAME_HEIGHT - 58, 1, 120, "#AUTESTNAV")
	If _Sleep(450) Then Return False
	If Not QuickMIS("BFI", $g_sImgAUpgradeMenu & "Titles\LabMenuTitle*", 590, 0, 780, 50) Then Return False
	SetLog("Laboratory Menu Detected", $COLOR_INFO)
	Click(817, $g_iGAME_HEIGHT - 58, 1, 120, "#AUTESTNAV")
	If _Sleep(450) Then Return False
	If Not QuickMIS("BFI", $g_sImgAUpgradeMenu & "Titles\PetMenuTitle*", 590, 0, 780, 50) Then Return False
	SetLog("Pet Menu Detected", $COLOR_INFO)
	If Not _AUpgradeClickBuilderMenu() Then Return False
	SetLog("Village Upgrade Navigation Complete", $COLOR_SUCCESS)
	Return True
EndFunc
