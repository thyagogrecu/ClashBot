; #FUNCTION# ====================================================================================================================
; Name ..........: algorith_AllTroops
; Description ...: This file contens all functions to attack algorithm will all Troops , using Barbarians, Archers, Goblins, Giants and Wallbreakers as they are available
; Syntax ........: algorithm_AllTroops()
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: Didipe (05-2015), ProMac(2016), MonkeyHunter(03-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func algorithm_AllTroops() ;Attack Algorithm for all existing troops
	If $g_bDebugSetLog Then SetDebugLog("algorithm_AllTroops()", $COLOR_DEBUG)
	SetSlotSpecialTroops()

	If _Sleep($DELAYALGORITHM_ALLTROOPS1) Then Return

	SmartAttackStrategy($g_iMatchMode) ; detect redarea first to drop any troops

	Local $nbSides = 0
	Switch $g_aiAttackStdDropSides[$g_iMatchMode]
		Case 0 ;Single sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking: Single Side", $COLOR_INFO)
			$nbSides = 1
		Case 1 ;Two sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking: Two Sides", $COLOR_INFO)
			$nbSides = 2
		Case 2 ;Three sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking: Three Sides", $COLOR_INFO)
			$nbSides = 3
		Case 3 ;All sides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking: All Sides", $COLOR_INFO)
			$nbSides = 4
		Case 4 ;DE Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on Dark Elixir Side.", $COLOR_INFO)
			$nbSides = 1
			If Not ($g_abAttackStdSmartAttack[$g_iMatchMode]) Then GetBuildingEdge($eSideBuildingDES) ; Get DE Storage side when Redline is not used.
		Case 5 ;TH Side - Live Base only ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			SetLog("Attacking on Town Hall Side.", $COLOR_INFO)
			$nbSides = 1
			If Not ($g_abAttackStdSmartAttack[$g_iMatchMode]) Then GetBuildingEdge($eSideBuildingTH) ; Get Townhall side when Redline is not used.
	EndSwitch
	If ($nbSides = 0) Then Return
	If _Sleep($DELAYALGORITHM_ALLTROOPS2) Then Return

	$g_iSidesAttack = $nbSides

	; Reset the deploy Giants points , spread along red line
	$g_iSlotsGiants = 0
	Local $GiantComp = 0
	; Giants quantities
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $eGiant Then
			$GiantComp = $g_avAttackTroops[$i][1]
		EndIf
	Next

	; Lets select the deploy points according by Giants qunatities & sides
	; Deploy points : 0 - spreads along the red line , 1 - one deploy point .... X - X deploy points
	Switch $GiantComp
		Case 0 To 10
			$g_iSlotsGiants = 2
		Case Else
			Switch $nbSides
				Case 1 To 2
					$g_iSlotsGiants = 4
				Case Else
					$g_iSlotsGiants = 0
			EndSwitch
	EndSwitch

	; $ListInfoDeploy = [Troop, No. of Sides, $WaveNb, $MaxWaveNb, $slotsPerEdge]
	If $g_aiAttackStdDropOrder[$g_iMatchMode] <> 0 Then $g_aiAttackStdDropOrder[$g_iMatchMode] = 0

	If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] = 4 Then ; Customise DE side wave deployment here
		Switch $g_aiAttackStdDropOrder[$g_iMatchMode]
			Case 0
				If $g_bCustomDropOrderEnable Then
					Local $listInfoDeploy[$eDropOrderCount][5] = [[MatchTroopDropName(0), MatchSidesDrop(0), MatchTroopWaveNb(0), 1, MatchSlotsPerEdge(0)], _
 						[MatchTroopDropName(1), MatchSidesDrop(1), MatchTroopWaveNb(1), 1, MatchSlotsPerEdge(1)], _
 						[MatchTroopDropName(2), MatchSidesDrop(2), MatchTroopWaveNb(2), 1, MatchSlotsPerEdge(2)], _
						[MatchTroopDropName(3), MatchSidesDrop(3), MatchTroopWaveNb(3), 1, MatchSlotsPerEdge(3)], _
						[MatchTroopDropName(4), MatchSidesDrop(4), MatchTroopWaveNb(4), 1, MatchSlotsPerEdge(4)], _
						[MatchTroopDropName(5), MatchSidesDrop(5), MatchTroopWaveNb(5), 1, MatchSlotsPerEdge(5)], _
						[MatchTroopDropName(6), MatchSidesDrop(6), MatchTroopWaveNb(6), 1, MatchSlotsPerEdge(6)], _
						[MatchTroopDropName(7), MatchSidesDrop(7), MatchTroopWaveNb(7), 1, MatchSlotsPerEdge(7)], _
						[MatchTroopDropName(8), MatchSidesDrop(8), MatchTroopWaveNb(8), 1, MatchSlotsPerEdge(8)], _
						[MatchTroopDropName(9), MatchSidesDrop(9), MatchTroopWaveNb(9), 1, MatchSlotsPerEdge(9)], _
						[MatchTroopDropName(10), MatchSidesDrop(10), MatchTroopWaveNb(10), 1, MatchSlotsPerEdge(10)], _
						[MatchTroopDropName(11), MatchSidesDrop(11), MatchTroopWaveNb(11), 1, MatchSlotsPerEdge(11)], _
						[MatchTroopDropName(12), MatchSidesDrop(12), MatchTroopWaveNb(12), 1, MatchSlotsPerEdge(12)], _
						[MatchTroopDropName(13), MatchSidesDrop(13), MatchTroopWaveNb(13), 1, MatchSlotsPerEdge(13)], _
						[MatchTroopDropName(14), MatchSidesDrop(14), MatchTroopWaveNb(14), 1, MatchSlotsPerEdge(14)], _
						[MatchTroopDropName(15), MatchSidesDrop(15), MatchTroopWaveNb(15), 1, MatchSlotsPerEdge(15)], _
						[MatchTroopDropName(16), MatchSidesDrop(16), MatchTroopWaveNb(16), 1, MatchSlotsPerEdge(16)], _
						[MatchTroopDropName(17), MatchSidesDrop(17), MatchTroopWaveNb(17), 1, MatchSlotsPerEdge(17)], _
						[MatchTroopDropName(18), MatchSidesDrop(18), MatchTroopWaveNb(18), 1, MatchSlotsPerEdge(18)], _
						[MatchTroopDropName(19), MatchSidesDrop(19), MatchTroopWaveNb(19), 1, MatchSlotsPerEdge(19)], _
						[MatchTroopDropName(20), MatchSidesDrop(20), MatchTroopWaveNb(20), 1, MatchSlotsPerEdge(20)], _
						[MatchTroopDropName(21), MatchSidesDrop(21), MatchTroopWaveNb(21), 1, MatchSlotsPerEdge(21)], _
						[MatchTroopDropName(22), MatchSidesDrop(22), MatchTroopWaveNb(22), 1, MatchSlotsPerEdge(22)], _
						[MatchTroopDropName(23), MatchSidesDrop(23), MatchTroopWaveNb(23), 1, MatchSlotsPerEdge(23)], _
						[MatchTroopDropName(24), MatchSidesDrop(24), MatchTroopWaveNb(24), 1, MatchSlotsPerEdge(24)], _
						[MatchTroopDropName(25), MatchSidesDrop(25), MatchTroopWaveNb(25), 1, MatchSlotsPerEdge(25)], _
						[MatchTroopDropName(26), MatchSidesDrop(26), MatchTroopWaveNb(26), 1, MatchSlotsPerEdge(26)], _
						[MatchTroopDropName(27), MatchSidesDrop(27), MatchTroopWaveNb(27), 1, MatchSlotsPerEdge(27)], _
						[MatchTroopDropName(28), MatchSidesDrop(28), MatchTroopWaveNb(28), 1, MatchSlotsPerEdge(28)], _
						[MatchTroopDropName(29), MatchSidesDrop(29), MatchTroopWaveNb(29), 1, MatchSlotsPerEdge(29)], _
						[MatchTroopDropName(30), MatchSidesDrop(30), MatchTroopWaveNb(30), 1, MatchSlotsPerEdge(30)], _
						[MatchTroopDropName(31), MatchSidesDrop(31), MatchTroopWaveNb(31), 1, MatchSlotsPerEdge(31)], _
						[MatchTroopDropName(32), MatchSidesDrop(32), MatchTroopWaveNb(32), 1, MatchSlotsPerEdge(32)], _
						[MatchTroopDropName(33), MatchSidesDrop(33), MatchTroopWaveNb(33), 1, MatchSlotsPerEdge(33)], _
						[MatchTroopDropName(34), MatchSidesDrop(34), MatchTroopWaveNb(34), 1, MatchSlotsPerEdge(34)], _
						[MatchTroopDropName(35), MatchSidesDrop(35), MatchTroopWaveNb(35), 1, MatchSlotsPerEdge(35)], _
						[MatchTroopDropName(36), MatchSidesDrop(36), MatchTroopWaveNb(36), 1, MatchSlotsPerEdge(36)], _
						[MatchTroopDropName(37), MatchSidesDrop(37), MatchTroopWaveNb(37), 1, MatchSlotsPerEdge(37)], _
						[MatchTroopDropName(38), MatchSidesDrop(38), MatchTroopWaveNb(38), 1, MatchSlotsPerEdge(38)], _
						[MatchTroopDropName(39), MatchSidesDrop(39), MatchTroopWaveNb(39), 1, MatchSlotsPerEdge(39)], _
						[MatchTroopDropName(40), MatchSidesDrop(40), MatchTroopWaveNb(40), 1, MatchSlotsPerEdge(40)], _
						[MatchTroopDropName(41), MatchSidesDrop(41), MatchTroopWaveNb(41), 1, MatchSlotsPerEdge(41)], _
						[MatchTroopDropName(42), MatchSidesDrop(42), MatchTroopWaveNb(42), 1, MatchSlotsPerEdge(42)], _
						[MatchTroopDropName(43), MatchSidesDrop(43), MatchTroopWaveNb(43), 1, MatchSlotsPerEdge(43)], _
						[MatchTroopDropName(44), MatchSidesDrop(44), MatchTroopWaveNb(44), 1, MatchSlotsPerEdge(44)], _
						[MatchTroopDropName(45), MatchSidesDrop(45), MatchTroopWaveNb(45), 1, MatchSlotsPerEdge(45)], _
						[MatchTroopDropName(46), MatchSidesDrop(46), MatchTroopWaveNb(46), 1, MatchSlotsPerEdge(46)], _
 						[MatchTroopDropName(47), MatchSidesDrop(47), MatchTroopWaveNb(47), 1, MatchSlotsPerEdge(47)], _
						[MatchTroopDropName(48), MatchSidesDrop(48), MatchTroopWaveNb(48), 1, MatchSlotsPerEdge(48)], _
						[MatchTroopDropName(49), MatchSidesDrop(49), MatchTroopWaveNb(49), 1, MatchSlotsPerEdge(49)], _
						[MatchTroopDropName(50), MatchSidesDrop(50), MatchTroopWaveNb(50), 1, MatchSlotsPerEdge(50)], _
						[MatchTroopDropName(51), MatchSidesDrop(51), MatchTroopWaveNb(51), 1, MatchSlotsPerEdge(51)], _
						[MatchTroopDropName(52), MatchSidesDrop(52), MatchTroopWaveNb(52), 1, MatchSlotsPerEdge(52)], _
						[MatchTroopDropName(53), MatchSidesDrop(53), MatchTroopWaveNb(53), 1, MatchSlotsPerEdge(53)], _
						[MatchTroopDropName(54), MatchSidesDrop(54), MatchTroopWaveNb(54), 1, MatchSlotsPerEdge(54)], _
						[MatchTroopDropName(55), MatchSidesDrop(55), MatchTroopWaveNb(55), 1, MatchSlotsPerEdge(55)], _
						[MatchTroopDropName(56), MatchSidesDrop(56), MatchTroopWaveNb(56), 1, MatchSlotsPerEdge(56)], _
						[MatchTroopDropName(57), MatchSidesDrop(57), MatchTroopWaveNb(57), 1, MatchSlotsPerEdge(57)], _
						[MatchTroopDropName(58), MatchSidesDrop(58), MatchTroopWaveNb(58), 1, MatchSlotsPerEdge(58)], _
						[MatchTroopDropName(59), MatchSidesDrop(59), MatchTroopWaveNb(59), 1, MatchSlotsPerEdge(59)], _
						[MatchTroopDropName(60), MatchSidesDrop(60), MatchTroopWaveNb(60), 1, MatchSlotsPerEdge(60)], _
						[MatchTroopDropName(61), MatchSidesDrop(61), MatchTroopWaveNb(61), 1, MatchSlotsPerEdge(61)], _
						[MatchTroopDropName(62), MatchSidesDrop(62), MatchTroopWaveNb(62), 1, MatchSlotsPerEdge(62)], _
						[MatchTroopDropName(63), MatchSidesDrop(63), MatchTroopWaveNb(63), 1, MatchSlotsPerEdge(63)], _
						[MatchTroopDropName(64), MatchSidesDrop(64), MatchTroopWaveNb(64), 1, MatchSlotsPerEdge(64)], _
						[MatchTroopDropName(65), MatchSidesDrop(65), MatchTroopWaveNb(65), 1, MatchSlotsPerEdge(65)], _
						[MatchTroopDropName(66), MatchSidesDrop(66), MatchTroopWaveNb(66), 1, MatchSlotsPerEdge(66)], _
						[MatchTroopDropName(67), MatchSidesDrop(67), MatchTroopWaveNb(67), 1, MatchSlotsPerEdge(67)], _
						[MatchTroopDropName(68), MatchSidesDrop(68), MatchTroopWaveNb(68), 1, MatchSlotsPerEdge(68)], _
						[MatchTroopDropName(69), MatchSidesDrop(69), MatchTroopWaveNb(69), 1, MatchSlotsPerEdge(69)], _
						[MatchTroopDropName(70), MatchSidesDrop(70), MatchTroopWaveNb(70), 1, MatchSlotsPerEdge(70)], _
						[MatchTroopDropName(71), MatchSidesDrop(71), MatchTroopWaveNb(71), 1, MatchSlotsPerEdge(71)], _
						[MatchTroopDropName(72), MatchSidesDrop(72), MatchTroopWaveNb(72), 1, MatchSlotsPerEdge(72)], _
						[MatchTroopDropName(73), MatchSidesDrop(73), MatchTroopWaveNb(73), 1, MatchSlotsPerEdge(73)], _
						[MatchTroopDropName(74), MatchSidesDrop(74), MatchTroopWaveNb(74), 1, MatchSlotsPerEdge(74)], _
						[MatchTroopDropName(75), MatchSidesDrop(75), MatchTroopWaveNb(75), 1, MatchSlotsPerEdge(75)], _
						[MatchTroopDropName(76), MatchSidesDrop(76), MatchTroopWaveNb(76), 1, MatchSlotsPerEdge(76)], _
						[MatchTroopDropName(77), MatchSidesDrop(77), MatchTroopWaveNb(77), 1, MatchSlotsPerEdge(77)], _
						[MatchTroopDropName(78), MatchSidesDrop(78), MatchTroopWaveNb(78), 1, MatchSlotsPerEdge(78)], _
						[MatchTroopDropName(79), MatchSidesDrop(79), MatchTroopWaveNb(79), 1, MatchSlotsPerEdge(79)]]
				Else
					Local $listInfoDeploy[$eDropOrderCount][5] = [[$eBarb, $nbSides, 1, 1, 0] _
						, [$eSBarb, $nbSides, 1, 1, 0] _
						, [$eArch, $nbSides, 1, 1, 0] _
						, [$eSArch, $nbSides, 1, 1, 0] _
						, [$eGobl, $nbSides, 1, 1, 0] _
						, [$eSGobl, $nbSides, 1, 1, 0] _
						, [$eBarcher, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, [$eSMini, $nbSides, 1, 1, 0] _
						, [$eIceMini, $nbSides, 1, 1, 0] _
						, [$eFire, $nbSides, 1, 1, 0] _
						, [$eDebt, $nbSides, 1, 1, 0] _
						, [$eKicker, $nbSides, 1, 1, 0] _
						, [$eGThrow, $nbSides, 1, 1, 0] _
                        , [$eMOMMA, $nbSides, 1, 1, 0] _
						, [$eRoyalG, $nbSides, 1, 1, 0] _
						, [$eWall, $nbSides, 1, 1, 1] _
						, [$eSWall, $nbSides, 1, 1, 1] _
						, [$eGiant, $nbSides, 1, 1, $g_iSlotsGiants] _
						, [$eSGiant, $nbSides, 1, 1, $g_iSlotsGiants] _
						, [$eGGiant, $nbSides, 1, 1, $g_iSlotsGiants] _
						, [$eGole, $nbSides, 1, 1, 2] _
						, [$eIceG, $nbSides, 1, 1, 2] _
						, [$eMeteorG, $nbSides, 1, 1, 2] _
						, [$eYeti, $nbSides, 1, 1, 2] _
						, [$eSYeti, $nbSides, 1, 1, 2] _
						, [$eETitan, $nbSides, 1, 1, 0] _
						, [$eRootR, $nbSides, 1, 1, 0] _
						, [$eGiantS, $nbSides, 1, 1, 0] _
						, [$eSBarrel, $nbSides, 1, 1, 0] _
						, [$eERider, $nbSides, 1, 1, 0] _
						, [$eLava, $nbSides, 1, 1, 2] _
						, [$eIceH, $nbSides, 1, 1, 2] _
						, [$eHogs, $nbSides, 1, 1, 1] _
						, [$eSHogs, $nbSides, 1, 1, 1] _
						, [$eHogWiz, $nbSides, 1, 1, 0] _
						, [$eRamR, $nbSides, 1, 1, 0] _
						, [$ePBarb, $nbSides, 1, 1, 0] _
						, [$eValk, $nbSides, 1, 1, 0] _
						, [$eSValk, $nbSides, 1, 1, 0] _
						, [$eBowl, $nbSides, 1, 1, 0] _
						, [$eSBowl, $nbSides, 1, 1, 0] _
						, [$eMine, $nbSides, 1, 1, 0] _
						, [$eSMine, $nbSides, 1, 1, 0] _
						, [$eThrower, $nbSides, 1, 1, 0] _
						, [$eHunt, $nbSides, 1, 1, 0] _
						, [$ePekk, $nbSides, 1, 1, 1] _
						, [$eWiza, $nbSides, 1, 1, 0] _
						, [$eSWiza, $nbSides, 1, 1, 0] _
						, [$ePartyWiz, $nbSides, 1, 1, 0] _
						, [$eIceWiz, $nbSides, 1, 1, 0] _
						, [$eWitc, $nbSides, 1, 1, 1] _
						, [$eSWitc, $nbSides, 1, 1, 1] _
						, [$eWitchG, $nbSides, 1, 1, 0] _
						, [$eBabyD, $nbSides, 1, 1, 0] _
						, [$eInfernoD, $nbSides, 1, 1, 0] _
						, [$eDrag, $nbSides, 1, 1, 0] _
						, [$eSDrag, $nbSides, 1, 1, 0] _
						, [$eEDrag, $nbSides, 1, 1, 0] _
						, [$eRDrag, $nbSides, 1, 1, 0] _
						, [$eGDrag, $nbSides, 1, 1, 0] _
						, [$eADrag, $nbSides, 1, 1, 0] _
						, [$eBall, $nbSides, 1, 1, 0] _
						, [$eRBall, $nbSides, 1, 1, 0] _
						, [$eLavaloon, $nbSides, 1, 1, 0] _
						, [$eTThrow, $nbSides, 1, 1, 0] _
						, [$eHeal, $nbSides, 1, 1, 1] _
						, [$eAppWard, $nbSides, 1, 1, 0] _
						, [$eDruid, $nbSides, 1, 1, 0] _
						, [$eFurn, $nbSides, 1, 1, 0] _
						, [$eRuinW, $nbSides, 1, 1, 0] _
						, [$eKANE, $nbSides, 1, 1, 0] _
						, [$eDisarmer, $nbSides, 1, 1, 0] _
						, [$eYEET, $nbSides, 1, 1, 0] _
						, [$eYUnder, $nbSides, 1, 1, 0] _
						, [$eBroom, $nbSides, 1, 1, 0] _
						, [$eMECHA, $nbSides, 1, 1, 0] _
						, [$eCOOKIE, $nbSides, 1, 1, 0] _
						, ["HEROES", 1, 2, 1, 1] _
						, ["CC", 1, 2, 1, 1]]
				EndIf
		EndSwitch
	Else
		If $g_bDebugSetLog Then SetDebugLog("listdeploy standard for attack", $COLOR_DEBUG)
		Switch $g_aiAttackStdDropOrder[$g_iMatchMode]
			Case 0
				If $g_bCustomDropOrderEnable Then
					Local $listInfoDeploy[$eDropOrderCount][5] = [[MatchTroopDropName(0), MatchSidesDrop(0), MatchTroopWaveNb(0), 1, MatchSlotsPerEdge(0)], _
 						[MatchTroopDropName(1), MatchSidesDrop(1), MatchTroopWaveNb(1), 1, MatchSlotsPerEdge(1)], _
 						[MatchTroopDropName(2), MatchSidesDrop(2), MatchTroopWaveNb(2), 1, MatchSlotsPerEdge(2)], _
						[MatchTroopDropName(3), MatchSidesDrop(3), MatchTroopWaveNb(3), 1, MatchSlotsPerEdge(3)], _
						[MatchTroopDropName(4), MatchSidesDrop(4), MatchTroopWaveNb(4), 1, MatchSlotsPerEdge(4)], _
						[MatchTroopDropName(5), MatchSidesDrop(5), MatchTroopWaveNb(5), 1, MatchSlotsPerEdge(5)], _
						[MatchTroopDropName(6), MatchSidesDrop(6), MatchTroopWaveNb(6), 1, MatchSlotsPerEdge(6)], _
						[MatchTroopDropName(7), MatchSidesDrop(7), MatchTroopWaveNb(7), 1, MatchSlotsPerEdge(7)], _
						[MatchTroopDropName(8), MatchSidesDrop(8), MatchTroopWaveNb(8), 1, MatchSlotsPerEdge(8)], _
						[MatchTroopDropName(9), MatchSidesDrop(9), MatchTroopWaveNb(9), 1, MatchSlotsPerEdge(9)], _
						[MatchTroopDropName(10), MatchSidesDrop(10), MatchTroopWaveNb(10), 1, MatchSlotsPerEdge(10)], _
						[MatchTroopDropName(11), MatchSidesDrop(11), MatchTroopWaveNb(11), 1, MatchSlotsPerEdge(11)], _
						[MatchTroopDropName(12), MatchSidesDrop(12), MatchTroopWaveNb(12), 1, MatchSlotsPerEdge(12)], _
						[MatchTroopDropName(13), MatchSidesDrop(13), MatchTroopWaveNb(13), 1, MatchSlotsPerEdge(13)], _
						[MatchTroopDropName(14), MatchSidesDrop(14), MatchTroopWaveNb(14), 1, MatchSlotsPerEdge(14)], _
						[MatchTroopDropName(15), MatchSidesDrop(15), MatchTroopWaveNb(15), 1, MatchSlotsPerEdge(15)], _
						[MatchTroopDropName(16), MatchSidesDrop(16), MatchTroopWaveNb(16), 1, MatchSlotsPerEdge(16)], _
						[MatchTroopDropName(17), MatchSidesDrop(17), MatchTroopWaveNb(17), 1, MatchSlotsPerEdge(17)], _
						[MatchTroopDropName(18), MatchSidesDrop(18), MatchTroopWaveNb(18), 1, MatchSlotsPerEdge(18)], _
						[MatchTroopDropName(19), MatchSidesDrop(19), MatchTroopWaveNb(19), 1, MatchSlotsPerEdge(19)], _
						[MatchTroopDropName(20), MatchSidesDrop(20), MatchTroopWaveNb(20), 1, MatchSlotsPerEdge(20)], _
						[MatchTroopDropName(21), MatchSidesDrop(21), MatchTroopWaveNb(21), 1, MatchSlotsPerEdge(21)], _
						[MatchTroopDropName(22), MatchSidesDrop(22), MatchTroopWaveNb(22), 1, MatchSlotsPerEdge(22)], _
						[MatchTroopDropName(23), MatchSidesDrop(23), MatchTroopWaveNb(23), 1, MatchSlotsPerEdge(23)], _
						[MatchTroopDropName(24), MatchSidesDrop(24), MatchTroopWaveNb(24), 1, MatchSlotsPerEdge(24)], _
						[MatchTroopDropName(25), MatchSidesDrop(25), MatchTroopWaveNb(25), 1, MatchSlotsPerEdge(25)], _
						[MatchTroopDropName(26), MatchSidesDrop(26), MatchTroopWaveNb(26), 1, MatchSlotsPerEdge(26)], _
						[MatchTroopDropName(27), MatchSidesDrop(27), MatchTroopWaveNb(27), 1, MatchSlotsPerEdge(27)], _
						[MatchTroopDropName(28), MatchSidesDrop(28), MatchTroopWaveNb(28), 1, MatchSlotsPerEdge(28)], _
						[MatchTroopDropName(29), MatchSidesDrop(29), MatchTroopWaveNb(29), 1, MatchSlotsPerEdge(29)], _
						[MatchTroopDropName(30), MatchSidesDrop(30), MatchTroopWaveNb(30), 1, MatchSlotsPerEdge(30)], _
						[MatchTroopDropName(31), MatchSidesDrop(31), MatchTroopWaveNb(31), 1, MatchSlotsPerEdge(31)], _
						[MatchTroopDropName(32), MatchSidesDrop(32), MatchTroopWaveNb(32), 1, MatchSlotsPerEdge(32)], _
						[MatchTroopDropName(33), MatchSidesDrop(33), MatchTroopWaveNb(33), 1, MatchSlotsPerEdge(33)], _
						[MatchTroopDropName(34), MatchSidesDrop(34), MatchTroopWaveNb(34), 1, MatchSlotsPerEdge(34)], _
						[MatchTroopDropName(35), MatchSidesDrop(35), MatchTroopWaveNb(35), 1, MatchSlotsPerEdge(35)], _
						[MatchTroopDropName(36), MatchSidesDrop(36), MatchTroopWaveNb(36), 1, MatchSlotsPerEdge(36)], _
						[MatchTroopDropName(37), MatchSidesDrop(37), MatchTroopWaveNb(37), 1, MatchSlotsPerEdge(37)], _
						[MatchTroopDropName(38), MatchSidesDrop(38), MatchTroopWaveNb(38), 1, MatchSlotsPerEdge(38)], _
						[MatchTroopDropName(39), MatchSidesDrop(39), MatchTroopWaveNb(39), 1, MatchSlotsPerEdge(39)], _
						[MatchTroopDropName(40), MatchSidesDrop(40), MatchTroopWaveNb(40), 1, MatchSlotsPerEdge(40)], _
						[MatchTroopDropName(41), MatchSidesDrop(41), MatchTroopWaveNb(41), 1, MatchSlotsPerEdge(41)], _
						[MatchTroopDropName(42), MatchSidesDrop(42), MatchTroopWaveNb(42), 1, MatchSlotsPerEdge(42)], _
						[MatchTroopDropName(43), MatchSidesDrop(43), MatchTroopWaveNb(43), 1, MatchSlotsPerEdge(43)], _
						[MatchTroopDropName(44), MatchSidesDrop(44), MatchTroopWaveNb(44), 1, MatchSlotsPerEdge(44)], _
						[MatchTroopDropName(45), MatchSidesDrop(45), MatchTroopWaveNb(45), 1, MatchSlotsPerEdge(45)], _
						[MatchTroopDropName(46), MatchSidesDrop(46), MatchTroopWaveNb(46), 1, MatchSlotsPerEdge(46)], _
 						[MatchTroopDropName(47), MatchSidesDrop(47), MatchTroopWaveNb(47), 1, MatchSlotsPerEdge(47)], _
						[MatchTroopDropName(48), MatchSidesDrop(48), MatchTroopWaveNb(48), 1, MatchSlotsPerEdge(48)], _
						[MatchTroopDropName(49), MatchSidesDrop(49), MatchTroopWaveNb(49), 1, MatchSlotsPerEdge(49)], _
						[MatchTroopDropName(50), MatchSidesDrop(50), MatchTroopWaveNb(50), 1, MatchSlotsPerEdge(50)], _
						[MatchTroopDropName(51), MatchSidesDrop(51), MatchTroopWaveNb(51), 1, MatchSlotsPerEdge(51)], _
						[MatchTroopDropName(52), MatchSidesDrop(52), MatchTroopWaveNb(52), 1, MatchSlotsPerEdge(52)], _
						[MatchTroopDropName(53), MatchSidesDrop(53), MatchTroopWaveNb(53), 1, MatchSlotsPerEdge(53)], _
						[MatchTroopDropName(54), MatchSidesDrop(54), MatchTroopWaveNb(54), 1, MatchSlotsPerEdge(54)], _
						[MatchTroopDropName(55), MatchSidesDrop(55), MatchTroopWaveNb(55), 1, MatchSlotsPerEdge(55)], _
						[MatchTroopDropName(56), MatchSidesDrop(56), MatchTroopWaveNb(56), 1, MatchSlotsPerEdge(56)], _
						[MatchTroopDropName(57), MatchSidesDrop(57), MatchTroopWaveNb(57), 1, MatchSlotsPerEdge(57)], _
						[MatchTroopDropName(58), MatchSidesDrop(58), MatchTroopWaveNb(58), 1, MatchSlotsPerEdge(58)], _
						[MatchTroopDropName(59), MatchSidesDrop(59), MatchTroopWaveNb(59), 1, MatchSlotsPerEdge(59)], _
						[MatchTroopDropName(60), MatchSidesDrop(60), MatchTroopWaveNb(60), 1, MatchSlotsPerEdge(60)], _
						[MatchTroopDropName(61), MatchSidesDrop(61), MatchTroopWaveNb(61), 1, MatchSlotsPerEdge(61)], _
						[MatchTroopDropName(62), MatchSidesDrop(62), MatchTroopWaveNb(62), 1, MatchSlotsPerEdge(62)], _
						[MatchTroopDropName(63), MatchSidesDrop(63), MatchTroopWaveNb(63), 1, MatchSlotsPerEdge(63)], _
						[MatchTroopDropName(64), MatchSidesDrop(64), MatchTroopWaveNb(64), 1, MatchSlotsPerEdge(64)], _
						[MatchTroopDropName(65), MatchSidesDrop(65), MatchTroopWaveNb(65), 1, MatchSlotsPerEdge(65)], _
						[MatchTroopDropName(66), MatchSidesDrop(66), MatchTroopWaveNb(66), 1, MatchSlotsPerEdge(66)], _
						[MatchTroopDropName(67), MatchSidesDrop(67), MatchTroopWaveNb(67), 1, MatchSlotsPerEdge(67)], _
						[MatchTroopDropName(68), MatchSidesDrop(68), MatchTroopWaveNb(68), 1, MatchSlotsPerEdge(68)], _
						[MatchTroopDropName(69), MatchSidesDrop(69), MatchTroopWaveNb(69), 1, MatchSlotsPerEdge(69)], _
						[MatchTroopDropName(70), MatchSidesDrop(70), MatchTroopWaveNb(70), 1, MatchSlotsPerEdge(70)], _
						[MatchTroopDropName(71), MatchSidesDrop(71), MatchTroopWaveNb(71), 1, MatchSlotsPerEdge(71)], _
						[MatchTroopDropName(72), MatchSidesDrop(72), MatchTroopWaveNb(72), 1, MatchSlotsPerEdge(72)], _
						[MatchTroopDropName(73), MatchSidesDrop(73), MatchTroopWaveNb(73), 1, MatchSlotsPerEdge(73)], _
						[MatchTroopDropName(74), MatchSidesDrop(74), MatchTroopWaveNb(74), 1, MatchSlotsPerEdge(74)], _
						[MatchTroopDropName(75), MatchSidesDrop(75), MatchTroopWaveNb(75), 1, MatchSlotsPerEdge(75)], _
						[MatchTroopDropName(76), MatchSidesDrop(76), MatchTroopWaveNb(76), 1, MatchSlotsPerEdge(76)], _
						[MatchTroopDropName(77), MatchSidesDrop(77), MatchTroopWaveNb(77), 1, MatchSlotsPerEdge(77)], _
						[MatchTroopDropName(78), MatchSidesDrop(78), MatchTroopWaveNb(78), 1, MatchSlotsPerEdge(78)], _
						[MatchTroopDropName(79), MatchSidesDrop(79), MatchTroopWaveNb(79), 1, MatchSlotsPerEdge(79)]]
				Else
					Local $listInfoDeploy[$eDropOrderCount][5] = [[$eBarb, $nbSides, 1, 1, 0] _
						, [$eSBarb, $nbSides, 1, 1, 0] _
						, [$eArch, $nbSides, 1, 1, 0] _
						, [$eSArch, $nbSides, 1, 1, 0] _
						, [$eGobl, $nbSides, 1, 1, 0] _
						, [$eSGobl, $nbSides, 1, 1, 0] _
						, [$eBarcher, $nbSides, 1, 1, 0] _
						, [$eMini, $nbSides, 1, 1, 0] _
						, [$eSMini, $nbSides, 1, 1, 0] _
						, [$eIceMini, $nbSides, 1, 1, 0] _
						, [$eFire, $nbSides, 1, 1, 0] _
						, [$eDebt, $nbSides, 1, 1, 0] _
						, [$eKicker, $nbSides, 1, 1, 0] _
						, [$eGThrow, $nbSides, 1, 1, 0] _
                        , [$eMOMMA, $nbSides, 1, 1, 0] _
						, [$eRoyalG, $nbSides, 1, 1, 0] _
						, [$eWall, $nbSides, 1, 1, 1] _
						, [$eSWall, $nbSides, 1, 1, 1] _
						, [$eGiant, $nbSides, 1, 1, $g_iSlotsGiants] _
						, [$eSGiant, $nbSides, 1, 1, $g_iSlotsGiants] _
						, [$eGGiant, $nbSides, 1, 1, $g_iSlotsGiants] _
						, [$eGole, $nbSides, 1, 1, 2] _
						, [$eIceG, $nbSides, 1, 1, 2] _
						, [$eMeteorG, $nbSides, 1, 1, 2] _
						, [$eYeti, $nbSides, 1, 1, 2] _
						, [$eSYeti, $nbSides, 1, 1, 2] _
						, [$eETitan, $nbSides, 1, 1, 0] _
						, [$eRootR, $nbSides, 1, 1, 0] _
						, [$eGiantS, $nbSides, 1, 1, 0] _
						, [$eSBarrel, $nbSides, 1, 1, 0] _
						, [$eERider, $nbSides, 1, 1, 0] _
						, [$eLava, $nbSides, 1, 1, 2] _
						, [$eIceH, $nbSides, 1, 1, 2] _
						, [$eHogs, $nbSides, 1, 1, 1] _
						, [$eSHogs, $nbSides, 1, 1, 1] _
						, [$eHogWiz, $nbSides, 1, 1, 0] _
						, [$eRamR, $nbSides, 1, 1, 0] _
						, [$ePBarb, $nbSides, 1, 1, 0] _
						, [$eValk, $nbSides, 1, 1, 0] _
						, [$eSValk, $nbSides, 1, 1, 0] _
						, [$eBowl, $nbSides, 1, 1, 0] _
						, [$eSBowl, $nbSides, 1, 1, 0] _
						, [$eMine, $nbSides, 1, 1, 0] _
						, [$eSMine, $nbSides, 1, 1, 0] _
						, [$eThrower, $nbSides, 1, 1, 0] _
						, [$eHunt, $nbSides, 1, 1, 0] _
						, [$ePekk, $nbSides, 1, 1, 1] _
						, [$eWiza, $nbSides, 1, 1, 0] _
						, [$eSWiza, $nbSides, 1, 1, 0] _
						, [$ePartyWiz, $nbSides, 1, 1, 0] _
						, [$eIceWiz, $nbSides, 1, 1, 0] _
						, [$eWitc, $nbSides, 1, 1, 1] _
						, [$eSWitc, $nbSides, 1, 1, 1] _
						, [$eWitchG, $nbSides, 1, 1, 0] _
						, [$eBabyD, $nbSides, 1, 1, 0] _
						, [$eInfernoD, $nbSides, 1, 1, 0] _
						, [$eDrag, $nbSides, 1, 1, 0] _
						, [$eSDrag, $nbSides, 1, 1, 0] _
						, [$eEDrag, $nbSides, 1, 1, 0] _
						, [$eRDrag, $nbSides, 1, 1, 0] _
						, [$eGDrag, $nbSides, 1, 1, 0] _
						, [$eADrag, $nbSides, 1, 1, 0] _
						, [$eBall, $nbSides, 1, 1, 0] _
						, [$eRBall, $nbSides, 1, 1, 0] _
						, [$eLavaloon, $nbSides, 1, 1, 0] _
						, [$eTThrow, $nbSides, 1, 1, 0] _
						, [$eHeal, $nbSides, 1, 1, 1] _
						, [$eAppWard, $nbSides, 1, 1, 0] _
						, [$eDruid, $nbSides, 1, 1, 0] _
						, [$eFurn, $nbSides, 1, 1, 0] _
						, [$eRuinW, $nbSides, 1, 1, 0] _
						, [$eKANE, $nbSides, 1, 1, 0] _
						, [$eDisarmer, $nbSides, 1, 1, 0] _
						, [$eYEET, $nbSides, 1, 1, 0] _
						, [$eYUnder, $nbSides, 1, 1, 0] _
						, [$eBroom, $nbSides, 1, 1, 0] _
						, [$eMECHA, $nbSides, 1, 1, 0] _
						, [$eCOOKIE, $nbSides, 1, 1, 0] _
						, ["HEROES", 1, 2, 1, 1] _
						, ["CC", 1, 1, 1, 1]]
				EndIf
		EndSwitch
	EndIf

	$g_bIsCCDropped = False
	$g_aiDeployCCPosition[0] = -1
	$g_aiDeployCCPosition[1] = -1
	$g_bIsHeroesDropped = False
	$g_aiDeployHeroesPosition[0] = -1
	$g_aiDeployHeroesPosition[1] = -1

	LaunchTroop2($listInfoDeploy, $g_iClanCastleSlot, $g_iKingSlot, $g_iQueenSlot, $g_iPrinceSlot, $g_iWardenSlot, $g_iChampionSlot, $g_iDukeSlot)

	If Not $g_bIsCCDropped And $g_iClanCastleSlot <> -1 Then
		If $g_aiDeployHeroesPosition[0] <> -1 Then
			dropCC($g_aiDeployHeroesPosition[0], $g_aiDeployHeroesPosition[1], $g_iClanCastleSlot)
		Else
			dropCC($g_aaiBottomRightDropPoints[2][0], $g_aaiBottomRightDropPoints[2][1], $g_iClanCastleSlot)
		EndIf
	EndIf
	CheckHeroesHealth()

	If _Sleep($DELAYALGORITHM_ALLTROOPS4) Then Return
	Local $iRemainingCheck = PrepareAttack($g_iMatchMode, True)
	If $iRemainingCheck <> -1 And HasRemainingRegularTroops() Then
		SetLog("Dropping leftover troops")
		For $i = $eBarb To $eGDrag ; launch all remaining troops
			If LaunchTroop($i, $nbSides, 1, 1, 1) Then
				CheckHeroesHealth()
				If _Sleep($DELAYALGORITHM_ALLTROOPS5) Then Return
			EndIf
		Next
	EndIf

	CheckHeroesHealth()
	If $iRemainingCheck = -1 Then
		SetLog("Attack deploy status not verified: attack bar detection failed", $COLOR_WARNING)
	Else
		SetLog("Finished Attacking, waiting for the battle to end")
	EndIf
EndFunc   ;==>algorithm_AllTroops

Func SetSlotSpecialTroops()
	$g_iKingSlot = -1
	$g_iQueenSlot = -1
	$g_iPrinceSlot = -1
	$g_iWardenSlot = -1
	$g_iChampionSlot = -1
	$g_iDukeSlot = -1
	$g_iClanCastleSlot = -1

	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $eCastle Or $g_avAttackTroops[$i][0] = $eWallW Or $g_avAttackTroops[$i][0] = $eBattleB Or $g_avAttackTroops[$i][0] = $eStoneS Or _
				$g_avAttackTroops[$i][0] = $eSiegeB Or $g_avAttackTroops[$i][0] = $eLogL Or $g_avAttackTroops[$i][0] = $eFlameF Or $g_avAttackTroops[$i][0] = $eBattleD Or $g_avAttackTroops[$i][0] = $eTroopL Or $g_avAttackTroops[$i][0] = $eSkyW Then
			$g_iClanCastleSlot = $i
		ElseIf $g_avAttackTroops[$i][0] = $eKing Then
			$g_iKingSlot = $i
		ElseIf $g_avAttackTroops[$i][0] = $eQueen Then
			$g_iQueenSlot = $i
		ElseIf $g_avAttackTroops[$i][0] = $ePrince Then
			$g_iPrinceSlot = $i
		ElseIf $g_avAttackTroops[$i][0] = $eWarden Then
			$g_iWardenSlot = $i
		ElseIf $g_avAttackTroops[$i][0] = $eChampion Then
			$g_iChampionSlot = $i
		ElseIf $g_avAttackTroops[$i][0] = $eDuke Then
			$g_iDukeSlot = $i
		EndIf
	Next

	If $g_bDebugSetLog Then
		SetDebugLog("SetSlotSpecialTroops() King Slot: " & $g_iKingSlot, $COLOR_DEBUG)
		SetDebugLog("SetSlotSpecialTroops() Queen Slot: " & $g_iQueenSlot, $COLOR_DEBUG)
		SetDebugLog("SetSlotSpecialTroops() Prince Slot: " & $g_iPrinceSlot, $COLOR_DEBUG)
		SetDebugLog("SetSlotSpecialTroops() Warden Slot: " & $g_iWardenSlot, $COLOR_DEBUG)
		SetDebugLog("SetSlotSpecialTroops() Champion Slot: " & $g_iChampionSlot, $COLOR_DEBUG)
		SetDebugLog("SetSlotSpecialTroops() Dragon Duke Slot: " & $g_iDukeSlot, $COLOR_DEBUG)
		SetDebugLog("SetSlotSpecialTroops() Clan Castle Slot: " & $g_iClanCastleSlot, $COLOR_DEBUG)
	EndIf

EndFunc   ;==>SetSlotSpecialTroops

Func CloseBattle()
	If IsAttackPage() Then
		For $i = 1 To 30
			;_CaptureRegion()
			If _ColorCheck(_GetPixelColor($aWonOneStar[0], $aWonOneStar[1], True), Hex($aWonOneStar[2], 6), $aWonOneStar[3]) = True Then ExitLoop ;exit if not 'no star'
			If _Sleep($DELAYALGORITHM_ALLTROOPS2) Then Return
		Next
	EndIf

	If IsAttackPage() Then ClickP($aSurrenderButton, 1, 0, "#0030") ;Click Surrender
	If _Sleep($DELAYALGORITHM_ALLTROOPS3) Then Return
	If IsEndBattlePage() Then
		ClickP($aConfirmSurrender, 1, 120, "#0031") ;Click Confirm
		If _Sleep($DELAYALGORITHM_ALLTROOPS1) Then Return
	EndIf

EndFunc   ;==>CloseBattle


Func SmartAttackStrategy($imode)
	If ($g_abAttackStdSmartAttack[$imode]) Then
		SetLog("Calculating Smart Attack Strategy", $COLOR_INFO)
		Local $hTimer = __TimerInit()
		_CaptureRegion2()
		_GetRedArea()

		SetLog("Calculated in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds:")
		If $g_iSmartZapTiming = $eSmartZapTimingStart Then
			SmartZap()
			If Not $g_bRunState Then Return
		EndIf

		If ($g_abAttackStdSmartNearCollectors[$imode][0] Or $g_abAttackStdSmartNearCollectors[$imode][1] Or $g_abAttackStdSmartNearCollectors[$imode][2]) Then
			SetLog("Locating Mines, Collectors & Drills", $COLOR_INFO)
			$hTimer = __TimerInit()
			Global $g_aiPixelMine[0]
			Global $g_aiPixelElixir[0]
			Global $g_aiPixelDarkElixir[0]
			Global $g_aiPixelNearCollector[0]
			; If drop troop near gold mine
			If $g_abAttackStdSmartNearCollectors[$imode][0] Then
				$g_aiPixelMine = GetLocationMine()
				If (IsArray($g_aiPixelMine)) Then
					_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelMine, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
				EndIf
			EndIf
			; If drop troop near elixir collector
			If $g_abAttackStdSmartNearCollectors[$imode][1] Then
				$g_aiPixelElixir = GetLocationElixir()
				If (IsArray($g_aiPixelElixir)) Then
					_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelElixir, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
				EndIf
			EndIf
			; If drop troop near dark elixir drill
			If $g_abAttackStdSmartNearCollectors[$imode][2] Then
				$g_aiPixelDarkElixir = GetLocationDarkElixir()
				If (IsArray($g_aiPixelDarkElixir)) Then
					_ArrayAdd($g_aiPixelNearCollector, $g_aiPixelDarkElixir, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
				EndIf
			EndIf
			SetLog("Located in " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds:")
			SetLog("[" & UBound($g_aiPixelMine) & "] Gold Mines")
			SetLog("[" & UBound($g_aiPixelElixir) & "] Elixir Collectors")
			SetLog("[" & UBound($g_aiPixelDarkElixir) & "] Dark Elixir Drills")
			$g_aiNbrOfDetectedMines[$imode] += UBound($g_aiPixelMine)
			$g_aiNbrOfDetectedCollectors[$imode] += UBound($g_aiPixelElixir)
			$g_aiNbrOfDetectedDrills[$imode] += UBound($g_aiPixelDarkElixir)
			UpdateStats()
		EndIf

	EndIf
EndFunc   ;==>SmartAttackStrategy

