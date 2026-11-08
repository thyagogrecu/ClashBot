; #FUNCTION# ====================================================================================================================
; Name ..........: UpgradeWall
; Description ...: This file checks if enough resources to upgrade walls, and upgrades them
; Syntax ........: UpgradeWall([$bStorageValidated])
; Parameters ....:
; Return values .: None
; Author ........: ProMac (2015), HungLe (2015)
; Modified ......: Sardo (08-2015), KnowJack (08-2015), MonkeyHunter(06-2016) , trlopes (07-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkwall.au3
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_bGoldStorageLimitWall = False, $g_bElixirStorageLimitWall = False

Func UpgradeWall($bStorageValidated = False)

	Local $bWallUpgraded = False

	If Not $g_bRunState Then Return
	SyncUpgradeWallRuntimeSettings()
	Local $iWallCost = UpgradeWallCurrentCost()

	If $g_bAutoUpgradeWallsEnable = True Then
		If Not $bStorageValidated Then
			VillageReport(True, True)
			If Not $g_bRunState Then Return
			If Not UpgradeWallStorageReady() Then Return
		EndIf
		SetDebugLog("$iWallCost:" & $iWallCost)
		If SkipWallUpgrade($iWallCost) Then Return
		SetDebugLog("$g_iFreeBuilderCount:" & $g_iFreeBuilderCount)
		If $g_iFreeBuilderCount - ReservedBuildersForBuildings(False) > 0 Then
			SetLog("Checking Wall Upgrades", $COLOR_INFO)
			ZoomOut()
			Local $iLoop = ($g_iUpgradeWallLootType = 2 ? 2 : 1)
			For $i = 1 To $iLoop
				SetDebugLog("Upgrade wall pass: " & $i & "/" & $iLoop)
				If Not DoUpgradeWall(True) Then ExitLoop
				$bWallUpgraded = True
				If _Sleep(1000) Then Return
			Next
		Else
			SetLog("Not enough builders available to upgrade walls")
		EndIf
	EndIf
	If _Sleep($DELAYUPGRADEWALL1) Then Return
	VillageReport(True, True)
	checkMainScreen(False) ; Check for errors during function
	Return $bWallUpgraded
EndFunc   ;==>UpgradeWall

Func UpgradeWallResourcesReady()
	If Not $g_bRunState Or Not $g_bAutoUpgradeWallsEnable Then Return False

	SyncUpgradeWallRuntimeSettings()
	VillageReport(True, True)
	If Not $g_bRunState Then Return False
	Return UpgradeWallStorageReady()
EndFunc   ;==>UpgradeWallResourcesReady

Func SyncUpgradeWallRuntimeSettings()
	If $g_iGuiMode <> 1 Then Return

	If $g_hChkWallHammerJam <> 0 Then $g_bWallHammerJam = (GUICtrlRead($g_hChkWallHammerJam) = $GUI_CHECKED)
	If $g_hChkWallGoldPass <> 0 Then $g_bWallGoldPass = (GUICtrlRead($g_hChkWallGoldPass) = $GUI_CHECKED)
	If $g_hCmbWallGoldPass <> 0 Then $g_iWallGoldPassDiscount = (_GUICtrlComboBox_GetCurSel($g_hCmbWallGoldPass) = 2 ? 20 : (_GUICtrlComboBox_GetCurSel($g_hCmbWallGoldPass) = 1 ? 15 : 10))
	If $g_hTxtWallMinGold <> 0 Then $g_iUpgradeWallMinGold = Number(GUICtrlRead($g_hTxtWallMinGold))
	If $g_hTxtWallMinElixir <> 0 Then $g_iUpgradeWallMinElixir = Number(GUICtrlRead($g_hTxtWallMinElixir))
	If $g_hRdoUseGold <> 0 And GUICtrlRead($g_hRdoUseGold) = $GUI_CHECKED Then
		$g_iUpgradeWallLootType = 0
	ElseIf $g_hRdoUseElixir <> 0 And GUICtrlRead($g_hRdoUseElixir) = $GUI_CHECKED Then
		$g_iUpgradeWallLootType = 1
	ElseIf $g_hRdoUseElixirGold <> 0 And GUICtrlRead($g_hRdoUseElixirGold) = $GUI_CHECKED Then
		$g_iUpgradeWallLootType = 2
	EndIf
	If $g_hCmbUpgradeWallStorageLimit <> 0 Then cmbUpgradeWallStorageLimit()
	If $g_hCmbWalls <> 0 Then $g_iCmbUpgradeWallsLevel = _GUICtrlComboBox_GetCurSel($g_hCmbWalls)
EndFunc   ;==>SyncUpgradeWallRuntimeSettings

; #FUNCTION# ===========================================================================================================
; Name ..........: UpgradeWallCurrentCost
; Description ...: Returns the configured wall cost including event and Gold Pass reductions.
; ======================================================================================================================
Func UpgradeWallCurrentCost()
	If $g_iCmbUpgradeWallsLevel >= 0 And $g_iCmbUpgradeWallsLevel < UBound($g_aiWallCost) Then $g_iWallCost = ($g_bWallHammerJam ? $g_aiWallCostHammerJam[$g_iCmbUpgradeWallsLevel] : $g_aiWallCost[$g_iCmbUpgradeWallsLevel])
	Local $iWallCost = Ceiling($g_iWallCost - ($g_iWallCost * ($g_bWallGoldPass ? $g_iWallGoldPassDiscount : 0) / 100))
	; Hammer Jam with the 15% pass uses the observed 58% combined reduction.
	If $g_bWallHammerJam And $g_bWallGoldPass And $g_iWallGoldPassDiscount = 15 Then $iWallCost = Ceiling($g_iWallCost * 84 / 100)
	SetDebugLog("Wall level " & ($g_iCmbUpgradeWallsLevel + 4) & " cost: " & $iWallCost, $COLOR_DEBUG)
	Return $iWallCost
EndFunc   ;==>UpgradeWallCurrentCost

; #FUNCTION# ===========================================================================================================
; Name ..........: TestUpgradeWallSingle
; Description ...: Tests wall detection and individual upgrade selection without confirming spending.
; Remarks .......: Uses the configured wall level. Resource can be Gold, Elixir or Default for the GUI preference.
; ======================================================================================================================
Func TestUpgradeWallSingle($sResource = Default)
	Return _TestUpgradeWall(False, $sResource, 1)
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: TestUpgradeWallBatch
; Description ...: Tests batch wall selection and leaves the final Okay button pending.
; Remarks .......: Tests 2 to 11 walls; ignores builder availability, storage limits and resource reserves.
; ======================================================================================================================
Func TestUpgradeWallBatch($sResource = Default, $iWallCount = 2)
	If Not IsInt($iWallCount) Or $iWallCount < 2 Or $iWallCount > 11 Then Return False
	Return _TestUpgradeWall(True, $sResource, $iWallCount)
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _TestUpgradeWall
; Description ...: Exercises real wall selection and button detection, stopping before final confirmation.
; Remarks .......: Does not call upgrade confirmation or completion accounting. Requires the Home Village screen.
; ======================================================================================================================
Func _TestUpgradeWall($bBatch, $sResource, $iWallCount)
	If Not $g_bRunState Then Return False
	SetLog("Testing Wall " & ($bBatch ? "Batch" : "Single") & " Upgrade", $COLOR_INFO)
	If Not IsMainPage(1) Then
		SetLog("Open Main Village before running this test", $COLOR_WARNING)
		Return False
	EndIf
	SyncUpgradeWallRuntimeSettings()
	If $sResource = Default Then $sResource = ($g_iUpgradeWallLootType = 0 ? "Gold" : "Elixir")
	Switch StringLower($sResource)
		Case "gold"
			$sResource = "Gold"
		Case "elixir"
			$sResource = "Elixir"
		Case Else
			Return False
	EndSwitch
	Local $iCost = UpgradeWallCurrentCost()
	SetLog("Wall Test Cost: " & _NumberFormat($iCost) & " " & $sResource & " per Wall", $COLOR_INFO)
	If Not imglocCheckWall() Then Return False
	If $bBatch Then
		If Not QuickMIS("BFI", @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\PlusSign*", 150, 500, 750, 650) Then
			SetLog("Wall Test: Upgrade More button not found", $COLOR_WARNING)
			Return False
		EndIf
		Click($g_iQuickMISX, $g_iQuickMISY, 1, 120, "#TESTWALLBATCH")
		If _Sleep(500) Then Return False
		Local $iSelected = 1, $aPlusArea[4]
		While $iSelected < $iWallCount
			Local $bPlus10 = False
			If $iWallCount - $iSelected >= 10 Then $bPlus10 = QuickMIS("BFI", @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus10*", 150, 500, 750, 650)
			If Not $bPlus10 Then
				UpgradeWallPlus1SearchArea($aPlusArea)
				If Not QuickMIS("BFI", @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*", $aPlusArea[0], $aPlusArea[1], $aPlusArea[2], $aPlusArea[3]) Then
					SetLog("Wall Test: Add Wall button not found", $COLOR_WARNING)
					Return False
				EndIf
			EndIf
			Click($g_iQuickMISX, $g_iQuickMISY, 1, 50, "#TESTWALLADD")
			If _Sleep(500) Then Return False
			$iSelected += ($bPlus10 ? 10 : 1)
		WEnd
		SetLog("Wall Test: " & $iSelected & " Walls Selected", $COLOR_INFO)
	EndIf
	Local $aResourceButton[2]
	If Not UpgradeWallFindResourceButton($sResource, $aResourceButton) Then
		SetLog("Wall Test: " & $sResource & " button not found", $COLOR_WARNING)
		Return False
	EndIf
	ClickP($aResourceButton, 1, 120, "#TESTWALLUPGRADE")
	If _Sleep(1000) Then Return False
	Local $aConfirm = $bBatch ? findButton("Okay", "Okay*.bmp", 1, True) : findButton("WallUpgradeConfirm", "ConfirmButton*.bmp", 1, True)
	If Not IsArray($aConfirm) Or UBound($aConfirm) < 2 Then
		SetLog("Wall Test: Final confirmation not detected", $COLOR_WARNING)
		Return False
	EndIf
	SetLog("Wall Test: " & ($bBatch ? "Okay" : "Confirm") & " detected; upgrade not started", $COLOR_SUCCESS)
	Return True
EndFunc

Func UpgradeWallStorageReady($bLog = True)
	$g_bGoldStorageLimitWall = False
	$g_bElixirStorageLimitWall = False

	Local $bReady = False
	Switch $g_iUpgradeWallLootType
		Case 1
			$bReady = UpgradeWallStorageAboveLimit("Elixir", $bLog)
			If Not $bReady And $bLog Then SetLog("Wall upgrade skipped, elixir storage isn't above " & UpgradeWallStorageLimitPercent() & "%")
		Case 2
			Local $bElixirReady = UpgradeWallStorageAboveLimit("Elixir", $bLog)
			Local $bGoldReady = UpgradeWallStorageAboveLimit("Gold", $bLog And Not $bElixirReady)
			$bReady = ($bElixirReady Or $bGoldReady)
			If Not $bReady And $bLog Then SetLog("Wall upgrade skipped, gold and elixir storage isn't above " & UpgradeWallStorageLimitPercent() & "%")
		Case Else
			$bReady = UpgradeWallStorageAboveLimit("Gold", $bLog)
			If Not $bReady And $bLog Then SetLog("Wall upgrade skipped, gold storage isn't above " & UpgradeWallStorageLimitPercent() & "%")
	EndSwitch
	Return $bReady
EndFunc   ;==>UpgradeWallStorageReady

Func UpgradeWallStorageAboveLimit($sResource, $bLog = True)
	Local $iLimit = UpgradeWallStorageLimitPercent()
	Local $aStorageFull[4], $aStorageLimit[4], $iLootIndex = $eLootGold, $sResourceName = "Gold"
	If StringInStr($sResource, "Elixir") Then
		$aStorageFull = $aIsElixirFull
		$iLootIndex = $eLootElixir
		$sResourceName = "Elixir"
	Else
		$aStorageFull = $aIsGoldFull
	EndIf

	If $iLimit = 0 Then
		If $bLog Then SetLog($sResourceName & " Storage Limit Disabled", $COLOR_ACTION)
		If $sResourceName = "Elixir" Then
			$g_bElixirStorageLimitWall = True
		Else
			$g_bGoldStorageLimitWall = True
		EndIf
		Return True
	EndIf

	Local $aStorageFullResult = _FullResPixelSearch($aStorageFull[0], $aStorageFull[0] + 4, $aStorageFull[1], 1, Hex(0x0D0D0D, 6), $aStorageFull[2], $aStorageFull[3])
	If IsArray($aStorageFullResult) Then
		If $bLog Then SetLog($sResourceName & " Storages > 90% : " & _NumberFormat($g_aiCurrentLoot[$iLootIndex]), $COLOR_SUCCESS)
		If $sResourceName = "Elixir" Then
			$g_bElixirStorageLimitWall = True
		Else
			$g_bGoldStorageLimitWall = True
		EndIf
		Return True
	EndIf

	Local $iStorageCapacity = UpgradeWallStorageCapacity($sResourceName)
	If $iStorageCapacity > 0 Then
		Local $iCurrentLoot = Number($g_aiCurrentLoot[$iLootIndex])
		Local $iRequiredLoot = Ceiling($iStorageCapacity * $iLimit / 100)
		If $iCurrentLoot >= $iRequiredLoot Then
			If $bLog Then SetLog($sResourceName & " Storages > " & $iLimit & "% : " & _NumberFormat($iCurrentLoot), $COLOR_ACTION)
			If $sResourceName = "Elixir" Then
				$g_bElixirStorageLimitWall = True
			Else
				$g_bGoldStorageLimitWall = True
			EndIf
			Return True
		EndIf

		If $bLog Then SetLog($sResourceName & " Storages < " & $iLimit & "% : " & _NumberFormat($iCurrentLoot), $COLOR_DEBUG)
		Return False
	EndIf

	$aStorageLimit[0] = UpgradeWallStorageLimitPixelX()
	$aStorageLimit[1] = $aStorageFull[1]
	$aStorageLimit[2] = $aStorageFull[2]
	$aStorageLimit[3] = 35
	If _CheckPixel($aStorageLimit, True) Then
		If $bLog Then SetLog($sResourceName & " Storages > " & $iLimit & "%", $COLOR_ACTION)
		If $sResourceName = "Elixir" Then
			$g_bElixirStorageLimitWall = True
		Else
			$g_bGoldStorageLimitWall = True
		EndIf
		Return True
	EndIf

	If $bLog Then SetLog($sResourceName & " Storages < " & $iLimit & "%", $COLOR_DEBUG)
	Return False
EndFunc   ;==>UpgradeWallStorageAboveLimit

Func UpgradeWallStorageCapacity($sResourceName)
	If $g_iTownHallLevel < 2 Or $g_iTownHallLevel > 18 Then Return 0

	Local $aiStorageCapacity[19] = [0, 8500, 8500, 100000, 500000, 1000000, 2000000, 4000000, 6000000, 8000000, 8500000, 10000000, 12000000, 18000000, 20000000, 22000000, 24000000, 26000000, 28000000]
	Local $iCapacity = $aiStorageCapacity[$g_iTownHallLevel]

	If Number($g_aiCurrentLoot[UpgradeWallStorageLootIndex($sResourceName)]) > $iCapacity Then $iCapacity = Number($g_aiCurrentLoot[UpgradeWallStorageLootIndex($sResourceName)])
	Return $iCapacity
EndFunc   ;==>UpgradeWallStorageCapacity

Func UpgradeWallStorageLootIndex($sResourceName)
	Return (StringInStr($sResourceName, "Elixir") ? $eLootElixir : $eLootGold)
EndFunc   ;==>UpgradeWallStorageLootIndex

Func UpgradeWallStorageLimitPercent()
	If $g_hCmbUpgradeWallStorageLimit <> 0 Then
		Local $iSelectedLimit = _GUICtrlComboBox_GetCurSel($g_hCmbUpgradeWallStorageLimit)
		If $iSelectedLimit >= 0 And $iSelectedLimit <= 2 Then $g_iCmbUpgradeWallStorageLimit = $iSelectedLimit
	EndIf

	Switch $g_iCmbUpgradeWallStorageLimit
		Case 0
			Return 0
		Case 2
			Return 75
	EndSwitch
	Return 50
EndFunc   ;==>UpgradeWallStorageLimitPercent

Func UpgradeWallStorageLimitPixelX()
	Local $iStorageBarLeft = 657
	Local $iStorageBarRight = 817
	Local $iStorageBarWidth = $iStorageBarRight - $iStorageBarLeft

	Switch UpgradeWallStorageLimitPercent()
		Case 25
			Return $iStorageBarLeft + Round($iStorageBarWidth * 0.75)
		Case 75
			Return $iStorageBarLeft + Round($iStorageBarWidth * 0.25)
	EndSwitch
	Return $iStorageBarLeft + Round($iStorageBarWidth * 0.50)
EndFunc   ;==>UpgradeWallStorageLimitPixelX

Func DoUpgradeWall($bUseCachedLoot = False)
	If Not $g_bRunState Then Return False

	If Not $bUseCachedLoot Then VillageReport(True, True)
	Local $iWallCost = UpgradeWallCurrentCost()
	Local $iCanUseGold = Number($g_aiCurrentLoot[$eLootGold]) - Number($g_iUpgradeWallMinGold)
	Local $iCanUseElixir = Number($g_aiCurrentLoot[$eLootElixir]) - Number($g_iUpgradeWallMinElixir)
	Local $bCanUseGold = ($iCanUseGold >= $iWallCost)
	Local $bCanUseElixir = ($iCanUseElixir >= $iWallCost)
	Local $aBtnCoord[4] = [150, 500, 750, 650]
	Local $aButton, $aGoldButton[2], $aElixirButton[2], $aPlusButton[2]
	Local $bPlusSignFound = False, $bGoldButtonFound = False, $bElixirButtonFound = False
	Local $bUseGold = ($g_iUpgradeWallLootType = 0 Or $g_iUpgradeWallLootType = 2)
	Local $bUseElixir = ($g_iUpgradeWallLootType = 1 Or $g_iUpgradeWallLootType = 2)

	If $bUseGold And Not $bCanUseGold Then SetLog("Not enough gold, upgrade skipped")
	If $bUseElixir And Not $bCanUseElixir Then SetLog("Not enough elixir, upgrade skipped")
	If ($bUseGold And Not $bCanUseGold) And ($bUseElixir And Not $bCanUseElixir) Then Return False
	If $g_iUpgradeWallLootType = 0 And Not $bCanUseGold Then Return False
	If $g_iUpgradeWallLootType = 1 And Not $bCanUseElixir Then Return False

	If Not imglocCheckWall() Then Return False

	$aButton = QuickMIS("CNX", @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons", $aBtnCoord[0], $aBtnCoord[1], $aBtnCoord[2], $aBtnCoord[3])
	If IsArray($aButton) And UBound($aButton) > 0 Then
		For $i = 0 To UBound($aButton) - 1
			Select
				Case $aButton[$i][0] = "PlusSign"
					$aPlusButton[0] = $aButton[$i][1]
					$aPlusButton[1] = $aButton[$i][2]
					$bPlusSignFound = True
				Case $aButton[$i][0] = "Gold"
					$aGoldButton[0] = $aButton[$i][1] - 25
					$aGoldButton[1] = $aButton[$i][2] + 25
					$bGoldButtonFound = True
				Case $aButton[$i][0] = UpgradeWallResourceImageName("Elixir")
					$aElixirButton[0] = $aButton[$i][1] - 25
					$aElixirButton[1] = $aButton[$i][2] + 25
					$bElixirButtonFound = True
			EndSelect
		Next
	EndIf
	If Not $bGoldButtonFound Then
		$bGoldButtonFound = UpgradeWallFindResourceButtonByColor("Gold", $aGoldButton)
	EndIf
	If Not $bElixirButtonFound Then
		$bElixirButtonFound = UpgradeWallFindResourceButtonByColor("Elixir", $aElixirButton)
	EndIf

	If Not $bGoldButtonFound Then $bCanUseGold = False
	If Not $bElixirButtonFound Then $bCanUseElixir = False
	If Not $g_bGoldStorageLimitWall Then $bCanUseGold = False
	If Not $g_bElixirStorageLimitWall Then $bCanUseElixir = False

	Local $iWallCanUpgradeGold = ($bCanUseGold ? Floor($iCanUseGold / $iWallCost) : 0)
	Local $iWallCanUpgradeElixir = ($bCanUseElixir ? Floor($iCanUseElixir / $iWallCost) : 0)
	SetDebugLog("iWallCanUpgradeGold: " & $iWallCanUpgradeGold & ", iWallCanUpgradeElixir: " & $iWallCanUpgradeElixir, $COLOR_DEBUG)

	If $iWallCanUpgradeGold < 1 Then $bCanUseGold = False
	If $iWallCanUpgradeElixir < 1 Then $bCanUseElixir = False
	If $bCanUseGold Then SetLog("Gold Upgrade Available: " & $iWallCanUpgradeGold & "", $COLOR_ACTION)
	If $bCanUseElixir Then SetLog("Elixir Upgrade Available: " & $iWallCanUpgradeElixir & "", $COLOR_ACTION)

	If Not $bCanUseGold And $g_iUpgradeWallLootType = 0 Then Return False
	If Not $bCanUseElixir And $g_iUpgradeWallLootType = 1 Then Return False
	If Not $bCanUseGold And Not $bCanUseElixir Then Return False

	If ($iWallCanUpgradeGold > 1 Or $iWallCanUpgradeElixir > 1) And $bPlusSignFound Then
		SetDebugLog("Trying Upgrade More Button", $COLOR_ACTION)
		ClickP($aPlusButton)
		If _Sleep(1000) Then Return
		Return UpgradeWallMore($iWallCost, $iWallCanUpgradeGold, $iWallCanUpgradeElixir, $bCanUseGold, $bCanUseElixir, $aGoldButton, $aElixirButton)
	EndIf

	Return UpgradeWallSingle($iWallCost, $iWallCanUpgradeGold, $iWallCanUpgradeElixir, $bCanUseGold, $bCanUseElixir, $aGoldButton, $aElixirButton)
EndFunc   ;==>DoUpgradeWall

Func UpgradeWallMore($iWallCost, $iWallCanUpgradeGold, $iWallCanUpgradeElixir, $bCanUseGold, $bCanUseElixir, ByRef $aGoldButton, ByRef $aElixirButton)
	Local $iPlus10Gold = ($bCanUseGold ? Floor($iWallCanUpgradeGold / 10) : 0)
	Local $iPlus10Elixir = ($bCanUseElixir ? Floor($iWallCanUpgradeElixir / 10) : 0)
	Local $iPlus1Gold = ($bCanUseGold ? $iWallCanUpgradeGold : 0)
	Local $iPlus1Elixir = ($bCanUseElixir ? $iWallCanUpgradeElixir : 0)

	SetDebugLog("Plus10Gold: " & $iPlus10Gold & ", Plus10Elixir: " & $iPlus10Elixir, $COLOR_DEBUG)
	SetDebugLog("Plus1Gold: " & $iPlus1Gold & ", Plus1Elixir: " & $iPlus1Elixir, $COLOR_DEBUG)

	If $iPlus10Gold > 0 Or $iPlus10Elixir > 0 Then
		Switch $g_iUpgradeWallLootType
			Case 0
				If $iWallCanUpgradeGold > 10 Then Return UpWallGold($iWallCost, $iPlus10Gold, "+10", $aGoldButton, $iWallCanUpgradeGold)
			Case 1
				If $iPlus10Elixir > 0 Then Return UpWallElixir($iWallCost, $iPlus10Elixir, "+10", $aElixirButton, $iWallCanUpgradeElixir)
			Case 2
				If $bCanUseElixir And $iPlus10Elixir > 0 Then Return UpWallElixir($iWallCost, $iPlus10Elixir, "+10", $aElixirButton, $iWallCanUpgradeElixir)
				If $bCanUseGold And $iPlus10Gold > 0 Then Return UpWallGold($iWallCost, $iPlus10Gold, "+10", $aGoldButton, $iWallCanUpgradeGold)
		EndSwitch
	EndIf

	If $iPlus1Gold > 1 Or $iPlus1Elixir > 1 Then
		Switch $g_iUpgradeWallLootType
			Case 0
				If $iPlus1Gold > 1 Then Return UpWallGold($iWallCost, $iPlus1Gold - 1, "+1", $aGoldButton, $iWallCanUpgradeGold)
			Case 1
				If $iPlus1Elixir > 1 Then Return UpWallElixir($iWallCost, $iPlus1Elixir - 1, "+1", $aElixirButton, $iWallCanUpgradeElixir)
			Case 2
				If $bCanUseElixir And $iPlus1Elixir > 1 Then Return UpWallElixir($iWallCost, $iPlus1Elixir - 1, "+1", $aElixirButton, $iWallCanUpgradeElixir)
				If $bCanUseGold And $iPlus1Gold > 1 Then Return UpWallGold($iWallCost, $iPlus1Gold - 1, "+1", $aGoldButton, $iWallCanUpgradeGold)
		EndSwitch
	EndIf

	Return False
EndFunc   ;==>UpgradeWallMore

Func UpgradeWallSingle($iWallCost, $iWallCanUpgradeGold, $iWallCanUpgradeElixir, $bCanUseGold, $bCanUseElixir, ByRef $aGoldButton, ByRef $aElixirButton)
	Switch $g_iUpgradeWallLootType
		Case 0
			If $bCanUseGold And $iWallCanUpgradeGold > 0 Then Return UpgradeWallClickSingle("Gold", $iWallCost, $aGoldButton)
		Case 1
			If $bCanUseElixir And $iWallCanUpgradeElixir > 0 Then Return UpgradeWallClickSingle("Elixir", $iWallCost, $aElixirButton)
		Case 2
			If $bCanUseElixir And $iWallCanUpgradeElixir > 0 Then Return UpgradeWallClickSingle("Elixir", $iWallCost, $aElixirButton)
			If $bCanUseGold And $iWallCanUpgradeGold > 0 Then Return UpgradeWallClickSingle("Gold", $iWallCost, $aGoldButton)
	EndSwitch
	Return False
EndFunc   ;==>UpgradeWallSingle

Func UpgradeWallClickSingle($sResource, $iWallCost, ByRef $aButton, $bBatch = False)
	SetDebugLog("Upgrading 1 Wall for " & UpgradeWallResourceName($sResource) & " upgrade", $COLOR_ACTION)
	If Not UpgradeWallReserveAllows($sResource, $iWallCost, 1) Then Return False
	ClickP($aButton)
	If Not UpgradeWallConfirmUpgradeWindow($sResource, $bBatch) Then Return False
	UpgradeWallRegisterComplete($sResource, $iWallCost, 1)
	Return True
EndFunc   ;==>UpgradeWallClickSingle

Func UpWallElixir($iWallCost, $iCountPlus, $UpType, $aButton, $iWallLimit = 0)
	Local $sDir = "", $bPlusButtonFound = False, $iCount = 1
	Local $aBtnCoord[4] = [150, 500, 750, 650], $iPlusWall = 1

	Switch $UpType
		Case "+10"
			$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus10_*.xml"
			$iPlusWall = 10
		Case "+1"
			$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*.xml"
			UpgradeWallPlus1SearchArea($aBtnCoord)
	EndSwitch

	If $UpType = "+10" Then
		If Not QuickMIS("BFI", $sDir, $aBtnCoord[0], $aBtnCoord[1], $aBtnCoord[2], $aBtnCoord[3]) Then
			SetLog("No " & $UpType & " Button Found", $COLOR_DEBUG)
			SetLog("Try +1 Instead", $COLOR_ACTION)
			$iPlusWall = 1
			$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*.xml"
			UpgradeWallPlus1SearchArea($aBtnCoord)
			$UpType = "+1"
			$iCountPlus *= 10
		EndIf
	EndIf

	SetLog("Try " & $UpType & " Button Upgrade", $COLOR_ACTION)
	Local $i = 1
	While $i <= $iCountPlus
		If $iWallLimit > 0 And $iCount + $iPlusWall > $iWallLimit Then
			If $UpType = "+10" Then
				SetLog("Try +1 Instead", $COLOR_ACTION)
				$UpType = "+1"
				$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*.xml"
				UpgradeWallPlus1SearchArea($aBtnCoord)
				$iPlusWall = 1
				$iCountPlus += $iWallLimit - $iCount
				ContinueLoop
			EndIf
			ExitLoop
		EndIf
		If QuickMIS("BFI", $sDir, $aBtnCoord[0], $aBtnCoord[1], $aBtnCoord[2], $aBtnCoord[3]) Then
			Click($g_iQuickMISX, $g_iQuickMISY, 1, 50, "Click " & $UpType)
			If _Sleep(500) Then Return
			$iCount += $iPlusWall
			$bPlusButtonFound = True
			SetLog("Count: " & $iCount)
			$i += 1
		Else
			SetLog("No " & $UpType & " Button Found", $COLOR_DEBUG)
			If $UpType = "+10" Then
				SetLog("Try +1 Instead", $COLOR_ACTION)
				$UpType = "+1"
				$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*.xml"
				UpgradeWallPlus1SearchArea($aBtnCoord)
				$iPlusWall = 1
				$iCountPlus *= 10
			Else
				ExitLoop
			EndIf
		EndIf
	WEnd

	If $bPlusButtonFound Then
		Return UpgradeWallClickSelectedBatch("Elixir", $iWallCost, $iCount, $aButton)
	EndIf
	SetLog("Try Default Button Upgrade", $COLOR_ACTION)
	Return UpgradeWallClickSingle("Elixir", $iWallCost, $aButton, True)
EndFunc   ;==>UpWallElixir

Func UpWallGold($iWallCost, $iCountPlus, $UpType, $aButton, $iWallLimit = 0)
	Local $sDir = "", $bPlusButtonFound = False, $iCount = 1
	Local $aBtnCoord[4] = [150, 500, 750, 650], $iPlusWall = 1

	Switch $UpType
		Case "+10"
			$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus10_*.xml"
			$iPlusWall = 10
		Case "+1"
			$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*.xml"
			UpgradeWallPlus1SearchArea($aBtnCoord)
	EndSwitch

	If $UpType = "+10" Then
		If Not QuickMIS("BFI", $sDir, $aBtnCoord[0], $aBtnCoord[1], $aBtnCoord[2], $aBtnCoord[3]) Then
			SetLog("No " & $UpType & " Button Found", $COLOR_DEBUG)
			SetLog("Try +1 Instead", $COLOR_ACTION)
			$iPlusWall = 1
			$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*.xml"
			UpgradeWallPlus1SearchArea($aBtnCoord)
			$UpType = "+1"
			$iCountPlus *= 10
		EndIf
	EndIf

	SetLog("Try " & $UpType & " Button Upgrade", $COLOR_ACTION)
	Local $i = 1
	While $i <= $iCountPlus
		If $iWallLimit > 0 And $iCount + $iPlusWall > $iWallLimit Then
			If $UpType = "+10" Then
				SetLog("Try +1 Instead", $COLOR_ACTION)
				$UpType = "+1"
				$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*.xml"
				UpgradeWallPlus1SearchArea($aBtnCoord)
				$iPlusWall = 1
				$iCountPlus += $iWallLimit - $iCount
				ContinueLoop
			EndIf
			ExitLoop
		EndIf
		If QuickMIS("BFI", $sDir, $aBtnCoord[0], $aBtnCoord[1], $aBtnCoord[2], $aBtnCoord[3]) Then
			Click($g_iQuickMISX, $g_iQuickMISY, 1, 50, "Click " & $UpType)
			If _Sleep(500) Then Return
			$iCount += $iPlusWall
			$bPlusButtonFound = True
			SetLog("Count: " & $iCount)
			$i += 1
		Else
			SetLog("No " & $UpType & " Button Found", $COLOR_DEBUG)
			If $UpType = "+10" Then
				SetLog("Try +1 Instead", $COLOR_ACTION)
				$UpType = "+1"
				$sDir = @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons\Plus1_*.xml"
				UpgradeWallPlus1SearchArea($aBtnCoord)
				$iPlusWall = 1
				$iCountPlus *= 10
			Else
				ExitLoop
			EndIf
		EndIf
	WEnd

	If $bPlusButtonFound Then
		Return UpgradeWallClickSelectedBatch("Gold", $iWallCost, $iCount, $aButton)
	EndIf
	SetLog("Try Default Button Upgrade", $COLOR_ACTION)
	Return UpgradeWallClickSingle("Gold", $iWallCost, $aButton, True)
EndFunc   ;==>UpWallGold

Func UpgradeWallClickSelectedBatch($sResource, $iWallCost, $iWallCount, ByRef $aButton)
	SetLog("Try " & UpgradeWallResourceName($sResource) & " Button Upgrade", $COLOR_ACTION)
	If Not UpgradeWallReserveAllows($sResource, $iWallCost, $iWallCount) Then Return False
	If _Sleep(500) Then Return
	If Not UpgradeWallFindResourceButton($sResource, $aButton) Then Return False
	ClickP($aButton)
	If Not UpgradeWallConfirmUpgradeWindow($sResource, True) Then Return False
	UpgradeWallRegisterComplete($sResource, $iWallCost, $iWallCount)
	Return True
EndFunc   ;==>UpgradeWallClickSelectedBatch

Func UpgradeWallReserveAllows($sResource, $iWallCost, $iWallCount)
	Local $iLootIndex = UpgradeWallIsElixir($sResource) ? $eLootElixir : $eLootGold
	Local $iReserve = UpgradeWallIsElixir($sResource) ? Number($g_iUpgradeWallMinElixir) : Number($g_iUpgradeWallMinGold)
	Local $iAvailable = Number($g_aiCurrentLoot[$iLootIndex]) - $iReserve
	Local $iCost = Number($iWallCost) * Number($iWallCount)

	If $iCost <= $iAvailable Then Return True

	SetLog("Wall upgrade skipped, selected " & $iWallCount & " " & UpgradeWallResourceName($sResource) & " walls would use reserved resources", $COLOR_DEBUG)
	SetDebugLog("Wall reserve check: cost=" & $iCost & ", available=" & $iAvailable & ", reserve=" & $iReserve, $COLOR_DEBUG)
	ClickBorder()
	Return False
EndFunc   ;==>UpgradeWallReserveAllows

Func UpgradeWallConfirmUpgradeWindow($sResource, $bBatch = False)
	If _Sleep(1000) Then Return False

	Local $aOkay
	If $bBatch Then
		$aOkay = findButton("Okay", "Okay*.bmp", 1, True)
	Else
		$aOkay = findButton("WallUpgradeConfirm", "ConfirmButton*.bmp", 1, True)
	EndIf
	If IsArray($aOkay) And UBound($aOkay) >= 2 Then
		SetDebugLog("Confirm " & UpgradeWallResourceName($sResource) & " Wall Upgrade", $COLOR_ACTION)
		ClickP($aOkay, 1, 120, "ConfirmWallUpgrade")
		If _Sleep(500) Then Return False
		Return True
	EndIf

	SetLog("Wall upgrade confirm button not found", $COLOR_WARNING)
	Return False
EndFunc   ;==>UpgradeWallConfirmUpgradeWindow

Func UpgradeWallFindResourceButton($sResource, ByRef $aButton)
	Local $aBtnCoord[4] = [150, 500, 750, 650]
	Local $aButtons = QuickMIS("CNX", @ScriptDir & "\ImgXML\Upgrades\Walls\Buttons", $aBtnCoord[0], $aBtnCoord[1], $aBtnCoord[2], $aBtnCoord[3])
	Local $sButtonName = UpgradeWallResourceImageName($sResource)

	If IsArray($aButtons) And UBound($aButtons) > 0 Then
		For $i = 0 To UBound($aButtons) - 1
			If $aButtons[$i][0] = $sButtonName Then
				$aButton[0] = $aButtons[$i][1] - 25
				$aButton[1] = $aButtons[$i][2] + 25
				SetDebugLog("Found " & UpgradeWallResourceName($sResource) & " Button on " & _ArrayToString($aButton), $COLOR_DEBUG)
				Return True
			EndIf
		Next
	EndIf

	Return UpgradeWallFindResourceButtonByColor($sResource, $aButton)
EndFunc   ;==>UpgradeWallFindResourceButton

; #FUNCTION# ===========================================================================================================
; Name ..........: UpgradeWallFindResourceButtonByColor
; Description ...: Locates a wall upgrade resource icon and derives its button position.
; Remarks .......: Used when the image template does not match the current wall menu layout.
; ======================================================================================================================

Func UpgradeWallFindResourceButtonByColor($sResource, ByRef $aButton)
	Local $sColor = UpgradeWallIsElixir($sResource) ? Hex(0xFF26FF, 6) : Hex(0xFFD846, 6)
	Local $aIcon = _PixelSearch(250, 560, 735, 595, $sColor, 25)
	If Not IsArray($aIcon) Then Return False
	Local $aNeighbor = _PixelSearch($aIcon[0] - 16, $aIcon[1] - 8, $aIcon[0] - 3, $aIcon[1] + 8, $sColor, 25)
	If Not IsArray($aNeighbor) Then Return False

	$aButton[0] = $aIcon[0] - 35
	$aButton[1] = $aIcon[1] + 30
	SetDebugLog(UpgradeWallResourceName($sResource) & " wall button detected at " & _ArrayToString($aButton), $COLOR_DEBUG)
	Return True
EndFunc   ;==>UpgradeWallFindResourceButtonByColor

Func UpgradeWallPlus1SearchArea(ByRef $aBtnCoord)
	$aBtnCoord[0] = 380
	$aBtnCoord[1] = 520
	$aBtnCoord[2] = 520
	$aBtnCoord[3] = 650
EndFunc   ;==>UpgradeWallPlus1SearchArea

Func UpgradeWallRegisterComplete($sResource, $iWallCost, $iWallCount)
	Local $iCostUpgrade = Number($iWallCount) * Number($iWallCost)
	Local $sResourceName = UpgradeWallResourceName($sResource)
	Local $iLootIndex = UpgradeWallStorageLootIndex($sResourceName)
	$g_aiCurrentLoot[$iLootIndex] = _Max(0, Number($g_aiCurrentLoot[$iLootIndex]) - $iCostUpgrade)
	If UpgradeWallIsElixir($sResource) Then
		PushMsg("UpgradeWithElixir")
		$g_iNbrOfWallsUppedElixir += $iWallCount
		$g_iCostElixirWall += $iCostUpgrade
	Else
		PushMsg("UpgradeWithGold")
		$g_iNbrOfWallsUppedGold += $iWallCount
		$g_iCostGoldWall += $iCostUpgrade
	EndIf
	$g_iNbrOfWallsUpped += $iWallCount
	SetLog("Wall Upgraded: " & $iWallCount, $COLOR_SUCCESS)
	SetLog("Cost : " & _NumberFormat($iCostUpgrade) & " " & $sResourceName, $COLOR_SUCCESS)
	UpdateStats()
EndFunc   ;==>UpgradeWallRegisterComplete

Func UpgradeWallIsElixir($sResource)
	Return StringInStr($sResource, "Elixir") > 0
EndFunc   ;==>UpgradeWallIsElixir

Func UpgradeWallResourceName($sResource)
	Return (UpgradeWallIsElixir($sResource) ? "Elixir" : "Gold")
EndFunc   ;==>UpgradeWallResourceName

Func UpgradeWallResourceImageName($sResource)
	Return (UpgradeWallIsElixir($sResource) ? "Elixir" : "Gold")
EndFunc   ;==>UpgradeWallResourceImageName

Func SkipWallUpgrade($iWallCost = $g_iWallCost) ; Dynamic Upgrades

	Local $iUpgradeAction = 0
	Local $iUpgradesNeedGold = 0
	Local $iUpgradesNeedElixir = 0
	Local $iAvailBuilderCount = 0

	SetDebugLog("In SkipWallUpgrade")
	SetDebugLog("$g_iTownHallLevel = " & $g_iTownHallLevel)

	If Not WallUpgradeAllowedByTownHall($g_iCmbUpgradeWallsLevel + 4) Then
		SetLog("Skipping wall upgrade, insufficient Town Hall Level", $COLOR_WARNING)
		Return True
	EndIf

	If Not _AUpgradeRefreshMenuBuilders() Then Return True ; return to village after reading the menu; skip on failure
	If _Sleep($DELAYRESPOND) Then Return True

	$iAvailBuilderCount = $g_iFreeBuilderCount ; capture local copy of free builders

	;;;;; Check building upgrade resouce needs .vs. available resources for walls
	For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1 ; loop through all upgrades to see if any are enabled.
		If $g_abBuildingUpgradeEnable[$iz] = True Then $iUpgradeAction += 1 ; count number enabled
	Next

	If $g_iFreeBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0) And $iUpgradeAction > 0 Then ; check if builder available for bldg upgrade, and upgrades enabled
		; December 2024 : Add Warden Cost to Needed Elixir
		If ($g_iWardenLevel <> -1) And ($g_iWardenLevel < $g_iMaxWardenLevel) And $g_bUpgradeWardenEnable And BitAND($g_iHeroUpgradingBit, $eHeroWarden) <> $eHeroWarden Then
			Local $g_ExactWardenCost = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * (1 - Number($g_iBuilderBoostDiscount) / 100)
			$iUpgradesNeedElixir += Number($g_ExactWardenCost)
			$iAvailBuilderCount -= 1
		EndIf
		For $iz = 0 To UBound($g_avBuildingUpgrades, 1) - 1
			; internal check if builder still available, if loop index upgrade slot is enabled, and if upgrade is not in progress
			If $iAvailBuilderCount > ($g_bUpgradeWallSaveBuilder ? 1 : 0) And $g_abBuildingUpgradeEnable[$iz] = True And $g_avBuildingUpgrades[$iz][7] = "" Then
				Switch $g_avBuildingUpgrades[$iz][3]
					Case "Gold"
						$iUpgradesNeedGold += Number($g_avBuildingUpgrades[$iz][2]) ; sum gold required for enabled upgrade
						$iAvailBuilderCount -= 1 ; subtract builder from free count, as only need to save gold for upgrades where builder is available
					Case "Elixir"
						$iUpgradesNeedElixir += Number($g_avBuildingUpgrades[$iz][2]) ; sum elixir required for enabled upgrade
						$iAvailBuilderCount -= 1 ; subtract builder from free count, as only need to save elixir for upgrades where builder is available
				EndSwitch
			EndIf
		Next
		; December 2024 : Add Lab Cost to Needed Elixir
		If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 Then
			$iUpgradesNeedElixir += Number($g_iLaboratoryElixirCost)
		EndIf
		SetDebugLog("SkipWall-Upgrade Summary: G:" & $iUpgradesNeedGold & ", E:" & $iUpgradesNeedElixir & ", Wall: " & $iWallCost & ", MinG: " & $g_iUpgradeWallMinGold & ", MinE: " & $g_iUpgradeWallMinElixir) ; debug
		If $iUpgradesNeedGold > 0 Or $iUpgradesNeedElixir > 0 Then ; if upgrade enabled and building upgrade resource is required, log user messages.
			Switch $g_iUpgradeWallLootType
				Case 0 ; Using gold
					If $g_aiCurrentLoot[$eLootGold] - ($iUpgradesNeedGold + $iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
						If $iUpgradesNeedGold > 0 Then SetLog("Skip wall upgrade, insufficient gold for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case 1 ; Using elixir
					If $g_aiCurrentLoot[$eLootElixir] - ($iUpgradesNeedElixir + $iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
						If $iUpgradesNeedElixir > 0 Then SetLog("Skip wall upgrade, insufficient elixir for selected upgrades", $COLOR_WARNING)
						Return True
					EndIf
				Case 2 ; Using gold and elixir
					If $g_aiCurrentLoot[$eLootElixir] - ($iUpgradesNeedElixir + $iWallCost + Number($g_iUpgradeWallMinElixir)) < 0 Then
						If $g_aiCurrentLoot[$eLootGold] - ($iUpgradesNeedGold + $iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
							SetLog("Skip wall upgrade, insufficient gold and elixir for selected upgrades", $COLOR_WARNING)
							Return True
						Else
							If $iUpgradesNeedElixir > 0 Then SetLog("Wall Upgrade: Insufficient elixir for selected upgrades", $COLOR_WARNING)
							SetLog("Using gold only for wall upgrade")
							$g_iUpgradeWallLootType = 0
						EndIf
					Else
						If $g_aiCurrentLoot[$eLootGold] - ($iUpgradesNeedGold + $iWallCost + Number($g_iUpgradeWallMinGold)) < 0 Then
							If $iUpgradesNeedGold > 0 Then SetLog("Wall Upgrade: Insufficient gold for selected upgrades", $COLOR_WARNING)
							SetLog("Using elixir only for wall upgrade")
							$g_iUpgradeWallLootType = 1
						EndIf
					EndIf
			EndSwitch
		EndIf
		If _Sleep($DELAYRESPOND) Then Return True
	EndIf
	;;;;;;;;;;;;;;;;;;;;;;;;;;;End upgrades value checking

	Return False
EndFunc   ;==>SkipWallUpgrade

Func WallUpgradeAllowedByTownHall($iWallLevel)
	Local $iMaxWallLevel = MaxWallLevelForTownHall()
	If $iMaxWallLevel < 1 Then
		SetDebugLog("Wall Level TH Check: Invalid Or Unsupported TH")
		Return False
	EndIf
	SetDebugLog("Wall Level TH Check: TH" & $g_iTownHallLevel & " Max Wall Level " & $iMaxWallLevel & ", Upgrade " & $iWallLevel & " To " & ($iWallLevel + 1))
	Return $iWallLevel + 1 <= $iMaxWallLevel
EndFunc   ;==>WallUpgradeAllowedByTownHall

Func MaxWallLevelForTownHall()
	Switch $g_iTownHallLevel
		Case 2 To 8
			Return $g_iTownHallLevel
		Case 9 To 18
			Return $g_iTownHallLevel + 1
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>MaxWallLevelForTownHall
