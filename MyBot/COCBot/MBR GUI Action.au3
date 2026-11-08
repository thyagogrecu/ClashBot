; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Action
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: cosote (2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func BotStart($bAutostartDelay = 0)
	FuncEnter(BotStart)

	If Not $g_bSearchMode Then
		If $g_hLogFile = 0 Then CreateLogFile() ; only create new log file when doesn't exist yet
		CreateAttackLogFile()
		If $g_iFirstRun = -1 Then $g_iFirstRun = 1
	EndIf
	SetLogCentered(" BOT LOG ", Default, Default, True)

	ResumeAndroid()
	CleanSecureFiles()
	;CalCostCamp()
	;CalCostSpell()
	;CalCostSiege()
	sldAdditionalClickDelay(True)

	$g_bRunState = True
	$g_bTogglePauseAllowed = True
	$g_bSkipFirstZoomout = False
	$g_bIsSearchLimit = False
	$g_bIsClientSyncError = False
	$g_bZoomoutFailureNotRestartingAnything = False
	$g_bRestart = False
	$g_bStayOnBuilderBase = False

	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	;$g_iFirstAttack = 0

	$g_bTrainEnabled = True
	$g_bDonationEnabled = True
	$g_bMeetCondStop = False
	$g_bIsClientSyncError = False
	$g_bFirstStart = True

	SaveConfig()
	readConfig()
	applyConfig(False) ; bot window redraw stays disabled!
	If ScriptRotationIsActive() Then
		Local $iScriptRotationAccount = ScriptRotationGetAccountIndex()
		$g_aiScriptRotationPhase[$iScriptRotationAccount] = ScriptRotationGetRandomPhase()
		$g_abScriptRotationPhaseInitialized[$iScriptRotationAccount] = True
		$g_aiScriptRotationAttackCount[$iScriptRotationAccount] = 0
		$g_aiScriptRotationAttackTarget[$iScriptRotationAccount] = 0
		ScriptRotationInvalidateRecipe()
	EndIf
	CreaTableDB()

	; Initial ObjEvents for the Autoit objects errors
	__ObjEventIni()

	If BitAND($g_iAndroidSupportFeature, 1 + 2) = 0 And $g_bChkBackgroundMode = True Then
		GUICtrlSetState($g_hChkBackgroundMode, $GUI_UNCHECKED)
		UpdateChkBackground() ; Invoke Event manually
		SetLog("Background Mode not supported for " & $g_sAndroidEmulator & " and has been disabled", $COLOR_ERROR)
	EndIf

	; update bottom buttons
	GUICtrlSetState($g_hBtnStart, $GUI_HIDE)
	GUICtrlSetState($g_hBtnStop, $GUI_SHOW)
	GUICtrlSetState($g_hBtnPause, $GUI_SHOW)
	GUICtrlSetState($g_hBtnResume, $GUI_HIDE)
	GUICtrlSetState($g_hBtnSearchMode, $GUI_HIDE)

	; update task bar buttons
	_ITaskBar_UpdateTBButton($g_hTblStop, $THBF_ENABLED)
	_ITaskBar_UpdateTBButton($g_hTblStart, $THBF_DISABLED)
	_ITaskBar_UpdateTBButton($g_hTblPause, $THBF_ENABLED)
	_ITaskBar_UpdateTBButton($g_hTblResume, $THBF_DISABLED)

	; update try items
	TrayItemSetText($g_hTiStartStop, GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Stop", "Stop bot"))
	TrayItemSetState($g_hTiPause, $TRAY_ENABLE)
	TrayItemSetText($g_hTiPause, GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Pause", "Pause bot"))

	EnableControls($g_hFrmBotBottom, Default, $g_aFrmBotBottomCtrlState)
	GUICtrlSetState($g_hChkBackgroundMode, $GUI_DISABLE)

	DisableGuiControls()

	SetRedrawBotWindow(True, Default, Default, Default, "BotStart")
	
	If Not ForumAuthentication() Then
		btnStop()
		Return FuncReturn()
	EndIf

	If $bAutostartDelay Then
		SetLog("Auto Starting: " & Round($bAutostartDelay / 1000, 0) & " seconds", $COLOR_ACTION)
		If _SleepStatus($bAutostartDelay) Then Return FuncReturn()
	EndIf

	$g_sClanGamesScore = "N/A"
	$g_sClanGamesTimeRemaining = "N/A"
	$YourAccScore[0] = -1
	$YourAccScore[1] = True
	$IsCGEventRunning = 0
	$g_bIsBBevent = 0
	$g_bClanGamesCompleted = 0
	CloseCGSettings()
	CloseHeroEquipment()
	$g_bFirstStartBarrel = 1
	$g_sAvailableAppBuilder = 0
	$g_sAvailableLabAssistant = 0
	$g_iBuilderBoostDiscount = 0
	$g_bFirstStartHeroStatus = 1
	For $i = 0 To 4
		$g_aiHeroUpgradeFinishDate[$i] = 0
	Next
	For $i = 0 To 4
		$g_aiHeroNeededResource[$i] = 0
	Next
	$g_aiAttackedCountPause = 0
	$g_aiAttackedCount = 0
	For $i = 0 To $g_iModeCount - 1
		$g_aiAttackedVillageCount[$i] = 0
	Next

	CleanSuperchargeTemplates()

	; wait for slot
	LockBotSlot(True)
	If $g_bRunState = False Then Return FuncReturn()

	Local $Result = False
	If WinGetAndroidHandle() = 0 Then
		$Result = OpenAndroid(False)
	EndIf
	SetDebugLog("Android Window Handle: " & WinGetAndroidHandle())
	If $g_hAndroidWindow <> 0 Then ;Is Android open?
		If Not $g_bRunState Then Return FuncReturn()
		If $g_bAndroidBackgroundLaunched = True Or AndroidControlAvailable() Then ; Really?
			If Not $Result Then
				$Result = InitiateLayout()
			EndIf
		Else
			; A wrong emulator resolution can make its render control unavailable.
			; Use the emulator-specific screen implementation through the common
			; dispatcher before reopening with the same unsupported configuration.
			SetLog($g_sAndroidEmulator & " screen mismatch; applying display settings", $COLOR_ACTION)
			$Result = RebootAndroidSetScreen()
		EndIf
		If Not $g_bRunState Then Return FuncReturn()
		Local $hWndActive = $g_hAndroidWindow
		; check if window can be activated
		If $g_bNoFocusTampering = False And $g_bAndroidBackgroundLaunched = False And $g_bAndroidEmbedded = False Then
			Local $hTimer = __TimerInit()
			$hWndActive = -1
			Local $activeHWnD = WinGetHandle("")
			While __TimerDiff($hTimer) < 1000 And $hWndActive <> $g_hAndroidWindow And Not _Sleep(100)
				$hWndActive = WinActivate($g_hAndroidWindow) ; ensure bot has window focus
			WEnd
			WinActivate($activeHWnD) ; restore current active window
		EndIf
		If Not $g_bRunState Then Return FuncReturn()
		If $hWndActive = $g_hAndroidWindow And ($g_bAndroidBackgroundLaunched = True Or AndroidControlAvailable()) Then  ; Really?
			Initiate() ; Initiate and run bot
		Else
			SetLog("Cannot use " & $g_sAndroidEmulator & ", please check log", $COLOR_ERROR)
			btnStop()
		EndIf
	Else
		SetLog("Cannot start " & $g_sAndroidEmulator & ", please check log", $COLOR_ERROR)
		btnStop()
	EndIf
	FuncReturn()
EndFunc   ;==>BotStart

Func BotStop()
	CleanSuperchargeTemplates()
	FuncEnter(BotStop)
	; release bot slot
	LockBotSlot(False)

	; release other switch accounts
	releaseProfilesMutex()

	ResumeAndroid()

	Local $bWasPaused = $g_bBotPaused
	$g_bRunState = False
	$g_bBotPaused = False
	$g_bTogglePauseAllowed = True
	$g_bRestart = False
	If $g_bIsHidden And Not $g_bAndroidEmbedded Then
		HideAndroidWindow(False, False, True, "BotStop")
		$g_bIsHidden = False
		updateBtnHideState()
	EndIf

	;WinSetState($g_hFrmBotBottom, "", @SW_DISABLE)
	Local $aCtrlState
	EnableControls($g_hFrmBotBottom, False, $g_aFrmBotBottomCtrlState)
	;$g_bFirstStart = true

	EnableGuiControls()

	;DistributorsUpdateGUI()
	AndroidBotStopEvent() ; signal android that bot is now stopping
	AndroidShieldPause()

	EnableControls($g_hFrmBotBottom, Default, $g_aFrmBotBottomCtrlState)

	; update bottom buttons
	GUICtrlSetState($g_hChkBackgroundMode, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnStart, $GUI_SHOW)
	GUICtrlSetState($g_hBtnStart, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnStop, $GUI_HIDE)
	GUICtrlSetState($g_hBtnPause, $GUI_HIDE)
	GUICtrlSetState($g_hBtnResume, $GUI_HIDE)
	If $g_iTownHallLevel > 2 Then GUICtrlSetState($g_hBtnSearchMode, $GUI_ENABLE)
	GUICtrlSetState($g_hBtnSearchMode, $GUI_SHOW)
	;GUICtrlSetState($g_hBtnMakeScreenshot, $GUI_ENABLE)

	; update task bar buttons
	_ITaskBar_UpdateTBButton($g_hTblStart, $THBF_ENABLED)
	_ITaskBar_UpdateTBButton($g_hTblStop, $THBF_DISABLED)
	_ITaskBar_UpdateTBButton($g_hTblPause, $THBF_DISABLED)
	_ITaskBar_UpdateTBButton($g_hTblResume, $THBF_DISABLED)

	; hide attack buttons if show
	GUICtrlSetState($g_hBtnAttackNowDB, $GUI_HIDE)
	GUICtrlSetState($g_hBtnAttackNowLB, $GUI_HIDE)
	GUICtrlSetState($g_hBtnAttackNowTS, $GUI_HIDE)
	HideShields(False)
	;GUICtrlSetState($g_hLblVersion, $GUI_SHOW)
	$g_bBtnAttackNowPressed = False

	; update try items
	TrayItemSetText($g_hTiStartStop, GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_Start", "Start bot"))
	TrayItemSetState($g_hTiPause, $TRAY_DISABLE)

	If Not $g_bSilentBotStopLog Then SetLogCentered(" Bot Stop ", Default, $COLOR_ACTION)
	$g_bSilentBotStopLog = False
	If Not $g_bSearchMode Then
		If Not $bWasPaused Then $g_iTimePassed += Int(__TimerDiff($g_hTimerSinceStarted))
		If ProfileSwitchAccountEnabled() And Not $bWasPaused Then $g_aiRunTime[$g_iCurAccount] += Int(__TimerDiff($g_ahTimerSinceSwitched[$g_iCurAccount]))
		;AdlibUnRegister("SetTime")
		;$g_bRestart = True

		If $g_hLogFile <> 0 Then
			FileClose($g_hLogFile)
			$g_hLogFile = 0
		EndIf

		If $g_hAttackLogFile <> 0 Then
			FileClose($g_hAttackLogFile)
			$g_hAttackLogFile = 0
		EndIf
	Else
		$g_bSearchMode = False
	EndIf

	; Ends ObjEvents for the Autoit objects errors
	__ObjEventEnds()

	ReduceBotMemory()

	; Some stop callbacks can update control states after the initial restore.
	; Make the editable GUI state the final state of a completed stop.
	EnableGuiControls(True, True)
	FuncReturn()
EndFunc   ;==>BotStop

Func BotSearchMode()
	FuncEnter(BotSearchMode)
	$g_bSearchMode = True
	$g_bRestart = False
	$g_bIsClientSyncError = False
	If $g_iFirstRun = 1 Then $g_iFirstRun = -1
	btnStart()
	checkMainScreen(False)
	If _Sleep(100) Then Return FuncReturn()
	$g_aiCurrentLoot[$eLootTrophy] = getTrophyMainScreen($aTrophies[0], $aTrophies[1]) ; get OCR to read current Village Trophies
	If _Sleep(100) Then Return FuncReturn()
	; Search Mode skips army preparation and starts normal matchmaking immediately.
	ClickAway()
	If _Sleep(100) Then Return FuncReturn()
	If IsSearchModeActive($DB) Or IsSearchModeActive($LB) Then
		If _Sleep(100) Then Return FuncReturn()
		If Not PrepareSearch($DB, True) Then Return FuncReturn()
		If $g_bOutOfGold Then Return ; Check flag for enough gold to search
		If $g_bRestart Then
			CleanSuperchargeTemplates()
			Return
		EndIf
		If _Sleep(1000) Then Return FuncReturn()
		VillageSearch()
		If $g_bOutOfGold Then Return ; Check flag for enough gold to search
		If _Sleep(100) Then Return FuncReturn()
		CleanSuperchargeTemplates()
	Else
		SetLog("Dead Base or Live Base search mode is not enabled", $COLOR_WARNING)
	EndIf
	btnStop()
	FuncReturn()
EndFunc   ;==>BotSearchMode
