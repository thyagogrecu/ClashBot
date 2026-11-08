#include-once

Func BotCommand($bLogStorage = True)

	Static $TimeToStop = -1

	Local $bChkBotStop, $iCmbBotCond, $iCmbBotCommand

	If $g_bOutOfElixir Or $g_bOutOfGold Then ; Check for out of loot conditions
		$bChkBotStop = True ; set halt attack mode
		$iCmbBotCond = 7 ; set stay online/collect only mode
		$iCmbBotCommand = 0 ; set stop mode to stay online
		Local $sOutOf = ($g_bOutOfGold ? "Gold" : "") & (($g_bOutOfGold And $g_bOutOfElixir) ? " and " : "") & ($g_bOutOfElixir ? "Elixir" : "")
		SetLog("Out of " & $sOutOf & " condition detected, force halt mode", $COLOR_WARNING)
	Else
		$bChkBotStop = $g_bChkBotStop ; Normal use GUI halt mode values
		$iCmbBotCond = $g_iCmbBotCond
		$iCmbBotCommand = $g_iCmbBotCommand
	EndIf

	$g_bMeetCondStop = False ; reset flags so bot can restart farming when conditions change.
	$g_bTrainEnabled = True
	$g_bDonationEnabled = True

	If $bChkBotStop Then

		If $iCmbBotCond = 5 Then $TimeToStop = (($g_iCmbHoursStop < 1) ? 1 : $g_iCmbHoursStop) * 3600000 ; 3600000 = 1 Hours

		Switch $iCmbBotCond
			Case 0
				If isGoldFull($bLogStorage) And isElixirFull($bLogStorage) And isDarkElixirFull($bLogStorage) Then $g_bMeetCondStop = True
			Case 1
				If isGoldFull($bLogStorage) Then $g_bMeetCondStop = True
			Case 2
				If isElixirFull($bLogStorage) Then $g_bMeetCondStop = True
			Case 3
				If isDarkElixirFull($bLogStorage) Then $g_bMeetCondStop = True
			Case 4 ; At Certain Time
				Local $bResume = ($iCmbBotCommand = 0)
				If StopAndResumeTimer($bResume) Then $g_bMeetCondStop = True
			Case 5 ; Bot Running For
				If Round(__TimerDiff($g_hTimerSinceStarted)) > $TimeToStop Then $g_bMeetCondStop = True
			Case 6 ; Donate Only
				$g_bMeetCondStop = True
				$g_bTrainEnabled = False
			Case 7 ; Only Stay Online
				$g_bMeetCondStop = True
				$g_bTrainEnabled = False
				$g_bDonationEnabled = False
		EndSwitch

		If $g_bMeetCondStop Then
			Switch $iCmbBotCommand
				Case 0
					If Not $g_bRushAttackRunning And $g_bEnableRankedBattle And $g_aiRankedBattleHaltState[$g_iCurAccount] <> 2 Then
						If $g_aiRankedBattleHaltState[$g_iCurAccount] <> 1 Then SetLog("Halt Attack Suspended: Completing Ranked Battles", $COLOR_ACTION)
						$g_aiRankedBattleHaltState[$g_iCurAccount] = 1
						$g_iCommandStop = -1
						Return False
					EndIf
					If Not $g_bRushAttackRunning And $g_aiRankedBattleHaltState[$g_iCurAccount] <> 2 And $iCmbBotCond <= 3 And $g_bCollectStarBonus And StarBonusSearch() Then
						SetLog("Star bonus available, continue attacking to collect it")
						Return False
					EndIf
					If Not $g_bRushAttackRunning And $g_aiRankedBattleHaltState[$g_iCurAccount] <> 2 And $g_bChkForceAttackOnClanGames And Not $g_bClanGamesCompleted Then
						_ClanGames()
						If $IsCGEventRunning Or $CurrentActiveChallenge <> 0 Then
							SetLog("Clan Games challenge in progress, don't halt attack")
							Return False
						EndIf
					EndIf
					If $g_aiRankedBattleHaltState[$g_iCurAccount] = 2 And $g_iCommandStop <> 0 Then SetLog("Ranked Battles Completed: Halt Attack Restored", $COLOR_ACTION)
					If Not $g_bDonationEnabled Then
						SetLog("Halt Attack: Stay Online/Collect", $COLOR_ACTION)
					ElseIf Not $g_bTrainEnabled Then
						SetLog("Halt Attack: Stay Online/Collect/Donate", $COLOR_ACTION)
					Else
						SetLog("Halt Attack: Stay Online/Train/Collect/Donate", $COLOR_ACTION)
					EndIf
					If Not $g_bRunState Then Return False

					; === HALT MODE UPGRADES ===
					If Not RunVillageUpgrades() Then Return False
					$g_iCommandStop = 0 ; Halt Attack

					; === HALT MODE DONATION ===
					If $g_bDonationEnabled And $g_bChkDonate Then
						If BalanceDonRec(True) Then DonateCC()
						If Not __RunBotStepReady() Then Return False
					EndIf
					If _Sleep($DELAYBOTCOMMAND1) Then Return
					Return False
				Case 1
					If Not $g_bRushAttackRunning And $g_bChkForceAttackOnClanGames And Not $g_bClanGamesCompleted Then
						_ClanGames(False, True)
						If $IsCGEventRunning Or $CurrentActiveChallenge <> 0 Then
							SetLog("Clan Games challenge in progress, finish it first")
							Return False
						EndIf
					EndIf
					SetLog("Halt Mode - Stop Bot", $COLOR_INFO)
					BotStop()
				Case 2
					SetLog("Halt Mode - Close Bot", $COLOR_INFO)
					BotClose()
				Case 3
					SetLog("Halt Mode - Close Android + Bot", $COLOR_INFO)
					CloseAndroid("BotCommand")
					BotClose()
				Case 4
					If CloseAndroid("BotCommand") Then
						SetLog("Halt Mode - Shutdown PC", $COLOR_INFO)
						Shutdown(BitOR($SD_SHUTDOWN, $SD_FORCE))
					EndIf
				Case 5
					If CloseAndroid("BotCommand") Then
						SetLog("Halt Mode - Sleep PC", $COLOR_INFO)
						Shutdown($SD_STANDBY)
					EndIf
				Case 6
					If CloseAndroid("BotCommand") Then
						SetLog("Halt Mode - Reboot PC", $COLOR_INFO)
						Shutdown(BitOR($SD_REBOOT, $SD_FORCE))
					EndIf
				Case 7
					SetLog("Halt Mode - Turn Idle", $COLOR_INFO)
					$g_iCommandStop = 1
					$g_bTrainEnabled = False
					$g_bDonationEnabled = False
					Return False
			EndSwitch
			Return True
		EndIf
	EndIf
	If $g_bRushAttackRunning Or Not $bChkBotStop Or Not $g_bMeetCondStop Or $iCmbBotCommand <> 0 Or Not $g_bEnableRankedBattle Then $g_aiRankedBattleHaltState[$g_iCurAccount] = 0
	Return False
EndFunc   ;==>BotCommand


Func StopAndResumeTimer($bResume = False)

	Static $abStop[$g_iSwitchAccMaxAccounts]

	Local $iTimerStop, $iTimerResume = 25
	$iTimerStop = Number($g_iCmbTimeStop)
	If $bResume Then $iTimerResume = Number($g_iResumeAttackTime)
	Local $bCurrentStatus = $abStop[$g_iCurAccount]
	SetDebugLog("$iTimerStop: " & $iTimerStop & ", $iTimerResume: " & $iTimerResume & ", Max: " & _Max($iTimerStop, $iTimerResume) & ", Min: " & _Min($iTimerStop, $iTimerResume) & ", $bCurrentStatus: " & $bCurrentStatus)

	If @HOUR < _Min($iTimerStop, $iTimerResume) Then ; both timers are ahead.
		;Do nothing
	ElseIf @HOUR < _Max($iTimerStop, $iTimerResume) Then ; 1 timer has passed, 1 timer ahead
		If $iTimerStop < $iTimerResume Then ; reach Timer to Stop
			$abStop[$g_iCurAccount] = True
			If Not $bCurrentStatus Then SetLog("Timer to stop is set at: " & $iTimerStop & ":00hrs. It's time to stop!", $COLOR_SUCCESS)
		Else ; reach Timer to Resume
			$abStop[$g_iCurAccount] = False
			If $bCurrentStatus Then SetLog("Timer to resume attack is set at: " & $iTimerResume & ":00hrs. Resume attack now!", $COLOR_SUCCESS)
		EndIf
	Else ; passed both timers
		If $iTimerStop < $iTimerResume Then ; reach Timer to Stop
			$abStop[$g_iCurAccount] = False
			If $bCurrentStatus Then SetLog("Timer to resume attack is set at: " & $iTimerResume & ":00hrs. Resume attack now!", $COLOR_SUCCESS)
		Else
			$abStop[$g_iCurAccount] = True
			If Not $bCurrentStatus Then SetLog("Timer to stop is set at: " & $iTimerStop & ":00hrs. It's time to stop!", $COLOR_SUCCESS)
		EndIf
	EndIf
	SetDebugLog("@HOUR: " & @HOUR & ", $bCurrentStatus: " & $bCurrentStatus & ", $abStop[$g_iCurAccount]: " & $abStop[$g_iCurAccount])
	Return $abStop[$g_iCurAccount]
EndFunc   ;==>StopAndResumeTimer

Func StarBonusSearch()
	Local $bRet = False
	For $i = 1 To 10
		If WaitforPixel(20, 543 + $g_iBottomOffsetY, 103, 554 + $g_iBottomOffsetY, "5B5B5B", 20, 0.2) Then
			$bRet = True
			ExitLoop
		EndIf
		If _Sleep(400) Then Return
		If Not $g_bRunState Then Return
	Next
	Return $bRet
EndFunc   ;==>StarBonusSearch

