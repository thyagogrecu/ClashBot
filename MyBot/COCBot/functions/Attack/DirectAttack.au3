; #FUNCTION# ===========================================================================================================
; Name ..........: Direct Attack
; Author ........: Phael
; Description ...: Executes the configured attack directly from the battle screen.
; Remarks .......: Runs EBO after deployment. A second click cancels, silently stops the bot, and leaves the battle open.
; ======================================================================================================================
Func DirectAttack()
	; === CANCELLATION HANDLING ===
	Static $hCancelClickCooldown = 0
	; Ignore only an OnEvent queued immediately after cancellation.
	If $g_bDirectAttackCancelRequested And Not $g_bDirectAttackRunning Then
		If $hCancelClickCooldown And __TimerDiff($hCancelClickCooldown) < 500 Then Return
		$g_bDirectAttackCancelRequested = False
	EndIf
	If $g_bDirectAttackRunning Then
		RequestDirectAttackCancel()
		Return
	EndIf

	; === VARIABLE BACKUP ===
	Local $tempbRunState = $g_bRunState
	
	; === UI INTERACTION ===
	$g_bDirectAttackCancelRequested = False
	$g_bDirectAttackRunning = True
	
	If $g_hBtnDirectAttack <> 0 Then GUICtrlSetBkColor($g_hBtnDirectAttack, 0x90EE90)
	_GUICtrlTab_ClickTab($g_hTabMain, 0)
	
	; === ATTACK MODE SETUP ===
	$g_iMatchMode = $g_iDirectAttackMode
	$g_bRunState = True
	$g_bBattleSpeedActivated = False
	$g_iSpecialBattleMode = $eSpecialBattleNone
	
	; === CONFIGURATION MANAGEMENT ===
	SaveConfig()
	ApplyConfig_600_52_2("Read")
	
	; === ATTACK PREPARATION ===
	AttackRemainingTime(True)
	ResetTHsearch()
	_ObjDeleteKey($g_oBldgAttackInfo, "")
	PrepareAttack($g_iMatchMode)

	; === ATTACK EXECUTION ===
	If Not $g_bDirectAttackCancelRequested Then Attack()
	If Not $g_bDirectAttackCancelRequested And $g_iSmartZapTiming = $eSmartZapTimingMid And IsAttackPage() Then SmartZap()
	If Not $g_bDirectAttackCancelRequested Then WaitDirectAttackBattle()
	Local $bDirectAttackCancelled = $g_bDirectAttackCancelRequested

	; === STATE RESTORATION ===
	If $bDirectAttackCancelled Then
		$hCancelClickCooldown = __TimerInit()
		$g_bRunState = False
	Else
		$g_bRunState = $tempbRunState
	EndIf

	; === UI AND STATE RESTORATION ===
	$g_bDirectAttackRunning = False
	If $g_hBtnDirectAttack <> 0 Then
		GUICtrlSetBkColor($g_hBtnDirectAttack, 0xFFB6C1)
		If Not $tempbRunState Then GUICtrlSetState($g_hBtnDirectAttack, $GUI_ENABLE)
	EndIf

	; === COMPLETION LOG ===
	If Not $bDirectAttackCancelled Then SetLog("» DIRECT ATTACK COMPLETED «", $COLOR_SUCCESS)
EndFunc   ;==>DirectAttack

; #FUNCTION# ===========================================================================================================
; Name ..........: RequestDirectAttack
; Description ...: Queues the Direct button action without holding a GUI callback during the battle.
; ======================================================================================================================
Func RequestDirectAttack()
	If $g_bDirectAttackRunning Then
		RequestDirectAttackCancel()
		Return
	EndIf
	$g_bDirectAttackStartRequested = Not $g_bDirectAttackStartRequested
EndFunc   ;==>RequestDirectAttack

; #FUNCTION# ===========================================================================================================
; Name ..........: ProcessDirectAttackRequest
; Description ...: Starts a queued attack after GUI message and log updates have finished.
; ======================================================================================================================
Func ProcessDirectAttackRequest()
	If Not $g_bDirectAttackStartRequested Or $g_bDirectAttackRunning Then Return
	If SetCriticalMessageProcessing() Or $g_bFlushGuiLogActive Then Return
	$g_bDirectAttackStartRequested = False
	DirectAttack()
EndFunc   ;==>ProcessDirectAttackRequest

; === CANCELLATION HELPERS ===
Func RequestDirectAttackCancel()
	If Not $g_bDirectAttackRunning Or $g_bDirectAttackCancelRequested Then Return
	$g_bDirectAttackCancelRequested = True
	SetLog("Canceling Direct Attack", $COLOR_ACTION)
	btnStop(False, True)
EndFunc   ;==>RequestDirectAttackCancel

Func CheckDirectAttackCancelClick()
	If Not $g_bDirectAttackRunning Or $g_bDirectAttackCancelRequested Then Return
	Local $aCursorInfo = GUIGetCursorInfo($g_hFrmBot)
	If IsArray($aCursorInfo) And $aCursorInfo[2] And $aCursorInfo[4] = $g_hBtnDirectAttack Then RequestDirectAttackCancel()
EndFunc   ;==>CheckDirectAttackCancelClick

; === BATTLE COMPLETION ===
Func WaitDirectAttackBattle()
	SetLog("Checking if the battle has finished")
	While GoldElixirChangeEBO()
		If $g_bDirectAttackCancelRequested Then Return False
		If $g_bRestart Then Return False
		If _Sleep($DELAYRETURNHOME1) Then Return False
		If $g_bRestart Then Return False
		CheckTagTeam()
	WEnd
	If $g_bDirectAttackCancelRequested Then Return False
	If $g_bRestart Then Return False

	If IsAttackPage() And $g_iSmartZapTiming = $eSmartZapTimingEnd Then SmartZap()
	Return EndDirectAttackBattle()
EndFunc   ;==>WaitDirectAttackBattle

Func EndDirectAttackBattle()
	; Stop on the result screen without clicking Return Home.
	If IsReturnHomeBattlePage(True, False) Then Return True
	SetLog("Ending Battle", $COLOR_INFO)

	For $iAttempt = 0 To 5
		Local $aiEndBattleButton = findButton("EndBattle", Default, 1, True)
		If IsArray($aiEndBattleButton) And UBound($aiEndBattleButton, 1) = 2 And IsAttackPage() Then
			ClickP($aiEndBattleButton, 1, 120, "#DirectAttackEndBattle")
			For $iConfirm = 0 To 10
				If IsEndBattlePage(False) Then
					ClickOkay("SurrenderOkay")
					Return True
				EndIf
				If _Sleep($DELAYRETURNHOME5) Then Return False
			Next
		EndIf
		If IsReturnHomeBattlePage(True, False) Then Return True
		If _Sleep($DELAYRETURNHOME5) Then Return False
	Next

	SetDebugLog("Direct Attack: unable to end battle", $COLOR_WARNING)
	Return False
EndFunc   ;==>EndDirectAttackBattle
