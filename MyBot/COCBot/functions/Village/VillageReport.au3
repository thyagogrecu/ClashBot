; #FUNCTION# ====================================================================================================================
; Name ..........: VillageReport
; Description ...: This function will report the village free and total builders, gold, elixir, dark elixir and gems.
;                  It will also update the statistics to the GUI.
; Syntax ........: VillageReport($bBypass = False, $bSuppressLog = False, $bDispatchExclusiveMode = True)
; Parameters ....: $bBypass, $bSuppressLog, $bDispatchExclusiveMode
; Return values .: None
; Author ........: Hervidero (2015-feb-10)
; Modified ......: Safar46 (2015), Hervidero (2015), KnowJack (June-2015) , ProMac (2015), Sardo 2015-08, MonkeyHunter(6-2106)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func VillageReport($bBypass = False, $bSuppressLog = False, $bDispatchExclusiveMode = True)
	ClearScreen()
	If _Sleep($DELAYVILLAGEREPORT1) Then Return

	; Close the event bar when its gray arrow is visible over the village.
	If _ColorCheck(_GetPixelColor(396, 695, True), Hex(0xFDFDFD, 6), 20) And _
			_ColorCheck(_GetPixelColor(400, 685, True), Hex(0xE2E2E2, 6), 20) Then
		Click(396, 695)
		If _Sleep($DELAYRESPOND) Then Return
	EndIf

	Switch $bBypass
		Case False
			If Not $bSuppressLog Then SetLog("Village Report", $COLOR_INFO)
		Case True
			If Not $bSuppressLog Then SetLog("Updating Village Resource Values", $COLOR_INFO)
		Case Else
			If Not $bSuppressLog Then SetLog("Village Report Error, You have been a BAD programmer!", $COLOR_ERROR)
	EndSwitch

	If Not IsMainPage(1) Then
		SetLog("Unable to read builders info at this time", $COLOR_ERROR)
		Return
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	If _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then ; check if the village have a Dark Elixir Storage
		$g_aiCurrentLoot[$eLootGold] = getResourcesMainScreen(690, 22)
		$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(690, 59)
		$g_aiCurrentLoot[$eLootDarkElixir] = getResourcesMainScreen(690, 96)
		$g_iGemAmount = getResourcesMainScreen(730, 133)
		If Not $bSuppressLog Then SetLog("[G]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & " [E]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & " [D]: " & _NumberFormat($g_aiCurrentLoot[$eLootDarkElixir]) & " [GEM]: " & _NumberFormat($g_iGemAmount), $COLOR_SUCCESS)
	Else
		$g_aiCurrentLoot[$eLootGold] = getResourcesMainScreen(690, 22)
		$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(690, 59)
		$g_iGemAmount = getResourcesMainScreen(730, 85)
		If Not $bSuppressLog Then SetLog("[G]: " & _NumberFormat($g_aiCurrentLoot[$eLootGold]) & " [E]: " & _NumberFormat($g_aiCurrentLoot[$eLootElixir]) & " [GEM]: " & _NumberFormat($g_iGemAmount), $COLOR_SUCCESS)
		If ProfileSwitchAccountEnabled() Then $g_aiCurrentLoot[$eLootDarkElixir] = "" ; prevent applying Dark Elixir of previous account to current account
	EndIf

	Local $bBuilderCountValid = getBuilderCount($bSuppressLog)
	If Not $bBuilderCountValid And Not IsMainPage(1) Then Return ; update builder data
	UpdateStats()

	Local $i = 0
	While _ColorCheck(_GetPixelColor(819, 39, True), Hex(0xF8FCFF, 6), 20) = True ; wait for Builder/shop to close
		$i += 1
		If _Sleep($DELAYVILLAGEREPORT1) Then Return
		If $i >= 2 Then ExitLoop
	WEnd

	If $bDispatchExclusiveMode Then
		; Only one exclusive attack mode can own this flow.
		If $g_bRushAttackEnabled And Not $g_bRushAttackRunning Then
			RushAttackCycle()
		ElseIf $g_bBBSpamEnabled And Not $g_bBBSpamRunning Then
			BBSpamCycle()
		ElseIf $g_bCCSpamEnabled And Not $g_bCCSpamRunning Then
			CCSpamCycle()
		EndIf
	EndIf
EndFunc   ;==>VillageReport

Func TestOCR()
	If Not IsMainPage(1) Then
		SetLog("TestOCR: Main Village screen not detected", $COLOR_ERROR)
		Return False
	EndIf

	Local $iGold = Number(getResourcesMainScreen(690, 22))
	Local $iElixir = Number(getResourcesMainScreen(690, 59))
	Local $iDarkElixir = Number(getResourcesMainScreen(690, 96))
	Local $iGems = Number(getResourcesMainScreen(730, 133))
	Local $sBuilderInfo = "", $sBuilderRaw = ""
	Local $aBuilderOcrOffset[5] = [0, -3, 3, -6, 6]
	For $i = 0 To UBound($aBuilderOcrOffset) - 1
		$sBuilderRaw = getBuilders($aBuildersDigits[0], $aBuildersDigits[1] + $aBuilderOcrOffset[$i], True)
		$sBuilderInfo = _NormalizeBuilderCount($sBuilderRaw)
		If $sBuilderInfo <> "" Then ExitLoop
	Next
	Local $sLaboratoryInfo = getLabBuilderCount(True)
	Local $bStarsAvailable = StarBonusSearch()
	Local $bBuildersValid = $sBuilderInfo <> ""
	Local $bLaboratoryValid = $sLaboratoryInfo <> ""
	Local $bResourcesValid = $iGold > 0 And $iElixir > 0 And $iDarkElixir >= 0 And $iGems >= 0
	Local $aiSavedLoot[3] = [$g_aiCurrentLoot[$eLootGold], $g_aiCurrentLoot[$eLootElixir], $g_aiCurrentLoot[$eLootDarkElixir]]
	Local $abSavedFullStorage[3] = [$g_abFullStorage[$eLootGold], $g_abFullStorage[$eLootElixir], $g_abFullStorage[$eLootDarkElixir]]
	Local $sStoragesFull = ""
	If $bResourcesValid Then
		$g_aiCurrentLoot[$eLootGold] = $iGold
		$g_aiCurrentLoot[$eLootElixir] = $iElixir
		$g_aiCurrentLoot[$eLootDarkElixir] = $iDarkElixir
		If isGoldFull(False) Then $sStoragesFull &= "Gold "
		If isElixirFull(False) Then $sStoragesFull &= "Elixir "
		If isDarkElixirFull(False) Then $sStoragesFull &= "Dark "
		$g_aiCurrentLoot[$eLootGold] = $aiSavedLoot[0]
		$g_aiCurrentLoot[$eLootElixir] = $aiSavedLoot[1]
		$g_aiCurrentLoot[$eLootDarkElixir] = $aiSavedLoot[2]
		$g_abFullStorage[$eLootGold] = $abSavedFullStorage[0]
		$g_abFullStorage[$eLootElixir] = $abSavedFullStorage[1]
		$g_abFullStorage[$eLootDarkElixir] = $abSavedFullStorage[2]
	EndIf
	If Not $bResourcesValid Then
		$sStoragesFull = "Unavailable"
	ElseIf $sStoragesFull = "" Then
		$sStoragesFull = "None"
	EndIf

	SetLog("[Gold]: " & _NumberFormat($iGold), $COLOR_INFO)
	SetLog("[Elixir]: " & _NumberFormat($iElixir), $COLOR_INFO)
	SetLog("[Dark]: " & _NumberFormat($iDarkElixir), $COLOR_INFO)
	SetLog("[Storages Full]: " & StringStripWS($sStoragesFull, 3), $COLOR_INFO)
	SetLog("[Gems]: " & _NumberFormat($iGems), $COLOR_INFO)
	SetLog("[Builders]: " & ($bBuildersValid ? StringReplace($sBuilderInfo, "#", "/") : "OCR failed"), $COLOR_INFO)
	SetLog("[Laboratory]: " & ($bLaboratoryValid ? StringReplace($sLaboratoryInfo, "#", "/") : "OCR failed"), $COLOR_INFO)
	SetLog("[Stars]: " & ($bStarsAvailable ? "Available" : "Unavailable"), $COLOR_INFO)
	Return $bResourcesValid And $bBuildersValid And $bLaboratoryValid
EndFunc   ;==>TestOCR
