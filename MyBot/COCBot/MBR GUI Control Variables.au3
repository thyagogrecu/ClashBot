; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Variables
; Description ...: This file Includes several files in the current script and all Declared variables, constant, or create an array.
; Syntax ........: #include , Global
; Parameters ....: $action_groupe, $group_de_controle
; Return values .: None
; Author ........: Boju(2016)
; Modified ......: MR.ViPER (11-2016), CodeSlinger69 (2017), MMHK (01-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hTxtInitialAttackCount

Global $g_aGroupSearchDB = "", $groupHerosDB = "", $groupSearchAB = "", $groupHerosAB = "", $groupSpellsDB = "", $groupSpellsAB = "", $groupSearchTS = "", $groupSkyWagon = ""

;Attack
Global $g_aGroupAttackDB = "", $g_aGroupAttackDBSpell = "", $groupIMGAttackDB = "", $groupIMGAttackDBSpell = "", $groupAttackAB = "", $groupAttackABSpell = "", _
		$groupIMGAttackAB = "", $groupIMGAttackABSpell = "", $groupAttackTS = "", $groupAttackTSSpell = "", $groupIMGAttackTS = "", $groupIMGAttackTSSpell = ""

;End Battle
Global $g_aGroupEndBattleDB = "", $groupEndBattkeAB = "", $groupKingSleeping = "", $groupQueenSleeping = "", $groupPrinceSleeping = "", $groupWardenSleeping = "", $groupCloseWhileTraining = "", _
		$grpTrainTroops = "", $grpCookSpell = "", $groupChampionSleeping = "", $groupDukeSleeping = ""
 
;Spell
Global $groupLightning = "", $groupHeal = "", $groupRage = "", $groupJump = "", $groupFreeze = "", $groupClone = "", $groupInvisibility = "", $groupRecall = "", $groupIceBlock = "", $groupAngry = "", $groupRevive = "", $groupTotem = ""
 
;Dark Spell
Global $groupPoison = "", $groupEarthquake = "", $groupHaste = "", $groupSkeleton = "", $groupBat = "", $groupOvergrowth = ""

;All Spells
Global $groupListSpells = ""

;Sieges
Global $groupWallWrecker = "", $groupBattleBlimp = "", $groupStoneSlammer = "", $groupSiegeBarracks = "", $groupLogLauncher = "", $groupFlameFlinger = "", $groupBattleDrill = "", $groupTroopLauncher = "", $groupSkyWagon = "", $groupListSieges = ""

;TH Level
Global $g_aGroupListTHLevels = ""

;PicDBMaxTH
Global $g_aGroupListPicDBMaxTH = ""

;PicABMaxTH
Global $g_aGroupListPicABMaxTH = ""


;League
Global $g_aGroupLeague = "", $g_aGroupCCLeague = "", $g_aGroupBBLeague = ""

; Groups of controls
Global $aTabControlsVillage, $aTabControlsMisc, $aTabControlsDonate, $aTabControlsUpgrade, $aTabControlsNotify
Global $aTabControlsAttack, $aTabControlsArmy, $aTabControlsSearch, $aTabControlsDeadbase, $aTabControlsActivebase, $aTabControlsAttackOptions
Global $aTabControlsStrategies, $aTabControlsBot, $aTabControlsStats
Global $oAlwaysEnabledControls = ObjCreate("Scripting.Dictionary")

Func InitializeControlVariables()
	$g_aGroupSearchDB = $g_hGrpDBFilter & "#" & $g_hCmbDBMeetGE & "#" & $g_hTxtDBMinGold & "#" & $g_hPicDBMinGold & "#" & $g_hTxtDBMinElixir & "#" & $g_hPicDBMinElixir & "#" & _
			$g_hTxtDBMinGoldPlusElixir & "#" & $g_hPicDBMinGPEGold & "#" & $g_hChkDBMeetDE & "#" & $g_hTxtDBMinDarkElixir & "#" & $g_hPicDBMinDarkElixir & "#" & _
			$g_hChkDBMeetTH & "#" & $g_hCmbDBTH & "#" & $g_hChkDBMeetTHO & "#" & _
			$g_ahChkMeetOne[$DB] & "#" & _
			$g_ahChkMaxMortar[$DB] & "#" & $g_ahCmbWeakMortar[$DB] & "#" & $g_ahPicWeakMortar[$DB] & "#" & $g_ahChkMaxWizTower[$DB] & "#" & $g_ahCmbWeakWizTower[$DB] & "#" & _
			$g_ahPicWeakWizTower[$DB] & "#" & _
			$g_ahChkMaxXBow[$DB] & "#" & $g_ahCmbWeakXBow[$DB] & "#" & $g_ahPicWeakXBow[$DB] & "#" & $g_ahChkMaxInferno[$DB] & "#" & $g_ahCmbWeakInferno[$DB] & "#" & _
			$g_ahPicWeakInferno[$DB] & "#" & $g_ahChkMaxEagle[$DB] & "#" & $g_ahCmbWeakEagle[$DB] & "#" & $g_ahPicWeakEagle[$DB] & "#" & $g_ahChkMaxScatter[$DB] & "#" & $g_ahCmbWeakScatter[$DB] & "#" & $g_ahPicWeakScatter[$DB] & "#" & _
			$g_ahChkMaxMonolith[$DB] & "#" & $g_ahCmbWeakMonolith[$DB] & "#" & $g_ahPicWeakMonolith[$DB]
	$groupHerosDB = $g_hPicDBHeroesWait & "#" & $g_hTxtDBHeroesWait & "#" & $g_hChkDBKingWait & "#" & $g_hChkDBQueenWait & "#" & $g_hChkDBPrinceWait & "#" & $g_hChkDBWardenWait & "#" & $g_hChkDBChampionWait & "#" & $g_hPicDBKingWait & "#" & _
			$g_hPicDBQueenWait & "#" & $g_hPicDBPrinceWait & "#" & $g_hPicDBWardenWait & "#" & $g_hPicDBChampionWait

	$groupSearchAB = $g_hGrpABFilter & "#" & $g_hCmbABMeetGE & "#" & $g_hTxtABMinGold & "#" & $g_hPicABMinGold & "#" & $g_hTxtABMinElixir & "#" & $g_hPicABMinElixir & "#" & _
			$g_hTxtABMinGoldPlusElixir & "#" & $g_hPicABMinGPEGold & "#" & $g_hChkABMeetDE & "#" & $g_hTxtABMinDarkElixir & "#" & $g_hPicABMinDarkElixir & "#" & _
			$g_hChkABMeetTH & "#" & $g_hCmbABTH & "#" & $g_hChkABMeetTHO & "#" & _
			$g_ahChkMeetOne[$LB] & "#" & _
			$g_ahChkMaxMortar[$LB] & "#" & $g_ahCmbWeakMortar[$LB] & "#" & $g_ahPicWeakMortar[$LB] & "#" & $g_ahChkMaxWizTower[$LB] & "#" & $g_ahCmbWeakWizTower[$LB] & "#" & _
			$g_ahPicWeakWizTower[$LB] & "#" & $g_ahChkMaxXBow[$LB] & "#" & $g_ahCmbWeakXBow[$LB] & "#" & $g_ahPicWeakXBow[$LB] & "#" & $g_ahChkMaxInferno[$LB] & "#" & _
			$g_ahCmbWeakInferno[$LB] & "#" & $g_ahPicWeakInferno[$LB] & "#" & $g_ahChkMaxEagle[$LB] & "#" & $g_ahCmbWeakEagle[$LB] & "#" & $g_ahPicWeakEagle[$LB] & "#" & $g_ahChkMaxScatter[$LB] & "#" & _
			$g_ahCmbWeakScatter[$LB] & "#" & $g_ahPicWeakScatter[$LB] & "#" & $g_ahChkMaxMonolith[$LB] & "#" & $g_ahCmbWeakMonolith[$LB] & "#" & $g_ahPicWeakMonolith[$LB]
	$groupHerosAB = $g_hPicABHeroesWait & "#" & $g_hTxtABHeroesWait & "#" & $g_hChkABKingWait & "#" & $g_hChkABQueenWait & "#" & $g_hChkABPrinceWait & "#" & $g_hChkABWardenWait & "#" & $g_hChkABChampionWait & "#" & _
			$g_hPicABKingWait & "#" & $g_hPicABQueenWait & "#" & $g_hPicABPrinceWait & "#" & $g_hPicABWardenWait & "#" & $g_hPicABChampionWait

	$groupSpellsDB = ""
	$groupSpellsAB = ""

	;Attack
	$g_aGroupAttackDB = $g_hCmbDBAlgorithm & "#" & $g_hChkDBKingAttack & "#" & $g_hChkDBQueenAttack & "#" & $g_hChkDBPrinceAttack & "#" & $g_hChkDBWardenAttack & "#" & $g_hChkDBChampionAttack & "#" & $g_hChkDBDropCC
 	$g_aGroupAttackDBSpell = ""
	$groupIMGAttackDB = $g_hPicDBKingAttack & "#" & $g_hPicDBQueenAttack & "#" & $g_hPicDBPrinceAttack & "#" & $g_hPicDBChampionAttack & "#" & $g_hPicDBDropCC
 	$groupIMGAttackDBSpell = ""

	$groupAttackAB = $g_hCmbABAlgorithm & "#" & $g_hChkABKingAttack & "#" & $g_hChkABQueenAttack & "#" & $g_hChkABPrinceAttack & "#" & $g_hChkABWardenAttack & "#" & $g_hChkABChampionAttack & "#" & $g_hChkABDropCC
 	$groupAttackABSpell = ""
	$groupIMGAttackAB = $g_hPicABKingAttack & "#" & $g_hPicABQueenAttack & "#" & $g_hPicABPrinceAttack & "#" & $g_hPicABChampionAttack & "#" & $g_hPicABDropCC
 	$groupIMGAttackABSpell = ""

	;End Battle
	$g_aGroupEndBattleDB = ""
	$groupEndBattkeAB = ""

	$groupKingSleeping = $g_hPicDBKingSleepWait & "#" & $g_hPicABKingSleepWait & "#" & $g_hPicChkKingSleepWait
	$groupQueenSleeping = $g_hPicDBQueenSleepWait & "#" & $g_hPicABQueenSleepWait & "#" & $g_hPicChkQueenSleepWait
	$groupPrinceSleeping = $g_hPicDBPrinceSleepWait & "#" & $g_hPicABPrinceSleepWait & "#" & $g_hPicChkPrinceSleepWait
	$groupWardenSleeping = $g_hPicDBWardenSleepWait & "#" & $g_hPicABWardenSleepWait & "#" & $g_hPicChkWardenSleepWait
	$groupChampionSleeping = $g_hPicDBChampionSleepWait & "#" & $g_hPicABChampionSleepWait & "#" & $g_hPicChkChampionSleepWait
	$groupDukeSleeping = $g_hPicChkDukeSleepWait

	$groupCloseWhileTraining = $g_hLbAttackconsecutiveTitle & "#" & $g_hCmbAttackconsecutiveMin & "#" & $g_hLbAttackconsecutiveLimit & "#" & $g_hCmbAttackconsecutiveMax & "#" & $g_hChkCloseEmulator & "#" & $g_hChkSuspendComputer & "#" & $g_hPicCloseWaitTrain & "#" & $g_hPicCloseWaitStop

	$grpTrainTroops = $g_ahTxtTrainArmyTroopCount[$eTroopBarbarian] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperBarbarian] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopArcher] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopSuperArcher] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopGiant] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperGiant] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopGoblin] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSneakyGoblin] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopWallBreaker] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopSuperWallBreaker] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopBalloon] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopRocketBalloon] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopWizard] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopSuperWizard] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopHealer] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopDragon] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperDragon] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopPekka] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopBabyDragon] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopInfernoDragon] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopMiner] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperMiner] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopMinion] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperMinion] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopHogRider] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopValkyrie] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperValkyrie] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopGolem] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopWitch] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperWitch] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopLavaHound] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopIceHound] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopBowler] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopElectroDragon] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopIceGolem] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopYeti] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperYeti] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopDragonRider] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopElectroTitan] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopHeadhunter] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperBowler] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopRootRider] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopThrower] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopMeteorGolem] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopSuperHogRider] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopAppWard] & "#" & _
			$g_ahTxtTrainArmyTroopCount[$eTroopDruid] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopFurnace] & "#" & $g_ahTxtTrainArmyTroopCount[$eTroopRuinWitch]

	$grpCookSpell = $g_ahTxtTrainArmySpellCount[$eSpellLightning] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellHeal] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellRage] & "#" & _
			$g_ahTxtTrainArmySpellCount[$eSpellJump] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellFreeze] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellClone] & "#" & _
			$g_ahTxtTrainArmySpellCount[$eSpellInvisibility] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellRecall] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellRevive] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellTotem] & "#" & _
			$g_ahTxtTrainArmySpellCount[$eSpellPoison] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellEarthquake] & "#" & _
			$g_ahTxtTrainArmySpellCount[$eSpellHaste] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellSkeleton] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellBat] & "#" & _
			$g_ahTxtTrainArmySpellCount[$eSpellOvergrowth] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellIBSpell] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellAngrySpell]

	;Spell
	$groupLightning = $g_ahPicTrainArmySpell[$eSpellLightning] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellLightning]
	$groupHeal = $g_ahPicTrainArmySpell[$eSpellHeal] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellHeal]
	$groupRage = $g_ahPicTrainArmySpell[$eSpellRage] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellRage]
	$groupJump = $g_ahPicTrainArmySpell[$eSpellJump] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellJump]
	$groupFreeze = $g_ahPicTrainArmySpell[$eSpellFreeze] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellFreeze]
	$groupClone = $g_ahPicTrainArmySpell[$eSpellClone] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellClone]
	$groupInvisibility = $g_ahPicTrainArmySpell[$eSpellInvisibility] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellInvisibility]
	$groupRecall = $g_ahPicTrainArmySpell[$eSpellRecall] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellRecall]
	$groupRevive = $g_ahPicTrainArmySpell[$eSpellRevive] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellRevive]
	$groupIceBlock = $g_ahPicTrainArmySpell[$eSpellIBSpell] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellIBSpell]
	$groupAngry = $g_ahPicTrainArmySpell[$eSpellAngrySpell] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellAngrySpell]
 	$groupTotem = $g_ahPicTrainArmySpell[$eSpellTotem] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellTotem]

	;Dark Spell
	$groupPoison = $g_ahPicTrainArmySpell[$eSpellPoison] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellPoison]
	$groupEarthquake = $g_ahPicTrainArmySpell[$eSpellEarthquake] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellEarthquake]
	$groupHaste = $g_ahPicTrainArmySpell[$eSpellHaste] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellHaste]
	$groupSkeleton = $g_ahPicTrainArmySpell[$eSpellSkeleton] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellSkeleton]
	$groupBat = $g_ahPicTrainArmySpell[$eSpellBat] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellBat]
	$groupOvergrowth = $g_ahPicTrainArmySpell[$eSpellOvergrowth] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellOvergrowth]
	$groupIceBlock = $g_ahPicTrainArmySpell[$eSpellIBSpell] & "#" & $g_ahTxtTrainArmySpellCount[$eSpellIBSpell]
 
 	$groupListSpells = $groupLightning & "#" & $groupHeal & "#" & $groupRage & "#" & $groupJump & "#" & $groupFreeze & "#" & $groupClone & "#" & $groupInvisibility & "#" & $groupRecall & "#" & $groupRevive & "#" & $groupTotem & "#" & _
			$groupPoison & "#" & $groupEarthquake & "#" & $groupHaste & "#" & $groupSkeleton & "#" & $groupBat & "#" & $groupOvergrowth & "#" & $groupIceBlock & "#" & $groupAngry & "#" & $groupTotem
 
 	; Sieges
	$groupWallWrecker = $g_ahPicTrainArmySiege[$eSiegeWallWrecker] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeWallWrecker]
	$groupBattleBlimp = $g_ahPicTrainArmySiege[$eSiegeBattleBlimp] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeBattleBlimp]
	$groupStoneSlammer = $g_ahPicTrainArmySiege[$eSiegeStoneSlammer] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeStoneSlammer]
	$groupSiegeBarracks = $g_ahPicTrainArmySiege[$eSiegeBarracks] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeBarracks]
	$groupLogLauncher = $g_ahPicTrainArmySiege[$eSiegeLogLauncher] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeLogLauncher]
	$groupFlameFlinger = $g_ahPicTrainArmySiege[$eSiegeFlameFlinger] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeFlameFlinger]
	$groupBattleDrill = $g_ahPicTrainArmySiege[$eSiegeBattleDrill] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeBattleDrill]
	$groupTroopLauncher = $g_ahPicTrainArmySiege[$eSiegeTroopLauncher] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeTroopLauncher]
	$groupSkyWagon = $g_ahPicTrainArmySiege[$eSiegeSkyWagon] & "#" & $g_ahTxtTrainArmySiegeCount[$eSiegeSkyWagon]
	$groupListSieges = $groupWallWrecker & "#" & $groupBattleBlimp & "#" & $groupStoneSlammer & "#" & $groupSiegeBarracks & "#" & $groupLogLauncher & "#" & $groupFlameFlinger & "#" & $groupBattleDrill & "#" & $groupTroopLauncher & "#" & $groupSkyWagon

	;TH Level
	$g_aGroupListTHLevels = $g_ahPicTHLevels[4] & "#" & $g_ahPicTHLevels[5] & "#" & $g_ahPicTHLevels[6] & "#" & $g_ahPicTHLevels[7] & "#" & $g_ahPicTHLevels[8] & "#" & _
			$g_ahPicTHLevels[9] & "#" & $g_ahPicTHLevels[10] & "#" & $g_ahPicTHLevels[11] & "#" & $g_ahPicTHLevels[12] & "#" & $g_ahPicTHLevels[13] & "#" & $g_ahPicTHLevels[14] & "#" & $g_ahPicTHLevels[15] & "#" & _
			$g_ahPicTHLevels[16] & "#" & $g_ahPicTHLevels[17] & "#" & $g_ahPicTHLevels[18]

	;PicDBMaxTH
	$g_aGroupListPicDBMaxTH = $g_ahPicDBMaxTH[6] & "#" & $g_ahPicDBMaxTH[7] & "#" & $g_ahPicDBMaxTH[8] & "#" & _
			$g_ahPicDBMaxTH[9] & "#" & $g_ahPicDBMaxTH[10] & "#" & $g_ahPicDBMaxTH[11] & "#" & $g_ahPicDBMaxTH[12] & "#" & $g_ahPicDBMaxTH[13] & "#" & $g_ahPicDBMaxTH[14] & "#" & $g_ahPicDBMaxTH[15] & "#" & $g_ahPicDBMaxTH[16]

	;PicABMaxTH
	$g_aGroupListPicABMaxTH = $g_ahPicABMaxTH[6] & "#" & $g_ahPicABMaxTH[7] & "#" & $g_ahPicABMaxTH[8] & "#" & _
			$g_ahPicABMaxTH[9] & "#" & $g_ahPicABMaxTH[10] & "#" & $g_ahPicABMaxTH[11] & "#" & $g_ahPicABMaxTH[12] & "#" & $g_ahPicABMaxTH[13] & "#" & $g_ahPicABMaxTH[14] & "#" & $g_ahPicABMaxTH[15] & "#" & $g_ahPicABMaxTH[16]


	;League
	$g_aGroupLeague = $g_ahPicLeague[$eLeagueUnranked] & "#" & $g_ahPicLeague[$eLeagueBronze] & "#" & $g_ahPicLeague[$eLeagueSilver] & "#" & $g_ahPicLeague[$eLeagueGold] & "#" & _
			$g_ahPicLeague[$eLeagueCrystal] & "#" & $g_ahPicLeague[$eLeagueMaster] & "#" & $g_ahPicLeague[$eLeagueChampion] & "#" & $g_ahPicLeague[$eLeagueTitan] & "#" & _
			$g_ahPicLeague[$eLeagueLegend]

	$g_aGroupCCLeague = $g_ahPicCCLeague[$eLeagueUnranked] & "#" & $g_ahPicCCLeague[$eLeagueBronze] & "#" & $g_ahPicCCLeague[$eLeagueSilver] & "#" & $g_ahPicCCLeague[$eLeagueGold] & "#" & _
			$g_ahPicCCLeague[$eLeagueCrystal] & "#" & $g_ahPicCCLeague[$eLeagueMaster] & "#" & $g_ahPicCCLeague[$eLeagueChampion] & "#" & $g_ahPicCCLeague[$eLeagueTitan] & "#" & _
			$g_ahPicCCLeague[$eLeagueLegend]

	$g_aGroupBBLeague = $g_ahPicBBLeague[$eBBLeagueUnranked] & "#" & $g_ahPicBBLeague[$eLeagueDiamond] & "#" & $g_ahPicBBLeague[$eLeagueRuby] & "#" & $g_ahPicBBLeague[$eLeagueEmerald] & "#" & _
			$g_ahPicBBLeague[$eLeaguePlatinum] & "#" & $g_ahPicBBLeague[$eLeagueTitanium] & "#" & $g_ahPicBBLeague[$eLeagueSteel] & "#" & $g_ahPicBBLeague[$eLeagueIron] & "#" & _
			$g_ahPicBBLeague[$eLeagueBrass] & "#" & $g_ahPicBBLeague[$eLeagueCopper] & "#" & $g_ahPicBBLeague[$eLeagueStone] & "#" & $g_ahPicBBLeague[$eLeagueClay] & "#" & _
			$g_ahPicBBLeague[$eLeagueWood]

	; Groups of controls
	Dim $aTabControlsVillage = [$g_hGUI_VILLAGE_TAB, $g_hGUI_VILLAGE_TAB_ITEM1, $g_hGUI_VILLAGE_TAB_ITEM2, $g_hGUI_VILLAGE_TAB_ITEM3, $g_hGUI_VILLAGE_TAB_ITEM4]
	Dim $aTabControlsMisc = [$g_hGUI_MISC_TAB, $g_hGUI_MISC_TAB_ITEM1, $g_hGUI_MISC_TAB_ITEM2, $g_hGUI_MISC_TAB_ITEM3, $g_hGUI_MISC_TAB_ITEM4]
	Dim $aTabControlsDonate = [$g_hGUI_DONATE_TAB, $g_hGUI_DONATE_TAB_ITEM1, $g_hGUI_DONATE_TAB_ITEM2, $g_hGUI_DONATE_TAB_ITEM3]
	Dim $aTabControlsUpgrade = [$g_hGUI_UPGRADE_TAB, $g_hGUI_UPGRADE_TAB_ITEM1, $g_hGUI_UPGRADE_TAB_ITEM2, $g_hGUI_UPGRADE_TAB_ITEM3, $g_hGUI_UPGRADE_TAB_ITEM4, $g_hGUI_UPGRADE_TAB_ITEM5]
	Dim $aTabControlsNotify = [$g_hGUI_NOTIFY_TAB, $g_hGUI_NOTIFY_TAB_ITEM2]
	Dim $aTabControlsAttack = [$g_hGUI_ATTACK_TAB, $g_hGUI_ATTACK_TAB_ITEM1, $g_hGUI_ATTACK_TAB_ITEM2, $g_hGUI_ATTACK_TAB_ITEM3]

	Dim $aTabControlsArmy = [$g_hGUI_TRAINARMY_TAB, $g_hGUI_TRAINARMY_TAB_ITEM1, $g_hGUI_TRAINARMY_TAB_ITEM2, $g_hGUI_TRAINARMY_ARMY_TAB, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM1, $g_hGUI_TRAINARMY_ARMY_TAB_ITEM2, $g_hGUI_TRAINARMY_ORDER_TAB, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM1, $g_hGUI_TRAINARMY_ORDER_TAB_ITEM2]
	Dim $aTabControlsSearch = [$g_hGUI_SEARCH_TAB, $g_hGUI_SEARCH_TAB_ITEM1, $g_hGUI_SEARCH_TAB_ITEM2, $g_hGUI_SEARCH_TAB_ITEM3]
	Dim $aTabControlsDeadbase = [$g_hGUI_DEADBASE_TAB, $g_hGUI_DEADBASE_TAB_ITEM1, $g_hGUI_DEADBASE_TAB_ITEM2, $g_hGUI_DEADBASE_TAB_ITEM3]
	Dim $aTabControlsActivebase = [$g_hGUI_ACTIVEBASE_TAB, $g_hGUI_ACTIVEBASE_TAB_ITEM1, $g_hGUI_ACTIVEBASE_TAB_ITEM2]
	Dim $aTabControlsAttackOptions = [$g_hGUI_ATTACKOPTION_TAB, $g_hGUI_ATTACKOPTION_TAB_ITEM1, $g_hGUI_ATTACKOPTION_TAB_ITEM2, $g_hGUI_ATTACKOPTION_TAB_ITEM3]
	Dim $aTabControlsStrategies = [$g_hGUI_STRATEGIES_TAB, $g_hGUI_STRATEGIES_TAB_ITEM1, $g_hGUI_STRATEGIES_TAB_ITEM2]

	Dim $aTabControlsBot = [$g_hGUI_BOT_TAB, $g_hGUI_BOT_TAB_ITEM1, $g_hGUI_BOT_TAB_ITEM2, $g_hGUI_BOT_TAB_ITEM3, $g_hGUI_BOT_TAB_ITEM4]
	Dim $aTabControlsStats = [$g_hGUI_STATS_TAB, $g_hGUI_STATS_TAB_ITEM1, $g_hGUI_STATS_TAB_ITEM4, $g_hGUI_STATS_TAB_ITEM5]

	; always enabled / unchanged controls during enabling/disabling all GUI controls function
	$oAlwaysEnabledControls($g_hChkDebugSetLog) = 1
	$oAlwaysEnabledControls($g_hChkDebugAndroid) = 1
	$oAlwaysEnabledControls($g_hChkDebugClick) = 1
	$oAlwaysEnabledControls($g_hChkDebugFunc) = 1
	$oAlwaysEnabledControls($g_hChkDebugDisableZoomout) = 1
	$oAlwaysEnabledControls($g_hChkDebugDisableVillageCentering) = 1
	$oAlwaysEnabledControls($g_hChkDebugDeadbaseImage) = 1
	$oAlwaysEnabledControls($g_hChkDebugOCR) = 1
	$oAlwaysEnabledControls($g_hChkDebugImageSave) = 1
	$oAlwaysEnabledControls($g_hChkdebugBuildingPos) = 1
	$oAlwaysEnabledControls($g_hChkdebugTrain) = 1
	$oAlwaysEnabledControls($g_hChkDebugOCRDonate) = 1
	$oAlwaysEnabledControls($g_hChkDebugSmartZap) = 1
	$oAlwaysEnabledControls($g_hBtnImgCapture) = 1
	$oAlwaysEnabledControls($g_hBtnGetBuilding) = 1
	$oAlwaysEnabledControls($g_hCmbGetBuilding) = 1
	$oAlwaysEnabledControls($g_hBtnGetBuildingRun) = 1
	$oAlwaysEnabledControls($g_hBtnGetBuildingClose) = 1
	$oAlwaysEnabledControls($g_hBtnAtkLogClear) = 1
	$oAlwaysEnabledControls($g_hBtnAtkLogCopyClipboard) = 1
	$oAlwaysEnabledControls($g_hBtnOpenProfileFolder) = 1
	$oAlwaysEnabledControls($g_hBtnTestAttackReportPng) = 1
	$oAlwaysEnabledControls($g_hRadAttackReportPngNormal) = 1
	$oAlwaysEnabledControls($g_hRadAttackReportPngRevenge) = 1
	$oAlwaysEnabledControls($g_hRadAttackReportPngRanked) = 1
	$oAlwaysEnabledControls($g_hBtnAttackReportPngSelect) = 1
	$oAlwaysEnabledControls($g_hBtnAttackReportPngClose) = 1
	$oAlwaysEnabledControls($g_hTxtImgCaptureCode) = 1
	$oAlwaysEnabledControls($g_hTxtImgCaptureIndex) = 1
	$oAlwaysEnabledControls($g_hTxtImgCaptureTolerance) = 1
	$oAlwaysEnabledControls($g_hTxtImgCaptureSize) = 1
	$oAlwaysEnabledControls($g_hCmbImgCaptureFormat) = 1
	$oAlwaysEnabledControls($g_hBtnImgCaptureClick) = 1
	$oAlwaysEnabledControls($g_hBtnImgCaptureOpenFolder) = 1
	$oAlwaysEnabledControls($g_hBtnImgCaptureClose) = 1
	$oAlwaysEnabledControls($g_hBtnTestTrain) = 1
	$oAlwaysEnabledControls($g_hBtnTestDonateCC) = 1
	$oAlwaysEnabledControls($g_hBtnTestRequestCC) = 1
	$oAlwaysEnabledControls($g_hBtnTestSendText) = 1
	$oAlwaysEnabledControls($g_hBtnTestAttackBar) = 1
	$oAlwaysEnabledControls($g_hBtnTestClickDrag) = 1
	$oAlwaysEnabledControls($g_hBtnTestImage) = 1
	$oAlwaysEnabledControls($g_hBtnTestVillageSize) = 1
	$oAlwaysEnabledControls($g_hBtnTestDeadBase) = 1
	$oAlwaysEnabledControls($g_hBtnTestDeadBaseFolder) = 1
	$oAlwaysEnabledControls($g_hBtnTestTHimgloc) = 1
	$oAlwaysEnabledControls($g_hBtnTestQuickTrainsimgloc) = 1
	$oAlwaysEnabledControls($g_hChkdebugAttackCSV) = 1
	$oAlwaysEnabledControls($g_hChkMakeIMGCSV) = 1
	$oAlwaysEnabledControls($g_hBtnTestAttackCSV) = 1
	$oAlwaysEnabledControls($g_hBtnTestBuildingLocation) = 1
	$oAlwaysEnabledControls($g_hBtnRunFunction) = 1
	$oAlwaysEnabledControls($g_hTxtRunFunction) = 1
	$oAlwaysEnabledControls($g_hBtnTestCleanYard) = 1
	$oAlwaysEnabledControls($g_hLblSmartLightningUsed) = 1
	$oAlwaysEnabledControls($g_hLblSmartZap) = 1
	$oAlwaysEnabledControls($g_hLblSmartEarthQuakeUsed) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigSave) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigRead) = 1
	$oAlwaysEnabledControls($g_hBtnTestConfigApply) = 1
	$oAlwaysEnabledControls($g_hBtnTestWeakBase) = 1
	$oAlwaysEnabledControls($g_hBtnConsoleWindow) = 1
	$oAlwaysEnabledControls($g_hBtnTestArmyWindow) = 1
	$oAlwaysEnabledControls($g_hBtnTestOcrMemory) = 1
	$oAlwaysEnabledControls($g_hBtnTestClickAway) = 1
	$oAlwaysEnabledControls($g_hBtnTestAutoUpgrade) = 1
	$oAlwaysEnabledControls($g_hBtnTestUpgradeWindow) = 1
	$oAlwaysEnabledControls($g_hBtnTestSmartWait) = 1
	$oAlwaysEnabledControls($g_hBtnTestTrainsimgloc) = 1

	$oAlwaysEnabledControls($g_hChkClanGamesDebug) = 1
	$oAlwaysEnabledControls($g_hChkCGDebugEvents) = 1

	$oAlwaysEnabledControls($g_hBtnAndroidAdbShell) = 1
	$oAlwaysEnabledControls($g_hBtnAndroidHome) = 1
	$oAlwaysEnabledControls($g_hBtnAndroidBack) = 1
	$oAlwaysEnabledControls($g_hBtnAndroidEnableTouch) = 1
	$oAlwaysEnabledControls($g_hBtnAndroidDisableTouch) = 1
	$oAlwaysEnabledControls($g_hBtnPullSharedPrefs) = 1

	$oAlwaysEnabledControls($g_hBtnMakeScreenshot) = 1
	$oAlwaysEnabledControls($g_hBtnRushAttack) = 1
	$oAlwaysEnabledControls($g_hbtnBBSpam) = 1
	$oAlwaysEnabledControls($g_hbtnCCSpam) = 1
	$oAlwaysEnabledControls($g_hDivider) = 1
	$oAlwaysEnabledControls($g_lblHepNotify) = 1
	$oAlwaysEnabledControls($g_hLblCSVHelpDB) = 1
	$oAlwaysEnabledControls($g_hLblCSVHelpAB) = 1

	$oAlwaysEnabledControls($g_hTabMain) = 1
	$oAlwaysEnabledControls($g_hTabLog) = 1
	$oAlwaysEnabledControls($g_hTabVillage) = 1
	$oAlwaysEnabledControls($g_hTabAttack) = 1
	$oAlwaysEnabledControls($g_hTabBot) = 1
	If $g_hTabStats <> 0 Then $oAlwaysEnabledControls($g_hTabStats) = 1
	If $g_hTabAbout <> 0 Then $oAlwaysEnabledControls($g_hTabAbout) = 1

	$oAlwaysEnabledControls($g_hTxtAutoUpgradeCCLog) = 1
	$oAlwaysEnabledControls($g_hTxtClanGamesLog) = 1

	For $i In $aTabControlsVillage
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsMisc
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsDonate
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsUpgrade
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsNotify
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsAttack
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsArmy
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsSearch
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsDeadbase
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsActivebase
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsAttackOptions
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsStrategies
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsBot
		$oAlwaysEnabledControls($i) = 1
	Next
	For $i In $aTabControlsStats
		If $i <> 0 Then $oAlwaysEnabledControls($i) = 1
	Next
EndFunc   ;==>InitializeControlVariables
