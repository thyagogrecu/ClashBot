;#FUNCTION# ====================================================================================================================
; Name ..........: RestartBot
; Description ...: Restart the bot
; Syntax ........: RestartBot([$bCloseAndroid, [$bAutostart, [$bImmediateExit, [$iTargetGuiMode]]]])
; Parameters ....: $bCloseAndroid    - [Optional] Default True closed Android
;                  $bAutostart       - [optional] Default True autostart bot (run state)
;                  $bImmediateExit   - [optional] Default False; exit as soon as the replacement process is launched
;                  $iTargetGuiMode   - [optional] Default keeps command line; 1 removes Mini GUI launch options
; Return values .: True when restart was launched; False when restart preparation or launch failed
; Author ........: MyBot.run team
; Modified ......: Cosote (Feb-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func RestartBot($bCloseAndroid = True, $bAutostart = True, $bImmediateExit = False, $iTargetGuiMode = Default)
	Static $bRestartActive = False
	If $bRestartActive Then Return True
	$bRestartActive = True

	Local $bPreviousRunState = $g_bRunState
	Local $bPreviousPausedState = $g_bBotPaused
	SetDebugLog("Restart " & $g_sBotTitle)
	Local $sCmdLine = ProcessGetCommandLine(@AutoItPID)
	If @error <> 0 Then
		SetLog("Cannot prepare to restart " & $g_sBotTitle & ", error code " & @error, $COLOR_RED)
		If $bImmediateExit Then
			$g_bRunState = $bPreviousRunState
			$g_bBotPaused = $bPreviousPausedState
		EndIf
		$bRestartActive = False
		Return SetError(1, 0, False)
	EndIf

	If $iTargetGuiMode = 1 Then
		$sCmdLine = StringRegExpReplace($sCmdLine, '(?i)(?<!\S)(?:/|-)(?:minigui|mg)(?=\s|$)', '')
		$sCmdLine = StringStripWS($sCmdLine, 3)
	EndIf

	; add restart option (if not already there)
	If StringInStr($sCmdLine, " /restart") = 0 Then
		$sCmdLine &= " /restart"
	EndIf

	If $bCloseAndroid = True Then
		If Not CloseAndroid("RestartBot") And $g_sAndroidEmulator = "MEmu" Then
			If $bImmediateExit Then
				$g_bRunState = $bPreviousRunState
				$g_bBotPaused = $bPreviousPausedState
			EndIf
			$bRestartActive = False
			Return SetError(2, 0, False)
		EndIf
		If _Sleep(1000) Then
			If $bImmediateExit Then
				$g_bRunState = $bPreviousRunState
				$g_bBotPaused = $bPreviousPausedState
			EndIf
			$bRestartActive = False
			Return SetError(2, 0, False)
		EndIf
	EndIf

	Local Const $sMissingRestartFlag = "{RESTART_FLAG_MISSING}"
	Local $sPreviousRestartFlag = $sMissingRestartFlag
	Local $bRestartFlagWritten = False
	If $bAutostart = True Then
		$sPreviousRestartFlag = IniRead($g_sProfileConfigPath, "general", "Restarted", $sMissingRestartFlag)
		$bRestartFlagWritten = IniWrite($g_sProfileConfigPath, "general", "Restarted", 1)
		If Not $bRestartFlagWritten Then
			SetLog("Cannot save restart state; using command-line autostart", $COLOR_WARNING)
			If StringInStr($sCmdLine, " /autostart") = 0 Then $sCmdLine &= " /autostart"
		EndIf
	EndIf

	If $bImmediateExit Then
		; Stop callbacks only after restart preparation and Android shutdown.
		$g_bRunState = False
		$g_bBotPaused = False
	EndIf

	; Restart My Bot
	Local $pid = Run("cmd.exe /c start """" " & $sCmdLine, $g_sWorkingDir, @SW_HIDE) ; cmd.exe only used to support launch like "..\AutoIt3\autoit3.exe" from console
	If @error = 0 And $pid > 0 Then
		SetLog("Restarting " & $g_sBotTitle)
		If $bImmediateExit Then Exit
		; Wait 1 Minute to get closed
		_SleepStatus(60 * 1000)
		$bRestartActive = False
		Return True
	Else
		SetLog("Cannot restart " & $g_sBotTitle, $COLOR_RED)
	EndIf

	If $bRestartFlagWritten Then
		If $sPreviousRestartFlag = $sMissingRestartFlag Then
			IniDelete($g_sProfileConfigPath, "general", "Restarted")
		Else
			IniWrite($g_sProfileConfigPath, "general", "Restarted", $sPreviousRestartFlag)
		EndIf
	EndIf
	If $bImmediateExit Then
		$g_bRunState = $bPreviousRunState
		$g_bBotPaused = $bPreviousPausedState
	EndIf
	$bRestartActive = False
	Return SetError(2, 0, False)
EndFunc   ;==>RestartBot
