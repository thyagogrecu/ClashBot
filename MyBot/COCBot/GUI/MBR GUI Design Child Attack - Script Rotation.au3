; #FUNCTION# ===========================================================================================================
; Name ..........: Script Rotation GUI Design
; Author ........: Phael
; Description ...: Creates the Script Rotation controls for scripted attack modes.
; Remarks .......: Recipe controls are registered for shared visibility and synchronization handling.
; ======================================================================================================================

#include-once

; === GLOBAL CONTROLS ===
Global $g_ahGrpScriptRotation[$g_iModeCount], $g_ahChkScriptRotationEnable[$g_iModeCount]
Global $g_ahRadScriptRotationPrimary[$g_iModeCount], $g_ahRadScriptRotationSecondary[$g_iModeCount], $g_ahRadScriptRotationTertiary[$g_iModeCount]
Global $g_ahCmbScriptRotationScript[$g_iModeCount]
Global $g_ahCmbScriptRotationDeploySiege[$g_iModeCount], $g_ahPicScriptRotationDeploySiege[$g_iModeCount]
Global $g_aahScriptRotationControls[$g_iModeCount][8]

; === CONTROL CREATION ===
Func CreateScriptRotation($iMode)
	$g_ahGrpScriptRotation[$iMode] = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Script Rotation", "Custom_Script_Rotation", "Script Rotation"), 5, 105, 146, 148)
	$g_ahChkScriptRotationEnable[$iMode] = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Script Rotation", "Custom_Enable_Script_Rotation", "Enable Script Rotation"), 13, 123, 132, 18)
	GUICtrlSetOnEvent(-1, "ScriptRotationToggle")

	$g_ahRadScriptRotationPrimary[$iMode] = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Script Rotation", "Custom_Recipe_1", "Recipe 1"), 13, 147, 62, 18)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "ScriptRotationSelectPhase")
	$g_ahRadScriptRotationSecondary[$iMode] = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Script Rotation", "Custom_Recipe_2", "Recipe 2"), 77, 147, 68, 18)
	GUICtrlSetOnEvent(-1, "ScriptRotationSelectPhase")
	$g_ahRadScriptRotationTertiary[$iMode] = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Attack - Script Rotation", "Custom_Recipe_3", "Recipe 3"), 45, 168, 62, 18)
	GUICtrlSetOnEvent(-1, "ScriptRotationSelectPhase")

	$g_ahCmbScriptRotationScript[$iMode] = GUICtrlCreateCombo("", 13, 190, 132, 22, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetOnEvent(-1, "ScriptRotationEditorChanged")

	$g_ahPicScriptRotationDeploySiege[$iMode] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, 13, 216, 24, 24)
	$g_ahCmbScriptRotationDeploySiege[$iMode] = GUICtrlCreateCombo("", 43, 217, 102, 22, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_06", "Default") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_05", "Any Siege") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_01", "Castle Only") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_02", "Wall Wrecker") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_03", "Battle Blimp") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_04", "Stone Slammer") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_07", "Siege Barracks") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_08", "Log Launcher") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_09", "Flame Flinger") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_10", "Battle Drill") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_11", "Troop Launcher") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_12", "Sky Wagon"))
	GUICtrlSetOnEvent(-1, "ScriptRotationSiegeChanged")

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$g_aahScriptRotationControls[$iMode][0] = $g_ahGrpScriptRotation[$iMode]
	$g_aahScriptRotationControls[$iMode][1] = $g_ahChkScriptRotationEnable[$iMode]
	$g_aahScriptRotationControls[$iMode][2] = $g_ahRadScriptRotationPrimary[$iMode]
	$g_aahScriptRotationControls[$iMode][3] = $g_ahRadScriptRotationSecondary[$iMode]
	$g_aahScriptRotationControls[$iMode][4] = $g_ahRadScriptRotationTertiary[$iMode]
	$g_aahScriptRotationControls[$iMode][5] = $g_ahCmbScriptRotationScript[$iMode]
	$g_aahScriptRotationControls[$iMode][6] = $g_ahPicScriptRotationDeploySiege[$iMode]
	$g_aahScriptRotationControls[$iMode][7] = $g_ahCmbScriptRotationDeploySiege[$iMode]
EndFunc   ;==>CreateScriptRotation
