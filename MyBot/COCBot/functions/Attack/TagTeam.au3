; #FUNCTION# ===========================================================================================================
; Name ..........: Tag Team
; Author ........: Phael
; Description ...: Detects the Tag Team reward popup and applies the configured reward strategy.
; Remarks .......: Resource mode uses reward #3 on Tags 1/2. Event Troops mode uses rewards #1/2 and deploys them after Tag 2.
; ======================================================================================================================

; === GLOBAL STATE ===
Global $g_bTagTeamEnabled = True
Global $g_iTagTeamPauseTime = 0
Global $g_bTagTeamFinalPopupVisible = False
Global $g_iTagTeamMidTagCount = 0
Global $g_hTagTeamAttackTimer = 0
Global $g_bTagTeamRemainingDeployActive = False
Global $g_bTagTeamRemainingDeployAbort = False
Global $g_iTagTeamEventReservedSlots = 0

Global Const $g_aiTagTeamRewardX[3] = [200, 430, 665]
Global Const $g_iTagTeamRewardY = 370 + $g_iMidOffsetY
Global Const $g_iTagTeamCheckInterval = 1000
Global Const $g_iTagTeamDeployCheckInterval = 250

; === STATE HELPERS ===
Func IsTagTeamActive()
	Return $g_bTagTeamEnabled And $g_iTagTeamMode <> $eTagTeamOff
EndFunc   ;==>IsTagTeamActive

Func GetTagTeamPauseTime()
	Return $g_iTagTeamPauseTime
EndFunc   ;==>GetTagTeamPauseTime

; === POPUP DETECTION ===
Func IsTagTeamRewardPopupVisible()
	If Not IsTagTeamActive() Or Not $g_bRunState Then Return False
	$g_bTagTeamFinalPopupVisible = False

	_CaptureRegion()

	; === FINAL POPUP DETECTION ===
	; Check first because its red banner can also match
	; the mid-attack detector and incorrectly force reward #3.
	Local $iFinalMatches = 0
	If $g_sAndroidEmulator = "BlueStacks5" Then
		If _ColorCheck(_GetPixelColor(280, 224), Hex(0x9A2B2B, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(300, 224), Hex(0x9A2B2B, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(320, 224), Hex(0x9A2B2B, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(540, 224), Hex(0x9A2B2B, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(560, 224), Hex(0x9A2B2B, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(580, 224), Hex(0x9A2B2B, 6), 15) Then $iFinalMatches += 1
	Else
		If _ColorCheck(_GetPixelColor(270, 182 + $g_iMidOffsetY), Hex(0xEA3F3F, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(270, 200 + $g_iMidOffsetY), Hex(0x892525, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(590, 200 + $g_iMidOffsetY), Hex(0x711E1E, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(295, 210 + $g_iMidOffsetY), Hex(0x822424, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(337, 210 + $g_iMidOffsetY), Hex(0x922A27, 6), 15) Then $iFinalMatches += 1
		If _ColorCheck(_GetPixelColor(570, 210 + $g_iMidOffsetY), Hex(0x822424, 6), 15) Then $iFinalMatches += 1
	EndIf
	If $iFinalMatches >= 5 Then
		$g_bTagTeamFinalPopupVisible = True
		Return True
	EndIf

	; === MID-ATTACK POPUP DETECTION ===
	Local $iMidAttackMatches = 0
	If $g_sAndroidEmulator = "BlueStacks5" Then
		If _ColorCheck(_GetPixelColor(250, 148), Hex(0x992A2A, 6), 15) Then $iMidAttackMatches += 1
		If _ColorCheck(_GetPixelColor(300, 148), Hex(0x992A2A, 6), 15) Then $iMidAttackMatches += 1
		If _ColorCheck(_GetPixelColor(325, 148), Hex(0x992A2A, 6), 15) Then $iMidAttackMatches += 1
		If _ColorCheck(_GetPixelColor(560, 148), Hex(0x992A2A, 6), 15) Then $iMidAttackMatches += 1
		If _ColorCheck(_GetPixelColor(610, 148), Hex(0x992A2A, 6), 15) Then $iMidAttackMatches += 1
	Else
		If _ColorCheck(_GetPixelColor(220, 102 + $g_iMidOffsetY), Hex(0xAE3030, 6), 15) Then $iMidAttackMatches += 1
		If _ColorCheck(_GetPixelColor(220, 120 + $g_iMidOffsetY), Hex(0x9A2929, 6), 15) Then $iMidAttackMatches += 1
		If _ColorCheck(_GetPixelColor(640, 102 + $g_iMidOffsetY), Hex(0x942727, 6), 15) Then $iMidAttackMatches += 1
		If _ColorCheck(_GetPixelColor(640, 139 + $g_iMidOffsetY), Hex(0x521515, 6), 15) Then $iMidAttackMatches += 1
		If _ColorCheck(_GetPixelColor(430, 147 + $g_iMidOffsetY), Hex(0xFF9900, 6), 15) Then $iMidAttackMatches += 1
	EndIf
	If $iMidAttackMatches >= 4 Then Return True

	Return False
EndFunc   ;==>IsTagTeamRewardPopupVisible

; === REWARD HANDLING ===
Func CheckTagTeam($bForceCheck = False, $bSetLog = True, $iCheckInterval = $g_iTagTeamCheckInterval)
	Static $bHandling = False
	Static $hLastCheck = 0

	; === VALIDATION ===
	If $bHandling Or Not IsTagTeamActive() Or Not $g_bRunState Or $g_bBotPaused Then Return False
	If Not $bForceCheck And $hLastCheck <> 0 And __TimerDiff($hLastCheck) < $iCheckInterval Then Return False

	If Not IsTagTeamRewardPopupVisible() Then
		; Start the interval after the synchronous capture. Starting it before the
		; capture makes slow ADB screenshots expire the interval immediately.
		$hLastCheck = __TimerInit()
		Return False
	EndIf
	Local $bInterruptedRemainingDeploy = $g_bTagTeamRemainingDeployActive
	If $bInterruptedRemainingDeploy Then
		$g_bTagTeamRemainingDeployAbort = True
		$g_bTagTeamRemainingDeployActive = False
		SetDebugLog("Tag Team: interrupting remaining troop deploy for reward selection")
	EndIf

	; === REWARD SELECTION ===
	$bHandling = True
	ClearClicks() ; discard attack clicks queued before the modal popup
	Local $hPauseTimer = __TimerInit()

	If $g_hTagTeamAttackTimer <> $g_hAttackTimer Then
		$g_hTagTeamAttackTimer = $g_hAttackTimer
		$g_iTagTeamMidTagCount = 0
		ResetTagTeamEventSlots()
	EndIf

	; Resource mode: Tags 1/2 select reward #3.
	; Event Troops mode: Tags 1/2 randomly select reward #1 or #2.
	; Tag 3 always selects one of the three resource rewards at random.
	Local $bFinalTag = $g_bTagTeamFinalPopupVisible
	Local $iGoldenReward = -1
	If Not $bFinalTag And $g_iTagTeamMode = $eTagTeamEventTroops Then $iGoldenReward = GetTagTeamGoldenReward()
	Local $iReward = $bFinalTag ? Random(0, 2, 1) : ($g_iTagTeamMode = $eTagTeamEventTroops ? ($iGoldenReward >= 0 ? $iGoldenReward : Random(0, 1, 1)) : 2)
	Local $bRewardSelected = False
	For $iAttempt = 1 To 4
		; If the first reward does not respond, try another valid reward in the
		; same handling cycle instead of logging a transient selection failure.
		If $iAttempt = 3 Then
			If $bFinalTag Then
				$iReward = Mod($iReward + Random(1, 2, 1), 3)
			ElseIf $g_iTagTeamMode = $eTagTeamEventTroops Then
				$iReward = 1 - $iReward
			EndIf
		EndIf
		PureClick(Random($g_aiTagTeamRewardX[$iReward] - 12, $g_aiTagTeamRewardX[$iReward] + 12, 1), _
				Random($g_iTagTeamRewardY - 15, $g_iTagTeamRewardY + 15, 1), 1, 120, "Tag Team Reward")

		Local $hCloseTimer = __TimerInit()
		While __TimerDiff($hCloseTimer) < 1600
			_SleepMilli(250)
			If Not $g_bRunState Then ExitLoop
			Local $bPopupVisible = IsTagTeamRewardPopupVisible()
			; The result screen can still match the mid-attack detector after the final
			; reward closes. For Tag 3, closing the final popup confirms the selection.
			If Not $bPopupVisible Or ($bFinalTag And Not $g_bTagTeamFinalPopupVisible) Then
				$bRewardSelected = True
				ExitLoop
			EndIf
		WEnd
		If $bRewardSelected Or Not $g_bRunState Then ExitLoop
	Next
	If Not $g_bRunState Then
		$g_iTagTeamPauseTime += __TimerDiff($hPauseTimer)
		$bHandling = False
		$hLastCheck = __TimerInit()
		Return False
	EndIf

	If $bRewardSelected Then
		$g_iTagTeamPauseTime += __TimerDiff($hPauseTimer)
		If Not $bFinalTag Then $g_iTagTeamMidTagCount += 1
		If $bSetLog Then
			If $bFinalTag Then
				SetLog("Tag Team 3: Reward #" & ($iReward + 1) & " Selected (Random)", $COLOR_ACTION)
			ElseIf $g_iTagTeamMode = $eTagTeamEventTroops Then
				Local $sRewardType = $iGoldenReward = $iReward ? "Golden Event Troops" : "Event Troops"
				SetLog("Tag Team " & $g_iTagTeamMidTagCount & ": Reward #" & ($iReward + 1) & " Selected (" & $sRewardType & ")", $COLOR_ACTION)
			Else
				SetLog("Tag Team " & $g_iTagTeamMidTagCount & ": Reward #3 Selected (Resources)", $COLOR_ACTION)
			EndIf
		EndIf

		; === EVENT TROOP HANDLING ===
		Local $bEventBarRefreshed = False
		If Not $bFinalTag And $g_iTagTeamMode = $eTagTeamEventTroops Then
			If $g_iTagTeamMidTagCount = 1 Then
				; Tag 1 rebuilds immediately to reorganize the common troop slots.
				$bEventBarRefreshed = RefreshTagTeamAttackBar(0)
				If $bEventBarRefreshed Then ReserveTagTeamEventSlots()
			ElseIf $g_iTagTeamMidTagCount = 2 Then
				; Tag 2 waits for the reward animation and rebuilds the complete bar.
				$bEventBarRefreshed = RefreshTagTeamAttackBar()
				If $bEventBarRefreshed Then
					ReserveTagTeamEventSlots()
					If Not $bInterruptedRemainingDeploy Then DeployTagTeamRemainingTroops(True)
				EndIf
			EndIf
			$g_iCSVLastTroopPositionDropTroopFromINI = -1
		EndIf
		$bHandling = False
		$hLastCheck = __TimerInit()
		Return True
	EndIf

	$g_iTagTeamPauseTime += __TimerDiff($hPauseTimer)
	If $bSetLog Then SetLog("Tag Team: Unable to select reward #" & ($iReward + 1), $COLOR_ERROR)
	$bHandling = False
	$hLastCheck = __TimerInit()
	Return False
EndFunc   ;==>CheckTagTeam

; #FUNCTION# ===========================================================================================================
; Name ..........: GetTagTeamGoldenReward
; Description ...: Detects the golden frame on either event-troop reward card.
; Remarks .......: Requires matches across at least three vertical frame bands and returns -1 when uncertain.
; ======================================================================================================================

Func GetTagTeamGoldenReward()
	Local $iYOffset = $g_sAndroidEmulator = "BlueStacks5" ? 0 : $g_iMidOffsetY
	Local $aiLeftFrameX[2] = [105, 335]
	Local $aiRightFrameX[2] = [295, 525]
	Local $aiBandY[4] = [260, 330, 400, 480]
	Local $aiGoldenScore[2] = [0, 0]

	For $iReward = 0 To 1
		For $iBand = 0 To UBound($aiBandY) - 1
			Local $iY = $aiBandY[$iBand] + $iYOffset
			Local $bLeftGold = HasTagTeamGoldenFramePixels($aiLeftFrameX[$iReward] - 3, $iY - 8, $aiLeftFrameX[$iReward] + 10, $iY + 8)
			Local $bRightGold = HasTagTeamGoldenFramePixels($aiRightFrameX[$iReward] - 10, $iY - 8, $aiRightFrameX[$iReward] + 3, $iY + 8)
			If $bLeftGold Or $bRightGold Then $aiGoldenScore[$iReward] += 1
		Next
	Next
	SetDebugLog("Tag Team: golden frame scores #1=" & $aiGoldenScore[0] & ", #2=" & $aiGoldenScore[1])
	If $aiGoldenScore[0] >= 3 And $aiGoldenScore[0] > $aiGoldenScore[1] Then Return 0
	If $aiGoldenScore[1] >= 3 And $aiGoldenScore[1] > $aiGoldenScore[0] Then Return 1

	SetDebugLog("Tag Team: golden reward not confirmed; using configured fallback")
	Return -1
EndFunc   ;==>GetTagTeamGoldenReward

Func HasTagTeamGoldenFramePixels($iLeft, $iTop, $iRight, $iBottom)
	Local $iGoldenPixels = 0
	For $iX = $iLeft To $iRight Step 2
		For $iY = $iTop To $iBottom Step 2
			Local $iColor = Dec(_GetPixelColor($iX, $iY))
			Local $iRed = BitAND(BitShift($iColor, 16), 0xFF)
			Local $iGreen = BitAND(BitShift($iColor, 8), 0xFF)
			Local $iBlue = BitAND($iColor, 0xFF)
			If $iRed >= 165 And $iGreen >= 105 And $iBlue <= 165 And $iRed >= $iGreen + 15 And $iGreen >= $iBlue + 15 Then
				$iGoldenPixels += 1
				If $iGoldenPixels >= 3 Then Return True
			EndIf
		Next
	Next
	Return False
EndFunc   ;==>HasTagTeamGoldenFramePixels

; === EVENT DEPLOYMENT FLOW ===
Func DeployTagTeamRemainingTroops($bAttackBarReady = False)
	; === ATTACK BAR PREPARATION ===
	If Not $bAttackBarReady Then
		If Not RefreshTagTeamAttackBar() Then Return False
		ReserveTagTeamEventSlots()
	EndIf
	If $g_iTagTeamEventReservedSlots < 1 Then Return False
	If IsReturnHomeBattlePage(True, False) Then Return False

	; === EVENT SLOT READING ===
	; Preserve the full-bar quantity when a selected-slot read fails.
	Local $aiEventTroopAmount[2] = [0, 0]
	Local $aiEventTroopType[2] = [-1, -1], $abEventTypeInArmy[2] = [False, False]
	For $iEventSlot = 0 To $g_iTagTeamEventReservedSlots - 1
		If $iEventSlot > 1 Then ExitLoop
		Local $iEventTroopIndex = $g_avAttackTroops[$iEventSlot][0]
		If $iEventTroopIndex < $eBarb Or $iEventTroopIndex > $eGDrag Then ContinueLoop
		$aiEventTroopType[$iEventSlot] = $iEventTroopIndex
		For $iArmySlot = $g_iTagTeamEventReservedSlots To UBound($g_avAttackTroops, 1) - 1
			If $g_avAttackTroops[$iArmySlot][0] = $iEventTroopIndex And $g_avAttackTroops[$iArmySlot][1] > 0 Then
				$abEventTypeInArmy[$iEventSlot] = True
				ExitLoop
			EndIf
		Next
		Local $iFallbackAmount = $g_avAttackTroops[$iEventSlot][1]
		SelectDropTroop($iEventSlot)
		If _Sleep(300) Then Return False
		Local $iReadAmount = ReadTroopQuantity($iEventSlot, True)
		$aiEventTroopAmount[$iEventSlot] = $iReadAmount > 0 ? $iReadAmount : $iFallbackAmount
	Next

	; === TROOP DEPLOYMENT ===
	SetLog("Dropping Tag Team Remaining Troops", $COLOR_ACTION)
	Local $iSides = $g_iSidesAttack
	If $iSides < 1 Or $iSides > 4 Then $iSides = 1
	Local $iOppositeEdge = GetTagTeamOppositeEdge()
	Local $avOppositeEdge = 0
	If $iOppositeEdge >= 0 Then
		If $iOppositeEdge >= UBound($g_aaiEdgeDropPoints) Then
			SetDebugLog("Tag Team: Invalid opposite edge index: " & $iOppositeEdge)
			ResetTagTeamEventSlots()
			Return False
		EndIf
		$avOppositeEdge = $g_aaiEdgeDropPoints[$iOppositeEdge]
		If Not IsArray($avOppositeEdge) Then
			SetDebugLog("Tag Team: Invalid opposite edge data: " & $iOppositeEdge)
			ResetTagTeamEventSlots()
			Return False
		EndIf
		If UBound($avOppositeEdge, 1) < 3 Or UBound($avOppositeEdge, 2) < 2 Then
			SetDebugLog("Tag Team: Invalid opposite edge drop point: " & $iOppositeEdge)
			ResetTagTeamEventSlots()
			Return False
		EndIf
	EndIf
	Local $bDropped = False
	$g_bTagTeamRemainingDeployAbort = False
	$g_bTagTeamRemainingDeployActive = True
	For $iSlot = 0 To 1
		If $g_bTagTeamRemainingDeployAbort Then ExitLoop
		If Not IsTagTeamEventSlotReserved($iSlot) Then ContinueLoop
		Local $iTroopIndex = $g_avAttackTroops[$iSlot][0]
		If $iTroopIndex < $eBarb Or $iTroopIndex > $eGDrag Then ContinueLoop
		Local $iTroopAmount = $aiEventTroopAmount[$iSlot]
		If $iTroopAmount < 1 Then ContinueLoop
		$g_avAttackTroops[$iSlot][1] = 0
		If $iTroopIndex >= $eBarb And $iTroopIndex <= $eGDrag Then
			SetDebugLog("Tag Team Event Slot " & $iSlot & ": " & GetTroopName($iTroopIndex, $iTroopAmount))
		Else
			SetDebugLog("Tag Team Event Slot " & $iSlot & ": " & $iTroopAmount & " troop(s)")
		EndIf
		; Do not reuse Smart Attack red-area vectors.
		If $iOppositeEdge >= 0 Then
			DropTagTeamTroopsOnEdge($iSlot, $avOppositeEdge, $iTroopAmount, $iOppositeEdge)
		Else
			DropOnEdges($iSlot, $iSides, $iTroopAmount, 1)
		EndIf
		$bDropped = True
		If _Sleep($DELAYALGORITHM_ALLTROOPS5) Then ExitLoop
	Next

	; === REMAINING EVENT TROOPS ===
	If Not $g_bTagTeamRemainingDeployAbort And $g_bRunState And Not IsReturnHomeBattlePage(True, False) Then
		ReleaseClicks()
		If Not _Sleep(250) Then
			Local $iRemainingTroops = PrepareAttack($g_iMatchMode, True, True, True)
			If $iRemainingTroops > 0 Then
				For $iSlot = 0 To $g_iTagTeamEventReservedSlots - 1
					If $iSlot > 1 Or $g_bTagTeamRemainingDeployAbort Then ExitLoop
					Local $iTroopIndex = $g_avAttackTroops[$iSlot][0]
					Local $iTroopAmount = $g_avAttackTroops[$iSlot][1]
					If $iTroopAmount < 1 Then ContinueLoop
					Local $bEventTroop = False
					For $iEventSlot = 0 To $g_iTagTeamEventReservedSlots - 1
						If $iEventSlot > 1 Then ExitLoop
						If $aiEventTroopType[$iEventSlot] = $iTroopIndex And Not $abEventTypeInArmy[$iEventSlot] Then
							$bEventTroop = True
							ExitLoop
						EndIf
					Next
					If Not $bEventTroop Then ContinueLoop
					SetLog("Tag Team: " & $iTroopAmount & " " & GetTroopName($iTroopIndex, $iTroopAmount) & " Remaining", $COLOR_ACTION)
					$g_avAttackTroops[$iSlot][1] = 0
					If $iOppositeEdge >= 0 Then
						DropTagTeamTroopsOnEdge($iSlot, $avOppositeEdge, $iTroopAmount, $iOppositeEdge)
					Else
						DropOnEdges($iSlot, $iSides, $iTroopAmount, 1)
					EndIf
					$bDropped = True
					If _Sleep($DELAYALGORITHM_ALLTROOPS5) Then ExitLoop
				Next
			EndIf
		EndIf
	EndIf

	; === DEPLOYMENT CLEANUP ===
	Local $bDeployInterrupted = $g_bTagTeamRemainingDeployAbort
	$g_bTagTeamRemainingDeployActive = False
	$g_bTagTeamRemainingDeployAbort = False
	If $bDeployInterrupted Then
		If $g_iTagTeamMidTagCount >= 2 Then
			If HasReservedTagTeamEventTroops() Then Return DeployTagTeamRemainingTroops(True)
			ResetTagTeamEventSlots()
		EndIf
		Return $bDropped
	EndIf
	ResetTagTeamEventSlots()
	Return $bDropped
EndFunc   ;==>DeployTagTeamRemainingTroops

; === DEPLOYMENT HELPERS ===
; #FUNCTION# ===========================================================================================================
; Name ..........: DropTagTeamTroopsOnEdge
; Description ...: Deploys Tag Team troops with broad per-click variation outside the selected red-line edge.
; Remarks .......: Uses paired points moving in opposite directions across the full opposite edge whenever possible.
; ======================================================================================================================

Func DropTagTeamTroopsOnEdge($iSlot, $avEdge, $iTroopAmount, $iEdgeIndex)
	If $iTroopAmount < 1 Or Not IsArray($avEdge) Then Return False
	If UBound($avEdge, 1) < 5 Or UBound($avEdge, 2) < 2 Then Return False
	If isProblemAffect(True) Then Return False
	If _SleepAttack($DELAYDROPONEDGE1) Then Return False
	SelectDropTroop($iSlot)
	If _SleepAttack($DELAYDROPONEDGE2) Then Return False
	Local $bDualLineDeploy = $iTroopAmount > 1
	Local $iDeployPairs = Ceiling($iTroopAmount / 2)
	Local $iLinePairs = $iDeployPairs > 20 ? 20 : $iDeployPairs
	AttackRemainingTime(False)

	For $iDrop = 1 To $iTroopAmount
		If $g_bTagTeamRemainingDeployAbort Or ($g_bDirectAttackRunning And $g_bDirectAttackCancelRequested) Then Return False
		Local $iDeployEdgeIndex = $iEdgeIndex
		Local $avDeployEdge = $avEdge
		Local $nEdgeRatio = Random(0.25, 0.75)
		If $bDualLineDeploy Then
			Local $iPairIndex = Floor(($iDrop - 1) / 2)
			If $iLinePairs > 1 Then
				Local $nLineProgress = Mod($iPairIndex, $iLinePairs) / ($iLinePairs - 1)
				$nEdgeRatio = Mod($iDrop, 2) = 0 ? 1 - $nLineProgress : $nLineProgress
			Else
				$nEdgeRatio = Mod($iDrop, 2) = 0 ? 0.75 : 0.25
			EndIf
		EndIf
		Local $iLineStart = $bDualLineDeploy ? 0 : 1
		Local $iLineEnd = $bDualLineDeploy ? 4 : 3
		Local $iDropX, $iDropY, $bSafeDropPoint = False
		For $iSafeAttempt = 0 To 100
			$iDropX = Round($avDeployEdge[$iLineStart][0] + (($avDeployEdge[$iLineEnd][0] - $avDeployEdge[$iLineStart][0]) * $nEdgeRatio))
			$iDropY = Round($avDeployEdge[$iLineStart][1] + (($avDeployEdge[$iLineEnd][1] - $avDeployEdge[$iLineStart][1]) * $nEdgeRatio))
			Switch $iDeployEdgeIndex
				Case 0 ; BOTTOM-RIGHT
					$iDropX += 4
					$iDropY += 4
				Case 1 ; TOP-LEFT
					$iDropX -= 4
					$iDropY -= 4
				Case 2 ; BOTTOM-LEFT
					$iDropX -= 4
					$iDropY += 4
				Case 3 ; TOP-RIGHT
					$iDropX += 4
					$iDropY -= 4
			EndSwitch
			If Not IsTagTeamReturnHomeRisk($iDropX, $iDropY) Then
				$bSafeDropPoint = True
				ExitLoop
			EndIf
			$nEdgeRatio += 0.01
			If $nEdgeRatio > 1 Then ExitLoop
		Next
		If Not $bSafeDropPoint Then
			SetDebugLog("Tag Team: skipped drop point inside Return Home safety area", $COLOR_WARNING)
			ContinueLoop
		EndIf
		Local $iDeployDelay = Random(64, 80, 1)
		If $bDualLineDeploy And Mod($iDrop, 2) = 1 Then $iDeployDelay = Random(12, 20, 1)
		PureClick($iDropX, $iDropY, 1, $iDeployDelay, "#TagTeam")
		_SleepMilli($iDeployDelay)
		If Mod($iDrop, 8) = 0 Then
			CheckTagTeam(False, True, 250)
			If $g_bDirectAttackRunning Then CheckDirectAttackCancelClick()
		EndIf
	Next
	If _Sleep($DELAYDROPONEDGE3) Then Return False
	Return True
EndFunc   ;==>DropTagTeamTroopsOnEdge

Func IsTagTeamReturnHomeRisk($iX, $iY)
	Local $iButtonLeft = $aReturnHomeButton[0] - 95
	Local $iButtonRight = $aReturnHomeButton[0] + 95
	Local $iButtonTop = $aReturnHomeButton[1] + 5
	Local $iButtonBottom = $aReturnHomeButton[1] + 105
	Return $iX >= $iButtonLeft And $iX <= $iButtonRight And $iY >= $iButtonTop And $iY <= $iButtonBottom
EndFunc   ;==>IsTagTeamReturnHomeRisk

Func GetTagTeamOppositeEdge()
	If GetEffectiveAttackAlgorithm($g_iMatchMode) <> 1 Then Return -1

	Local $sMainSide = String(Eval("MAINSIDE"))
	Switch $sMainSide
		Case "BOTTOM-RIGHT"
			Return 1 ; TOP-LEFT
		Case "TOP-LEFT"
			Return 0 ; BOTTOM-RIGHT
		Case "BOTTOM-LEFT"
			Return 3 ; TOP-RIGHT
		Case "TOP-RIGHT"
			Return 2 ; BOTTOM-LEFT
	EndSwitch
	Return -1
EndFunc   ;==>GetTagTeamOppositeEdge

Func ResetTagTeamEventSlots()
	$g_iTagTeamEventReservedSlots = 0
EndFunc   ;==>ResetTagTeamEventSlots

Func ReserveTagTeamEventSlots()
	If $g_iTagTeamMode <> $eTagTeamEventTroops Then Return
	Local $iSlotCount = UBound($g_avAttackTroops, 1)
	ResetTagTeamEventSlots()
	Local $iRewardSlots = $g_iTagTeamMidTagCount
	If $iRewardSlots > 2 Then $iRewardSlots = 2
	If $iRewardSlots > $iSlotCount Then $iRewardSlots = $iSlotCount
	$g_iTagTeamEventReservedSlots = $iRewardSlots
EndFunc   ;==>ReserveTagTeamEventSlots

Func IsTagTeamEventSlotReserved($iSlot)
	If $g_iTagTeamMode <> $eTagTeamEventTroops Or $g_hTagTeamAttackTimer <> $g_hAttackTimer Then Return False
	Return $iSlot >= 0 And $iSlot < $g_iTagTeamEventReservedSlots
EndFunc   ;==>IsTagTeamEventSlotReserved

Func HasReservedTagTeamEventTroops()
	If $g_iTagTeamEventReservedSlots < 1 Then Return False
	For $iSlot = 0 To $g_iTagTeamEventReservedSlots - 1
		Local $iTroopIndex = $g_avAttackTroops[$iSlot][0]
		If $iTroopIndex >= $eBarb And $iTroopIndex <= $eGDrag And $g_avAttackTroops[$iSlot][1] > 0 Then Return True
	Next
	Return False
EndFunc   ;==>HasReservedTagTeamEventTroops

; === ATTACK BAR REFRESH ===
Func RefreshTagTeamAttackBar($iAnimationDelay = 1500)
	If $iAnimationDelay > 0 And _Sleep($iAnimationDelay) Then Return False
	For $iAttempt = 1 To 3
		If PrepareAttack($g_iMatchMode, True, True, True) > 0 Then Return True
		If $iAttempt < 3 And _Sleep(500) Then Return False
	Next
	SetDebugLog("Tag Team: attack bar refresh unavailable after reward animation", $COLOR_WARNING)
	Return False
EndFunc   ;==>RefreshTagTeamAttackBar

; === TEST ===
Func TagTeam_Test($bClick = False)
	If IsTagTeamRewardPopupVisible() Then
		SetLog("Tag Team: Reward popup detected", $COLOR_SUCCESS)
		If $bClick Then Return CheckTagTeam(True)
		Return True
	EndIf

	SetLog("Tag Team: Reward popup not detected", $COLOR_INFO)
	Return False
EndFunc   ;==>TagTeam_Test
