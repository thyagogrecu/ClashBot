; #FUNCTION# ====================================================================================================================
; Name ..........: GoldElixirChangeEBO  (End Battle Options)
; Description ...: Checks if the gold/elixir changes , Returns True if changed.
; Syntax ........: GoldElixirChangeEBO()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: Sardo (06-2015), Fliegerfaust (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:v
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func GoldElixirChangeEBO()
	; Check the reward before the slower resource/damage OCR sequence.
	CheckTagTeam()
	Static $hInvalidResourceOCRStart = 0
	Static $hObservedAttack = 0
	If $hObservedAttack <> $g_hAttackTimer Then
		$hObservedAttack = $g_hAttackTimer
		$hInvalidResourceOCRStart = 0
	EndIf
	If IsReturnHomeBattlePage(True, False) Then Return False

	Local $Gold1, $Gold2
	Local $GoldChange, $ElixirChange
	Local $Elixir1, $Elixir2
	Local $DarkElixir1, $DarkElixir2
	Local $DarkElixirChange
	Local $txtDiff, $sBattleStatus
	Local $exitOneStar = 0, $exitTwoStars = 0, $exitPctHigher = 0
	Local $Damage, $CurDamage
	Local $bHasDarkElixir2 = False, $bResourceOCRValid = False
	;READ RESOURCES n.1
	$Gold1 = getGoldVillageSearch(45, 68)
	$Elixir1 = getElixirVillageSearch(45, 98)
	$DarkElixir1 = getDarkElixirVillageSearch(45, 126)
	$Damage = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY, 66)
	If Number($Damage) > Number($g_iPercentageDamage) Then $g_iPercentageDamage = Number($Damage)
	Local $bHasDarkElixir1 = $DarkElixir1 <> "" Or _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixirEBO1") Or _ColorCheck(_GetPixelColor(31, 151, True), Hex(0x0F0617, 6), 5)
	$bHasDarkElixir2 = $bHasDarkElixir1
	If $bHasDarkElixir1 Then ; If DE icon found, then base has Dark Elixir
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return

	Else
		$DarkElixir1 = ""
	EndIf

	;CALCULATE WHICH TIMER TO USE
	Local $x = $g_iStopAtkNoLoot1Time * 1000, $y = $g_iStopAtkNoLoot2Time * 1000, $z, $w = $g_iStopAtkPctNoChangeTime * 1000
	Local $bInitialResourceOCR = StringLen($Gold1) > 0 And StringLen($Elixir1) > 0 And _
			(Not $bHasDarkElixir1 Or StringLen($DarkElixir1) > 0)
	If $bInitialResourceOCR And Number($Gold1) < $g_iStopAtkNoLoot2MinGold And _
			Number($Elixir1) < $g_iStopAtkNoLoot2MinElixir And _
			Number($DarkElixir1) < $g_iStopAtkNoLoot2MinDark And _
			$g_bStopAtkNoLoot2Enable Then

		$z = $y
	ElseIf $Damage <> "" And $g_bStopAtkPctNoChangeEnable Then
		$z = $w
	Else
		If $g_bStopAtkNoLoot1Enable Then
			$z = $x
		Else
			$z = AttackRemainingTime()
		EndIf
	EndIf

	;CALCULATE TWO STARS REACH
	If $g_bStopAtkTwoStars And _CheckPixel($aWonTwoStar, True) Then
		SetLog("2 Stars Reached | Ending Battle", $COLOR_INFO)
		$exitTwoStars = 1
		$z = 0
	EndIf

	;CALCULATE ONE STARS REACH
	If $g_bStopAtkOneStar And _CheckPixel($aWonOneStar, True) Then
		SetLog("1 Star Reached | Ending Battle", $COLOR_INFO)
		$exitOneStar = 1
		$z = 0
	EndIf

	; Early Check if Percentage is already higher than set
	If $g_bStopAtkPctHigherEnable And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY, 66)) > Number($g_iStopAtkPctHigherAmt) Then
		SetLog("Damage Above " & Number($g_iStopAtkPctHigherAmt) & "% | Ending Battle", $COLOR_INFO)
		$g_iPercentageDamage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY, 66))
		$exitPctHigher = 1
		$z = 0
	EndIf

	Local $NoResourceOCR = False
	Local $ExitNoLootChange = ($g_bStopAtkNoLoot1Enable Or $g_bStopAtkNoLoot2Enable Or $g_bStopAtkNoResources)

	;MAIN LOOP
	Local $iBegin = __TimerInit()
	Local $iTagTeamPauseStart = GetTagTeamPauseTime()

	Local $iSuspendAndroidTimeOffset = SuspendAndroidTime()
	SetDebugLog("GoldElixirChangeEBO: Start waiting for battle end, Wait: " & $z & ", Offset: " & $iSuspendAndroidTimeOffset)

	Local $iTime = 0
	Local $bOneLoop = True
	While $bOneLoop Or ($iTime < $z And $z > 0 And $iTime >= 0)
		$bOneLoop = False
		If IsReturnHomeBattlePage(True, False) Then
			$hInvalidResourceOCRStart = 0
			Return False
		EndIf

		; Centralized fatal error check while waiting for battle end.
		If CheckCriticalGameError() Then Return False

		; Tag Team selection/deployment is synchronous. Restart this EBO iteration
		; only after it finishes so no exit/resource checks overlap the deploy.
		If CheckTagTeam() Then
			If IsReturnHomeBattlePage(True, False) Then ExitLoop
			ContinueLoop
		EndIf
		;HEALTH HEROES
		CheckHeroesHealth()

		If $g_bCheckKingPower Or $g_bCheckQueenPower Then
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
		Else
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		EndIf

		;--> Read Ressources #2
		$Gold2 = getGoldVillageSearch(45, 68)
		If $Gold2 = "" Then
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return
			$Gold2 = getGoldVillageSearch(45, 68)
		EndIf
		$Elixir2 = getElixirVillageSearch(45, 98)
		$DarkElixir2 = getDarkElixirVillageSearch(45, 126)
		CheckHeroesHealth()
		$bHasDarkElixir2 = $bHasDarkElixir2 Or $DarkElixir2 <> "" Or _CheckPixel($aAtkHasDarkElixir, $g_bCapturePixel, Default, "HasDarkElixirEBO2") Or _ColorCheck(_GetPixelColor(31, 151, True), Hex(0x0F0617, 6), 5)
		If $bHasDarkElixir2 Then ; If DE icon found, then base has Dark Elixir
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO1) Then Return

		Else
			$DarkElixir2 = ""
		EndIf
		$CurDamage = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY, 66)
		;--> Read Ressources #2

		CheckHeroesHealth()

		;WRITE LOG
		Local $iTagTeamPause = GetTagTeamPauseTime() - $iTagTeamPauseStart
		$txtDiff = Round(($z - (__TimerDiff($iBegin) - SuspendAndroidTime() + $iSuspendAndroidTimeOffset - $iTagTeamPause)) / 1000, 0)
		If Number($txtDiff) < 0 Then
			$txtDiff = "0s"
		Else
			Local $m = Int($txtDiff / 60)
			Local $s = $txtDiff - $m * 60
			$txtDiff = ""
			If $m > 0 Then $txtDiff = $m & "m "
			$txtDiff &= $s & "s"
		EndIf
		$bResourceOCRValid = StringLen($Gold2) > 0 And StringLen($Elixir2) > 0 And _
				(Not $bHasDarkElixir2 Or StringLen($DarkElixir2) > 0)
		$NoResourceOCR = Not $bResourceOCRValid
		If Not $NoResourceOCR Then $hInvalidResourceOCRStart = 0
		$sBattleStatus = $txtDiff & _
				" | G:" & ($Gold2 = "" ? "?" : $Gold2) & _
				" E:" & ($Elixir2 = "" ? "?" : $Elixir2) & _
				" DE:" & ($DarkElixir2 = "" ? "?" : $DarkElixir2) & _
				" | " & ($CurDamage = "" ? "?" : $CurDamage) & "%"
		If $NoResourceOCR And CheckTagTeam(True) Then
			ContinueLoop
		EndIf
		If Not $NoResourceOCR Then
			If $g_bDebugSetLog Then
				SetDebugLog("Exit in " & $txtDiff & ", [G]: " & $Gold2 & " [E]: " & $Elixir2 & " [DE]: " & $DarkElixir2 & " [%]: " & $CurDamage & ", Suspend-Time: " & $g_iSuspendAndroidTime & ", Suspend-Count: " & $g_iSuspendAndroidTimeCount & ", Offset: " & $iSuspendAndroidTimeOffset, $COLOR_INFO)
			EndIf
		EndIf

		If Number($CurDamage) > Number($g_iPercentageDamage) Then $g_iPercentageDamage = Number($CurDamage)

		;CALCULATE RESOURCE CHANGES
		If $Gold2 <> "" Or $Elixir2 <> "" Or $DarkElixir2 <> "" Then
			$GoldChange = $Gold2
			$ElixirChange = $Elixir2
			$DarkElixirChange = $DarkElixir2
		EndIf

		;EXIT IF RESOURCES = 0
		If $g_bStopAtkNoResources And Not $NoResourceOCR And Number($Gold2) = 0 And Number($Elixir2) = 0 And Number($DarkElixir2) = 0 Then
			SetLog("No Resources Left | Ending Battle", $COLOR_INFO)
			If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
			ExitLoop
		EndIf

		;EXIT IF TWO STARS REACH
		If $g_bStopAtkTwoStars And _CheckPixel($aWonTwoStar, True) Then
			SetLog("2 Stars Reached | Ending Battle", $COLOR_INFO)
			$exitTwoStars = 1
			ExitLoop
		EndIf

		;EXIT IF ONE STARS REACH
		If $g_bStopAtkOneStar And _CheckPixel($aWonOneStar, True) Then
			SetLog("1 Star Reached | Ending Battle", $COLOR_INFO)
			$exitOneStar = 1
			ExitLoop
		EndIf

		; Empty OCR can occur while the Tag Team reward closes. Only a confirmed
		; result screen may use missing resource text as a battle-end signal.
		If getGoldVillageSearch(45, 68) = "" And getElixirVillageSearch(45, 98) = "" Then
			If IsReturnHomeBattlePage(True, False) Then ExitLoop
		EndIf

		If $g_bStopAtkPctHigherEnable And $exitPctHigher = 0 And Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY, 66)) > Number($g_iStopAtkPctHigherAmt) Then
			SetLog("Damage Above " & Number($g_iStopAtkPctHigherAmt) & "% | Ending Battle", $COLOR_INFO)
			$g_iPercentageDamage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY, 66))
			$exitPctHigher = 1
			ExitLoop
		EndIf

		;RETURN IF RESOURCES CHANGE DETECTED
		If ($g_bStopAtkNoLoot1Enable Or $g_bStopAtkNoLoot2Enable) And ($Gold1 <> $Gold2 Or $Elixir1 <> $Elixir2 Or $DarkElixir1 <> $DarkElixir2) Then
			SetLog("Loot Changed | " & $sBattleStatus, $COLOR_INFO)
			Return True
		EndIf

		;RETURN IF DAMAGE CHANGE DETECTED
		If $g_bStopAtkPctNoChangeEnable And $Damage <> "" And $CurDamage <> "" And (Number($Damage) <> Number($CurDamage)) Then
			SetLog("Damage Changed | " & $sBattleStatus, $COLOR_INFO)
			$g_iPercentageDamage = Number(getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY, 66))
			Return True
		EndIf

		SetLog("Waiting | " & $sBattleStatus, $COLOR_INFO)

		$iTime = __TimerDiff($iBegin) - SuspendAndroidTime() + $iSuspendAndroidTimeOffset - $iTagTeamPause
	WEnd ; END MAIN LOOP

	;FIRST CHECK... EXIT FOR ONE STAR REACH
	If $g_bStopAtkOneStar And $exitOneStar = 1 Then
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf

	;SECOND CHECK... EXIT FOR TWO STARS REACH
	If $g_bStopAtkTwoStars And $exitTwoStars = 1 Then
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf

	; A configured damage limit is a definitive end-battle condition even when
	; resource OCR is temporarily unavailable.
	If $g_bStopAtkPctHigherEnable And $exitPctHigher = 1 Then Return False

	If $g_bStopAtkPctNoChangeEnable And $Damage <> "" And $CurDamage <> "" And Number($Damage) = Number($CurDamage) Then
		SetLog("No Damage Change | Ending Battle", $COLOR_INFO)
		Return False
	EndIf

	; Invalid resource OCR is not proof that the battle ended. Restart the
	; observation window briefly unless the result screen is positively confirmed.
	If $NoResourceOCR Then
		If IsReturnHomeBattlePage(True, False) Then
			$hInvalidResourceOCRStart = 0
			Return False
		EndIf
		If $hInvalidResourceOCRStart = 0 Then $hInvalidResourceOCRStart = __TimerInit()
		If __TimerDiff($hInvalidResourceOCRStart) >= 120000 Then
			SetLog("Resource OCR unavailable for 2 minutes; ending battle", $COLOR_WARNING)
			$hInvalidResourceOCRStart = 0
			Return False
		EndIf
		Return True
	EndIf

	;FOURTH CHECK... IF RESOURCES = 0 THEN EXIT
	If $g_bStopAtkNoResources And $NoResourceOCR = False And Number($Gold2) = 0 And Number($Elixir2) = 0 And Number($DarkElixir2) = 0 Then
		SetLog("No Resources Left | Ending Battle", $COLOR_INFO)
		If _Sleep($DELAYGOLDELIXIRCHANGEEBO2) Then Return
		Return False
	EndIf



	;FIFTH CHECK... IF VALUES NOT CHANGED  RETURN FALSE ELSE RETURN TRUE
	If $bInitialResourceOCR And (Number($Gold1) = Number($Gold2) And Number($Elixir1) = Number($Elixir2) And Number($DarkElixir1) = Number($DarkElixir2)) Then
		If $g_bStopAtkNoLoot1Enable Or $g_bStopAtkNoLoot2Enable Then
			SetLog("No Loot Change | Ending Battle", $COLOR_INFO)
			Return False
		EndIf
	Else
		If $g_bDebugSetLog Then
			SetDebugLog("Gold1: " & Number($Gold1) & "  Gold2: " & Number($Gold2), $COLOR_DEBUG)
			SetDebugLog("Elixir1: " & Number($Elixir1) & "  Elixir2: " & Number($Elixir2), $COLOR_DEBUG)
			SetDebugLog("Dark Elixir1: " & Number($DarkElixir1) & "  Dark Elixir2: " & Number($DarkElixir2), $COLOR_DEBUG)
		EndIf
	EndIf

	Return True

EndFunc   ;==>GoldElixirChangeEBO
