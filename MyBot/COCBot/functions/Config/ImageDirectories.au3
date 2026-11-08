; #Variables# ====================================================================================================================
; Name ..........: Image Search Directories
; Description ...: Gobal Strings holding Path to Images used for Image Search
; Syntax ........: $g_sImgxxx = @ScriptDir & "\imgxml\xxx\"
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_sImgImgLocButtons = @ScriptDir & "\imgxml\Interface\Buttons"

#Region Windows
Global Const $g_sImgGeneralCloseButton = @ScriptDir & "\imgxml\Interface\Windows\CloseButton\"
#EndRegion Windows

#Region Attack
Global Const $g_sImgNextButton = @ScriptDir & "\imgxml\Attack\Home Village\Search\NextButton\"
Global Const $g_sImgReturnHomeChest = @ScriptDir & "\imgxml\Attack\Home Village\Search\ReturnHomeChest\"
#EndRegion Attack

#Region Obstacles
Global Const $g_sImgChatTabPixel = @ScriptDir & "\imgxml\Interface\Dialogs\ChatTabPixel*"
Global Const $g_sImgCocStopped = @ScriptDir & "\imgxml\Interface\Dialogs\CocStopped*"
Global Const $g_sImgCocReconnecting = @ScriptDir & "\imgxml\Interface\Dialogs\CocReconnecting*"
Global Const $g_sImgObstacleAnyoneThere = @ScriptDir & "\imgxml\Interface\Dialogs\AnyoneThere\"
Global Const $g_sImgObstaclePersonalBreak = @ScriptDir & "\imgxml\Interface\Dialogs\Break\"
Global Const $g_sImgObstacleCurrentError = @ScriptDir & "\imgxml\Interface\Dialogs\Error\"
Global Const $g_sImgGfxError = @ScriptDir & "\imgxml\Interface\Dialogs\GfxError*"
Global Const $g_sImgMaintenance = @ScriptDir & "\imgxml\Interface\Dialogs\Maintenance*"
Global Const $g_sImgMaintClock = @ScriptDir & "\imgxml\Interface\Dialogs\MaintClock*"
Global Const $g_sImgError = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Error*"
Global Const $sImgConnectionLost = @ScriptDir & "\imgxml\Interface\BlockingDialogs\ConnectionLost*"
Global Const $sImgOos = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Oos*"
Global Const $sImgRateGame = @ScriptDir & "\imgxml\Interface\BlockingDialogs\RateGame*"
Global Const $sImgNotice = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Notice*"
Global Const $sImgMajorUpdate = @ScriptDir & "\imgxml\Interface\BlockingDialogs\MajorUpdate*"
Global Const $sImgGPServices = @ScriptDir & "\imgxml\Interface\BlockingDialogs\GPServices*"
Global Const $sImgDevice = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Device*"
Global Const $sImgReloadBtn = @ScriptDir & "\imgxml\Interface\BlockingDialogs\ReloadBtn*"
Global Const $sImgNeverBtn = @ScriptDir & "\imgxml\Interface\BlockingDialogs\NeverBtn*"
Global Const $sImgOKBtn = @ScriptDir & "\imgxml\Interface\BlockingDialogs\OKBtn*"
Global Const $sImgClashOfMagicAdvert = @ScriptDir & "\imgxml\Interface\BlockingDialogs\ClashOfMagicAdvert*"
Global Const $sImgClashNotResponding = @ScriptDir & "\imgxml\Interface\BlockingDialogs\NotResp*"
Global Const $g_sImgCOCUpdate = @ScriptDir & "\imgxml\Interface\BlockingDialogs\COCUpdate*"
Global Const $g_sImgClanCapitalResults = @ScriptDir & "\imgxml\Interface\Dialogs\CCResults*"
Global Const $g_sImgLoading = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Loading*"
Global Const $g_sImgInfoButton = @ScriptDir & "\imgxml\Interface\BlockingDialogs\InfoButton*"
Global Const $g_sImgSurvey = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Survey*"
Global Const $g_sImgNoThanks = @ScriptDir & "\imgxml\Interface\BlockingDialogs\NoThks*"
Global Const $sImgPersonnalDatas = @ScriptDir & "\imgxml\Interface\BlockingDialogs\PersonnalDatas*"
Global Const $sImgDenyBtn = @ScriptDir & "\imgxml\Interface\BlockingDialogs\DenyBtn*"
Global Const $g_sImgOkayBlue = @ScriptDir & "\imgxml\Interface\Dialogs\OkayBlue*"
Global Const $sImgAnalytics = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Analytics*"
Global Const $sImgDenyLightBtn = @ScriptDir & "\imgxml\Interface\BlockingDialogs\DenyLightBtn*"
;Voucher
Global Const $g_sImgGoButton = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Voucher\Go*"
Global Const $g_sImgClaimButton = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Voucher\Claim*"
;Season Ended/New
Global Const $g_sImgLockEnd = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Lock*"
Global Const $g_sImgWatch = @ScriptDir & "\imgxml\Interface\BlockingDialogs\Watch*"
;Okay Button in Daily challenge Window
Global Const $g_sImgOkayDailyChallenge = @ScriptDir & "\imgxml\Events\DailyChallenges\Okay\Okay*"
#EndRegion Obstacles

#Region Main Village
Global $sImgIsOnMainVillage = @ScriptDir & "\imgxml\Interface\ScreenDetection\Home Village\"
Global $g_sImgCollectRessources = @ScriptDir & "\imgxml\Collect\Home Village\Resources"
Global $g_sImgCollectLootCart = @ScriptDir & "\imgxml\Collect\Home Village\LootCart"
Global $g_sImgGobBuilder = @ScriptDir & "\imgxml\Interface\ScreenDetection\Home Village\GobBuilder*"
Global $g_sImgBoat = @ScriptDir & "\imgxml\Navigation\Boat\"
Global $g_sImgZoomOutDir = @ScriptDir & "\imgxml\Scenery\Home Village\Normal\"
Global $g_sImgCheckWallDir = @ScriptDir & "\imgxml\Upgrades\Walls"
Global $g_sImgClearTombs = @ScriptDir & "\imgxml\Obstacles\Home Village\Tombs"
Global $g_sImgCleanYard = @ScriptDir & "\imgxml\Obstacles\Home Village\Yard"
Global $g_sImgCleanYardSnow = @ScriptDir & "\imgxml\Obstacles\Home Village\Snow"
Global $g_sImgGemBox = @ScriptDir & "\imgxml\Obstacles\Home Village\GemBox"
Global $g_sImgAchievementsMainScreen = @ScriptDir & "\imgxml\Collect\Home Village\Achievements\MainScreen*"
Global $g_sImgAchievementsClaimReward = @ScriptDir & "\imgxml\Collect\Home Village\Achievements\ClaimButton"
Global $g_sImgTrader = @ScriptDir & "\ImgXML\Collect\Home Village\Trader\TraderIcon"
Global $g_sImgTraderGems = @ScriptDir & "\ImgXML\Collect\Home Village\Trader\Gems"
Global $g_sImgDailyDiscountWindow = @ScriptDir & "\ImgXML\Collect\Home Village\Trader\DailyDiscounts*"
Global $g_sImgBuyDealWindow = @ScriptDir & "\ImgXML\Collect\Home Village\Trader\BuyDeal"
Global Const $g_sImgUpgradeWhiteZero = @ScriptDir & "\imgxml\Upgrades\Resources\Dialogs\WhiteZero*"
Global $g_sImgCancelButton = @ScriptDir & "\imgxml\Upgrades\Resources\Dialogs\CancelButton\"
Global Const $g_sImgDonateCC = @ScriptDir & "\imgxml\ClanCastle\Donate\"
Global Const $g_sImgLabResearch = @ScriptDir & "\imgxml\Upgrades\Laboratory\"
Global $g_sImgGobBuilderLab = @ScriptDir & "\imgxml\Upgrades\Resources\GoblinBuilder\GobBuilder*"
Global $g_sImgElixirDrop = @ScriptDir & "\imgxml\Upgrades\Laboratory\ElixirDrop\"
Global $g_sImgHeroEquipement = @ScriptDir & "\imgxml\Upgrades\Blacksmith\"
Global $g_sImgEquipmentResearch = @ScriptDir & "\imgxml\Upgrades\Blacksmith\Equipment\"
Global $g_sImgEquipmentNew = @ScriptDir & "\imgxml\Upgrades\Blacksmith\New\New*"
Global $g_sImgRedZero = @ScriptDir & "\imgxml\Upgrades\Blacksmith\RedZero\RedZero*"
Global $ImgMiniCupButton = @ScriptDir & "\imgxml\Events\DailyChallenges\MiniCup\MiniCup*"
;Apprentice Builder
Global $g_sImgGreenAssignButton = @ScriptDir & "\imgxml\HelperHut\"
Global $ImgLocked = @ScriptDir & "\imgxml\HelperHut\Locked*"
Global $ImgConfirmButton = @ScriptDir & "\imgxml\HelperHut\Confirm*"
Global $ImgJobInProgress = @ScriptDir & "\imgxml\HelperHut\Job*"
Global $ImgOnGoingMini = @ScriptDir & "\imgxml\HelperHut\OnGoingMini*"
Global $ImgAssignMini = @ScriptDir & "\imgxml\HelperHut\AssignMini*"
Global $g_sImgMiniBuilderAppHead = @ScriptDir & "\imgxml\HelperHut\MiniBuilderApp*"
Global $g_sImgMiniLabAssistHead = @ScriptDir & "\imgxml\HelperHut\MiniLabAssist*"
; Treasury Hunt
Global $g_sImgChestPage = @ScriptDir & "\imgxml\Events\Chests\"
Global $ImgHammerOnRock = @ScriptDir & "\imgxml\Events\TreasureHunt\Hammer\Hammer*"
Global $ImgHammersOnRock = @ScriptDir & "\imgxml\Events\TreasureHunt\Hammer\"
Global $ImgLockOfChest = @ScriptDir & "\imgxml\Events\TreasureHunt\Lock*"
#EndRegion Main Village

#Region Clan Capital
Global $g_sImgCCMap = @ScriptDir & "\imgxml\ClanCapital\CCMap\"
Global $g_sImgCCMapName = @ScriptDir & "\imgxml\ClanCapital\CapitalMap\"
Global $g_sImgCCMenuTriangle = @ScriptDir & "\imgxml\ClanCapital\CCMap\MenuTriangle\"
Global $g_sImgAirShip = @ScriptDir & "\imgxml\ClanCapital\CCMap\AirShip\"
Global $g_sImgLock = @ScriptDir & "\imgxml\ClanCapital\CCMap\Lock\"
Global $g_sImgCCGoldCollect = @ScriptDir & "\imgxml\ClanCapital\CCMap\CCGold\Collect\"
Global $g_sImgCCGoldCraft = @ScriptDir & "\imgxml\ClanCapital\CCMap\CCGold\Craft\"
Global $g_sImgActiveForge = @ScriptDir & "\imgxml\ClanCapital\CCMap\CCGold\ActiveForge\"
Global $g_sImgForgeHouse = @ScriptDir & "\imgxml\ClanCapital\ForgeHouse\"
Global $g_sImgResourceCC = @ScriptDir & "\imgxml\ClanCapital\CCMap\BuilderMenu\"
Global $g_sImgCCUpgradeButton = @ScriptDir & "\imgxml\ClanCapital\CCMap\UpgradeButton\Hammer*"
Global $g_sImgCCGrandBuilder = @ScriptDir & "\imgxml\ClanCapital\CCMap\UpgradeButton\GrandBuilder*"
Global $g_sImgCCCapitalTreasury = @ScriptDir & "\imgxml\ClanCapital\CCMap\Treasury\Treasury*"
Global $g_sImgCCRaid = @ScriptDir & "\imgxml\ClanCapital\CCMap\Raid\"
Global $g_sImgPrioritizeCC = @ScriptDir & "\imgxml\ClanCapital\CCMap\BuilderMenu\Prioritize\"
Global $g_sImgDecoration = @ScriptDir & "\imgxml\ClanCapital\CCMap\BuilderMenu\Decoration\"
#EndRegion Clan Capital

#Region Boost Super Troops
Global $g_sImgBoostTroopsBarrel = @ScriptDir & "\imgxml\Boost\SuperTroops\Barrel\"
Global $g_sImgBarrelStopped = @ScriptDir & "\imgxml\Boost\SuperTroops\Stopped\"
Global $g_sImgBoostTroopsWindow = @ScriptDir & "\imgxml\Boost\SuperTroops\Window\"
Global $g_sImgBoostTroopsIcons = @ScriptDir & "\imgxml\Boost\SuperTroops\Troops\"
Global $g_sImgBoostTroopsButtons = @ScriptDir & "\imgxml\Boost\SuperTroops\Buttons\"
Global $g_sImgBoostTroopsPotion = @ScriptDir & "\imgxml\Boost\SuperTroops\Potions\"
Global $g_sImgBoostTroopsClock = @ScriptDir & "\imgxml\Boost\SuperTroops\Clock\"
#EndRegion Boost Super Troops


#Region Builder Base
Global $g_sImgCollectRessourcesBB = @ScriptDir & "\imgxml\Collect\Builder Base\Resources"
;Global $g_sImgBoatBB = @ScriptDir & "\imgxml\Boat\BoatBuilderBase_0_89.xml"
Global $g_sImgBoatBB = @ScriptDir & "\imgxml\Navigation\Boat\"
Global $g_sImgStartCTBoost = @ScriptDir & "\imgxml\Boost\ClockTower\ClockTowerAvailable*.xml"
Global $g_sImgCleanBBYard = @ScriptDir & "\imgxml\Obstacles\Builder Base"
Global $g_sImgCleanBBLower = $g_sImgCleanBBYard & "\Lower\"
Global $g_sImgCleanBBHigher = $g_sImgCleanBBYard & "\Higher\"
Global $g_sImgCleanBBDownTunnel = $g_sImgCleanBBYard & "\DownTunnel\"
Global $g_sImgCleanBBUpTunnel = $g_sImgCleanBBYard & "\UpTunnel\"
Global $g_sImgCleanBBRemoveButton = $g_sImgCleanBBYard & "\Buttons\"
Global $g_sImgIsOnBB = @ScriptDir & "\imgxml\Interface\ScreenDetection\Builder Base\"
Global Const $g_sImgMasterBuilderHead = @ScriptDir & "\imgxml\Interface\ScreenDetection\Builder Base\BuilderEye*"
Global $sImgIsOnBuilderBaseEnemyVillage = @ScriptDir & "\imgxml\Interface\ScreenDetection\BuilderBaseEnemyVillage\"
Global $g_sImgStarLaboratory = @ScriptDir & "\imgxml\Upgrades\StarLaboratory"
Global $g_sImgStarLabElex = @ScriptDir & "\imgxml\Upgrades\StarLaboratory\Resource\StarLabElex*"
Global $g_sImgBBMachReady = @ScriptDir & "\imgxml\Attack\Builder Base\PrepareAttack\BattleMachine"
Global $g_sImgDirBBTroops = @ScriptDir & "\imgxml\Attack\Builder Base\AttackBar\"
Global $g_sImgElixirCart = @ScriptDir & "\imgxml\Collect\Builder Base\ElixirCart\ElixirCart*"
Global $g_sImgCollectElixirCart = @ScriptDir & "\imgxml\Collect\Builder Base\ElixirCart\Collect*"
Global $g_sImgFillTrain = @ScriptDir & "\imgxml\Attack\Builder Base\PrepareAttack\TrainTroop\"
Global $g_sImgFillCamp = @ScriptDir & "\imgxml\Attack\Builder Base\PrepareAttack\TrainTroop\Camp\"
Global $sImgTunnel = @ScriptDir & "\imgxml\Navigation\Tunnel\"
; Builder Base Attack
Global $g_sImgBBAttackStart = @ScriptDir & "\imgxml\Attack\Builder Base\AttackStart\"
Global $g_sImgBBAttackBonus = @ScriptDir & "\imgxml\Attack\Builder Base\AttackBonus\"
Global $g_sImgBBReturnHome = @ScriptDir & "\imgxml\Attack\Builder Base\ReturnHome\"
Global $g_sImgBBBattleMachine = @ScriptDir & "\imgxml\Attack\Builder Base\AttackBar\Machine\"
Global $g_sImgDirMachineAbility = @ScriptDir & "\imgxml\Attack\Builder Base\AttackBar\MachineAbility\"
Global $g_sImgDirBomberAbility = @ScriptDir & "\imgxml\Attack\Builder Base\AttackBar\BomberAbility\"
Global $g_sImgOpponentBuildingsBB = @ScriptDir & "\imgxml\Attack\Builder Base\AttackBuildings\"
#EndRegion Builder Base

#Region DonateCC
Global $g_sImgDonateTroops = @ScriptDir & "\imgxml\ClanCastle\Donate\Troops\"
Global $g_sImgDonateSpells = @ScriptDir & "\imgxml\ClanCastle\Donate\Spells\"
Global $g_sImgDonateSiege = @ScriptDir & "\imgxml\ClanCastle\Donate\SiegeMachines\"
Global $g_sImgChatDivider = @ScriptDir & "\imgxml\ClanCastle\Chat\ChatDivider_0_98.xml"
Global $g_sImgChatIUnterstand = @ScriptDir & "\imgxml\ClanCastle\Chat\IUnderstand_0_95.xml"
#EndRegion DonateCC

#Region Auto Upgrade Normal Village
Global $g_sImgAUpgradeObst = @ScriptDir & "\imgxml\Upgrades\Village\Obstacles"
Global $g_sImgAUpgradeZero = @ScriptDir & "\imgxml\Upgrades\Village\Zero"
Global $g_sImgAUpgradeRes = @ScriptDir & "\imgxml\Upgrades\Resources"
Global $g_sImgAUpgradeEndBoost = @ScriptDir & "\imgxml\Upgrades\Village\EndBoost\EndBoost*"
Global $g_sImgAUpgradeEndBoostOKBtn = @ScriptDir & "\imgxml\Upgrades\Village\EndBoost\EndBoostOKBtn*"
Global $g_sImgResourceIcon = @ScriptDir & "\imgxml\Upgrades\Resources\ResourceIcon\"
Global $g_sImgAUpgradeMenu = @ScriptDir & "\imgxml\Upgrades\AutoUpgrade\Home Village\"
Global $g_sImgAUpgradeBuild = $g_sImgAUpgradeMenu & "Buttons\Build*"
Global $g_sImgAUpgradeBuilderMenu = $g_sImgAUpgradeMenu & "Buttons\BuilderMenu*"
Global $g_sImgAUpgradeLabMenu = $g_sImgAUpgradeMenu & "Buttons\LabMenu*"
Global $g_sImgWallResource = @ScriptDir & "\imgxml\Upgrades\Village\UpgradeWalls\"
Global $g_sImgUpgradeBtn2Wall = @ScriptDir & "\imgxml\Interface\Buttons\Upgrade*"
Global $g_sImgAUpgradeHeroes = @ScriptDir & "\imgxml\Upgrades\Village\Heroes"
Global $g_sImgCardTapIcon = @ScriptDir & "\imgxml\Scenery\ClashOfCards\CardTapIcon\" ; Optional dedicated template from the Clash of Cards event
Global $g_sImgCardPage = @ScriptDir & "\imgxml\Events\ClashOfCards\"
Global $g_sImgClaimRewardButton = @ScriptDir & "\imgxml\Collect\Home Village\ClaimReward_0_90.xml"
#EndRegion Auto Upgrade Normal Village

#Region Auto Upgrade Builder Base
Global $g_sImgAutoUpgradeBB = @ScriptDir & "\imgxml\Upgrades\Builder\Resources"
Global $g_sImgAUpgradeBBMenu = @ScriptDir & "\imgxml\Upgrades\AutoUpgrade\Builder Base\"
Global $g_sImgAUpgradeBBBuild = $g_sImgAUpgradeBBMenu & "Buttons\Build*"
Global $g_sImgAUpgradeBBMasterMenu = $g_sImgAUpgradeBBMenu & "Buttons\MasterBuilderMenu*"
Global $g_sImgAUpgradeBBStarLabMenu = $g_sImgAUpgradeBBMenu & "Buttons\StarLabMenu*"
Global $g_sImgAutoUpgradeNew = @ScriptDir & "\imgxml\Upgrades\Builder\New"
Global $g_sImgAutoUpgradeNoRes = @ScriptDir & "\imgxml\Upgrades\Builder\NoResources"
Global $g_sImgAutoUpgradeBtnDir = @ScriptDir & "\imgxml\Upgrades\Builder\Upgrade"
Global $g_sImgAutoUpgradeZero = @ScriptDir & "\imgxml\Upgrades\Builder\NewBuildings\Shop"
Global $g_sImgAutoUpgradeClock = @ScriptDir & "\imgxml\Upgrades\Builder\NewBuildings\Clock"
Global $g_sImgAutoUpgradeInfo = @ScriptDir & "\imgxml\Upgrades\Builder\NewBuildings\Slot"
Global $g_sImgAutoUpgradeNewBldgYes = @ScriptDir & "\imgxml\Upgrades\Builder\NewBuildings\Yes"
Global $g_sImgAutoUpgradeNewBldgNo = @ScriptDir & "\imgxml\Upgrades\Builder\NewBuildings\No"
Global $ImgHeroMaxLevel = @ScriptDir & "\imgxml\Upgrades\Resources\Dialogs\HeroMaxLevel\MaxLevel*.xml"
#EndRegion Auto Upgrade Builder Base

#Region Train
Global $g_sImgTrainTroops = @ScriptDir & "\imgxml\Army\Training\Troop_Training\"
Global $g_sImgTrainSpells = @ScriptDir & "\imgxml\Army\Training\Spell_Training\"
Global $g_sImgTrainSieges = @ScriptDir & "\imgxml\Army\Training\Siege_Training\"
Global $g_sImgArmyOverviewSpells = @ScriptDir & "\imgxml\Army\Overview\Spells" ; @ScriptDir & "\imgxml\ArmySpells"
Global $g_sImgRequestCCButton = @ScriptDir & "\imgxml\ClanCastle\Request"
Global $g_sImgSendRequestButton = @ScriptDir & "\imgxml\ClanCastle\Request\SendRequest\SendButton*"
Global $g_sImgArmyOverviewCastleCake = @ScriptDir & "\imgxml\Army\Overview\CastleCake"
#EndRegion Train

#Region Attack
Global $g_sImgAttackBarDir = @ScriptDir & "\imgxml\Attack\Home Village\AttackBar"
Global $g_sImgSwitchSiegeMachine = @ScriptDir & "\imgxml\Attack\Home Village\SiegeSelection\"
Global $g_sImgIsMultiplayerTab = @ScriptDir & "\imgxml\Attack\Home Village\Search\MultiplayerTab*"
Global $g_sImgQueenBar = @ScriptDir & "\imgxml\Attack\Home Village\AttackBar\Queen*"
Global $g_sImgKingBar = @ScriptDir & "\imgxml\Attack\Home Village\AttackBar\King*"
Global $g_sImgPrinceBar = @ScriptDir & "\imgxml\Attack\Home Village\AttackBar\Prince*"
Global $g_sImgWardenBar = @ScriptDir & "\imgxml\Attack\Home Village\AttackBar\Warden*"
Global $g_sImgChampionBar = @ScriptDir & "\imgxml\Attack\Home Village\AttackBar\Champion*"
Global $g_sImgDukeBar = @ScriptDir & "\imgxml\Attack\Home Village\AttackBar\Duke*"
#EndRegion Attack

#Region Search
Global $g_sImgElixirCollectorFill = @ScriptDir & "\imgxml\Attack\Home Village\DeadBase\Elixir\Fill\"
Global $g_sImgElixirCollectorLvl = @ScriptDir & "\imgxml\Attack\Home Village\DeadBase\Elixir\LVL\"
Global $g_sImgElixirStorage = @ScriptDir & "\imgxml\Attack\Home Village\DeadBase\Elixir\Storage\"
Global $g_sImgElixirSupercharge = @ScriptDir & "\imgxml\Attack\Home Village\DeadBase\Elixir\Supercharge\"
Global $g_sImgWeakBaseBuildingsDir = @ScriptDir & "\imgxml\Buildings\Home Village"
Global $g_sImgWeakBaseBuildingsEagleDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\Eagle"
Global $g_sImgWeakBaseBuildingsScatterDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\Scattershot"
Global $g_sImgWeakBaseBuildingsMonolithDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\Monolith"
Global $g_sImgWeakBaseBuildingsInfernoDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\InfernoTower"
Global $g_sImgWeakBaseBuildingsXbowDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\XBow"
Global $g_sImgWeakBaseBuildingsWizTowerSnowDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\WizardTower\Snow"
Global $g_sImgWeakBaseBuildingsWizTowerDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\WizardTower\Normal"
Global $g_sImgWeakBaseBuildingsMortarsDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\Mortars"
Global $g_sImgWeakBaseBuildingsAirDefenseDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\AirDefense"
Global $g_sImgWeakBaseBuildingsFirespitterDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\Firespitter"
Global $g_sImgWeakBaseBuildingsRevengeTowerDir = @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\RevengeTower"
Global $g_sImgSearchDrill = @ScriptDir & "\imgxml\Attack\Home Village\StorageDetection\Drills"
Global $g_sImgSearchDrillLevel = @ScriptDir & "\imgxml\Attack\Home Village\StorageDetection\Drills\Level"
Global $g_sImgEasyBuildings = @ScriptDir & "\imgxml\easybuildings"
Global $g_sImgPrepareLegendLeagueSearch = @ScriptDir & "\imgxml\Attack\Home Village\Search\LegendLeague"
Global $ImgArmyAttack = @ScriptDir & "\imgxml\Attack\Home Village\Search\AttackButton*"
Global $g_sImgRetrySearchButton = @ScriptDir & "\imgxml\Attack\Home Village\Clouds\RetryButton*"
Global $g_sImgResourceAttack = @ScriptDir & "\imgxml\Attack\Home Village\Resource\"
#EndRegion Search

#Region SwitchAcc
Global Const $g_sImgLoginWithSupercellID = @ScriptDir & "\imgxml\Interface\Dialogs\LoginWithSupercellID*"
Global Const $g_sImgSupercellIDConnected = @ScriptDir & "\imgxml\Accounts\Switching\SupercellID\Connected\SCIDConnected*"
Global Const $g_sImgSupercellIDReload = @ScriptDir & "\imgxml\Accounts\Switching\SupercellID\Reload\SCIDReload*"
Global Const $g_sImgSupercellIDWindows = @ScriptDir & "\imgxml\Accounts\Switching\SupercellID\SCIDWindows*"
Global Const $g_sImgSupercellIDSlots = @ScriptDir & "\imgxml\Accounts\Switching\SupercellID\Slots\SCIDHead*"
#EndRegion SwitchAcc

#Region ClanGames
Global Const $g_sImgCaravan = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\Caravan"
Global Const $g_sImgStart = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\Start"
Global Const $g_sImgCoolPurge = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\Gem\CooldownGem*"
Global Const $g_sImgTrashPurge = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\Trash"
Global Const $g_sImgReward = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\Reward"
Global Const $g_sImgWindow = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\Window"
Global Const $g_sImgBorder = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\Border"
Global Const $g_sImgGameComplete = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\GameComplete"
Global Const $g_sImgVersus = @ScriptDir & "\imgxml\Events\ClanGames\MainLoop\Versus"
#EndRegion ClanGames

#Region RankedBattle
Global Const $g_sImgRankedBattleSearch = @ScriptDir & "\imgxml\Attack\Home Village\Search\RankedBattle\"
#EndRegion RankedBattle
