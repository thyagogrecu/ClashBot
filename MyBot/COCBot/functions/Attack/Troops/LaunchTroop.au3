
; #FUNCTION# ====================================================================================================================
; Name ..........: LaunchTroop
; Description ...:
; Syntax ........: LaunchTroop($troopKind, $nbSides, $waveNb, $maxWaveNb[, $slotsPerEdge = 0[, $bSetLog = True]])
; Parameters ....: $troopKind           - a dll struct value.
;                  $nbSides             - a general number value.
;                  $waveNb              - an unknown value.
;                  $maxWaveNb           - a map.
;                  $slotsPerEdge        - [optional] a string value. Default is 0.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LaunchTroop($troopKind, $nbSides, $waveNb, $maxWaveNb, $slotsPerEdge = 0, $bSetLog = True)
	Local $troop = -1
	Local $troopNb = 0
	Local $name = ""
	For $i = 0 To UBound($g_avAttackTroops) - 1 ; identify the position of this kind of troop
		If IsTagTeamEventSlotReserved($i) Then ContinueLoop
		If $g_avAttackTroops[$i][0] = $troopKind Then
			If $g_avAttackTroops[$i][1] < 1 Then Return False
			$troop = $i
			$troopNb = Ceiling($g_avAttackTroops[$i][1] / $maxWaveNb)
			$name = GetTroopName($troopKind, $troopNb)
		EndIf
	Next

	If $g_bDebugSetLog Then SetDebugLog("Dropping : " & $troopNb & " " & $name, $COLOR_DEBUG)

	If $troop = -1 Or $troopNb = 0 Then
		Return False ; nothing to do => skip this wave
	EndIf

	If $bSetLog Then SetLog("Deploying " & $troopNb & " " & $name, $COLOR_INFO)
	Local $iBeforeDeployCount = ReadTroopQuantity($troop)
	If $iBeforeDeployCount < 1 Then $iBeforeDeployCount = $g_avAttackTroops[$troop][1]
	DropTroop($troop, $nbSides, $troopNb, $slotsPerEdge)

	Return VerifyStandardTroopDeployment($troop, $iBeforeDeployCount)
EndFunc   ;==>LaunchTroop

; #FUNCTION# ===========================================================================================================
; Name ..........: VerifyStandardTroopDeployment
; Description ...: Checks a readable troop count after standard deployment without interpreting empty OCR as zero.
; Remarks .......: Does not redeploy or change wave quantities. Unknown counts are reported as unverified.
; ======================================================================================================================
Func VerifyStandardTroopDeployment($iSlot, $iBefore)
	If Not $g_bRunState Or IsKeepClicksActive() Then Return False
	If _SleepAttack(200) Then Return False
	If Not IsAttackPage(True) Then Return False
	Local $aPosition = GetSlotPosition($iSlot)
	Local $sCount = getTroopCountSmall($aPosition[0], $aPosition[1])
	If $sCount = "" Then $sCount = getTroopCountBig($aPosition[0], $aPosition[1] - 3)
	If $sCount = "" Or Not StringIsDigit($sCount) Then
		SetLog("Deployment not verified: troop quantity OCR unavailable", $COLOR_WARNING)
		Return False
	EndIf
	If Number($sCount) >= $iBefore Then
		SetLog("Deployment not verified: troop quantity did not decrease", $COLOR_WARNING)
		Return False
	EndIf
	Return True
EndFunc   ;==>VerifyStandardTroopDeployment

Func HasRemainingRegularTroops()
	For $i = 0 To UBound($g_avAttackTroops) - 1
		If IsTagTeamEventSlotReserved($i) Then ContinueLoop
		If $g_avAttackTroops[$i][0] >= $eBarb And $g_avAttackTroops[$i][0] < $eKing And $g_avAttackTroops[$i][1] > 0 Then Return True
	Next
	Return False
EndFunc   ;==>HasRemainingRegularTroops

Func LaunchTroop2($listInfoDeploy, $iCC, $iKing, $iQueen, $iPrince, $iWarden, $iChampion, $iDuke = -1)
	If $g_bDebugSetLog Then SetDebugLog("LaunchTroop2 with CC " & $iCC & ", K " & $iKing & ", Q " & $iQueen & ", P " & $iPrince & ", W " & $iWarden & ", C " & $iChampion & ", D " & $iDuke, $COLOR_DEBUG)
	Local $listListInfoDeployTroopPixel[0]
	Local $pixelRandomDrop[2]
	Local $pixelRandomDropcc[2]

	If ($g_abAttackStdSmartAttack[$g_iMatchMode]) Then
		For $i = 0 To UBound($listInfoDeploy) - 1
			Local $iFoundTroopAt = -1, $iTroopAmount = 0, $sTroopName
			Local $vTroopIndex = $listInfoDeploy[$i][0]
			Local $iNumberSides = $listInfoDeploy[$i][1]
			Local $iNumberWaves = $listInfoDeploy[$i][2]
			Local $iMaxNumberWaves = $listInfoDeploy[$i][3]
			Local $iSlotsPerEdge = $listInfoDeploy[$i][4]
			If $g_bDebugSetLog Then SetDebugLog("**ListInfoDeploy row " & $i & ": Use: " & $vTroopIndex & "|Sides: " & $iNumberSides & "|Wave: " & $iNumberWaves & "|Max Wavess: " & $iMaxNumberWaves & "|Slots per Edge " & $iSlotsPerEdge, $COLOR_DEBUG)
			If IsNumber($vTroopIndex) Then
				$iFoundTroopAt = _ArraySearch($g_avAttackTroops, $vTroopIndex, 0, 0, 0, 0, 1, 0)
				If $iFoundTroopAt <> -1 Then
					$iTroopAmount = Ceiling($g_avAttackTroops[$iFoundTroopAt][1] / $iMaxNumberWaves)
					$sTroopName = GetTroopName($vTroopIndex, $iTroopAmount)
				EndIf
			EndIf
			If ($iFoundTroopAt <> -1 And $iTroopAmount > 0) Or (IsString($vTroopIndex) And ($vTroopIndex = "CC" Or $vTroopIndex = "HEROES")) Then
				If $iNumberWaves > 0 Then
					Local $listInfoDeployTroopPixel[0]
					If (UBound($listListInfoDeployTroopPixel) < $iNumberWaves) Then
						ReDim $listListInfoDeployTroopPixel[$iNumberWaves]
						Local $newListInfoDeployTroopPixel[0]
						$listListInfoDeployTroopPixel[$iNumberWaves - 1] = $newListInfoDeployTroopPixel
					EndIf
					$listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$iNumberWaves - 1]
					If Not IsArray($listInfoDeployTroopPixel) Then
						Local $newListInfoDeployTroopPixel[0]
						$listInfoDeployTroopPixel = $newListInfoDeployTroopPixel
					EndIf

					ReDim $listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) + 1]
					If (IsString($vTroopIndex)) Then
						Local $arrCCorHeroes[1] = [$vTroopIndex]
						$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $arrCCorHeroes
					Else
						Local $infoDropTroop = DropTroop2($iFoundTroopAt, $iNumberSides, $iTroopAmount, $iSlotsPerEdge, $sTroopName)
						$listInfoDeployTroopPixel[UBound($listInfoDeployTroopPixel) - 1] = $infoDropTroop
					EndIf
					$listListInfoDeployTroopPixel[$iNumberWaves - 1] = $listInfoDeployTroopPixel
				EndIf
			EndIf
		Next

		If (($g_abAttackStdSmartNearCollectors[$g_iMatchMode][0] Or $g_abAttackStdSmartNearCollectors[$g_iMatchMode][1] Or _
				$g_abAttackStdSmartNearCollectors[$g_iMatchMode][2]) And UBound($g_aiPixelNearCollector) = 0) Then
			SetLog("Error, no pixel found near collector => Normal attack near red line")
		EndIf
		If ($g_aiAttackStdSmartDeploy[$g_iMatchMode] = 0) Then
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				If Not IsArray($listInfoDeployTroopPixel) Then ContinueLoop
				For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
					Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
					If IsArray($infoPixelDropTroop) And UBound($infoPixelDropTroop) > 0 And (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then

						If $g_aiDeployHeroesPosition[0] <> -1 Then
							$pixelRandomDrop[0] = $g_aiDeployHeroesPosition[0]
							$pixelRandomDrop[1] = $g_aiDeployHeroesPosition[1]
							If $g_bDebugSetLog Then SetDebugLog("Deploy Heroes $g_aiDeployHeroesPosition")
						Else
							$pixelRandomDrop[0] = $g_aaiBottomRightDropPoints[2][0]
							$pixelRandomDrop[1] = $g_aaiBottomRightDropPoints[2][1] ;
							If $g_bDebugSetLog Then SetDebugLog("Deploy Heroes $g_aaiBottomRightDropPoints")
						EndIf
						$pixelRandomDropcc[0] = $pixelRandomDrop[0]
						$pixelRandomDropcc[1] = $pixelRandomDrop[1]

						If ($infoPixelDropTroop[0] = "CC" And $g_bIsHeroesDropped) Then
							dropCC($pixelRandomDropcc[0], $pixelRandomDropcc[1], $iCC)
							$g_bIsCCDropped = True
							$g_aiDeployCCPosition[0] = $pixelRandomDropcc[0]
							$g_aiDeployCCPosition[1] = $pixelRandomDropcc[1]
						ElseIf ($infoPixelDropTroop[0] = "HEROES") Then
							dropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $iKing, $iQueen, $iPrince, $iWarden, $iChampion, $iDuke)
							$g_aiDeployHeroesPosition[0] = $pixelRandomDrop[0]
							$g_aiDeployHeroesPosition[1] = $pixelRandomDrop[1]
						EndIf
					Else
						If IsArray($infoPixelDropTroop) And UBound($infoPixelDropTroop) >= 6 Then
							If _Sleep($DELAYLAUNCHTROOP21) Then Return
							If Not SelectDropTroop($infoPixelDropTroop[0]) Then ContinueLoop
							If _Sleep($DELAYLAUNCHTROOP21) Then Return
							SetLog("Deploying " & $infoPixelDropTroop[4] & " " & $infoPixelDropTroop[5], $COLOR_INFO)
							Local $iBeforeDeploy = ReadTroopQuantity($infoPixelDropTroop[0])
							DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], $infoPixelDropTroop[2], $infoPixelDropTroop[3])
							If $iBeforeDeploy > 0 Then VerifyStandardTroopDeployment($infoPixelDropTroop[0], $iBeforeDeploy)
						Else
							SetLog("Invalid troop info for deployment", $COLOR_ERROR)
						EndIf
					EndIf
					If ($g_bIsHeroesDropped) Then
						If _Sleep($DELAYLAUNCHTROOP22) Then Return ; delay Queen Image  has to be at maximum size : CheckHeroesHealth checks the y = 573
						CheckHeroesHealth()
					EndIf
					If _Sleep(SetSleep(1)) Then Return
				Next
			Next
		Else
			For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
				Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
				If Not IsArray($listInfoDeployTroopPixel) Then ContinueLoop
				If (UBound($listInfoDeployTroopPixel) > 0) Then
					Local $infoTroopListArrPixel = $listInfoDeployTroopPixel[0]
					Local $numberSidesDropTroop = 1

					For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
						$infoTroopListArrPixel = $listInfoDeployTroopPixel[$i]
						If Not IsArray($infoTroopListArrPixel) Then ContinueLoop
						If (UBound($infoTroopListArrPixel) > 1) Then
							Local $infoListArrPixel = $infoTroopListArrPixel[1]
							$numberSidesDropTroop = UBound($infoListArrPixel)
							ExitLoop
						EndIf
					Next

					If ($numberSidesDropTroop > 0) Then
						For $i = 0 To $numberSidesDropTroop - 1
							For $j = 0 To UBound($listInfoDeployTroopPixel) - 1
								$infoTroopListArrPixel = $listInfoDeployTroopPixel[$j]
								If Not IsArray($infoTroopListArrPixel) Then ContinueLoop
								If (IsString($infoTroopListArrPixel[0]) And ($infoTroopListArrPixel[0] = "CC" Or $infoTroopListArrPixel[0] = "HEROES")) Then

									If $g_aiDeployHeroesPosition[0] <> -1 Then
										$pixelRandomDrop[0] = $g_aiDeployHeroesPosition[0]
										$pixelRandomDrop[1] = $g_aiDeployHeroesPosition[1]
										If $g_bDebugSetLog Then SetDebugLog("Deploy Heroes $g_aiDeployHeroesPosition")
									Else
										$pixelRandomDrop[0] = $g_aaiBottomRightDropPoints[2][0]
										$pixelRandomDrop[1] = $g_aaiBottomRightDropPoints[2][1] ;
										If $g_bDebugSetLog Then SetDebugLog("Deploy Heroes $g_aaiBottomRightDropPoints")
									EndIf
									If $g_aiDeployCCPosition[0] <> -1 Then
										$pixelRandomDropcc[0] = $g_aiDeployCCPosition[0]
										$pixelRandomDropcc[1] = $g_aiDeployCCPosition[1]
										If $g_bDebugSetLog Then SetDebugLog("Deploy CC $g_aiDeployHeroesPosition")
									Else
										$pixelRandomDropcc[0] = $g_aaiBottomRightDropPoints[2][0]
										$pixelRandomDropcc[1] = $g_aaiBottomRightDropPoints[2][1] ;
										If $g_bDebugSetLog Then SetDebugLog("Deploy CC $g_aaiBottomRightDropPoints")
									EndIf

									If ($g_bIsCCDropped = False And $infoTroopListArrPixel[0] = "CC" And $g_bIsHeroesDropped) Then
										dropCC($pixelRandomDropcc[0], $pixelRandomDropcc[1], $iCC)
										$g_bIsCCDropped = True
										$g_aiDeployCCPosition[0] = $pixelRandomDropcc[0]
										$g_aiDeployCCPosition[1] = $pixelRandomDropcc[1]
									ElseIf ($g_bIsHeroesDropped = False And $infoTroopListArrPixel[0] = "HEROES" And $i = $numberSidesDropTroop - 1) Then
										dropHeroes($pixelRandomDrop[0], $pixelRandomDrop[1], $iKing, $iQueen, $iPrince, $iWarden, $iChampion, $iDuke)
										$g_aiDeployHeroesPosition[0] = $pixelRandomDrop[0]
										$g_aiDeployHeroesPosition[1] = $pixelRandomDrop[1]
									EndIf
								Else
									$infoListArrPixel = $infoTroopListArrPixel[1]
									Local $listPixel = $infoListArrPixel[$i]
									;infoPixelDropTroop : First element in array contains troop and list of array to drop troop
									If _Sleep($DELAYLAUNCHTROOP21) Then Return
									If Not SelectDropTroop($infoTroopListArrPixel[0]) Then ContinueLoop
									If _Sleep($DELAYLAUNCHTROOP23) Then Return
									SetLog("Deploying " & $infoTroopListArrPixel[2] & " " & $infoTroopListArrPixel[5] & " [Side " & $i + 1 & "]", $COLOR_INFO)
									Local $iBeforeSideDeploy = ReadTroopQuantity($infoTroopListArrPixel[0])
									Local $pixelDropTroop[1] = [$listPixel]
									DropOnPixel($infoTroopListArrPixel[0], $pixelDropTroop, $infoTroopListArrPixel[2], $infoTroopListArrPixel[3])
									If $iBeforeSideDeploy > 0 Then VerifyStandardTroopDeployment($infoTroopListArrPixel[0], $iBeforeSideDeploy)
								EndIf
								If ($g_bIsHeroesDropped) Then
									If _sleep(1000) Then Return ; delay Queen Image  has to be at maximum size : CheckHeroesHealth checks the y = 573
									CheckHeroesHealth()
								EndIf
							Next
						Next
					EndIf
				EndIf
				If _Sleep(SetSleep(1)) Then Return
			Next
		EndIf
		For $numWave = 0 To UBound($listListInfoDeployTroopPixel) - 1
			Local $listInfoDeployTroopPixel = $listListInfoDeployTroopPixel[$numWave]
			If Not IsArray($listInfoDeployTroopPixel) Then ContinueLoop
			For $i = 0 To UBound($listInfoDeployTroopPixel) - 1
				Local $infoPixelDropTroop = $listInfoDeployTroopPixel[$i]
				If IsArray($infoPixelDropTroop) And UBound($infoPixelDropTroop) >= 6 And Not (IsString($infoPixelDropTroop[0]) And ($infoPixelDropTroop[0] = "CC" Or $infoPixelDropTroop[0] = "HEROES")) Then
					Local $numberLeft = ReadTroopQuantity($infoPixelDropTroop[0])
					If ($numberLeft > 0) Then
						If _Sleep($DELAYLAUNCHTROOP21) Then Return
						If Not SelectDropTroop($infoPixelDropTroop[0]) Then ContinueLoop
						If _Sleep($DELAYLAUNCHTROOP23) Then Return
						SetLog("Dropping last " & $numberLeft & " " & GetTroopName($g_avAttackTroops[$infoPixelDropTroop[0]][0], $numberLeft), $COLOR_SUCCESS)
						;                       $troop,             $listArrPixel,               $number,                                 $slotsPerEdge = 0
						DropOnPixel($infoPixelDropTroop[0], $infoPixelDropTroop[1], Ceiling($numberLeft / UBound($infoPixelDropTroop[1])), $infoPixelDropTroop[3])
					EndIf
				EndIf
				If _Sleep(SetSleep(0)) Then Return
			Next
			If _Sleep(SetSleep(1)) Then Return
		Next
	Else
		For $i = 0 To UBound($listInfoDeploy) - 1
			If (IsString($listInfoDeploy[$i][0]) And ($listInfoDeploy[$i][0] = "CC" Or $listInfoDeploy[$i][0] = "HEROES")) Then
				If $g_iMatchMode = $LB And $g_aiAttackStdDropSides[$LB] >= 4 Then ; Used for DE or TH side attack
					Local $RandomEdge = $g_aaiEdgeDropPoints[$g_iBuildingEdge]
					Local $RandomXY = 2
				Else
					Local $RandomEdge = $g_aaiEdgeDropPoints[Round(Random(0, 3))]
					Local $RandomXY = Round(Random(1, 3))
				EndIf
				If ($listInfoDeploy[$i][0] = "CC") Then
					dropCC($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $iCC)
				ElseIf ($listInfoDeploy[$i][0] = "HEROES") Then
					dropHeroes($RandomEdge[$RandomXY][0], $RandomEdge[$RandomXY][1], $iKing, $iQueen, $iPrince, $iWarden, $iChampion, $iDuke)
				EndIf
			Else
				If LaunchTroop($listInfoDeploy[$i][0], $listInfoDeploy[$i][1], $listInfoDeploy[$i][2], $listInfoDeploy[$i][3], $listInfoDeploy[$i][4]) Then
					If _Sleep(SetSleep(1)) Then Return
				EndIf
			EndIf

		Next

	EndIf
	Return True
EndFunc   ;==>LaunchTroop2
