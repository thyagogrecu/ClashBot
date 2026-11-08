; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkStopAtkNoLoot1()
	If GUICtrlRead($g_hChkStopAtkNoLoot1) = $GUI_CHECKED Then
		$g_bStopAtkNoLoot1Enable = True
		GUICtrlSetState($g_hTxtStopAtkNoLoot1, $GUI_ENABLE)
		GUICtrlSetState($g_hLblTimeStopAtk, $GUI_ENABLE)
	Else
		$g_bStopAtkNoLoot1Enable = False
		GUICtrlSetState($g_hTxtStopAtkNoLoot1, $GUI_DISABLE)
		GUICtrlSetState($g_hLblTimeStopAtk, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkStopAtkNoLoot1

Func chkStopAtkNoLoot2()
	$g_bStopAtkNoLoot2Enable = (GUICtrlRead($g_hChkStopAtkNoLoot2) = $GUI_CHECKED)
	Local $iState = $g_bStopAtkNoLoot2Enable ? $GUI_ENABLE : $GUI_DISABLE
	Local $aControls[] = [$g_hLblStopAtkNoLoot2, $g_hTxtStopAtkNoLoot2, $g_hLblTimeStopAtk2, _
			$g_hLblMinRerourcesAtk2, $g_hTxtMinGoldStopAtk2, $g_hPicMinGoldStopAtk2, _
			$g_hTxtMinElixirStopAtk2, $g_hPicMinElixirStopAtk2, $g_hTxtMinDarkElixirStopAtk2, $g_hPicMinDarkElixirStopAtk2]
	For $hControl In $aControls
		GUICtrlSetState($hControl, $iState)
	Next
EndFunc   ;==>chkStopAtkNoLoot2

Func chkEndPercentHigher()
	If GUICtrlRead($g_hChkEndPercentHigher) = $GUI_CHECKED Then
		$g_bStopAtkPctHigherEnable = True
		GUICtrlSetState($g_hTxtPercentHigher, $GUI_ENABLE)
		GUICtrlSetState($g_hLblPercentHigherSec, $GUI_ENABLE)
	Else
		$g_bStopAtkPctHigherEnable = False
		GUICtrlSetState($g_hTxtPercentHigher, $GUI_DISABLE)
		GUICtrlSetState($g_hLblPercentHigherSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkEndPercentHigher

Func chkEndPercentChange()
	If GUICtrlRead($g_hChkEndPercentChange) = $GUI_CHECKED Then
		$g_bStopAtkPctNoChangeEnable = True
		GUICtrlSetState($g_hTxtPercentChange, $GUI_ENABLE)
		GUICtrlSetState($g_hLblPercentChangeSec, $GUI_ENABLE)
	Else
		$g_bStopAtkPctNoChangeEnable = False
		GUICtrlSetState($g_hTxtPercentChange, $GUI_DISABLE)
		GUICtrlSetState($g_hLblPercentChangeSec, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkEndPercentChange

Func cmbEndBattleStars()
	Local $iStars = _GUICtrlComboBox_GetCurSel($g_hCmbEndBattleStars)
	$g_bStopAtkOneStar = ($iStars = 1)
	$g_bStopAtkTwoStars = ($iStars = 2)
EndFunc   ;==>cmbEndBattleStars

Func chkTakeLootSS()
	GUICtrlSetState($g_hChkScreenshotLootInfo, GUICtrlRead($g_hChkTakeLootSS) = $GUI_CHECKED ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>chkTakeLootSS
