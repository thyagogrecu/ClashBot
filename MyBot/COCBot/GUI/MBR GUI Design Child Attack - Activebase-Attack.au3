; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack" tab under the "ActiveBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

; Attack with
Global $g_hCmbABAlgorithm = 0, $g_hCmbABSelectTroop = 0, $g_hChkABKingAttack = 0, $g_hChkABQueenAttack = 0, $g_hChkABWardenAttack = 0, $g_hChkABDropCC = 0
Global $g_hGrpABAttack = 0, $g_hPicABKingAttack = 0, $g_hPicABQueenAttack = 0, $g_hPicABDropCC = 0
Global $g_hCmbABSiege = 0, $g_hChkABChampionAttack = 0, $g_hPicABChampionAttack = 0
Global $g_hChkABPrinceAttack = 0, $g_hPicABPrinceAttack = 0
Global $g_hChkABDukeAttack = 0, $g_hPicABDukeAttack = 0

Func CreateAttackSearchActiveBaseAttack()
	Local $sTxtTip = ""
	Local $x = 25, $y = 40
	$g_hGrpABAttack = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_01", "Attack Mode"), $x - 20, $y - 15, 146, 74)
	$x -= 15
	$y += 2
	$g_hCmbABAlgorithm = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, "")
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_01", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_02", -1), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_01", -1))
	GUICtrlSetOnEvent(-1, "cmbABAlgorithm")

	$g_hCmbABSelectTroop = GUICtrlCreateCombo("", -99, -99, 1, 1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Use All Troops", "Use All Troops")
	_GUICtrlSetTip(-1, "Use all troops for every attack")
	_GUICtrlComboBox_SetCurSel($g_hCmbABSelectTroop, 0)

	$g_hPicABKingAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, -99, -99, 1, 1)
	$g_hChkABKingAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	$g_hPicABQueenAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, -99, -99, 1, 1)
	$g_hChkABQueenAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	$g_hPicABPrinceAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPrince, -99, -99, 1, 1)
	$g_hChkABPrinceAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	$g_hPicABChampionAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampion, -99, -99, 1, 1)
	$g_hChkABChampionAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	$g_hPicABDukeAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDuke, -99, -99, 1, 1)
	$g_hChkABDukeAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)

	$y += 27
	$g_hChkABWardenAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	GUICtrlSetState($g_hChkABWardenAttack, $GUI_CHECKED)
	$g_hPicABDropCC = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x, $y, 24, 24)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Clan Castle_Info_01", -1)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hChkABDropCC = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	GUICtrlSetState($g_hChkABDropCC, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "chkABDropCC")

	$x += 34
	$g_hCmbABSiege = GUICtrlCreateCombo("", $x, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_06", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_05", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_01", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_02", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_03", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_04", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_07", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_08", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_09", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_10", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_11", -1) & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_12", -1), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_06", -1))
	GUICtrlSetOnEvent(-1, "cmbABSiege")
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Tip", -1)
	_GUICtrlSetTip(-1, $sTxtTip)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	CreateScriptRotation($LB)
EndFunc   ;==>CreateAttackSearchActiveBaseAttack
