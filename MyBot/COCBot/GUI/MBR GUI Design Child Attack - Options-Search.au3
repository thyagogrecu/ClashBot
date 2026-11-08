; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Search" tab under the "Options" tab under the "Search & Attack" tab under the "Attack Plan" tab
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

Global $g_hChkSearchReduction = 0, $g_hTxtSearchReduceCount = 0, $g_hTxtSearchReduceGold = 0, $g_hTxtSearchReduceElixir = 0, $g_hTxtSearchReduceGoldPlusElixir = 0, _
	   $g_hTxtSearchReduceDark = 0
Global $g_hChkEnableTournament = 0
Global $g_hChkAttackNow = 0, $g_hCmbAttackNowDelay = 0, $g_hLblAttackNow = 0, $g_hLblAttackNowSec = 0, $g_hChkRestartSearchLimit = 0, $g_hTxtRestartSearchlimit = 0, $g_hChkAlertSearch = 0
Global $g_hChkSmartLightSpell = 0, $g_hChkSmartEQSpell = 0, $g_hTxtSmartZapEarthquakesPerTarget = 0, $g_hCmbSmartZapTarget = 0, $g_hCmbSmartZapSecondaryTarget = 0, _
	   $g_hTxtSmartZapSpellsPerTarget = 0, $g_hCmbSmartZapTiming = 0

Func CreateAttackSearchOptionsSearch()

	Local $sTxtTip = ""
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "Group_03", "Search Options"), $x - 20, $y - 20, 223, 347)
	$x -= 13
	$y -= 5
		$g_hChkRestartSearchLimit = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkRestartSearchLimit", "Restart every") & ":", $x, $y - 4, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkRestartSearchLimit_Info_01", "Return To Base after x searches and restart to search enemy villages.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_CHECKED)
			GUICtrlSetOnEvent(-1, "chkRestartSearchLimit")
		$g_hTxtRestartSearchlimit = GUICtrlCreateInput("50", $x + 15, $y + 15, 25, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "search(es).", -1), $x + 47, $y + 17, -1, -1)

	$y += 48
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblTargetReduction", "Target Reduction"), $x, $y, 190, 16)

	$y += 17
		$g_hChkSearchReduction = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkSearchReduction", "Enable Search Reduction"), $x, $y - 4, -1, -1)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkSearchReduction_Info_01", "Check this if you want the search values to automatically be lowered after a certain amount of searches."))
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			GUICtrlSetOnEvent(-1, "chkSearchReduction")

	$y += 20
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceCount", "Reduce targets every"), $x, $y + 3, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceCount_Info_01", "Enter the No. of searches to wait before each reduction occurs.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtSearchReduceCount = GUICtrlCreateInput("20", $x + 115, $y + 2, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "search(es).", -1), $x + 160, $y + 3, -1, -1)

	$y += 21
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceGold", "- Reduce Gold"), $x, $y + 3, -1, 17)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceGold_Info_01", "Lower value for Gold by this amount on each step.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtSearchReduceGold = GUICtrlCreateInput("2000", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 160, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceElixir", "- Reduce Elixir"), $x, $y + 3, -1, 17)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceElixir_Info_01", "Lower value for Elixir by this amount on each step.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtSearchReduceElixir = GUICtrlCreateInput("2000", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 160, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceGoldPlusElixir", "- Reduce Gold + Elixir"), $x, $y + 3, -1, 17)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceGoldPlusElixir_Info_01", "Lower total sum for G+E by this amount on each step.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtSearchReduceGoldPlusElixir = GUICtrlCreateInput("4000", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 5)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 160, $y + 1, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlCreateLabel("+", $x + 176, $y + 1, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 182, $y + 1, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 21
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceDark", "- Reduce Dark Elixir"), $x, $y + 3, -1, 17)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSearchReduceDark_Info_01", "Lower value for Dark Elixir by this amount on each step.")
			_GUICtrlSetTip(-1, $sTxtTip)
		$g_hTxtSearchReduceDark = GUICtrlCreateInput("100", $x + 115, $y, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 3)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 160, $y, 16, 16)
			_GUICtrlSetTip(-1, $sTxtTip)

	$y += 38
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblManualControl", "Manual Control"), $x, $y, 190, 16)

	$y += 17
		$g_hChkAttackNow = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAttackNow", "Enable Attack Now! Option"), $x, $y - 4, -1, -1)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAttackNow_Info_01", "Check this if you want the option to have an 'Attack Now!' button next to") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAttackNow_Info_02", "the Start and Pause buttons to bypass the dead base or all base search values.") & @CRLF & _
					   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkAttackNow_Info_03", "The Attack Now! button will only appear when searching for villages to Attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkAttackNow")
	$y += 22
		$g_hLblAttackNow = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblAttackNow", "Reaction Time") & ":", $x, $y + 3, 92, -1, $SS_RIGHT)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblAttackNow_Info_01", "Add this amount of reaction time to slow down the search.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hCmbAttackNowDelay = GUICtrlCreateCombo("", $x + 97, $y, 35, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, "0|1|2|3|4|5", "3") ; default value 3
			GUICtrlSetState(-1, $GUI_DISABLE)
		$g_hLblAttackNowSec = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "sec.", -1), $x + 137, $y + 3, -1, -1)
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 253
	$y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "Group_04", "SmartZap"), $x - 20, $y - 20, 189, 197)
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x - 15, $y - 4, 24, 24)
		$g_hChkSmartLightSpell = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkSmartLightSpell", "Use Lightning"), $x + 15, $y - 3, 130, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkSmartLightSpell_Info_01", "Drop Lightning spells on Dark Elixir Drills.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkSmartLightSpell")

	$y += 25
		_GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x - 15, $y - 4, 24, 24)
		$g_hChkSmartEQSpell = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkSmartEQSpell", "Use Earthquake"), $x + 15, $y - 3, 130, 24)
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "ChkSmartEQSpell_Info_01", "Drop Earthquake spells on selected SmartZap targets.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetOnEvent(-1, "chkEarthQuakeZap")

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSmartZapSpellsPerTarget", "Lightning") & ":", $x - 15, $y + 4, 75, 17, $SS_RIGHT)
		$g_hTxtSmartZapSpellsPerTarget = GUICtrlCreateInput("2", $x + 65, $y, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "TxtSmartZapSpellsPerTarget_Info_01", "Lightning spells to drop on each target before moving to the next one.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetOnEvent(-1, "txtSmartZapSpellsPerTarget")
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSmartZapPerTarget", "per target"), $x + 105, $y + 4, 65, 17)

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSmartZapEarthquakesPerTarget", "Earthquake") & ":", $x - 15, $y + 4, 75, 17, $SS_RIGHT)
		$g_hTxtSmartZapEarthquakesPerTarget = GUICtrlCreateInput("1", $x + 65, $y, 35, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "TxtSmartZapEarthquakesPerTarget_Info_01", "Earthquake spells to drop on each target before moving to the next one.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetLimit(-1, 2)
			GUICtrlSetOnEvent(-1, "txtSmartZapEarthquakesPerTarget")
			GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSmartZapPerTarget", "per target"), $x + 105, $y + 4, 65, 17)

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSmartZapTarget", "Target") & ":", $x - 15, $y + 4, 45, 17, $SS_RIGHT)
		$g_hCmbSmartZapTarget = GUICtrlCreateCombo("", $x + 35, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTarget_Info_01", "Choose which building SmartZap attacks.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetDrills", "Drills") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetAirDefense", "Air Defense") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetAirSweeper", "Air Sweeper") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetEagle", "Eagle") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetFirespitter", "Firespitter") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetInfernos", "Infernos") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetMonolith", "Monolith") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetMortars", "Mortars") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetRevengeTower", "Revenge Tower") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetScattershot", "Scattershot") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetWizardTowers", "Wizard Towers") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetXBow", "XBow"), _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetDrills", "Drills"))
			GUICtrlSetOnEvent(-1, "cmbSmartZapTarget")
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 25
		$g_hCmbSmartZapSecondaryTarget = GUICtrlCreateCombo("", $x + 35, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapSecondaryTarget_Info_01", "Choose an optional secondary target if the first target is not detected.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapSecondaryTargetNone", "None") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetDrills", "Drills") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetAirDefense", "Air Defense") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetAirSweeper", "Air Sweeper") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetEagle", "Eagle") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetFirespitter", "Firespitter") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetInfernos", "Infernos") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetMonolith", "Monolith") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetMortars", "Mortars") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetRevengeTower", "Revenge Tower") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetScattershot", "Scattershot") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetWizardTowers", "Wizard Towers") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTargetXBow", "XBow"), _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapSecondaryTargetNone", "None"))
			GUICtrlSetOnEvent(-1, "cmbSmartZapSecondaryTarget")
			GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 25
		GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "LblSmartZapTiming", "Timing") & ":", $x - 15, $y + 4, 45, 17, $SS_RIGHT)
		$g_hCmbSmartZapTiming = GUICtrlCreateCombo("", $x + 35, $y, 100, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTiming_Info_01", "Choose when SmartZap runs during attack.")
			_GUICtrlSetTip(-1, $sTxtTip)
			GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTimingStart", "Start") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTimingMid", "Mid") & "|" & _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTimingEnd", "End"), _
							   GetTranslatedFileIni("MBR GUI Design Child Attack - Options-Search", "CmbSmartZapTimingStart", "Start"))
			GUICtrlSetOnEvent(-1, "cmbSmartZapTiming")
			GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateAttackSearchOptionsSearch
