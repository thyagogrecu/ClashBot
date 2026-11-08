; #FUNCTION# ===========================================================================================================
; Name ..........: Script Rotation GUI Control
; Author ........: Phael
; Description ...: Synchronizes Script Rotation controls, recipes, scripts, and siege selections.
; Remarks .......: Dead Base and Live Base modes share one Script Rotation configuration.
; ======================================================================================================================

#include-once

; === GLOBAL STATE ===
Global $g_sScriptRotationScriptItems = ""
Global Const $g_sScriptRotationDisabled = "Disabled"

; === VISIBILITY AND CONTROL ROUTING ===
Func ScriptRotationSetVisibility($bVisible, $iMode = Default)
	Local $iFirst = ($iMode = Default ? $DB : $iMode)
	Local $iLast = ($iMode = Default ? $LB : $iMode)
	Local $iState = $bVisible ? $GUI_SHOW : $GUI_HIDE
	For $i = $iFirst To $iLast
		For $j = 0 To UBound($g_aahScriptRotationControls, 2) - 1
			If $g_aahScriptRotationControls[$i][$j] <> 0 Then GUICtrlSetState($g_aahScriptRotationControls[$i][$j], $iState)
		Next
	Next
EndFunc   ;==>ScriptRotationSetVisibility

Func ScriptRotationGetControlMode($hControl = Default)
	If $hControl = Default Then $hControl = @GUI_CtrlId
	For $iMode = $DB To $LB
		For $iControl = 1 To UBound($g_aahScriptRotationControls, 2) - 1
			If $g_aahScriptRotationControls[$iMode][$iControl] = $hControl Then Return $iMode
		Next
	Next
	Return $LB
EndFunc   ;==>ScriptRotationGetControlMode

; === SCRIPT LIST MANAGEMENT ===
Func PopulateScriptRotationScripts()
	Local $hSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
	Local $sItems = ""
	If $hSearch <> -1 Then
		While True
			Local $sFile = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			$sItems &= StringTrimRight($sFile, 4) & "|"
		WEnd
		FileClose($hSearch)
	EndIf
	$g_sScriptRotationScriptItems = ($sItems <> "" ? StringTrimRight($sItems, 1) : "")
	For $iMode = $DB To $LB
		ScriptRotationPopulateScriptCombo($g_ahCmbScriptRotationScript[$iMode], $g_iScriptRotationEditorPhase)
	Next
EndFunc   ;==>PopulateScriptRotationScripts

Func ScriptRotationPopulateScriptCombo($hCombo, $iPhase)
	_GUICtrlComboBox_ResetContent($hCombo)
	If $g_sScriptRotationScriptItems <> "" Then GUICtrlSetData($hCombo, $g_sScriptRotationScriptItems)
	If $iPhase = $eScriptRotationTertiary Then _GUICtrlComboBox_InsertString($hCombo, $g_sScriptRotationDisabled, 0)
EndFunc   ;==>ScriptRotationPopulateScriptCombo

; === ATTACK MODE SYNCHRONIZATION ===
Func ScriptRotationEnsureScriptedModes()
	_GUICtrlComboBox_SetCurSel($g_hCmbDBAlgorithm, 1)
	_GUICtrlComboBox_SetCurSel($g_hCmbABAlgorithm, 1)
	cmbDBAlgorithm()
	cmbABAlgorithm()
EndFunc   ;==>ScriptRotationEnsureScriptedModes

Func ScriptRotationRestoreConfiguredModes()
	_GUICtrlComboBox_SetCurSel($g_hCmbDBAlgorithm, $g_aiAttackAlgorithm[$DB])
	_GUICtrlComboBox_SetCurSel($g_hCmbABAlgorithm, $g_aiAttackAlgorithm[$LB])
	cmbDBAlgorithm()
	cmbABAlgorithm()
EndFunc   ;==>ScriptRotationRestoreConfiguredModes

; === ENABLE STATE HANDLING ===
Func ScriptRotationToggle()
	Local $iMode = ScriptRotationGetControlMode()
	ScriptRotationSaveEditor($iMode)
	$g_bScriptRotationEnable = (GUICtrlRead($g_ahChkScriptRotationEnable[$iMode]) = $GUI_CHECKED)
	For $i = $DB To $LB
		GUICtrlSetState($g_ahChkScriptRotationEnable[$i], $g_bScriptRotationEnable ? $GUI_CHECKED : $GUI_UNCHECKED)
	Next
	If $g_bScriptRotationEnable Then
		ScriptRotationEnsureScriptedModes()
		ScriptRotationInvalidateRecipe()
		$g_bFullArmy = False
		$g_bFullArmySpells = False
		$g_bIsFullArmywithHeroesAndSpells = False
		$g_iActualTrainSkip = 0
		$g_abScriptRotationPhaseInitialized[ScriptRotationGetAccountIndex()] = False
		$g_aiScriptRotationAttackCount[ScriptRotationGetAccountIndex()] = 0
		$g_aiScriptRotationAttackTarget[ScriptRotationGetAccountIndex()] = 0
	Else
		$g_bScriptRotationPhaseChanged = False
		ScriptRotationRestoreConfiguredModes()
	EndIf
EndFunc   ;==>ScriptRotationToggle

; === EDITOR EVENTS ===
Func ScriptRotationSelectPhase()
	Local $iMode = ScriptRotationGetControlMode()
	ScriptRotationSaveEditor($iMode)
	Switch @GUI_CtrlId
		Case $g_ahRadScriptRotationSecondary[$iMode]
			$g_iScriptRotationEditorPhase = $eScriptRotationSecondary
		Case $g_ahRadScriptRotationTertiary[$iMode]
			$g_iScriptRotationEditorPhase = $eScriptRotationTertiary
		Case Else
			$g_iScriptRotationEditorPhase = $eScriptRotationPrimary
	EndSwitch
	ScriptRotationLoadEditor($g_iScriptRotationEditorPhase)
EndFunc   ;==>ScriptRotationSelectPhase

Func ScriptRotationEditorChanged()
	Local $iMode = ScriptRotationGetControlMode()
	ScriptRotationSaveEditor($iMode)
	ScriptRotationInvalidateRecipe()
	If $g_iScriptRotationEditorPhase = $eScriptRotationTertiary And $g_asScriptRotationScript[$eScriptRotationTertiary] = "" Then
		$g_aiScriptRotationDeploySiege[$eScriptRotationTertiary] = 0
		ScriptRotationLoadEditor($g_iScriptRotationEditorPhase)
	Else
		ScriptRotationLoadEditor($g_iScriptRotationEditorPhase, $iMode = $DB ? $LB : $DB)
	EndIf
EndFunc   ;==>ScriptRotationEditorChanged

Func ScriptRotationSiegeChanged()
	Local $iMode = ScriptRotationGetControlMode()
	ScriptRotationSaveEditor($iMode)
	ScriptRotationLoadEditor($g_iScriptRotationEditorPhase, $iMode = $DB ? $LB : $DB)
EndFunc   ;==>ScriptRotationSiegeChanged

; === EDITOR STATE PERSISTENCE ===
Func ScriptRotationSaveEditor($iMode = Default)
	If $iMode = Default Then $iMode = $LB
	If $g_ahCmbScriptRotationScript[$iMode] = 0 Then Return
	Local $iPhase = $g_iScriptRotationEditorPhase
	Local $iScriptIndex = _GUICtrlComboBox_GetCurSel($g_ahCmbScriptRotationScript[$iMode])
	Local $sScript = GUICtrlRead($g_ahCmbScriptRotationScript[$iMode])
	If IsString($sScript) Then
		If $iPhase = $eScriptRotationTertiary And $iScriptIndex = 0 Then
			$g_asScriptRotationScript[$iPhase] = ""
		ElseIf $sScript <> "" Then
			$g_asScriptRotationScript[$iPhase] = $sScript
		EndIf
	EndIf
	$g_aiScriptRotationDeploySiege[$iPhase] = _GUICtrlComboBox_GetCurSel($g_ahCmbScriptRotationDeploySiege[$iMode])
EndFunc   ;==>ScriptRotationSaveEditor

Func ScriptRotationLoadEditor($iPhase, $iMode = Default)
	If $iPhase <> $eScriptRotationTertiary And _
		(Not IsString($g_asScriptRotationScript[$iPhase]) Or $g_asScriptRotationScript[$iPhase] = "" Or $g_asScriptRotationScript[$iPhase] = "False") Then
		Local $iDefaultMode = ($iPhase = $eScriptRotationPrimary ? $DB : $LB)
		$g_asScriptRotationScript[$iPhase] = $g_sAttackScrScriptName[$iDefaultMode]
	EndIf
	If $iPhase = $eScriptRotationTertiary And $g_asScriptRotationScript[$iPhase] = "" Then _
		$g_aiScriptRotationDeploySiege[$iPhase] = 0
	Local $iFirst = ($iMode = Default ? $DB : $iMode)
	Local $iLast = ($iMode = Default ? $LB : $iMode)
	For $i = $iFirst To $iLast
		GUICtrlSetState($g_ahRadScriptRotationPrimary[$i], $iPhase = $eScriptRotationPrimary ? $GUI_CHECKED : $GUI_UNCHECKED)
		GUICtrlSetState($g_ahRadScriptRotationSecondary[$i], $iPhase = $eScriptRotationSecondary ? $GUI_CHECKED : $GUI_UNCHECKED)
		GUICtrlSetState($g_ahRadScriptRotationTertiary[$i], $iPhase = $eScriptRotationTertiary ? $GUI_CHECKED : $GUI_UNCHECKED)
		ScriptRotationPopulateScriptCombo($g_ahCmbScriptRotationScript[$i], $iPhase)
		Local $iIndex = -1
		If $iPhase = $eScriptRotationTertiary And $g_asScriptRotationScript[$iPhase] = "" Then
			$iIndex = 0
		Else
			Local $iFindAfter = ($iPhase = $eScriptRotationTertiary ? 0 : -1)
			$iIndex = _GUICtrlComboBox_FindStringExact($g_ahCmbScriptRotationScript[$i], $g_asScriptRotationScript[$iPhase], $iFindAfter)
		EndIf
		If $iIndex >= 0 Then
			_GUICtrlComboBox_SetCurSel($g_ahCmbScriptRotationScript[$i], $iIndex)
		Else
			GUICtrlSetData($g_ahCmbScriptRotationScript[$i], $g_asScriptRotationScript[$iPhase])
		EndIf
		_GUICtrlComboBox_SetCurSel($g_ahCmbScriptRotationDeploySiege[$i], $g_aiScriptRotationDeploySiege[$iPhase])
		UpdateAttackSiegeIcon($g_ahCmbScriptRotationDeploySiege[$i], $g_ahPicScriptRotationDeploySiege[$i])
	Next
EndFunc   ;==>ScriptRotationLoadEditor
