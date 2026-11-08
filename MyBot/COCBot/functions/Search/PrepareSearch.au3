; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareSearch
; Description ...: Goes into searching for a match, breaks shield if it has to
; Syntax ........: PrepareSearch()
; Parameters ....:
; Return values .: None
; Author ........: Code Monkey #4
; Modified ......: KnowJack (Aug 2015), MonkeyHunter(2015-12)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include "RankedBattle.au3"
#include "RevengeBattle.au3"

Func PrepareSearch($Mode = $DB, $bNormalMatchOnly = False) ;Click attack button and find match button, will break shield
	SetLog("» GOING TO ATTACK «", $COLOR_ACTION)
	
	; Clear an interrupted previous Ranked/Revenge session before selecting the next attack type.
	$g_iSpecialBattleMode = $eSpecialBattleNone
	ChkAttackCSVConfig()
	Local $bRankedHaltOverride = ($g_aiRankedBattleHaltState[$g_iCurAccount] = 1)

	; === REVENGE BATTLE ===
	; 0 = not started, 1 = Revenge started, 2 = normal search started from the Battle screen.
	Local $iRevengeResult = 0
	Local $bMainPage = False, $bBattleSelection = _RBD_IsRankedMatchButtonVisible() Or _RBD_IsNormalFindMatchButtonVisible()
	If Not $bBattleSelection And Not $bRankedHaltOverride And Not $bNormalMatchOnly And $g_bEnableRevengeBattle Then
		$iRevengeResult = JoinRevengeBattle()
	EndIf
	If $iRevengeResult < 0 Then Return False

	If $iRevengeResult = 0 Then
		If Not $bBattleSelection Then $bBattleSelection = _RBD_IsRankedMatchButtonVisible() Or _RBD_IsNormalFindMatchButtonVisible()
		If Not $bBattleSelection Then $bMainPage = IsMainPage()
		If Not $bMainPage And Not $bBattleSelection Then
			SetLog("Attack screen not detected; search not started", $COLOR_WARNING)
			Return False
		EndIf
	EndIf

	If $iRevengeResult = 0 Then
		; === NORMAL ATTACK FLOW ===
		If $bMainPage Then
			If _Sleep($DELAYTREASURY4) Then Return
			If _CheckPixel($aAttackForTreasury, $g_bCapturePixel, Default, "Is attack for treasury:") Then
				SetLog("It isn't attack for Treasury:", $COLOR_SUCCESS)
				Return
			EndIf
			If _Sleep($DELAYTREASURY4) Then Return
		
			Local $aAttack = findButton("AttackButton", Default, 1, True)
			Local $AttackCoordsX[2] = [45, 80]
			Local $AttackCoordsY[2] = [625 + $g_iBottomOffsetY, 645 + $g_iBottomOffsetY]
			Local $AttackButtonClickXY[2] = [Random($AttackCoordsX[0], $AttackCoordsX[1], 1), Random($AttackCoordsY[0], $AttackCoordsY[1], 1)]
			Local $bAttackButtonFound = IsArray($aAttack) And UBound($aAttack, 1) = 2

			If Not $bAttackButtonFound Then
				Local $aRescueAttack = findButton("RescueAtkButton", Default, 1, True)
				$bAttackButtonFound = IsArray($aRescueAttack) And UBound($aRescueAttack, 1) = 2
			EndIf

			If Not $bAttackButtonFound Then
				SetLog("Couldn't find the Attack Button!", $COLOR_ERROR)
				If $g_bDebugImageSave Then SaveDebugImage("AttackButtonNotFound")
				Return
			EndIf

			; Click the lower center of the main Attack button, away from the Builder Base boat.
			ClickP($AttackButtonClickXY, 1, 130, "#0149")


			If _Sleep($DELAYPREPARESEARCH1) Then Return
		EndIf

		Local $bRankedBattle = False, $sRankedResult = ""
		If Not $bNormalMatchOnly And $g_bEnableRankedBattle Then
			$bRankedBattle = JoinRankedBattle($sRankedResult)
			If Not __RunBotCanContinue() Then Return False
			If Not $bRankedBattle And $sRankedResult <> "Completed" Then
				SetLog("Ranked Battle not confirmed; search postponed", $COLOR_WARNING)
				Return False
			EndIf
			If $sRankedResult = "Completed" And $bRankedHaltOverride Then
				$g_aiRankedBattleHaltState[$g_iCurAccount] = 2
				_RBD_CloseBattleSelection()
				Return False
			EndIf
		EndIf

		$g_bCloudsActive = True ; early set of clouds to ensure no android suspend occurs that might cause infinite waits

		If Not $bRankedBattle Then
			; ========================================================================
		  ; 1 Yellow "Find a Match" Button
		  ; ========================================================================
			Local $iYelX = Random(140, 200, 1)
			Local $iYelY = Random(480, 500, 1)
			Click($iYelX, $iYelY)
		  ; ========================================================================
		  ; 2. Green "Attack!" Button
		  ; ========================================================================
			If _Sleep(1500) Then Return ; Wait for popup to appear
			; Range: X(655 to 800), Y(521 to 554)
			Local $iGrnX = Random(700, 770, 1)
			Local $iGrnY = Random(530, 540, 1)
			Click($iGrnX, $iGrnY)
			If _Sleep(1000) Then Return False ; Wait for clouds
			If _RBD_IsRankedMatchButtonVisible() Then
				SetLog("Battle selection remained open; search not started", $COLOR_WARNING)
				Return False
			EndIf
			; ========================================================================
		EndIf
	EndIf
	
	If $g_iSpecialBattleMode <> $eSpecialBattleRevenge And $g_iTownHallLevel <> "" And $g_iTownHallLevel > 0 Then
		$g_iSearchCost += $g_aiSearchCost[$g_iTownHallLevel - 1]
		$g_iStatsTotalGain[$eLootGold] -= $g_aiSearchCost[$g_iTownHallLevel - 1]
	EndIf
	UpdateStats()

	If _Sleep($DELAYPREPARESEARCH2) Then Return

	If isGemOpen(True) Then ; Check for gem window open
		SetLog(" Not enough gold to start searching!", $COLOR_ERROR)
		If _Sleep($DELAYPREPARESEARCH1) Then Return
		CloseWindow() ; Click close attack window "X"
		If _Sleep($DELAYPREPARESEARCH1) Then Return
		$g_bOutOfGold = True ; Set flag for out of gold to search for attack
	EndIf
	SetDebugLog("PrepareSearch exit check $g_bRestart= " & $g_bRestart & ", $g_bOutOfGold= " & $g_bOutOfGold, $COLOR_DEBUG)

	If $g_bRestart Or $g_bOutOfGold Then ; If we have one or both errors, then return
		$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode, collecting resources etc.
		Return
	EndIf

	If IsAttackWhileShieldPage(False) Then ; check for shield window and then button to lose time due attack and click okay
		Local $aiOkayButton = findButton("Okay", Default, 1, True)
		If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then ClickP($aiOkayButton, 1, 120, "#0153") ; Click Okay Button
		If _Sleep($DELAYPREPARESEARCH3) Then Return
	EndIf

	Return True ; Continue with attack
EndFunc   ;==>PrepareSearch

Func OkayLegend()
	Local $aOkayAttackButton
	$aOkayAttackButton = findButton("Okay", Default, 1, True)
	
	If IsArray($aOkayAttackButton) And UBound($aOkayAttackButton, 1) = 2 Then
		ClickP($aOkayAttackButton, 1, 120)
		Return True
	EndIf

	Return False
EndFunc   ;==>OkayLegend
