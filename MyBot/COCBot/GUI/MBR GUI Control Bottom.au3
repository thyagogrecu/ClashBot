; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), KnowJack(July 2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aFrmBotBottomCtrlState[1][2] = [[0, False]], $g_hFrmBotEmbeddedShield = 0, $g_hFrmBotEmbeddedMouse = 0, $g_hFrmBotEmbeddedGraphics = 0

Func Initiate()
	WinGetAndroidHandle()
	If $g_hAndroidWindow <> 0 And ($g_bAndroidBackgroundLaunched = True Or AndroidControlAvailable()) Then
		SetLogCentered(" " & $g_sBotTitle & " Powered by MyBot.run ", "~", $COLOR_DEBUG)

		Local $Compiled = @ScriptName & (@Compiled ? " Executable" : " Script")
		SetLog($Compiled & " running on " & @OSVersion & " " & @OSServicePack & " " & @OSArch)

		If _Sleep($DELAYRESPOND) Then Return

		Local $sGameVersion = GetCoCAppVersion()
		If Not @error Then SetLog(">>  Clash of Clans Game App Version = " & $sGameVersion, $COLOR_DEBUG)

		If Not $g_bSearchMode Then
			SetLogCentered(" Bot Start ", Default, $COLOR_SUCCESS)
		Else
			SetLogCentered(" Search Mode Start ", Default, $COLOR_SUCCESS)
		EndIf
		SetLogCentered("  Current Profile: " & $g_sProfileCurrentName & " ", "-", $COLOR_INFO)
		If $g_bDebugSetLog Or $g_bDebugOcr Or $g_bDebugRedArea Or $g_bDevMode Or $g_bDebugImageSave Or $g_bDebugBuildingPos Or $g_bDebugOCRdonate Or $g_bDebugAttackCSV Or $g_bDebugAndroid Then
			SetLogCentered(" Warning Debug Mode Enabled! ", "-", $COLOR_ERROR)
			SetLog("      SetLog: " & $g_bDebugSetLog, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("     Android: " & $g_bDebugAndroid, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("         OCR: " & $g_bDebugOcr, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("     RedArea: " & $g_bDebugRedArea, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   ImageSave: " & $g_bDebugImageSave, $COLOR_ERROR, "Lucida Console", 8)
			SetLog(" BuildingPos: " & $g_bDebugBuildingPos, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   OCRDonate: " & $g_bDebugOCRdonate, $COLOR_ERROR, "Lucida Console", 8)
			SetLog("   AttackCSV: " & $g_bDebugAttackCSV, $COLOR_ERROR, "Lucida Console", 8)
			SetLogCentered(" Warning Debug Mode Enabled! ", "-", $COLOR_ERROR)
		EndIf

		$g_bInitiateSwitchAcc = True
		$g_sLabUpgradeTime = ""
		$g_sPetUpgradeTime = ""
		$g_sBSmithUpgradeTime = ""
		For $i = 0 To $eLootCount - 1
			$g_abFullStorage[$i] = False
		Next

;~ 		If $g_bNotifyDeleteAllPushesOnStart Then _DeletePush()

		If Not $g_bSearchMode Then
			$g_hTimerSinceStarted = __TimerInit()
		EndIf

		AndroidBotStartEvent() ; signal android that bot is now running
		If Not $g_bRunState Then Return

		If Not $g_bSearchMode Then
			If $g_bRestarted Then
				$g_bRestarted = False
				IniWrite($g_sProfileConfigPath, "general", "Restarted", 0)
				PushMsg("Restarted")
			EndIf
		EndIf
		If Not $g_bRunState Then Return

		AndroidShield("Initiate", True)
		Local $bMainVillageConfirmed = checkMainScreen()
		If Not $g_bRunState Then Return

		ZoomOut()
		If Not $g_bRunState Then Return
		If $g_bBotLaunchOption_HideAndroid And Not $g_bAndroidEmbedded Then
			$g_bIsHidden = HideAndroidWindow(True, Default, Default, "AutoHideAndroid")
			If Not $g_bIsHidden Then SetLog("Unable to hide " & $g_sAndroidEmulator & " window", $COLOR_ERROR)
			updateBtnHideState()
		EndIf

		If Not $g_bSearchMode Then
			InitiateSwitchAcc($bMainVillageConfirmed)
			If Not $g_bRunState Then Return

			BotDetectFirstTime()
			If Not $g_bRunState Then Return

			If $g_bCheckGameLanguage Then TestLanguage()
			If Not $g_bRunState Then Return

			Do
				$g_bRestartRunBot = False
				runBot()
				If $g_bRestartRunBot Then $g_bRestart = False
			Until Not $g_bRestartRunBot Or Not $g_bRunState
		EndIf
	Else
		SetLog("Not In Game!", $COLOR_ERROR)
		;		$g_bRunState = True
		btnStop()
	EndIf
EndFunc   ;==>Initiate

Func InitiateLayout()

	Local $AdjustScreenIfNecessarry = True
	WinGetAndroidHandle()
	Local $BSsize = getAndroidPos()

	If IsArray($BSsize) Then ; Is Android Client Control available?

		Local $BSx = $BSsize[2]
		Local $BSy = $BSsize[3]

		SetDebugLog("InitiateLayout: " & $g_sAndroidTitle & " Android-ClientSize: " & $BSx & " x " & $BSy, $COLOR_INFO)

		If Not CheckScreenAndroid($BSx, $BSy) Then ; Is Client size now correct?
			If $AdjustScreenIfNecessarry = True Then
				Local $MsgRet = $IDOK
				;If _Sleep(3000) Then Return False
				;Local $MsgRet = MsgBox(BitOR($MB_OKCANCEL, $MB_SYSTEMMODAL), "Change the resolution and restart " & $g_sAndroidEmulator & "?", _
				;	"Click OK to adjust the screen size of " & $g_sAndroidEmulator & " and restart the emulator." & @CRLF & _
				;	"If your " & $g_sAndroidEmulator & " really has the correct size (" & $g_iDEFAULT_WIDTH & " x " & $g_iDEFAULT_HEIGHT & "), click CANCEL." & @CRLF & _
				;	"(Automatically Cancel in 15 Seconds)", 15)

				If $MsgRet = $IDOK Then
					Return RebootAndroidSetScreen() ; recursive call!
					;Return "RebootAndroidSetScreen()"
				EndIf
			Else
				SetLog("Cannot use " & $g_sAndroidEmulator & ".", $COLOR_ERROR)
				SetLog("Please set screen size manually to " & $g_iAndroidClientWidth & " x " & $g_iAndroidClientHeight, $COLOR_ERROR)
				btnStop()
				Return False
			EndIf
		EndIf

		DisposeWindows()
		Return True

	EndIf

	Return False

EndFunc   ;==>InitiateLayout

Func chkBackground()
	If IsDeclared("g_hChkBackgroundMode") Then
		UpdateChkBackground()
		; update Android Window always on top
		AndroidToFront(Default, "chkBackground")
	EndIf
EndFunc   ;==>chkBackground

Func UpdateChkBackground()
	If GUICtrlRead($g_hChkBackgroundMode) = $GUI_CHECKED Then
		$g_bChkBackgroundMode = True
		updateBtnHideState($GUI_ENABLE)
	Else
		$g_bChkBackgroundMode = False
		updateBtnHideState($GUI_DISABLE)
	EndIf
	If CheckDpiAwareness() Then
		; DPI awareness changed
	EndIf
EndFunc   ;==>UpdateChkBackground

Func DisableChkBackground()
	GUICtrlSetState($g_hChkBackgroundMode, $GUI_UNCHECKED)
	UpdateChkBackground()
EndFunc   ;==>DisableChkBackground

Func btnStart()
	; decide when to run
	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	Local $bRunNow = $g_iBotAction <> $eBotNoAction
	If $bRunNow Then
		BotStart()
	Else
		$g_iBotAction = $eBotStart
	EndIf
	$g_iActualTrainSkip = 0
EndFunc   ;==>btnStart

Func btnStop($bNotifyTelegram = True, $bSilentLog = False)
	If $bSilentLog Then $g_bSilentBotStopLog = True
	If $g_bRunState Then
		; Mark the bot stopped before any network call so re-entrant stop requests
		; cannot send the same notification more than once.
		$g_bRunState = False ; Exit BotStart()
		If $bNotifyTelegram And $g_bNotifyTGEnable And $g_sNotifyTGToken <> "" Then
			NotifyPushToTelegram($g_sNotifyOrigin & " | Bot Stop")
		EndIf
		; Always invoked in MyBot.run.au3
		EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	EndIf
	$g_iBotAction = $eBotStop
EndFunc   ;==>btnStop

Func btnSearchMode()
	; decide when to run
	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	Local $bRunNow = $g_iBotAction <> $eBotNoAction
	If $bRunNow Then
		BotSearchMode()
	Else
		$g_iBotAction = $eBotSearchMode
	EndIf
EndFunc   ;==>btnSearchMode

Func btnPause($bRunNow = True)
	TogglePause()
EndFunc   ;==>btnPause

Func btnResume()
	If Not $g_bBotPaused Then Return
	TogglePause()
EndFunc   ;==>btnResume

Func btnAttackNowDB()
	If $g_bRunState Then
		$g_bBtnAttackNowPressed = True
		$g_iMatchMode = $DB
		GUICtrlSetState($g_hBtnAttackNowDB, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnAttackNowDB

Func btnAttackNowLB()
	If $g_bRunState Then
		$g_bBtnAttackNowPressed = True
		$g_iMatchMode = $LB
		GUICtrlSetState($g_hBtnAttackNowLB, $GUI_DISABLE)
	EndIf
EndFunc   ;==>btnAttackNowLB

Func DisableBBSpam($sReason = "")
	$g_bBBSpamEnabled = False
	$g_bBBSpamRunning = False
	GUICtrlSetData($g_hbtnBBSpam, "BBSpam")
	GUICtrlSetBkColor($g_hbtnBBSpam, 0xFFB6C1) ; Light pink/red background
	
	If $sReason = "Resources maxed out" Then $g_bBBSpamDisabledDueToFull = True
	
	If $sReason <> "" Then
		SetLog("» BB SPAM DISABLED: " & StringUpper($sReason) & " «", $COLOR_INFO)
	Else
		SetLog("» BB SPAM MODE DISABLED «", $COLOR_INFO)
	EndIf
EndFunc   ;==>DisableBBSpam

Func DisableCCSpam($sReason = "")
	$g_bCCSpamEnabled = False
	$g_bCCSpamRunning = False
	GUICtrlSetData($g_hbtnCCSpam, "CCSpam")
	GUICtrlSetBkColor($g_hbtnCCSpam, 0xFFB6C1) ; Light pink/red background

	If $sReason <> "" Then
		SetLog("» CC SPAM DISABLED: " & StringUpper($sReason) & " «", $COLOR_INFO)
	Else
		SetLog("» CC SPAM MODE DISABLED «", $COLOR_INFO)
	EndIf
EndFunc   ;==>DisableCCSpam

Func DisableRushAttack($sReason = "")
	$g_bRushAttackEnabled = False
	$g_bRushAttackReenableAfterSwitch = ($sReason = "Halt attack condition reached" Or $sReason = "Out of gold")
	GUICtrlSetData($g_hBtnRushAttack, "Rush")
	GUICtrlSetBkColor($g_hBtnRushAttack, 0xFFB6C1)

	If $sReason <> "" Then
		SetLog("» RUSH ATTACK DISABLED: " & StringUpper($sReason) & " «", $COLOR_INFO)
	Else
		SetLog("» RUSH ATTACK MODE DISABLED «", $COLOR_INFO)
	EndIf
EndFunc   ;==>DisableRushAttack

;~ Hide Android Window again without overwriting $botPos[0] and [1]
Func reHide()
	WinGetAndroidHandle()
	If $g_bIsHidden And $g_hAndroidWindow <> 0 And Not $g_bAndroidEmbedded Then
		SetDebugLog("Hide " & $g_sAndroidEmulator & " Window after restart")
		Local $Result = HideAndroidWindow(True, Default, Default, "reHide") ;WinMove($g_hAndroidWindow, "", -32000, -32000)
		If Not $Result Then
			$g_bIsHidden = False
			SetLog("Unable to hide " & $g_sAndroidEmulator & " window", $COLOR_ERROR)
		EndIf
		updateBtnHideState()
		Return $Result
	EndIf
	Return 0
EndFunc   ;==>reHide

Func updateBtnHideState($newState = $GUI_ENABLE)
	If $g_hBtnHide = 0 Then Return
	Local $hideState = GUICtrlGetState($g_hBtnHide)
	Local $newHideState = ($g_bAndroidEmbedded = True ? $GUI_DISABLE : $newState)
	If $hideState <> $newHideState Then GUICtrlSetState($g_hBtnHide, $newHideState)
	Local $sText
	If $g_bIsHidden Then
		$sText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_btnHide_False", "Show")
	Else
		$sText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_btnHide_True", "Hide")
	EndIf
	If GUICtrlRead($g_hBtnHide) <> $sText Then
		; update text
		GUICtrlSetData($g_hBtnHide, $sText)
	EndIf
EndFunc   ;==>updateBtnHideState

Func btnHide()
	If $g_bAndroidEmbedded Then
		updateBtnHideState($GUI_DISABLE)
		Return
	EndIf
	WinGetAndroidHandle()
	If Not IsHWnd($g_hAndroidWindow) Then
		$g_bIsHidden = False
		updateBtnHideState($GUI_DISABLE)
		Return
	EndIf
	Local $bHide = Not $g_bIsHidden
	If HideAndroidWindow($bHide, Default, Default, "btnHide") Then
		$g_bIsHidden = $bHide
	Else
		SetLog("Unable to " & ($bHide ? "hide" : "show") & " " & $g_sAndroidEmulator & " window", $COLOR_ERROR)
	EndIf
	updateBtnHideState()
EndFunc   ;==>btnHide

Func updateBtnEmbed()
	If $g_hBtnEmbed = 0 Then Return False
	UpdateFrmBotStyle()
	WinGetAndroidHandle()
	Local $state = GUICtrlGetState($g_hBtnEmbed)
	If Not IsHWnd($g_hAndroidWindow) Or $g_bAndroidBackgroundLaunched = True Or $g_bAndroidEmbed = False Or $g_iGuiMode <> 1 Then
		If $state <> $GUI_DISABLE Then GUICtrlSetState($g_hBtnEmbed, $GUI_DISABLE)
		updateBtnHideState()
		Return False
	EndIf

	Local $text = GUICtrlRead($g_hBtnEmbed)
	Local $newText
	If $g_bAndroidEmbedded Then
		$newText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_AndroidEmbedded_False", "Undock")
	Else
		$newText = GetTranslatedFileIni("MBR GUI Control Bottom", "Func_AndroidEmbedded_True", "Dock")
	EndIf
	If $text <> $newText Then GUICtrlSetData($g_hBtnEmbed, $newText)
	If $state <> $GUI_ENABLE Then GUICtrlSetState($g_hBtnEmbed, $GUI_ENABLE)
	; also update hide button
	updateBtnHideState()
	Return True
EndFunc   ;==>updateBtnEmbed

Func btnEmbed()
	ResumeAndroid()
	WinGetAndroidHandle()
	If Not IsHWnd($g_hAndroidWindow) Then
		updateBtnEmbed()
		Return SetError(0, 0, 0)
	EndIf
	WinGetPos($g_hAndroidWindow)
	If @error <> 0 Then Return SetError(0, 0, 0)
	AndroidEmbed(Not $g_bAndroidEmbedded)
EndFunc   ;==>btnEmbed

Func btnMakeScreenshot()
	If $g_bRunState Then
		; call with flag when bot is running to execute on _sleep() idle
		$g_bMakeScreenshotNow = True
	Else
		; call directly when bot is stopped
		If $g_bScreenshotPNGFormat = False Then
			MakeScreenshot($g_sProfileTempPath, "jpg")
		Else
			MakeScreenshot($g_sProfileTempPath, "png")
		EndIf
	EndIf
EndFunc   ;==>btnMakeScreenshot

Func GetFont()
	Local $i, $sText = "", $DefaultFont
	$DefaultFont = __EMB_GetDefaultFont()
	For $i = 0 To UBound($DefaultFont) - 1
		$sText &= " $DefaultFont[" & $i & "]= " & $DefaultFont[$i] & ", "
	Next
	SetLog($sText, $COLOR_DEBUG)
EndFunc   ;==>GetFont

Func btnVillageStat($source = "")

	If $g_iFirstRun = 0 And $g_bRunState And Not $g_bBotPaused Then SetTime(True)
	If $source = "UpdateStats" Then
		$g_iVillageStatsPage = 0
	ElseIf $source = "Previous" Then
		$g_iVillageStatsPage = Mod($g_iVillageStatsPage + 3, 4)
	Else
		$g_iVillageStatsPage = Mod($g_iVillageStatsPage + 1, 4)
	EndIf
	_SetVillageStatsPage()
EndFunc   ;==>btnVillageStat

Func _SetVillageStatsPage()
	GUICtrlSetState($g_hPicResultGoldTemp, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultElixirTemp, $GUI_HIDE)
	GUICtrlSetState($g_hPicResultDETemp, $GUI_HIDE)
	_UpdateHelperTimers()
	Local $aHelpers = [$g_hLblResultRuntimeNow, $g_hPicResultRuntimeNow, $g_hHelperBuilderTimer, $g_hHelperLabTimer, $g_hHelperBuilderIcon, $g_hHelperLabIcon, $g_hVillageLabTimer, $g_hVillagePetTimer, $g_hVillageStarTimer, $g_hVillageLabIcon, $g_hVillagePetIcon, $g_hVillageStarIcon]
	For $i = 0 To UBound($aHelpers) - 1
		GUICtrlSetState($aHelpers[$i], $g_iVillageStatsPage = 3 ? $GUI_SHOW : $GUI_HIDE)
	Next
	Local $aLabels = [$g_hLblResultGoldNow, $g_hLblResultElixirNow, $g_hLblResultDENow, $g_hLblResultTrophyNow, $g_hLblResultBuilderNow, $g_hLblResultGemNow, _
			$g_hLblResultGoldHourNow, $g_hLblResultElixirHourNow, $g_hLblResultDEHourNow, $g_hLblResultAttackedHourNow, $g_hLblResultSkippedHourNow, $g_hLblResultOoSNow, _
			$g_hLblResultGoldBBNow, $g_hLblResultElixirBBNow, $g_hLblResultTrophyBBNow, $g_hLblResultBuilderBBNow, $g_hLblResultCCGoldNow, $g_hLblResultCCMedalNow]
	Local $aIcons = [$g_hPicResultTrophyNow, $g_hPicResultBuilderNow, $g_hPicResultGemNow, $g_hPicResultAttackedHourNow, $g_hPicResultSkippedHourNow, $g_hPicResultOoSNow, _
			$g_hPicResultGoldBBNow, $g_hPicResultElixirBBNow, $g_hPicResultTrophyBBNow, $g_hPicResultBuilderBBNow, $g_hPicResultCCGoldNow, $g_hPicResultCCMedalNow]
	For $i = 0 To UBound($aLabels) - 1
		GUICtrlSetState($aLabels[$i], $GUI_HIDE)
	Next
	For $i = 0 To UBound($aIcons) - 1
		GUICtrlSetState($aIcons[$i], $GUI_HIDE)
	Next

	Switch $g_iVillageStatsPage
		Case 0
			For $i = 0 To 5
				GUICtrlSetState($aLabels[$i], $GUI_SHOW)
			Next
			GUICtrlSetState($g_hPicResultTrophyNow, $GUI_SHOW)
			GUICtrlSetState($g_hPicResultBuilderNow, $GUI_SHOW)
			GUICtrlSetState($g_hPicResultGemNow, $GUI_SHOW)
		Case 1
			For $i = 6 To 11
				If $i < 9 Or $g_iFirstRun = 0 Then GUICtrlSetState($aLabels[$i], $GUI_SHOW)
			Next
			GUICtrlSetState($g_hPicResultOoSNow, $GUI_SHOW)
			GUICtrlSetState($g_hPicResultAttackedHourNow, $GUI_SHOW)
			GUICtrlSetState($g_hPicResultSkippedHourNow, $GUI_SHOW)
		Case 2
			For $i = 12 To UBound($aLabels) - 1
				GUICtrlSetState($aLabels[$i], $GUI_SHOW)
			Next
			For $i = 6 To UBound($aIcons) - 1
				GUICtrlSetState($aIcons[$i], $GUI_SHOW)
			Next
	EndSwitch

	If $g_iVillageStatsPage < 2 Then
		GUICtrlSetState($g_hPicResultGoldNow, $GUI_SHOW)
		GUICtrlSetState($g_hPicResultElixirNow, $GUI_SHOW)
		GUICtrlSetState($g_hPicResultDENow, $GUI_SHOW)
	Else
		GUICtrlSetState($g_hPicResultGoldNow, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultElixirNow, $GUI_HIDE)
		GUICtrlSetState($g_hPicResultDENow, $GUI_HIDE)
	EndIf
EndFunc   ;==>_SetVillageStatsPage

Func _UpdateVillageBuilderBaseStats()
	GUICtrlSetData($g_hLblResultGoldBBNow, $g_aiCurrentLootBB[$eLootGoldBB] = 0 ? "" : _NumberFormat($g_aiCurrentLootBB[$eLootGoldBB], True))
	GUICtrlSetData($g_hLblResultElixirBBNow, $g_aiCurrentLootBB[$eLootElixirBB] = 0 ? "" : _NumberFormat($g_aiCurrentLootBB[$eLootElixirBB], True))
	GUICtrlSetData($g_hLblResultTrophyBBNow, $g_aiCurrentLootBB[$eLootTrophyBB] = 0 ? "" : _NumberFormat($g_aiCurrentLootBB[$eLootTrophyBB], True))
	GUICtrlSetData($g_hLblResultBuilderBBNow, $g_iTotalBuilderCountBB = 0 ? "" : $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB)
	Local $bCapitalReportAvailable = $g_iLootCCGold > 0 Or $g_iLootCCMedal > 0 Or $g_iCCTrophies > 0
	GUICtrlSetData($g_hLblResultCCGoldNow, $bCapitalReportAvailable ? _NumberFormat($g_iLootCCGold, True) : "")
	GUICtrlSetData($g_hLblResultCCMedalNow, $bCapitalReportAvailable ? _NumberFormat($g_iLootCCMedal, True) : "")
EndFunc   ;==>_UpdateVillageBuilderBaseStats

Func EnableGuiControls($bOptimizedRedraw = True, $bForce = False)
	Return ToggleGuiControls(True, $bOptimizedRedraw, $bForce)
EndFunc   ;==>EnableGuiControls

Func DisableGuiControls($bOptimizedRedraw = True, $bForce = False)
	If $g_bUnlockMode Then
		If Not $g_bGuiControlsEnabled Then Return ToggleGuiControls(True, $bOptimizedRedraw, True)
		Return
	EndIf
	Return ToggleGuiControls(False, $bOptimizedRedraw, $bForce)
EndFunc   ;==>DisableGuiControls

Func EnforceGuiControlsDisabled($bOptimizedRedraw = True)
	If $g_bUnlockMode Or $g_bGuiControlsEnabled Or $g_iGuiMode <> 1 Then Return
	If $bOptimizedRedraw Then Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "EnforceGuiControlsDisabled")
	$g_bGUIControlDisabled = True
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		If $i >= $g_hClanGamesTV And $i < $g_hChkForceAttackOnClanGames Then ContinueLoop
		If BitAND(GUICtrlGetState($i), $GUI_ENABLE) Then GUICtrlSetState($i, $GUI_DISABLE)
	Next
	ControlDisable("", "", $g_hCmbGUILanguage)
	$g_bGUIControlDisabled = False
	If $bOptimizedRedraw Then SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "EnforceGuiControlsDisabled")
EndFunc   ;==>EnforceGuiControlsDisabled

Func ToggleGuiControls($bEnabled, $bOptimizedRedraw = True, $bForce = False)
	If Not $bForce And $g_bGuiControlsEnabled = $bEnabled Then Return
	$g_bGuiControlsEnabled = $bEnabled
	If $g_iGuiMode <> 1 Then Return
	If $bOptimizedRedraw Then Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "ToggleGuiControls")
	If Not $bEnabled Then
		SetDebugLog("Disable GUI Controls")
	Else
		SetDebugLog("Enable GUI Controls")
	EndIf
	$g_bGUIControlDisabled = True
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		If $i >= $g_hClanGamesTV And $i < $g_hChkForceAttackOnClanGames Then ContinueLoop
		If Not $bEnabled Then
			; Save state of all controls on tabs
			$g_aiControlPrevState[$i] = BitAND(GUICtrlGetState($i), $GUI_ENABLE)
			If $g_aiControlPrevState[$i] Then GUICtrlSetState($i, $GUI_DISABLE)
		Else
			; Restore previous state of controls
			If $g_aiControlPrevState[$i] Then GUICtrlSetState($i, $g_aiControlPrevState[$i])
			If $i >= $g_hChkForceAttackOnClanGames And $i <= $g_hBtnCGSettingsClose Then GUICtrlSetState($i, $GUI_ENABLE)
		EndIf
	Next
	If Not $bEnabled Then
		ControlDisable("", "", $g_hCmbGUILanguage)
	Else
		ControlEnable("", "", $g_hCmbGUILanguage)
	EndIf
	$g_bGUIControlDisabled = False
	If $bOptimizedRedraw Then SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "ToggleGuiControls")
EndFunc   ;==>ToggleGuiControls

Func GetCoCAppVersion()
	Local $sCMD = "dumpsys package " & $g_sAndroidGamePackage & " | grep versionName"  ;Get info from APK and grep version number line from text string
	Local $sReturn = AndroidAdbSendShellCommand($sCMD) ; Grep return string = versionName=15.352.8
	If @error Then
		SetLog("Failed to get Clash of Clans version, Result= " & $sReturn, $COLOR_ERROR)
		SetError(1)
		Return
	EndIf
	Local $sCleanReturn = StringStripWS($sReturn, $STR_STRIPALL)  ; strip white space
	SetDebugLog("Clash of Clans Game App = " & $sCleanReturn)
	Return StringTrimLeft($sCleanReturn, 12)  ; return version number string
EndFunc   ;==>GetCoCAppVersion

Func ToggleBBSpam()
	$g_bBBSpamEnabled = Not $g_bBBSpamEnabled
	$g_bBBSpamDisabledDueToFull = False
	$g_bRushAttackReenableAfterSwitch = False
	
	If $g_bBBSpamEnabled Then
		; Mutual exclusion: disable CC Spam if active
		If $g_bCCSpamEnabled Then
			$g_bCCSpamEnabled = False
			$g_bCCSpamRunning = False
			GUICtrlSetBkColor($g_hbtnCCSpam, 0xFFB6C1)
		EndIf
		If $g_bRushAttackEnabled Then
			$g_bRushAttackEnabled = False
			GUICtrlSetBkColor($g_hBtnRushAttack, 0xFFB6C1)
		EndIf
		; Activate BB Spam mode
		GUICtrlSetData($g_hbtnBBSpam, "BBSpam")
		GUICtrlSetBkColor($g_hbtnBBSpam, 0x90EE90) ; Light green background
		SetLog("» BB SPAM MODE ENABLED «", $COLOR_INFO)
		$g_iBBSpamCycles = 0
		$g_bBBSpamRunning = False
		
		; Start bot if not already running
		If Not $g_bRunState Then
			btnStart()
		EndIf
	Else
		; Deactivate BB Spam mode
		GUICtrlSetData($g_hbtnBBSpam, "BBSpam")
		GUICtrlSetBkColor($g_hbtnBBSpam, 0xFFB6C1) ; Light pink/red background
		SetLog("» BB SPAM MODE DISABLED «", $COLOR_INFO)
		$g_bBBSpamRunning = False
	EndIf
EndFunc   ;==>ToggleBBSpam

Func ToggleCCSpam()
	$g_bCCSpamEnabled = Not $g_bCCSpamEnabled

	If $g_bCCSpamEnabled Then
		$g_bBBSpamDisabledDueToFull = False
		$g_bRushAttackReenableAfterSwitch = False
		; Mutual exclusion: disable BB Spam if active
		If $g_bBBSpamEnabled Then
			$g_bBBSpamEnabled = False
			$g_bBBSpamRunning = False
			GUICtrlSetBkColor($g_hbtnBBSpam, 0xFFB6C1)
		EndIf
		If $g_bRushAttackEnabled Then
			$g_bRushAttackEnabled = False
			GUICtrlSetBkColor($g_hBtnRushAttack, 0xFFB6C1)
		EndIf
		; Activate CC Spam mode
		GUICtrlSetData($g_hbtnCCSpam, "CCSpam")
		GUICtrlSetBkColor($g_hbtnCCSpam, 0x90EE90) ; Light green background
		SetLog("» CC SPAM MODE ENABLED «", $COLOR_INFO)
		$g_bCCSpamRunning = False

		; Start bot if not already running
		If Not $g_bRunState Then
			btnStart()
		EndIf
	Else
		; Deactivate CC Spam mode
		GUICtrlSetData($g_hbtnCCSpam, "CCSpam")
		GUICtrlSetBkColor($g_hbtnCCSpam, 0xFFB6C1) ; Light pink/red background
		SetLog("» CC SPAM MODE DISABLED «", $COLOR_INFO)
		$g_bCCSpamRunning = False
	EndIf
EndFunc   ;==>ToggleCCSpam

Func ToggleRushAttack()
	$g_bRushAttackEnabled = Not $g_bRushAttackEnabled
	$g_bRushAttackReenableAfterSwitch = False

	If $g_bRushAttackEnabled Then
		$g_bBBSpamDisabledDueToFull = False
		If $g_bBBSpamEnabled Then
			$g_bBBSpamEnabled = False
			$g_bBBSpamRunning = False
			GUICtrlSetBkColor($g_hbtnBBSpam, 0xFFB6C1)
		EndIf
		If $g_bCCSpamEnabled Then
			$g_bCCSpamEnabled = False
			$g_bCCSpamRunning = False
			GUICtrlSetBkColor($g_hbtnCCSpam, 0xFFB6C1)
		EndIf

		GUICtrlSetData($g_hBtnRushAttack, "Rush")
		GUICtrlSetBkColor($g_hBtnRushAttack, 0x90EE90)
		SetLog("» RUSH ATTACK MODE ENABLED «", $COLOR_INFO)
		$g_bRushAttackRunning = False

		If Not $g_bRunState Then btnStart()
	Else
		GUICtrlSetData($g_hBtnRushAttack, "Rush")
		GUICtrlSetBkColor($g_hBtnRushAttack, 0xFFB6C1)
		SetLog("» RUSH ATTACK MODE DISABLED «", $COLOR_INFO)
	EndIf
EndFunc   ;==>ToggleRushAttack

; #FUNCTION# ===========================================================================================================
; Name ..........: _UpdateHelperTimers
; Description ...: Displays cooldown dates read by HelperHut.
; ======================================================================================================================
Func _UpdateHelperTimers()
	GUICtrlSetData($g_hVillageLabTimer, _VillageUpgradeTimerText($g_sLabUpgradeTime))
	GUICtrlSetData($g_hVillagePetTimer, _VillageUpgradeTimerText($g_sPetUpgradeTime))
	GUICtrlSetData($g_hVillageStarTimer, _VillageUpgradeTimerText($g_sStarLabUpgradeTime))
	GUICtrlSetData($g_hHelperBuilderTimer, _HelperTimerText($g_sAvailableAppBuilder))
	GUICtrlSetData($g_hHelperLabTimer, _HelperTimerText($g_sAvailableLabAssistant))
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _HelperTimerText
; Description ...: Formats a helper availability date as remaining time.
; ======================================================================================================================
Func _HelperTimerText($sAvailable)
	If Not _DateIsValid($sAvailable) Then Return ""
	Local $iSeconds = _DateDiff("s", _NowCalc(), $sAvailable)
	If $iSeconds <= 0 Then Return "Disponivel"
	Return StringFormat("%02i:%02i:%02i", Int($iSeconds / 3600), Mod(Int($iSeconds / 60), 60), Mod($iSeconds, 60))
EndFunc
; #FUNCTION# ===========================================================================================================
; Name ..........: _VillageUpgradeTimerText
; Description ...: Formats remaining upgrade time for the village panel.
; ======================================================================================================================
Func _VillageUpgradeTimerText($sFinish)
	If Not _DateIsValid($sFinish) Then Return ""
	Local $iSeconds = _DateDiff("s", _NowCalc(), $sFinish)
	If $iSeconds <= 0 Then Return ""
	If $iSeconds >= 86400 Then Return StringFormat("%ud %02i:%02i", Int($iSeconds / 86400), Mod(Int($iSeconds / 3600), 24), Mod(Int($iSeconds / 60), 60))
	Return StringFormat("%02i:%02i:%02i", Int($iSeconds / 3600), Mod(Int($iSeconds / 60), 60), Mod($iSeconds, 60))
EndFunc