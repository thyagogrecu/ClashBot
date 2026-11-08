; #FUNCTION# ====================================================================================================================
; Name ..........: checkMainScreen
; Description ...: Checks whether the pixel, located in the eyes of the builder in mainscreen, is available
;						If it is not available, it calls checkObstacles and also waitMainScreen.
; Syntax ........: checkMainScreen([$bSetLog = True], [$bBuilderBase = False], [$bNotifyPending = True])
; Parameters ....: $bSetLog: [optional] Sets a Message in Bot Log. Default is True  - $bBuilderBase: [optional] Use CheckMainScreen for Builder Base instead of normal Village. Default is False
;                  $bNotifyPending: [optional] Executes pending notification actions after validation. Default is True
; Return values .: True when the main screen is located; otherwise False
; Author ........:
; Modified ......: KnowJack (07-2015) , TheMaster1st(2015), Fliegerfaust (06-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: checkObstacles(), waitMainScreen()
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func checkMainScreen($bSetLog = Default, $bBuilderBase = Default, $bNotifyPending = True) ;Checks if in main screen
	FuncEnter(checkMainScreen)
	Return FuncReturn(_checkMainScreen($bSetLog, $bBuilderBase, $bNotifyPending))
EndFunc   ;==>checkMainScreen

Func _checkMainScreen($bSetLog = Default, $bBuilderBase = Default, $bNotifyPending = True) ;Checks if in main screen
	; Ensure Clash of Clans is running at initial startup.
	If GetAndroidProcessPID() = 0 Then
		If Not OpenCoC(True) Then Return False
		If Not __RunBotCanContinue() Then Return False
	EndIf

	If $bSetLog = Default Then $bSetLog = True
	If $bBuilderBase = Default Then $bBuilderBase = $g_bStayOnBuilderBase

	Local $i, $iErrorCount, $iCheckBeforeRestartAndroidCount, $bObstacleResult, $bContinue, $bCaptureBackendRecovered = False
	Local $aPixelToCheck = $aIsMain

	If $bSetLog Then
		SetLog("Locating Main Screen", $COLOR_INFO)
	EndIf

	If Not TestCapture() Then
		If CheckAndroidRunning(False) = False Then Return False
		getBSPos() ; Update $g_hAndroidWindow and Android Window Positions
		WinGetAndroidHandle()
		If Not $g_bChkBackgroundMode And $g_hAndroidWindow <> 0 Then
			; ensure android is top
			AndroidToFront(Default, "checkMainScreen")
		EndIf
		If $g_bAndroidAdbScreencap = False And _WinAPI_IsIconic($g_hAndroidWindow) Then WinSetState($g_hAndroidWindow, "", @SW_RESTORE)
	EndIf

	$i = 0
	$iErrorCount = 0
	$iCheckBeforeRestartAndroidCount = 20

	If $bBuilderBase Then $aPixelToCheck = $aIsOnBuilderBase
	Local $bLocated

	; Return to Main Village before screen validation.
	If Not TestCapture() And Not $bBuilderBase And _CaptureRegions() And isOnBuilderBase() Then
		; The post-defense summary can falsely match the Builder Base detector.
		; Let the regular obstacle loop close it before attempting to find the boat.
		If Not IsPostDefenseSummaryPage(False) Then
			SetLog("Builder Base Detected - Switching To Main Village", $COLOR_INFO)
			If Not SwitchBetweenBases(False, False) Then Return False
		EndIf
	EndIf

	While _CaptureRegions() And Not _checkMainScreenImage($bLocated, $aPixelToCheck)
		If Not $g_bRunState Then Return False  ; Add immediate stop check
		$i += 1
		If TestCapture() Then
			SetLog("Main Screen not Located", $COLOR_ERROR)
			ExitLoop
		EndIf
		WinGetAndroidHandle()

		$bObstacleResult = checkObstacles($bBuilderBase)
		SetDebugLog("CheckObstacles[" & $i & "] Result = " & $bObstacleResult, $COLOR_DEBUG)
		If $g_bRestart Then Return False ; Restart completed: return control to the main bot loop.

		;Arch: Arbitrary looping limit...
		If $i > 24 Then
			SetLog("Giving up and restarting everything.", $COLOR_ERROR)
			SaveConfig()
			RestartBot()
		EndIf

		$bContinue = False
		If Not $bObstacleResult Then
			If $g_bMinorObstacle Then
				$g_bMinorObstacle = False
				$bContinue = True
			Else
				If $i > $iCheckBeforeRestartAndroidCount Then
					If $g_bChkBackgroundMode And Not $g_bAndroidAdbScreencap And Not $bCaptureBackendRecovered Then
						$bCaptureBackendRecovered = True
						SetLog("Main Screen Detection Failed - Refreshing WinAPI Capture", $COLOR_ERROR)
						SaveDebugImage("checkMainScreen_WinAPIDetectionFailed", False)
						_CaptureDispose()
						WinGetAndroidHandle()
						GetAndroidControlClass(True, True)
						If @error Then SetDebugLog("WinAPI capture renderer handle refresh failed", $COLOR_ERROR)
						If _Sleep($DELAYCHECKMAINSCREEN1) Then Return
						ContinueLoop
					ElseIf $g_bAndroidAdbScreencap And $g_bAndroidAdbPortPerInstance And $g_bAndroidAdbPort And Not $bCaptureBackendRecovered Then
						$bCaptureBackendRecovered = True
						SetLog("Main Screen Detection Failed - Restarting Dedicated ADB Screencap Daemon", $COLOR_ERROR)
						SaveDebugImage("checkMainScreen_AdbDetectionFailed", False)
						AndroidAdbTerminateShellInstance()
						If KillAdbDaemon() Then ConnectAndroidAdb(False)
					Else
						SaveDebugImage("checkMainScreen_RestartCoC", False) ; why do we need to restart ?
						RestartAndroidCoC() ; Need to try to restart CoC
					EndIf
					$bContinue = True
				EndIf
			EndIf
		Else
			$g_bRestart = True
			$bContinue = True
		EndIf
		If $bContinue Then
			waitMainScreen() ; Due to differeneces in PC speed, let waitMainScreen test for CoC restart
			If Not $g_bRunState Then Return False
			If @extended Then Return SetError(1, 1, False)
			If @error Then $iErrorCount += 1
			If $iErrorCount > 2 Then
				SetLog("Unable to fix the window error", $COLOR_ERROR)
				CloseCoC(True)
				ExitLoop
			EndIf
		Else
			If _Sleep($DELAYCHECKMAINSCREEN1) Then Return
		EndIf
	WEnd

	If $bLocated Then
		; check that shared_prefs are pulled
		;If $g_bUpdateSharedPrefs And Not HaveSharedPrefs() Then PullSharedPrefs()
		ZoomOut()
	EndIf
	If Not $g_bRunState Then Return False

	If $bSetLog Then
		If $bLocated Then
			SetLog("Main Screen Located", $COLOR_SUCCESS)
		Else
			SetLog("Main Screen Not Located", $COLOR_ERROR)
		EndIf
	EndIf

	;After checkscreen dispose windows
	DisposeWindows()

	;Execute Notify Pending Actions
	If $bNotifyPending Then NotifyPendingActions()

	Return $bLocated
EndFunc   ;==>_checkMainScreen

Func _checkMainScreenImage(ByRef $bLocated, $aPixelToCheck, $bNeedCaptureRegion = $g_bNoCapturePixel)
	$bLocated = _CheckPixel($aPixelToCheck, $bNeedCaptureRegion) And Not checkObstacles_Network(False, False)
	If $bLocated Then
		checkObstacles_Network(False, False, True) ; Confirmed main screen ends the current recovery sequence.
		checkChatTabPixel()
	EndIf
	Return $bLocated
EndFunc   ;==>_checkMainScreenImage

Func checkChatTabPixel()
	SetDebugLog("Checking chat tab pixel exists to ensure images have loaded correctly")
	If _Sleep(500) Then Return
	Local $aChatTabPixel = decodeSingleCoord(findImage("ChatTabPixel", $g_sImgChatTabPixel, GetDiamondFromRect2(5, 285 + $g_iMidOffsetY, 30, 330 + $g_iMidOffsetY), 1, True))
	If UBound($aChatTabPixel) = 2 Then
		SetDebugLog("ChatTabPixel found", $COLOR_SUCCESS)
		Return True
	Else
		If Not $g_bRunState Then Return False
		SetDebugLog("ChatTabPixel not found (account may not be in a clan)", $COLOR_DEBUG)
	EndIf
	Return False
EndFunc   ;==>checkChatTabPixel
