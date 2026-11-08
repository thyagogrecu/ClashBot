; #FUNCTION# ===========================================================================================================
; Name ..........: Clan Castle Spam
; Author ........: Phael
; Description ...: Repeats configured Clan Castle donations after a cooldown.
; Remarks .......: Stops when donations are disabled or unavailable, or when the mode or run state changes.
; ======================================================================================================================
Func CCSpamCycle()
	; === VALIDATION ===
	If Not $g_bCCSpamEnabled Then Return

	If Not $g_bRunState Then
		DisableCCSpam("Bot is not running")
		Return
	EndIf

	; === DONATION VALIDATION ===
	If Not $g_bChkDonate Then
		DisableCCSpam("Donation is disabled in settings")
		Return
	EndIf

	; === INITIALIZATION ===
	$g_bCCSpamRunning = True
	SetLog("» CC SPAM MODE ENABLED «", $COLOR_INFO)

	; === MAIN SPAM LOOP ===
	While $g_bCCSpamEnabled And $g_bRunState

		; === DONATION EXECUTION ===
		DonateCC()

		; === POST-DONATE STATE CHECKS ===
		If Not $g_bRunState Then ExitLoop
		If checkObstacles() Then ExitLoop
		If $g_bRestart = True Then ExitLoop

		; Return to main village screen between cycles
		checkMainScreen(False)
		If _Sleep($DELAYRUNBOT3) Then ExitLoop

		; === DONATION STATE VALIDATION ===
		If Not $g_bChkDonate Then
			DisableCCSpam("Donation disabled during cycle")
			ExitLoop
		EndIf

		If Not $g_bDonationEnabled Then
			DisableCCSpam("Donation system disabled during cycle")
			ExitLoop
		EndIf

		; === DONATION COOLDOWN ===
		Local $iCCSpamDelay = Random($g_iCCSpamDelayMin, $g_iCCSpamDelayMax, 1)
		SetLog("Waiting " & $iCCSpamDelay & "s before next donation")
		Local $iWaitTimer = __TimerInit()
		While __TimerDiff($iWaitTimer) < ($iCCSpamDelay * 1000)
			If Not $g_bCCSpamEnabled Then ExitLoop
			If Not $g_bRunState Then ExitLoop
			If _Sleep(1000) Then ExitLoop
		WEnd

		If Not $g_bCCSpamEnabled Then ExitLoop
		If Not $g_bRunState Then ExitLoop

	WEnd

	; === CLEANUP ===
	checkMainScreen(False)
	$g_bCCSpamRunning = False
EndFunc   ;==>CCSpamCycle
