; #FUNCTION# ====================================================================================================================
; Name ..........: dropHeroes
; Description ...: Will drop heroes in specific coordinates when their attack-bar slot is detected.
; Syntax ........: dropHeroes($x, $y, $iKingSlot = -1, $iQueenSlot = -1, $iPrinceSlot = -1, $iWardenSlot = -1, $iChampionSlot = -1, $iDukeSlot = -1)
; Parameters ....: $x                   - an unknown value.
;                  $y                   - an unknown value.
;                  $KingSlot            - [optional] an unknown value. Default is -1.
;                  $QueenSlot           - [optional] an unknown value. Default is -1.
;                  $WardenSlot          - [optional] an unknown value. Default is -1.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func dropHeroes($iX, $iY, $iKingSlotNumber = -1, $iQueenSlotNumber = -1, $iPrinceSlotNumber = -1, $iWardenSlotNumber = -1, $iChampionSlotNumber = -1, $iDukeSlotNumber = -1) ;Drops for All Heroes
	If $g_bDebugSetLog Then SetDebugLog("dropHeroes $iKingSlotNumber " & $iKingSlotNumber & " $iQueenSlotNumber " & $iQueenSlotNumber & " $iPrinceSlotNumber " & $iPrinceSlotNumber & " $iWardenSlotNumber " & $iWardenSlotNumber & " $iChampionSlotNumber " & $iChampionSlotNumber & " $iDukeSlotNumber " & $iDukeSlotNumber & " matchmode " & $g_iMatchMode, $COLOR_DEBUG)
	If _Sleep($DELAYDROPHEROES1) Then Return
	Local $bDropKing = False
	Local $bDropQueen = False
	Local $bDropPrince = False
	Local $bDropWarden = False
	Local $bDropChampion = False
	Local $bDropDuke = False

	If $iKingSlotNumber <> -1 Then $bDropKing = True
	If $iQueenSlotNumber <> -1 Then $bDropQueen = True
	If $iPrinceSlotNumber <> -1 Then $bDropPrince = True
	If $iWardenSlotNumber <> -1 Then $bDropWarden = True
	If $iChampionSlotNumber <> -1 Then $bDropChampion = True
	If $iDukeSlotNumber <> -1 Then $bDropDuke = True
	; Ensure hero order array is valid; fallback to default order if not
	Local $aHeroOrder[6] = [0, 1, 2, 3, 4, 5]
	If IsArray($g_aiHeroDeployOrder) Then $aHeroOrder = $g_aiHeroDeployOrder
	For $i = 0 To UBound($aHeroOrder) - 1
		Switch $aHeroOrder[$i]
			Case 0
				If $g_bDebugSetLog Then SetDebugLog("drop KING = " & $bDropKing, $COLOR_DEBUG)
				KingDrop($iX, $iY, $iKingSlotNumber, $bDropKing)
			Case 1
				If $g_bDebugSetLog Then SetDebugLog("drop QUEEN = " & $bDropQueen, $COLOR_DEBUG)
				QueenDrop($iX, $iY, $iQueenSlotNumber, $bDropQueen)
			Case 2
				If $g_bDebugSetLog Then SetDebugLog("drop PRINCE = " & $bDropPrince, $COLOR_DEBUG)
				PrinceDrop($iX, $iY, $iPrinceSlotNumber, $bDropPrince)
			Case 3
				If $g_bDebugSetLog Then SetDebugLog("drop WARDEN = " & $bDropWarden, $COLOR_DEBUG)
				WardenDrop($iX, $iY, $iWardenSlotNumber, $bDropWarden)
			Case 4
				If $g_bDebugSetLog Then SetDebugLog("drop CHAMPION = " & $bDropChampion, $COLOR_DEBUG)
				ChampionDrop($iX, $iY, $iChampionSlotNumber, $bDropChampion)
			Case 5
				If $g_bDebugSetLog Then SetDebugLog("drop DRAGON DUKE = " & $bDropDuke, $COLOR_DEBUG)
				DukeDrop($iX, $iY, $iDukeSlotNumber, $bDropDuke)
		EndSwitch
	Next
	$g_bIsHeroesDropped = $g_bDropKing Or $g_bDropQueen Or $g_bDropPrince Or $g_bDropWarden Or $g_bDropChampion Or $g_bDropDuke

EndFunc   ;==>dropHeroes

Func DeployHeroAttempt($iHeroTimerIndex, $iSlotNumber, $iX, $iY, $sDebugText)
	SelectDropTroop($iSlotNumber, 1, Default, False)
	If _Sleep($DELAYDROPHEROES2) Then Return False
	AttackClick($iX + Random(0, 3, 1), $iY + Random(0, 3, 1), 1, 50, 0, $sDebugText)
	$g_aHeroesTimerActivation[$iHeroTimerIndex] = __TimerInit()
	StartHeroAbilityTracking($iHeroTimerIndex)
	If GetEffectiveAttackAlgorithm($g_iMatchMode) = 1 Then Return True

	If _Sleep($DELAYDROPHEROES1) Then Return False
	CheckHeroesHealth()
	If _Sleep(500) Then Return False
	CheckHeroesHealth()
	Return True
EndFunc   ;==>DeployHeroAttempt

Func StartHeroAbilityTracking($iHeroTimerIndex)
	Switch $iHeroTimerIndex
		Case $eHeroBarbarianKing
			If Not $g_bDropKing Then $g_bCheckKingPower = True
			$g_bDropKing = True
		Case $eHeroArcherQueen
			If Not $g_bDropQueen Then $g_bCheckQueenPower = True
			$g_bDropQueen = True
		Case $eHeroMinionPrince
			If Not $g_bDropPrince Then $g_bCheckPrincePower = True
			$g_bDropPrince = True
		Case $eHeroGrandWarden
			If Not $g_bDropWarden Then $g_bCheckWardenPower = True
			$g_bDropWarden = True
		Case $eHeroRoyalChampion
			If Not $g_bDropChampion Then $g_bCheckChampionPower = True
			$g_bDropChampion = True
		Case $eHeroDukeIndex
			If Not $g_bDropDuke Then $g_bCheckDukePower = True
			$g_bDropDuke = True
	EndSwitch
EndFunc   ;==>StartHeroAbilityTracking

Func KingDrop($iX, $iY, $iKingSlotNumber = -1, $bDropKing = False)
	If $bDropKing Then
		SetLog("Dropping King at " & $iX & ", " & $iY)
		If Not DeployHeroAttempt($eHeroBarbarianKing, $iKingSlotNumber, $iX, $iY, "#0093") Then Return
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>KingDrop

Func QueenDrop($iX, $iY, $iQueenSlotNumber = -1, $bDropQueen = False)
	If $bDropQueen Then
		SetLog("Dropping Queen at " & $iX & ", " & $iY)
		If Not DeployHeroAttempt($eHeroArcherQueen, $iQueenSlotNumber, $iX, $iY, "#0095") Then Return
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>QueenDrop

Func PrinceDrop($iX, $iY, $iPrinceSlotNumber = 1, $bDropPrince = False)
	If $bDropPrince Then
		SetLog("Dropping Prince at " & $iX & ", " & $iY)
		If Not DeployHeroAttempt($eHeroMinionPrince, $iPrinceSlotNumber, $iX, $iY, "#0095") Then Return
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>PrinceDrop

Func WardenDrop($iX, $iY, $iWardenSlotNumber = -1, $bDropWarden = False)
	If $bDropWarden Then
		SetLog("Dropping Grand Warden at " & $iX & ", " & $iY)
		If Not DeployHeroAttempt($eHeroGrandWarden, $iWardenSlotNumber, $iX, $iY, "#x999") Then Return
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>WardenDrop

Func ChampionDrop($iX, $iY, $iChampionSlotNumber = -1, $bDropChampion = False)
	If $bDropChampion Then
		SetLog("Dropping Royal Champion at " & $iX & ", " & $iY)
		If Not DeployHeroAttempt($eHeroRoyalChampion, $iChampionSlotNumber, $iX, $iY, "#x999") Then Return
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>ChampionDrop

Func DukeDrop($iX, $iY, $iDukeSlotNumber = -1, $bDropDuke = False)
	If $bDropDuke Then
		SetLog("Dropping Dragon Duke at " & $iX & ", " & $iY)
		If Not DeployHeroAttempt($eHeroDukeIndex, $iDukeSlotNumber, $iX, $iY, "#x999") Then Return
		If _Sleep($DELAYDROPHEROES1) Then Return
	EndIf
	If _Sleep($DELAYDROPHEROES1) Then Return
EndFunc   ;==>DukeDrop

