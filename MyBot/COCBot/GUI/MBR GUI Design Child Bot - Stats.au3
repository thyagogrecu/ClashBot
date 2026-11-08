; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Stats" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), kaganus (2015), Boju (2016), TheRevenor (2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hGUI_STATS = 0, $g_hGUI_STATS_TAB = 0, $g_hGUI_STATS_TAB_ITEM1 = 0, $g_hGUI_STATS_TAB_ITEM2 = 0, $g_hGUI_STATS_TAB_ITEM3 = 0, $g_hGUI_STATS_TAB_ITEM4 = 0, $g_hGUI_STATS_TAB_ITEM5 = 0
Global $btnResetStats = 0

; Gain
Global $g_ahPicTHLevels[19], $g_hLblTHLevels = 0
Global $g_ahPicLeague[$eLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblLeague = 0
Global $g_ahLblStatsStartedWith[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsGainPerHour[$eLootCount] = [0, 0, 0, 0]
Global $g_ahLblStatsTotalGain[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsLastAttack[$eLootCount] = [0, 0, 0, 0]
Global $g_ahLblStatsBonusLast[$eLootCount] = [0, 0, 0, 0], $g_ahLblStatsTop[$eLootCount] = [0, 0, 0, 0]
Global $g_hPicResultDEStart = 0, $g_hLblStatsSZRev1 = 0, $g_hLblStatsSZRev2 = 0, $g_hPicHourlyStatsDark = 0, $g_hPicDarkLoot = 0, $g_hPicDarkLastAttack = 0

; Misc
Global $g_hLblResultRuntime = 0, $g_hLblNbrOfOoS = 0, $g_hLblResultVillagesAttacked = 0, $g_hLblResultVillagesSkipped = 0, $g_hLblResultTrophiesDropped = 0
Global $g_hLblSearchCost = 0, $g_hLblTrainCostElixir = 0, $g_hLblTrainCostDElixir = 0, $g_hLblTrainCostGold = 0, $g_hLblGoldFromMines = 0, $g_hLblElixirFromCollectors = 0, $g_hLblDElixirFromDrills = 0
Global $g_hLblWallGoldMake = 0, $g_hLblWallElixirMake = 0, $g_hLblNbrOfBuildingUpgGold = 0, $g_hLblNbrOfBuildingUpgElixir = 0, $g_hLblNbrOfBuildingUpgDElixir = 0, $g_hLblNbrOfHeroUpg = 0, $g_hLblNbrOfWardenUpg = 0
Global $g_hLblWallUpgCostGold = 0, $g_hLblWallUpgCostElixir = 0, $g_hLblBuildingUpgCostGold = 0, $g_hLblBuildingUpgCostElixir = 0, $g_hLblBuildingUpgCostDElixir = 0, $g_hLblHeroUpgCost = 0, $g_hLblWardenUpgCost = 0

; Attacks
Global $g_hLblAttacked[$g_iModeCount] = [0, 0], $g_hLblTotalGoldGain[$g_iModeCount] = [0, 0], $g_hLblTotalElixirGain[$g_iModeCount] = [0, 0], _
		$g_hLblTotalDElixirGain[$g_iModeCount] = [0, 0], $g_hLblTotalTrophyGain[$g_iModeCount] = [0, 0], $g_hLblNbrOfTSSuccess = 0, $g_hLblNbrOfTSFailed = 0
Global $g_hLblNbrOfDetectedMines[$g_iModeCount] = [0, 0], $g_hLblNbrOfDetectedCollectors[$g_iModeCount] = [0, 0], _
		$g_hLblNbrOfDetectedDrills[$g_iModeCount] = [0, 0], $g_hLblSmartZap = 0, $g_hLblSmartLightningUsed = 0, $g_hLblSmartEarthQuakeUsed = 0

; Donations
Global $g_hLblDonTroop[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblDonSpell[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblDonSiegel[$eSiegeMachineCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hLblTotalTroopsQ = 0, $g_hLblTotalTroopsXP = 0, $g_hLblTotalSiegesQ = 0, $g_hLblTotalSiegesXP = 0, $g_hLblTotalSpellsQ = 0, $g_hLblTotalSpellsXP = 0
Global Const $g_iStatsDonateTroopSlots = 49
Global $g_iStatsDonateTroopPage = 0, $g_hBtnDonTroopPage = 0
Global $g_iStatsDonateLastPage = -1
Global $g_hLblDonTroopsHeader = 0, $g_hLblDonSuperTroopsHeader = 0, $g_hDonTroopsPageFirst = 0, $g_hDonTroopsPageLast = 0
Global $g_hDonSiegesSpellsPageFirst = 0, $g_hDonSiegesSpellsPageLast = 0
Global $g_ahPicDonTroopSlot[$g_iStatsDonateTroopSlots], $g_ahLblDonTroopSepSlot[$g_iStatsDonateTroopSlots], $g_ahLblDonTroopSlot[$g_iStatsDonateTroopSlots]
Global $g_aiDonTroopSlotIndex[$g_iStatsDonateTroopSlots], $g_aiDonTroopSlotDisplay[$g_iStatsDonateTroopSlots]
Global $g_abDonTroopSlotReady[$g_iStatsDonateTroopSlots], $g_abDonTroopSlotPosReady[$g_iStatsDonateTroopSlots], $g_abDonTroopSlotSuper[$g_iStatsDonateTroopSlots], $g_abDonTroopSlotVisible[$g_iStatsDonateTroopSlots]

; Multi Stats
Global $g_iMultiStatsPage = 0, $g_hBtnMultiStatsPage = 0
Global $g_aiMultiVillagePage[$g_iSwitchAccMaxAccounts], $g_ahGrpHelpersAcc[$g_iSwitchAccMaxAccounts]
Global $g_ahMultiBuilderTimer[$g_iSwitchAccMaxAccounts], $g_ahMultiLabTimer[$g_iSwitchAccMaxAccounts], $g_ahMultiBuilderIcon[$g_iSwitchAccMaxAccounts], $g_ahMultiLabIcon[$g_iSwitchAccMaxAccounts]
Global $g_ahGrpVillageAcc[$g_iSwitchAccMaxAccounts], $g_ahGrpDefaultAcc[$g_iSwitchAccMaxAccounts], $g_ahGrpReportAcc[$g_iSwitchAccMaxAccounts], $g_ahGrpStatsAcc[$g_iSwitchAccMaxAccounts], $g_ahGrpStats2Acc[$g_iSwitchAccMaxAccounts]
Global $g_ahLblResultGoldNowAcc[$g_iSwitchAccMaxAccounts], $g_ahPicResultGoldNowAcc[$g_iSwitchAccMaxAccounts], $g_ahLblResultTrophyNowAcc[$g_iSwitchAccMaxAccounts], $g_ahPicResultTrophyNowAcc[$g_iSwitchAccMaxAccounts]
Global $g_ahPic2ResultGoldNowAcc[$g_iSwitchAccMaxAccounts], $g_ahPic2ResultElixirNowAcc[$g_iSwitchAccMaxAccounts], $g_ahPic2ResultDENowAcc[$g_iSwitchAccMaxAccounts]
Global $g_ahLblResultElixirNowAcc[$g_iSwitchAccMaxAccounts], $g_ahPicResultElixirNowAcc[$g_iSwitchAccMaxAccounts], $g_ahLblResultBuilderNowAcc[$g_iSwitchAccMaxAccounts], $g_ahPicResultBuilderNowAcc[$g_iSwitchAccMaxAccounts]
Global $g_ahLblResultDENowAcc[$g_iSwitchAccMaxAccounts], $g_ahPicResultDENowAcc[$g_iSwitchAccMaxAccounts], $g_ahLblResultGemNowAcc[$g_iSwitchAccMaxAccounts], $g_ahPicResultGemNowAcc[$g_iSwitchAccMaxAccounts]
Global $g_ahLblHourlyStatsGoldAcc[$g_iSwitchAccMaxAccounts], $g_ahLblResultRuntimeNowAcc[$g_iSwitchAccMaxAccounts], $g_ahPicResultRuntimeNowAcc[$g_iSwitchAccMaxAccounts]
Global $g_ahLblHourlyStatsElixirAcc[$g_iSwitchAccMaxAccounts], $g_ahLblResultAttacked[$g_iSwitchAccMaxAccounts], $g_ahPicResultAttacked[$g_iSwitchAccMaxAccounts]
Global $g_ahLblHourlyStatsDarkAcc[$g_iSwitchAccMaxAccounts], $g_ahLblResultSkipped[$g_iSwitchAccMaxAccounts], $g_ahPicResultSkipped[$g_iSwitchAccMaxAccounts]
Global $g_ahPicArrowLeft[$g_iSwitchAccMaxAccounts], $g_ahPicArrowRight[$g_iSwitchAccMaxAccounts]
Global $g_ahLblTroopTime[$g_iSwitchAccMaxAccounts], $g_ahPicTroopTime[$g_iSwitchAccMaxAccounts], $g_ahLblTroopTimeRep[$g_iSwitchAccMaxAccounts], $g_ahPicTroopTimeRep[$g_iSwitchAccMaxAccounts]
Global $g_ahLblLabTime[$g_iSwitchAccMaxAccounts], $g_ahPicLabTime[$g_iSwitchAccMaxAccounts], $g_ahLbLPetTime[$g_iSwitchAccMaxAccounts], $g_ahPicPetTime[$g_iSwitchAccMaxAccounts], $g_ahLbLStarLabTime[$g_iSwitchAccMaxAccounts], $g_ahPicStarLabTime[$g_iSwitchAccMaxAccounts]
Global $g_ahLbLLootCCGold[$g_iSwitchAccMaxAccounts], $g_ahPicResultCCGold[$g_iSwitchAccMaxAccounts], $g_ahLbLLootCCMedal[$g_iSwitchAccMaxAccounts], $g_ahPicResultCCMedal[$g_iSwitchAccMaxAccounts], $g_ahLblResultBBuilderNowAcc[$g_iSwitchAccMaxAccounts]
Global $g_ahLbLLootBB[$g_iSwitchAccMaxAccounts][3], $g_ahPicResultLootBBGold[$g_iSwitchAccMaxAccounts], $g_ahPicResultLootBBElix[$g_iSwitchAccMaxAccounts], $g_ahPicResultLootBBTr[$g_iSwitchAccMaxAccounts], $g_ahPicResultBBuilderNowAcc[$g_iSwitchAccMaxAccounts]
Global $g_ahLblTrophiesCC[$g_iSwitchAccMaxAccounts], $g_ahPicTrophiesCC[$g_iSwitchAccMaxAccounts]

Func CreateBotStats()

	$g_bMultiStatsEnabled = True
	$g_bMultiStatsCreated = False
	$g_hGUIMultiStats = 0
	$g_hGUI_STATS_TAB_ITEM5 = 0

	;GUISetBkColor($COLOR_WHITE, $g_hGUI_STATS)
	GUISwitch($g_hGUI_STATS)
	$g_hGUI_STATS_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab1, $g_iSizeHGrpTab1, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$btnResetStats = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "BtnResetStats", "Reset Stats"), 381, 0, 70, 20)
	GUICtrlSetOnEvent(-1, "btnResetStats")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hGUI_STATS_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_01", "Gain"))
	CreateGainSubTab()
	$g_hGUI_STATS_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_04", "Donations"))
	CreateDonationsSubTab()
	If $g_bMultiStatsEnabled Then
		$g_hGUI_STATS_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_04_STab_05_STab_05", "Multi Stats"))
		CreateMultiStatsSubTab()
		$g_bMultiStatsCreated = True
	EndIf
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateBotStats

#Region Gain SubTab
Func CreateGainSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart, $y = $yStart
	_GUICtrlCreatePic(@ScriptDir & "\images\Stats\Stats001.jpg", $x - 11, $y - 20, 422, 80)

	$x = $xStart + 282
	$y = $yStart - 14
	;Boju Display TH Level in Stats
	$g_ahPicTHLevels[4] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV04, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[5] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV05, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV06, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV07, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV08, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV09, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV10, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV11, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV12, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV13, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV14, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[15] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV15, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[16] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV16, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[17] = _GUICtrlCreateIcon($g_sLibIconPath, $eHdV17, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicTHLevels[18] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTH18, $x - 11, $y + 15, 52, 52)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", "Town Hall"), $x - 11, $y, -1, -1, $SS_CENTER)

	;-->Display TH Level in Stats
	$g_hLblTHLevels = GUICtrlCreateLabel("", $x + 38, $y + 53, 17, 17, $SS_CENTER)
	GUICtrlSetFont($g_hLblTHLevels, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 346
	$y = $yStart - 14
	;Display League in Stats ==>
	$g_ahPicLeague[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_SHOW)
	$g_ahPicLeague[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicLeague[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x - 2, $y - 5 + 15, 56, 56)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLeague", "League"), $x + 3, $y, -1, -1, $SS_CENTER)

	;-->Display League Level in Stats
	$g_hLblLeague = GUICtrlCreateLabel("", $x + 43, $y + 53, 17, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 11, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 100
	GUICtrlCreateLabel("", $x - 25, $y - 32, 444, 17)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStats", "Stats"), $x - 25, $y - 32, 92, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGold", "Gold"), $x - 18 + 92, $y - 32, 95, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblElixir", "Elixir"), $x - 18 + 205, $y - 32, 75, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDarkE", "Dark Elixir"), $x - 23 + 340, $y - 32, 90, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel("", $x - 23 + 412, $y - 32, 1, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateGroup("", $x - 25, $y - 20, 444, 28)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStartedWith", "Started with") & ":", $x - 15, $y - 11, -1, -1)
	$x += 92
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_01", "The amount of Gold you had when the bot started.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsStartedWith[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 113
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_02", "The amount of Elixir you had when the bot started.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsStartedWith[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 130
	$g_hPicResultDEStart = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_03", "The amount of Dark Elixir you had when the bot started.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsStartedWith[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsStartedWith_Info_04", "The amount of Trophies you had when the bot started.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsStartedWith[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 125
	GUICtrlCreateGroup("", $x - 25, $y - 20, 444, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblGainPerHour", "Gain per Hour") & ":", $x - 15, $y - 11, -1, -1)

	$x += 92
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_01", "Gold gain per hour")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsGainPerHour[$eLootGold] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 113
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_02", "Elixir gain per hour")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsGainPerHour[$eLootElixir] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 130
	$g_hPicHourlyStatsDark = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_03", "Dark Elixir gain per hour")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsGainPerHour[$eLootDarkElixir] = GUICtrlCreateLabel("0/h", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsGainPerHour_Info_04", "Trophy gain per hour")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsGainPerHour[$eLootTrophy] = GUICtrlCreateLabel("0/h", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 150
	GUICtrlCreateGroup("", $x - 25, $y - 20, 444, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTotalGain", "Total Gain") & ":", $x - 15, $y - 11, -1, -1)
	$x += 92
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_01", "The total amount of Gold you gained or lost while the Bot is running.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTotalGain[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 113
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_03", "The total amount of Elixir you gained or lost while the Bot is running.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTotalGain[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 130
	$g_hPicDarkLoot = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_04", "The total amount of Dark Elixir you gained or lost while the Bot is running.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_02", "(This includes manual spending of resources on upgrade of buildings)")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTotalGain[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTotalGain_Info_05", "The amount of Trophies you gained or lost while the Bot is running.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTotalGain[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 195
	GUICtrlCreateGroup("", $x - 25, $y - 20, 444, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLastAttack", "Last Attack") & ":", $x - 15, $y - 11, -1, -1)
	$x += 92
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_01", "The amount of Gold you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsLastAttack[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 113
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_02", "The amount of Elixir you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsLastAttack[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 130
	$g_hPicDarkLastAttack = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_03", "The amount of Dark Elixir you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsLastAttack[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsLastAttack_Info_04", "The amount of Trophies you gained or lost on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsLastAttack[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 220
	GUICtrlCreateGroup("", $x - 25, $y - 20, 444, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLeagueBonus", "League Bonus") & ":", $x - 15, $y - 11, -1, -1)
	$x += 92
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_01", "The amount of Bonus Gold you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsBonusLast[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 113
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_02", "The amount of Bonus Elixir you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsBonusLast[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 130
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsBonusLast_Info_03", "The amount of Bonus Dark Elixir you gained on the last attack.")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsBonusLast[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 3
	$y = $yStart + 265
	GUICtrlCreateGroup("", $x - 25, $y - 20, 444, 28)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblTopLoot", "Top Loot") & ":", $x - 15, $y - 11, -1, -1)

	$x += 92
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_01", "Top Gold gained")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTop[$eLootGold] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 113
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_02", "Top Elixir gained")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTop[$eLootElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 130
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 50, $y - 12, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_03", "Top Dark gained")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTop[$eLootDarkElixir] = GUICtrlCreateLabel("0", $x - 18, $y - 12, 65, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 75
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 50, $y - 12, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsTop_Info_04", "Top Trophy gained")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblStatsTop[$eLootTrophy] = GUICtrlCreateLabel("0", $x - 18 + 5, $y - 12, 60, 17, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	CreateBaseAttackStats(330)
EndFunc   ;==>CreateGainSubTab
#EndRegion Gain SubTab

#Region Base Attack Stats
; #FUNCTION# ===========================================================================================================
; Name ..........: CreateBaseAttackStats
; Description ...: Creates Dead Base and Live Base statistics below the Gain loot table.
; ======================================================================================================================
Func CreateBaseAttackStats($iTop)
	Local $sTxtTip = "", $xStart = 25, $x = 0, $y = 0
	$x = $xStart + 3
	$y = $iTop + 32
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base", "Dead Base"), $x - 25, $y - 32, 225, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base", "Live Base"), $x - 18 + 212, $y - 32, 225, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 7, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base_Info_01", "The No. of Dead Base that were attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 30, $y + 2, 82, 17, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblAttacked[$DB] = GUICtrlCreateLabel("0", $x + 112, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 7, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Gold_Info_01", "The amount of Gold gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", "Gain") & ":", $x + 30, $y + 2, 82, 17, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalGoldGain[$DB] = GUICtrlCreateLabel("0", $x + 112, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 7, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Elixir_Info_01", "The amount of Elixir gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 30, $y + 2, 82, 17, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 112, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 7, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Dark_Info_01", "The amount of Dark Elixir gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 30, $y + 2, 82, 17, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalDElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 112, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStart + 180
	$y = $iTop + 32
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 204, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base_Info_01", "The No. of Live Base that were attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 115, $y + 2, 82, 17, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblAttacked[$LB] = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_LEFT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 204, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Gold_Info_01", "The amount of Gold gained from Live Bases attacked by the Bot")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 115, $y + 2, 82, 17, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalGoldGain[$LB] = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_LEFT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 204, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Elixir_Info_01", "The amount of Elixir gained from Live Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 115, $y + 2, 82, 17, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_LEFT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 204, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Dark_Info_01", "The amount of Dark Elixir gained from Live Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 115, $y + 2, 82, 17, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalDElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 45, $y + 2, 70, 17, $SS_LEFT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBaseAttackStats
#EndRegion Base Attack Stats

#Region Attacks SubTab
Func CreateAttacksSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 45
	Local $x = $xStart + 3, $y = $yStart + 20
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base", "Dead Base"), $x - 25, $y - 32, 192, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base", "Live Base"), $x - 18 + 212, $y - 32, 225, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel("", $x + 187, $y - 32, 5, 300)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 10
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base_Info_01", "The No. of Dead Base that were attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblAttacked[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Gold_Info_01", "The amount of Gold gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", "Gain") & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalGoldGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Elixir_Info_01", "The amount of Elixir gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x - 10, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Dark_Info_01", "The amount of Dark Elixir gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalDElixirGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x - 10, $y, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain-Trophies_Info_01", "The amount of Trophies gained from Dead Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 13, $y + 2, -1, 17)
	GUICtrlSetState(-1, $GUI_HIDE)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalTrophyGain[$DB] = GUICtrlCreateLabel("0", $x + 115, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$x += 30
	$y += 25
	$g_hLblNbrOfDetectedMines[$DB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedCollectors[$DB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedDrills[$DB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 180
	$y = $yStart + 25
	$y -= 15
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base_Info_01", "The No. of Live Base that were attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblBase-Attacked", "Attacked") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblAttacked[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Gold_Info_01", "The amount of Gold gained from Live Bases attacked by the Bot")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalGoldGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Elixir_Info_01", "The amount of Elixir gained from Live Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 22, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Dark_Info_01", "The amount of Dark Elixir gained from Live Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalDElixirGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrophy, $x + 22, $y, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLive-Base-Gain-Trophy_Info_01", "The amount of Trophy gained from Live Bases attacked by the Bot.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	GUICtrlSetState(-1, $GUI_HIDE)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLblTotalTrophyGain[$LB] = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	$x += 62
	$y += 25
	$g_hLblNbrOfDetectedMines[$LB] = GUICtrlCreateLabel("0", $x - 18, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x + 6, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedCollectors[$LB] = GUICtrlCreateLabel("0", $x + 18, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 43, $y - 4, 16, 16)
	$x += 20
	$g_hLblNbrOfDetectedDrills[$LB] = GUICtrlCreateLabel("0", $x + 54, $y - 2, 20, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 79, $y - 4, 16, 16)
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	$x = $xStart + 3
	$y = $yStart + 165
	Local $hFirstHiddenAttackExtra = GUICtrlCreateDummy()
	$g_hLblStatsSZRev2 = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2", "SmartZap"), $x + 192, $y - 32, 225, 17, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x = $xStart + 180
	$y = $yStart + 165
	$y -= 10
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x + 22, $y, 16, 16)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", "The amount of Lightning Spells used to zap"))
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2-Used", "Used") & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", -1))
	$g_hLblSmartLightningUsed = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartLightningUsed_Info_01", -1))
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x + 22, $y, 16, 16)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", "The amount of Earthquake Spells used to zap"))
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSZRev2-Used", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", -1))
	$g_hLblSmartEarthQuakeUsed = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartEarthQuakeUsed_Info_01", -1))
	$y += 20
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 22, $y, 18, 18)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01", "The amount of Dark Elixir won while zapping"))
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblDead-Base-Gain", -1) & ":", $x + 45, $y + 2, -1, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01", -1))
	$g_hLblSmartZap = GUICtrlCreateLabel("0", $x + 150, $y + 2, 70, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsSmartZap_Info_01", -1))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Local $hLastHiddenAttackExtra = GUICtrlCreateDummy()
	For $hCtrl = $hFirstHiddenAttackExtra To $hLastHiddenAttackExtra
		GUICtrlSetState($hCtrl, $GUI_HIDE)
	Next

EndFunc   ;==>CreateAttacksSubTab
#EndRegion Attacks SubTab

#Region Donations SubTab
Func CreateDonationsSubTab()
	Local $sTxtTip = ""
	Local $xStart = 25, $yStart = 40
	Local $x = $xStart, $y = $yStart + 20
	Local $xOffset = 54
	$g_hLblDonTroopsHeader = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDon-Troops", "Troops"), $x - 22, $y - 32, 444, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	$x = 12
	$y -= 12
	$g_ahPicDonTroopSlot[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $x, $y, 24, 24)
	$g_hDonTroopsPageFirst = $g_ahPicDonTroopSlot[0]
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[0] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[0] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcher, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[1] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[1] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGiant, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[2] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[2] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[3] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoblin, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[3] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[3] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[4] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallBreaker, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[4] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[4] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[5] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBalloon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[5] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[5] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y = $yStart + 8
	$x += $xOffset
	$g_ahPicDonTroopSlot[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWizard, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[6] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[6] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealer, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[7] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[7] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[8] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[8] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPekka, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[9] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[9] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBabyDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[10] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[10] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMiner, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[11] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[11] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y = $yStart + 8
	$x += $xOffset
	$g_ahPicDonTroopSlot[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[12] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[12] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnYeti, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[13] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[13] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDragonRider, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[14] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[14] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[15] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElectroTitan, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[15] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[15] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[16] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRootRider, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[16] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[16] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[17] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnThrower, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[17] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[17] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y = $yStart + 8
	$x += $xOffset
	$g_ahPicDonTroopSlot[18] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMeteorGolem, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[18] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[18] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[19] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMinion, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[19] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[19] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[20] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHogRider, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[20] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[20] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[21] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnValkyrie, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[21] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[21] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[22] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGolem, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[22] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[22] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[23] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWitch, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[23] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[23] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y = $yStart + 8
	$x += $xOffset
	$g_ahPicDonTroopSlot[24] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLavaHound, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[24] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[24] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[25] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBowler, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[25] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[25] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[26] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceGolem, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[26] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[26] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[27] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeadhunter, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[27] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[27] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[28] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnAppWard, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[28] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[28] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[29] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDruid, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[29] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[29] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y = $yStart + 8
	$x += $xOffset
	$g_ahPicDonTroopSlot[30] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnFurnace, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[30] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[30] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[31] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRuinWitch, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[31] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[31] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[32] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperBarbarian, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[32] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[32] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[33] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperArcher, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[33] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[33] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[34] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSneakyGoblin, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[34] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[34] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[35] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWallBreaker, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[35] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[35] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[36] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperGiant, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[36] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[36] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y = $yStart + 8
	$x += $xOffset
	$g_ahPicDonTroopSlot[37] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRocketBalloon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[37] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[37] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[38] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWizard, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[38] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[38] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[39] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[39] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[39] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[40] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnInfernoDragon, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[40] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[40] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[41] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperMinion, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[41] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[41] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[42] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperValkyrie, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[42] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[42] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y = $yStart + 8
	$x += $xOffset
	$g_ahPicDonTroopSlot[43] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperWitch, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[43] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[43] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[44] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnIceHound, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[44] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[44] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[45] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperBowler, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[45] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[45] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[46] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperMiner, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[46] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[46] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$y += 28
	$g_ahPicDonTroopSlot[47] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperHogRider, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[47] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[47] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
 	_GUICtrlSetTip(-1, $sTxtTip)
 
	$y += 28
	$g_ahPicDonTroopSlot[48] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSuperYeti, $x, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_ahLblDonTroopSepSlot[48] = GUICtrlCreateLabel(":", $x + 28, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_ahLblDonTroopSlot[48] = GUICtrlCreateLabel("0", $x + 15, $y + 6, 35, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hLblDonSuperTroopsHeader = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDon-SuperTroops", "Super Troops"), 3, $yStart + 120, 444, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
 
 	$x = $xStart
	$y = $yStart + 258
	GUICtrlCreateLabel(" " & GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotal", "Total Donated") & ":", $x - 22, $y - 32, 219, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalTroopsQ = GUICtrlCreateLabel("0", $x + 105, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotalXP", "Total XP") & ":", $x - 18 + 212, $y - 32, 228, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalTroopsXP = GUICtrlCreateLabel("0", $x + 332, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hDonTroopsPageLast = GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 20
	$g_hDonSiegesSpellsPageFirst = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDon-Sieges", "Sieges"), $x - 22, $y - 32, 444, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x -= 3
	$y -= 12

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWallW, $x - 10, $y + 1, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 16, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeWallWrecker] = GUICtrlCreateLabel("0", $x, $y + 5, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleB, $x + 44, $y + 1, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 70, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeBattleBlimp] = GUICtrlCreateLabel("0", $x + 54, $y + 5, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnStoneS, $x + 98, $y + 1, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 124, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeStoneSlammer] = GUICtrlCreateLabel("0", $x + 108, $y + 5, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSiegeB, $x + 152, $y + 1, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 178, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeBarracks] = GUICtrlCreateLabel("0", $x + 162, $y + 5, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLogL, $x + 206, $y + 1, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 232, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeLogLauncher] = GUICtrlCreateLabel("0", $x + 216, $y + 5, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnFlameF, $x + 260, $y + 1, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 286, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeFlameFlinger] = GUICtrlCreateLabel("0", $x + 270, $y + 5, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleD, $x + 314, $y + 1, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 340, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeBattleDrill] = GUICtrlCreateLabel("0", $x + 324, $y + 5, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTroopL, $x + 368, $y + 1, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 394, $y + 4, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeTroopLauncher] = GUICtrlCreateLabel("0", $x + 378, $y + 5, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkyW, $x - 10, $y + 31, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 16, $y + 34, -1, 17)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSiegel[$eSiegeSkyWagon] = GUICtrlCreateLabel("0", $x, $y + 35, 37, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStart
	$y = $yStart + 97
	GUICtrlCreateLabel(" " & GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotal", "Total Donated") & ":", $x - 22, $y - 32, 219, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalSiegesQ = GUICtrlCreateLabel("0", $x + 105, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotalXP", "Total XP") & ":", $x - 18 + 212, $y - 32, 228, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalSiegesXP = GUICtrlCreateLabel("0", $x + 332, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 120
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonElixir-Spells", "Elixir Spells"), $x - 22, $y - 32, 219, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonDark-Spells", "Dark Elixir Spells"), $x - 18 + 215, $y - 32, 225, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$x = $xStart - 3
	$y -= 8
	$xOffset = 46
	Local $yOffset = 28

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLightSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellLightning] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHealSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellHeal] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRageSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellRage] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnJumpSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellJump] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnFreezeSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellFreeze] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = $xStart - 3
	$y += $yOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCloneSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellClone] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnInvisibilitySpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellInvisibility] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecallSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellRecall] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnReviveSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellRevive] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTotemSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellTotem] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart + 241
	$y = $yStart + 112

	; Row 1 Dark Spells: Poison, EQ, Haste, Skeleton (24px icons)
	$x = $xStart + 237
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPoisonSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellPoison] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnEarthQuakeSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellEarthquake] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHasteSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellHaste] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSkeletonSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellSkeleton] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	; Row 2 Dark Spells: Bat, Overgrowth, IBSpell (24px icons)
	$x = $xStart + 237
	$y += $yOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBatSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellBat] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnOvergrowthSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellOvergrowth] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnIBSpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellIBSpell] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += $xOffset
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnAngrySpell, $x - 10, $y, 24, 24)
	$sTxtTip = ""
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateLabel(":", $x + 18, $y + 4, -1, -1)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	$g_hLblDonSpell[$eSpellAngrySpell] = GUICtrlCreateLabel("0", $x + 5, $y + 6, 25, 17, $SS_RIGHT)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)
	GUICtrlSetColor(-1, $COLOR_BLACK)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = $xStart
	$y = $yStart + 200
	GUICtrlCreateLabel(" " & GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotal", "Total Donated") & ":", $x - 22, $y - 32, 219, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel("", $x + 35 + 130, $y - 32, 30, 15, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalSpellsQ = GUICtrlCreateLabel("0", $x + 105, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblStatsDonTotalXP", "Total XP") & ":", $x - 18 + 212, $y - 32, 228, 15)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hLblTotalSpellsXP = GUICtrlCreateLabel("0", $x + 332, $y - 32, 70, 15, $SS_RIGHT)
	GUICtrlSetBkColor(-1, 0xD4D4D4)
	$g_hDonSiegesSpellsPageLast = GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hBtnDonTroopPage = GUICtrlCreateButton(">", 428, 286, 20, 20)
	GUICtrlSetBkColor(-1, 0x2A2A2A)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	GUICtrlSetOnEvent(-1, "btnDonTroopPage")
	_GUICtrlSetTip(-1, "Next page")

	UpdateDonTroopPage()

EndFunc   ;==>CreateDonationsSubTab
#EndRegion Donations SubTab

#Region MultiStats SubTab
Func EnsureMultiStatsCreated($bShow = True)
	If Not $g_bMultiStatsEnabled Then Return
	If Not $g_bMultiStatsCreated Then Return
	GUISwitch($g_hGUI_STATS)
EndFunc   ;==>EnsureMultiStatsCreated

Func SetMultiStatsVisibility($bVisible)
	Return
EndFunc   ;==>SetMultiStatsVisibility

Func CreateMultiStatsSubTab()
	$g_hBtnMultiStatsPage = GUICtrlCreateButton(">", 427, 24, 20, 20)
	GUICtrlSetBkColor(-1, 0x2A2A2A)
	GUICtrlSetColor(-1, $COLOR_WHITE)
	GUICtrlSetFont(-1, 8, $FW_BOLD, Default, "Segoe UI Semibold", $CLEARTYPE_QUALITY)
	GUICtrlSetOnEvent(-1, "btnMultiStatsPage")
	_GUICtrlSetTip(-1, "Next page")

	For $i = 0 To $g_iSwitchAccMaxAccounts - 1
		Local $x = 25
		Local $y = 5
		Local $iSlot = Mod($i, $g_iSwitchAccAccountsPerPage)
		Local $i_X = Mod($iSlot, 2), $i_Y = Int($iSlot / 2)
		Local $delY = 17, $delY2 = 95, $delX = 90, $delX2 = 215

		$g_ahGrpVillageAcc[$i] = GUICtrlCreateGroup("", $x - 3 + $i_X * $delX2, $y + $i_Y * $delY2, 180, 90)

		$g_ahLblResultGoldNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultGoldNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 75 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
		$g_ahPic2ResultGoldNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 75 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
		$g_ahLblResultTrophyNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultTrophyNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnStrongMan, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

		$g_ahLblResultElixirNowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultElixirNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 75 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		$g_ahPic2ResultElixirNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 75 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		$g_ahLblResultBuilderNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultBuilderNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 16, 14)

		$g_ahLblResultDENowAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultDENowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 75 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
		$g_ahPic2ResultDENowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 75 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
		$g_ahLblResultGemNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultGemNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

		$g_ahLblLabTime[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicLabTime[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x + 75 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 16, 16)

		$g_ahLbLPetTime[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicPetTime[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetHouse, $x + 75 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 16, 16)

		$g_ahPicArrowLeft[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowLeft, $x - 20 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		Local $sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage_Info_01", "Switch between village info and stats")
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "SwitchVillageInfo")

		$g_ahPicArrowRight[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowRight, $x + 180 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		_GUICtrlSetTip(-1, $sTxtTip)
		GUICtrlSetOnEvent(-1, "SwitchVillageInfo2")

		$g_ahLblHourlyStatsGoldAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahLblResultRuntimeNowAcc[$i] = GUICtrlCreateLabel("00:00:00", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultRuntimeNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

		$g_ahLblHourlyStatsElixirAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahLblResultAttacked[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultAttacked[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)

		$g_ahLblHourlyStatsDarkAcc[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahLblResultSkipped[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultSkipped[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgX, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

		$g_ahLblTroopTime[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicTroopTime[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)
		$g_ahLblTroopTimeRep[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicTroopTimeRep[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnTrain, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)

		$g_ahLbLLootBB[$i][$eLootGoldBB] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultLootBBGold[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBGold, $x + 75 + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 15, 15)
		$g_ahLbLLootBB[$i][$eLootElixirBB] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicResultLootBBElix[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBElix, $x + 75 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 15, 15)
		$g_ahLbLLootBB[$i][$eLootTrophyBB] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicResultLootBBTr[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBTrophy, $x + 75 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 15, 15)
		GUICtrlSetState(-1, $GUI_HIDE)

		$g_ahLbLLootCCGold[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultCCGold[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalGold, $x + 60 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 - 1, 16, 16)
		$g_ahLbLLootCCMedal[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 2, 55, 17, $SS_RIGHT)
		$g_ahPicResultCCMedal[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalMedal, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
		$g_ahLbLStarLabTime[$i] = GUICtrlCreateLabel("", $x + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 70, 17, $SS_RIGHT)
		$g_ahPicStarLabTime[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnStarLaboratory, $x + 75 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 15, 16)
		$g_ahLblTrophiesCC[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 2, 55, 17, $SS_RIGHT)
		GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahPicTrophiesCC[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalTrophy, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 17, 17)
		GUICtrlSetState(-1, $GUI_HIDE)
		$g_ahLblResultBBuilderNowAcc[$i] = GUICtrlCreateLabel("", $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 55, 17, $SS_RIGHT)
		$g_ahPicResultBBuilderNowAcc[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMasterBuilder, $x + 60 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)

		$g_ahGrpDefaultAcc[$i] = $g_ahGrpVillageAcc[$i] & "#" & $g_ahPicArrowLeft[$i] & "#" & $g_ahPicArrowRight[$i]
		$g_ahMultiBuilderTimer[$i] = GUICtrlCreateLabel("", 0, 0, 55, 17, $SS_RIGHT)
		$g_ahMultiBuilderIcon[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilderApprentice, 0, 0, 16, 16)
		$g_ahMultiLabTimer[$i] = GUICtrlCreateLabel("", 0, 0, 55, 17, $SS_RIGHT)
		$g_ahMultiLabIcon[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLabAssistant, 0, 0, 16, 16)
		_GUI_Value_STATE("HIDE", $g_ahLblTroopTime[$i] & "#" & $g_ahPicTroopTime[$i] & "#" & $g_ahLblTroopTimeRep[$i] & "#" & $g_ahPicTroopTimeRep[$i] & "#" & $g_ahLblTrophiesCC[$i] & "#" & $g_ahPicTrophiesCC[$i])
		$g_ahGrpReportAcc[$i] = $g_ahLblResultGoldNowAcc[$i] & "#" & $g_ahPicResultGoldNowAcc[$i] & "#" & $g_ahLblResultElixirNowAcc[$i] & "#" & $g_ahPicResultElixirNowAcc[$i] & "#" & $g_ahLblResultDENowAcc[$i] & "#" & $g_ahPicResultDENowAcc[$i] & "#" & $g_ahLblResultTrophyNowAcc[$i] & "#" & $g_ahPicResultTrophyNowAcc[$i] & "#" & $g_ahLblResultBuilderNowAcc[$i] & "#" & $g_ahPicResultBuilderNowAcc[$i] & "#" & $g_ahLblResultGemNowAcc[$i] & "#" & $g_ahPicResultGemNowAcc[$i]
		$g_ahGrpStatsAcc[$i] = $g_ahLblHourlyStatsGoldAcc[$i] & "#" & $g_ahPic2ResultGoldNowAcc[$i] & "#" & $g_ahLblHourlyStatsElixirAcc[$i] & "#" & $g_ahPic2ResultElixirNowAcc[$i] & "#" & $g_ahLblHourlyStatsDarkAcc[$i] & "#" & $g_ahPic2ResultDENowAcc[$i] & "#" & $g_ahLblResultRuntimeNowAcc[$i] & "#" & $g_ahPicResultRuntimeNowAcc[$i] & "#" & $g_ahLblResultAttacked[$i] & "#" & $g_ahPicResultAttacked[$i] & "#" & $g_ahLblResultSkipped[$i] & "#" & $g_ahPicResultSkipped[$i]
		$g_ahGrpStats2Acc[$i] = $g_ahLbLLootBB[$i][$eLootGoldBB] & "#" & $g_ahPicResultLootBBGold[$i] & "#" & $g_ahLbLLootBB[$i][$eLootElixirBB] & "#" & $g_ahPicResultLootBBElix[$i] & "#" & $g_ahLbLLootCCGold[$i] & "#" & $g_ahPicResultCCGold[$i] & "#" & $g_ahLbLLootBB[$i][$eLootTrophyBB] & "#" & $g_ahPicResultLootBBTr[$i] & "#" & $g_ahLblResultBBuilderNowAcc[$i] & "#" & $g_ahPicResultBBuilderNowAcc[$i] & "#" & $g_ahLbLLootCCMedal[$i] & "#" & $g_ahPicResultCCMedal[$i]
		$g_ahGrpHelpersAcc[$i] = $g_ahLblLabTime[$i] & "#" & $g_ahPicLabTime[$i] & "#" & $g_ahLbLPetTime[$i] & "#" & $g_ahPicPetTime[$i] & "#" & $g_ahLbLStarLabTime[$i] & "#" & $g_ahPicStarLabTime[$i] & "#" & $g_ahMultiBuilderTimer[$i] & "#" & $g_ahMultiBuilderIcon[$i] & "#" & $g_ahMultiLabTimer[$i] & "#" & $g_ahMultiLabIcon[$i]
		_GUI_Value_STATE("HIDE", $g_ahGrpHelpersAcc[$i])
		MultiStatsSetAccountSlot($i, $iSlot)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		_GUI_Value_STATE("HIDE", $g_ahGrpDefaultAcc[$i] & "#" & $g_ahGrpReportAcc[$i] & "#" & $g_ahGrpStatsAcc[$i] & "#" & $g_ahGrpStats2Acc[$i])
	Next
EndFunc   ;==>CreateMultiStatsSubTab
#EndRegion MultiStats SubTab
