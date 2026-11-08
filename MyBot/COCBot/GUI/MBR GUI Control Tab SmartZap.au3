; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 [2017]
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func UpdateSmartZapControls()
	$g_bSmartZapUseLightning = (GUICtrlRead($g_hChkSmartLightSpell) = $GUI_CHECKED)
	$g_bEarthQuakeZap = (GUICtrlRead($g_hChkSmartEQSpell) = $GUI_CHECKED)
	$g_bSmartZapEnable = ($g_bSmartZapUseLightning Or $g_bEarthQuakeZap)

	GUICtrlSetState($g_hCmbSmartZapTarget, $g_bSmartZapEnable ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_hCmbSmartZapSecondaryTarget, $g_bSmartZapEnable ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_hCmbSmartZapTiming, $g_bSmartZapEnable ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_hTxtSmartZapSpellsPerTarget, $g_bSmartZapUseLightning ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_hTxtSmartZapEarthquakesPerTarget, $g_bEarthQuakeZap ? $GUI_ENABLE : $GUI_DISABLE)

	If $g_bSmartZapEnable Then
		cmbSmartZapTarget()
		cmbSmartZapSecondaryTarget()
		cmbSmartZapTiming()
	EndIf
	If $g_bSmartZapUseLightning Then txtSmartZapSpellsPerTarget()
	If $g_bEarthQuakeZap Then txtSmartZapEarthquakesPerTarget()
EndFunc   ;==>UpdateSmartZapControls

Func chkSmartLightSpell()
	UpdateSmartZapControls()
EndFunc   ;==>chkSmartLightSpell

Func chkEarthQuakeZap()
	UpdateSmartZapControls()
EndFunc   ;==>chkEarthQuakeZap

Func cmbSmartZapTarget()
	$g_iSmartZapTarget = SmartZapTargetFromComboIndex(_GUICtrlComboBox_GetCurSel($g_hCmbSmartZapTarget))
EndFunc   ;==>cmbSmartZapTarget

Func cmbSmartZapSecondaryTarget()
	$g_iSmartZapSecondaryTarget = SmartZapTargetFromComboIndex(_GUICtrlComboBox_GetCurSel($g_hCmbSmartZapSecondaryTarget) - 1)
EndFunc   ;==>cmbSmartZapSecondaryTarget

Func SmartZapTargetFromComboIndex($iComboIndex)
	Switch $iComboIndex
		Case 1
			Return $eSmartZapTargetAirDefense
		Case 2
			Return $eSmartZapTargetAirSweeper
		Case 3
			Return $eSmartZapTargetEagle
		Case 4
			Return $eSmartZapTargetFirespitter
		Case 5
			Return $eSmartZapTargetInferno
		Case 6
			Return $eSmartZapTargetMonolith
		Case 7
			Return $eSmartZapTargetMortar
		Case 8
			Return $eSmartZapTargetRevengeTower
		Case 9
			Return $eSmartZapTargetScatterShot
		Case 10
			Return $eSmartZapTargetWizardTower
		Case 11
			Return $eSmartZapTargetXBow
		Case 0
			Return $eSmartZapTargetDrill
		Case Else
			Return -1
	EndSwitch
EndFunc   ;==>SmartZapTargetFromComboIndex

Func SmartZapTargetComboIndex()
	Return SmartZapTargetToComboIndex($g_iSmartZapTarget)
EndFunc   ;==>SmartZapTargetComboIndex

Func SmartZapSecondaryTargetComboIndex()
	If $g_iSmartZapSecondaryTarget < $eSmartZapTargetDrill Then Return 0
	Return SmartZapTargetToComboIndex($g_iSmartZapSecondaryTarget) + 1
EndFunc   ;==>SmartZapSecondaryTargetComboIndex

Func SmartZapTargetToComboIndex($iTarget)
	Switch $iTarget
		Case $eSmartZapTargetAirDefense
			Return 1
		Case $eSmartZapTargetAirSweeper
			Return 2
		Case $eSmartZapTargetEagle
			Return 3
		Case $eSmartZapTargetFirespitter
			Return 4
		Case $eSmartZapTargetInferno
			Return 5
		Case $eSmartZapTargetMonolith
			Return 6
		Case $eSmartZapTargetMortar
			Return 7
		Case $eSmartZapTargetRevengeTower
			Return 8
		Case $eSmartZapTargetScatterShot
			Return 9
		Case $eSmartZapTargetWizardTower
			Return 10
		Case $eSmartZapTargetXBow
			Return 11
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>SmartZapTargetToComboIndex

Func txtSmartZapSpellsPerTarget()
	$g_iSmartZapSpellsPerTarget = Int(GUICtrlRead($g_hTxtSmartZapSpellsPerTarget))
	If $g_iSmartZapSpellsPerTarget < 1 Then $g_iSmartZapSpellsPerTarget = 1
	If $g_iSmartZapSpellsPerTarget > 99 Then $g_iSmartZapSpellsPerTarget = 99
	GUICtrlSetData($g_hTxtSmartZapSpellsPerTarget, $g_iSmartZapSpellsPerTarget)
EndFunc   ;==>txtSmartZapSpellsPerTarget

Func txtSmartZapEarthquakesPerTarget()
	$g_iSmartZapEarthquakesPerTarget = Int(GUICtrlRead($g_hTxtSmartZapEarthquakesPerTarget))
	If $g_iSmartZapEarthquakesPerTarget < 1 Then $g_iSmartZapEarthquakesPerTarget = 1
	If $g_iSmartZapEarthquakesPerTarget > 99 Then $g_iSmartZapEarthquakesPerTarget = 99
	GUICtrlSetData($g_hTxtSmartZapEarthquakesPerTarget, $g_iSmartZapEarthquakesPerTarget)
EndFunc   ;==>txtSmartZapEarthquakesPerTarget

Func cmbSmartZapTiming()
	$g_iSmartZapTiming = _GUICtrlComboBox_GetCurSel($g_hCmbSmartZapTiming)
	If $g_iSmartZapTiming < $eSmartZapTimingStart Or $g_iSmartZapTiming > $eSmartZapTimingEnd Then $g_iSmartZapTiming = $eSmartZapTimingStart
	$g_bSmartZapBeforeAttack = ($g_bSmartZapEnable And $g_iSmartZapTiming = $eSmartZapTimingStart)
EndFunc   ;==>cmbSmartZapTiming
