; #FUNCTION# ====================================================================================================================
; Name ..........: BotDetectFirstTime
; Description ...: This script detects your buildings on the first run
; Author ........: HungLe (04/2015)
; Modified ......: Hervidero (05/2015), HungLe (05/2015), KnowJack(07/2015), Sardo (08/2015), CodeSlinger69 (01/2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func BotDetectFirstTime()
	If $g_bIsClientSyncError Then Return ; if restart after OOS, and User stop/start bot, skip this.

	ClearScreen()
	If _Sleep($DELAYBOTDETECT1) Then Return

	SetLog("Detecting Buildings", $COLOR_INFO)
	AutoDetectTownHall()

	If Number($g_iTownHallLevel) > 1 And Number($g_iTownHallLevel) < 6 Then
		SetLog("Warning: Town Hall level below 6 is not recommended!", $COLOR_ERROR)
		SetLog("Proceed with caution as errors may occur", $COLOR_ERROR)
	EndIf

	If _Sleep($DELAYBOTDETECT1) Then Return
	; CheckImageType()
	If _Sleep($DELAYBOTDETECT1) Then Return

	;Display Level TH in Stats
	GUICtrlSetData($g_hLblTHLevels, "")

	_GUI_Value_STATE("HIDE", $g_aGroupListTHLevels)
	SetDebugLog("Select TH Level:" & Number($g_iTownHallLevel), $COLOR_DEBUG)
	GUICtrlSetState($g_ahPicTHLevels[$g_iTownHallLevel], $GUI_SHOW)
	GUICtrlSetData($g_hLblTHLevels, $g_iTownHallLevel)
EndFunc   ;==>BotDetectFirstTime

Func AutoDetectTownHall()
	Local $aiSavedTownHallPos = $g_aiTownHallPos
	Local $iSavedTownHallLevel = $g_iTownHallLevel
	Local $bLocalSearch = False

	$g_aiTownHallPos[0] = -1
	$g_aiTownHallPos[1] = -1

	If isInsideDiamond($aiSavedTownHallPos) Then
		Local $iLeft = $aiSavedTownHallPos[0] - 90
		Local $iTop = $aiSavedTownHallPos[1] - 90
		Local $iRight = $aiSavedTownHallPos[0] + 90
		Local $iBottom = $aiSavedTownHallPos[1] + 90
		If $iLeft < 0 Then $iLeft = 0
		If $iTop < 0 Then $iTop = 0
		If $iRight > $g_iGAME_WIDTH Then $iRight = $g_iGAME_WIDTH
		If $iBottom > $g_iGAME_HEIGHT Then $iBottom = $g_iGAME_HEIGHT
		Local $sLocalArea = GetDiamondFromRect2($iLeft, $iTop, $iRight, $iBottom)
		imglocTHSearch(True, True, True, $sLocalArea, True)
		$bLocalSearch = True
	EndIf

	If Not isInsideDiamond($g_aiTownHallPos) Then imglocTHSearch(True, True, Not $bLocalSearch)
	If isInsideDiamond($g_aiTownHallPos) Then
		BuildingClick($g_aiTownHallPos[0], $g_aiTownHallPos[1])
		If _Sleep($DELAYIMGLOCATE1) Then Return False
		Local $aTownHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If IsArray($aTownHallInfo) And StringInStr($aTownHallInfo[1], "Town") And Number($aTownHallInfo[2]) >= 2 Then
			$g_iTownHallLevel = Number($aTownHallInfo[2])
			SetLog("Town Hall Detected: (" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & "), Level: " & $g_iTownHallLevel, $COLOR_SUCCESS)
			SaveConfig()
			ClearScreen()
			Return True
		EndIf
		ClearScreen()
	EndIf

	$g_aiTownHallPos = $aiSavedTownHallPos
	$g_iTownHallLevel = $iSavedTownHallLevel
	If Not isInsideDiamond($g_aiTownHallPos) Then LogUnknownBuildingPosition("Town Hall")
	Return False
EndFunc   ;==>AutoDetectTownHall

Func LogUnknownBuildingPosition($sBuilding)
	SetLog($sBuilding & ": Unknow Position", $COLOR_DEBUG)
	SetLog("Require manual detection")
EndFunc   ;==>LogUnknownBuildingPosition
