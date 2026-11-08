; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Misc" tab under the "Village" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017), Chilly-Chill (2019)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#include <TreeViewConstants.au3>
Global $g_hGUI_MISC = 0, $g_hGUI_MISC_TAB = 0, $g_hGUI_MISC_TAB_ITEM1 = 0, $g_hGUI_MISC_TAB_ITEM2 = 0, $g_hGUI_MISC_TAB_ITEM3 = 0, $g_hGUI_MISC_TAB_ITEM4 = 0

Global $g_hChkBotStop = 0, $g_hCmbBotCommand = 0, $g_hCmbBotCond = 0, $g_hCmbHoursStop = 0, $g_hCmbTimeStop = 0
Global $g_LblResumeAttack = 0, $g_ahTxtResumeAttackLoot[$eLootCount] = [0, 0, 0, 0], $g_hCmbResumeTime = 0
Global $g_hChkCollectStarBonus = 0
Global $g_hTxtRestartGold = 0, $g_hTxtRestartElixir = 0, $g_hTxtRestartDark = 0
Global $g_hChkTrap = 1, $g_hChkCollect = 1, $g_hChkTombstones = 1, $g_hChkCleanYard = 0, $g_hChkGemsBox = 0
Global $g_hChkCollectCartFirst = 0, $g_hTxtCollectGold = 0, $g_hTxtCollectElixir = 0, $g_hTxtCollectDark = 0
Global $g_hBtnLocateSpellfactory = 0, $g_hBtnLocateDarkSpellFactory = 0
Global $g_hBtnLocateHeroHall = 0, $g_hBtnLocateLaboratory = 0, $g_hBtnLocatePetHouse = 0, $g_hBtnResetBuilding = 0, _
		$g_hBtnLocateBlacksmith = 0, $g_hBtnLocateHelperHut = 0, $g_hBtnLocateAllNormalBuildings = 0
Global $g_hChkTreasuryCollect = 0, $g_hTxtTreasuryGold = 0, $g_hTxtTreasuryElixir = 0, $g_hTxtTreasuryDark = 0, $g_hChkCollectAchievements = 0, $g_hChkFreeMagicItems = 0, $g_hChkCollectRewards = 0, $g_hChkSellRewards = 0

Global $g_alblBldBaseStats[3] = ["", "", ""]
Global $g_hChkCollectBuilderBase = 0, $g_hChkStartClockTowerBoost = 0, $g_hChkCTBoostBlderBz = 0, $g_hChkCleanBBYard = 0
Global $g_hChkCollectBldGE = 0, $g_hChkCollectBldGems = 0, $g_hChkActivateClockTower = 0
Global $g_hBtnDelDoubleCannonCoord = 0, $g_hBtnDelArcherTowerCoord = 0, $g_hBtnDelMultiMortarCoord = 0, $g_hBtnDelCannonCoord = 0, $g_hBtnBattleMachineCoord = 0, $g_hBtnBattlecopterCoord = 0
Global $g_hChkBattleMachineUpgrade = 0, $g_hChkDoubleCannonUpgrade = 0, $g_hChkArcherTowerUpgrade = 0, $g_hChkMultiMortarUpgrade = 0
Global $g_hChkBattleCopterUpgrade = 0, $g_hChkAnyDefUpgrade = 0
Global $g_hChkDropTrophyBB = 0, $g_hChkBBStarsAvailable = 0
Global $g_hChkResourcesToIgnore[3] = [0, 0, 0]
Global $g_ahPicBBLeague[$eBBLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblBBLeague1 = 0, $g_hLblBBLeague2 = 0, $g_hLblBBLeague3 = 0, $g_hLblBBLeague4 = 0, $g_hLblBBLeague5 = 0

;ClanGames Challenges
Global $g_hChkClanGamesEnabled = 0, $g_hChkClanGamesAllTimes = 0, $g_hChkClanGamesNoOneDay = 0
Global $g_hTxtClanGamesLog = 0, $g_hLblRemainTime = 0, $g_hLblYourScore = 0
Global $g_hGUI_CGSettings = 0, $g_hBtnCGSettingsOpen = 0, $g_hBtnCGSettingsClose = 0
Global $g_hGUI_CGRewardsSettings = 0, $g_hChkClanGamesCollectRewards = 0, $g_hBtnCGRewardsSettingsOpen = 0, $g_hBtnCGRewardsSettingsClose = 0, _
		$TitlePriority = 0, $TitlePriority2 = 0, $g_hBtnCGRewardsSettingsDefault = 0
Global $g_hLabelRewardFull = 0, $g_hLabelReward5Gems = 0, $g_hLabelReward10Gems = 0, $g_hLabelReward50Gems = 0, $g_hLabelAllPotionsFull = 0, $g_hLabelAllBooksFull = 0, $g_hLabelAllBooks = 0
Global $g_acmbPriorityReward[22] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkForceAttackOnClanGames = 0, $g_hChkClanGamesPurgeAny = 0, $g_hChkClanGamesStopBeforeReachAndPurge = 0, $g_hChkClanGamesDisableWhenCompleted = 0
Global $hSearchBBEventFirst = 0, $hSearchMainEventFirst = 0, $hSearchBothVillages = 0
Global $g_hChkClanGamesSort = 0, $g_hCmbClanGamesSort = 0
Global $g_hLabelClangamesDesc = 0

Global $g_hClanGamesTV = 0, $g_hChkCGMainLoot = 0, $g_hChkCGMainBattle = 0, $g_hChkCGMainDestruction = 0
Global $g_hChkCGMainAir = 0, $g_hChkCGMainGround = 0, $g_hChkCGMainMisc = 0, $g_hChkCGMainSpell = 0
Global $g_hChkCGBBBattle = 0, $g_hChkCGBBDestruction = 0, $g_hChkCGBBTroops = 0
Global $g_hChkCGMainHero = 0
Global $g_hChkClanGamesDebug = 0, $g_hChkCGDebugEvents = 0

Global $g_ahCGMainLootItem[6], $g_ahCGMainBattleItem[8], $g_ahCGMainDestructionItem[26], $g_ahCGMainAirItem[14], _
		$g_ahCGMainGroundItem[32], $g_ahCGMainMiscItem[3], $g_ahCGMainSpellItem[12], $g_ahCGBBBattleItem[4], _
		$g_ahCGBBDestructionItem[21], $g_ahCGBBTroopsItem[12], $g_ahCGMainHeroItem[11]

;ClanCapitalTAB
Global $g_lblCapitalGold = 0, $g_lblCapitalMedal = 0, $g_hCmbForgeBuilder = 0, $g_hLbCmbForgeBuilder = 0, $g_hChkEnableAutoUpgradeCC = 0, $g_hChkAutoUpgradeCCTreasury = 0, $g_hChkAutoUpgradeCCIgnore = 0, $g_hTxtAutoUpgradeCCLog = 0, _
		$g_hChkAutoUpgradeCCWallIgnore = 0, $g_hChkAutoUpgradeCCPriorArmy = 0, $g_lblCapitalTrophies = 0, $g_ahPicCCLeague[$eLeagueCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0], $g_hLblCCLeague1 = 0, $g_hLblCCLeague2 = 0, $g_hLblCCLeague3 = 0
Global $g_hChkEnableCollectCCGold = 0, $g_hChkEnableForgeGold = 0, $g_hChkEnableForgeElix = 0, $g_hChkEnableForgeDE = 0, $g_hChkEnableForgeBBGold = 0, $g_hChkEnableForgeBBElix = 0, $g_hChkEnableSmartUse = 0
Global $g_hChkUseGoldPassForgeOnly = 0
Global $g_hLbacmdGoldSaveMin = 0, $g_acmdGoldSaveMin = 0, $g_hLbacmdElixSaveMin = 0, $g_acmdElixSaveMin = 0, $g_hLbacmdDarkSaveMin = 0, $g_acmdDarkSaveMin = 0
Global $g_hLbacmdBBGoldSaveMin = 0, $g_acmdBBGoldSaveMin = 0, $g_hLbacmdBBElixSaveMin = 0, $g_acmdBBElixSaveMin = 0

Func CreateVillageMisc()
	$g_hGUI_MISC = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)

	GUISwitch($g_hGUI_MISC)
	$g_hGUI_MISC_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_MISC_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM1", "Normal Village"))
	CreateMiscNormalVillageSubTab()
	$g_hGUI_MISC_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM2", "Builder Base"))
	CreateMiscBuilderBaseSubTab()
	$g_hGUI_MISC_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM3", "Clan Games"))
	CreateMiscClanGamesV3SubTab()
	$g_hGUI_MISC_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "MISC_TAB_ITEM4", "Clan Capital"))
	CreateClanCapitalTab()
	CreateBBDropOrderGUI()
	CreateClanGamesSettings()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageMisc

Func CreateMiscNormalVillageSubTab()
	Local $sTxtTip = ""
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_01", "Halt Attack"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 145)
	$g_hChkBotStop = GUICtrlCreateCheckbox("", $x, $y, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BotStop_Info_01", "Use these options to set when the bot will stop attacking.")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkBotStop")

	$g_hCmbBotCommand = GUICtrlCreateCombo("", $x + 20, $y - 3, 95, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_01", "Halt Attack") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_02", "Stop Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_03", "Close Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_04", "Close Android+Bot") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_05", "Shutdown PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_06", "Sleep PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_07", "Reboot PC") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_08", "Turn Idle"), GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCommand_Item_01", -1))
	GUICtrlSetOnEvent(-1, "cmbBotCommand")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBotCommand", "When..."), $x + 125, $y, 45, 17)

	$g_hCmbBotCond = GUICtrlCreateCombo("", $x + 173, $y - 3, 160, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_01", "All Storages Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_02", "Gold Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_03", "Elixir Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_04", "Dark Full") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_05", "At Certain Time") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_06", "Bot Running For") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_07", "Donate Only") & "|" & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_08", "Only Stay Online"), GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBotCond_Item_07", -1))
	GUICtrlSetOnEvent(-1, "cmbBotCond")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hCmbHoursStop = GUICtrlCreateCombo("", $x + 337, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, $sTxtTip)
	Local $sTxtHours = GetTranslatedFileIni("MBR Global GUI Design", "Hours", "Hours")
	GUICtrlSetData(-1, "-|1 " & GetTranslatedFileIni("MBR Global GUI Design", "Hour", "Hour") & "|2 " & $sTxtHours & "|3 " & $sTxtHours & "|4 " & $sTxtHours & "|5 " & $sTxtHours & "|6 " & _
			$sTxtHours & "|7 " & $sTxtHours & "|8 " & $sTxtHours & "|9 " & $sTxtHours & "|10 " & $sTxtHours & "|11 " & $sTxtHours & "|12 " & _
			$sTxtHours & "|13 " & $sTxtHours & "|14 " & $sTxtHours & "|15 " & $sTxtHours & "|16 " & $sTxtHours & "|17 " & $sTxtHours & "|18 " & _
			$sTxtHours & "|19 " & $sTxtHours & "|20 " & $sTxtHours & "|21 " & $sTxtHours & "|22 " & $sTxtHours & "|23 " & $sTxtHours & "|24 " & $sTxtHours, "-")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hCmbTimeStop = GUICtrlCreateCombo("", $x + 337, $y - 3, 80, 35, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0:00 AM|1:00 AM|2:00 AM|3:00 AM|4:00 AM|5:00 AM|6:00 AM|7:00 AM|8:00 AM|9:00 AM|10:00 AM|11:00 AM" & _
			"|12:00 PM|1:00 PM|2:00 PM|3:00 PM|4:00 PM|5:00 PM|6:00 PM|7:00 PM|8:00 PM|9:00 PM|10:00 PM|11:00 PM", "0:00 AM")
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 25
	$g_LblResumeAttack = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblResumeAttack", "Resume Attack") & ":", $x + 20, $y + 2, 80, -1)

	$x += 94
	$g_hCmbResumeTime = GUICtrlCreateCombo("", $x + 15, $y - 1, 80, 20, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_01", "After Halt-attack due to time schedule, the Bot will resume attack when the clock turns this time in a day"))
	GUICtrlSetData(-1, "0:00 AM|1:00 AM|2:00 AM|3:00 AM|4:00 AM|5:00 AM|6:00 AM|7:00 AM|8:00 AM|9:00 AM|10:00 AM|11:00 AM" & _
			"|12:00 PM|1:00 PM|2:00 PM|3:00 PM|4:00 PM|5:00 PM|6:00 PM|7:00 PM|8:00 PM|9:00 PM|10:00 PM|11:00 PM", "12:00 PM")
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_hChkCollectStarBonus = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectStarBonus", "When star bonus available"), $x + 15, $y + 20, -1, -1)

	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 70, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootGold] = GUICtrlCreateInput("", $x + 15, $y, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 8)

	$x += 85
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 70, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootElixir] = GUICtrlCreateInput("", $x + 15, $y, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 8)

	$x += 80
	GUICtrlCreateLabel("<", $x + 5, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 65, $y, 16, 16)
	$g_ahTxtResumeAttackLoot[$eLootDarkElixir] = GUICtrlCreateInput("", $x + 15, $y, 45, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkResumeAttackTip_02", -1))
	GUICtrlSetLimit(-1, 6)

	$x = 15
	$y += 45
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBotWillHaltAutomatically", "The bot will Halt automatically when you run out of Resources. It will resume when reaching these minimal values:"), $x + 20, $y, 400, 25, $BS_MULTILINE)

	$y += 30
	$x += 90
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 149, $y, 16, 16)
	$g_hTxtRestartGold = GUICtrlCreateInput("10000", $x + 99, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartGold_Info_01", "Minimum Gold value for the bot to resume attacking after halting because of low gold."))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 149, $y, 16, 16)
	$g_hTxtRestartElixir = GUICtrlCreateInput("25000", $x + 99, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartElixir_Info_01", "Minimum Elixir value for the bot to resume attacking after halting because of low elixir."))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel(ChrW(8805), $x + 89, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 149, $y, 16, 16)
	$g_hTxtRestartDark = GUICtrlCreateInput("500", $x + 99, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRestartDark_Info_01", "Minimum Dark Elixir value for the bot to resume attacking after halting because of low dark elixir."))
	GUICtrlSetLimit(-1, 6)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 15, $y = 192
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_02", "Collect, Clear"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 170)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMine, $x - 5, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollector, $x + 20, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $x + 45, $y, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLootCart, $x + 70, $y, 24, 24)
	$g_hChkCollect = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect", "Collect Resources && Loot Cart"), $x + 100, $y - 6, -1, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkCollect")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_01", "Check this to automatically collect the Villages Resources") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_02", "from Gold Mines, Elixir Collectors and Dark Elixir Drills.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollect_Info_03", "This will also search for a Loot Cart in your village and collect it."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkCollectCartFirst = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectCartFirst", "Loot Cart First"), $x + 280, $y - 6, -1, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectCartFirst_Info_01", "Check this to collect the Loot Cart before Villages Resources."))
	GUICtrlSetState(-1, $GUI_CHECKED)

	$x += 179
	$y += 15
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 60, $y, 16, 16)
	$g_hTxtCollectGold = GUICtrlCreateInput("0", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_01", "Minimum Gold Storage amount to collect Gold.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_02", "Set same as Resume Attack values to collect when 'out of gold' error") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_03", "happens while searching for attack.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", "Set to zero to always collect."))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 60, $y, 16, 16)
	$g_hTxtCollectElixir = GUICtrlCreateInput("0", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_01", "Minimum Elixir Storage amount to collect Elixier.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_02", "Set same as Resume Attack values to collect when 'out of elixir' error") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_03", "happens during troop training.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", -1))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 60, $y, 16, 16)
	$g_hTxtCollectDark = GUICtrlCreateInput("0", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectDark_Info_01", "Minimum Dark Elixir Storage amount to collect Dark Elixier.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_02", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectElixir_Info_03", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCollectGold_Info_04", -1))
	GUICtrlSetLimit(-1, 6)

	$x = 15
	$y += 22
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTreasury, $x + 22, $y - 14, 48, 48)
	$g_hChkTreasuryCollect = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect", "Treasury"), $x + 100, $y - 2, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", "Check this to automatically collect Treasury when FULL,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_02", "'OR' when Storage values are BELOW minimum values on right,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_03", "Use zero as min values to ONLY collect when Treasury is full") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_04", "Large minimum values will collect Treasury loot more often!"))
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "ChkTreasuryCollect")

	$x += 179
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 60, $y, 16, 16)
	$g_hTxtTreasuryGold = GUICtrlCreateInput("1000000", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_01", "Minimum Gold Storage amount to collect Treasury.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_02", "Set same as Resume Attack values to collect when 'out of gold' error") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryGold_Info_03", "happens while searching for attack") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 60, $y, 16, 16)
	$g_hTxtTreasuryElixir = GUICtrlCreateInput("1000000", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_01", "Minimum Elixir Storage amount to collect Treasury.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_02", "Set same as Resume Attack values to collect when 'out of elixir' error") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_03", "happens during troop training") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 7)

	$x += 80
	GUICtrlCreateLabel("<", $x, $y + 2, -1, -1)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 60, $y, 16, 16)
	$g_hTxtTreasuryDark = GUICtrlCreateInput("1000", $x + 10, $y, 50, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryDark_Info_01", "Minimum Dark Elixir Storage amount to collect Treasury.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_02", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtTreasuryElixir_Info_03", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTreasuryCollect_Info_01", -1))
	GUICtrlSetLimit(-1, 6)

	$x = 15
	$y += 21
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnTombstone, $x + 32, $y, 24, 24)
	$g_hChkTombstones = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTombstones", "Clear Tombstone"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkTombstones_Info_01", "Check this to automatically clear tombstones after enemy attack."))
	GUICtrlSetState(-1, $GUI_CHECKED)

	$g_hChkCollectRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectRewards", "Collect Challenge Rewards"), $x + 265, $y + 4, -1, -1)

	$y += 21
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGembox, $x + 32, $y, 24, 24)
	$g_hChkGemsBox = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkGemsBox", "Remove GemBox"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkGemsBox_Info_01", "Check this to automatically clear GemBox."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$g_hChkSellRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkSellRewards", "Sell Extras"), $x + 295, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkSellExtra_Info_01", "Check to automatically sell all extra magic item rewards for gems."))

	$y += 21
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBark, $x + 32, $y, 24, 24)
	$g_hChkCleanYard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanYard", "Remove Obstacle"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanYard_Info_01", "Check this to automatically clear Yard from Trees, Trunks, etc."))
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPowerPotion, $x + 233, $y + 1, 19, 24)
	$g_hChkFreeMagicItems = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems", "Collect Free Magic Items"), $x + 265, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkFreeMagicItems_Info", "Check this to automatically collect free magic items.\r\nMust be at least Th8."))
	GUICtrlSetOnEvent(-1, "ChkFreeMagicItems")
	GUICtrlSetColor(-1, $COLOR_ERROR)

	$y += 21
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCollectAchievements, $x + 22, $y - 12, 48, 48)
	$g_hChkCollectAchievements = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectAchievements", "Collect Achievement"), $x + 100, $y + 4, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectAchievements_Info", "Check this to automatically collect achievement rewards."))

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 20, $y = 363
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_03", "Locate Manually"), $x - 15, $y - 20, $g_iSizeWGrpTab3, 60)
	Local $sTxtRelocate = GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtRelocate_Info_01", "Relocate your") & " "
	$x -= 11
	$y -= 2
	GUICtrlCreateButton(GetTranslatedFileIni("MBR Global GUI Design", "LblTownhall", -1), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnTH, 1)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnTownhall", "Town Hall"))
	GUICtrlSetOnEvent(-1, "btnLocateTownHall")

	$x += 48
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCC", "Clan Castle"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnCC, 1)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCC", "Clan Castle"))
	GUICtrlSetOnEvent(-1, "btnLocateClanCastle")

	$x += 48
	$g_hBtnLocateHeroHall = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateHeroHall", "Hero Hall"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHeroHall)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateHeroHall_Info_01", "Hero Hall"))
	GUICtrlSetOnEvent(-1, "btnLocateHeroHall")

	$x += 48
	$g_hBtnLocateLaboratory = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory", "Lab."), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnLaboratory)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateLaboratory_Info_01", "Laboratory"))
	GUICtrlSetOnEvent(-1, "btnLab")

	$x += 48
	$g_hBtnLocatePetHouse = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocatePetHouse", "Pet House"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnPetHouseGreen)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocatePetHouse_Info_01", "PetHouse"))
	GUICtrlSetOnEvent(-1, "btnPet")

	$x += 48
	$g_hBtnLocateBlacksmith = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateBlacksmith", "Blacksmith"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBlacksmithgreen)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateBlacksmith_Info_01", "Blacksmith"))
	GUICtrlSetOnEvent(-1, "btnBsmith")

	$x += 48
	$g_hBtnLocateHelperHut = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateHelperHut", "Helper Hut"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnHelperHut)
	_GUICtrlSetTip(-1, $sTxtRelocate & GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateHelperHut_Info_01", "Helper Hut"))
	GUICtrlSetOnEvent(-1, "btnHelperHut")

	$x += 48
	$g_hBtnLocateAllNormalBuildings = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateAllNormalBuildings", "All"), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBldgTarget)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnLocateAllNormalBuildings_Info_01", "Locate all normal village buildings"))
	GUICtrlSetOnEvent(-1, "btnLocateAllNormalBuildings")

	$x += 48
	$g_hBtnResetBuilding = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset", "Reset."), $x, $y, 36, 36, $BS_ICON)
	_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnBldgX)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset_Info_01", "Click here to reset all building locations,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnReset_Info_02", "when you have changed your village layout."))
	GUICtrlSetOnEvent(-1, "btnResetBuilding")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateMiscNormalVillageSubTab

Func CreateMiscBuilderBaseSubTab()
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_05", "Builders Base Stats"), $x - 10, $y - 20, $g_iSizeWGrpTab3, 50)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBGold, $x, $y - 2, 24, 24)
	$g_alblBldBaseStats[$eLootGoldBB] = GUICtrlCreateLabel("---", $x + 35, $y + 2, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBElix, $x + 130, $y - 2, 24, 24)
	$g_alblBldBaseStats[$eLootElixirBB] = GUICtrlCreateLabel("---", $x + 165, $y + 2, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBTrophy, $x + 260, $y - 3, 26, 26)
	$g_alblBldBaseStats[$eLootTrophyBB] = GUICtrlCreateLabel("---", $x + 295, $y + 2, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	$g_ahPicBBLeague[$eBBLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 355, $y - 15, 40, 40)
	GUICtrlSetState(-1, $GUI_SHOW)
	$g_ahPicBBLeague[$eLeagueWood] = _GUICtrlCreateIcon($g_sLibIconPath, $eWood, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueClay] = _GUICtrlCreateIcon($g_sLibIconPath, $eClay, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueStone] = _GUICtrlCreateIcon($g_sLibIconPath, $eStone, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueCopper] = _GUICtrlCreateIcon($g_sLibIconPath, $eCopper, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueBrass] = _GUICtrlCreateIcon($g_sLibIconPath, $eBrass, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueIron] = _GUICtrlCreateIcon($g_sLibIconPath, $eIron, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueSteel] = _GUICtrlCreateIcon($g_sLibIconPath, $eSteel, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueTitanium] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitanium, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeaguePlatinum] = _GUICtrlCreateIcon($g_sLibIconPath, $ePlatinum, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueEmerald] = _GUICtrlCreateIcon($g_sLibIconPath, $eEmerald, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueRuby] = _GUICtrlCreateIcon($g_sLibIconPath, $eRuby, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicBBLeague[$eLeagueDiamond] = _GUICtrlCreateIcon($g_sLibIconPath, $eDiamond, $x + 355, $y - 12, 40, 40)
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_hLblBBLeague1 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue1, $x + 382, $y + 12, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblBBLeague2 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue2, $x + 382, $y + 12, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblBBLeague3 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue3, $x + 382, $y + 13, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblBBLeague4 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue4, $x + 382, $y + 13, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblBBLeague5 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue5, $x + 382, $y + 13, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y = 75
	Local $iBBAttackGroupSize = 110 ; y size

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_13", "Builders Base Attacking"), $x - 10, $y, $g_iSizeWGrpTab3, 100)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBAttack, $x - 5, $y + 19, 20, 20)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableBBAttack_Info_01", "Uses the currently queued army to attack."))
	$g_hChkEnableBBAttack = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableBBAttack", "Attack"), $x + 20, $y + 20, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableBBAttack_Info_01", "Uses the currently queued army to attack."))
	GUICtrlSetOnEvent(-1, "chkEnableBBAttack")

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes", "Attack Count"), $x + 85, $y + 24)
	$g_hCmbBBAttackCount = GUICtrlCreateCombo("", $x + 150, $y + 20, 65, -1, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes_Info_01", "Set how many time Bot will Attack On Builder Base") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes_Info_02", "PRO Tips: set Stars will always attack while stars available") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes_Info_03", "PRO Tips: set Random will attack random times") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBAttackTimes_Info_04", "Type a number from 1 to 15."))
	GUICtrlSetOnEvent(-1, "cmbBBAttackCount")
	Local $sBBAttackCountList = "Stars|Random"
	For $i = 1 To 15
		$sBBAttackCountList &= "|" & $i
	Next
	GUICtrlSetData(-1, $sBBAttackCountList, "Random")
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBNextTroopDelay", "Next Troop Delay"), $x + 85, $y + 51)
	$g_hCmbBBNextTroopDelay = GUICtrlCreateCombo("", $x + 180, $y + 48, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBBNextTroopDelay_Info_01", "Set the delay between different troops. 1 fastest to 9 slowest."))
	GUICtrlSetOnEvent(-1, "cmbBBNextTroopDelay")
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9")
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlComboBox_SetCurSel($g_hCmbBBNextTroopDelay, 4)         ; start in middle

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblBBSameTroopDelay", "Same Troop Delay"), $x + 85, $y + 78)
	$g_hCmbBBSameTroopDelay = GUICtrlCreateCombo("", $x + 180, $y + 75, 30, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CmbBBSameTroopDelay_Info_01", "Set the delay between same troops. 1 fastest to 9 slowest."))
	GUICtrlSetOnEvent(-1, "cmbBBSameTroopDelay")
	GUICtrlSetData(-1, "1|2|3|4|5|6|7|8|9")
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlComboBox_SetCurSel($g_hCmbBBSameTroopDelay, 4)         ; start in middle

	$g_hBtnBBDropOrder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrder", "Drop Order"), $x + 10, $y + 52, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrder_Info", "Set a custom dropping order for your troops."))
	GUICtrlSetBkColor(-1, $COLOR_RED)
	GUICtrlSetOnEvent(-1, "btnBBDropOrder")
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkBBTrophyRange = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBTrophyRange", "Trophies"), $x + 235, $y + 10)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBTrophyRange_Info_01", "Enable ability to set a trophy range."))
	GUICtrlSetOnEvent(-1, "chkBBTrophyRange")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hTxtBBTrophyLowerLimit = GUICtrlCreateInput($g_iTxtBBTrophyLowerLimit, $x + 310, $y + 10, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBTrophyLimit_Info_01", "If your trophies go below this number then attacking is stopped."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hTxtBBTrophyUpperLimit = GUICtrlCreateInput($g_iTxtBBTrophyUpperLimit, $x + 360, $y + 10, 40, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBTrophyLimit_Info_02", "If your trophies go above this number then the bot drops trophies"))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkDropTrophyBB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Drop_Trophies", "Drop Trophies"), $x + 235, $y + 32, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Enable_dropping_trophies_in_Builder_Base_by_losing_attacks_intentionally", "Enable dropping trophies in Builder Base by losing attacks intentionally."))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkBBStarsAvailable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBStarsAvailable", "Stars Available"), $x + 330, $y + 32, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBStarsAvailable_Info_01", "Only attack when stars are available in Builder Base."))
	GUICtrlSetState(-1, $GUI_DISABLE)

	$g_hChkBBHaltOnStoragesFull = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBHaltOnStoragesFull", "Halt When Storages Are Full"), $x + 235, $y + 52)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBHaltOnStoragesFull_Info_01", "Halt if both Gold and Elixir Storages are Full."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "chkBBHaltOnStoragesFull")

	$g_hChkBBIgnoreFullStorages = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBIgnoreFullStorages", "Ignore Full Storages"), $x + 235, $y + 72)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBIgnoreFullStorages_Info_01", "Continue attacks even if storages are full (interacts with BB Spam)."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "chkBBIgnoreFullStorages")

	Local $iOffset = $iBBAttackGroupSize + 5
	Local $x = 15, $y = 175 + $iOffset - 25
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_04", "Collect && Activate"), $x - 10, $y - 14, $g_iSizeWGrpTab3, 74)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGoldMineL5, $x + 7, $y - 1, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixirCollectorL5, $x + 32, $y - 1, 24, 24)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGemMine, $x + 57, $y - 1, 24, 24)
	$g_hChkCollectBuilderBase = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectBuilderBase", "Collect Resources"), $x + 100, $y + 1, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCollectBuildersBase_Info_01", "Check this to collect Resources and Elixir Cart on the Builder Base"))
	$g_hChkCleanBBYard = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanBBYard", "Remove Obstacles"), $x + 260, $y + 1, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCleanBBYard_Info_01", "Check this to automatically clear Yard from Trees, Trunks, etc."))
	GUICtrlSetState(-1, $GUI_ENABLE)

	$y += 27
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnClockTower, $x + 32, $y + 1, 24, 24)
	$g_hChkStartClockTowerBoost = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkActivateClockTowerBoost", "Activate Clock Tower Boost"), $x + 100, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkActivateClockTowerBoost_Info_01", "Check this to activate the Clock Tower Boost when it is available.\r\nThis option doesn't use your Gems"))
	GUICtrlSetOnEvent(-1, "chkStartClockTowerBoost")
	$g_hChkCTBoostBlderBz = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCTBoostBlderBz", "Only When Builder Is Busy"), $x + 260, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkCTBoostBlderBz_Info_01", "boost only when the builder is busy"))
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $x = 15, $y = 175 + $iOffset - 89
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Attack_Options", "Attack Options"), $x - 10, $y - 23, $g_iSizeWGrpTab3, 70)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Attack_Sides", "Attack Sides:"), $x + 20, $y)
	$g_hChkBBAttack1Side = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_1_Side", "1 Side"), $x + 100, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Attack_1_side_in_Builder_Base", "Attack 1 side in Builder Base"))
	GUICtrlSetOnEvent(-1, "chkBBAttack1Side")
	$g_hChkBBAttack2Sides = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_2_Sides", "2 Sides"), $x + 180, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Attack_2_sides_in_Builder_Base", "Attack 2 sides in Builder Base"))
	GUICtrlSetOnEvent(-1, "chkBBAttack2Sides")
	$g_hChkBBAttackAllSides = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_All_Sides", "All Sides"), $x + 260, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Attack_all_sides_in_Builder_Base", "Attack all sides in Builder Base"))
	GUICtrlSetOnEvent(-1, "chkBBAttackAllSides")

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Prioritize_Defenses", "Prioritize Defenses:"), $x + 20, $y + 25)
	$g_hCmbBBPrioritizeDefenses = GUICtrlCreateCombo("", $x + 120, $y + 20, 150, -1, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_PriorityDefenseOptions", "None|Lava Launcher|Air Bomb|Mega Tesla|Guard Post"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Select_which_defense_to_prioritize_when_attacking", "Select which defense to prioritize when attacking"))
	GUICtrlSetOnEvent(-1, "cmbBBPrioritizeDefenses")

	$g_hChkBBUseTroopsSkills = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBUseTroopSkills", "Use Troop Skills"), $x + 300, $y + 20, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkBBUseTroopSkills_Info_01", "Activate troops skills during attack."))
	GUICtrlSetOnEvent(-1, "chkBBUseTroopSkills")

	GUICtrlSetState($g_hChkBBAttack1Side, $GUI_DISABLE)
	GUICtrlSetState($g_hChkBBAttack2Sides, $GUI_DISABLE)
	GUICtrlSetState($g_hChkBBAttackAllSides, $GUI_DISABLE)
	GUICtrlSetState($g_hCmbBBPrioritizeDefenses, $GUI_DISABLE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; BOB upgrades
	Local $x = 15, $y = 175 + $iOffset + 52
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_BOB_Upgrade", "BOB Upgrade"), $x - 10, $y - 14, $g_iSizeWGrpTab3, 86)
	Local $iCol1 = $x + 5, $iCol2 = $x + 142, $iCol3 = $x + 279
	Local $iRow1 = $y - 1, $iRow2 = $y + 29

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleMachine, $iCol1 + 3, $iRow1 + 3, 24, 24)
	$g_hChkBattleMachineUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Battle_Machine", "Battle Machine"), $iCol1 + 32, $iRow1 + 8, 99, -1)
	GUICtrlSetOnEvent(-1, "chkUpgradeBattleMachine")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnArcheTower6, $iCol2 + 2, $iRow1 + 2, 26, 26)
	$g_hChkArcherTowerUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Archer_Tower", "Archer Tower"), $iCol2 + 32, $iRow1 + 8, 99, -1)
	GUICtrlSetOnEvent(-1, "chkUpgradeArcherTower")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDoubleCannon4, $iCol3 + 1, $iRow1 + 1, 28, 28)
	$g_hChkDoubleCannonUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Double_Cannon", "Double Cannon"), $iCol3 + 32, $iRow1 + 8, 104, -1)
	GUICtrlSetOnEvent(-1, "chkUpgradeDoubleCannon")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBattleCopter, $iCol1 + 2, $iRow2 + 2, 26, 26)
	$g_hChkBattleCopterUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Battle_Copter", "Battle Copter"), $iCol1 + 32, $iRow2 + 8, 99, -1)
	GUICtrlSetOnEvent(-1, "chkUpgradeBattlecopter")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCannon9, $iCol2 - 4, $iRow2 - 4, 38, 38)
	$g_hChkAnyDefUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Cannon", "Cannon"), $iCol2 + 32, $iRow2 + 8, 90, -1)
	GUICtrlSetOnEvent(-1, "chkUpgradeAnyDef")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnMultiMortar8, $iCol3 + 3, $iRow2 + 3, 24, 24)
	$g_hChkMultiMortarUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Multi_Mortar", "Multi Mortar"), $iCol3 + 32, $iRow2 + 8, 104, -1)
	GUICtrlSetOnEvent(-1, "chkUpgradeMultiMortar")

EndFunc   ;==>CreateMiscBuilderBaseSubTab

; Clan Games v3
Func CreateMiscClanGamesV3SubTab()

	Local Const $g_sLibIconPathMOD = @ScriptDir & "\images\ClanGames.bmp"

	; GUI SubTab
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_CG", "Clan Games"), $x - 10, $y - 20, $g_iSizeWGrpTab3 - 5, 245)
	GUICtrlCreatePic($g_sLibIconPathMOD, $x + 5, $y, 94, 128, $SS_BITMAP)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesTimeRemaining", "Time Remaining"), $x - 5, $y + 135, 110, 40)
	$g_hLblRemainTime = GUICtrlCreateLabel("N/A", $x + 15, $y + 135 + 15, 65, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, $GUI_FONTNORMAL)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesYourScore", "Your Score"), $x - 5, $y + 158 + 20, 110, 40)
	$g_hLblYourScore = GUICtrlCreateLabel("N/A", $x + 15, $y + 158 + 35, 65, 17, $SS_CENTER)
	GUICtrlSetFont(-1, 9.5, $FW_BOLD, $GUI_FONTNORMAL)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 33
	$x = 135
	$g_hChkClanGamesEnabled = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesEnabled", "Enabled"), $x, $y + 10, -1, -1)
	GUICtrlSetOnEvent(-1, "chkActivateClangames")
	$g_hChkClanGamesDisableWhenCompleted = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDisableWhenCompleted", "Disable Upon Completion"), $x + 80, $y + 10, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesDisableWhenCompleted_Info", "Disable Clan Games after the score limit is reached."))

	$g_hChkClanGamesDebug = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CGDebug", "Debug CG"), $x + 220, $y + 3, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Check_To_Enable_Clan_Games_Debug", "Check To Enable Clan Games Debug."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_hChkCGDebugEvents = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CGDebugEvents", "CG Events"), $x + 220, $y + 23, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Check_To_Capture_CG_Events_Window", "Check To Capture CG Events Window."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 55
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_CG_Challenges", "Challenges"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 130, 70)
	$y += 10
	$g_hBtnCGSettingsOpen = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Clan_Games_Settings", "Clan Games Settings"), $x + 80, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "btnCGSettings")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 80
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_CG_Rewards", "Rewards"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 130, 70)
	$y += 10
	$g_hChkClanGamesCollectRewards = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesCollectRewards", "Collect"), $x, $y + 2, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesCollectRewards_Info1", "Check This To Auto Collect Rewards At the End of Clan Games.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesCollectRewards_Info2", "Settings are in \Profiles\YourProfile\ClanGamesRewards.ini"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x = 15
	$y = 40
	$g_hTxtClanGamesLog = GUICtrlCreateEdit("", $x - 10, 275, $g_iSizeWGrpTab3, 127, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtClanGamesLog", _
			"--------------------------------------------------------- Clan Games LOG ------------------------------------------------"))

EndFunc   ;==>CreateMiscClanGamesV3SubTab

Func CreateClanGamesSettings()
	Local $tmpChallenges
	$g_hGUI_CGSettings = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_CGSettings", "ClanGames Challenge Settings"), $_GUI_MAIN_WIDTH - 4, $_GUI_MAIN_HEIGHT - 100, $g_iFrmBotPosX, $g_iFrmBotPosY + 80, $WS_DLGFRAME, -1, $g_hFrmBot)
	Local $x = 25, $y = 25

	$g_hClanGamesTV = GUICtrlCreateTreeView(6, 6, 200, $_GUI_MAIN_HEIGHT - 140, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_CHECKBOXES), $WS_EX_CLIENTEDGE)

	$g_hChkCGMainHero = GUICtrlCreateTreeViewItem("Hero Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGMainHero, True)
	GUICtrlSetOnEvent(-1, "CGMainHeroTVRoot")
	$tmpChallenges = ClanGamesChallenges("$HeroChallenges")
	; Hero deployment challenges, then hero hunting challenges.
	Local $aHeroChallengeDisplayOrder[11] = [0, 1, 3, 2, 4, 5, 6, 7, 8, 9, 10]
	For $j = 0 To UBound($aHeroChallengeDisplayOrder) - 1
		Local $iHeroChallengeIndex = $aHeroChallengeDisplayOrder[$j]
		$g_ahCGMainHeroItem[$iHeroChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iHeroChallengeIndex][1], $g_hChkCGMainHero)
		GUICtrlSetOnEvent(-1, "CGMainHeroTVItem")
	Next

	$g_hChkCGMainLoot = GUICtrlCreateTreeViewItem("Loot Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGMainLoot, True)
	GUICtrlSetOnEvent(-1, "CGLootTVRoot")
	$tmpChallenges = ClanGamesChallenges("$LootChallenges")
	; Gold, elixir, then dark elixir; single-battle and cumulative challenges paired.
	Local $aLootChallengeDisplayOrder[6] = [0, 3, 1, 4, 2, 5]
	For $j = 0 To UBound($aLootChallengeDisplayOrder) - 1
		Local $iLootChallengeIndex = $aLootChallengeDisplayOrder[$j]
		$g_ahCGMainLootItem[$iLootChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iLootChallengeIndex][1], $g_hChkCGMainLoot)
		GUICtrlSetOnEvent(-1, "CGLootTVItem")
	Next

	$g_hChkCGMainBattle = GUICtrlCreateTreeViewItem("Battle Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGMainBattle, True)
	GUICtrlSetOnEvent(-1, "CGMainBattleTVRoot")
	$tmpChallenges = ClanGamesChallenges("$BattleChallenges")
	; Stars, victories, destruction, then restricted-army challenges.
	Local $aBattleChallengeDisplayOrder[8] = [0, 3, 2, 4, 1, 5, 6, 7]
	For $j = 0 To UBound($aBattleChallengeDisplayOrder) - 1
		Local $iBattleChallengeIndex = $aBattleChallengeDisplayOrder[$j]
		$g_ahCGMainBattleItem[$iBattleChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iBattleChallengeIndex][1], $g_hChkCGMainBattle)
		GUICtrlSetOnEvent(-1, "CGMainBattleTVItem")
	Next

	$g_hChkCGMainDestruction = GUICtrlCreateTreeViewItem("Destruction Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGMainDestruction, True)
	GUICtrlSetOnEvent(-1, "CGMainDestructionTVRoot")
	$tmpChallenges = ClanGamesChallenges("$DestructionChallenges")
	; Defenses alphabetically, resource buildings, support buildings, then general destruction.
	Local $aDestructionChallengeDisplayOrder[26] = [4, 6, 1, 8, 2, 0, 11, 10, 3, 25, 7, 5, 9, 16, 17, 18, 13, 14, 15, 24, 12, 19, 20, 21, 23, 22]
	For $j = 0 To UBound($aDestructionChallengeDisplayOrder) - 1
		Local $iDestructionChallengeIndex = $aDestructionChallengeDisplayOrder[$j]
		$g_ahCGMainDestructionItem[$iDestructionChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iDestructionChallengeIndex][1], $g_hChkCGMainDestruction)
		GUICtrlSetOnEvent(-1, "CGMainDestructionTVItem")
	Next

	$g_hChkCGMainAir = GUICtrlCreateTreeViewItem("Air Troop Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGMainAir, True)
	GUICtrlSetOnEvent(-1, "CGMainAirTVRoot")
	$tmpChallenges = ClanGamesChallenges("$AirTroopChallenges")
	; Display elixir troops, dark elixir troops, Super Troops, then siege machines; retain saved indices.
	Local $aAirChallengeDisplayOrder[14] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 10, 9, 11, 12, 13]
	For $j = 0 To UBound($aAirChallengeDisplayOrder) - 1
		Local $iAirChallengeIndex = $aAirChallengeDisplayOrder[$j]
		$g_ahCGMainAirItem[$iAirChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iAirChallengeIndex][1], $g_hChkCGMainAir)
		GUICtrlSetOnEvent(-1, "CGMainAirTVItem")
	Next

	$g_hChkCGMainGround = GUICtrlCreateTreeViewItem("Ground Troop Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGMainGround, True)
	GUICtrlSetOnEvent(-1, "CGMainGroundTVRoot")
	$tmpChallenges = ClanGamesChallenges("$GroundTroopChallenges")
	; Display elixir troops, dark elixir troops, Super Troops, then siege machines; retain saved indices.
	Local $aGroundChallengeDisplayOrder[32] = [1, 0, 2, 3, 4, 5, 6, 9, 8, 14, 7, 12, 13, 10, 11, 15, 16, 17, 18, 19, 20, 21, 22, 26, 27, 28, 23, 24, 25, 29, 30, 31]
	For $j = 0 To UBound($aGroundChallengeDisplayOrder) - 1
		Local $iGroundChallengeIndex = $aGroundChallengeDisplayOrder[$j]
		$g_ahCGMainGroundItem[$iGroundChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iGroundChallengeIndex][1], $g_hChkCGMainGround)
		GUICtrlSetOnEvent(-1, "CGMainGroundTVItem")
	Next
	$g_hChkCGMainMisc = GUICtrlCreateTreeViewItem("Miscellaneous Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGMainMisc, True)
	GUICtrlSetOnEvent(-1, "CGMainMiscTVRoot")
	$tmpChallenges = ClanGamesChallenges("$MiscChallenges")
	; Troop donations, spell donations, then obstacle clearing.
	Local $aMiscChallengeDisplayOrder[3] = [2, 1, 0]
	For $j = 0 To UBound($aMiscChallengeDisplayOrder) - 1
		Local $iMiscChallengeIndex = $aMiscChallengeDisplayOrder[$j]
		$g_ahCGMainMiscItem[$iMiscChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iMiscChallengeIndex][1], $g_hChkCGMainMisc)
		GUICtrlSetOnEvent(-1, "CGMainMiscTVItem")
	Next

	$g_hChkCGMainSpell = GUICtrlCreateTreeViewItem("Spell Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGMainSpell, True)
	GUICtrlSetOnEvent(-1, "CGMainSpellTVRoot")
	$tmpChallenges = ClanGamesChallenges("$SpellChallenges")
	; Elixir spells, then dark elixir spells, in unlock order.
	Local $aSpellChallengeDisplayOrder[12] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
	For $j = 0 To UBound($aSpellChallengeDisplayOrder) - 1
		Local $iSpellChallengeIndex = $aSpellChallengeDisplayOrder[$j]
		$g_ahCGMainSpellItem[$iSpellChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iSpellChallengeIndex][1], $g_hChkCGMainSpell)
		GUICtrlSetOnEvent(-1, "CGMainSpellTVItem")
	Next

	$g_hChkCGBBBattle = GUICtrlCreateTreeViewItem("BB Battle Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGBBBattle, True)
	GUICtrlSetOnEvent(-1, "CGBBBattleTVRoot")
	$tmpChallenges = ClanGamesChallenges("$BBBattleChallenges")
	; Stars, victories, destruction, then timed challenges.
	Local $aBBBattleChallengeDisplayOrder[4] = [0, 1, 3, 2]
	For $j = 0 To UBound($aBBBattleChallengeDisplayOrder) - 1
		Local $iBBBattleChallengeIndex = $aBBBattleChallengeDisplayOrder[$j]
		$g_ahCGBBBattleItem[$iBBBattleChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iBBBattleChallengeIndex][1], $g_hChkCGBBBattle)
		GUICtrlSetOnEvent(-1, "CGBBBattleTVItem")
	Next

	$g_hChkCGBBDestruction = GUICtrlCreateTreeViewItem("BB Destruction Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGBBDestruction, True)
	GUICtrlSetOnEvent(-1, "CGBBDestructionTVRoot")
	$tmpChallenges = ClanGamesChallenges("$BBDestructionChallenges")
	; Defenses alphabetically, support and resource buildings, then general destruction.
	Local $aBBDestructionChallengeDisplayOrder[21] = [0, 16, 3, 15, 5, 6, 8, 9, 17, 10, 11, 12, 19, 2, 18, 13, 4, 20, 7, 1, 14]
	For $j = 0 To UBound($aBBDestructionChallengeDisplayOrder) - 1
		Local $iBBDestructionChallengeIndex = $aBBDestructionChallengeDisplayOrder[$j]
		$g_ahCGBBDestructionItem[$iBBDestructionChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iBBDestructionChallengeIndex][1], $g_hChkCGBBDestruction)
		GUICtrlSetOnEvent(-1, "CGBBDestructionTVItem")
	Next

	$g_hChkCGBBTroops = GUICtrlCreateTreeViewItem("BB Troop Challenges", $g_hClanGamesTV)
	ClanGamesCategoryStateChanged($g_hChkCGBBTroops, True)
	GUICtrlSetOnEvent(-1, "CGBBTroopsTVRoot")
	$tmpChallenges = ClanGamesChallenges("$BBTroopsChallenges")
	; Builder Base troops in unlock order.
	Local $aBBTroopsChallengeDisplayOrder[12] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
	For $j = 0 To UBound($aBBTroopsChallengeDisplayOrder) - 1
		Local $iBBTroopsChallengeIndex = $aBBTroopsChallengeDisplayOrder[$j]
		$g_ahCGBBTroopsItem[$iBBTroopsChallengeIndex] = GUICtrlCreateTreeViewItem($tmpChallenges[$iBBTroopsChallengeIndex][1], $g_hChkCGBBTroops)
		GUICtrlSetOnEvent(-1, "CGBBTroopsTVItem")
	Next

	$x = 220
	$y -= 23
	$g_hChkForceAttackOnClanGames = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkForceAttackOnClanGames", "Always Force Attack"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkForceAttackOnClanGames")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkForceAttackOnClanGames_Info", _
			"For an active Clan Games challenge: allow Home Village attacks in Halt mode and ignore Builder Base trophy, loot and Battle Machine wait limits." & @CRLF & _
			"Finish the active challenge before stopping or closing the bot."))

	$y += 33
	$g_hChkClanGamesPurgeAny = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesPurgeAny", "Purge Unselected Challenges"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGames_Info_04", "When no enabled challenge is available, start and purge a challenge to refresh the choices."))
	GUICtrlSetOnEvent(-1, "ChkClanGamesPurgeAny")

	$y += 33
	$g_hChkClanGamesStopBeforeReachAndPurge = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesStopBeforeReachAndPurge", "Reserve Points && Purge"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGames_Info_06", "Stop completing challenges within 300 points of your personal limit and only purge challenges." & @CRLF & _
			"On the final day of Clan Games, resume completing challenges."))

	$y += 35
	GUIStartGroup()
	$g_hChkClanGamesAllTimes = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_All_Challenges", "All Challenges"), $x + 20, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Classic_Behaviour_All_Times_Challenges", "Classic Behaviour : All Times Challenges"))
	GUICtrlSetOnEvent(-1, "ChkClanGamesAllTimes")
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hChkClanGamesNoOneDay = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_No_1_Day_Challenges", "No 1 Day Challenges"), $x + 120, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Not_choose_1_Day_Challenges_This_Will_be_8_Hours_Or_3_Hours_Challenges", "Not choose 1 Day Challenges, This Will be 8 Hours Or 3 Hours Challenges"))
	GUICtrlSetOnEvent(-1, "ChkClanGamesNoOneDay")
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$y += 35
	$g_hChkClanGamesSort = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkClanGamesSort", "Challenges Sorting :"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "chkSortClanGames")
	GUICtrlSetState(-1, $GUI_CHECKED)

	$y += 23
	$g_hCmbClanGamesSort = GUICtrlCreateCombo("", $x + 20, $y, 120, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	Local $sCmbTxt = "Lower Difficulties|Shortest Times|Longest Times|Lowest Points|Highest Points"
	GUICtrlSetData(-1, $sCmbTxt, "Lower Difficulties")

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ClangamesDesc", "Description"), $x - 10, $y - 15, 250, 120)
	$g_hLabelClangamesDesc = GUICtrlCreateLabel("", $x, $y, 230, 100)
	GUICtrlSetFont(-1, 9, $FW_BOLD, $GUI_FONTITALIC)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 135
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ClangamesPriority", "Challenges Priority Select"), $x - 10, $y - 15, 250, 45)
	$hSearchBBEventFirst = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SearchBBEventFirst", "BB First"), $x, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x += 65
	$hSearchMainEventFirst = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SearchMainEventFirst", "Main First"), $x, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)

	$x += 70
	$hSearchBothVillages = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "SearchBothVillages", "Both Equal"), $x, $y, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$g_hBtnCGSettingsClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnCGSettings", "Close"), $_GUI_MAIN_WIDTH - 100, $_GUI_MAIN_HEIGHT - 160, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCGSettings")

EndFunc   ;==>CreateClanGamesSettings

; Builder base drop order gui
Func CreateBBDropOrderGUI()
	$g_hGUI_BBDropOrder = _GUICreate(GetTranslatedFileIni("GUI Design Child Village - Misc", "GUI_BBDropOrder", "BB Custom Drop Order"), 322, 313, -1, -1, $WS_BORDER, $WS_EX_CONTROLPARENT)


	Local $x = 25, $y = 25
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BBDropOrderGroup", "BB Custom Dropping Order"), $x - 20, $y - 20, 308, 250)
	$x += 10
	$y += 20

	$g_hChkBBCustomDropOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BBChkCustomDropOrderEnable", "Enable Custom Dropping Order"), $x - 13, $y - 22, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BBChkCustomDropOrderEnable_Info_01", "Enable to select a custom troops dropping order"))
	GUICtrlSetOnEvent(-1, "chkBBDropOrder")

	$y += 5
	For $i = 0 To $g_iBBTroopCount - 1
		If $i < 6 Then
			GUICtrlCreateLabel($i + 1 & ":", $x - 19, $y + 3 + 25 * $i, -1, 18)
			$g_ahCmbBBDropOrder[$i] = GUICtrlCreateCombo("", $x, $y + 25 * $i, 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIBBDropOrder")
			GUICtrlSetData(-1, $g_sBBDropOrderDefault)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBDropOrder", "Enter sequence order for drop of troop #" & $i + 1))
			GUICtrlSetState(-1, $GUI_DISABLE)
		Else
			GUICtrlCreateLabel($i + 1 & ":", $x + 150 - 19, $y + 3 + 25 * ($i - 6), -1, 18)
			$g_ahCmbBBDropOrder[$i] = GUICtrlCreateCombo("", $x + 150, $y + 25 * ($i - 6), 94, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIBBDropOrder")
			GUICtrlSetData(-1, $g_sBBDropOrderDefault)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtBBDropOrder", "Enter sequence order for drop of troop #" & $i + 1))
			GUICtrlSetState(-1, $GUI_DISABLE)
		EndIf
	Next

	$x = 25
	$y = 225
	; Create push button to set training order once completed
	$g_hBtnBBDropOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderSet", "Apply New Order"), $x, $y, 100, 25)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderSet_Info_01", "Push button when finished selecting custom troops dropping order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderSet_Info_02", "When not all troop slots are filled, will use default order."))
	GUICtrlSetOnEvent(-1, "BtnBBDropOrderSet")

	$x += 150
	$g_hBtnBBRemoveDropOrder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBRemoveDropOrder", "Empty Drop List"), $x, $y, 118, 25)
	GUICtrlSetState(-1, BitOR($GUI_UNCHECKED, $GUI_DISABLE))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBRemoveDropOrder_Info_01", "Push button to remove all troops from list and start over"))
	GUICtrlSetOnEvent(-1, "BtnBBRemoveDropOrder")

	$g_hBtnBBClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "BtnBBDropOrderClose", "Close"), 229, 258, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseCustomBBDropOrder")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBBDropOrderGUI

Func CreateClanCapitalTab()
	Local $x = 15, $y = 40
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_01", "Stats"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 70)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalGold, $x, $y + 1, 24, 24)
	$g_lblCapitalGold = GUICtrlCreateLabel("---", $x + 35, $y + 5, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalMedal, $x + 110, $y, 24, 24)
	$g_lblCapitalMedal = GUICtrlCreateLabel("---", $x + 145, $y + 5, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalTrophy, $x + 220, $y - 4, 32, 32)
	$g_lblCapitalTrophies = GUICtrlCreateLabel("---", $x + 255, $y + 5, 100, -1)
	GUICtrlSetFont(-1, 9, $FW_BOLD, Default, "Arial", $CLEARTYPE_QUALITY)

	$y += 30

	$g_hChkEnableCollectCCGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "CollectCCGold", "Collect Clan Capital Gold"), $x, $y, -1, -1)

	GUICtrlCreateLabel("", $x + 313, $y - 39, 1, 63)
	GUICtrlSetBkColor(-1, 0xC3C3C3)

	$g_ahPicCCLeague[$eLeagueUnranked] = _GUICtrlCreateIcon($g_sLibIconPath, $eUnranked, $x + 345, $y - 27, 46, 46)
	GUICtrlSetState(-1, $GUI_SHOW)
	$g_ahPicCCLeague[$eLeagueBronze] = _GUICtrlCreateIcon($g_sLibIconPath, $eBronze, $x + 345, $y - 27, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueSilver] = _GUICtrlCreateIcon($g_sLibIconPath, $eSilver, $x + 345, $y - 26, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueGold] = _GUICtrlCreateIcon($g_sLibIconPath, $eGold, $x + 345, $y - 24, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueCrystal] = _GUICtrlCreateIcon($g_sLibIconPath, $eCrystal, $x + 345, $y - 28, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueMaster] = _GUICtrlCreateIcon($g_sLibIconPath, $eMaster, $x + 345, $y - 24, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueChampion] = _GUICtrlCreateIcon($g_sLibIconPath, $eLChampion, $x + 345, $y - 25, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueTitan] = _GUICtrlCreateIcon($g_sLibIconPath, $eTitan, $x + 345, $y - 25, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_ahPicCCLeague[$eLeagueLegend] = _GUICtrlCreateIcon($g_sLibIconPath, $eLegend, $x + 345, $y - 27, 46, 46)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Bot - Stats", "LblLeague", "League"), $x + 345, $y - 38, -1, -1, $SS_CENTER)

	$g_hLblCCLeague1 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue1, $x + 376, $y + 6, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblCCLeague2 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue2, $x + 376, $y + 6, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hLblCCLeague3 = _GUICtrlCreateIcon($g_sLibIconPath, $eLigue3, $x + 376, $y + 7, 10, 10)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_02", "Forge/Craft Gold"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 113)
	$g_hChkEnableForgeGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeGold", "Use Gold"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeGold")
	$g_hLbacmdGoldSaveMin = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Save", "Save : "), $x + 70, $y + 4, -1, -1)
	$g_acmdGoldSaveMin = GUICtrlCreateInput("150000", $x + 110, $y + 2, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 8)
	$y += 20
	$g_hChkEnableForgeElix = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeElix", "Use Elixir"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeElix")
	$g_hLbacmdElixSaveMin = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Save", "Save : "), $x + 70, $y + 4, -1, -1)
	$g_acmdElixSaveMin = GUICtrlCreateInput("1000", $x + 110, $y + 2, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 8)
	$x += 100
	$y -= 20
	$g_hChkEnableForgeDE = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeDE", "Use Dark"), $x - 100, $y + 40, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeDE")
	$g_hLbacmdDarkSaveMin = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Save", "Save : "), $x - 30, $y + 44, -1, -1)
	$g_acmdDarkSaveMin = GUICtrlCreateInput("1000", $x + 10, $y + 42, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 6)
	$g_hChkEnableSmartUse = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableSmartUse", "Smart Use of Resources"), $x + 115, $y + 40, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableSmartUse_Info_01", "If checked, Bot will use resources in the order of their values.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableSmartUse_Info_02", "If unchecked, Bot will use resources by type."))
	$y += 20
	$g_hChkEnableForgeBBElix = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeBBElix", "Use BB Elixir"), $x + 115, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeBBElix")
	$g_hLbacmdBBElixSaveMin = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Save", "Save : "), $x + 200, $y + 4, -1, -1)
	$g_acmdBBElixSaveMin = GUICtrlCreateInput("1000", $x + 240, $y + 2, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 7)
	$x += 115
	$y -= 20
	$g_hChkEnableForgeBBGold = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "EnableCCGoldForgeBBGold", "Use BB Gold"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkEnableForgeBBGold")
	$g_hLbacmdBBGoldSaveMin = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Custom_Save", "Save : "), $x + 85, $y + 4, -1, -1)
	$g_acmdBBGoldSaveMin = GUICtrlCreateInput("1000", $x + 125, $y + 2, 55, 18, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	GUICtrlSetLimit(-1, 7)
	$x = 15
	$y += 68
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeUseBuilder", "Use "), $x, $y + 2, 45, 17)
	$g_hCmbForgeBuilder = GUICtrlCreateCombo("", $x + 24, $y - 2, 40, 18, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "0|1|2|3|4", "0")
	GUICtrlSetOnEvent(-1, "CmbForgeBuilder")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "InputForgeUseBuilder", "Put How many builder to use to Forge") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "InputForgeUseBuilder2", "Set ""0"" to disable regular builder forge slots."))
	$g_hLbCmbForgeBuilder = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "LblForgeBuilder", "Builder for Forge"), $x + 69, $y + 2, 100, 25)
	; Gold Pass forge slot does not consume builders.
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnXbow, $x + 185, $y - 1, 24, 24)
	$g_hChkUseGoldPassForgeOnly = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkUseGoldPassForgeOnly", "Use Gold Pass Forge"), $x + 215, $y + 2, -1, -1)
	GUICtrlSetOnEvent(-1, "ChkUseGoldPassForgeOnly")

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 47
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Group_ClanCapital_03", "Auto Upgrade Clan Capital"), $x - 10, $y - 15, $g_iSizeWGrpTab3 - 3, 65)
	$g_hChkEnableAutoUpgradeCC = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkEnableAutoUpgradeCC", "Enable"), $x, $y, -1, -1)
	GUICtrlSetOnEvent(-1, "EnableAutoUpgradeCC")
	$g_hChkAutoUpgradeCCTreasury = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCTreasury", "Capital Treasury"), $x + 100, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCTreasury", "Donate all available Capital Gold to the Capital Treasury instead of upgrading buildings"))
	$y += 20
	$g_hChkAutoUpgradeCCPriorArmy = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCPriorArmy", "Prior Army Stuff"), $x, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCPriorArmy", "Prior Army Camps, Barracks, Fortress Yard, Spell Storage and Factory"))
	$g_hChkAutoUpgradeCCIgnore = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCIgnore", "Ignore Decoration Buildings"), $x + 100, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCIgnore", "Enable Ignore Upgrade for Groove, Tree, Forest, Campsite, etc..."))
	$g_hChkAutoUpgradeCCWallIgnore = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "ChkAutoUpgradeCCWallIgnore", "Ignore Walls"), $x + 255, $y, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "Info_ChkAutoUpgradeCCWallIgnore", "Enable Ignore Upgrade for Walls"))
	$y += 40
	$g_hTxtAutoUpgradeCCLog = GUICtrlCreateEdit("", $x - 10, $y, $g_iSizeWGrpTab3 - 3, 105, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY, $ES_AUTOVSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "TxtCCLog", "------------------------------------------- CLAN CAPITAL UPGRADE LOG --------------------------------------"))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateClanCapitalTab
