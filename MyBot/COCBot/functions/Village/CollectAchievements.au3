; #FUNCTION# ====================================================================================================================
; Name ..........: collectAchievements
; Description ...: Collect Achievement rewards
; Syntax ........: collectAchievements()
; Parameters ....:
; Return values .: None
; Author ........: Nytol (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_iCollectAchievementsLoopCount = 0
Global $g_iCollectAchievementsRunOn = 0
Global $g_iFoundScrollEnd = 0

Func CollectAchievements($bTestMode = False) ;Run with True parameter if testing to run regardless of checkbox setting, randomization skips and runstate check

	If Not $bTestMode Then
		If Not $g_bChkCollectAchievements Or Not $g_bRunState Then Return
		If Not CollectAchievementsRandomization() Then Return
	EndIf

	ClearScreen()
	If Not IsMainPage() Then Return
	If Not CollectAchievementsProfileBadgeDetected() Then
		SetLog("No achievement available to collect")
		Return
	EndIf

	SetLog("Collecting Achievement Rewards", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Open the player profile from its current main-screen position.
	Click(Random(42, 54, 1), Random(76, 88, 1), 1, 120, "Open Player Profile")
	If _Sleep(1500) Then Return

	Local $bRewardsCollected = CollectAchievementsClaimReward(True, 0)
	If Not $bRewardsCollected Then
		If Not $g_bRunState Then Return
		SetDebugLog("Claim Reward not found; opening My Profile", $COLOR_INFO)
		Click(Random(116, 128, 1), Random(145, 157, 1), 1, 120, "Open My Profile")
		If _Sleep(1500) Then Return
		$bRewardsCollected = CollectAchievementsClaimReward(True)
	EndIf

	If Not $bRewardsCollected Then
		SetDebugLog("There are no achievement rewards to collect", $COLOR_INFO)
		If _Sleep(1000) Then Return
		CloseWindow2()
		Return
	EndIf

	If _Sleep(1000) Then Return
	SetDebugLog("All achievement rewards collected successfully", $COLOR_SUCCESS)
	CloseWindow2()
	Return
EndFunc   ;==>CollectAchievements

Func CollectAchievementsProfileBadgeDetected()
	; Search the badge ring around its reference point; the center may be covered by the counter text.
	Local Const $iLeft = 61, $iTop = 22, $iRight = 89, $iBottom = 50
	Local $aBadge = _PixelSearch($iLeft, $iTop, $iRight, $iBottom, Hex(0xCB1C36, 6), 55)
	If Not IsArray($aBadge) Then $aBadge = _PixelSearch($iLeft, $iTop, $iRight, $iBottom, Hex(0xFE0B0C, 6), 65)
	If Not IsArray($aBadge) Then $aBadge = _PixelSearch($iLeft, $iTop, $iRight, $iBottom, Hex(0xE22234, 6), 60)
	If IsArray($aBadge) Then
		SetDebugLog("Achievement notification detected at " & $aBadge[0] & "," & $aBadge[1], $COLOR_ACTION)
		Return True
	EndIf
	Return False
EndFunc   ;==>CollectAchievementsProfileBadgeDetected

Func CollectAchievementsRandomization() ; Add some randomization to avoid running the check every loop if a friend request exists

	If $g_iCollectAchievementsRunOn = 0 Then ; Run on first loop
		SetDebugLog("First Run so set randomization parameters and collect", $COLOR_INFO)
		$g_iCollectAchievementsRunOn = Random(2, 5, 1)
		$g_iCollectAchievementsLoopCount = $g_iCollectAchievementsLoopCount + 1
		Return True
	ElseIf $g_iCollectAchievementsLoopCount = $g_iCollectAchievementsRunOn Then ; Run if loop count matches random value
		SetDebugLog("Loop count matches, lets collect!", $COLOR_SUCCESS)
		Return True
	Else ; Return false in none of the above conditions match
		SetDebugLog("Skipping collection for randomization.", $COLOR_INFO)
		SetDebugLog("Collection will happen in '" & $g_iCollectAchievementsRunOn - $g_iCollectAchievementsLoopCount & "' more loops", $COLOR_INFO)
		$g_iCollectAchievementsLoopCount = $g_iCollectAchievementsLoopCount + 1
		Return False
	EndIf
EndFunc   ;==>CollectAchievementsRandomization

Func CollectAchievementsClaimReward($bSuppressNoRewardLog = False, $iMaxScrollAttempts = 3)
	If Not $g_bRunState Then Return

	Local $sSearchArea = GetDiamondFromRect2(660, 130 + $g_iMidOffsetY, 845, 645 + $g_iMidOffsetY)
	Local $aClaimButtons, $aClaimButtonXY, $aButton
	Local $iScrollAttempts = 0, $iClaimAttempts = 0, $iClaimed = 0
	Local Const $iMaxClaimAttempts = 50

	While $g_bRunState And $iScrollAttempts <= $iMaxScrollAttempts And $iClaimAttempts < $iMaxClaimAttempts
		$aClaimButtons = findMultiple($g_sImgAchievementsClaimReward, $sSearchArea, $sSearchArea, 0, 1000, 0, "objectname,objectpoints", True)
		If IsArray($aClaimButtons) And UBound($aClaimButtons) > 0 Then
			$aButton = $aClaimButtons[0]
			$aClaimButtonXY = decodeMultipleCoords($aButton[1])
			If IsArray($aClaimButtonXY) And UBound($aClaimButtonXY) > 0 Then
				$aButton = $aClaimButtonXY[0]
				Click($aButton[0], $aButton[1])
				$iClaimAttempts += 1
				$iClaimed += 1
				SetLog("Achievement Reward Collected", $COLOR_SUCCESS)
				If _Sleep(1200) Then Return
				ContinueLoop
			EndIf
		EndIf

		If $iScrollAttempts = $iMaxScrollAttempts Then ExitLoop
		ClickDrag(400, 555 + $g_iMidOffsetY, 400, 270 + $g_iMidOffsetY, 400)
		$iScrollAttempts += 1
		If _Sleep(700) Then Return
	WEnd

	If $iClaimed > 0 Then Return True
	If Not $bSuppressNoRewardLog Then SetLog("No achievement rewards to collect")
	Return False
EndFunc   ;==>CollectAchievementsClaimReward

