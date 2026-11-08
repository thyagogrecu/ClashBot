; #FUNCTION# ====================================================================================================================
; Name ..........: Train Siege 2018
; Description ...:
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: ProMac(07-2018)
; Modified ......: Moebius14(03-2025)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func TrainSiege()

	Local $bContinueinFunc = False
	For $i = 0 To $eSiegeMachineCount - 1
		If $g_aiArmyCompSiegeMachines[$i] > 0 Then
			$bContinueinFunc = True
			ExitLoop
		EndIf
	Next

	If Not $bContinueinFunc Then Return

	Local $rWhatToTrain = WhichSiegeToTrain(True)     ; r in First means Result! Result of What To Train Function
	Local $Isremoved = True
	If RemoveExtraSieges($rWhatToTrain) = 3 Then $Isremoved = False

	If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop

	If Not $g_bRunState Then Return

	If $Isremoved Or _NeedSiegeTraining() Then
		Local $rWhatToTrain = WhichSiegeToTrain()
		If DoWhatToTrainContainSiege($rWhatToTrain) Then TrainSiegeUsingWhatToTrain($rWhatToTrain)
	EndIf

	If _Sleep(250) Then Return
	If Not $g_bRunState Then Return

EndFunc   ;==>TrainSiege

Func _NeedSiegeTraining()
	For $i = 0 To $eSiegeMachineCount - 1
		If $g_aiArmyCompSiegeMachines[$i] > $g_aiCurrentSiegeMachines[$i] Then Return True
	Next

	Return False
EndFunc   ;==>_NeedSiegeTraining

Func DoWhatToTrainContainSiege($rWTT)
	If UBound($rWTT) = 1 And $rWTT[0][0] = "WallW" And $rWTT[0][1] = 0 Then Return False ; If was default Result of WhichSiegeToTrain
	For $i = 0 To (UBound($rWTT) - 1)
		If IsSiegeToTrain($rWTT[$i][0]) And $rWTT[$i][1] > 0 Then Return True
	Next
	Return False
EndFunc   ;==>DoWhatToTrainContainSiege

Func IsSiegeToTrain($sName)
	Local $iIndex = TroopIndexLookup($sName, "IsSiegeToTrain")
	If $iIndex >= $eWallW And $iIndex <= $eSkyW Then Return True
	Return False
EndFunc   ;==>IsSiegeToTrain

Func TrainSiegeUsingWhatToTrain($rWTT)
	If Not $g_bRunState Then Return

	If UBound($rWTT) = 1 And $rWTT[0][0] = "WallW" And $rWTT[0][1] = 0 Then Return True ; If was default Result of WhatToTrain

	Local $aLeftSpace = GetOCRCurrent(672, 320 + $g_iMidOffsetY, "sieges")
	Local $LeftSpace = $aLeftSpace[1] - $aLeftSpace[0]
	Local $iPage = 0

	; Loop through needed troops to Train
	For $i = 0 To (UBound($rWTT) - 1)
		If Not $g_bRunState Then Return
		If $rWTT[$i][1] > 0 Then ; If Count to Train Was Higher Than ZERO

			If Not IsTrainPageGrayed(False, 1) Then
				If Not OpenSiegeMachinesTab(True, "TrainSiegeUsingWhatToTrain()") Then Return
			EndIf

			Local $iSiegeIndex = TroopIndexLookup($rWTT[$i][0], "TrainSiegeUsingWhatToTrain()")
			Local $NeededSpace = $g_aiSiegeMachineSpace[$iSiegeIndex - $eWallW] * $rWTT[$i][1]

			If $NeededSpace > $LeftSpace Then $rWTT[$i][1] = Int($LeftSpace / $g_aiSiegeMachineSpace[$iSiegeIndex - $eWallW])

			If $rWTT[$i][1] > 0 Then
				Local $sSiegeName = $g_asSiegeMachineNames[$iSiegeIndex - $eWallW]
				If $iSiegeIndex - $eWallW = 3 Then
					SetLog("Training " & $rWTT[$i][1] & "x " & $sSiegeName, $COLOR_SUCCESS)
				Else
					SetLog("Training " & $rWTT[$i][1] & "x " & $sSiegeName & ($rWTT[$i][1] > 1 ? "s" : ""), $COLOR_SUCCESS)
				EndIf

				If Not TrainSiegeMachineIt($iSiegeIndex, $rWTT[$i][1], $iPage) Then
					CloseSiegeTrainingPanel()
					Return False
				EndIf
				$LeftSpace -= $rWTT[$i][1] * $g_aiSiegeMachineSpace[$iSiegeIndex - $eWallW]
			EndIf
		EndIf
		If _Sleep($DELAYRESPOND) Then Return ; add 5ms delay to catch TrainIt errors, and force return to back to main loop
	Next

	CloseSiegeTrainingPanel()
	Return True
EndFunc   ;==>TrainSiegeUsingWhatToTrain

Func CloseSiegeTrainingPanel()
	If IsTrainPageGrayed(False, 3) Then
		Click(Random(240, 360, 1), Random(190 + $g_iMidOffsetY, 210 + $g_iMidOffsetY, 1), 1, 120)
		If _Sleep(250) Then Return
	EndIf
EndFunc   ;==>CloseSiegeTrainingPanel

Func TrainSiegeMachineIt($iSiegeIndex, $iQuantity, ByRef $iPage)
	Local $iSiegeMachineIndex = $iSiegeIndex - $eWallW

	If _Sleep(900) Then Return False
	If _TrainVisibleSiegeMachine($iSiegeIndex, $iQuantity) Then Return True
	If _DragAndTrainSiegeIfNeeded($iSiegeMachineIndex, $iSiegeIndex, $iQuantity, $iPage) Then Return True

	If $iPage < 2 And DragSiegePageRight($iPage) Then
		If _TrainVisibleSiegeMachine($iSiegeIndex, $iQuantity) Then Return True
	EndIf

	SetLog("TrainIt troop position " & GetTroopName($iSiegeIndex) & " did not find icon", $COLOR_ERROR)
	SetLog("Siege machine icon not found in workshop!", $COLOR_ERROR)
	Return False
EndFunc   ;==>TrainSiegeMachineIt

Func _TrainVisibleSiegeMachine($iSiegeIndex, $iQuantity)
	Local $aTrainPos = GetTrainPos($iSiegeIndex)
	If Not IsArray($aTrainPos) Or $aTrainPos[0] = -1 Then Return False

	If _ColorCheck(_GetPixelColor($aTrainPos[0], $aTrainPos[1], $g_bCapturePixel), Hex($aTrainPos[2], 6), $aTrainPos[3]) Then
		Return TrainClickP($aTrainPos, $iQuantity, $g_iTrainClickDelay, "#0266")
	EndIf

	Return False
EndFunc   ;==>_TrainVisibleSiegeMachine

Func WhichSiegeToTrain($bRemoveExtra = False)
	Local $ToReturn[1][2] = [["WallW", 0]] ; 2 element dynamic list [Siege, quantity]
	If Not $bRemoveExtra Then
		For $i = 0 To $eSiegeMachineCount - 1
			Local $iMissingSieges = $g_aiArmyCompSiegeMachines[$i] - $g_aiCurrentSiegeMachines[$i]
			If $iMissingSieges > 0 Then
				$ToReturn[UBound($ToReturn) - 1][0] = $g_asSiegeMachineShortNames[$i]
				$ToReturn[UBound($ToReturn) - 1][1] = $iMissingSieges
				ReDim $ToReturn[UBound($ToReturn) + 1][2]
			EndIf
		Next
	Else
		For $i = 0 To $eSiegeMachineCount - 1
			If $g_aiCurrentSiegeMachines[$i] > 0 Then
				If $g_aiArmyCompSiegeMachines[$i] - $g_aiCurrentSiegeMachines[$i] < 0 Then
					$ToReturn[UBound($ToReturn) - 1][0] = $g_asSiegeMachineShortNames[$i]
					$ToReturn[UBound($ToReturn) - 1][1] = Abs($g_aiArmyCompSiegeMachines[$i] - $g_aiCurrentSiegeMachines[$i])
					ReDim $ToReturn[UBound($ToReturn) + 1][2]
				EndIf
			EndIf
		Next
	EndIf
	Return $ToReturn
EndFunc   ;==>WhichSiegeToTrain

Func RemoveExtraSieges($toRemove)
	Local $iResult = 0
	; Army Window should be open and should be in Tab 'Army tab'

	; 1 Means Removed Sieges without Deleting Sieges Queued
	; 2 Means Removed Sieges And Also Deleted Sieges Queued
	; 3 Means Didn't removed troop... Everything was well

	If UBound($toRemove) = 1 And $toRemove[0][0] = "WallW" And $toRemove[0][1] = 0 Then Return 3

	If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And Not $g_iActiveDonate Then Return 3

	If UBound($toRemove) > 0 Then ; If needed to remove Sieges

		; Loop through Sieges needed to get removed Just to write some Logs
		For $i = 0 To (UBound($toRemove) - 1)
			SetLog("Removing Sieges", $COLOR_INFO)
			Click(793, 326 + $g_iMidOffsetY)
			If _Sleep(250) Then Return
			Local $aiOkayButton = findButton("Okay", Default, 1, True)
			If IsArray($aiOkayButton) And UBound($aiOkayButton, 1) = 2 Then
				Click($aiOkayButton[0], $aiOkayButton[1])     ; Click Okay Button
				If _Sleep(200) Then Return
				ExitLoop
			EndIf
		Next

		If _Sleep(200) Then Return

		If Not $g_bRunState Then Return

		SetLog("All Extra Sieges Removed", $COLOR_SUCCESS)
		Local $aEmptySieges[$eSiegeMachineCount]
		$g_aiCurrentSiegeMachines = $aEmptySieges
		If _Sleep(200) Then Return
		If $iResult = 0 Then $iResult = 1
	Else ; If No extra troop found
		SetLog("No sieges to remove, great", $COLOR_SUCCESS)
		$iResult = 3
	EndIf

	Return $iResult
EndFunc   ;==>RemoveExtraSieges

Func _DragAndTrainSiegeIfNeeded($iSiegeIndex, $iTrainIndex, $iQuantity, ByRef $iPage)
	Local $iTargetPage = 0

	Switch $iSiegeIndex
		Case $eSiegeWallWrecker To $eSiegeLogLauncher
			$iTargetPage = 0
		Case $eSiegeFlameFlinger To $eSiegeBattleDrill
			$iTargetPage = 1
		Case $eSiegeTroopLauncher To $eSiegeSkyWagon
			$iTargetPage = 2
	EndSwitch

	While $iPage < $iTargetPage
		If Not DragSiegePageRight($iPage) Then Return False
		If _TrainVisibleSiegeMachine($iTrainIndex, $iQuantity) Then Return True
	WEnd

	While $iPage > $iTargetPage
		If Not DragSiegePageLeft($iPage) Then Return False
		If _TrainVisibleSiegeMachine($iTrainIndex, $iQuantity) Then Return True
	WEnd

	Return False
EndFunc   ;==>_DragAndTrainSiegeIfNeeded

Func DragSiegePageRight(ByRef $iPage)
	Local $iY1 = Random(540 + $g_iBottomOffsetY, 580 + $g_iBottomOffsetY, 1)
	Local $iY2 = Random(540 + $g_iBottomOffsetY, 580 + $g_iBottomOffsetY, 1)

	ClickDrag(760, $iY1, 220, $iY2, 350)
	If _Sleep(Random(1500, 2000, 1)) Then Return False
	$iPage += 1
	Return True
EndFunc   ;==>DragSiegePageRight

Func DragSiegePageLeft(ByRef $iPage)
	Local $iY1 = Random(540 + $g_iBottomOffsetY, 580 + $g_iBottomOffsetY, 1)
	Local $iY2 = Random(540 + $g_iBottomOffsetY, 580 + $g_iBottomOffsetY, 1)

	ClickDrag(220, $iY1, 760, $iY2, 350)
	If _Sleep(Random(1500, 2000, 1)) Then Return False
	$iPage -= 1
	Return True
EndFunc   ;==>DragSiegePageLeft
