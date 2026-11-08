; #FUNCTION# ====================================================================================================================
; Name ..........: ReturnHome
; Description ...: Returns home when in battle, will take screenshot and check for gold/elixir change unless specified not to.
; Syntax ........: ReturnHome([$TakeSS = 1[, $GoldChangeCheck = True]])
; Parameters ....: $TakeSS              - [optional] flag for saving a snapshot of the winning loot. Default is 1.
;                  $GoldChangeCheck     - [optional] an unknown value. Default is True.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (07-2015), MonkeyHunter (01-2016), CodeSlinger69 (01-2017), MonkeyHunter (03-2017), Moebius14 (09-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ReturnHome($TakeSS = 1, $GoldChangeCheck = True) ;Return main screen
	SetDebugLog("ReturnHome function... (from matchmode=" & $g_iMatchMode & " - " & $g_asModeText[$g_iMatchMode] & ")", $COLOR_DEBUG)
	CheckTagTeam(True)
	Local $counter = 0
	Local $hBitmap_Scaled
	Local $i, $j
	Local $aiSurrenderButton
	Local $bWasRevengeBattle = ($g_iSpecialBattleMode = $eSpecialBattleRevenge)
	Local $bWasRankedBattle = ($g_iSpecialBattleMode = $eSpecialBattleRanked)

	If $GoldChangeCheck Then
		If Not (IsReturnHomeBattlePage(True, False)) Then ; if already in return home battle page do not wait and try to activate Hero Ability and close battle
			SetLog("Checking if the battle has finished")
			While GoldElixirChangeEBO()
				If $g_bRestart Then Return
				If _Sleep($DELAYRETURNHOME1) Then
					Return
				EndIf
				If $g_bRestart Then Return
				; Do not wait for another full resource/damage OCR cycle to handle the reward.
				CheckTagTeam()
			WEnd
			; GoldElixirChangeEBO can restart CoC on disconnect/OOS. Do not continue the
			; ReturnHome/surrender flow after the current attack context has been invalidated.
			If $g_bRestart Then Return
			If IsAttackPage() And $g_iSmartZapTiming = $eSmartZapTimingEnd Then SmartZap() ; Check to see if we should zap the DE Drills
		Else
			SetDebugLog("Battle already over", $COLOR_DEBUG)
		EndIf
	EndIf

	; Reset hero variables
	$g_bCheckKingPower = False
	$g_bCheckQueenPower = False
	$g_bCheckPrincePower = False
	$g_bCheckWardenPower = False
	$g_bCheckChampionPower = False
	$g_bCheckDukePower = False
	$g_bDropKing = False
	$g_bDropQueen = False
	$g_bDropPrince = False
	$g_bDropWarden = False
	$g_bDropChampion = False
	$g_bDropDuke = False
	$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0
	$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0
	$g_aHeroesTimerActivation[$eHeroMinionPrince] = 0
	$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0
	$g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0
	$g_aHeroesTimerActivation[$eHeroDukeIndex] = 0
	
	; Reset building info used to attack base
	_ObjDeleteKey($g_oBldgAttackInfo, "") ; Remove all Keys from dictionary

	SetLog("Returning Home", $COLOR_INFO)
	If $g_bRunState = False Then Return
	If ReturnHomeCheckObstacle() Then Return

	; ---- CLICK SURRENDER BUTTON ----
	If Not (IsReturnHomeBattlePage(True, False)) Then ; check if battle is already over
		Local $bret = False
		For $i = 0 To 5 ; dynamic wait loop for surrender button to appear (if end battle or surrender button are not found in 5*(200)ms + 10*(200)ms or 3 seconds, then give up.)
			If ReturnHomeCheckObstacle() Then Return
			SetDebugLog("Waiting for surrender button to appear #" & $i)
			$aiSurrenderButton = findButton("EndBattle", Default, 1, True)
			If IsArray($aiSurrenderButton) And UBound($aiSurrenderButton, 1) = 2 Then
				If IsAttackPage() Then ; verify still on attack page, and battle has not ended magically before clicking
					ClickP($aiSurrenderButton, 1, 120, "#0099") ;Click Surrender
					$j = 0
					While 1 ; dynamic wait for Okay button
						If ReturnHomeCheckObstacle() Then Return
						SetDebugLog("Waiting for OK button to appear #" & $j)
						If IsEndBattlePage(False) Then
							ClickOkay("SurrenderOkay") ; Click Okay to Confirm surrender
							ExitLoop 2
						Else
							$j += 1
						EndIf
						If ReturnHomeMainPage() Then Return
						If $j > 10 Then
							Select
								Case $i < 5 ; if Okay button not found in 10*(200)ms or 2 seconds, then give up.
									ExitLoop
								Case $i = 5 ; if Okay button not found Then Restart COC.
									$bret = True
									ExitLoop 2
							EndSelect
						EndIf
						If _Sleep($DELAYRETURNHOME5) Then Return
					WEnd
				EndIf
			Else
				SetDebugLog("Cannot Find Surrender Button", $COLOR_ERROR)
			EndIf
			If ReturnHomeMainPage() Then Return
			If _Sleep($DELAYRETURNHOME5) Then Return
		Next
		If $bret Then
			SetLog("Have strange problem Couldn't Click Okay to Confirm surrender, Restarting Clash of Clans", $COLOR_ERROR)
			CloseCoC(True)
			If Not $g_bRunState Then Return
			If Not checkMainScreen(False) Then
				SetLog("Unable to return home after Clash of Clans restart", $COLOR_ERROR)
				Return SetError(1, 0, False)
			EndIf
			Return
		EndIf
	Else
		SetDebugLog("Battle already over", $COLOR_DEBUG)
	EndIf
	If _Sleep($DELAYRETURNHOME2) Then Return ; short wait for return to main

	TrayTip($g_sBotTitle, "", BitOR($TIP_ICONASTERISK, $TIP_NOSOUND)) ; clear village search match found message

	If CheckAndroidReboot() Then Return

	If $GoldChangeCheck Then
		If IsAttackPage() Then
			$counter = 0
			While _ColorCheck(_GetPixelColor($aRtnHomeCheck1[0], $aRtnHomeCheck1[1], True), Hex($aRtnHomeCheck1[2], 6), $aRtnHomeCheck1[3]) = False And _ColorCheck(_GetPixelColor($aRtnHomeCheck2[0], $aRtnHomeCheck2[1], True), Hex($aRtnHomeCheck2[2], 6), $aRtnHomeCheck2[3]) = False ; test for Return Home Button
				If ReturnHomeCheckObstacle() Then Return
				SetDebugLog("Waiting for return home button to appear #" & $counter)
				If _Sleep($DELAYRETURNHOME2) Then ExitLoop
				$counter += 1
				If $counter > 40 Then ExitLoop
			WEnd
		EndIf
		If _Sleep($DELAYRETURNHOME3) Then Return ; wait for all report details
		If ReturnHomeCheckObstacle() Then Return
		If $g_iSmartZapTiming = $eSmartZapTimingMid And IsAttackPage() Then SmartZap()
		_CaptureRegion()
		AttackReport($bWasRevengeBattle, False, $bWasRankedBattle)
		$g_sLootFileName = ""
	EndIf
	If $TakeSS = 1 And $GoldChangeCheck Then
		SetLog("Taking snapshot of your loot", $COLOR_SUCCESS)
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN
		Local $sLootFileName = ""
		_CaptureRegion()
		If $g_hBitmap <> 0 Then
			Local $iBitmapWidth = _GDIPlus_ImageGetWidth($g_hBitmap)
			Local $iBitmapHeight = _GDIPlus_ImageGetHeight($g_hBitmap)
			If $iBitmapWidth > 0 And $iBitmapHeight > 0 Then
				$hBitmap_Scaled = _GDIPlus_ImageResize($g_hBitmap, $iBitmapWidth / 2, $iBitmapHeight / 2) ;resize image
			EndIf
		EndIf
		If $hBitmap_Scaled <> 0 Then
			; screenshot filename according with new options around filenames
			If $g_bScreenshotLootInfo Then
				$sLootFileName = $Date & "_" & $Time & " G" & $g_iStatsLastAttack[$eLootGold] & " E" & $g_iStatsLastAttack[$eLootElixir] & " DE" & _
						$g_iStatsLastAttack[$eLootDarkElixir] & " T" & $g_iStatsLastAttack[$eLootTrophy] & " S" & StringFormat("%3s", $g_iSearchCount) & ".jpg"
			Else
				$sLootFileName = $Date & "_" & $Time & ".jpg"
			EndIf
			If _GDIPlus_ImageSaveToFile($hBitmap_Scaled, $g_sProfileLootsPath & $sLootFileName) Then
				$g_sLootFileName = $sLootFileName
			Else
				SetLog("Unable to save loot snapshot", $COLOR_ERROR)
			EndIf
			_GDIPlus_ImageDispose($hBitmap_Scaled)
		Else
			SetLog("Unable to save loot snapshot: invalid capture", $COLOR_ERROR)
		EndIf
	EndIf

	; Push images if requested
	If $GoldChangeCheck Then PushMsg("LastRaid")

	$i = 0 ; Reset Loop counter
	Local $iExitLoop = -1
	Local $iEndFightSceneLoopLimit = IsClashOfCardsEventActive() ? 1 : 10
	While 1
		If ReturnHomeCheckObstacle() Then Return
		SetDebugLog("Waiting for end fight scene to appear #" & $i)
		If IsReturnHomeChestButtonVisible() Then
			If IsReturnHomeChestPage() Then $iExitLoop = $i
		ElseIf IsReturnHomeButtonVisible() Then
			PureClickP($aReturnHomeButton, 1, 120, "#0101") ; Click Return Home Button
			If _Sleep($DELAYRETURNHOME1) Then Return

			If IsReturnHomeButtonVisible() Then ; if still on page, try fallback position
				Local $aReturnHomeButtonFallback[4] = [Random(425, 435), Random(575 + $g_iMidOffsetY, 585 + $g_iMidOffsetY), 0x6CBB1F, 15]
				PureClickP($aReturnHomeButtonFallback, 1, 120, "#0101") ; Click Return Home Button Fallback
				If _Sleep($DELAYRETURNHOME1) Then Return
			EndIf

			; sometimes 1st click is not closing, so try again
			$iExitLoop = $i
		EndIf

		If $i > $iEndFightSceneLoopLimit Or ($iExitLoop > -1 And $i > $iExitLoop + 2) Then ExitLoop ; allow a few retries when the result screen is still visible
		$i += 1
		If _Sleep($DELAYRETURNHOME5) Then Return
	WEnd
	If _Sleep(IsClashOfCardsEventActive() ? 250 : $DELAYRETURNHOME1) Then Return ; short wait for screen to close

	$counter = 0
	Local $bClashOfCardsChecked = False
	Local $iSpecialScreenDelay = IsClashOfCardsEventActive() ? 250 : $DELAYRETURNHOME4
	SetDebugLog("Waiting for special screen to appear")
	While 1
		If ReturnHomeCheckObstacle() Then Return
		If _Sleep($iSpecialScreenDelay) Then Return
		Local $bIsMain = _CheckPixel($aIsMain, $g_bCapturePixel, Default, "IsMain")
		Local $bIsMainGrayed = IsMainGrayed()
		If StarBonus() Then
			SetLog("Star Bonus window closed chief!", $COLOR_INFO)
			ContinueLoop
		EndIf
		Select
			Case Not $bIsMain And Not $bIsMainGrayed
				If TreasureHunt($counter, IsClashOfCardsEventActive() ? 1 : 10) Then
					SetLog("Treasury Hunt window closed chief!", $COLOR_INFO) ; Check for Treasury Hunt Event window to (2024-09) update
					ContinueLoop
				EndIf
				If Not $bClashOfCardsChecked And IsClashOfCardsEventActive() Then
					$bClashOfCardsChecked = True
					If CheckClashOfCards(True, True) Then
						SetLog("Clash of Cards pack claimed!", $COLOR_SUCCESS)
						ContinueLoop
					EndIf
				EndIf
			Case $bIsMainGrayed
				; Voucher / Magic Snack Freebie
				If Freebie() Then
					SetLog("Freebie window closed chief!", $COLOR_INFO) ; Check for Freebie Event window (2025-03)
					ContinueLoop
				EndIf
				; Season End Start
				If EndStartSeason() Then
					SetLog("Ended/New Season window closed chief!", $COLOR_INFO) ; Check for Ended or Started Season Window
					ContinueLoop
				EndIf
				; Clan Capital Result
				If UBound(decodeSingleCoord(FindImageInPlace2("CCResults", $g_sImgClanCapitalResults, 210, 130 + $g_iMidOffsetY, 320, 240 + $g_iMidOffsetY, True))) > 1 Then
					If _ColorCheck(_GetPixelColor(247, 311 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) And _ColorCheck(_GetPixelColor(669, 242 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0xFFFFFF, 6), 10) Then
						CloseWindow()
						If _Sleep($DELAYCHECKOBSTACLES1) Then Return
						ContinueLoop
					EndIf
				EndIf
				If CheckStreakEvent() Then
					SetLog("Streak Event window closed chief!", $COLOR_INFO) ; Check for Streak Event window to (2024-06) update
					ContinueLoop
				EndIf
		EndSelect
		$g_bFullArmy = False ; forcing check the army
		$g_bIsFullArmywithHeroesAndSpells = False ; forcing check the army
		If ReturnHomeMainPage() Then Return
		$counter += 1
		SetDebugLog("Loop #" & $counter)
		If $counter >= 30 Or isProblemAffect(True) Then
			SetLog("Cannot return home", $COLOR_ERROR)
			checkMainScreen()
			Return
		EndIf
	WEnd
EndFunc   ;==>ReturnHome

Func ReturnHomeCheckObstacle()
	CheckTagTeam(True)
	If CheckCriticalGameError() Then Return True
	_CaptureRegions()
	If Not IsProblemAffect(False) Then Return False
	SetLog("Error window detected while returning home", $COLOR_ERROR)
	If Not checkObstacles() Then CloseCoC(True)
	Return True
EndFunc   ;==>ReturnHomeCheckObstacle

Func IsReturnHomeButtonVisible()
	If IsReturnHomeBattlePage(True, False) Then Return True
	If _CheckPixel($aReturnHomeButton, $g_bCapturePixel, Default, "ReturnHomeButton") Then Return True
	If _CheckPixel($aEndFightSceneBtn, $g_bCapturePixel, Default, "ReturnHomeButtonTop") Then Return True
	If IsReturnHomeChestPage(False, False) Then Return True
	Return False
EndFunc   ;==>IsReturnHomeButtonVisible

Func ReturnHomeMainPage()
	If IsMainPage(1) Or IsMainPageBuilderBase(1) Then
		; Preserve Ranked/Revenge mode until the attack flow has completely returned home.
		$g_iSpecialBattleMode = $eSpecialBattleNone
		$g_hAttackTimer = 0
		$g_iAttackTimerOffset = Default
		SetLogCentered(" BOT LOG ", Default, Default, True)
		Return True
	EndIf
	Return False
EndFunc   ;==>ReturnHomeMainPage

Func CheckStreakEvent()
	SetDebugLog("Begin Steak Event window check", $COLOR_DEBUG1)
	If Not $g_bRunState Then Return
	Local $bRet = False
	Local $sAllCoordsString, $aAllCoordsTemp, $aTempCoords
	Local $aAllCoords[0][2]
	If _Sleep($DELAYSTARBONUS100) Then Return
	Local $aContinueButton = findButton("Continue", Default, 1, True)
	If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
		ClickP($aContinueButton, 1, 120, "#0433")
		If _Sleep(2500) Then Return
	EndIf
	Local $bCheckStreakEventWindow = _ColorCheck(_GetPixelColor(290, 150 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0x9B071A, 6), 20) And _ColorCheck(_GetPixelColor(560, 150 + $g_iMidOffsetY, $g_bCapturePixel), Hex(0x9B071A, 6), 20)
	If Not $bCheckStreakEventWindow Then
		SetDebugLog("Streak Event window not found?", $COLOR_DEBUG)
		Return $bRet
	EndIf
	$bRet = True
	Local $SearchArea = GetDiamondFromRect("20,260(820,140)")
	Local $aResult = findMultiple(@ScriptDir & "\imgxml\Events\DailyChallenges\", $SearchArea, $SearchArea, 0, 1000, 10, "objectname,objectpoints", True)
	If $aResult <> "" And IsArray($aResult) Then
		For $t = 0 To UBound($aResult) - 1
			Local $aResultArray = $aResult[$t]     ; ["Button Name", "x1,y1", "x2,y2", ...]
			SetDebugLog("Find Claim buttons, $aResultArray[" & $t & "]: " & _ArrayToString($aResultArray))
			If IsArray($aResultArray) And $aResultArray[0] = "ClaimBtn" Then
				$sAllCoordsString = _ArrayToString($aResultArray, "|", 1)     ; "x1,y1|x2,y2|..."
				$aAllCoordsTemp = decodeMultipleCoords($sAllCoordsString, 50, 50)     ; [{coords1}, {coords2}, ...]
				For $k = 0 To UBound($aAllCoordsTemp, 1) - 1
					$aTempCoords = $aAllCoordsTemp[$k]
					_ArrayAdd($aAllCoords, Number($aTempCoords[0]) & "|" & Number($aTempCoords[1]))
				Next
			EndIf
		Next
		RemoveDupXY($aAllCoords)
		For $j = 0 To UBound($aAllCoords) - 1
			Click($aAllCoords[$j][0], $aAllCoords[$j][1], 1, 120, "Claim " & $j + 1)         ; Click Claim button
			If _Sleep(2000) Then Return
		Next
	EndIf
	CloseWindow2()
	Return $bRet
EndFunc   ;==>CheckStreakEvent

Func TreasureHunt($counter = 0, $iDetectionLoopLimit = 10)
	Static $s_iTreasureHuntChestLoop = 0
	Local Const $iTreasureHuntChestLoopLimit = 5

	If Not $g_bRunState Then Return
	If isOnBuilderBase(True) Then
		SetDebugLog("Skipping Treasure Hunt check on Builder Base", $COLOR_DEBUG)
		Return False
	EndIf
	Local $bret = False
	Local $bHitDone = False

	If $counter > 0 Then
		Local $aContinueButton = findButton("Continue", Default, 1, True) ; In case all below failed in the ReturnHome loop, unlikely
		If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
			ClickP($aContinueButton, 1, 120, "#0433")
			SetLog("Reward Received", $COLOR_SUCCESS)
			$s_iTreasureHuntChestLoop = 0
			If _Sleep(IsClashOfCardsEventActive() ? 350 : $DELAYTREASURY2) Then Return
			Return True
		EndIf
	EndIf
	If $counter >= 3 Then
		SetDebugLog("Skipping Treasure Hunt check after repeated attempts", $COLOR_DEBUG)
		Return False
	EndIf

	Local $bLoop = 0
	Local $bCountedChestAttempt = False
	While 1
		If Not $g_bRunState Then Return
		Local $aiHammerOnRock = decodeSingleCoord(FindImageInPlace2("HammerOnRock", $ImgHammerOnRock, 340, 470 + $g_iMidOffsetY, 430, 520 + $g_iMidOffsetY, True))
		If IsArray($aiHammerOnRock) And UBound($aiHammerOnRock) = 2 Then
			If Not $bCountedChestAttempt Then
				$bCountedChestAttempt = True
				$s_iTreasureHuntChestLoop += 1
				If $s_iTreasureHuntChestLoop >= $iTreasureHuntChestLoopLimit Then
					SetLog("Treasure Hunt chest loop detected, restarting Clash of Clans", $COLOR_ERROR)
					SaveDebugImage("TreasureHuntChestLoop")
					$s_iTreasureHuntChestLoop = 0
					CloseCoC(True)
					Return False
				EndIf
				SetLog("Opening Chest", $COLOR_SUCCESS)
			EndIf
			For $i = 0 To 20
				If Not $g_bRunState Then Return
				Local $aiLockOfChest = decodeSingleCoord(FindImageInPlace2("LockOfBox", $ImgLockOfChest, 400, 305 + $g_iMidOffsetY, 480, 410 + $g_iMidOffsetY, True))
				If IsArray($aiLockOfChest) And UBound($aiLockOfChest) = 2 Then
					Local $iHammers = QuickMIS("CNX", $ImgHammersOnRock, 340, 470 + $g_iMidOffsetY, 510, 520 + $g_iMidOffsetY)
					If IsArray($iHammers) And UBound($iHammers) > 1 And UBound($iHammers, $UBOUND_COLUMNS) > 1 Then
						_RemoveDuplicateTreasureHuntHammers($iHammers)
						If UBound($iHammers) <= 1 Then
							If _Sleep(IsClashOfCardsEventActive() ? 250 : 1000) Then Return
							ContinueLoop
						EndIf
						SetLog("Detected Hammers : " & UBound($iHammers), $COLOR_INFO)
						For $t = 0 To UBound($iHammers) - 1
							If Not $g_bRunState Then Return
							Local $ButtonClickX = Random($aiLockOfChest[0] - 20, $aiLockOfChest[0] + 20, 1)
							Local $ButtonClickY = Random($aiLockOfChest[1] - 20, $aiLockOfChest[1] + 20, 1)
							SetLog(($t = 0 ? "Hit Number : #" : "#") & $t + 1 & ".. ", $COLOR_ACTION, Default, Default, Default, Default, ($t = 0 ? Default : False), ($t = UBound($iHammers) - 1 ? Default : False))
							Click($ButtonClickX, $ButtonClickY, 1, IsClashOfCardsEventActive() ? 60 : 130, "LockHit")
							If $t = UBound($iHammers) - 1 Then
								If _Sleep(IsClashOfCardsEventActive() ? 600 : Random(2000, 3000, 1)) Then Return
							Else
								If _Sleep(IsClashOfCardsEventActive() ? 250 : Random(700, 1200, 1)) Then Return
							EndIf
						Next
						$bHitDone = True
						ExitLoop 2
					EndIf
				EndIf
				If _Sleep(IsClashOfCardsEventActive() ? 250 : 1000) Then Return
			Next
		EndIf
		If _Sleep(IsClashOfCardsEventActive() ? 250 : 1000) Then Return
		$bLoop += 1
		If $bLoop >= $iDetectionLoopLimit Then Return $bret
	WEnd

	If $bHitDone Then
		SetLog("Continue...", $COLOR_INFO)
		For $i = 0 To 30
			If Not $g_bRunState Then Return
			If ClickChestContinueButton(IsClashOfCardsEventActive() ? 150 : 500, "#0433") Then
				SetLog("Reward Received", $COLOR_SUCCESS)
				$bret = True
				$s_iTreasureHuntChestLoop = 0
				If _Sleep(IsClashOfCardsEventActive() ? 350 : $DELAYTREASURY2) Then Return
				ExitLoop
			EndIf

			Local $aContinueButton = findButton("Continue", Default, 1, True)
			If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
				If _Sleep(IsClashOfCardsEventActive() ? 150 : 500) Then Return
				ClickP($aContinueButton, 1, 120, "#0433")
				SetLog("Reward Received", $COLOR_SUCCESS)
				$bret = True
				$s_iTreasureHuntChestLoop = 0
				If _Sleep(IsClashOfCardsEventActive() ? 350 : $DELAYTREASURY2) Then Return
				ExitLoop
			EndIf
			If _Sleep(300) Then Return
			If $i = 30 Then
				SaveDebugImage("ChestRoomError")
				SetLog("Cannot find Continue button", $COLOR_ERROR)
				If _Sleep(200) Then Return
				Click(430, 530 + $g_iMidOffsetY)
			EndIf
		Next
	EndIf

	Return $bret

EndFunc   ;==>TreasureHunt

Func _RemoveDuplicateTreasureHuntHammers(ByRef $aHammers, $iDistance = 10)
	Local $aUniqueHammers[0][4]
	For $i = 0 To UBound($aHammers) - 1
		Local $bDuplicate = False
		For $j = 0 To UBound($aUniqueHammers) - 1
			If Abs($aHammers[$i][1] - $aUniqueHammers[$j][1]) <= $iDistance And _
					Abs($aHammers[$i][2] - $aUniqueHammers[$j][2]) <= $iDistance Then
				$bDuplicate = True
				ExitLoop
			EndIf
		Next
		If Not $bDuplicate Then _ArrayAdd($aUniqueHammers, $aHammers[$i][0] & "|" & $aHammers[$i][1] & "|" & $aHammers[$i][2] & "|" & $aHammers[$i][3])
	Next
	$aHammers = $aUniqueHammers
EndFunc   ;==>_RemoveDuplicateTreasureHuntHammers
