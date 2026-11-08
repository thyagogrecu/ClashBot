; #FUNCTION# ====================================================================================================================
; Name ..........: BuilderBaseReport()
; Description ...: Make Resources report of Builders Base
; Syntax ........: BuilderBaseReport()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (05-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BuilderBaseReport($bBypass = False, $bSetLog = True)
	ClearScreen("Defaut", False)
	If _Sleep($DELAYVILLAGEREPORT1) Then Return

	; Close the event bar when its gray arrow is visible over the Builder Base.
	If _ColorCheck(_GetPixelColor(396, 695, True), Hex(0xFDFDFD, 6), 20) And _
			_ColorCheck(_GetPixelColor(400, 685, True), Hex(0xE2E2E2, 6), 20) Then
		Click(396, 695)
		If _Sleep($DELAYRESPOND) Then Return
	EndIf

	Switch $bBypass
		Case False
			If $bSetLog Then SetLog("Builder Base Report", $COLOR_INFO)
		Case True
			If $bSetLog Then SetLog("Updating Builder Base Resource Values", $COLOR_INFO)
		Case Else
			If $bSetLog Then SetLog("Builder Base Village Report Error, You have been a BAD programmer!", $COLOR_ERROR)
	EndSwitch

	If Not IsMainPageBuilderBase(1) Then
		SetLog("Unable to read builders info at this time", $COLOR_ERROR)
		Return
	EndIf
	If _Sleep($DELAYRESPOND) Then Return

	$g_aiCurrentLootBB[$eLootTrophyBB] = getTrophyBuilderBase($aTrophiesBuilderBase[0], $aTrophiesBuilderBase[1])
	$g_aiCurrentLootBB[$eLootGoldBB] = getResourcesMainScreen(690, 22)
	$g_aiCurrentLootBB[$eLootElixirBB] = getResourcesMainScreen(690, 59)
	If Not getBuilderCount(Not $bSetLog, True) And Not IsMainPageBuilderBase(1) Then Return ; update builder data
	If $bSetLog Then SetLog("[G]: " & _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB]) & " [E]: " & _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB]) & " [T]: " & _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB]), $COLOR_SUCCESS)

	PicBBTrophies()

	UpdateStats()

	; Auto-disable drop trophies if elixir storage is full, like halt attack
	If $g_bChkDropTrophyBB And CheckBBElixirStorageFull(False) Then
		$g_bChkDropTrophyBB = False
		GUICtrlSetState($g_hChkDropTrophyBB, $GUI_UNCHECKED)
		If $bSetLog Then SetLog("Elixir storage full, disabling Drop Trophies", $COLOR_INFO)
	EndIf

	If ProfileSwitchAccountEnabled() Then SwitchAccountVariablesReload("Save")
EndFunc   ;==>BuilderBaseReport

; #FUNCTION# ===========================================================================================================
; Name ..........: TestBBOCR
; Description ...: Tests the Master Builder free/total OCR using the Builder Base report coordinates.
; Remarks .......: Logs raw and normalized results without changing builder state or restarting the game.
; ======================================================================================================================

Func TestBBOCR()
	If Not IsMainPageBuilderBase(1) Then
		SetLog("TestBBOCR: Builder Base screen not detected", $COLOR_ERROR)
		Return False
	EndIf
	Local $iGold = Number(getResourcesMainScreen(690, 22))
	Local $iElixir = Number(getResourcesMainScreen(690, 59))
	Local $iTrophies = getTrophyBuilderBase($aTrophiesBuilderBase[0], $aTrophiesBuilderBase[1])
	Local $bGoldFull = CheckBBGoldStorageFull(False)
	Local $bElixirFull = CheckBBElixirStorageFull(False)
	Local $sBuilderInfo = "", $sBuilderRaw = ""
	Local $aBuilderOcrOffset[3] = [0, -1, 1]
	For $i = 0 To UBound($aBuilderOcrOffset) - 1
		$sBuilderRaw = getBuilders($aBuildersDigitsBuilderBase[0], $aBuildersDigitsBuilderBase[1] + $aBuilderOcrOffset[$i], True, True)
		$sBuilderInfo = _NormalizeBuilderCount($sBuilderRaw)
		If $sBuilderInfo <> "" Then ExitLoop
	Next
	Local $sStars = _ReadBBStarsOCR()
	Local $aStars = StringSplit($sStars, "#", $STR_NOCOUNT)
	Local $bStarsValid = IsArray($aStars) And UBound($aStars) = 2 And StringIsDigit($aStars[0]) And StringIsDigit($aStars[1]) And Number($aStars[1]) > 0
	Local $sStarLabInfo = getLabBuilderCount()
	Local $bStarLabValid = StringRegExp($sStarLabInfo, "^[01]#1$")

	SetLog("[Gold]: " & _NumberFormat($iGold), $COLOR_INFO)
	SetLog("[Elixir]: " & _NumberFormat($iElixir), $COLOR_INFO)
	Local $sStoragesFull = ""
	If $bGoldFull Then $sStoragesFull &= "Gold "
	If $bElixirFull Then $sStoragesFull &= "Elixir "
	If $sStoragesFull = "" Then $sStoragesFull = "None"
	SetLog("[Storages Full]: " & StringStripWS($sStoragesFull, $STR_STRIPLEADING + $STR_STRIPTRAILING), $COLOR_INFO)
	SetLog("[Trophies]: " & ($iTrophies > 0 ? _NumberFormat($iTrophies) : "OCR failed"), $COLOR_INFO)
	SetLog("[Builders]: " & ($sBuilderInfo <> "" ? StringReplace($sBuilderInfo, "#", "/") : "OCR failed"), $COLOR_INFO)
	SetLog("[Star Laboratory]: " & ($bStarLabValid ? StringReplace($sStarLabInfo, "#", "/") : "OCR failed"), $COLOR_INFO)
	SetLog("[Stars]: " & ($bStarsValid ? $aStars[0] & "/" & $aStars[1] : "OCR failed"), $COLOR_INFO)
	Return $iGold > 0 And $iElixir > 0 And $iTrophies > 0 And $sBuilderInfo <> "" And $bStarLabValid And $bStarsValid
EndFunc   ;==>TestBBOCR

Func PicBBTrophies()
	_GUI_Value_STATE("HIDE", $g_aGroupBBLeague)
	If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[41][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueDiamond], $GUI_SHOW)
		GUICtrlSetState($g_hLblBBLeague1, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague2, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague3, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[38][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueRuby], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[40][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[39][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[38][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[35][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueEmerald], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[37][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[36][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[35][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[32][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeaguePlatinum], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[34][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[33][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[32][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[29][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueTitanium], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[31][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[30][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[29][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[26][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueSteel], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[28][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[27][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[26][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[23][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueIron], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[25][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[24][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[23][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[20][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueBrass], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[22][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[21][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[20][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		EndIf
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[15][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueCopper], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[19][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[18][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[17][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[16][1]) Then
			GUICtrlSetState($g_hLblBBLeague4, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[15][1]) Then
			GUICtrlSetState($g_hLblBBLeague5, $GUI_SHOW)
		EndIf
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[10][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueStone], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[14][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[13][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[12][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[11][1]) Then
			GUICtrlSetState($g_hLblBBLeague4, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[10][1]) Then
			GUICtrlSetState($g_hLblBBLeague5, $GUI_SHOW)
		EndIf
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[5][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueClay], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[9][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[8][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[7][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[6][1]) Then
			GUICtrlSetState($g_hLblBBLeague4, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[5][1]) Then
			GUICtrlSetState($g_hLblBBLeague5, $GUI_SHOW)
		EndIf
	ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[0][1]) Then
		GUICtrlSetState($g_ahPicBBLeague[$eLeagueWood], $GUI_SHOW)
		If Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[4][1]) Then
			GUICtrlSetState($g_hLblBBLeague1, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[3][1]) Then
			GUICtrlSetState($g_hLblBBLeague2, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[2][1]) Then
			GUICtrlSetState($g_hLblBBLeague3, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[1][1]) Then
			GUICtrlSetState($g_hLblBBLeague4, $GUI_SHOW)
		ElseIf Number($g_aiCurrentLootBB[$eLootTrophyBB]) >= Number($g_asBBLeagueDetails[0][1]) Then
			GUICtrlSetState($g_hLblBBLeague5, $GUI_SHOW)
		EndIf
	Else
		GUICtrlSetState($g_ahPicBBLeague[$eBBLeagueUnranked], $GUI_SHOW)
		GUICtrlSetState($g_hLblBBLeague1, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague2, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague3, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague4, $GUI_HIDE)
		GUICtrlSetState($g_hLblBBLeague5, $GUI_HIDE)
	EndIf
EndFunc   ;==>PicBBTrophies
