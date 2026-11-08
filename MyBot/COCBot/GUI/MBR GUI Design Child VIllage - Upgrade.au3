; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the "Upgrade" tab under the "Village" tab
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

Global $g_hGUI_UPGRADE = 0, $g_hGUI_UPGRADE_TAB = 0, $g_hGUI_UPGRADE_TAB_ITEM1 = 0, $g_hGUI_UPGRADE_TAB_ITEM2 = 0, $g_hGUI_UPGRADE_TAB_ITEM3 = 0, _
		$g_hGUI_UPGRADE_TAB_ITEM4 = 0, $g_hGUI_UPGRADE_TAB_ITEM5 = 0

; Lab
Global $g_hChkAutoLabUpgrades = 0, $g_ahCmbLabPriority[3] = [0, 0, 0], $g_hBtnResetLabUpgradeTime = 0
Global $g_hChkAutoStarLabUpgrades = 0, $g_ahCmbStarLabPriority[3] = [0, 0, 0], $g_hBtnResetStarLabUpgradeTime = 0
Global $g_hChkLabAssistantLabel = 0, $g_hChkLabAssistant = 0

; Heroes
Global $g_hChkUpgradeKing = 0, $g_hChkUpgradeQueen = 0, $g_hChkUpgradePrince = 0, $g_hChkUpgradeWarden = 0, _
		$g_hPicChkKingSleepWait = 0, $g_hPicChkQueenSleepWait = 0, $g_hPicChkPrinceSleepWait = 0, $g_hPicChkWardenSleepWait = 0
Global $g_hCmbHeroReservedBuilder = 0, $g_hLblHeroReservedBuilderTop = 0, $g_hLblHeroReservedBuilderBottom = 0, $g_hBtnHeroEquipment = 0
Global $g_hChkUpgradeChampion = 0, $g_hPicChkChampionSleepWait = 0
Global $g_hChkUpgradeDuke = 0, $g_hPicChkDukeSleepWait = 0
Global $g_hChkUpgradeHero7 = 0, $g_hPicUpgradeHero7 = 0

Global $g_hChkUpgradePets[$ePetCount]
Global $g_hBtnUpgradeHeroesAll = 0, $g_hBtnUpgradeHeroesReset = 0

Global $g_hGUI_HeroEquipment = 0, $g_hBtnHeroEquipmentClose = 0

; Buildings
Global $g_hChkUpgrade[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hPicUpgradeStatus[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeName[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeLevel[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hPicUpgradeType[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeValue[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeTime[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgradeEndTime[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hChkUpgradeRepeat[$g_iUpgradeSlots] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Global $g_hTxtUpgrMinGold = 0, $g_hTxtUpgrMinElixir = 0, $g_hTxtUpgrMinDark = 0
Global $g_hCmbBuildingReservedBuilder = 0, $g_hLblBuildingReservedBuilderTop = 0

; Walls
Global $g_hChkWallGoldPass = 0, $g_hCmbWallGoldPass = 0
Global $g_hChkWallHammerJam = 0
Global $g_hChkWalls = 0, $g_hTxtWallMinGold = 0, $g_hTxtWallMinElixir = 0, $g_hRdoUseGold = 0, $g_hRdoUseElixir = 0, $g_hRdoUseElixirGold = 0, $g_hChkSaveWallBldr = 0, _
		$g_hCmbWalls = 4, $g_hCmbUpgradeWallStorageLimit = 0
Global $g_hLblWallCost = 0, $g_hBtnFindWalls = 0, $g_hBtnResetWallCounter = 0
Global $g_ahWallsCurrentCount[20] = [-1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 to 3 are not referenced
Global $g_ahPicWallsLevel[20] = [-1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; elements 0 to 3 are not referenced

; Auto Upgrade
Global $g_hChkAutoPetUpgrade = 0
Global $g_hChkAutoUpgrade = 0, $g_hChkAutoLabUpgrade = 0, $g_hChkAutoUpgradeBB = 0, $g_hChkAutoStarUpgradeBB = 0
Global $g_hChkAppBuilderLabel = 0, $g_hChkAppBuilder = 0
Global $g_hCmbAutoUpgradeResource = 0, $g_hCmbAutoUpgradeType = 0, $g_hCmbAutoUpgradeSorting = 0
Global $g_hCmbAutoLabUpgradeResource = 0, $g_hCmbAutoLabUpgradeType = 0, $g_hCmbAutoLabUpgradeSorting = 0
Global $g_hPicAutoUpgradeResource = 0, $g_hPicAutoLabUpgradeResource = 0
Global $g_hPicAutoUpgradeType = 0, $g_hPicAutoUpgradeSorting = 0, $g_hPicAutoLabUpgradeType = 0, $g_hPicAutoLabUpgradeSorting = 0
Global $g_hCmbAutoUpgradeBBResource = 0, $g_hCmbAutoUpgradeBBType = 0, $g_hCmbAutoUpgradeBBSorting = 0
Global $g_hCmbAutoLabUpgradeBBSorting = 0
Global $g_hPicAutoUpgradeBBResource = 0
Global $g_hPicAutoUpgradeBBType = 0, $g_hPicAutoUpgradeBBSorting = 0, $g_hPicAutoLabUpgradeBBSorting = 0

Func CreateVillageUpgrade()

	$g_hGUI_UPGRADE = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_VILLAGE)
	;GUISetBkColor($COLOR_WHITE, $g_hGUI_UPGRADE)

	GUISwitch($g_hGUI_UPGRADE)
	$g_hGUI_UPGRADE_TAB = GUICtrlCreateTab(0, 0, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, BitOR($TCS_MULTILINE, $TCS_RIGHTJUSTIFY))
	$g_hGUI_UPGRADE_TAB_ITEM5 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_05", "Auto Upgrade"))
	CreateAutoUpgradeSubTab()
	$g_hGUI_UPGRADE_TAB_ITEM3 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_03", "Buildings"))
	CreateBuildingsSubTab()
	$g_hGUI_UPGRADE_TAB_ITEM2 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_02", "Heroes"))
	CreateHeroesSubTab()
	$g_hGUI_UPGRADE_TAB_ITEM1 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_01", "Lab"))
	CreateLaboratorySubTab()
	$g_hGUI_UPGRADE_TAB_ITEM4 = GUICtrlCreateTabItem(GetTranslatedFileIni("MBR Main GUI", "Tab_02_STab_03_STab_04", "Walls"))
	CreateWallsSubTab()
	CreateHeroEquipment()
	GUICtrlCreateTabItem("")

EndFunc   ;==>CreateVillageUpgrade

Func CreateLaboratorySubTab()
	Local $sTxtNames = GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBarbarian", "Barbarian") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtArcher", "Archer") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGiant", "Giant") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGoblin", "Goblin") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallBreaker", "Wall Breaker") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBalloon", "Balloon") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWizard", "Wizard") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHealer", "Healer") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragon", "Dragon") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtPekka", "Pekka") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBabyDragon", "Baby Dragon") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMiner", "Miner") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtEDragon", "Electro Dragon") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtYeti", "Yeti") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDragonRider", "Dragon Rider") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtElectroTitan", "Electro Titan") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRootRider", "Root Rider") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRootThrower", "Thrower") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMeteorGolem", "Meteor Golem") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtLightningSpell", "Lightning Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHealingSpell", "Healing Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRageSpell", "Rage Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtJumpSpell", "Jump Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtFreezeSpell", "Freeze Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtCloneSpell", "Clone Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtInvisibilitySpell", "Invisibility Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtRecallSpell", "Recall Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtReviveSpell", "Revive Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtTotemSpell", "Totem Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtPoisonSpell", "Poison Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtEarthQuakeSpell", "EarthQuake Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtHasteSpell", "Haste Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtSkeletonSpell", "Skeleton Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtBatSpell", "Bat Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtOvergrowthSpell", "Overgrowth Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtIBSpell", "Ice Block Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Spells", "TxtAngrySpell", "Angry Spell") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtMinion", "Minion") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHogRider", "Hog Rider") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtValkyrie", "Valkyrie") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtGolem", "Golem") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWitch", "Witch") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLavaHound", "Lava Hound") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBowler", "Bowler") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtIceGolem", "Ice Golem") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtHeadhunter", "Headhunter") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtAppWard", "App. Warden") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtDruid", "Druid") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtFurnace", "Furnace") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtRuinWitch", "Ruin Witch") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtWallWrecker", "Wall Wrecker") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBattleBlimp", "Battle Blimp") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtStoneSlammer", "Stone Slammer") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSiegeBarrack", "Siege Barrack") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtLogLauncher", "Log Launcher") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtFlameFlinger", "Flame Flinger") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtBattleDrill", "Battle Drill") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtTroopLauncher", "Troop Launcher") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Troops", "TxtSkyWagon", "Sky Wagon")

	Local $sTxtSLNames = GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtRagedBarbarian", "Raged Barbarian") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtSneakyArcher", "Sneaky Archer") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBoxerGiant", "Boxer Giant") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBetaMinion", "Beta Minion") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBomber", "Bomber") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtBabyDragon", "Baby Dragon") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtCannonCart", "Cannon Cart") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtNightWitch", "Night Witch") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtDropShip", "Drop Ship") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtSuperPekka", "Super Pekka") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtHogGlider", "Hog Glider") & "|" & _
			GetTranslatedFileIni("MBR Global GUI Design Names Builderbase Troops", "TxtEFWizard", "ElectroFire Wizard")

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "Group_01", "Laboratory"), $x - 20, $y - 20, $g_iSizeWGrpTab3 - 5, 185)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnLabUpgrade, $x, $y, 64, 64)
	$g_hChkAutoLabUpgrades = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoLabUpgrades", "Auto Laboratory Upgrades"), $x + 80, $y + 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoLabUpgrades_Info_01", "Check box to enable automatically starting Upgrades in laboratory"))
	GUICtrlSetOnEvent(-1, "chkLab")
	; Red button, will show on upgrade in progress. Temp unhide here and in Func ChkLab() if GUI needs editing.
	$g_hBtnResetLabUpgradeTime = GUICtrlCreateButton("", $x + 375, $y + 4, 18, 18, BitOR($BS_PUSHLIKE, $BS_DEFPUSHBUTTON))
	GUICtrlSetBkColor(-1, $COLOR_ERROR)
	;_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRedLight)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)         ; comment this line out to edit GUI
	GUICtrlSetOnEvent(-1, "ResetLabUpgradeTime")
	
	; Priority 1
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Priority_1", "Priority 1:"), $x + 80, $y + 40, 60, -1)
	$g_ahCmbLabPriority[0] = GUICtrlCreateCombo("", $x + 135, $y + 37, 185, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Select_the_primary_troop_type_to_upgrade", "Select the primary troop type to upgrade"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbLabPriority")
	$g_ahPicLabPriority[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y + 32, 32, 32)
	
	; Priority 2
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Priority_2", "Priority 2:"), $x + 80, $y + 80, 60, -1)
	$g_ahCmbLabPriority[1] = GUICtrlCreateCombo("", $x + 135, $y + 77, 185, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Select_the_secondary_troop_type_to_upgrade", "Select the secondary troop type to upgrade"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbLabPriority")
	$g_ahPicLabPriority[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y + 72, 32, 32)
	
	; Priority 3
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Priority_3", "Priority 3:"), $x + 80, $y + 120, 60, -1)
	$g_ahCmbLabPriority[2] = GUICtrlCreateCombo("", $x + 135, $y + 117, 185, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Select_the_tertiary_troop_type_to_upgrade", "Select the tertiary troop type to upgrade"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbLabPriority")
	$g_ahPicLabPriority[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y + 112, 32, 32)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 210
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "Group_02", "Star Laboratory"), $x - 20, $y - 40, $g_iSizeWGrpTab3 - 5, 185)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnStarLaboratory, $x, $y, 64, 64)
	$g_hChkAutoStarLabUpgrades = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoStarLabUpgrades", "Auto Star Laboratory Upgrades"), $x + 80, $y - 15, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "ChkAutoStarLabUpgrades_Info_01", "Check box to enable automatically starting Upgrades in star laboratory"))
	GUICtrlSetOnEvent(-1, "chkStarLab")
	
	; Star Lab Priority 1
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Priority_1", "Priority 1:"), $x + 80, $y + 20, 60, -1)
	$g_ahCmbStarLabPriority[0] = GUICtrlCreateCombo("", $x + 135, $y + 17, 185, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtSLNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Select_the_primary_troop_type_to_upgrade_in_Star_Laboratory", "Select the primary troop type to upgrade in Star Laboratory"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbStarLabPriority")
	$g_ahPicStarLabPriority[0] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y + 8, 32, 32)
	
	; Star Lab Priority 2
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Priority_2", "Priority 2:"), $x + 80, $y + 60, 60, -1)
	$g_ahCmbStarLabPriority[1] = GUICtrlCreateCombo("", $x + 135, $y + 57, 185, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtSLNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Select_the_secondary_troop_type_to_upgrade_in_Star_Laboratory", "Select the secondary troop type to upgrade in Star Laboratory"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbStarLabPriority")
	$g_ahPicStarLabPriority[1] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y + 48, 32, 32)
	
	; Star Lab Priority 3
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Priority_3", "Priority 3:"), $x + 80, $y + 100, 60, -1)
	$g_ahCmbStarLabPriority[2] = GUICtrlCreateCombo("", $x + 135, $y + 97, 185, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL))
	GUICtrlSetData(-1, $sTxtSLNames, GetTranslatedFileIni("MBR Global GUI Design", "Any", "Any"))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Select_the_tertiary_troop_type_to_upgrade_in_Star_Laboratory", "Select the tertiary troop type to upgrade in Star Laboratory"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbStarLabPriority")
	$g_ahPicStarLabPriority[2] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 330, $y + 88, 32, 32)
	; Red button, will show on upgrade in progress. Temp unhide here and in Func ChkLab() if GUI needs editing.
	$g_hBtnResetStarLabUpgradeTime = GUICtrlCreateButton("", $x + 375, $y - 15, 18, 18, BitOR($BS_PUSHLIKE, $BS_DEFPUSHBUTTON))
	GUICtrlSetBkColor(-1, $COLOR_ERROR)
	;_GUICtrlSetImage(-1, $g_sLibIconPath, $eIcnRedLight)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)         ; comment this line out to edit GUI
	GUICtrlSetOnEvent(-1, "ResetStarLabUpgradeTime")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateLaboratorySubTab

Func CreateHeroesSubTab()
	Local $sTxtTip = ""
	Local $x = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "Group_01", "Upgrade Heroes"), $x - 10, $y - 20, $g_iSizeWGrpTab3 - 4, $g_iSizeHGrpTab3)
	$g_hBtnUpgradeHeroesAll = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_All", "All"), $g_iSizeWGrpTab3 - 88, $y - 12, 38, 22)
	GUICtrlSetOnEvent(-1, "UpgradeHeroesSelectAll")
	$g_hBtnUpgradeHeroesReset = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Reset", "Reset"), $g_iSizeWGrpTab3 - 50, $y - 12, 48, 22)
	GUICtrlSetOnEvent(-1, "UpgradeHeroesResetAll")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "LblAutoUpgrading_01", "Auto Upgrade Heroes"), $x, $y, -1, -1)

	$y += 20
	$g_hChkUpgradeKing = GUICtrlCreateCheckbox("", $x, $y + 23, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeKing_Info_01", "Enable upgrading of your King when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeKing_Info_02", "You can manually locate your Hero Hall on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", "Verify your Resume Bot Dark Elixir value at Misc Tab vs Saving Min. Dark Elixir here!") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeKing_Info_04", "Enabled with TownHall 7 and higher")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeKing")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnKingUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkKingSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnKingUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x += 70
	$g_hChkUpgradeQueen = GUICtrlCreateCheckbox("", $x, $y + 23, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeQueen_Info_01", "Enable upgrading of your Queen when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeQueen_Info_02", "You can manually locate your Hero Hall on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeQueen_Info_03", "Enabled with TownHall 8 and higher")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeQueen")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueenUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkQueenSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnQueenUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x += 70
	$g_hChkUpgradePrince = GUICtrlCreateCheckbox("", $x, $y + 23, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradePrince_Info_01", "Enable upgrading of your Prince when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradePrince_Info_02", "You can manually locate your Hero Hall on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradePrince_Info_03", "Enabled with TownHall 9 and higher")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePrince")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPrinceUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkPrinceSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingPrince, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x += 70
	$g_hChkUpgradeWarden = GUICtrlCreateCheckbox("", $x, $y + 23, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeWarden_Info_01", "Enable upgrading of your Warden when you have enough Elixir (Saving Min. Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeWarden_Info_02", "You can manually locate your Hero Hall on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeWarden_Info_03", "Enabled with TownHall 11")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeWarden")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkWardenSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnWardenUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x += 70
	$g_hChkUpgradeChampion = GUICtrlCreateCheckbox("", $x, $y + 23, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeChampion_Info_01", "Enable upgrading of your Royal Champion when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeChampion_Info_02", "You can manually locate your Hero Hall on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeChampion_Info_03", "Enabled with TownHall 13 and higher")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeChampion")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnChampionUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkChampionSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingChampion, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x += 70
	$g_hChkUpgradeDuke = GUICtrlCreateCheckbox("", $x, $y + 23, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeDuke_Info_01", "Enable upgrading of your Dragon Duke when you have enough Dark Elixir (Saving Min. Dark Elixir)") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeDuke_Info_02", "You can manually locate your Hero Hall on Misc Tab") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeHeroes_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeDuke_Info_03", "Enabled with TownHall 15 and higher")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradeDuke")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDukeUpgr, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChkDukeSleepWait = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSleepingDuke, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)

	$x = 15
	$y += 55
	$g_hChkUpgradeHero7 = GUICtrlCreateCheckbox("", $x, $y + 23, 17, 17)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Future_Hero", "Future Hero"))
	$g_hPicUpgradeHero7 = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHeroes, $x + 18, $y + 7, 40, 40)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Future_Hero", "Future Hero"))

	$y += 45
	$x = 15
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilderHut, $x, $y + 10, 24, 24)
	$g_hLblHeroReservedBuilderTop = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "LblHeroReservedBuilderTop", "Reserve "), $x + 29, $y + 15, -1, -1)
	$g_hCmbHeroReservedBuilder = GUICtrlCreateCombo("", $x + 79, $y + 11, 30, 21, $CBS_DROPDOWNLIST, $WS_EX_RIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "CmbHeroReservedBuilder", "At least this many builders have to upgrade heroes, or wait for it."))
	GUICtrlSetData(-1, "|0|1|2|3|4|5|6", "0")
	GUICtrlSetOnEvent(-1, "cmbHeroReservedBuilder")
	$g_hLblHeroReservedBuilderBottom = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "LblHeroReservedBuilderBottom", "builder/s for hero upgrade"), $x + 124, $y + 15, -1, -1)
	$g_hBtnHeroEquipment = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Hero_Equipment", "Hero Equipment"), $g_iSizeWGrpTab3 - 102, $y + 11, 100, 22)
	GUICtrlSetOnEvent(-1, "BtnHeroEquipment")

	; Pets
	Local $x = 15, $y = 200
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Pets", "LblAutoUpgrading_02", "Auto Upgrade Pets"), $x, $y, -1, -1)

	$y += 15
	$g_hChkUpgradePets[$ePetLassi] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeLassi_Info_01", "Enable upgrading of your Pet, Lassi, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetLassi, $x + 23, $y + 5, 48, 48)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetElectroOwl] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeElectroOwl_Info_01", "Enable upgrading of your Pet, Electro Owl, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetElectroOwl, $x + 23, $y + 5, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetMightyYak] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeMightyYak_Info_01", "Enable upgrading of your Pet, Mighty Yak, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetMightyYak, $x + 23, $y - 1, 60, 60)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetUnicorn] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeUnicorn_Info_01", "Enable upgrading of your Pet, Unicorn, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetUnicorn, $x + 18, $y - 4, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetFrosty] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeFrosty_Info_01", "Enable upgrading of your Pet, Frosty, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetFrosty, $x + 15, $y - 3, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = 15
	$y += 55
	$g_hChkUpgradePets[$ePetDiggy] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeDiggy_Info_01", "Enable upgrading of your Pet, Diggy, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetDiggy, $x + 18, $y + 2, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetPoisonLizard] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradePoisonLizard_Info_01", "Enable upgrading of your Pet, Poison Lizard, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetPoisonLizard, $x + 18, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetPhoenix] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradePhoenix_Info_01", "Enable upgrading of your Pet, Phoenix, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetPhoenix, $x + 13, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetSpiritFox] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeSpiritFox_Info_01", "Enable upgrading of your Pet, Spirit Fox, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnSpiritFox, $x + 8, $y, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetAngryJelly] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeAngryJelly_Info_01", "Enable upgrading of your Pet, Angry Jelly, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	GUICtrlSetColor(-1, $COLOR_ERROR)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnAngryJelly, $x + 18, $y + 6, 55, 55)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x = 15
	$y += 55
	$g_hChkUpgradePets[$ePetSneezy] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeSneezy_Info_01", "Enable upgrading of your Pet, Sneezy, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetSneezy, $x + 18, $y + 2, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 85
	$g_hChkUpgradePets[$ePetGreedyRaven] = GUICtrlCreateCheckbox("", $x, $y + 25, 17, 17)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Heroes", "ChkUpgradeGreedyRaven_Info_01", "Enable upgrading of your Pet, Greedy Raven, when you have enough Dark Elixir")
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetOnEvent(-1, "chkUpgradePets")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetGreedyRaven, $x + 18, $y + 2, 64, 64)
	_GUICtrlSetTip(-1, $sTxtTip)

	;--------------------------------------------------
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateHeroesSubTab

Func CreateHeroEquipment()
	Local $x = 25, $y = 5
	$g_hGUI_HeroEquipment = _GUICreate("Hero Equipment", $_GUI_MAIN_WIDTH + 50, $_GUI_MAIN_HEIGHT - 247, $g_iFrmBotPosX - 25, $g_iFrmBotPosY + 40, $WS_DLGFRAME, -1, $g_hFrmBot)

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlacksmith, $x + 15, $y + 30, 48, 48)
	$g_hChkCustomEquipmentOrderEnable = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentEnable", "Auto Equipment Upgrades"), $x + 75, $y + 30, -1, -1)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentEnable_Info_01", "Enable to select a custom equipment upgrade order"))
	GUICtrlSetOnEvent(-1, "chkEquipmentOrder")

	$g_hChkFinishCurrentEquipmentFirst = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkFinishCurrentEquipmentFirst", "Finish Current Equipment First"), $x + 75, $y + 60, -1, -1)
	GUICtrlSetState(-1, $GUI_CHECKED)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkFinishCurrentEquipmentFirst_Info_01", "Finish current equipment first before trying to upgrade next one.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkFinishCurrentEquipmentFirst_Info_02", "Note : Bot will try to upgrade next when :") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkFinishCurrentEquipmentFirst_Info_03", "- Current equipment will be maxed.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkFinishCurrentEquipmentFirst_Info_04", "- TH/Blacksmith upgrade will be required to upgrade current equipment."))

	Local $sComboData = ""
	For $t = 0 To UBound($g_asEquipmentOrderList) - 1
		$sComboData &= $g_asEquipmentOrderList[$t][0] & "|"
	Next

	Local $txtEquipmentOrder = GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "TxtEquipmentOrder", "Select Equipment To Upgrade In Position ")

	; Create ComboBox(es) for selection of troop training order
	$x += 40
	$y = 110

	For $z = 0 To UBound($g_ahCmbEquipmentOrder) - 1
		If $z < 5 Then
			$g_EquipmentOrderLabel[$z] = GUICtrlCreateLabel($z + 1 & ":", $x - 36, $y + 3, -1, 25)
			$g_hChkCustomEquipmentOrder[$z] = GUICtrlCreateCheckbox("", $x - 20, $y - 2, -1, 25)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentOrder_Info_01", "Enable or disable a custom equipment upgrade"))
			$g_ahCmbEquipmentOrder[$z] = GUICtrlCreateCombo("", $x, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIRoyalEquipmentOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtEquipmentOrder & $z + 1)
			$g_ahImgEquipmentOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 123, $y - 2, 24, 24)
			$g_ahImgEquipmentOrder2[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 155, $y - 2, 24, 24)
			$y += 40 ; move down to next combobox location
		ElseIf $z = 5 Then
			If $z = 5 Then
				$x += 250
				$y = 110
			EndIf
			$g_EquipmentOrderLabel[$z] = GUICtrlCreateLabel($z + 1 & ":", $x - 36, $y + 3, -1, 25)
			$g_hChkCustomEquipmentOrder[$z] = GUICtrlCreateCheckbox("", $x - 20, $y - 2, -1, 25)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentOrder_Info_01", "Enable or disable a custom equipment upgrade"))
			$g_ahCmbEquipmentOrder[$z] = GUICtrlCreateCombo("", $x, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIRoyalEquipmentOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtEquipmentOrder & $z + 1)
			$g_ahImgEquipmentOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 123, $y - 2, 24, 24)
			$g_ahImgEquipmentOrder2[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 155, $y - 2, 24, 24)
			$y += 40 ; move down to next combobox location
		ElseIf $z > 5 And $z < 10 Then
			If $z = 5 Then
				$x += 250
			EndIf
			$g_EquipmentOrderLabel[$z] = GUICtrlCreateLabel($z + 1 & ":", $x - 40, $y + 3, -1, 25)
			$g_hChkCustomEquipmentOrder[$z] = GUICtrlCreateCheckbox("", $x - 20, $y - 2, -1, 25)
			GUICtrlSetState(-1, $GUI_UNCHECKED)
			_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "ChkCustomEquipmentOrder_Info_01", "Enable or disable a custom equipment upgrade"))
			$g_ahCmbEquipmentOrder[$z] = GUICtrlCreateCombo("", $x, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetOnEvent(-1, "GUIRoyalEquipmentOrder")
			GUICtrlSetData(-1, $sComboData, "")
			_GUICtrlSetTip(-1, $txtEquipmentOrder & $z + 1)
			$g_ahImgEquipmentOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 123, $y - 2, 24, 24)
			$g_ahImgEquipmentOrder2[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 155, $y - 2, 24, 24)
			$y += 40 ; move down to next combobox location
		Else
			$g_hChkCustomEquipmentOrder[$z] = GUICtrlCreateCheckbox("", $x - 20, $y - 2, -1, 25)
			GUICtrlSetState(-1, $GUI_UNCHECKED + $GUI_HIDE)
			$g_ahCmbEquipmentOrder[$z] = GUICtrlCreateCombo("", $x, $y, 120, 25, BitOR($CBS_DROPDOWNLIST + $WS_VSCROLL, $CBS_AUTOHSCROLL))
			GUICtrlSetData(-1, $sComboData, "")
			GUICtrlSetState(-1, $GUI_HIDE)
			$g_ahImgEquipmentOrder[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 123, $y - 2, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
			$g_ahImgEquipmentOrder2[$z] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnOptions, $x + 155, $y - 2, 24, 24)
			GUICtrlSetState(-1, $GUI_HIDE)
		EndIf
	Next

	$x = 125
	$y = 330
	$g_hBtnRemoveEquipment = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnRemoveEquipment", "Empty Equipment List"), $x - 6, $y, 130, 20)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnRemoveEquipment_Info_01", "Push button to remove all equipment from list and start over"))
	GUICtrlSetOnEvent(-1, "btnRemoveEquipment")

	$x += 165
	$g_hBtnEquipmentOrderSet = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnEquipmentOrderSet", "Apply New Order"), $x - 6, $y, 96, 20)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnEquipmentOrderSet_Info_01", "Push button when finished selecting custom equipment upgrading order") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnEquipmentOrderSet_Info_02", "Icon changes color based on status: Red= Not Set, Green = Order Set") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Equipment", "BtnEquipmentOrderSet_Info_03", "When not all equipment slots are filled, will use random equipment order in empty slots!"))
	GUICtrlSetOnEvent(-1, "btnEquipmentOrderSet")
	$g_ahImgEquipmentOrderSet = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnSilverStar, $x + 119, $y, 18, 18)

	$y = 370
	$g_hBtnHeroEquipmentClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Close", "Close"), 410, $y, 85, 25)
	GUICtrlSetOnEvent(-1, "CloseHeroEquipment")
EndFunc   ;==>CreateHeroEquipment

Func CreateBuildingsSubTab()
	Local $sTxtShowType = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowType", "This shows type of upgrade, click to show location")
	Local $sTxtStatus = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtStatus", "Status: Red=not programmed, Yellow=programmed, not completed, Green=Completed")
	Local $sTxtShowName = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowName", "This box is updated with unit name after upgrades are checked")
	Local $sTxtShowLevel = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowLevel", "This unit box is updated with unit level after upgrades are checked")
	Local $sTxtShowCost = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowCost", "This upgrade cost box is updated after upgrades are checked")
	Local $sTxtShowTime = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowTime", "This box is updated with time length of upgrade after upgrades are checked")
	Local $sTxtChkRepeat = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtChkRepeat", "Check box to Enable Upgrade to repeat continuously")
	Local $sTxtShowEndTime = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtShowEndTime", "This box is updated with estimate end time of upgrade after upgrades are checked")
	Local $sTxtCheckBox = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtCheckBox", "Check box to Enable Upgrade")
	Local $sTxtAfterUsing = GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtAfterUsing", "after using Locate Upgrades button")

	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Group_01", "Buildings or Heroes"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 30 + ($g_iUpgradeSlots * 22))
	$x -= 7
	; table header
	$y -= 7
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_01", "Unit Name"), $x + 71, $y, 70, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_02", "Lvl"), $x + 153, $y, 40, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_03", "Type"), $x + 173, $y, 50, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_04", "Cost"), $x + 219, $y, 50, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_05", "Time"), $x + 270, $y, 50, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_06", "Rep."), $x + 392, $y, 50, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "Table header_07", "Estimated End"), $x + 315, $y, 75, 18)
	$y += 13

	; Create upgrade GUI slots 0 to $g_iUpgradeSlots
	; Can add more slots with $g_iUpgradeSlots value in Global variables file, 6 is minimum and max limit is 15 before GUI is too long.
	For $i = 0 To $g_iUpgradeSlots - 1
		$g_hPicUpgradeStatus[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedLight, $x - 10, $y + 1, 14, 14)
		_GUICtrlSetTip(-1, $sTxtStatus)
		$g_hChkUpgrade[$i] = GUICtrlCreateCheckbox($i + 1 & ":", $x + 5, $y + 1, 34, 15)
		_GUICtrlSetTip(-1, $sTxtCheckBox & " #" & $i + 1 & " " & $sTxtAfterUsing)
		;			GUICtrlSetFont(-1, 8)
		GUICtrlSetOnEvent(-1, "btnchkbxUpgrade")
		$g_hTxtUpgradeName[$i] = GUICtrlCreateInput("", $x + 40, $y, 107, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtShowName)
		$g_hTxtUpgradeLevel[$i] = GUICtrlCreateInput("", $x + 150, $y, 23, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtShowLevel)
		$g_hPicUpgradeType[$i] = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlank, $x + 178, $y + 1, 15, 15)
		_GUICtrlSetTip(-1, $sTxtShowType)
		GUICtrlSetOnEvent(-1, "picUpgradeTypeLocation")
		$g_hTxtUpgradeValue[$i] = GUICtrlCreateInput("", $x + 197, $y, 65, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtShowCost)
		;HArchH was 35 wide.
		$g_hTxtUpgradeTime[$i] = GUICtrlCreateInput("", $x + 266, $y, 45, 17, BitOR($ES_CENTER, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtShowTime)
		;HArchH was 305 start and 85 wide
		$g_hTxtUpgradeEndTime[$i] = GUICtrlCreateInput("", $x + 315, $y, 75, 17, BitOR($ES_LEFT, $GUI_SS_DEFAULT_INPUT, $ES_READONLY, $ES_NUMBER))
		GUICtrlSetFont(-1, 7)
		_GUICtrlSetTip(-1, $sTxtShowEndTime)
		$g_hChkUpgradeRepeat[$i] = GUICtrlCreateCheckbox("", $x + 395, $y + 1, 15, 15)
		;			GUICtrlSetFont(-1, 8)
		_GUICtrlSetTip(-1, $sTxtChkRepeat)
		GUICtrlSetOnEvent(-1, "btnchkbxRepeat")

		$y += 22
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$x += 5
	$y += 8
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x - 15, $y, 15, 15)
	GUICtrlCreateLabel( GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "LblUpgrMinGold", "Min. Gold") & ":", $x + 5, $y + 3, -1, -1)
	$g_hTxtUpgrMinGold = GUICtrlCreateInput("150000", $x + 55, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinGold_Info_01", "Save this much Gold after the upgrade completes.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinGold_Info_02", "Set this value as needed to save for searching, or wall upgrades."))
	GUICtrlSetLimit(-1, 8)
	$y += 18
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x - 15, $y, 15, 15)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "LblUpgrMinElixir", "Min. Elixir") & ":", $x + 5, $y + 3, -1, -1)
	$g_hTxtUpgrMinElixir = GUICtrlCreateInput("1000", $x + 55, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinElixir_Info_01", "Save this much Elixir after the upgrade completes") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinElixir_Info_02", "Set this value as needed to save for making troops or wall upgrades."))
	GUICtrlSetLimit(-1, 8)
	$x -= 15
	$y -= 8
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 140, $y, 15, 15)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "LblUpgrMinDark", "Min. Dark") & ":", $x + 160, $y + 3, -1, -1)
	$g_hTxtUpgrMinDark = GUICtrlCreateInput("1000", $x + 210, $y, 61, 17, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinDark_Info_01", "Save this amount of Dark Elixir after the upgrade completes.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "TxtUpgrMinDark_Info_02", "Set this value higher if you want make war troops."))
	GUICtrlSetLimit(-1, 6)
	$y -= 8

	; Locate/reset buttons
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnLocateUpgradesShort", "Locate"), $x + 282, $y - 4, 67, 18, BitOR($BS_MULTILINE, $BS_VCENTER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnLocateUpgrades_Info_01", "Push button to locate and record information on building/Hero upgrades") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnLocateUpgrades_Info_02", "Any upgrades with repeat enabled are skipped and can not be located again"))
	GUICtrlSetOnEvent(-1, "btnLocateUpgrades")
	GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnResetUpgradesShort", "Reset"), $x + 351, $y - 4, 67, 18, BitOR($BS_MULTILINE, $BS_VCENTER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnResetUpgrades_Info_01", "Push button to reset & remove upgrade information") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "BtnResetUpgrades_Info_02", "If repeat box is checked, data will not be reset"))
	GUICtrlSetOnEvent(-1, "btnResetUpgrade")

	; Building reserve
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilderHut, $x + 302, $y + 14, 20, 20)
	$g_hLblBuildingReservedBuilderTop = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "LblBuildingReservedBuilderTop", "Reserve"), $x + 326, $y + 18, 42, 17)
	$g_hCmbBuildingReservedBuilder = GUICtrlCreateCombo("", $x + 372, $y + 14, 30, 21, $CBS_DROPDOWNLIST, $WS_EX_RIGHT)
	GUICtrlSetData(-1, "|0|1|2|3|4|5|6", "0")
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Buildings", "CmbBuildingReservedBuilder", "Reserve builders for configured building upgrades."))
	GUICtrlSetOnEvent(-1, "cmbBuildingReservedBuilder")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

EndFunc   ;==>CreateBuildingsSubTab

Func CreateWallsSubTab()
	Local $x = 25, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "Group_01", "Walls"), $x - 20, $y - 20, $g_iSizeWGrpTab3, 193)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnWall, $x - 12, $y - 2, 20, 20)
	$g_hChkWalls = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkWalls", "Auto Wall Upgrade"), $x + 18, $y - 2, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkWalls_Info_01", "Check this to upgrade Walls if there are enough resources."))
	GUICtrlSetState(-1, $GUI_ENABLE)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkWalls")
	#CS		$sldMaxNbWall = GUICtrlCreateSlider( $x + 135, $y, 85 , 24, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
				_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkWalls_Info_02", "No. of Positions to test and find walls. Higher is better but slower."))
				_GUICtrlSlider_SetTipSide(-1, $TBTS_BOTTOM)
				_GUICtrlSlider_SetTicFreq(-1, 1)
				GUICtrlSetLimit(-1, 8, 1)
				GUICtrlSetData(-1, 4)
				GUICtrlSetBkColor(-1, $COLOR_WHITE)
	#CE		$sldMaxNbWall = GUICtrlCreateSlider( $x + 135, $y, 85 , 24, BITOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	$g_hBtnFindWalls = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "BtnFindWalls", "TEST"), $x - 20 + $g_iSizeWGrpTab3 - 62, $y - 20 + 193 - 28, 56, 21)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "BtnFindWalls_Info_01", "Click here to test the Wall Detection."))
	GUICtrlSetOnEvent(-1, "btnWalls")
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x5CAD85)
	$g_hRdoUseGold = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseGold", "Use Gold"), $x + 25, $y + 16, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseGold_Info_01", "Use only Gold for Walls.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseGold_Info_02", "Available at all Wall levels."))
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hRdoUseElixir = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixir", "Use Elixir"), $x + 25, $y + 34, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixir_Info_01", "Use only Elixir for Walls.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixir_Info_02", "Available only at Wall levels upgradeable with Elixir."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hRdoUseElixirGold = GUICtrlCreateRadio(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixirGold", "Use Elixir > Gold"), $x + 25, $y + 52, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixirGold_Info_01", "Try to use Elixir first. If not enough Elixir try to use Gold second for Walls.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "RdoUseElixir_Info_02", -1))
	GUICtrlSetState(-1, $GUI_DISABLE)
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnHammerJam, $x - 14, $y + 78, 24, 24)
	$g_hChkWallHammerJam = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkHammerJam", "Hammer Jam"), $x + 18, $y + 80, -1, -1)
	_GUICtrlSetTip(-1, "Reduce Wall Gold and Elixir costs by 50% during Hammer Jam.")
	GUICtrlSetOnEvent(-1, "chkWallHammerJam")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnXbow, $x - 14, $y + 106, 24, 24)
	$g_hChkWallGoldPass = GUICtrlCreateCheckbox("Gold Pass", $x + 18, $y + 108, 85, 21)
	GUICtrlSetOnEvent(-1, "chkWallGoldPass")
	$g_hCmbWallGoldPass = GUICtrlCreateCombo("", $x + 115, $y + 108, 61, 21, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "10%|15%|20%", "10%")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbWallGoldPass")
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilderHut, $x - 14, $y + 134, 24, 24)
	$g_hChkSaveWallBldr = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkSaveWallBldr", "Reserve Builder"), $x + 18, $y + 136, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkSaveWallBldr_Info_01", "Check this to reserve 1 builder exclusively for walls and") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "ChkSaveWallBldr_Info_02", "reduce the available builder by 1 for other upgrades"))
	GUICtrlSetState(-1, $GUI_ENABLE)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	GUICtrlSetOnEvent(-1, "chkSaveWallBldr")

	$x += 225
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblSearchforWalls", "Walls Level") & ":", $x, $y + 2, -1, -1)
	$g_hCmbWalls = GUICtrlCreateCombo("", $x + 110, $y, 61, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL), $WS_EX_RIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "CmbWalls_Info_01", "Search for Walls of this level and try to upgrade them one by one."))
	GUICtrlSetData(-1, "4   |5   |6   |7   |8   |9   |10   |11   |12   |13   |14   |15   |16   |17   |18   ", "4   ")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbWalls")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblNextWalllevelcosts", "Next Wall Level Cost") & ":", $x, $y + 25, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblNextWalllevelcosts_Info_01", "Use this value as an indicator.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblNextWalllevelcosts_Info_02", "The value will update if you select an other wall level."))
	$g_hLblWallCost = GUICtrlCreateLabel("30 000", $x + 110, $y + 25, 60, -1, $SS_RIGHT)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblWallStorageLimit", "Storage Limit") & ":", $x, $y + 47, -1, -1)
	$g_hCmbUpgradeWallStorageLimit = GUICtrlCreateCombo("", $x + 110, $y + 45, 61, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL), $WS_EX_RIGHT)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "CmbWallStorageLimit_Info_01", "Only start wall upgrades when the selected resource storage is above this percentage."))
	GUICtrlSetData(-1, "0%|50%|75%", "50%")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "cmbUpgradeWallStorageLimit")

	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x, $y + 70, 16, 16)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Goldtosave", "Gold Reserve"), $x + 20, $y + 70, -1, -1)
	$g_hTxtWallMinGold = GUICtrlCreateInput("150000", $x + 110, $y + 68, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Goldtosave_Info_01", "Save this much Gold after the wall upgrade completes,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Goldtosave_Info_02", "Set this value to save Gold for other upgrades, or searching."))
	GUICtrlSetLimit(-1, 8)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$y += 2
	_GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x, $y + 90, 16, 16)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Elixirtosave", "Elixir Reserve"), $x + 20, $y + 93, -1, -1)
	$g_hTxtWallMinElixir = GUICtrlCreateInput("1000", $x + 110, $y + 88, 61, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Elixirtosave_Info_01", "Save this much Elixir after the wall upgrade completes,") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "LblMin.Elixirtosave_Info_02", "Set this value to save Elixir for other upgrades or troop making."))
	GUICtrlSetLimit(-1, 8)
	GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
 
 	Local $x = 25, $y = 243
	Local $iWallCounterGroupX = $x - 20, $iWallCounterGroupY = $y - 20, $iWallCounterGroupW = $g_iSizeWGrpTab3, $iWallCounterGroupH = 135 + 40
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "Group_02", "Walls Counter"), $iWallCounterGroupX, $iWallCounterGroupY, $iWallCounterGroupW, $iWallCounterGroupH)
 	$g_ahWallsCurrentCount[4] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
 	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", "Input number of Walls level") & " 4 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", "you have."))
 	$g_ahPicWallsLevel[4] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall04, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[5] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 5 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[5] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall05, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[6] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 6 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[6] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall06, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[7] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 7 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[7] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall07, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[8] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 8 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[8] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall08, $x + 27, $y - 2, 24, 24)
	Local $x = 25
	$y += 40
	$g_ahWallsCurrentCount[9] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 9 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[9] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall09, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[10] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 10 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[10] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall10, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[11] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 11 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[11] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall11, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[12] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 12 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[12] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall12, $x + 28, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[13] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 13 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[13] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall13, $x + 27, $y - 2, 24, 24)
	Local $x = 25
	$y += 40
	$g_ahWallsCurrentCount[14] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 14 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[14] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall14, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[15] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 15 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[15] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall15, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[16] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 16 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[16] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall16, $x + 27, $y - 2, 24, 24)
	$x += 80
	$g_ahWallsCurrentCount[17] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 17 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[17] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall17, $x + 26, $y - 5, 28, 28)
	$x += 80
	$g_ahWallsCurrentCount[18] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 18 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[18] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall18, $x + 28, $y - 2, 22, 22)
	Local $x = 25
	$y += 40
 	$g_ahWallsCurrentCount[19] = GUICtrlCreateInput("0", $x, $y, 25, 19, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER))
 	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_01", -1) & " 19 " & GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "WallsCurrentCount_Info_02", -1))
	$g_ahPicWallsLevel[19] = _GUICtrlCreateIcon($g_sLibIconPath, $eWall19, $x + 26, $y - 5, 24, 24)
	$g_hBtnResetWallCounter = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "BtnResetWallCounter", "RESET"), $iWallCounterGroupX + $iWallCounterGroupW - 62, $iWallCounterGroupY + $iWallCounterGroupH - 28, 56, 21)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Walls", "BtnResetWallCounter_Info_01", "Reset all Wall Counter values to zero."))
	GUICtrlSetOnEvent(-1, "btnResetWallCounter")
 	GUICtrlCreateGroup("", -99, -99, 1, 1)
 
EndFunc   ;==>CreateWallsSubTab

Func CreateAutoUpgradeSubTab()
	Local $x = 25, $y = 45
	Local $iBBGroupGap = 6, $iBBGroupLeft = 5
	Local $iBBGroupWidth = Int(($g_iSizeWGrpTab3 - 4 - $iBBGroupGap) / 2)
	Local $iStarLabGroupLeft = $iBBGroupLeft + $iBBGroupWidth + $iBBGroupGap
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Helper_Hut", "Helper Hut"), 5, 25, $g_iSizeWGrpTab3 - 4, 55)
	Local $hBuilderAssistantIcon = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilderApprentice, $iBBGroupLeft + 5, 44, 24, 24)
	GUICtrlSetState($hBuilderAssistantIcon, $GUI_DISABLE)
	$g_hChkAppBuilderLabel = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Builder", "Builder:"), $iBBGroupLeft + 32, 53, 49, 17)
	$g_hChkAppBuilder = GUICtrlCreateCombo("", $iBBGroupLeft + 83, 48, 112, 22, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "AssistantOptions", "Don't Use|Longest|Shortest"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "AppBuilder_Info01", "Auto-Assign Builder's Apprentice") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "AppBuilder_Info02", "Longest : Assign Builder's Apprentice To The Longest Upgrade.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Misc", "AppBuilder_Info03", "Shortest : Assign Builder's Apprentice To The Shortest Upgrade."))
	Local $hLabAssistantIcon = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLabAssistant, $iStarLabGroupLeft + 5, 44, 24, 24)
	GUICtrlSetState($hLabAssistantIcon, $GUI_DISABLE)
	$g_hChkLabAssistantLabel = GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Lab", "Lab:"), $iStarLabGroupLeft + 32, 53, 49, 17)
	$g_hChkLabAssistant = GUICtrlCreateCombo("", $iStarLabGroupLeft + 83, 48, 112, 22, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "AssistantOptions", "Don't Use|Longest|Shortest"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "LabAssist_Info01", "Auto-Assign Lab Assistant") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "LabAssist_Info02", "Longest : Assign Lab Assistant To The Longest Upgrade.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Village - Upgrade_Laboratory", "LabAssist_Info03", "Shortest : Assign Lab Assistant To The Shortest Upgrade."))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Builder_Menu", "Builder Menu"), $iBBGroupLeft, 90, $iBBGroupWidth, 150)
	$g_hChkAutoUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "ChkAutoUpgradeBuilder", "Auto Builder Upgrade"), $iBBGroupLeft + 7, 108, -1, 17)
	GUICtrlSetOnEvent(-1, "chkAutoUpgrade")
	$g_hPicAutoUpgradeResource = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $iBBGroupLeft + 8, 138, 18, 18)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Filter_Resource", "Resource"), $iBBGroupLeft + 32, 140, 49, 18)
	$g_hCmbAutoUpgradeResource = GUICtrlCreateCombo("", $iBBGroupLeft + 83, 135, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "ResourceOptions", "Default|Gold|Elixir|Dark"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent(-1, "cmbAutoUpgradeResource")
	cmbAutoUpgradeResource()

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Filter_Type", "Type"), $iBBGroupLeft + 32, 170, 49, 18)
	$g_hCmbAutoUpgradeType = GUICtrlCreateCombo("", $iBBGroupLeft + 83, 165, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "TypeOptions", "Default|Army|Defense|Hero|Resource|Permanent"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent($g_hCmbAutoUpgradeType, "cmbAutoUpgradeType")
	$g_hPicAutoUpgradeType = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnDrill, $iBBGroupLeft + 7, 167, 20, 20)
	cmbAutoUpgradeType()

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "Filter_Sorting", "Sorting"), $iBBGroupLeft + 32, 200, 49, 18)
	$g_hCmbAutoUpgradeSorting = GUICtrlCreateCombo("", $iBBGroupLeft + 83, 195, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "SortingOptions", "Default|Cost Max|Cost Min"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent($g_hCmbAutoUpgradeSorting, "cmbAutoUpgradeSorting")
	$g_hPicAutoUpgradeSorting = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $iBBGroupLeft + 8, 198, 18, 18)
	cmbAutoUpgradeSorting()
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Laboratory_Menu", "Laboratory Menu"), $iStarLabGroupLeft, 90, $iBBGroupWidth, 150)
	$g_hChkAutoLabUpgrade = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "ChkAutoUpgradeLaboratory", "Auto Laboratory Upgrade"), $iStarLabGroupLeft + 7, 108, -1, 17)
	GUICtrlSetOnEvent(-1, "chkAutoLabUpgrade")
	$g_hPicAutoLabUpgradeResource = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $iStarLabGroupLeft + 7, 137, 20, 20)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Resource", "Resource"), $iStarLabGroupLeft + 32, 140, 49, 18)
	$g_hCmbAutoLabUpgradeResource = GUICtrlCreateCombo("", $iStarLabGroupLeft + 83, 135, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "LabResourceOptions", "Default|Elixir|Dark"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent(-1, "cmbAutoLabUpgradeResource")
	cmbAutoLabUpgradeResource()

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Type", "Type"), $iStarLabGroupLeft + 32, 170, 49, 18)
	$g_hCmbAutoLabUpgradeType = GUICtrlCreateCombo("", $iStarLabGroupLeft + 83, 165, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "LabTypeOptions", "Default|Troops|Spells|Sieges"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	$g_hPicAutoLabUpgradeType = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBarbarian, $iStarLabGroupLeft + 7, 167, 20, 20)
	GUICtrlSetState($g_hPicAutoLabUpgradeType, $GUI_HIDE)
	GUICtrlSetOnEvent($g_hCmbAutoLabUpgradeType, "cmbAutoLabUpgradeType")

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Sorting", "Sorting"), $iStarLabGroupLeft + 32, 200, 49, 18)
	$g_hCmbAutoLabUpgradeSorting = GUICtrlCreateCombo("", $iStarLabGroupLeft + 83, 195, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "SortingOptions", "Default|Cost Max|Cost Min"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent($g_hCmbAutoLabUpgradeSorting, "cmbAutoLabUpgradeSorting")
	$g_hPicAutoLabUpgradeSorting = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $iStarLabGroupLeft + 8, 198, 18, 18)
	cmbAutoLabUpgradeSorting()
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Master_Builder_Menu", "Master Builder Menu"), $iBBGroupLeft, 250, $iBBGroupWidth, 155)
	$g_hChkAutoUpgradeBB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "ChkAutoUpgradeMasterBuilder", "Auto Master Builder"), $iBBGroupLeft + 7, 269, -1, 17)
	GUICtrlSetOnEvent(-1, "chkAutoUpgradeBB")
	$g_hPicAutoUpgradeBBResource = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBGold, $iBBGroupLeft + 9, 298, 16, 16)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Resource", "Resource"), $iBBGroupLeft + 32, 299, 49, 18)
	$g_hCmbAutoUpgradeBBResource = GUICtrlCreateCombo("", $iBBGroupLeft + 83, 294, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "BBResourceOptions", "Default|Gold|Elixir"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent(-1, "cmbAutoUpgradeBBResource")
	cmbAutoUpgradeBBResource()
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Type", "Type"), $iBBGroupLeft + 32, 329, 49, 18)
	$g_hCmbAutoUpgradeBBType = GUICtrlCreateCombo("", $iBBGroupLeft + 83, 324, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "TypeOptions", "Default|Army|Defense|Hero|Resource|Permanent"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent($g_hCmbAutoUpgradeBBType, "cmbAutoUpgradeBBType")
	$g_hPicAutoUpgradeBBType = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGemMine, $iBBGroupLeft + 7, 326, 20, 20)
	cmbAutoUpgradeBBType()
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Sorting", "Sorting"), $iBBGroupLeft + 32, 359, 49, 18)
	$g_hCmbAutoUpgradeBBSorting = GUICtrlCreateCombo("", $iBBGroupLeft + 83, 354, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "SortingOptions", "Default|Cost Max|Cost Min"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent($g_hCmbAutoUpgradeBBSorting, "cmbAutoUpgradeBBSorting")
	$g_hPicAutoUpgradeBBSorting = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $iBBGroupLeft + 8, 357, 18, 18)
	cmbAutoUpgradeBBSorting()
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("Pet Menu", $iStarLabGroupLeft, 250, $iBBGroupWidth, 68)
	$g_hChkAutoPetUpgrade = GUICtrlCreateCheckbox("Auto Pet Upgrade", $iStarLabGroupLeft + 7, 269, -1, 17)
	GUICtrlSetOnEvent(-1, "chkAutoPetUpgrade")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Star_Laboratory_Menu", "Star Laboratory Menu"), $iStarLabGroupLeft, 323, $iBBGroupWidth, 82)
	$g_hChkAutoStarUpgradeBB = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "ChkAutoUpgradeStarLaboratory", "Auto Star Laboratory"), $iStarLabGroupLeft + 7, 342, -1, 17)
	GUICtrlSetOnEvent(-1, "chkAutoStarUpgradeBB")
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child VIllage - Upgrade", "Custom_Sorting", "Sorting"), $iStarLabGroupLeft + 32, 375, 49, 18)
	$g_hCmbAutoLabUpgradeBBSorting = GUICtrlCreateCombo("", $iStarLabGroupLeft + 83, 370, 112, 24, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, GetTranslatedFileIni("MBR GUI Design - AutoUpgrade", "SortingOptions", "Default|Cost Max|Cost Min"))
	_GUICtrlComboBox_SetCurSel(-1, 0)
	GUICtrlSetOnEvent($g_hCmbAutoLabUpgradeBBSorting, "cmbAutoLabUpgradeBBSorting")
	$g_hPicAutoLabUpgradeBBSorting = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $iStarLabGroupLeft + 8, 373, 18, 18)
	cmbAutoLabUpgradeBBSorting()
	GUICtrlCreateGroup("", -99, -99, 1, 1)
EndFunc   ;==>CreateAutoUpgradeSubTab
