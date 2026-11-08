; #FUNCTION# ====================================================================================================================
; Name ..........: AttackReport
; Description ...: This function will report the loot from the last Attack: gold, elixir, dark elixir and trophies.
;                  It will also update the statistics to the GUI (Last Attack).
; Syntax ........: AttackReport([$bRevengeBattle = False[, $bTestMode = False[, $bRankedBattle = False]]])
; Parameters ....: $bRevengeBattle - [optional] apply Revenge Battle ribbon detection and OCR normalization. Default is False.
;                  $bTestMode      - [optional] read values only, without updating attack totals. Default is False.
;                  $bRankedBattle  - [optional] read Ranked Battle trophy gain from the fourth loot row. Default is False.
; Return values .: None
; Author ........: Hervidero (02-2015), Sardo (05-2015), Hervidero (12-2015)
; Modified ......: Sardo (05-2015), Hervidero (05-2015), Knowjack (07-2015), MikeD (04-2021)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func AttackReport($bRevengeBattle = False, $bTestMode = False, $bRankedBattle = False)
	Static $iBonusLast = 0 ; last attack Bonus percentage
	Local $iCount
	Local $sReportMode = _AttackReportModeName($bRevengeBattle, $bRankedBattle)
	Local $aLootCoords = _AttackReportLootCoords($sReportMode)
	Local $aBonusCoords = _AttackReportBonusCoords($sReportMode)
	Local $iLootGoldX = $aLootCoords[0][0], $iLootGoldY = $aLootCoords[0][1]
	Local $iLootElixirX = $aLootCoords[1][0], $iLootElixirY = $aLootCoords[1][1]
	Local $iLootDarkX = $aLootCoords[2][0], $iLootDarkY = $aLootCoords[2][1]
	Local $iLootTrophyX = $aLootCoords[3][0], $iLootTrophyY = $aLootCoords[3][1]
	Local $iBonusPercentX = $aBonusCoords[0][0], $iBonusPercentY = $aBonusCoords[0][1]
	Local $iBonusGoldX = $aBonusCoords[1][0], $iBonusGoldY = $aBonusCoords[1][1]
	Local $iBonusElixirX = $aBonusCoords[2][0], $iBonusElixirY = $aBonusCoords[2][1]
	Local $iBonusDarkX = $aBonusCoords[3][0], $iBonusDarkY = $aBonusCoords[3][1]
	Local $bHasDarkLoot = False, $bHasDarkBonus = False
	Local $bReportReadWarning = False
	Local $sReadyGold = ""

	$iCount = 0 ; Reset loop counter
	If Not $bTestMode Then
		While _AttackReportSceneReady($sReportMode) = False ; check for normal/ranked gold ribbon or revenge red ribbon before reading values
			$iCount += 1
			If _Sleep($DELAYATTACKREPORT1) Then Return
			SetDebugLog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds", $COLOR_DEBUG)
			If $iCount > (($sReportMode = "revenge") ? 3 : 10) Then ExitLoop ; revenge uses a different report ribbon, so fallback quickly
		WEnd
	EndIf
	If $iCount > (($sReportMode = "revenge") ? 3 : 10) Then
		SetLog("End of Attack scene slow to appear, attack values may not be correct", $COLOR_INFO)
		$bReportReadWarning = True
	EndIf

	$iCount = 0 ; reset loop counter
	If Not $bTestMode Then
		While True
			$sReadyGold = _AttackReportReadValue($sReportMode, "lootgold", $iLootGoldX, $iLootGoldY)
			If $sReadyGold <> "" Then ExitLoop
			$iCount += 1
			If _Sleep($DELAYATTACKREPORT1) Then Return
			SetDebugLog("Waiting Attack Report Ready, " & ($iCount / 2) & " Seconds", $COLOR_DEBUG)
			If $iCount > (($sReportMode = "revenge") ? 2 : 10) Then ExitLoop ; wait 10*500ms = 5 seconds max before we have call the OCR read an error
		WEnd
	EndIf
	If $iCount > (($sReportMode = "revenge") ? 2 : 10) Then
		SetLog("End of Attack scene read gold error, attack values may not be correct", $COLOR_INFO)
		$bReportReadWarning = True
	EndIf

	If $bRankedBattle Then
		$g_iStatsLastAttack[$eLootGold] = ($sReadyGold <> "" ? $sReadyGold : _AttackReportReadValue($sReportMode, "lootgold", $iLootGoldX, $iLootGoldY))
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootElixir] = _AttackReportReadValue($sReportMode, "lootelixir", $iLootElixirX, $iLootElixirY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootDarkElixir] = _AttackReportReadValue($sReportMode, "de", $iLootDarkX, $iLootDarkY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		$g_iStatsLastAttack[$eLootTrophy] = _AttackReportReadValue($sReportMode, "trophy", $iLootTrophyX, $iLootTrophyY)
		If _Sleep($DELAYATTACKREPORT2) Then Return
		SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]) & " [TR]: " & _NumberFormat($g_iStatsLastAttack[$eLootTrophy]), $COLOR_SUCCESS)
	Else
		$bHasDarkLoot = $bRevengeBattle Or _ColorCheck(_GetPixelColor($aAtkRprtDECheck[0], $aAtkRprtDECheck[1], True), Hex($aAtkRprtDECheck[2], 6), $aAtkRprtDECheck[3])
		If $bHasDarkLoot Then ; if the color of the DE drop detected
			$g_iStatsLastAttack[$eLootGold] = ($sReadyGold <> "" ? $sReadyGold : _AttackReportReadValue($sReportMode, "lootgold", $iLootGoldX, $iLootGoldY))
			If _Sleep($DELAYATTACKREPORT2) Then Return
			$g_iStatsLastAttack[$eLootElixir] = _AttackReportReadValue($sReportMode, "lootelixir", $iLootElixirX, $iLootElixirY)
			If _Sleep($DELAYATTACKREPORT2) Then Return
			$g_iStatsLastAttack[$eLootDarkElixir] = _AttackReportReadValue($sReportMode, "de", $iLootDarkX, $iLootDarkY)
			If _Sleep($DELAYATTACKREPORT2) Then Return
			$g_iStatsLastAttack[$eLootTrophy] = 0
			SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsLastAttack[$eLootDarkElixir]), $COLOR_SUCCESS)
		Else
			$g_iStatsLastAttack[$eLootGold] = ($sReadyGold <> "" ? $sReadyGold : _AttackReportReadValue($sReportMode, "lootgold", $iLootGoldX, $iLootGoldY))
			If _Sleep($DELAYATTACKREPORT2) Then Return
			$g_iStatsLastAttack[$eLootElixir] = _AttackReportReadValue($sReportMode, "lootelixir", $iLootElixirX, $iLootElixirY)
			If _Sleep($DELAYATTACKREPORT2) Then Return
			$g_iStatsLastAttack[$eLootTrophy] = 0
			$g_iStatsLastAttack[$eLootDarkElixir] = ""
			SetLog("Loot: [G]: " & _NumberFormat($g_iStatsLastAttack[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsLastAttack[$eLootElixir]), $COLOR_SUCCESS)
		EndIf
	EndIf

	If $g_iStatsLastAttack[$eLootTrophy] >= 0 Then
		$iBonusLast = Number(_AttackReportReadValue($sReportMode, "bonusperc", $iBonusPercentX, $iBonusPercentY))
		If $sReportMode = "revenge" And $iBonusLast = 1 Then $iBonusLast = 100
		Local $iCheckBonusLast = StringTrimRight($iBonusLast, 1)
		If $iBonusLast > 100 And $iCheckBonusLast = 7 Then ; If % is detected as 7.
			If $g_bDebugImageSave Then SaveDebugImage("AttackReport", True)
			Local $Loop = 0
			While ($iBonusLast > 100 And $iCheckBonusLast = 7)
				If $Loop = 20 Then
					If $iBonusLast > 100 And $iCheckBonusLast = 7 Then $iBonusLast = StringTrimRight($iBonusLast, 1)
					ExitLoop
				EndIf
				$iBonusLast = Number(_AttackReportReadValue($sReportMode, "bonusperc", $iBonusPercentX, $iBonusPercentY))
				If $sReportMode = "revenge" And $iBonusLast = 1 Then $iBonusLast = 100
				$iCheckBonusLast = StringTrimRight($iBonusLast, 1)
				$Loop += 1
				If _Sleep(250) Then Return
			WEnd
		EndIf
		If $iBonusLast > 0 Then
			$bHasDarkBonus = ($sReportMode = "revenge") Or _ColorCheck(_GetPixelColor($aAtkRprtDECheck2[0], $aAtkRprtDECheck2[1], True), Hex($aAtkRprtDECheck2[2], 6), $aAtkRprtDECheck2[3])
			If $bHasDarkBonus Then
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootGold] = _AttackReportReadValue($sReportMode, "bonus", $iBonusGoldX, $iBonusGoldY)
				$g_iStatsBonusLast[$eLootGold] = StringReplace($g_iStatsBonusLast[$eLootGold], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootElixir] = _AttackReportReadValue($sReportMode, "bonus", $iBonusElixirX, $iBonusElixirY)
				$g_iStatsBonusLast[$eLootElixir] = StringReplace($g_iStatsBonusLast[$eLootElixir], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootDarkElixir] = _AttackReportReadValue($sReportMode, "bonusde", $iBonusDarkX, $iBonusDarkY)
				$g_iStatsBonusLast[$eLootDarkElixir] = StringReplace($g_iStatsBonusLast[$eLootDarkElixir], "+", "")
				SetLog("Bonus Percentage: " & $iBonusLast & "%", $COLOR_SUCCESS)
				SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]) & " [DE]: " & _NumberFormat($g_iStatsBonusLast[$eLootDarkElixir]), $COLOR_SUCCESS)
			Else
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootGold] = _AttackReportReadValue($sReportMode, "bonus", $iBonusGoldX, $iBonusGoldY)
				$g_iStatsBonusLast[$eLootGold] = StringReplace($g_iStatsBonusLast[$eLootGold], "+", "")
				If _Sleep($DELAYATTACKREPORT2) Then Return
				$g_iStatsBonusLast[$eLootElixir] = _AttackReportReadValue($sReportMode, "bonus", $iBonusElixirX, $iBonusElixirY)
				$g_iStatsBonusLast[$eLootElixir] = StringReplace($g_iStatsBonusLast[$eLootElixir], "+", "")
				$g_iStatsBonusLast[$eLootDarkElixir] = 0
				SetLog("Bonus Percentage: " & $iBonusLast & "%", $COLOR_SUCCESS)
				SetLog("Bonus [G]: " & _NumberFormat($g_iStatsBonusLast[$eLootGold]) & " [E]: " & _NumberFormat($g_iStatsBonusLast[$eLootElixir]), $COLOR_SUCCESS)
			EndIf
		Else
			SetLog("No Bonus")
		EndIf
	Else
		$g_iStatsBonusLast[$eLootGold] = 0
		$g_iStatsBonusLast[$eLootElixir] = 0
		$g_iStatsBonusLast[$eLootDarkElixir] = 0
	EndIf

	; check stars earned
	Local $starsearned = _AttackReportReadStars($sReportMode)
	SetLog("Stars Earned: " & $starsearned, $COLOR_SUCCESS)
	_AttackReportNormalizeDamage($starsearned)

	Local $AtkLogTxt
	Local $iLogMatchMode = $g_iMatchMode
	Local $sBaseType = ($iLogMatchMode = $DB ? "DB" : "LB")
	Local $sTrophyLog = "--"
	If $bRankedBattle And $g_iStatsLastAttack[$eLootTrophy] <> "" Then $sTrophyLog = StringFormat("%2d", $g_iStatsLastAttack[$eLootTrophy])

	$g_iStatsBonusLast[$eLootGold] = $g_iStatsBonusLast[$eLootGold] / 1000

	$AtkLogTxt = "|" & StringFormat("%2d", $g_iCurAccount + 1) & "|" & _NowTime(4) & "|"
	$AtkLogTxt &= StringFormat("%4s", $sBaseType) & "|"
	$AtkLogTxt &= ($g_iSearchCount > 999 ? StringFormat("%6s", "###") : StringFormat("%6d", $g_iSearchCount)) & "|"
	$AtkLogTxt &= StringFormat("%9d", $g_iStatsLastAttack[$eLootGold]) & "|"
	$AtkLogTxt &= StringFormat("%9d", $g_iStatsLastAttack[$eLootElixir]) & "|"
	$AtkLogTxt &= StringFormat("%7d", $g_iStatsLastAttack[$eLootDarkElixir]) & "|"
	$AtkLogTxt &= $sTrophyLog & "|"
	$AtkLogTxt &= StringFormat("%2d", $starsearned) & "|"
	$AtkLogTxt &= StringFormat("%3d", $g_iPercentageDamage) & "|"
	$AtkLogTxt &= StringFormat("%4d", $g_iStatsBonusLast[$eLootGold]) & "K|"
	;$AtkLogTxt &= StringFormat("%4d", $g_iStatsBonusLast[$eLootElixir]) & "k|"
	$AtkLogTxt &= StringFormat("%5d", $g_iStatsBonusLast[$eLootDarkElixir]) & "|"

	$g_iStatsBonusLast[$eLootGold] = $g_iStatsBonusLast[$eLootGold] * 1000

	; Stats Attack
	$g_sTotalDamage = $g_iPercentageDamage
	$g_sAttacksides = $g_iSidesAttack
	$g_sLootGold = $g_iStatsLastAttack[$eLootGold]
	$g_sLootElixir = $g_iStatsLastAttack[$eLootElixir]
	$g_sLootDE = $g_iStatsLastAttack[$eLootDarkElixir]
	$g_sLeague = $sTrophyLog
	$g_sBonusGold = $g_iStatsBonusLast[$eLootGold]
	$g_sBonusElixir = $g_iStatsBonusLast[$eLootElixir]
	$g_sBonusDE = $g_iStatsBonusLast[$eLootDarkElixir]
	$g_sStarsEarned = $starsearned

	If $bTestMode Then
		SetLog("AttackReport PNG Test Finished", $COLOR_INFO)
		Return
	EndIf

	If $bReportReadWarning Then
		SetAtkLog($AtkLogTxt, "", $COLOR_ERROR)
	Else
		SetAtkLog($AtkLogTxt, "", $COLOR_BLACK)
	EndIf

	; rename or delete zombie
	If $g_bDebugDeadBaseImage Then
		setZombie($g_iStatsLastAttack[$eLootElixir])
	EndIf

	; Share Replay
	If $g_bShareAttackEnable Then
		If (Number($g_iStatsLastAttack[$eLootGold]) >= Number($g_iShareMinGold)) And (Number($g_iStatsLastAttack[$eLootElixir]) >= Number($g_iShareMinElixir)) And (Number($g_iStatsLastAttack[$eLootDarkElixir]) >= Number($g_iShareMinDark)) Then
			SetLog("Reached minimum Loot values. Share Replay")
			$g_bShareAttackEnableNow = True
		Else
			SetLog("Below minimum Loot values. No Share Replay")
			$g_bShareAttackEnableNow = False
		EndIf
	EndIf

	If $g_iFirstAttack = 0 Then $g_iFirstAttack = 1
	$g_iStatsTotalGain[$eLootGold] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
	$g_aiTotalGoldGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootGold] + $g_iStatsBonusLast[$eLootGold]
	$g_iStatsTotalGain[$eLootElixir] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
	$g_aiTotalElixirGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootElixir] + $g_iStatsBonusLast[$eLootElixir]
	If $g_iStatsStartedWith[$eLootDarkElixir] <> "" Then
		$g_iStatsTotalGain[$eLootDarkElixir] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
		$g_aiTotalDarkGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootDarkElixir] + $g_iStatsBonusLast[$eLootDarkElixir]
	EndIf
	$g_iStatsTotalGain[$eLootTrophy] += $g_iStatsLastAttack[$eLootTrophy]
	$g_aiTotalTrophyGain[$g_iMatchMode] += $g_iStatsLastAttack[$eLootTrophy]
	$g_aiAttackedVillageCount[$g_iMatchMode] += 1
	UpdateStats()
	UpdateSDataBase()
	If ProfileSwitchAccountEnabled() Then
		SetSwitchAccLog(" - Acc. " & $g_iCurAccount + 1 & ", Attack: " & $g_aiAttackedCount)
	EndIf
	$g_iActualTrainSkip = 0
	$g_iPercentageDamage = 0
	$g_iSidesAttack = 0

	Return True
EndFunc   ;==>AttackReport

Func _AttackReportModeName($bRevengeBattle, $bRankedBattle)
	If $bRankedBattle Then Return "ranked"
	If $bRevengeBattle Then Return "revenge"
	Return "normal"
EndFunc   ;==>_AttackReportModeName

Func _AttackReportLootCoords($sReportMode)
	Local $aLootCoords[4][2]

	Switch $sReportMode
		Case "ranked"
			$aLootCoords[0][0] = 300 ; Gold
			$aLootCoords[0][1] = 280 + $g_iMidOffsetY
			$aLootCoords[1][0] = 300 ; Elixir
			$aLootCoords[1][1] = 318 + $g_iMidOffsetY
			$aLootCoords[2][0] = 335 ; Dark Elixir
			$aLootCoords[2][1] = 356 + $g_iMidOffsetY
			$aLootCoords[3][0] = 405 ; Trophies
			$aLootCoords[3][1] = 392 + $g_iMidOffsetY
		Case "revenge"
			$aLootCoords[0][0] = 320 ; Gold
			$aLootCoords[0][1] = 300 + $g_iMidOffsetY
			$aLootCoords[1][0] = 320 ; Elixir
			$aLootCoords[1][1] = 341 + $g_iMidOffsetY
			$aLootCoords[2][0] = 350 ; Dark Elixir
			$aLootCoords[2][1] = 382 + $g_iMidOffsetY
			$aLootCoords[3][0] = 420 ; Trophies unused
			$aLootCoords[3][1] = 402 + $g_iMidOffsetY
		Case Else ; normal
			$aLootCoords[0][0] = 320 ; Gold
			$aLootCoords[0][1] = 300 + $g_iMidOffsetY
			$aLootCoords[1][0] = 320 ; Elixir
			$aLootCoords[1][1] = 341 + $g_iMidOffsetY
			$aLootCoords[2][0] = 350 ; Dark Elixir
			$aLootCoords[2][1] = 382 + $g_iMidOffsetY
			$aLootCoords[3][0] = 420 ; Trophies unused
			$aLootCoords[3][1] = 402 + $g_iMidOffsetY
	EndSwitch

	Return $aLootCoords
EndFunc   ;==>_AttackReportLootCoords

Func _AttackReportBonusCoords($sReportMode)
	Local $aBonusCoords[4][2]

	Switch $sReportMode
		Case "normal", "ranked", "revenge"
			$aBonusCoords[0][0] = 655 ; Percent
			$aBonusCoords[0][1] = 300 + $g_iMidOffsetY
			$aBonusCoords[1][0] = 660 ; Gold
			$aBonusCoords[1][1] = 333 + $g_iMidOffsetY
			$aBonusCoords[2][0] = 660 ; Elixir
			$aBonusCoords[2][1] = 364 + $g_iMidOffsetY
			$aBonusCoords[3][0] = 695 ; Dark Elixir
			$aBonusCoords[3][1] = 396 + $g_iMidOffsetY
	EndSwitch

	Return $aBonusCoords
EndFunc   ;==>_AttackReportBonusCoords

Func _AttackReportNormalizeDamage($iStarsEarned)
	Local $iDamage = Number($g_iPercentageDamage)

	If $iStarsEarned >= 3 And $iDamage < 100 Then
		If $g_bDebugSetLog Then SetDebugLog("AttackReport: damage normalized from " & $g_iPercentageDamage & " to 100 because stars earned = " & $iStarsEarned, $COLOR_DEBUG)
		$g_iPercentageDamage = 100
		Return
	EndIf

	If $iDamage > 100 Then
		If $g_bDebugSetLog Then SetDebugLog("AttackReport: damage clamped from " & $g_iPercentageDamage & " to 100", $COLOR_DEBUG)
		$g_iPercentageDamage = 100
	ElseIf $iDamage < 0 Then
		If $g_bDebugSetLog Then SetDebugLog("AttackReport: damage clamped from " & $g_iPercentageDamage & " to 0", $COLOR_DEBUG)
		$g_iPercentageDamage = 0
	EndIf
EndFunc   ;==>_AttackReportNormalizeDamage

Func _AttackReportReadStars($sReportMode)
	If $sReportMode = "revenge" Then
		Local $aRevengeStars[3][4] = [[350, 160, 0xD9E0EB, 35], [400, 160, 0xF4F5FF, 35], [510, 160, 0xD9E0EB, 35]]
		Local $iRevengeStars = 0
		For $i = 0 To UBound($aRevengeStars) - 1
			If _ColorCheck(_GetPixelColor($aRevengeStars[$i][0], $aRevengeStars[$i][1], True), Hex($aRevengeStars[$i][2], 6), $aRevengeStars[$i][3]) Then $iRevengeStars += 1
		Next
		Return $iRevengeStars
	EndIf

	Local $iStars = 0
	If _ColorCheck(_GetPixelColor($aWonOneStarAtkRprt[0], $aWonOneStarAtkRprt[1], True), Hex($aWonOneStarAtkRprt[2], 6), $aWonOneStarAtkRprt[3]) Then $iStars += 1
	If _ColorCheck(_GetPixelColor($aWonTwoStarAtkRprt[0], $aWonTwoStarAtkRprt[1], True), Hex($aWonTwoStarAtkRprt[2], 6), $aWonTwoStarAtkRprt[3]) Then $iStars += 1
	If _ColorCheck(_GetPixelColor($aWonThreeStarAtkRprt[0], $aWonThreeStarAtkRprt[1], True), Hex($aWonThreeStarAtkRprt[2], 6), $aWonThreeStarAtkRprt[3]) Then $iStars += 1
	Return $iStars
EndFunc   ;==>_AttackReportReadStars

Func _AttackReportSceneReady($sReportMode)
	If _CheckPixel($aEndFightSceneAvl, True) Then Return True
	If $sReportMode <> "revenge" Then Return False

	; Revenge uses the same report geometry, but its victory ribbon is red instead of gold.
	Local $aRevengeRedRibbon[3][4] = [[260, 195, 0xF55C3D, 35], [430, 195, 0xE1472E, 35], [600, 195, 0xFA6F48, 35]]
	Local $iRedPixels = 0
	For $i = 0 To UBound($aRevengeRedRibbon) - 1
		If _ColorCheck(_GetPixelColor($aRevengeRedRibbon[$i][0], $aRevengeRedRibbon[$i][1], True), Hex($aRevengeRedRibbon[$i][2], 6), $aRevengeRedRibbon[$i][3]) Then $iRedPixels += 1
	Next
	If $iRedPixels >= 2 Then Return True

	Return IsReturnHomeBattlePage(True, False)
EndFunc   ;==>_AttackReportSceneReady

Func _AttackReportReadValue($sReportMode, $sType, $x, $y)
	If $sReportMode = "ranked" And ($sType = "lootgold" Or $sType = "lootelixir" Or $sType = "de" Or $sType = "trophy") Then
		Return _AttackReportReadRankedLoot($sType, $x, $y)
	EndIf

	If $sReportMode = "ranked" Then
		Switch $sType
			Case "bonus"
				Return getOcrAndCapture("coc-report-bonus", $x, $y, 90, 20, True)
			Case "bonusde"
				Return getOcrAndCapture("coc-report-bonus", $x - 15, $y, 70, 20, True)
		EndSwitch
	EndIf

	If $sReportMode <> "revenge" Then Return _AttackReportReadModel($sType, $x, $y)

	Local $aOffsets[1][2] = [[0, 0]]
	Local $sBestRaw = "", $sBestClean = ""
	Local $iBestX = $x, $iBestY = $y, $iBestScore = -1
	For $i = 0 To UBound($aOffsets) - 1
		Local $iTryX = $x + $aOffsets[$i][0]
		Local $iTryY = $y + $aOffsets[$i][1]
		Local $sTryRaw = _AttackReportReadRevengeOcr($sType, $iTryX, $iTryY)
		If $sType = "bonusperc" Then $sTryRaw = _AttackReportNormalizeRevengeBonusPercentRaw($sTryRaw)
		Local $sTryClean = StringRegExpReplace($sTryRaw, "[^0-9-]", "")
		If $sType = "bonusperc" Then $sTryClean = _AttackReportNormalizeRevengeBonusPercent($sTryClean)
		Local $iScore = _AttackReportRevengeOcrScore($sType, $sTryClean)
		If $iScore > $iBestScore Then
			$sBestRaw = $sTryRaw
			$sBestClean = $sTryClean
			$iBestX = $iTryX
			$iBestY = $iTryY
			$iBestScore = $iScore
		EndIf
	Next

	If $g_bDebugSetLog Then SetDebugLog("AttackReport revenge OCR " & $sType & " best [" & $iBestX & "," & $iBestY & "] raw='" & $sBestRaw & "' clean='" & $sBestClean & "'", $COLOR_DEBUG)
	Return $sBestClean
EndFunc   ;==>_AttackReportReadValue

; #FUNCTION# ===========================================================================================================
; Name ..........: _AttackReportReadRankedLoot
; Description ...: Reads ranked loot with space for larger values while excluding the resource icons.
; ======================================================================================================================
Func _AttackReportReadRankedLoot($sType, $x, $y)
	Local $iWidth = ($sType = "trophy" ? 50 : 458 - $x)
	_CaptureRegion2($x, $y, $x + $iWidth, $y + 22)
	If @error Or $g_hHBitmap2 = 0 Then Return ""
	Local $hMask = _AttackReportMaskRankedLoot($g_hHBitmap2)
	If $hMask = 0 Then Return ""
	Local $sResult = StringReplace(getOcr($hMask, "coc-report-ranked"), " ", "")
	If $sResult = "" Then $sResult = StringReplace(getOcr($hMask, "coc-report-ranked"), " ", "")
	_WinAPI_DeleteObject($hMask)
	If $g_bDebugSetLog Then SetDebugLog("AttackReport ranked OCR " & $sType & "='" & $sResult & "'", $COLOR_DEBUG)
	Return $sResult
EndFunc   ;==>_AttackReportReadRankedLoot

; #FUNCTION# ===========================================================================================================
; Name ..........: _AttackReportReadModel
; Description ...: Reads report values using isolated xbebenk OCR models and the existing crop sizes.
; Remarks .......: Preserves the original capture policy for Normal and Revenge report fields.
; ======================================================================================================================
Func _AttackReportReadModel($sType, $x, $y)
	Switch $sType
		Case "loot", "lootgold", "lootelixir"
			Return getOcrAndCapture("coc-report-loot", $x, $y, 160, 22, True)
		Case "de"
			Return getOcrAndCapture("coc-report-loot", $x, $y, 120, 22, True)
		Case "trophy"
			Return getOcrAndCapture("coc-report-loot", $x, $y, 50, 22, True)
		Case "bonusperc"
			Return getOcrAndCapture("coc-report-bonus", $x, $y, 48, 16, True)
		Case "bonus", "bonusde"
			Return getOcrAndCapture("coc-report-bonus", $x, $y, 98, 20, True)
	EndSwitch
	Return ""
EndFunc   ;==>_AttackReportReadModel

; #FUNCTION# ===========================================================================================================
; Name ..........: _AttackReportReadRevengeOcr
; Description ...: Reads Revenge values before applying the existing normalization and scoring.
; ======================================================================================================================
Func _AttackReportReadRevengeOcr($sType, $x, $y)
	Return _AttackReportReadModel($sType, $x, $y)
EndFunc   ;==>_AttackReportReadRevengeOcr

Func _AttackReportNormalizeRevengeBonusPercentRaw($sRaw)
	If $sRaw = "" Then Return ""
	$sRaw = StringReplace($sRaw, "O", "0")
	$sRaw = StringReplace($sRaw, "o", "0")
	$sRaw = StringReplace($sRaw, "D", "0")
	$sRaw = StringReplace($sRaw, "Q", "0")
	$sRaw = StringReplace($sRaw, "I", "1")
	$sRaw = StringReplace($sRaw, "l", "1")
	$sRaw = StringReplace($sRaw, "|", "1")
	$sRaw = StringReplace($sRaw, "!", "1")
	Return $sRaw
EndFunc   ;==>_AttackReportNormalizeRevengeBonusPercentRaw

Func _AttackReportNormalizeRevengeBonusPercent($sClean)
	If $sClean = "" Then Return ""
	If StringLeft($sClean, 3) = "100" Then Return "100"
	If $sClean = "00" Then Return "100"
	If StringLen($sClean) > 2 And StringRight($sClean, 2) = "96" Then $sClean = StringTrimRight($sClean, 2)
	If StringLen($sClean) > 2 And StringRight($sClean, 1) = "8" Then $sClean = StringTrimRight($sClean, 1)
	If Number($sClean) > 100 And StringLen($sClean) > 2 Then $sClean = StringLeft($sClean, 2)
	Return $sClean
EndFunc   ;==>_AttackReportNormalizeRevengeBonusPercent

Func _AttackReportRevengeOcrScore($sType, $sClean)
	If $sClean = "" Then Return -1
	If $sType = "bonusperc" And (Number($sClean) < 1 Or Number($sClean) > 100) Then Return -1
	Return StringLen($sClean)
EndFunc   ;==>_AttackReportRevengeOcrScore

; #FUNCTION# ===========================================================================================================
; Name ..........: _AttackReportMaskRankedLoot
; Description ...: Isolates neutral white ranked-result digits without resizing or changing the crop coordinates.
; ======================================================================================================================
Func _AttackReportMaskRankedLoot($hSource)
	Local $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hSource)
	If $hImage = 0 Then Return 0
	Local $iWidth = _GDIPlus_ImageGetWidth($hImage), $iHeight = _GDIPlus_ImageGetHeight($hImage)
	Local $tData = _GDIPlus_BitmapLockBits($hImage, 0, 0, $iWidth, $iHeight, BitOR($GDIP_ILMREAD, $GDIP_ILMWRITE), $GDIP_PXF32ARGB)
	If @error Then
		_GDIPlus_BitmapDispose($hImage)
		Return 0
	EndIf
	Local $pScan = DllStructGetData($tData, "Scan0"), $iStride = DllStructGetData($tData, "Stride")
	For $y = 0 To $iHeight - 1
		Local $tRow = DllStructCreate("dword[" & $iWidth & "]", $pScan + $y * $iStride)
		For $x = 1 To $iWidth
			Local $iPixel = DllStructGetData($tRow, 1, $x)
			Local $r = BitAND(BitShift($iPixel, 16), 255), $g = BitAND(BitShift($iPixel, 8), 255), $b = BitAND($iPixel, 255)
			Local $bWhite = $r >= 210 And $g >= 210 And $b >= 210 And Abs($r - $g) < 40 And Abs($r - $b) < 40 And Abs($g - $b) < 40
			DllStructSetData($tRow, 1, ($bWhite ? 0xFFFFFFFF : 0xFF000000), $x)
		Next
	Next
	_GDIPlus_BitmapUnlockBits($hImage, $tData)
	Local $hResult = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	_GDIPlus_BitmapDispose($hImage)
	Return $hResult
EndFunc   ;==>_AttackReportMaskRankedLoot

