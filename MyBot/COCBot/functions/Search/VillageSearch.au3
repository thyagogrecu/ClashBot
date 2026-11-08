; #FUNCTION# ====================================================================================================================
; Name ..........: VillageSearch
; Description ...: Searches for a village that meets conditions
; Syntax ........: VillageSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #6
; Modified ......: kaganus (Jun/Aug 2015), Sardo 2015-07, KnowJack(Aug 2015) , The Master (2015), MonkeyHunter (02/08-2016),
;				   CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func VillageSearch()
	$g_bVillageSearchActive = True
	$g_bCloudsActive = True

	Local $Result = _VillageSearch()
	If $g_bSearchAttackNowEnable Then
		GUICtrlSetState($g_hBtnAttackNowDB, $GUI_HIDE)
		GUICtrlSetState($g_hBtnAttackNowLB, $GUI_HIDE)
		GUICtrlSetState($g_hBtnAttackNowTS, $GUI_HIDE)
		HideShields(False)
		$g_bBtnAttackNowPressed = False
	EndIf

	$g_bVillageSearchActive = False
	$g_bCloudsActive = False

	Return $Result = True
EndFunc   ;==>VillageSearch

Func _VillageSearch() ;Control for searching a village that meets conditions
	Local $Result
	Local $weakBaseValues
	Local $logwrited = False
	Local $iSkipped = 0
	Local $abHeroUse[$eHeroCount] = [False, False, False, False, False, False]
	For $i = 0 To $eHeroCount - 1
		$abHeroUse[$i] = ($g_abSearchSearchesEnable[$DB] ? IsUnitUsed($DB, $eKing + $i) : False) _
				Or ($g_abSearchSearchesEnable[$LB] ? IsUnitUsed($LB, $eKing + $i) : False)
	Next

	If $g_bDebugDeadBaseImage Or $g_aiSearchEnableDebugDeadBaseImage > 0 Then
		DirCreate($g_sProfileTempDebugPath & "\SkippedZombies\")
		DirCreate($g_sProfileTempDebugPath & "\Zombies\")
		setZombie()
	EndIf

	If $g_bIsClientSyncError = False Then
		For $i = 0 To $g_iModeCount - 1
			$g_iAimGold[$i] = $g_aiFilterMinGold[$i]
			$g_iAimElixir[$i] = $g_aiFilterMinElixir[$i]
			$g_iAimGoldPlusElixir[$i] = $g_aiFilterMinGoldPlusElixir[$i]
			$g_iAimDark[$i] = ($g_abFilterMeetDEEnable[$i] ? ($g_aiFilterMeetDEMin[$i]) : (0))
		Next
	EndIf

	If _Sleep($DELAYVILLAGESEARCH1) Then Return
	If $g_bRestart = True Then Return ; exit func
	If Not ($g_bIsSearchLimit) Then
		If Not $g_bFastSearchMode Then SetLogCentered("=", "=", $COLOR_INFO)
	EndIf
	For $x = 0 To $g_iModeCount - 1
		If IsSearchModeActive($x) Then WriteLogVillageSearch($x)
	Next

	If Not ($g_bIsSearchLimit) Then
		If Not $g_bFastSearchMode Then SetLogCentered("=", "=", $COLOR_INFO)
	Else
		If Not $g_bFastSearchMode Then SetLogCentered(" Restart To Search ", Default, $COLOR_INFO)
	EndIf

	If $g_bSearchAttackNowEnable Then
		HideShields(True)
		GUICtrlSetState($g_hBtnAttackNowDB, $GUI_SHOW)
		GUICtrlSetState($g_hBtnAttackNowLB, $GUI_SHOW)
		GUICtrlSetState($g_hBtnAttackNowTS, $GUI_SHOW)
	EndIf

	If $g_bIsClientSyncError = False And $g_bIsSearchLimit = False Then
		$g_iSearchCount = 0
	EndIf

	If $g_bIsSearchLimit = True Then $g_bIsSearchLimit = False

	; Reset page errors
	InitAndroidPageError()
	
	While 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		; cleanup some vars used by imgloc just in case. used in TH and DeadBase ( imgloc functions)
		ResetTHsearch()

		_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all keys from building dictionary

		If $g_bDebugVillageSearchImages Then SaveDebugImage("villagesearch")
		$logwrited = False
		$g_bBtnAttackNowPressed = False
		$g_iSearchTHLResult = -1

		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC

		If $g_bRestart Then Return ; exit func

		; ----------------- READ ENEMY VILLAGE RESOURCES  -----------------------------------
		WaitForClouds() ; Wait for clouds to disappear
		If Not $g_bRunState Then Return
		AttackRemainingTime(True) ; Timer for knowing when attack starts, in 30 Sec. attack automatically starts and lasts for 3 Minutes
		If $g_bRestart Then Return ; exit func

		$g_bCloudsActive = False

		If $g_iSpecialBattleMode <> $eSpecialBattleNone Then
			Local $match[$g_iModeCount]
			$g_iMatchMode = $LB
			Return True
		EndIf

		If Not GetResources(False) Then ; Reads Resource Values
			If Not $g_bRunState Then Return
			If $g_bRestart Then Return ; Exit func
			ContinueLoop
		EndIf
		If $g_bRestart Then Return ; Exit func

		SuspendAndroid()

		; ---------------- CHECK THE ACTIVE MODE  --------------------------------------------
		; $dbase = true if dead base found
		; $match[$i] = result of check between gui settings and target village resources
		; $isModeActive[$i] = the mode it is active or not (cups, research, army %)
		Local $noMatchTxt = ""
		Local $dbBase = False
		Local $bSkipSearchFilter = $g_bSkipSearchFilter And Not $g_bRushAttackRunning
		Local $match[$g_iModeCount]
		Global $isModeActive[$g_iModeCount]
		For $i = 0 To $g_iModeCount - 1
			$match[$i] = False
			$isModeActive[$i] = False
		Next

		If _Sleep($DELAYRESPOND) Then
			ResumeAndroid()
			Return False
		EndIf

		For $i = 0 To $g_iModeCount - 1
			$isModeActive[$i] = IsSearchModeActive($i)
			If $isModeActive[$i] Then
				$match[$i] = ($bSkipSearchFilter ? True : CompareResources($i))
			EndIf
		Next

		If $bSkipSearchFilter And ($match[$DB] Or $match[$LB]) Then
			ResumeAndroid()
			Local $GetResourcesTXT = StringFormat("%3s", $g_iSearchCount) & "> [G]:" & StringFormat("%7s", $g_iSearchGold) & " [E]:" & StringFormat("%7s", $g_iSearchElixir) & " [D]:" & StringFormat("%5s", $g_iSearchDark)
			$g_sSearchCount = $g_iSearchCount
			$g_sOppGold = $g_iSearchGold
			$g_sOppElixir = $g_iSearchElixir
			$g_sOppDE = $g_iSearchDark
			$g_sOppTrophies = $g_iSearchTrophy
			SetLog($GetResourcesTXT, $COLOR_ACTION, "Lucida Console", 7.5)
			If Not $g_bFastSearchMode Then
				SetLog("      " & "Search Filter Skipped - Attacking First Detected Village!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			EndIf
			$logwrited = True
			$g_iMatchMode = ($match[$DB] ? $DB : $LB)
			ExitLoop
		EndIf

		; only one capture here, very important for consistent debug images, zombies, redline calc etc.
		ForceCaptureRegion()
		_CaptureRegion2()

		If $g_bRestart Then
			ResumeAndroid()
			Return False
		EndIf

		; ----------------- FIND TARGET TOWNHALL -------------------------------------------
		; $g_iSearchTH name of level of townhall (return "-" if no th found)
		; $g_iTHx and $g_iTHy coordinates of townhall
		Local $THString = ""
		If Not $bSkipSearchFilter Then
			If $match[$DB] Or $match[$LB] Then ; make sure resource conditions are met
				$THString = FindTownhall(False, False) ;find TH, but only if TH condition is checked
			ElseIf ($g_abFilterMeetOneConditionEnable[$DB] Or $g_abFilterMeetOneConditionEnable[$LB]) Then ; meet one then attack, do not need correct resources
				$THString = FindTownhall(True, False)
			EndIf

			For $i = 0 To $g_iModeCount - 1
				If $isModeActive[$i] Then
					If $g_abFilterMeetOneConditionEnable[$i] Then
						If $g_abFilterMeetTH[$i] = False And $g_abFilterMeetTHOutsideEnable[$i] = False Then
							;ignore, conditions not checked
						Else
							If CompareTH($i) Then $match[$i] = True ;have a match if meet one enabled & a TH condition is met. ; UPDATE THE VARIABLE $g_iSearchTHLResult
						EndIf
					Else
						If Not CompareTH($i) Then $match[$i] = False ;if TH condition not met, skip. if it is, match is determined based on resources ; UPDATE THE VARIABLE $g_iSearchTHLResult
					EndIf
				EndIf
			Next
		EndIf

		If $g_iSearchTHLResult = -1 Then CompareTH(0) ; inside have a conditional to update $g_iSearchTHLResult

		; ----------------- WRITE LOG OF ENEMY RESOURCES -----------------------------------
		Local $GetResourcesTXT = StringFormat("%3s", $g_iSearchCount) & "> [G]:" & StringFormat("%7s", $g_iSearchGold) & " [E]:" & StringFormat("%7s", $g_iSearchElixir) & " [D]:" & StringFormat("%5s", $g_iSearchDark) & $THString

		; Stats Attack
		$g_sSearchCount = $g_iSearchCount
		$g_sOppGold = $g_iSearchGold
		$g_sOppElixir = $g_iSearchElixir
		$g_sOppDE = $g_iSearchDark
		$g_sOppTrophies = $g_iSearchTrophy
		If $g_bFastSearchMode Then SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)

		; ----------------- CHECK DEAD BASE -------------------------------------------------
		If Not $g_bRunState Then
			ResumeAndroid()
			Return False
		EndIf
		; check deadbase
		Local $checkDeadBase = $match[$DB] Or $match[$LB]
		If $checkDeadBase Then
			$dbBase = checkDeadBase()
		EndIf

		; ----------------- CHECK WEAK BASE -------------------------------------------------
		If (IsWeakBaseActive($DB) And $dbBase And ($match[$DB] Or $g_abFilterMeetOneConditionEnable[$DB])) Or _
				(IsWeakBaseActive($LB) And ($match[$LB] Or $g_abFilterMeetOneConditionEnable[$LB])) Then
			; check twice if Eagle is active
			Local $maxTry = 1
			For $i = 0 To $g_iModeCount - 1
				If $g_abFilterMaxEagleEnable[$i] Then $maxTry = 2
			Next
			For $try = 1 To $maxTry ; check twice to be sure due to walking heroes
				;let try to reduce weakbase time
				If ($g_iSearchTH <> "-") Then
					$weakBaseValues = IsWeakBase($g_iImglocTHLevel, $g_sImglocRedline, False)
				Else
					$weakBaseValues = IsWeakBase($g_iMaxTHLevel, "", False)
				EndIf
				Local $bIsWeak = False
				For $i = 0 To $g_iModeCount - 1
					If IsWeakBaseActive($i) And (($i = $DB And $dbBase) Or $i <> $DB) And ($match[$i] Or $g_abFilterMeetOneConditionEnable[$i]) Then
						If getIsWeak($weakBaseValues, $i) Then
							$match[$i] = True
							$bIsWeak = True
						Else
							$match[$i] = False
							$noMatchTxt &= ", Not a Weak Base for " & $g_asModeText[$i]
							; don't check again
							$try = 2
						EndIf
					EndIf
				Next

				If $bIsWeak And $try = 1 And Not $g_bFastSearchMode Then
					ResumeAndroid()
					If _Sleep(3000) Then Return ; wait 5 Seconds to give heroes time to "walk away"
					ForceCaptureRegion()
					_CaptureRegion2()
					SuspendAndroid()
				EndIf
			Next
		EndIf

		ResumeAndroid()

		; ----------------- WRITE LOG VILLAGE FOUND AND ASSIGN VALUE AT $g_iMatchMode and exitloop  IF CONDITIONS MEET ---------------------------
		If $match[$DB] And $dbBase Then
			If Not $g_bFastSearchMode Then
				SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
				SetLog("      " & "Dead Base Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			EndIf
			$logwrited = True
			$g_iMatchMode = $DB
			ExitLoop
		ElseIf $match[$LB] And Not $dbBase Then
			If Not $g_bFastSearchMode Then
				SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
				SetLog("      " & "Live Base Found!", $COLOR_SUCCESS, "Lucida Console", 7.5)
			EndIf
			$logwrited = True
			$g_iMatchMode = $LB
			ExitLoop
		ElseIf $match[$LB] And $g_bCollectorFilterDisable Then
			If Not $g_bFastSearchMode Then
				SetLog($GetResourcesTXT, $COLOR_SUCCESS, "Lucida Console", 7.5)
				SetLog("      " & "Live Base Found!*", $COLOR_SUCCESS, "Lucida Console", 7.5)
			EndIf
			$logwrited = True
			$g_iMatchMode = $LB
			ExitLoop
		EndIf

		If $match[$DB] And Not $dbBase Then
			$noMatchTxt &= ", Not a " & $g_asModeText[$DB]
		ElseIf $match[$LB] And $dbBase Then
			$noMatchTxt &= ", Not a " & $g_asModeText[$LB]
		EndIf

		If $noMatchTxt <> "" Then
			If Not $g_bFastSearchMode Then
				SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
				SetLog("      " & StringMid($noMatchTxt, 3), $COLOR_ACTION, "Lucida Console", 7.5)
			EndIf
			$logwrited = True
		EndIf

		If Not ($logwrited) Then
			If Not $g_bFastSearchMode Then SetLog($GetResourcesTXT, $COLOR_BLACK, "Lucida Console", 7.5)
		EndIf

		; Return Home on search limit
		If SearchLimit($iSkipped + 1) Then Return False

		If CheckAndroidReboot() = True Then
			$g_bRestart = True
			$g_bIsClientSyncError = True
			Return
		EndIf

		If _Sleep($DELAYRESPOND) Then Return

		; ------- Add attack now button delay and check button status
		If $g_bSearchAttackNowEnable And $g_iSearchAttackNowDelay > 0 Then
			For $i = 1 To $g_iSearchAttackNowDelay
				If _Sleep(1000) Then Return ; add human reaction time on AttackNow button function
				If $g_bBtnAttackNowPressed = True Then ExitLoop 2
			Next
		EndIf
		If $g_bBtnAttackNowPressed = True Then ExitLoop

		; ----------------- PRESS BUTTON NEXT  -------------------------------------------------
		If $checkDeadBase And Not $g_bDebugDeadBaseImage And $g_iSearchCount > $g_aiSearchEnableDebugDeadBaseImage Then
			SetLog("Enabled collecting debug images of dead bases (zombies)", $COLOR_DEBUG)
			SetLog("- Save skipped dead base when available Elixir with empty storage > " & (($g_aZombie[8] > -1) ? ($g_aZombie[8] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save skipped dead base when available Elixir > " & (($g_aZombie[9] > -1) ? ($g_aZombie[9] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save dead base when available Elixir < " & (($g_aZombie[10] > -1) ? ($g_aZombie[10] & "k") : ("is disabled")), $COLOR_DEBUG)
			SetLog("- Save dead base when raided Elixir < " & (($g_aZombie[7] > -1) ? ($g_aZombie[7] & "%") : ("is disabled")), $COLOR_DEBUG)
			$g_bDebugDeadBaseImage = True
		EndIf
		If $g_bDebugDeadBaseImage Then setZombie()
		Local $i = 0
		While $i < 100
			If _Sleep($DELAYVILLAGESEARCH2) Then Return
			$i += 1
			_CaptureRegions()

			If (_ColorCheck(_GetPixelColor($NextBtn[0], $NextBtn[1]), Hex($NextBtn[2], 6), $NextBtn[3]) Or _
					QuickMIS("BC1", $g_sImgNextButton, 700, 500 + $g_iBottomOffsetY, 760, 555 + $g_iBottomOffsetY)) And IsAttackPage(False) Then
				$g_bCloudsActive = True
				Click(Random($NextBtnRND[0], $NextBtnRND[2], 1), Random($NextBtnRND[1], $NextBtnRND[3], 1), 1, 120, "#0155") ;Click Next
				ExitLoop
			Else
				SetDebugLog("Wait to see Next Button... " & $i, $COLOR_DEBUG)
			EndIf
			If Mod($i, 10) = 0 And checkObstacles_Network(False, True) Then
				If $g_bRestart Then Return
				$i -= 1 ; Do not consume the Next-button timeout while reconnecting is visible.
				ContinueLoop
			EndIf
			If $i >= 99 Or isProblemAffect() Then ; if we can't find the next button or there is an error, then restart
				$g_bIsClientSyncError = True
				checkMainScreen()
				If $g_bRestart Then
					$g_iNbrOfOoS += 1
					UpdateStats()
					SetLog("Couldn't locate Next button", $COLOR_ERROR)
					PushMsg("OoSResources")
				Else
					SetLog("Have strange problem couldn't locate Next button, Restarting Clash of Clans and Bot...", $COLOR_ERROR)
					$g_bIsClientSyncError = False ; disable fast OOS restart if not simple error and try restarting CoC
					CloseCoC(True)
				EndIf
				Return
			EndIf
		WEnd

		If _Sleep($DELAYRESPOND) Then Return
		If $g_bRestart = True Then Return ; exit func

		If isGemOpen(True) Then
			SetLog(" Not enough gold to keep searching.....", $COLOR_ERROR)
			If _Sleep($DELAYVILLAGESEARCH3) Then Return
			$g_bOutOfGold = True ; Set flag for out of gold to search for attack
			ReturnHome(False, False)
			Return
		EndIf

		$iSkipped = $iSkipped + 1
		$g_iSkippedVillageCount += 1
		If $g_iTownHallLevel <> "" And $g_iTownHallLevel > 0 Then
			$g_iSearchCost += $g_aiSearchCost[$g_iTownHallLevel - 1]
			$g_iStatsTotalGain[$eLootGold] -= $g_aiSearchCost[$g_iTownHallLevel - 1]
		EndIf
		UpdateStats()

	WEnd ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;### Main Search Loop End ###;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;--- show buttons attacknow ----
	If $g_bBtnAttackNowPressed = True Then
		SetLogCentered(" Attack Now Pressed! ", "~", $COLOR_SUCCESS)
	EndIf

	;--- write in log match found ----
	If $g_bSearchAlertMe Then
		TrayTip($g_sProfileCurrentName & ": " & $g_asModeText[$g_iMatchMode] & " Match Found!", "Gold: " & $g_iSearchGold & "; Elixir: " & $g_iSearchElixir & "; Dark: " & $g_iSearchDark, "", 0)
		SetDebugLog("Trying to play sound.  Set volume to 50%", $COLOR_DEBUG)
		SoundSetWaveVolume(50)   ;50% WAV volume setting
		If FileExists(@WindowsDir & "\media\Festival\Windows Exclamation.wav") Then
			SetDebugLog("Playing first sound.", $COLOR_DEBUG)
			SoundPlay(@WindowsDir & "\media\Festival\Windows Exclamation.wav", 1)
		ElseIf FileExists(@WindowsDir & "\media\Windows Exclamation.wav") Then
			SetDebugLog("Playing second sound.", $COLOR_DEBUG)
			SoundPlay(@WindowsDir & "\media\Windows Exclamation.wav", 1)
		Else
			SetDebugLog("No sound files found.", $COLOR_DEBUG)
		EndIf
	EndIf

	SetLogCentered(" Search Complete ", Default, $COLOR_INFO)
	PushMsg("MatchFound")

	$g_bIsClientSyncError = False
	Return True
EndFunc   ;==>_VillageSearch

Func SearchLimit($iSkipped)
	If $g_bSearchRestartEnable And $iSkipped >= Number($g_iSearchRestartLimit) Then
		Local $Wcount = 0
		While _CheckPixel($aSurrenderButton, $g_bCapturePixel) = False
			If _Sleep($DELAYSEARCHLIMIT) Then Return
			$Wcount += 1
			SetDebugLog("wait surrender button " & $Wcount, $COLOR_DEBUG)
			If $Wcount >= 50 Or isProblemAffect(True) Then
				checkMainScreen()
				$g_bIsClientSyncError = False ; reset OOS flag for long restart
				$g_bRestart = True ; set force runbot restart flag
				Return True
			EndIf
		WEnd
		$g_bIsSearchLimit = True
		ReturnHome(False, False) ;If End battle is available
		getArmyTroopCapacity(True, True)
		$g_bRestart = True ; set force runbot restart flag
		$g_bIsClientSyncError = True ; set OOS flag for fast restart
		Return True
	Else
		Return False
	EndIf
EndFunc   ;==>SearchLimit


Func WriteLogVillageSearch($x)
	;this function writes in BOT LOG the values setting for each attack mode ($DB,$LB)
	;example
	;[18.07.30] ============== Searching For Dead Base ===============
	;[18.07.30] Enable Dead Base search IF
	;[18.07.30] - Army Camps % >  70
	;[18.07.30] Match Dead Base  village IF
	;[18.07.30] - Meet: Gold and Elixir
	;[18.07.30] - Weak Base(Mortar: 5, WizTower: 5)

	Local $MeetGxEtext = "", $MeetGorEtext = "", $MeetGplusEtext = "", $MeetDEtext = "", $MeetTHtext = "", $MeetTHOtext = "", $MeetWeakBasetext = "", $EnabledAftertext = ""
	If $g_aiFilterMeetGE[$x] = 0 Then $MeetGxEtext = "- Meet: Gold and Elixir"
	If $g_aiFilterMeetGE[$x] = 1 Then $MeetGorEtext = "- Meet: Gold or Elixir"
	If $g_aiFilterMeetGE[$x] = 2 Then $MeetGplusEtext = "- Meet: Gold + Elixir"
	If $g_abFilterMeetDEEnable[$x] Then $MeetDEtext = "- Dark"
	If $g_abFilterMeetTH[$x] Then $MeetTHtext = "- Max TH " & $g_aiMaxTH[$x] ;$g_aiFilterMeetTHMin
	If $g_abFilterMeetTHOutsideEnable[$x] Then $MeetTHOtext = "- TH Outside"
	If IsWeakBaseActive($x) Then $MeetWeakBasetext = "- Weak Base"
	If Not ($g_bIsSearchLimit) And $g_bDebugSetLog Then
		SetLogCentered(" Searching For " & $g_asModeText[$x] & " ", Default, $COLOR_INFO)
		SetLog("Enable " & $g_asModeText[$x] & " search IF ", $COLOR_INFO)
		If $g_abSearchSearchesEnable[$x] Then SetLog("- Numbers of searches range " & $g_aiSearchSearchesMin[$x] & " - " & $g_aiSearchSearchesMax[$x], $COLOR_INFO)
		If $g_abSearchCampsEnable[$x] Then SetLog("- Army Camps % >  " & $g_aiSearchCampsPct[$x], $COLOR_INFO)
		SetLog("Match " & $g_asModeText[$x] & "  village IF ", $COLOR_INFO)
		If $MeetGxEtext <> "" Then SetLog($MeetGxEtext, $COLOR_INFO)
		If $MeetGorEtext <> "" Then SetLog($MeetGorEtext, $COLOR_INFO)
		If $MeetGplusEtext <> "" Then SetLog($MeetGplusEtext, $COLOR_INFO)
		If $MeetDEtext <> "" Then SetLog($MeetDEtext, $COLOR_INFO)
		If $MeetTHtext <> "" Then SetLog($MeetTHtext, $COLOR_INFO)
		If $MeetTHOtext <> "" Then SetLog($MeetTHOtext, $COLOR_INFO)
		If $MeetWeakBasetext <> "" Then SetLog($MeetWeakBasetext, $COLOR_INFO)
		If $g_abFilterMeetOneConditionEnable[$x] Then SetLog("Meet One and Attack!")
		SetLogCentered(" RESOURCE CONDITIONS ", "~", $COLOR_INFO)
	EndIf
	If Not ($g_bIsSearchLimit) Then
		Local $txtTownhall = ""
		If $g_abFilterMeetTH[$x] Then $txtTownhall = " [TH]:" & StringFormat("%2s", $g_aiMaxTH[$x]) ;$g_aiFilterMeetTHMin
		If $g_abFilterMeetTHOutsideEnable[$x] Then $txtTownhall &= ", Out"
		If $g_aiFilterMeetGE[$x] = 2 Then
			SetLog("Aim:           [G+E]:" & StringFormat("%7s", $g_iAimGoldPlusElixir[$x]) & " [D]:" & StringFormat("%5s", $g_iAimDark[$x]) & $txtTownhall & " for: " & $g_asModeText[$x], $COLOR_SUCCESS, "Lucida Console", 7.5)
		Else
			SetLog("Aim: [G]:" & StringFormat("%7s", $g_iAimGold[$x]) & " [E]:" & StringFormat("%7s", $g_iAimElixir[$x]) & " [D]:" & StringFormat("%5s", $g_iAimDark[$x]) & $txtTownhall & " for: " & $g_asModeText[$x], $COLOR_SUCCESS, "Lucida Console", 7.5)
		EndIf
	EndIf
EndFunc   ;==>WriteLogVillageSearch
