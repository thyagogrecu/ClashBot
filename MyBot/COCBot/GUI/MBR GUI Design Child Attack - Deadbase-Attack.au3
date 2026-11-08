; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Attack" tab under the "DeadBase" tab under the "Search & Attack" tab under the "Attack Plan" tab
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
Global $g_hCmbDBAlgorithm = 0, $g_hCmbDBSelectTroop = 0, $g_hChkDBKingAttack = 0, $g_hChkDBQueenAttack = 0, $g_hChkDBWardenAttack = 0, $g_hChkDBDropCC = 0
Global $g_hPicDBKingAttack = 0, $g_hPicDBQueenAttack = 0, $g_hPicDBDropCC = 0
Global $g_hCmbDBSiege = 0, $g_hChkDBChampionAttack = 0, $g_hPicDBChampionAttack = 0
Global $g_hChkDBPrinceAttack = 0, $g_hPicDBPrinceAttack = 0
Global $g_hChkDBDukeAttack = 0, $g_hPicDBDukeAttack = 0

Func CreateAttackSearchDeadBaseAttack()
	Local $sTxtTip = ""
	Local $x = 25, $y = 40
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Group_01", "Attack Mode"), $x - 20, $y - 15, 146, 74)
	$x -= 15
	$y += 2
	$g_hCmbDBAlgorithm = GUICtrlCreateCombo("", $x, $y, 135, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, "")
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_01", "Standard Attack") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_02", "Scripted Attack") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_04", "SmartFarm Attack"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Algorithm_Item_01", -1))
	GUICtrlSetOnEvent(-1, "cmbDBAlgorithm")

	$g_hCmbDBSelectTroop = GUICtrlCreateCombo("", -99, -99, 1, 1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "Use All Troops", "Use All Troops")
	_GUICtrlSetTip(-1, "Use all troops for every attack")
	_GUICtrlComboBox_SetCurSel($g_hCmbDBSelectTroop, 0)

	$g_hPicDBKingAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnKing, -99, -99, 1, 1)
	$g_hChkDBKingAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	$g_hPicDBQueenAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueen, -99, -99, 1, 1)
	$g_hChkDBQueenAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	$g_hPicDBPrinceAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPrince, -99, -99, 1, 1)
	$g_hChkDBPrinceAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	$g_hPicDBChampionAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampion, -99, -99, 1, 1)
	$g_hChkDBChampionAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	$g_hPicDBDukeAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDuke, -99, -99, 1, 1)
	$g_hChkDBDukeAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)

	$y += 27
	$g_hChkDBWardenAttack = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	GUICtrlSetState($g_hChkDBWardenAttack, $GUI_CHECKED)
	$g_hPicDBDropCC = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCC, $x, $y, 24, 24)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Chk-Use-Clan Castle_Info_01", "Drop your Clan Castle in battle if it contains troops.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hChkDBDropCC = GUICtrlCreateCheckbox("", -99, -99, 1, 1)
	GUICtrlSetState($g_hChkDBDropCC, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "chkDBDropCC")

	$x += 34
	$g_hCmbDBSiege = GUICtrlCreateCombo("", $x, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
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
			GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_12", "Sky Wagon"), GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Item_06", -1))
	GUICtrlSetOnEvent(-1, "cmbDBSiege")
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Attack", "Cmb-Siege_Tip", "Select Castle or Siege to be used." & @CRLF & _
			"The Bot will always check Castle/Siege type before every attack." & @CRLF & _
			"Choose 'Default' to bypass Castle/Siege check")
	_GUICtrlSetTip(-1, $sTxtTip)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	CreateScriptRotation($DB)
EndFunc   ;==>CreateAttackSearchDeadBaseAttack
