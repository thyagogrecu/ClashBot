; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot
; Description ...: Uses the ColorCheck until the screen is clear from Clouds to Get Resources values.
; Author ........: HungLe (2015)
; Modified ......: ProMac (2015), Hervidero (2015), MonkeyHunter (08-2016)(05-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func GetResources($bLog = True, $pMatchMode = -1) ;Reads resources
	Static $iStuck = 0, $iSearchGold2 = 0, $iSearchElixir2 = 0

	If _Sleep($DELAYRESPOND) Then Return False
	$g_iSearchGold = ""
	$g_iSearchElixir = ""
	$g_iSearchDark = ""
	$g_iSearchTrophy = ""

	SuspendAndroid()

	Local $iCount = 0
	While (getGoldVillageSearch(48, 69) = "") Or (getElixirVillageSearch(48, 69 + 29) = "")
		$iCount += 1
		If _Sleep($DELAYGETRESOURCES3) Then Return False
		If $iCount >= 50 Or isProblemAffect(True) Then ExitLoop ; Wait 50*150ms=7.5 seconds max to read resources
	WEnd

	If _Sleep($DELAYRESPOND) Then Return False
	$g_iSearchGold = getGoldVillageSearch(48, 69)
	If _Sleep($DELAYRESPOND) Then Return False
	$g_iSearchElixir = getElixirVillageSearch(48, 69 + 29)
	If _Sleep($DELAYRESPOND) Then Return False
	If $g_iSearchGold = "" Or $g_iSearchElixir = "" Then
		resetAttackSearch(True)
		Return False
	EndIf

	If _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixir1") Or _ColorCheck(_GetPixelColor(31, 151, True), Hex(0x0F0617, 6), 5) Then ; check if the village have a Dark Elixir Storage
		$g_iSearchDark = getDarkElixirVillageSearch(48, 126)
	Else
		$g_iSearchDark = "N/A"
	EndIf

	If $g_iSearchGold = $iSearchGold2 And $g_iSearchElixir = $iSearchElixir2 Then $iStuck += 1
	If $g_iSearchGold <> $iSearchGold2 Or $g_iSearchElixir <> $iSearchElixir2 Then $iStuck = 0

	$iSearchGold2 = $g_iSearchGold
	$iSearchElixir2 = $g_iSearchElixir

	If $iStuck >= 5 Then
		SetDebugLog("GetResources: same resources repeated, keeping current village for normal filter checks", $COLOR_DEBUG)
		$iStuck = 0
	EndIf

	If isProblemAffect(True) Then
		$iStuck = 0
		resetAttackSearch(True)
		Return False
	EndIf

	$g_iSearchCount += 1 ; Counter for number of searches

	ResumeAndroid()

	Return True
EndFunc   ;==>GetResources

; Tests the currently visible attack-search loot OCR without changing search state.
Func TestAttackOCR()
	Local $bSearchScreen = _ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1], True), Hex($NextBtn[2], 6), $NextBtn[3])
	If Not $bSearchScreen Then $bSearchScreen = QuickMIS("BC1", $g_sImgNextButton, 700, 500 + $g_iBottomOffsetY, 850, 620 + $g_iBottomOffsetY)
	If Not $bSearchScreen Then
		SetLog("TestAttackOCR: Attack/search screen not detected", $COLOR_ERROR)
		Return False
	EndIf

	Local $sGold = StringRegExpReplace(getGoldVillageSearch(48, 69), "\D", "")
	Local $sElixir = StringRegExpReplace(getElixirVillageSearch(48, 69 + 29), "\D", "")
	Local $bHasDarkElixir = _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixirTest") Or _ColorCheck(_GetPixelColor(31, 151, True), Hex(0x0F0617, 6), 5)
	Local $sDarkElixir = $bHasDarkElixir ? StringRegExpReplace(getDarkElixirVillageSearch(48, 126), "\D", "") : "N/A"

	SetLog("[Available Gold]: " & ($sGold <> "" ? _NumberFormat(Number($sGold)) : "OCR failed"), $COLOR_INFO)
	SetLog("[Available Elixir]: " & ($sElixir <> "" ? _NumberFormat(Number($sElixir)) : "OCR failed"), $COLOR_INFO)
	SetLog("[Available Dark Elixir]: " & ($sDarkElixir = "N/A" ? "N/A" : ($sDarkElixir <> "" ? _NumberFormat(Number($sDarkElixir)) : "OCR failed")), $COLOR_INFO)

	Return $sGold <> "" And $sElixir <> "" And ($sDarkElixir = "N/A" Or $sDarkElixir <> "")
EndFunc   ;==>TestAttackOCR

Func resetAttackSearch($bStuck = False)
	; function to check main screen and restart search and display why as needed
	If $bStuck And _RecoverSearchWithNext("resources") Then Return

	$g_bIsClientSyncError = True
	checkMainScreen()
	If $g_bRestart Then
		$g_iNbrOfOoS += 1
		UpdateStats()
		If $bStuck Then
			SetLog("Connection Lost While Searching", $COLOR_ERROR)
		Else
			SetLog("Disconnected At Search Clouds", $COLOR_ERROR)
		EndIf
		PushMsg("OoSResources")
	Else
		If $bStuck Then
			SetLog("Attack is disabled or slow connection issues, restarting Clash of Clans and Bot...", $COLOR_ERROR)
		Else
			SetLog("Stuck at Search Clouds, restarting Clash of Clans and Bot...", $COLOR_ERROR)
		EndIf
		$g_bIsClientSyncError = False ; disable fast OOS restart if not simple error and restarting CoC
		CloseCoC(True)
	EndIf
	Return
EndFunc   ;==>resetAttackSearch

Func _RecoverSearchWithNext($sReason)
	For $i = 1 To 6
		If _Sleep(150) Then Return False
		_CaptureRegions()
		If IsAttackPage(False) And (_ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1]), Hex($NextBtn[2], 6), $NextBtn[3]) Or _
				QuickMIS("BC1", $g_sImgNextButton, 700, 500 + $g_iBottomOffsetY, 760, 555 + $g_iBottomOffsetY)) Then
			SetDebugLog("Search recovery: skipping current village after " & $sReason & " read issue", $COLOR_DEBUG)
			$g_bCloudsActive = True
			ResumeAndroid()
			Click(Random($NextBtnRND[0], $NextBtnRND[2], 1), Random($NextBtnRND[1], $NextBtnRND[3], 1), 1, 120, "#0155")
			Return True
		EndIf
	Next

	Return False
EndFunc   ;==>_RecoverSearchWithNext
