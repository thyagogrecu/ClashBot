; #FUNCTION# ====================================================================================================================
; Name ..........: PrepareAttack
; Description ...: Checks the troops when in battle, checks for type, slot, and quantity.  Saved in $g_avAttackTroops[SLOT][TYPE/QUANTITY] variable
; Syntax ........: PrepareAttack($pMatchMode[, $bRemaining = False[, $bSilentRefresh = False[, $bForceRefresh = False]]])
; Parameters ....: $pMatchMode          - a pointer value.
;                  $bRemaining          - [optional] Flag for when checking remaining troops. Default is False.
;                  $bSilentRefresh      - [optional] Suppresses normal logs during an internal refresh. Default is False.
;                  $bForceRefresh       - [optional] Rebuilds the visible bar and accepts any regular remaining troop.
; Return values .: None
; Author ........:
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func PrepareAttack($pMatchMode, $bRemaining = False, $bSilentRefresh = False, $bForceRefresh = False) ;Assigns troops

	; Attack CSV has debug option to save attack line image, save have png of current $g_hHBitmap2
	If GetEffectiveAttackAlgorithm($pMatchMode) = 1 Then
		If $g_bDebugMakeIMGCSV And $bRemaining = False And TestCapture() = 0 Then
			If $g_iSearchTH = "-" Then ; If TH is unknown, try again to find as it is needed for filename
				imglocTHSearch(True, False, False)
			EndIf
			SaveDebugImage("clean", False, Default, "TH" & $g_iSearchTH & "-") ; make clean snapshot as well
		EndIf
	EndIf

	If Not $bRemaining Then ; only for initial attack preparation, not for checking remaining troops after some were used
		; Zoom out the screen to ensure proper view for troop detection and attack preparation
		ZoomOutSimple()
		_Sleep($DELAYZOOMOUT1) ; Small delay to ensure changes are applied
	
		; Set village offset to ensure correct coordinate mapping for attack simulation
		setVillageOffset(0, 0, 1)
		ConvertInternalExternArea()
		
		; reset hero dropped flags
		$g_bDropKing = False
		$g_bDropQueen = False
		$g_bDropPrince = False
		$g_bDropWarden = False
		$g_bDropChampion = False
		$g_bDropDuke = False
		$g_bIsHeroesDropped = False
		If $g_iActivateKing = 1 Or $g_iActivateKing = 2 Then $g_aHeroesTimerActivation[$eHeroBarbarianKing] = 0
		If $g_iActivateQueen = 1 Or $g_iActivateQueen = 2 Then $g_aHeroesTimerActivation[$eHeroArcherQueen] = 0
		If $g_iActivatePrince = 1 Or $g_iActivatePrince = 2 Then $g_aHeroesTimerActivation[$eHeroMinionPrince] = 0
		If $g_iActivateWarden = 1 Or $g_iActivateWarden = 2 Then $g_aHeroesTimerActivation[$eHeroGrandWarden] = 0
		If $g_iActivateChampion = 1 Or $g_iActivateChampion = 2 Then $g_aHeroesTimerActivation[$eHeroRoyalChampion] = 0
		If $g_iActivateDuke = 1 Or $g_iActivateDuke = 2 Then $g_aHeroesTimerActivation[$eHeroDukeIndex] = 0

		$g_iTotalAttackSlot = 10 ; reset flag - Slot11+
		$g_bDraggedAttackBar = False
		$g_bExtendedAttackBar = False
	EndIf

	SetDebugLog("PrepareAttack for " & $pMatchMode & " " & $g_asModeText[$pMatchMode], $COLOR_DEBUG)
	If $bRemaining And Not $bSilentRefresh Then
		SetLog("Checking remaining unused troops")
		If $g_bExtendedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True)
	ElseIf Not $bRemaining Then
		SetLog("Preparing " & $g_asModeText[$pMatchMode] & " Attack", $COLOR_INFO)
	EndIf

	If _Sleep($DELAYPREPAREATTACK1) Then Return

	Local $iTroopNumber = 0

	Local $avAttackBar = GetAttackBar($bRemaining, $pMatchMode, False, $bForceRefresh)
	Local $bPreserveRemainingSlots = $bRemaining And Not $bForceRefresh And $g_bAttackActive And GetEffectiveAttackAlgorithm($pMatchMode) <> 1
	If $bRemaining And Not IsArray($avAttackBar) Then
		SetDebugLog("PrepareAttack: remaining attack bar detection failed", $COLOR_ERROR)
		Return -1
	EndIf
	For $i = 0 To UBound($g_avAttackTroops, 1) - 1
		Local $bClearSlot = True ; by default clear the slot, if no corresponding slot is found in attackbar detection
		If $bRemaining And Not $bForceRefresh Then
			; keep initial heroes to avoid possibly "losing" them when not dropped yet
			;Local $bSlotDetectedAgain = UBound($avAttackBar, 1) > $i And $g_avAttackTroops[$i][0] = Number($avAttackBar[$i][0]) ; wrong, as attackbar array on remain is shorter
			Local $bDropped = Default
			Local $iTroopIndex = $g_avAttackTroops[$i][0]
			Switch $iTroopIndex
				Case $eKing
					$bDropped = $g_bDropKing
				Case $eQueen
					$bDropped = $g_bDropQueen
				Case $ePrince
					$bDropped = $g_bDropPrince
				Case $eWarden
					$bDropped = $g_bDropWarden
				Case $eChampion
					$bDropped = $g_bDropChampion
				Case $eDuke
					$bDropped = $g_bDropDuke
			EndSwitch
			If $bDropped = False Then
				SetDebugLog("Discard updating hero " & GetTroopName($g_avAttackTroops[$i][0]) & " because not dropped yet")
				$iTroopNumber += $g_avAttackTroops[$i][2]
				ContinueLoop
			EndIf
			If $bDropped = True Then
				;If $bSlotDetectedAgain Then
				; ok, hero was dropped, really? don't know yet... TODO add check if hero was really dropped...
				;EndIf
				SetDebugLog("Discard updating hero " & GetTroopName($g_avAttackTroops[$i][0]) & " because already dropped")
				$iTroopNumber += $g_avAttackTroops[$i][2]
				ContinueLoop
			EndIf
		EndIf

		If UBound($avAttackBar, 1) > 0 Then
			For $j = 0 To UBound($avAttackBar, 1) - 1
				If $avAttackBar[$j][1] = $i Then
					; troop slot found
					If IsUnitUsed($pMatchMode, $avAttackBar[$j][0]) Or ($bForceRefresh And $avAttackBar[$j][0] >= $eBarb And $avAttackBar[$j][0] <= $eGDrag) Then
						$bClearSlot = False
						Local $sLogExtension = ""
						If Not $bRemaining Or $bForceRefresh Then
							; Select castle or siege machine only during initial preparation.
							If Not $bRemaining And ($pMatchMode = $DB Or $pMatchMode = $LB) Then
								Switch $avAttackBar[$j][0]
									Case $eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF, $eBattleD, $eTroopL, $eSkyW ; 0=Default, 1=Any, 2=Castle Only, 3-11=Specific Siege

										SetDebugLog("Effective Attack Siege: " & GetEffectiveAttackSiege($pMatchMode))

										If GetEffectiveAttackSiege($pMatchMode) <> 0 Then
											SelectCastleOrSiege($avAttackBar[$j][0], Number($avAttackBar[$j][5]), GetEffectiveAttackSiege($pMatchMode))

											If GetEffectiveAttackSiege($pMatchMode) = 2 And Not ($avAttackBar[$j][0] = $eCastle) Then ; if the user wanted to drop castle and no troops were available, do not drop a siege
												SetDebugLog("Discard use of " & GetTroopName($avAttackBar[$j][0]) & " (" & $avAttackBar[$j][0] & ")", $COLOR_ERROR)
												ContinueLoop
											EndIf

											If $avAttackBar[$j][0] <> $eCastle Then $sLogExtension = " (Level " & $g_iSiegeLevel & ")"
										EndIf
									Case $eWarden
								EndSwitch
							EndIf

							; populate the i-th slot
							$g_avAttackTroops[$i][0] = Number($avAttackBar[$j][0]) ; Troop Index
							$g_avAttackTroops[$i][1] = Number($avAttackBar[$j][2]) ; Amount
							$g_avAttackTroops[$i][2] = Number($avAttackBar[$j][3]) ; X-Coord
							$g_avAttackTroops[$i][3] = Number($avAttackBar[$j][4]) ; Y-Coord
							$g_avAttackTroops[$i][4] = Number($avAttackBar[$j][5]) ; OCR X-Coord
							$g_avAttackTroops[$i][5] = Number($avAttackBar[$j][6]) ; OCR Y-Coord
						Else
							; only update amount of i-th slot
							$g_avAttackTroops[$i][1] = Number($avAttackBar[$j][2]) ; Amount
						EndIf
						Local $iAttackBarQuantity = Number($avAttackBar[$j][2])
						$iTroopNumber += $iAttackBarQuantity

						If $iAttackBarQuantity > 0 And Not ($bRemaining And $bSilentRefresh) Then
							Local $sDebugText = $g_bDebugSetLog ? " (X:" & $avAttackBar[$j][3] & "|Y:" & $avAttackBar[$j][4] & "|OCR-X:" & $avAttackBar[$j][5] & "|OCR-Y:" & $avAttackBar[$j][6] & ")" : ""
							SetLog($avAttackBar[$j][1] & ": " & $iAttackBarQuantity & " " & GetTroopName($avAttackBar[$j][0], $iAttackBarQuantity) & $sLogExtension & $sDebugText, $COLOR_SUCCESS)
						EndIf
					Else
						SetDebugLog("Discard use of " & GetTroopName($avAttackBar[$j][0]) & " (" & $avAttackBar[$j][0] & ")", $COLOR_ERROR)
					EndIf
					ExitLoop
				EndIf
			Next
		EndIf

		If $bClearSlot Then
			If $bPreserveRemainingSlots Then
				SetDebugLog("PrepareAttack: preserving undetected remaining slot " & $i, $COLOR_WARNING)
				$iTroopNumber += $g_avAttackTroops[$i][1]
				ContinueLoop
			EndIf
			; slot not identified
			$g_avAttackTroops[$i][0] = -1
			$g_avAttackTroops[$i][1] = 0
			$g_avAttackTroops[$i][2] = 0
			$g_avAttackTroops[$i][3] = 0
			$g_avAttackTroops[$i][4] = 0
			$g_avAttackTroops[$i][5] = 0
		EndIf
	Next
	If Not $bRemaining Or $bForceRefresh Then SetSlotSpecialTroops()

	Return $iTroopNumber
EndFunc   ;==>PrepareAttack

Func SelectCastleOrSiege(ByRef $iTroopIndex, $iX, $iCmbSiege)
	Local $hStarttime = _Timer_Init()
	Local $aSiegeTypes[12] = ["Default", "Any", $eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF, $eBattleD, $eTroopL, $eSkyW]
	Local $ToUse = $aSiegeTypes[$iCmbSiege]
	Local $bNeedSwitch = False, $bAnySiege = False

	; Max siege level from the training-time table (index 0 = number of levels)
	Local $iTroopTableIdx = $iTroopIndex - $eWallW
	Local $iMaxSiegeLevel = ($iTroopTableIdx >= 0 And $iTroopTableIdx < $eSiegeMachineCount) ? $g_aiSiegeMachineTrainTimePerLevel[$iTroopTableIdx][0] : 4

	Switch $ToUse
		Case $iTroopIndex ; the same as current castle/siege
			If $iTroopIndex <> $eCastle And $g_iSiegeLevel < $iMaxSiegeLevel Then
				$bNeedSwitch = True
				SetLog(GetTroopName($iTroopIndex) & " level " & $g_iSiegeLevel & " detected, looking for higher level")
			EndIf

		Case $eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF, $eBattleD, $eTroopL, $eSkyW ; NOT the same as current castle/siege
			$bNeedSwitch = True
			SetLog(GetTroopName($iTroopIndex) & ($iTroopIndex <> $eCastle ? " level " & $g_iSiegeLevel & " detected, looking for " : " detected, switching to ") & GetTroopName($ToUse))

		Case "Any" ; use any siege
			If $iTroopIndex = $eCastle Or ($iTroopIndex <> $eCastle And $g_iSiegeLevel < $iMaxSiegeLevel) Then ; found Castle or a low level Siege
				$bNeedSwitch = True
				$bAnySiege = True
				SetLog(GetTroopName($iTroopIndex) & ($iTroopIndex = $eCastle ? " detected, looking for any siege machine" : " level " & $g_iSiegeLevel & " detected, looking for any higher siege machine"))
			EndIf
	EndSwitch

	If $bNeedSwitch Then
		; Wider search area when Castle is in slot (button may appear at different offset than for siege)
		Local $sSearchArea = ($iTroopIndex = $eCastle) ? _
			GetDiamondFromRect($iX - 50 & ",693," & $iX + 70 & ",730") : _
			GetDiamondFromRect($iX - 30 & ",700," & $iX + 35 & ",720")
		Local $aiSwitchBtn = decodeSingleCoord(findImage("SwitchSiegeButton", $g_sImgSwitchSiegeMachine & "ButtonSelection\SiegeAtt*", $sSearchArea, 1, True, Default))
		If Not (IsArray($aiSwitchBtn) And UBound($aiSwitchBtn, 1) = 2) Then
			SetLog("Switch button not found for " & GetTroopName($iTroopIndex) & " at X:" & $iX & " (area: " & $sSearchArea & ")", $COLOR_ERROR)
			SaveDebugDiamondImage("SwitchBtn_NotFound_" & GetTroopName($iTroopIndex), $sSearchArea)
		EndIf
		If IsArray($aiSwitchBtn) And UBound($aiSwitchBtn, 1) = 2 Then
			ClickP($aiSwitchBtn)

			; wait to appears the new small window
			Local $iLastX = $aiSwitchBtn[0] - 30, $iLastY = $aiSwitchBtn[1]
			If _Sleep(2000) Then Return

			; Dynamically locate switch popup: search a wide horizontal band, then refine to a 440x105 window from detected coords.
			Local $iSearchTop = 505, $iSearchBottom = 610
			Local $iSearchLeft = 0, $iSearchRight = $g_iGAME_WIDTH
			Local $sSearchAreaWide = GetDiamondFromRect2(0, $iSearchTop, $g_iGAME_WIDTH, $iSearchBottom)
			Local $aSearchResult = findMultiple($g_sImgSwitchSiegeMachine, $sSearchAreaWide, $sSearchAreaWide, 0, 1000, 5, "objectname,objectpoints", True)

			If IsArray($aSearchResult) And UBound($aSearchResult) > 0 Then
				Local $iMinX = $g_iGAME_WIDTH, $iMaxX = 0
				For $k = 0 To UBound($aSearchResult) - 1
					Local $aTmpAvailable = $aSearchResult[$k]
					Local $aTmpCoords = decodeMultipleCoords(_ArrayToString($aTmpAvailable, "|", 1), 50, 50)
					If Not IsArray($aTmpCoords) Then ContinueLoop
					For $m = 0 To UBound($aTmpCoords) - 1
						Local $aTmpCoord = $aTmpCoords[$m]
						If IsArray($aTmpCoord) And UBound($aTmpCoord) >= 2 Then
							$iMinX = _Min($iMinX, Number($aTmpCoord[0]))
							$iMaxX = _Max($iMaxX, Number($aTmpCoord[0]))
						EndIf
					Next
				Next

				If $iMaxX > $iMinX Then
					$iSearchLeft = _Max(_Min($iMinX - 35, $g_iGAME_WIDTH - 440), 0)
					$iSearchRight = $iSearchLeft + 440
				Else
					$iSearchLeft = _Max(_Min($aiSwitchBtn[0] - 220, $g_iGAME_WIDTH - 440), 0)
					$iSearchRight = $iSearchLeft + 440
				EndIf
			Else
				; Fallback to old logic if wide-band search failed for any reason.
				$iSearchLeft = _Min($iX - 50, 470)
				$iSearchRight = $iSearchLeft + 440
			EndIf

			Local $sSearchArea = GetDiamondFromRect2($iSearchLeft, $iSearchTop, $iSearchRight, $iSearchBottom)
			SetLog("Switch Search Area: " & $sSearchArea)
			If $g_bDebugImageSave Then SaveDebugDiamondImage("SelectCastleOrSiege", $sSearchArea)

			; Re-run in refined area to reduce false positives and keep outlier filtering bounded.
			$aSearchResult = findMultiple($g_sImgSwitchSiegeMachine, $sSearchArea, $sSearchArea, 0, 1000, 5, "objectname,objectpoints", True)
			If $g_bDebugSetLog Then SetDebugLog("Benchmark Switch Siege imgloc: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
			$hStarttime = _Timer_Init()

			If $aSearchResult <> "" And IsArray($aSearchResult) Then
				Local $iFinalX = -1, $iFinalY = -1, $iFinalLevel = 0, $iFinalSiege

				For $i = 0 To UBound($aSearchResult) - 1
					Local $aAvailable = $aSearchResult[$i]
					SetDebugLog("SelectCastleOrSiege() $aSearchResult[" & $i & "]: " & _ArrayToString($aAvailable))

					Local $iSiegeIndex = TroopIndexLookup($aAvailable[0], "SelectCastleOrSiege()")
					Local $sAllCoordsString = _ArrayToString($aAvailable, "|", 1)
					Local $aAllCoords = decodeMultipleCoords($sAllCoordsString, 50, 50)

					If $iSiegeIndex = $ToUse And $iSiegeIndex = $eCastle Then
						If IsArray($aAllCoords) And UBound($aAllCoords) > 0 Then
							Local $aFirstCoord = $aAllCoords[0]
							If IsArray($aFirstCoord) And UBound($aFirstCoord) >= 2 Then
								$iFinalX = Number($aFirstCoord[0])
								$iFinalY = Number($aFirstCoord[1])
							EndIf
						EndIf
						$iFinalSiege = $iSiegeIndex
						ExitLoop
					EndIf

					$iMaxSiegeLevel = (($iSiegeIndex - $eWallW) >= 0 And ($iSiegeIndex - $eWallW) < $eSiegeMachineCount) ? $g_aiSiegeMachineTrainTimePerLevel[$iSiegeIndex - $eWallW][0] : 4

					If $iSiegeIndex >= $eWallW And $iSiegeIndex <= $eSkyW And ($bAnySiege Or $iSiegeIndex = $ToUse) Then
						If Not IsArray($aAllCoords) Or UBound($aAllCoords) = 0 Then ContinueLoop
						For $j = 0 To UBound($aAllCoords) - 1
							Local $aCoords = $aAllCoords[$j]
							If Not IsArray($aCoords) Or UBound($aCoords) < 2 Then ContinueLoop

							Local $iCoordX = Number($aCoords[0])
							Local $iCoordY = Number($aCoords[1])
							If $iCoordX < $iSearchLeft + 8 Or $iCoordX > $iSearchRight - 8 Or $iCoordY < $iSearchTop + 12 Or $iCoordY > $iSearchBottom - 6 Then
								SetDebugLog("SelectCastleOrSiege() skip outlier coord: " & $iCoordX & "|" & $iCoordY & " for " & $aAvailable[0])
								ContinueLoop
							EndIf

					Local $iSiegeIdx = $iSiegeIndex - $eWallW
					If $iSiegeIdx < 0 Or $iSiegeIdx >= $eSiegeMachineCount Then $iSiegeIdx = 0
						Local $SiegeLevel = getSiegeLevel($iCoordX + $g_aiSiegeOcrOffsets[$iSiegeIdx][1], $iSearchTop + $g_aiSiegeOcrOffsets[$iSiegeIdx][2])
							If $SiegeLevel = "" Then $SiegeLevel = 1
							If Number($SiegeLevel) < 1 Or Number($SiegeLevel) > $iMaxSiegeLevel Then $SiegeLevel = 1
							If $iFinalLevel < Number($SiegeLevel) Then
								$iFinalLevel = Number($SiegeLevel)
								$iFinalX = $iCoordX
								$iFinalY = $iCoordY
								$iFinalSiege = $iSiegeIndex
							EndIf
							SetDebugLog($i & "." & $j & ". Name: " & $aAvailable[0] & ", Level: " & $SiegeLevel & ", Coords: " & $iCoordX & "|" & $iCoordY)
							SetLog($i & "." & $j & ". Name: " & $aAvailable[0] & ", Level: " & $SiegeLevel & ", Coords: " & $iCoordX & "|" & $iCoordY)
							If $iFinalLevel = $iMaxSiegeLevel Then ExitLoop 2 ; Exit when max level found
						Next
					EndIf
				Next
				If $g_bDebugSetLog Then SetDebugLog("Benchmark Switch Siege Levels: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
				$hStarttime = _Timer_Init()

				If ($iTroopIndex = $ToUse Or $bAnySiege) And $g_iSiegeLevel >= $iFinalLevel Then
					SetLog($bAnySiege ? "No higher level siege machine found" : "No higher level of " & GetTroopName($iTroopIndex) & " found")
					Click($iLastX, $iLastY, 1)
				ElseIf $iFinalX > 0 And $iFinalY > 0 Then
					Click($iFinalX, $iFinalY, 1, 0)
					$g_iSiegeLevel = $iFinalLevel
					$iTroopIndex = $iFinalSiege
				Else
					If Not $bAnySiege Then SetLog("No " & GetTroopName($ToUse) & " found")
					Click($iLastX, $iLastY, 1)
				EndIf

			Else
				If $g_bDebugImageSave Then SaveDebugImage("PrepareAttack_SwitchSiege")
				; If was not detectable lets click again on green icon to hide the window!
				SetLog("Undetected " & ($bAnySiege ? "any siege machine " : GetTroopName($ToUse)) & " after click on switch btn!", $COLOR_DEBUG)
				Click($iLastX, $iLastY, 1)
			EndIf
			If _Sleep(750) Then Return
		EndIf
	EndIf
	If $g_bDebugSetLog Then SetDebugLog("Benchmark Switch Siege Detection: " & StringFormat("%.2f", _Timer_Diff($hStarttime)) & "'ms")
EndFunc   ;==>SelectCastleOrSiege

Func IsUnitUsed($iMatchMode, $iTroopIndex)
	If $iTroopIndex < $eKing Then ;Index is a Troop
		Local $aTempArray = $g_aaiTroopsToBeUsed[$g_aiAttackTroopSelection[$iMatchMode]]
		Local $iFoundAt = _ArraySearch($aTempArray, $iTroopIndex)
		If $iFoundAt <> -1 Then Return True
		Return False
	Else ; Index is a Hero/Siege/Castle/Spell
		If $iMatchMode <> $DB And $iMatchMode <> $LB Then
			Return True
		Else
			Switch $iTroopIndex
				Case $eKing To $eDuke
					Return True
				Case $eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF, $eBattleD, $eTroopL, $eSkyW
					If $g_abAttackDropCC[$iMatchMode] Or GetEffectiveAttackAlgorithm($iMatchMode) = 1 Then Return True
				Case $eLSpell To $eASpell
					Return True
				Case Else
					Return False
			EndSwitch
			Return False
		EndIf
		Return False
	EndIf
	Return False
EndFunc   ;==>IsUnitUsed

Func AttackRemainingTime($bInitialze = Default)
	Static $iTagTeamPauseAtAttack = 0
	If $bInitialze Then
		$g_hAttackTimer = __TimerInit()
		$g_iAttackTimerOffset = Default
		$iTagTeamPauseAtAttack = GetTagTeamPauseTime()
		SuspendAndroidTime(True) ; Reset suspend Android time for compensation when Android is suspended
		Return
	EndIf

	Local $iPrepareTime = 29 * 1000

	If $g_iAttackTimerOffset = Default Then
		; now attack is really starting (or it has already after 30 Seconds)
		; set offset
		$g_iAttackTimerOffset = __TimerDiff($g_hAttackTimer) - SuspendAndroidTime()

		If $g_iAttackTimerOffset > $iPrepareTime Then
			; adjust offset by remove "lost" attack time
			$g_iAttackTimerOffset = $iPrepareTime - $g_iAttackTimerOffset
		EndIf
	EndIf

	; Return remaining attack time
	Local $iAttackTime = 3 * 60 * 1000
	Local $iTagTeamPause = GetTagTeamPauseTime() - $iTagTeamPauseAtAttack
	Local $iRemaining = $iAttackTime - (__TimerDiff($g_hAttackTimer) - SuspendAndroidTime() - $g_iAttackTimerOffset - $iTagTeamPause)
	If $iRemaining < 0 Then Return 0
	Return $iRemaining
EndFunc   ;==>AttackRemainingTime

Func BattleSpeedPixelMatch($hBitmap, $iCenterX, $iCenterY, $iColor, $iTolerance, $iRadius = 2)
	For $iY = $iCenterY - $iRadius To $iCenterY + $iRadius
		For $iX = $iCenterX - $iRadius To $iCenterX + $iRadius
			Local $sPixel = Hex(_GDIPlus_BitmapGetPixel($hBitmap, $iX, $iY), 6)
			If _ColorCheck($sPixel, Hex($iColor, 6), $iTolerance) Then Return True
		Next
	Next
	Return False
EndFunc   ;==>BattleSpeedPixelMatch

Func IsBattleSpeedButtonVisible($sBattleType = "Main Village")
	; Cover both Battle Speed layouts and click the center actually detected.
	Local $iLeft = 790, $iTop = 390 + $g_iMidOffsetY
	Local $iRight = 852, $iBottom = 536 + $g_iMidOffsetY

	Local $hLocalHBitmap = _CaptureRegion($iLeft, $iTop, $iRight, $iBottom, True)
	If $hLocalHBitmap = 0 Then Return False

	Local $hLocalBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hLocalHBitmap)
	Local $bVisible = False

	If $hLocalBitmap <> 0 Then
		Local $iWhiteCount = 0, $iWhiteXTotal = 0, $iWhiteYTotal = 0
		Local $iWidth = $iRight - $iLeft
		Local $iHeight = $iBottom - $iTop

		For $iY = 0 To $iHeight
			For $iX = 0 To $iWidth
				Local $iPixel = _GDIPlus_BitmapGetPixel($hLocalBitmap, $iX, $iY)
				Local $iRed = BitAND(BitShift($iPixel, 16), 0xFF)
				Local $iGreen = BitAND(BitShift($iPixel, 8), 0xFF)
				Local $iBlue = BitAND($iPixel, 0xFF)

				If $iRed >= 220 And $iGreen >= 220 And $iBlue >= 220 Then
					$iWhiteCount += 1
					$iWhiteXTotal += $iX
					$iWhiteYTotal += $iY
				EndIf
			Next
		Next

		If $iWhiteCount >= 20 Then
			Local $iButtonX = Round($iWhiteXTotal / $iWhiteCount)
			Local $iButtonY = Round($iWhiteYTotal / $iWhiteCount)
			Local $iGreenCount = 0
			Local $iScanTop = $iButtonY - 32, $iScanBottom = $iButtonY + 32
			Local $iScanLeft = $iButtonX - 28, $iScanRight = $iButtonX + 28
			If $iScanTop < 0 Then $iScanTop = 0
			If $iScanBottom > $iHeight Then $iScanBottom = $iHeight
			If $iScanLeft < 0 Then $iScanLeft = 0
			If $iScanRight > $iWidth Then $iScanRight = $iWidth
			For $iY = $iScanTop To $iScanBottom
				For $iX = $iScanLeft To $iScanRight
					Local $iPixel = _GDIPlus_BitmapGetPixel($hLocalBitmap, $iX, $iY)
					Local $iRed = BitAND(BitShift($iPixel, 16), 0xFF)
					Local $iGreen = BitAND(BitShift($iPixel, 8), 0xFF)
					Local $iBlue = BitAND($iPixel, 0xFF)
					If $iGreen >= 145 And $iRed >= 70 And $iRed <= 235 And $iBlue <= 140 And $iGreen > $iRed + 20 And $iGreen > $iBlue + 45 Then $iGreenCount += 1
				Next
			Next
			$bVisible = $iGreenCount >= 500
			If $bVisible Then
				$g_aiBattleSpeedButtonPos[0] = $iLeft + $iButtonX
				$g_aiBattleSpeedButtonPos[1] = $iTop + $iButtonY
			EndIf
		EndIf
		_GDIPlus_BitmapDispose($hLocalBitmap)
	EndIf

	GdiDeleteHBitmap($hLocalHBitmap)
	Return $bVisible
EndFunc   ;==>IsBattleSpeedButtonVisible

Func ClickBattleSpeedButton($sBattleType = "Main Village")
	; Keep the original Builder Base timing isolated from the Main Village Tag Team handling.
	If $sBattleType = "Builder Base" Then
		SetLog("Activating Battle Speed (" & $sBattleType & ")", $COLOR_ACTION)
		Sleep(1000)
		Click(Random($g_aiBattleSpeedButtonPos[0] - 6, $g_aiBattleSpeedButtonPos[0] + 6, 1), Random($g_aiBattleSpeedButtonPos[1] - 6, $g_aiBattleSpeedButtonPos[1] + 6, 1), 1, 120)
		Return True
	EndIf

	; The screen can change between the caller's detection and this click.
	If Not IsBattleSpeedButtonVisible($sBattleType) Then Return False
	If TestCapture() Or Not $g_bRunState Then Return False
	SetLog("Activating Battle Speed (" & $sBattleType & ")", $COLOR_ACTION)
	Click(Random($g_aiBattleSpeedButtonPos[0] - 6, $g_aiBattleSpeedButtonPos[0] + 6, 1), Random($g_aiBattleSpeedButtonPos[1] - 6, $g_aiBattleSpeedButtonPos[1] + 6, 1), 1, 120, "Battle Speed Main Village")
	Return True
EndFunc   ;==>ClickBattleSpeedButton

Func ActivateBattleSpeedAfterTwoMinutes()
	Static $bSpeedActivated = False
	Static $hAttackSession = 0
	Static $hLastCheck = 0
	Static $iTagTeamPauseAtSession = 0

	If Not $g_bEnableBattleSpeed Then Return False
	If $g_hAttackTimer = 0 Then Return False
	; Wait for the first troop deployment.
	If $g_iAttackTimerOffset = Default Then Return False
	If $hAttackSession <> $g_hAttackTimer Then
		$hAttackSession = $g_hAttackTimer
		$bSpeedActivated = False
		$g_bBattleSpeedActivated = False
		$hLastCheck = 0
		$iTagTeamPauseAtSession = GetTagTeamPauseTime()
	EndIf
	If $bSpeedActivated Then Return False
	If $hLastCheck <> 0 And __TimerDiff($hLastCheck) < 500 Then Return False
	$hLastCheck = __TimerInit()

	; Stop monitoring after the normal attack window has expired.
	Local $iTagTeamPause = GetTagTeamPauseTime() - $iTagTeamPauseAtSession
	Local $iElapsed = __TimerDiff($g_hAttackTimer) - SuspendAndroidTime() - $iTagTeamPause
	If $iElapsed > 210000 Then Return False

	; Do not wait for a fixed time. Click as soon as the 1x button becomes visible.
	If Not IsBattleSpeedButtonVisible() Then Return False
	If Number($g_iPercentageDamage) >= 100 Then Return False

	If ClickBattleSpeedButton("Main Village") Then
		$bSpeedActivated = True
		$g_bBattleSpeedActivated = True
		Return True
	EndIf
	Return False
EndFunc   ;==>ActivateBattleSpeedAfterTwoMinutes
