; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file creates the bottom panel
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GKevinOD (2014)
; Modified ......: DkEd, Hervidero (2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_hBtnStart = 0, $g_hBtnStop = 0, $g_hBtnPause = 0, $g_hBtnResume = 0, $g_hBtnSearchMode = 0, $g_hBtnMakeScreenshot = 0, $g_hBtnHide = 0, $g_hBtnEmbed = 0, _
		$g_hChkBackgroundMode = 0, $g_hLblDonate = 0, $g_hBtnAttackNowDB = 0, $g_hBtnAttackNowLB = 0, $g_hBtnAttackNowTS = 0, $g_hbtnBBSpam = 0, $g_hbtnCCSpam = 0, $g_hBtnDirectAttack = 0, _
		$g_hBtnRushAttack = 0
Global $g_hPicTwoArrowShield = 0, $g_hLblVersion = 0, $g_hPicArrowLeft = 0, $g_hPicArrowRight = 0
Global $g_hGrpVillage = 0
Global $g_hLblResultGoldNow = 0, $g_hLblResultGoldHourNow = 0, $g_hPicResultGoldNow = 0, $g_hPicResultGoldTemp = 0
Global $g_hLblResultElixirNow = 0, $g_hLblResultElixirHourNow = 0, $g_hPicResultElixirNow = 0, $g_hPicResultElixirTemp = 0
Global $g_hLblResultDENow = 0, $g_hLblResultDEHourNow = 0, $g_hPicResultDENow = 0, $g_hPicResultDETemp = 0
Global $g_hLblResultTrophyNow = 0, $g_hPicResultTrophyNow = 0, $g_hLblResultRuntimeNow = 0, $g_hPicResultRuntimeNow = 0, $g_hLblResultBuilderNow = 0, $g_hPicResultBuilderNow = 0
Global $g_hLblResultAttackedHourNow = 0, $g_hPicResultAttackedHourNow = 0, $g_hLblResultGemNow = 0, $g_hPicResultGemNow = 0, $g_hLblResultSkippedHourNow = 0, $g_hPicResultSkippedHourNow = 0
Global $g_hLblResultOoSNow = 0, $g_hPicResultOoSNow = 0
Global $g_iVillageStatsPage = 0
Global $g_hVillageLabTimer = 0, $g_hVillagePetTimer = 0, $g_hVillageStarTimer = 0, $g_hVillageLabIcon = 0, $g_hVillagePetIcon = 0, $g_hVillageStarIcon = 0
Global $g_hHelperBuilderTimer = 0, $g_hHelperLabTimer = 0, $g_hHelperBuilderIcon = 0, $g_hHelperLabIcon = 0
Global $g_hLblResultGoldBBNow = 0, $g_hPicResultGoldBBNow = 0
Global $g_hLblResultElixirBBNow = 0, $g_hPicResultElixirBBNow = 0
Global $g_hLblResultTrophyBBNow = 0, $g_hPicResultTrophyBBNow = 0
Global $g_hLblResultBuilderBBNow = 0, $g_hPicResultBuilderBBNow = 0
Global $g_hLblResultCCGoldNow = 0, $g_hPicResultCCGoldNow = 0
Global $g_hLblResultCCMedalNow = 0, $g_hPicResultCCMedalNow = 0

; GLOBALS FOR NEW GAME STATUS DISPLAY
Global $g_hlblKing = 0, $g_hPicKingGray = 0, $g_hPicKingBlue = 0, $g_hPicKingRed = 0, $g_hPicKingGreen = 0
Global $g_hlblQueen = 0, $g_hPicQueenGray = 0, $g_hPicQueenBlue = 0, $g_hPicQueenRed = 0, $g_hPicQueenGreen = 0
Global $g_hlblPrince = 0, $g_hPicPrinceGray = 0, $g_hPicPrinceBlue = 0, $g_hPicPrinceRed = 0, $g_hPicPrinceGreen = 0
Global $g_hlblWarden = 0, $g_hPicWardenGray = 0, $g_hPicWardenBlue = 0, $g_hPicWardenRed = 0, $g_hPicWardenGreen = 0
Global $g_hlblChampion = 0, $g_hPicChampionGray = 0, $g_hPicChampionBlue = 0, $g_hPicChampionRed = 0, $g_hPicChampionGreen = 0
Global $g_hlblDuke = 0, $g_hPicDukeGray = 0, $g_hPicDukeBlue = 0, $g_hPicDukeRed = 0, $g_hPicDukeGreen = 0
Global $g_hPicLabMarker = 0, $g_hPicLabGray = 0, $g_hPicLabRed = 0, $g_hPicLabGreen = 0, $g_hLbLLabTime = 0

; Pet House
Global $g_hPicPetMarker = 0, $g_hPicPetGray = 0, $g_hPicPetRed = 0, $g_hPicPetGreen = 0, $g_hLbLPetTime = 0

Func CreateBottomPanel()
	Local $sTxtTip = ""
;~ ------------------------------------------------------
;~ Lower part visible on all Tabs
;~ ------------------------------------------------------

;~ Buttons
	Local $y_bottom = 0 ; 515
	Local $x = 10, $y = $y_bottom + 10
	GUICtrlCreateGroup("https://mybot.run", $x - 5, $y - 10, 160, 108)
	$g_hBtnStart = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStart", "Start Bot"), $x, $y + 2 + 5, 75, 40 - 5)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStart_Info_01", "Use this to START the bot."))
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x5CAD85)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hBtnStop = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStop", "Stop Bot"), -1, -1, 75, 40 - 5)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnStop_Info_01", "Use this to STOP the bot (or ESC key)."))
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0xDB4D4D)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hBtnPause = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnPause", "Pause"), $x + 75, -1, 75, 40 - 5)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnPause_Info_01", "Use this to PAUSE all actions of the bot until you Resume (or Pause/Break key)."))
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0xFFA500)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hBtnResume = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnResume", "Resume"), -1, -1, 75, 40 - 5)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnResume_Info_01", "Use this to RESUME a paused Bot (or Pause/Break key)."))
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0xFFA500)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hBtnSearchMode = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnSearchMode", "Search Mode"), -1, -1, 75, 40 - 5)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnSearchMode_Info_01", "Does not attack. Searches for a Village that meets conditions."))
	GUICtrlSetOnEvent(-1, "btnSearchMode")
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0xFFA500)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hBtnMakeScreenshot = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnMakeScreenshot", "Photo"), $x, $y + 45, 35, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnMakeScreenshot_Info_01", "Click here to take a snaphot of your village and save it to a file."))
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x5CAD85)
	$g_hBtnHide = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide", "Hide"), $x + 35, $y + 45, 40, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide_Info_01", "Use this to move the Android Window out of sight.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Bottom", "BtnHide_Info_02", "(Not minimized, but hidden)"))
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$g_hBtnEmbed = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEmbed", "Dock"), $x + 75, $y + 45, 75, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "BtnEmbed_Info_01", "Use this to embed the Android Window into Bot."))
	If $g_bBtnColor Then GUICtrlSetBkColor(-1, 0x22C4F5)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "btnEmbed")
	$g_hChkBackgroundMode = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode", "Background Mode"), $x + 1, $y + 72, 104, 24)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode_Info_01", "Check this to ENABLE the Background Mode of the Bot.") & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Bottom", "ChkBackgroundMode_Info_02", "With this you can also hide the Android Emulator window out of sight."))
	If $g_bGuiRemote Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "chkBackground")
	GUICtrlSetState(-1, (($g_bAndroidAdbScreencap = True) ? ($GUI_CHECKED) : ($GUI_UNCHECKED)))

	$g_hLblVersion = GUICtrlCreateLabel($g_sBotVersion, $x + 105, $y + 77, 41, 17, $SS_RIGHT)
	GUICtrlSetColor(-1, $COLOR_GRAY)


	$g_hBtnAttackNowDB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnAttackNowDB", "DB Attack!"), $x + 190, $y - 4, 60, -1)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hBtnAttackNowLB = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Bottom", "BtnAttackNowLB", "LB Attack!"), $x + 190, $y + 23, 60, -1)
	GUICtrlSetState(-1, $GUI_HIDE)

	; ===== Direct ATK | BB Spam | CC Spam | Rush Attack =====
	$g_hBtnDirectAttack = GUICtrlCreateButton("Direct", $x + 243, $y + 76, 48, 24)
		_GUICtrlSetTip(-1, "Direct attack - Execute PrepareAttack() and Attack() sequence for Live Base. Click again to cancel and leave the battle open.")
		GUICtrlSetOnEvent(-1, "RequestDirectAttack")
	$g_hBtnRushAttack = GUICtrlCreateButton("Rush", $x + 292, $y + 76, 44, 24)
		_GUICtrlSetTip(-1, "Rush Attack - Runs attack sequences continuously without donate, request or upgrades." & @CRLF & _
			"Click to toggle ON/OFF.")
		GUICtrlSetOnEvent(-1, "ToggleRushAttack")
	$g_hbtnBBSpam = GUICtrlCreateButton("BBSpam", $x + 337, $y + 76, 54, 24)
		_GUICtrlSetTip(-1, "Builder Base farming loop - Continuously attacks and collects until BB resources reach maximum storage" & @CRLF & _
			"Click to toggle ON/OFF. Will bypass normal bot operations when active.")
		GUICtrlSetOnEvent(-1, "ToggleBBSpam")

	$g_hbtnCCSpam = GUICtrlCreateButton("CCSpam", $x + 392, $y + 76, 54, 24)
		_GUICtrlSetTip(-1, "Clan Castle donation spam - Continuously calls DonateCC() every 30 seconds." & @CRLF & _
			"Click to toggle ON/OFF. Stops when donation is disabled or bot is stopped.")
		GUICtrlSetOnEvent(-1, "ToggleCCSpam")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	If $g_bAndroidAdbScreencap Then chkBackground() ; update background mode GUI

	$g_hPicArrowLeft = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowLeft, $x + 269, $y + 40, 16, 16)
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage_Info_01", "Switch between village info and stats")
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicArrowRight = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnArrowRight, $x + 247 + 198, $y + 40, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_SHOW)



	;New section for royal and lab status
	Local $x = 174, $y = $y_bottom + 5
	$sTxtTip = GetTranslatedFileIni("MBR GUI Design Bottom", "GrpStatus_Info_01", "Gray - N/A" & @CRLF & "Green - Ready" & @CRLF & "Blue - Healing" & @CRLF & "Red - Upgrading")
	$g_hPicKingGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicKingBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicKingGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicKingRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hlblKing = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "King_K", "K"), $x + 4, $y + 21, 10, 16, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 19
	$g_hPicQueenGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicQueenBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicQueenGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicQueenRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hlblQueen = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Queen_Q", "Q"), $x + 4, $y + 21, 10, 16, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 19
	$g_hPicPrinceGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicPrinceBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicPrinceGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicPrinceRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hlblPrince = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Prince_P", "P"), $x + 4, $y + 21, 10, 16, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 19
	$g_hPicWardenGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicWardenBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicWardenGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicWardenRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hlblWarden = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Warden_W", "W"), $x + 4, $y + 21, 10, 16, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 19
	$g_hPicChampionGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicChampionBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicChampionGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicChampionRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hlblChampion = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Champion_C", "C"), $x + 4, $y + 21, 10, 16, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)

	$x += 19
	$g_hPicDukeGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGrayShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicDukeBlue = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBlueShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicDukeGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnGreenShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicDukeRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRedShield, $x, $y, 16, 16)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hlblDuke = GUICtrlCreateLabel(GetTranslatedFileIni("MBR Global GUI Design Names Troops", "Duke_D", "D"), $x + 4, $y + 21, 10, 16, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)

	; Legacy Lab controls remain outside the visible panel for existing status updates.
	Local $x = -1000, $y = $y_bottom + 43
	$sTxtTip = "Laboratory status is shown by the remaining time"
	$g_hPicLabGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x - 1, $y - 1, 18, 18)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicLabGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x - 1, $y - 1, 18, 18)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicLabRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x - 1, $y - 1, 18, 18)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicLabMarker = GUICtrlCreateLabel("L", $x + 4, $y + 17, 10, 16, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLbLLabTime = GUICtrlCreateLabel("", $x + 20, $y + 2, 50, 16, $SS_LEFT)

	; Legacy Pet House controls remain outside the visible panel for existing status updates.
	Local $x = -1000, $y = $y_bottom + 76
	$sTxtTip = "Pet House status is shown by the remaining time"
	$g_hPicPetGray = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetHouse, $x - 1, $y - 1, 18, 18)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hPicPetGreen = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetHouse, $x - 1, $y - 1, 18, 18)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicPetRed = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetHouse, $x - 1, $y - 1, 18, 18)
	_GUICtrlSetTip(-1, $sTxtTip)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicPetMarker = GUICtrlCreateLabel("P", $x + 4, $y + 17, 10, 16, $SS_LEFT)
	_GUICtrlSetTip(-1, $sTxtTip)
	$g_hLbLPetTime = GUICtrlCreateLabel("", $x + 20, $y + 2, 50, 16, $SS_LEFT)

;~ Village
	Local $x = 295, $y = $y_bottom + 20
	$g_hGrpVillage = GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Bottom", "GrpVillage", "Village"), $x - 0, $y - 20, 160, 85)
	$g_hLblResultGoldNow = GUICtrlCreateLabel("", $x + 9, $y + 2, 56, 15, $SS_RIGHT)
	$g_hLblResultGoldHourNow = GUICtrlCreateLabel("", $x + 9, $y + 2, 56, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultGoldNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 69, $y, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultGoldTemp = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGold, $x + 15, $y, 16, 16)

	$g_hLblResultElixirNow = GUICtrlCreateLabel("", $x + 9, $y + 22, 56, 15, $SS_RIGHT)
	$g_hLblResultElixirHourNow = GUICtrlCreateLabel("", $x + 9, $y + 22, 56, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultElixirNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 69, $y + 20, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultElixirTemp = GUICtrlCreateIcon($g_sLibIconPath, $eIcnElixir, $x + 15, $y + 20, 16, 16)

	$g_hLblResultDENow = GUICtrlCreateLabel("", $x + 9, $y + 42, 56, 15, $SS_RIGHT)
	$g_hLblResultDEHourNow = GUICtrlCreateLabel("", $x + 9, $y + 42, 56, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultDENow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 69, $y + 40, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultDETemp = GUICtrlCreateIcon($g_sLibIconPath, $eIcnDark, $x + 15, $y + 40, 16, 16)
	$x += 75

	;trophy / runtime
	$g_hLblResultTrophyNow = GUICtrlCreateLabel("", $x + 18, $y + 2, 41, 15, $SS_RIGHT)
	$g_hPicResultTrophyNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnStrongMan, $x + 63, $y, 16, 16)
	$g_hLblResultRuntimeNow = GUICtrlCreateLabel("", $x + 14, $y + 42, 45, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultRuntimeNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnHourGlass, $x + 63, $y + 40, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)

	;builders/attacked
	$g_hLblResultBuilderNow = GUICtrlCreateLabel("", $x + 18, $y + 22, 41, 15, $SS_RIGHT)
	$g_hPicResultBuilderNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilder, $x + 63, $y + 20, 16, 16)
	$g_hLblResultAttackedHourNow = GUICtrlCreateLabel("0", $x + 18, $y + 2, 41, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultAttackedHourNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgTarget, $x + 63, $y, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)

	;gems/skipped
	$g_hLblResultGemNow = GUICtrlCreateLabel("", $x + 18, $y + 42, 41, 15, $SS_RIGHT)
	$g_hPicResultGemNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnGem, $x + 63, $y + 40, 16, 16)
	$g_hLblResultSkippedHourNow = GUICtrlCreateLabel("0", $x + 18, $y + 22, 41, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultSkippedHourNow = GUICtrlCreateIcon($g_sLibIconPath, $eIcnBldgX, $x + 63, $y + 20, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)

		$g_hLblResultOoSNow = GUICtrlCreateLabel("0", $x + 18, $y + 42, 41, 15, $SS_RIGHT)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hPicResultOoSNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnRecycle, $x + 63, $y + 40, 16, 16)
	_GUICtrlSetTip(-1, "Out of Sync (OoS)")
	GUICtrlSetState(-1, $GUI_HIDE)

; Builder Base stats
	$g_hLblResultGoldBBNow = GUICtrlCreateLabel("", $x - 66, $y + 2, 56, 15, $SS_RIGHT)
	$g_hPicResultGoldBBNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBGold, $x - 6, $y, 16, 16)
	$g_hLblResultElixirBBNow = GUICtrlCreateLabel("", $x - 66, $y + 22, 56, 15, $SS_RIGHT)
	$g_hPicResultElixirBBNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBElix, $x - 6, $y + 20, 16, 16)
	$g_hLblResultTrophyBBNow = GUICtrlCreateLabel("", $x + 18, $y + 2, 41, 15, $SS_RIGHT)
	$g_hPicResultTrophyBBNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBBTrophy, $x + 63, $y, 16, 16)
	$g_hLblResultBuilderBBNow = GUICtrlCreateLabel("", $x + 18, $y + 22, 41, 15, $SS_RIGHT)
	$g_hPicResultBuilderBBNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnMasterBuilder, $x + 63, $y + 20, 16, 16)
	$g_hLblResultCCGoldNow = GUICtrlCreateLabel("", $x - 66, $y + 42, 56, 15, $SS_RIGHT)
	$g_hPicResultCCGoldNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalGold, $x - 6, $y + 40, 16, 16)
	$g_hLblResultCCMedalNow = GUICtrlCreateLabel("", $x + 18, $y + 42, 41, 15, $SS_RIGHT)
	$g_hPicResultCCMedalNow = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnCapitalMedal, $x + 63, $y + 40, 16, 16)
	GUICtrlSetState($g_hLblResultGoldBBNow, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultGoldBBNow, $GUI_HIDE)
	GUICtrlSetState($g_hLblResultElixirBBNow, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultElixirBBNow, $GUI_HIDE)
	GUICtrlSetState($g_hLblResultTrophyBBNow, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultTrophyBBNow, $GUI_HIDE)
	GUICtrlSetState($g_hLblResultBuilderBBNow, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultBuilderBBNow, $GUI_HIDE)
	GUICtrlSetState($g_hLblResultCCGoldNow, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultCCGoldNow, $GUI_HIDE)
	GUICtrlSetState($g_hLblResultCCMedalNow, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultCCMedalNow, $GUI_HIDE)

		$g_hHelperBuilderIcon = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnBuilderApprentice, $x + 63, $y, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hHelperBuilderTimer = GUICtrlCreateLabel("", $x + 14, $y + 2, 45, 15, $SS_RIGHT)
	_GUICtrlSetTip(-1, "Builder Aprendiz")
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hHelperLabIcon = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLabAssistant, $x + 63, $y + 20, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hHelperLabTimer = GUICtrlCreateLabel("", $x + 14, $y + 22, 45, 15, $SS_RIGHT)
	_GUICtrlSetTip(-1, "Lab Assistant")
	GUICtrlSetState(-1, $GUI_HIDE)
	
	$g_hVillageLabTimer = GUICtrlCreateLabel("", $x - 66, $y + 2, 56, 15, $SS_RIGHT)
	_GUICtrlSetTip(-1, "Laboratorio")
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hVillageLabIcon = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnLaboratory, $x - 6, $y + 0, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_hVillagePetTimer = GUICtrlCreateLabel("", $x - 66, $y + 22, 56, 15, $SS_RIGHT)
	_GUICtrlSetTip(-1, "Pet House")
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hVillagePetIcon = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnPetHouse, $x - 6, $y + 20, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)

	$g_hVillageStarTimer = GUICtrlCreateLabel("", $x - 66, $y + 42, 56, 15, $SS_RIGHT)
	_GUICtrlSetTip(-1, "Star Lab")
	GUICtrlSetState(-1, $GUI_HIDE)
	$g_hVillageStarIcon = _GUICtrlCreateIcon($g_sLibIconPath, $eIcnStarLaboratory, $x - 6, $y + 40, 16, 16)
	GUICtrlSetState(-1, $GUI_HIDE)

	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlSetState($g_hPicResultGoldTemp, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultElixirTemp, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultDETemp, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultGoldNow, $GUI_SHOW)
	GUICtrlSetState($g_hPicResultElixirNow, $GUI_SHOW)
	GUICtrlSetState($g_hPicResultDENow, $GUI_SHOW)
EndFunc   ;==>CreateBottomPanel
