; #FUNCTION# ====================================================================================================================
; Name ..........: CheckHeroesHealth
; Description ...:
; Syntax ........: CheckHeroesHealth()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: MonkeyHunter(03-2017), Fliegerfaust (11-2017), Moebius14 (01-2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func CheckHeroesHealth()
	If Not ($g_bIsHeroesDropped Or $g_bDropKing Or $g_bDropQueen Or $g_bDropPrince Or $g_bDropWarden Or $g_bDropChampion Or $g_bDropDuke) Then Return

	If $g_bCheckKingPower Or $g_bCheckQueenPower Or $g_bCheckPrincePower Or $g_bCheckWardenPower Or $g_bCheckChampionPower Or $g_bCheckDukePower Then
		ForceCaptureRegion() ; ensure no screenshot caching kicks in

		Local $aDisplayTime[$eHeroCount] = [0, 0, 0, 0, 0, 0] ; array to hold converted timerdiff into seconds

		If $g_bDebugSetLog Then
			SetDebugLog("CheckHeroesHealth() for Queen started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateQueen = 0 Or $g_iActivateQueen = 2 Then
			If $g_bCheckQueenPower And ($g_aHeroesTimerActivation[$eHeroArcherQueen] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroArcherQueen]) > $DELAYCHECKHEROESHEALTH) Then
				Local $asQueenResult = decodeSingleCoord(FindImageInPlace2("Queen", $g_sImgQueenBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Queen
				If IsArray($asQueenResult) And UBound($asQueenResult) = 2 Then
					Local $aQueenHealthCopy = $aQueenHealth
					$aQueenHealthCopy[0] = $asQueenResult[0] - $aQueenHealthCopy[4]
					Local $QueenPixelColor = _GetPixelColor($aQueenHealthCopy[0], $aQueenHealthCopy[1], $g_bCapturePixel)
					If $g_bDebugSetLog Then SetDebugLog(" Queen _GetPixelColor(" & $aQueenHealthCopy[0] & "," & $aQueenHealthCopy[1] & "): " & $QueenPixelColor, $COLOR_DEBUG)
					If Not _CheckPixel2($aQueenHealthCopy, $QueenPixelColor, "Red+Blue") Then
						SetLog("Queen is getting weak, activating ability")
						ClickP($asQueenResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iQueenSlot
						$g_bCheckQueenPower = False
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_iActivateQueen = 1 Or $g_iActivateQueen = 2 Then
			If $g_bCheckQueenPower Then
				If IsHeroAbilityDelayElapsed($eHeroArcherQueen, $g_iDelayActivateQueen, $aDisplayTime) Then
					Local $asQueenResult = decodeSingleCoord(FindImageInPlace2("Queen", $g_sImgQueenBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Queen
					If IsArray($asQueenResult) And UBound($asQueenResult) = 2 Then
						SetLog("Activating Queen's ability after " & $aDisplayTime[$eHeroArcherQueen] & "'s")
						ClickP($asQueenResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iQueenSlot
						$g_bCheckQueenPower = False ; Reset check power flag
						$g_aHeroesTimerActivation[$eHeroArcherQueen] = 0 ; Reset Timer
					EndIf
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetLog Then
			SetDebugLog("CheckHeroesHealth() for King started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateKing = 0 Or $g_iActivateKing = 2 Then
			If $g_bCheckKingPower And ($g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroBarbarianKing]) > $DELAYCHECKHEROESHEALTH) Then
				Local $asKingResult = decodeSingleCoord(FindImageInPlace2("King", $g_sImgKingBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for King
				If IsArray($asKingResult) And UBound($asKingResult) = 2 Then
					Local $aKingHealthCopy = $aKingHealth ; copy ScreenCoordinates array to modify locally with dynamic X coordinate from slotposition
					$aKingHealthCopy[0] = $asKingResult[0] - $aKingHealthCopy[4]
					Local $KingPixelColor = _GetPixelColor($aKingHealthCopy[0], $aKingHealthCopy[1], $g_bCapturePixel)
					If $g_bDebugSetLog Then SetDebugLog("King _GetPixelColor(" & $aKingHealthCopy[0] & "," & $aKingHealthCopy[1] & "): " & $KingPixelColor, $COLOR_DEBUG)
					If Not _CheckPixel2($aKingHealthCopy, $KingPixelColor, "Red+Blue") Then
						SetLog("King is getting weak, activating ability")
						ClickP($asKingResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iKingSlot
						$g_bCheckKingPower = False
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_iActivateKing = 1 Or $g_iActivateKing = 2 Then
			If $g_bCheckKingPower Then
				If IsHeroAbilityDelayElapsed($eHeroBarbarianKing, $g_iDelayActivateKing, $aDisplayTime) Then
					Local $asKingResult = decodeSingleCoord(FindImageInPlace2("King", $g_sImgKingBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for King
					If IsArray($asKingResult) And UBound($asKingResult) = 2 Then
						SetLog("Activating King's ability after " & $aDisplayTime[$eHeroBarbarianKing] & "'s")
						ClickP($asKingResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iKingSlot
						$g_bCheckKingPower = False ; Reset check power flag
						$g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0 ; Reset Timer
					EndIf
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetLog Then
			SetDebugLog("CheckHeroesHealth() for Prince started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivatePrince = 0 Or $g_iActivatePrince = 2 Then
			If $g_bCheckPrincePower And ($g_aHeroesTimerActivation[$eHeroMinionPrince] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroMinionPrince]) > $DELAYCHECKHEROESHEALTH) Then
				Local $asPrinceResult = decodeSingleCoord(FindImageInPlace2("Prince", $g_sImgPrinceBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Prince
				If IsArray($asPrinceResult) And UBound($asPrinceResult) = 2 Then
					Local $aPrinceHealthCopy = $aPrinceHealth
					$aPrinceHealthCopy[0] = $asPrinceResult[0] - $aPrinceHealthCopy[4]
					Local $PrincePixelColor = _GetPixelColor($aPrinceHealthCopy[0], $aPrinceHealthCopy[1], $g_bCapturePixel)
					If $g_bDebugSetLog Then SetDebugLog(" Prince _GetPixelColor(" & $aPrinceHealthCopy[0] & "," & $aPrinceHealthCopy[1] & "): " & $PrincePixelColor, $COLOR_DEBUG)
					If Not _CheckPixel2($aPrinceHealthCopy, $PrincePixelColor, "Red+Blue") Then
						SetLog("Prince is getting weak, activating ability")
						ClickP($asPrinceResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iPrinceSlot
						$g_bCheckPrincePower = False
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_iActivatePrince = 1 Or $g_iActivatePrince = 2 Then
			If $g_bCheckPrincePower Then
				If IsHeroAbilityDelayElapsed($eHeroMinionPrince, $g_iDelayActivatePrince, $aDisplayTime) Then
					Local $asPrinceResult = decodeSingleCoord(FindImageInPlace2("Prince", $g_sImgPrinceBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Prince
					If IsArray($asPrinceResult) And UBound($asPrinceResult) = 2 Then
						SetLog("Activating Prince's ability after " & $aDisplayTime[$eHeroMinionPrince] & "'s")
						ClickP($asPrinceResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iPrinceSlot
						$g_bCheckPrincePower = False ; Reset check power flag
						$g_aHeroesTimerActivation[$eHeroMinionPrince] = 0 ; Reset Timer
					EndIf
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetLog Then
			SetDebugLog("CheckHeroesHealth() for Warden started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateWarden = 0 Or $g_iActivateWarden = 2 And ($g_aHeroesTimerActivation[$eHeroGrandWarden] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroGrandWarden]) > $DELAYCHECKHEROESHEALTH) Then
			If $g_bCheckWardenPower Then
				Local $asWardenResult = decodeSingleCoord(FindImageInPlace2("Warden", $g_sImgWardenBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Warden
				If IsArray($asWardenResult) And UBound($asWardenResult) = 2 Then
					Local $aWardenHealthCopy = $aWardenHealth
					$aWardenHealthCopy[0] = $asWardenResult[0] - $aWardenHealthCopy[4]
					Local $WardenPixelColor = _GetPixelColor($aWardenHealthCopy[0], $aWardenHealthCopy[1], $g_bCapturePixel)
					If $g_bDebugSetLog Then SetDebugLog(" Grand Warden _GetPixelColor(" & $aWardenHealthCopy[0] & "," & $aWardenHealthCopy[1] & "): " & $WardenPixelColor, $COLOR_DEBUG)
					If Not _CheckPixel2($aWardenHealthCopy, $WardenPixelColor, "Red+Blue") Then
						SetLog("Warden is getting weak, activating ability")
						ClickP($asWardenResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iWardenSlot
						$g_bCheckWardenPower = False
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_iActivateWarden = 1 Or $g_iActivateWarden = 2 Then
			If $g_bCheckWardenPower Then
				If IsHeroAbilityDelayElapsed($eHeroGrandWarden, $g_iDelayActivateWarden, $aDisplayTime) Then
					Local $asWardenResult = decodeSingleCoord(FindImageInPlace2("Warden", $g_sImgWardenBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Warden
					If IsArray($asWardenResult) And UBound($asWardenResult) = 2 Then
						SetLog("Activating Warden's ability after " & $aDisplayTime[$eHeroGrandWarden] & "'s")
						ClickP($asWardenResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iWardenSlot
						$g_bCheckWardenPower = False ; Reset check power flag
						$g_aHeroesTimerActivation[$eHeroGrandWarden] = 0 ; Reset Timer
					EndIf
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetLog Then
			SetDebugLog("CheckHeroesHealth() for Royal Champion started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateChampion = 0 Or $g_iActivateChampion = 2 And ($g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroRoyalChampion]) > $DELAYCHECKHEROESHEALTH) Then
			If $g_bCheckChampionPower Then
				Local $asChampionResult = decodeSingleCoord(FindImageInPlace2("Champion", $g_sImgChampionBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Champion
				If IsArray($asChampionResult) And UBound($asChampionResult) = 2 Then
					Local $aChampionHealthCopy = $aChampionHealth
					$aChampionHealthCopy[0] = $asChampionResult[0] - $aChampionHealthCopy[4]
					Local $ChampionPixelColor = _GetPixelColor($aChampionHealthCopy[0], $aChampionHealthCopy[1], $g_bCapturePixel)
					If $g_bDebugSetLog Then SetDebugLog("Royal Champion _GetPixelColor(" & $aChampionHealthCopy[0] & "," & $aChampionHealthCopy[1] & "): " & $ChampionPixelColor, $COLOR_DEBUG)
					If Not _CheckPixel2($aChampionHealthCopy, $ChampionPixelColor, "Red+Blue") Then
						SetLog("Champion is getting weak, activating ability")
						ClickP($asChampionResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iChampionSlot
						$g_bCheckChampionPower = False
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_iActivateChampion = 1 Or $g_iActivateChampion = 2 Then
			If $g_bCheckChampionPower Then
				If IsHeroAbilityDelayElapsed($eHeroRoyalChampion, $g_iDelayActivateChampion, $aDisplayTime) Then
					Local $asChampionResult = decodeSingleCoord(FindImageInPlace2("Champion", $g_sImgChampionBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Champion
					If IsArray($asChampionResult) And UBound($asChampionResult) = 2 Then
						SetLog("Activating Champion's ability after " & $aDisplayTime[$eHeroRoyalChampion] & "'s")
						ClickP($asChampionResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iChampionSlot
						$g_bCheckChampionPower = False ; Reset check power flag
						$g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0 ; Reset Timer
					EndIf
				EndIf
			EndIf
		EndIf

		If $g_bDebugSetLog Then
			SetDebugLog("CheckHeroesHealth() for Dragon Duke started ")
			If _Sleep($DELAYRESPOND) Then Return ; improve pause button response
		EndIf

		If $g_iActivateDuke = 0 Or $g_iActivateDuke = 2 And ($g_aHeroesTimerActivation[$eHeroDukeIndex] = 0 Or __TimerDiff($g_aHeroesTimerActivation[$eHeroDukeIndex]) > $DELAYCHECKHEROESHEALTH) Then
			If $g_bCheckDukePower Then
				Local $asDukeResult = decodeSingleCoord(FindImageInPlace2("Dragon Duke", $g_sImgDukeBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Dragon Duke
				If IsArray($asDukeResult) And UBound($asDukeResult) = 2 Then
					Local $aDukeHealthCopy = $aDukeHealth
					$aDukeHealthCopy[0] = $asDukeResult[0] - $aDukeHealthCopy[4]
					Local $DukePixelColor = _GetPixelColor($aDukeHealthCopy[0], $aDukeHealthCopy[1], $g_bCapturePixel)
					If $g_bDebugSetLog Then SetDebugLog("Dragon Duke _GetPixelColor(" & $aDukeHealthCopy[0] & "," & $aDukeHealthCopy[1] & "): " & $DukePixelColor, $COLOR_DEBUG)
					If Not _CheckPixel2($aDukeHealthCopy, $DukePixelColor, "Red+Blue") Then
						SetLog("Duke is getting weak, activating ability")
						ClickP($asDukeResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iDukeSlot
						$g_bCheckDukePower = False
					EndIf
				EndIf
			EndIf
		EndIf
		If $g_iActivateDuke = 1 Or $g_iActivateDuke = 2 Then
			If $g_bCheckDukePower Then
				If IsHeroAbilityDelayElapsed($eHeroDukeIndex, $g_iDelayActivateDuke, $aDisplayTime) Then
					Local $asDukeResult = decodeSingleCoord(FindImageInPlace2("Dragon Duke", $g_sImgDukeBar, 0, 570 + $g_iBottomOffsetY, 858, 638 + $g_iBottomOffsetY, True)) ; Looking for Dragon Duke
					If IsArray($asDukeResult) And UBound($asDukeResult) = 2 Then
						SetLog("Activating Duke's ability after " & $aDisplayTime[$eHeroDukeIndex] & "'s")
						ClickP($asDukeResult, 2)
						$g_iCSVLastTroopPositionDropTroopFromINI = $g_iDukeSlot
						$g_bCheckDukePower = False ; Reset check power flag
						$g_aHeroesTimerActivation[$eHeroDukeIndex] = 0 ; Reset Timer
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndFunc   ;==>CheckHeroesHealth

Func IsHeroAbilityDelayElapsed($iHeroTimerIndex, $iConfiguredDelay, ByRef $aDisplayTime)
	If $g_aHeroesTimerActivation[$iHeroTimerIndex] = 0 Then
		$aDisplayTime[$iHeroTimerIndex] = 0
		Return Int($iConfiguredDelay) <= 0
	EndIf
	Local $iElapsed = __TimerDiff($g_aHeroesTimerActivation[$iHeroTimerIndex])
	If GetEffectiveAttackAlgorithm($g_iMatchMode) = 1 Then
		$aDisplayTime[$iHeroTimerIndex] = Ceiling($iElapsed / 1000)
		Return (Int($iConfiguredDelay) / 1000) <= $aDisplayTime[$iHeroTimerIndex]
	EndIf
	$aDisplayTime[$iHeroTimerIndex] = Floor($iElapsed / 1000)
	Return $iElapsed >= Int($iConfiguredDelay)
EndFunc   ;==>IsHeroAbilityDelayElapsed
