; #FUNCTION# ====================================================================================================================
; Name ..........: GetAttackBar
; Description ...: Detects Army in the Attackbar and Returns Name, Slot, Amount and X Coordinate
; Syntax ........: GetAttackBar($bRemaining = False, $pMatchMode = $DB, $bDebug = False, $bForceRefresh = False)
; Parameters ....: $bRemaining (First Check or for Remaining Troops), $pMatchMode (Attackmode that needs the Attackbar: $DB, $AB), $bDebug (Debug GetAttackbar), $bForceRefresh (rebuild visible bar)
; Return values .:
; Author ........: Trlopes (06-2016)
; Modified ......: ProMac (12-2016), Fliegerfaust(12-2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func GetAttackBar($bRemaining = False, $pMatchMode = $DB, $bDebug = False, $bForceRefresh = False)
	Local Static $aAttackBar[0][8]
	Local Static $bDoubleRow = False, $bCheckSlot12 = False
	Local $sSearchDiamond = GetDiamondFromRect2(0, 575 + $g_iBottomOffsetY, 858, 644 + $g_iBottomOffsetY)
	Local $iYBelowRowOne = 630, $aiOCRLocation[2] = [-1, -1], $aSlotAmountX[0][3]
	Local $g_bCheckExtAttackBar = True
	Local $bPreserveRemainingSlots = $bRemaining And Not $bForceRefresh And $g_bAttackActive And GetEffectiveAttackAlgorithm($pMatchMode) <> 1
	If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True)

	;Reset All Static Variables if GetAttackBar is not for Remaining
	If Not $bRemaining Or $bForceRefresh Then
		$bCheckSlot12 = False
		$bDoubleRow = False
		$g_bExtendedAttackBar = False
		Local $aDummyArray[0][8]
		$aAttackBar = $aDummyArray
		$g_iLSpellLevel = 1
		$g_iESpellLevel = 1
		$g_iSiegeLevel = 0

		;Check if Double Row is enabled aswell as has 12+ Slots
		If _CheckPixel($aDoubRowAttackBar, True) Then
				$bDoubleRow = True
				$sSearchDiamond = GetDiamondFromRect("0,535,835,698")
		ElseIf IsArray(_PixelSearch($a12OrMoreSlots[0], $a12OrMoreSlots[1], $g_iGAME_WIDTH, $a12OrMoreSlots[1] + 3, Hex($a12OrMoreSlots[2], 6), $a12OrMoreSlots[3], True)) And $g_bCheckExtAttackBar Then
			$bCheckSlot12 = True
			$g_bExtendedAttackBar = True
			SetLog("Check Extended Attack Bar", $COLOR_INFO)
		ElseIf Not $bForceRefresh Then
			SetLog("Check Attack Bar", $COLOR_INFO)
		EndIf
		SetDebugLog("GetBarCheck: DoubleRow= " & $bDoubleRow)
	EndIf

	If Not $g_bRunState Then Return

	If UBound($aAttackBar) = 0 Or Not $bRemaining Or $bForceRefresh Then
		Local $iAttackbarStart = __TimerInit()
		Local $aTempArray, $aTempCoords, $aTempMultiCoords, $iRow = 1

		Local $aAttackBarResult = findMultiple($g_sImgAttackBarDir, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)

		If UBound($aAttackBarResult) = 0 Then
			If $bRemaining Then
				SetDebugLog("GetAttackBar(): No remaining troop found in the visible bar")
				Return ""
			EndIf
			SetLog("Error in GetAttackBar(): Search did not return any results!", $COLOR_ERROR)
			SaveDebugImage("ErrorGetAttackBar", False, Default, "#1")
			Return ""
		EndIf

		;Add found Stuff into our Arrays
		For $i = 0 To UBound($aAttackBarResult, 1) - 1
			$aTempArray = $aAttackBarResult[$i]
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 40, 40, -1)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				If UBound($aTempCoords) < 2 Then ContinueLoop
				If $bDoubleRow And $aTempCoords[1] >= $iYBelowRowOne Then $iRow = 2
				If StringRegExp($aTempArray[0], "(AmountX)", 0) Then
					_ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					$aiOCRLocation[$iRow - 1] = $aTempCoords[1] ; Store any OCR Location for later use on Heroes
				Else
					If StringRegExp($aTempArray[0], "(King)|(Queen)|(Prince)|(Warden)|(Champion)|(Duke)|(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)|(TroopL)|(SkyW)", 0) Then _ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Local $aTempElement[1][8] = [[$aTempArray[0], $aTempCoords[0], $aTempCoords[1], -1, -1, -1, -1, $iRow]] ; trick to get the right variable types into our array. Delimiter Adding only gets us string which can't be sorted....
					_ArrayAdd($aAttackBar, $aTempElement)
				EndIf
				$iRow = 1
			Next
		Next

		If UBound($aAttackBar, 1) = 0 Then
			If $bForceRefresh Then
				SetDebugLog("GetAttackBar(): No Tag Team remaining troop found in the visible bar")
				Return ""
			EndIf
			SetLog("Error in GetAttackBar(): $aAttackBar has no results in it", $COLOR_ERROR)
			Return ""
		EndIf

		;Sort the Arrays by X Position of the Results
		_ArraySort($aAttackBar, 0, 0, 0, 1)
		_ArraySort($aSlotAmountX)
		If $bDoubleRow Then $aSlotAmountX = SortDoubleRowXElements($aSlotAmountX)

		SetDebugLog("GetAttackBar(): Finished Image Search in: " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")
		$iAttackbarStart = __TimerInit()

	EndIf

	DebugAttackBarImage($aAttackBar)

	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop/Spell/Hero/Siege
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
		[n][5] = The X Coordinate of the x beside the Amount
		[n][6] = The Y Coordinate of the x beside the Amount
		[n][7] = The Row where it is in
	#comments-end

	Local $aFinalAttackBar[0][7]
	Local $aiOCRY = [-1, -1]
	If Not $bRemaining Or $bForceRefresh Then $aiOCRY = GetOCRYLocation($aSlotAmountX)
	Local $sKeepRemainTroops = "(King)|(Queen)|(Prince)|(Warden)|(Champion)|(Duke)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)|(TroopL)|(SkyW)"

	For $i = 0 To UBound($aAttackBar, 1) - 1
		If $aAttackBar[$i][1] > 0 Then
			Local $bRemoved = False
			If Not $g_bRunState Then Return
			If $bRemaining And Not $bForceRefresh Then
				$aTroopIsDeployed[0] = $aAttackBar[$i][5] - 15
				$aTroopIsDeployed[1] = $aAttackBar[$i][6]
				If _CheckPixel($aTroopIsDeployed, True) Then
					; Troop got deployed already
					$bRemoved = True
					$aAttackBar[$i][4] = 0 ; set available troops to 0
					If StringRegExp($aAttackBar[$i][0], $sKeepRemainTroops, 0) = 0 Then
						If $bPreserveRemainingSlots Then
							SetDebugLog("GetAttackBar(): Troop " & $aAttackBar[$i][0] & " already deployed, keeping zero quantity")
						Else
							SetDebugLog("GetAttackBar(): Troop " & $aAttackBar[$i][0] & " already deployed, now removed")
							ContinueLoop
						EndIf
					Else
						SetDebugLog("GetAttackBar(): Troop " & $aAttackBar[$i][0] & " already deployed, but stays")
					EndIf
				EndIf
			Else
				Local $aTempSlot = AttackSlot(Number($aAttackBar[$i][1]), Number($aAttackBar[$i][7]), $aSlotAmountX)
				$aAttackBar[$i][5] = Number($aTempSlot[0])
				$aAttackBar[$i][6] = Number($aTempSlot[1])
				$aAttackBar[$i][3] = Number($aTempSlot[2])
				If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Prince)|(Warden)|(Champion)|(Duke)", 0) And $aiOCRY[$aAttackBar[$i][7] - 1] <> -1 Then $aAttackBar[$i][6] = ($aiOCRY[$aAttackBar[$i][7] - 1] - 7)
			EndIf

			If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Prince)|(Warden)|(Champion)|(Duke)|(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)|(TroopL)|(SkyW)", 0) Then
				If Not $bRemoved Then $aAttackBar[$i][4] = 1
				If ($pMatchMode = $DB Or $pMatchMode = $LB) And StringRegExp($aAttackBar[$i][0], "(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)|(TroopL)|(SkyW)", 0) And $g_abAttackDropCC[$pMatchMode] And _
						(GetEffectiveAttackSiege($pMatchMode) = 1 Or GetEffectiveAttackSiege($pMatchMode) >= 3) And GetEffectiveAttackSiege($pMatchMode) <= $eSiegeMachineCount + 2 Then
					Local $iSiegeIdx = TroopIndexLookup($aAttackBar[$i][0], "GetAttackBar") - $eWallW
					If $iSiegeIdx < 0 Or $iSiegeIdx >= $eSiegeMachineCount Then $iSiegeIdx = 0
					$g_iSiegeLevel = Number(getSiegeLevel(Number($aAttackBar[$i][5]) + $g_aiSiegeOcrOffsets[$iSiegeIdx][0], 653 + $g_iBottomOffsetY))
					If $g_iSiegeLevel = "" Then $g_iSiegeLevel = 1
					SetDebugLog($aAttackBar[$i][0] & " level: " & $g_iSiegeLevel)
				EndIf
			Else
				If Not $bRemoved Then
					$aAttackBar[$i][4] = Number(getTroopCountSmall(Number($aAttackBar[$i][5]), Number($aAttackBar[$i][6])))
					If $aAttackBar[$i][4] = 0 Then $aAttackBar[$i][4] = Number(getTroopCountBig(Number($aAttackBar[$i][5]), Number($aAttackBar[$i][6] - 2)))
				EndIf
				If StringRegExp($aAttackBar[$i][0], "(LSpell)|(ESpell)", 0) And $g_bSmartZapEnable Then
					If StringInStr($aAttackBar[$i][0], "LSpell") <> 0 Then
						Local $iSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][1]) - 18, 642 + $g_iBottomOffsetY)) ; use image location as 'x' changes with quantity
						;Local $NewTry = 0
						;While $iSpellLevel = ""
						;	$NewTry += 1
						;	$iSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][1]) - 18, 642 + $g_iBottomOffsetY));Recheck Loop
						;	If _Sleep(100) Then Return
						;	If $NewTry = 15 Then ExitLoop
						;WEnd
						If $iSpellLevel > 0 And $iSpellLevel <= $g_iMaxLSpellLevel Then
							$g_iLSpellLevel = $iSpellLevel
						Else
							$g_iLSpellLevel = 1
						EndIf
					EndIf

					If StringInStr($aAttackBar[$i][0], "ESpell") <> 0 Then
						Local $iSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][1]) - 25, 642 + $g_iBottomOffsetY)) ; use image location as 'x' changes with quantity
						If $iSpellLevel > 0 And $iSpellLevel <= $g_iMaxESpellLevel Then
							$g_iESpellLevel = $iSpellLevel
						Else
							$g_iESpellLevel = 1
						EndIf
					EndIf

				EndIf
			EndIf
			; 0: Index, 1: Slot, 2: Amount, 3: X-Coord, 4: Y-Coord, 5: OCR X-Coord, 6: OCR Y-Coord
			Local $aTempFinalArray[1][7] = [[TroopIndexLookup($aAttackBar[$i][0]), $aAttackBar[$i][3], $aAttackBar[$i][4], $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][5], $aAttackBar[$i][6]]]
			_ArrayAdd($aFinalAttackBar, $aTempFinalArray)
		EndIf
	Next

	DebugAB($aFinalAttackBar, "Initial")

	; Drag left and check Slot11+. A forced Tag Team rebuild must include the
	; extended page because newly inserted event troops shift the final CSV slots.
	If (($pMatchMode <= $LB And $bCheckSlot12 And Not $bDoubleRow And UBound($aAttackBar) > 1 And _
			(GetEffectiveAttackAlgorithm($pMatchMode) <> 2 Or $bForceRefresh)) Or ($bDebug And $bCheckSlot12)) Then
		DragAttackBar()
		Local $aExtendedArray = ExtendedAttackBarCheck($aAttackBar, $bForceRefresh ? False : $bRemaining, $sSearchDiamond, $bPreserveRemainingSlots, $bForceRefresh)
		Local $bExtendedMissing = Not IsArray($aExtendedArray)
		If IsArray($aExtendedArray) Then $bExtendedMissing = UBound($aExtendedArray, 1) = 0
		If $bForceRefresh And $bExtendedMissing Then
			DragAttackBar($g_iTotalAttackSlot, True)
			SetDebugLog("GetAttackBar(): extended Tag Team bar is still animating")
			Return ""
		EndIf

		DebugAB($aExtendedArray, "Extended Return")

		_ArrayAdd($aFinalAttackBar, $aExtendedArray)
		If Not $bRemaining Or $bForceRefresh Then
			Local $iLastAttackSlot = _ArrayMax($aFinalAttackBar, 0, -1, -1, 1)
			$g_iTotalAttackSlot = $iLastAttackSlot > 10 ? $iLastAttackSlot : ($g_bExtendedAttackBar ? 20 : 10)
			DragAttackBar($g_iTotalAttackSlot, True) ; return drag
		EndIf
	EndIf

	_ArraySort($aFinalAttackBar, 0, 0, 0, 1) ; Sort Final Array by Slot Number
	If Not $bRemaining Then ForceClanCastleDetection($aFinalAttackBar)
	If ResolveAttackBarSlotConflicts($aFinalAttackBar) Then _ArraySort($aFinalAttackBar, 0, 0, 0, 1)

	DebugAB($aFinalAttackBar, "Final")

	Return $aFinalAttackBar

EndFunc   ;==>GetAttackBar

Func ResolveAttackBarSlotConflicts(ByRef $aAttackBar)
	If Not IsArray($aAttackBar) Or UBound($aAttackBar, 1) < 2 Then Return False

	Local $aResolved[0][7]
	Local $bConflictFound = False

	For $i = 0 To UBound($aAttackBar, 1) - 1
		Local $iExisting = -1
		For $j = 0 To UBound($aResolved, 1) - 1
			If Number($aResolved[$j][1]) = Number($aAttackBar[$i][1]) Then
				$iExisting = $j
				ExitLoop
			EndIf
		Next

		If $iExisting = -1 Then
			Local $aNewRow[1][7] = [[$aAttackBar[$i][0], $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][3], $aAttackBar[$i][4], $aAttackBar[$i][5], $aAttackBar[$i][6]]]
			_ArrayAdd($aResolved, $aNewRow)
			ContinueLoop
		EndIf

		$bConflictFound = True
		Local $bReplace = IsAttackBarCandidateBetter($aResolved, $iExisting, $aAttackBar, $i)
		Local $sKeptName = GetTroopName($bReplace ? $aAttackBar[$i][0] : $aResolved[$iExisting][0])
		Local $sDiscardedName = GetTroopName($bReplace ? $aResolved[$iExisting][0] : $aAttackBar[$i][0])
		SetDebugLog("AttackBar slot conflict on Slot(" & $aAttackBar[$i][1] & "): keeping " & $sKeptName & ", discarding " & $sDiscardedName, $COLOR_ERROR)

		If $bReplace Then
			For $iColumn = 0 To 6
				$aResolved[$iExisting][$iColumn] = $aAttackBar[$i][$iColumn]
			Next
		EndIf
	Next

	If $bConflictFound Then $aAttackBar = $aResolved
	Return $bConflictFound
EndFunc   ;==>ResolveAttackBarSlotConflicts

Func IsAttackBarCandidateBetter(ByRef $aCurrent, $iCurrent, ByRef $aCandidate, $iCandidate)
	Local $iCurrentAmount = Number($aCurrent[$iCurrent][2])
	Local $iCandidateAmount = Number($aCandidate[$iCandidate][2])
	If ($iCandidateAmount > 0) <> ($iCurrentAmount > 0) Then Return $iCandidateAmount > 0

	Local $iCurrentDistance = Abs(Number($aCurrent[$iCurrent][3]) - Number($aCurrent[$iCurrent][5]))
	Local $iCandidateDistance = Abs(Number($aCandidate[$iCandidate][3]) - Number($aCandidate[$iCandidate][5]))
	Return $iCandidateDistance < $iCurrentDistance
EndFunc   ;==>IsAttackBarCandidateBetter

Func ForceClanCastleDetection(ByRef $aFinalAttackBar)
	If Not $g_bForceClanCastleDetection Then Return
	If UBound($aFinalAttackBar, 1) < 2 Then Return

	Local $iMaxSlot = -1
	Local $iMissingSlot = -1
	Local $bHasClanCastleSlot = False

	For $i = 0 To UBound($aFinalAttackBar, 1) - 1
		Switch $aFinalAttackBar[$i][0]
			Case $eCastle, $eWallW, $eBattleB, $eStoneS, $eSiegeB, $eLogL, $eFlameF, $eBattleD, $eTroopL, $eSkyW
				$bHasClanCastleSlot = True
				ExitLoop
		EndSwitch
		If $aFinalAttackBar[$i][1] > $iMaxSlot Then $iMaxSlot = $aFinalAttackBar[$i][1]
	Next

	If $bHasClanCastleSlot Or $iMaxSlot < 1 Then Return

	For $iSlot = 0 To $iMaxSlot - 1
		Local $bSlotFound = False
		For $i = 0 To UBound($aFinalAttackBar, 1) - 1
			If $aFinalAttackBar[$i][1] = $iSlot Then
				$bSlotFound = True
				ExitLoop
			EndIf
		Next
		If Not $bSlotFound Then
			$iMissingSlot = $iSlot
			ExitLoop
		EndIf
	Next

	If $iMissingSlot = -1 Then Return

	Local $iPrevRow = -1, $iNextRow = -1
	For $i = 0 To UBound($aFinalAttackBar, 1) - 1
		If $aFinalAttackBar[$i][1] < $iMissingSlot Then $iPrevRow = $i
		If $aFinalAttackBar[$i][1] > $iMissingSlot Then
			$iNextRow = $i
			ExitLoop
		EndIf
	Next

	If $iPrevRow = -1 Or $iNextRow = -1 Then Return

	Local $iX = Int(($aFinalAttackBar[$iPrevRow][3] + $aFinalAttackBar[$iNextRow][3]) / 2)
	Local $iY = Int(($aFinalAttackBar[$iPrevRow][4] + $aFinalAttackBar[$iNextRow][4]) / 2)
	Local $iOCRX = Int(($aFinalAttackBar[$iPrevRow][5] + $aFinalAttackBar[$iNextRow][5]) / 2)
	Local $iOCRY = Int(($aFinalAttackBar[$iPrevRow][6] + $aFinalAttackBar[$iNextRow][6]) / 2)

	Local $aClanCastleSlot[1][7] = [[$eCastle, $iMissingSlot, 1, $iX, $iY, $iOCRX, $iOCRY]]
	_ArrayAdd($aFinalAttackBar, $aClanCastleSlot)
	_ArraySort($aFinalAttackBar, 0, 0, 0, 1)
	SetDebugLog("Force Clan Castle Detection: forced missing slot " & $iMissingSlot & " as Clan Castle", $COLOR_DEBUG)
EndFunc   ;==>ForceClanCastleDetection

Func ExtendedAttackBarCheck($aAttackBarFirstSearch, $bRemaining, $sSearchDiamond, $bPreserveRemainingSlots = False, $bSilent = False)
	;DebugAB($aAttackBarFirstSearch, "ExtendedAttackBarCheck")

	Local Static $aAttackBar[0][8]
	Local $iLastSlotNumber = _ArrayMax($aAttackBarFirstSearch, 0, -1, -1, 3)
	Local $sLastTroopName = $aAttackBarFirstSearch[_ArrayMaxIndex($aAttackBarFirstSearch, 0, -1, -1, 1)][0], $aiOCRLocation[2] = [-1, -1]
	Local $aSlotAmountX[0][3]

	;Reset All Static Variables if the AttackBarCheck is not for Remaining
	If Not $bRemaining Then
		Local $aDummyArray[0][8]
		$aAttackBar = $aDummyArray
		$g_iTotalAttackSlot = 10
	EndIf

	If Not $g_bRunState Then Return

	If UBound($aAttackBar) = 0 Or Not $bRemaining Then
		Local $iAttackbarStart = __TimerInit()
		Local $aTempArray, $aTempCoords, $aTempMultiCoords, $iRow = 1

		Local $aAttackBarResult = findMultiple($g_sImgAttackBarDir, $sSearchDiamond, $sSearchDiamond, 0, 1000, 0, "objectname,objectpoints", True)

		If UBound($aAttackBarResult) = 0 Then
			If $bSilent Then
				SetDebugLog("AttackBarCheck(): extended search returned no results")
			Else
				SetLog("Error in AttackBarCheck(): Search did not return any results!", $COLOR_ERROR)
			EndIf
			If Not $bSilent Then SaveDebugImage("ErrorAttackBarCheck", False, Default, "#2")
			Return ""
		EndIf

		;Add found Stuff into our Arrays
		For $i = 0 To UBound($aAttackBarResult, 1) - 1
			$aTempArray = $aAttackBarResult[$i]
			$aTempMultiCoords = decodeMultipleCoords($aTempArray[1], 40, 40, -1)
			For $j = 0 To UBound($aTempMultiCoords, 1) - 1
				$aTempCoords = $aTempMultiCoords[$j]
				If UBound($aTempCoords) < 2 Then ContinueLoop
				If StringRegExp($aTempArray[0], "(AmountX)", 0) Then
					_ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					$aiOCRLocation[$iRow - 1] = $aTempCoords[1]
				Else
					If StringRegExp($aTempArray[0], "(King)|(Queen)|(Prince)|(Warden)|(Champion)|(Duke)|(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)|(TroopL)|(SkyW)", 0) Then _ArrayAdd($aSlotAmountX, $aTempCoords[0] & "|" & $aTempCoords[1] & "|" & $iRow, 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
					Local $aTempElement[1][8] = [[$aTempArray[0], $aTempCoords[0], $aTempCoords[1], -1, -1, -1, -1, $iRow]]
					_ArrayAdd($aAttackBar, $aTempElement)
				EndIf
			Next
		Next

		If UBound($aAttackBar, 1) = 0 Then
			If $bSilent Then
				SetDebugLog("AttackBarCheck(): extended bar has no results")
			Else
				SetLog("Error in AttackBarCheck(): $aAttackBar has no results in it", $COLOR_ERROR)
			EndIf
			Return ""
		EndIf

		;Sort the Arrays by X Position of the Results
		_ArraySort($aAttackBar, 0, 0, 0, 1)
		_ArraySort($aSlotAmountX)

		SetDebugLog("AttackBarCheck(): Finished Image Search in: " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")
		$iAttackbarStart = __TimerInit()
	EndIf

	#comments-start
		$aAttackBar[n][8]
		[n][0] = Name of the found Troop/Spell/Hero/Siege
		[n][1] = The X Coordinate of the Troop/Spell/Hero/Siege
		[n][2] = The Y Coordinate of the Troop/Spell/Hero/Siege
		[n][3] = The Slot Number (Starts with 0)
		[n][4] = The Amount
		[n][5] = The X Coordinate of the x beside the Amount
		[n][6] = The Y Coordinate of the x beside the Amount
		[n][7] = The Row where it is in
	#comments-end

	Local $aFinalAttackBar[0][7]
	Local $aiOCRY = [-1, -1]
	Local $sKeepRemainTroops = "(King)|(Queen)|(Prince)|(Warden)|(Champion)|(Duke)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)|(TroopL)|(SkyW)"

	If Not $bRemaining Then
		$aiOCRY = GetOCRYLocation($aSlotAmountX)
		; locate the last troop from the first AB on the extended AB

		Local $iSlot = _ArrayUnique($aAttackBarFirstSearch)

		;_ArrayDisplay($iSlot)

		;SetLog("number of unique troops: " & $iSlot[0])

		Local $iLastTroopMatch = -1
		If $iSlot[0] < 11 Then
			$iLastTroopMatch = _ArraySearch($aAttackBar, $sLastTroopName, 0, 0, 0, 0, 0, 0) ; works with 3 troops 4 heroes 2 spells (1 is rage) cc rage and 1 more
		Else
			$iLastTroopMatch = _ArraySearch($aAttackBar, $sLastTroopName, 0, 0, 0, 0, 1, 0)
		EndIf

		Local $iLastTroopIndex = $iLastTroopMatch + 1
		$aAttackBar = _ArrayExtract($aAttackBar, $iLastTroopIndex)
		$aSlotAmountX = _ArrayExtract($aSlotAmountX, $iLastTroopIndex)

	EndIf

	For $i = 0 To UBound($aAttackBar, 1) - 1
		If $aAttackBar[$i][1] > 0 Then
			Local $bRemoved = False
			If Not $g_bRunState Then Return
			If $bRemaining Then
				$aTroopIsDeployed[0] = $aAttackBar[$i][5] - 15
				$aTroopIsDeployed[1] = $aAttackBar[$i][6]
				If _CheckPixel($aTroopIsDeployed, True) Then
					; Troop got deployed already
					$bRemoved = True
					$aAttackBar[$i][4] = 0 ; set available troops to 0
					If StringRegExp($aAttackBar[$i][0], $sKeepRemainTroops, 0) = 0 Then
						If $bPreserveRemainingSlots Then
							SetDebugLog("AttackBarCheck(): Troop " & $aAttackBar[$i][0] & " already deployed, keeping zero quantity")
						Else
							SetDebugLog("AttackBarCheck(): Troop " & $aAttackBar[$i][0] & " already deployed, now removed")
							ContinueLoop
						EndIf
					Else
						SetDebugLog("AttackBarCheck(): Troop " & $aAttackBar[$i][0] & " already deployed, but stays")
					EndIf
				EndIf
			Else
				Local $aTempSlot = AttackSlot(Number($aAttackBar[$i][1]), Number($aAttackBar[$i][7]), $aSlotAmountX)
				$aAttackBar[$i][5] = Number($aTempSlot[0])
				$aAttackBar[$i][6] = Number($aTempSlot[1])
				If UBound($aAttackBar, 1) > 1 Then
					$aAttackBar[$i][3] = Number($aTempSlot[2] + $iLastSlotNumber + 1)
				Else
					$aAttackBar[$i][3] = Number($iLastSlotNumber + 1)
				EndIf
				If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Prince)|(Warden)|(Champion)|(Duke)", 0) And $aiOCRY[$aAttackBar[$i][7] - 1] <> -1 Then $aAttackBar[$i][6] = ($aiOCRY[$aAttackBar[$i][7] - 1] - 7)
			EndIf

			If StringRegExp($aAttackBar[$i][0], "(King)|(Queen)|(Prince)|(Warden)|(Champion)|(Duke)|(Castle)|(WallW)|(BattleB)|(StoneS)|(SiegeB)|(LogL)|(FlameF)|(BattleD)|(TroopL)|(SkyW)", 0) Then
				If Not $bRemoved Then $aAttackBar[$i][4] = 1
			Else
				If Not $bRemoved Then
					$aAttackBar[$i][4] = Number(getTroopCountSmall(Number($aAttackBar[$i][5]), Number($aAttackBar[$i][6])))
					If $aAttackBar[$i][4] = 0 Then $aAttackBar[$i][4] = Number(getTroopCountBig(Number($aAttackBar[$i][5]), Number($aAttackBar[$i][6] - 2)))
				EndIf
				If StringRegExp($aAttackBar[$i][0], "(LSpell)|(ESpell)", 0) And $g_bSmartZapEnable Then
					If StringInStr($aAttackBar[$i][0], "LSpell") <> 0 Then
						Local $iSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][1]) - 18, 642 + $g_iBottomOffsetY)) ; use image location as 'x' changes with quantity
						If $iSpellLevel > 0 And $iSpellLevel <= $g_iMaxLSpellLevel Then
							$g_iLSpellLevel = $iSpellLevel
						Else
							$g_iLSpellLevel = 1
						EndIf
					EndIf

					If StringInStr($aAttackBar[$i][0], "ESpell") <> 0 Then
						Local $iSpellLevel = Number(getTroopsSpellsLevel(Number($aAttackBar[$i][1]) - 25, 642 + $g_iBottomOffsetY)) ; use image location as 'x' changes with quantity
						If $iSpellLevel > 0 And $iSpellLevel <= $g_iMaxESpellLevel Then
							$g_iESpellLevel = $iSpellLevel
						Else
							$g_iESpellLevel = 1
						EndIf
					EndIf

				EndIf
			EndIf
			; 0: Index, 1: Slot, 2: Amount, 3: X-Coord, 4: Y-Coord, 5: OCR X-Coord, 6: OCR Y-Coord
			Local $aTempFinalArray[1][7] = [[TroopIndexLookup($aAttackBar[$i][0]), $aAttackBar[$i][3], $aAttackBar[$i][4], $aAttackBar[$i][1], $aAttackBar[$i][2], $aAttackBar[$i][5], $aAttackBar[$i][6]]]
			_ArrayAdd($aFinalAttackBar, $aTempFinalArray)
		EndIf
	Next

	_ArraySort($aFinalAttackBar, 0, 0, 0, 1) ; Sort Final Array by Slot Number

	Return $aFinalAttackBar
EndFunc   ;==>ExtendedAttackBarCheck

Func GetOCRYLocation($aArray)
	Local $aiReturn[2] = [-1, -1], $aTempArray[0], $aTempArray2[0]
	For $i = 0 To UBound($aArray, 1) - 1
		If $aArray[$i][2] = 1 Then
			_ArrayAdd($aTempArray, $aArray[$i][1])
		Else
			_ArrayAdd($aTempArray2, $aArray[$i][1])
		EndIf
	Next
	$aiReturn[0] = _ArrayMin($aTempArray)
	$aiReturn[1] = _ArrayMin($aTempArray2)

	Return $aiReturn
EndFunc   ;==>GetOCRYLocation

Func SearchNearest($aArray, $iNumber, $iRow)
	Local $iVal, $iValOld = _ArrayMax($aArray), $iReturn
	For $i = 0 To UBound($aArray) - 1
		$iVal = Abs($aArray[$i][0] - $iNumber)
		If $iValOld >= $iVal And $iRow = Number($aArray[$i][2]) Then
			$iValOld = $iVal
			$iReturn = $i
		EndIf
	Next
	Return $iReturn
EndFunc   ;==>SearchNearest

Func SortDoubleRowXElements($aArray)
	Local $aSecondRow[0][3]
	Local $aNewSlotAmountX[0][3]
	For $i = 0 To UBound($aArray) - 1
		If $aArray[$i][2] = 2 Then
			_ArrayAdd($aSecondRow, _ArrayExtract($aArray, $i, $i))
		Else
			_ArrayAdd($aNewSlotAmountX, _ArrayExtract($aArray, $i, $i))
		EndIf
	Next
	_ArraySort($aNewSlotAmountX)
	_ArraySort($aSecondRow)
	_ArrayAdd($aNewSlotAmountX, $aSecondRow)

	Return $aNewSlotAmountX
EndFunc   ;==>SortDoubleRowXElements

Func DragAttackBar($iTotalSlot = 20, $bBack = False)
	If $g_iTotalAttackSlot > $iTotalSlot Then $iTotalSlot = $g_iTotalAttackSlot
	Local $iSlot0X = 25
	Local $iDragSlots = _Max(11, $iTotalSlot - 9)
	Local $iLastSlotX = _Min($g_iGAME_WIDTH - 30, $iSlot0X + 73 * $iDragSlots)
	Local $bAlreadyDrag = False

	If Not $bBack Then
		SetDebugLog("Dragging attack troop bar to final page in one pull. Distance = " & $iDragSlots & " slots")
		ClickDrag($iLastSlotX, 600 + $g_iBottomOffsetY, $iSlot0X, 600 + $g_iBottomOffsetY, 350, False, True)
		If _Sleep(400) Then Return
		$bAlreadyDrag = True
	Else
		SetDebugLog("Dragging attack troop bar from Slot 0 back to troop page in one pull. Distance = " & $iDragSlots & " slots")
		ClickDrag($iSlot0X, 600 + $g_iBottomOffsetY, $iLastSlotX, 600 + $g_iBottomOffsetY, 350, False, True)
		If _Sleep(300) Then Return
		$bAlreadyDrag = False
	EndIf

	$g_bDraggedAttackBar = $bAlreadyDrag
	$g_iCSVLastTroopPositionDropTroopFromINI = -1 ; after drag attack bar, need to clear last troop selected
	Return $bAlreadyDrag
EndFunc   ;==>DragAttackBar

Func AttackSlot($iPosX, $iRow, $aSlots)
	Local $aTempSlot[3] = [0, 0, 0]
	Local $iClosest = SearchNearest($aSlots, $iPosX, $iRow)
	Local $bLast = False
	If $iClosest = _ArrayMaxIndex($aSlots, 0) And $aSlots[$iClosest][0] >= ($g_iGAME_WIDTH - 60) Then $bLast = True

	If $iClosest >= 0 And $iClosest < UBound($aSlots) Then
		$aTempSlot[0] = $bLast ? $g_iGAME_WIDTH - 53 : $aSlots[$iClosest][0] - 15 ; X Coord | Last Item to get OCRd needs to be compensated because it could happen that the Capture Rectangle gets out of boundary and image gets not usable
		$aTempSlot[1] = $aSlots[$iClosest][1] - 7 ; Y Coord
		$aTempSlot[2] = $iClosest
	EndIf

	Return $aTempSlot
EndFunc   ;==>AttackSlot

Func DebugAttackBarImage($aAttackBarResult)
	#comments-start
		SetDebugLog("Attackbar OCR completed in " & StringFormat("%.2f", __TimerDiff($iAttackbarStart)) & " ms")
	
		If $bDebug Then
		Local $iX1 = 0, $iY1 = 635, $iX2 = 853, $iY2 = 698
		_CaptureRegion2($iX1, $iY1, $iX2, $iY2)
	
		Local $sSubDir = $g_sProfileTempDebugPath & "AttackBarDetection"
	
		DirCreate($sSubDir)
	
		Local $sDate = @YEAR & "-" & @MON & "-" & @MDAY, $sTime = @HOUR & "." & @MIN & "." & @SEC
		Local $sDebugImageName = String($sDate & "_" & $sTime & "_.png")
		Local $hEditedImage = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hEditedImage)
		Local $hPenRED = _GDIPlus_PenCreate(0xFFFF0000, 3)
	
		For $i = 0 To UBound($aResult) - 1
		addInfoToDebugImage($hGraphic, $hPenRED, $aResult[$i][0], $aResult[$i][1], $aResult[$i][2])
		Next
	
		_GDIPlus_ImageSaveToFile($hEditedImage, $sSubDir & "\" & $sDebugImageName)
		_GDIPlus_PenDispose($hPenRED)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($hEditedImage)
		EndIf
	#comments-end
EndFunc   ;==>DebugAttackBarImage

Func DebugAB($aAttackBar, $sText = "")
	For $i = 0 To UBound($aAttackBar, 1) - 1
		If IsInt($aAttackBar[$i][0]) Then
			SetDebugLog("AttackBarCheck(): Slot(" & $aAttackBar[$i][1] & ")-" & $sText & " Troop(index) " & GetTroopName($aAttackBar[$i][0]) & " Qty : " & $aAttackBar[$i][2])
		Else
			SetDebugLog("AttackBarCheck(): Slot(" & $aAttackBar[$i][1] & ")-" & $sText & " Troop " & $aAttackBar[$i][0] & " Qty : " & $aAttackBar[$i][2])
		EndIf
	Next
EndFunc   ;==>DebugAB
