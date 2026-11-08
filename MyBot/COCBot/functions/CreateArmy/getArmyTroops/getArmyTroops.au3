; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyTroops
; Description ...: Obtain the current trained Troops
; Syntax ........: getArmyTroops()
; Parameters ....:
; Return values .:
; Author ........: Fliegerfaust(11-2017)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include <Array.au3>
#include <MsgBoxConstants.au3>


Func getArmyTroops($bOpenArmyWindow = False, $bCloseArmyWindow = False, $bCheckWindow = False, $bSetLog = True, $bNeedCapture = True)

	If $g_bDebugSetLogTrain Then SetLog("getArmyTroops():", $COLOR_DEBUG)

	If Not $bOpenArmyWindow Then
		If $bCheckWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return ; not open, not requested to be open - error.
		EndIf
	ElseIf $bOpenArmyWindow Then
		If Not OpenArmyOverview(True, "getArmyTroops()") Then
			SetError(2)
			Return ; not open, requested to be open - error.
		EndIf
		If _Sleep($DELAYCHECKARMYCAMP5) Then Return
	EndIf

	If _CheckPixel($aReceivedTroops, $bNeedCapture) Or _CheckPixel($aReceivedTroopsOCR, $bNeedCapture) Then ; Found the "You have received" Message on Screen, wait till its gone.
		If $bSetLog Then SetLog("Detected Clan Castle Message Blocking Troop Images. Waiting until it's gone", $COLOR_INFO)
		_CaptureRegion2()
		While (_CheckPixel($aReceivedTroops, $bNeedCapture) Or _CheckPixel($aReceivedTroopsOCR, $bNeedCapture))
			If _Sleep($DELAYTRAIN1) Then Return
		WEnd
	EndIf

	WaitForClanMessage("ArmyOverview")

	Local $sTroopDiamond = GetDiamondFromRect2(380, 235 + $g_iMidOffsetY, 803, 292 + $g_iMidOffsetY) ; Contains iXStart, $iYStart, $iXEnd, $iYEnd

	If $g_bDebugFuncTime Then StopWatchStart("findMultiple, \imgxml\Army\Overview\Troops")
	Local $aCurrentTroops = findMultiple(@ScriptDir & "\imgxml\Army\Overview\Troops", $sTroopDiamond, $sTroopDiamond, 0, 1000, 0, "objectname,objectpoints", $bNeedCapture) ; Returns $aCurrentTroops[index] = $aArray[2] = ["TroopShortName", CordX,CordY]
	If $g_bDebugFuncTime Then StopWatchStopLog()

	Local $aTempTroopArray, $aTroopCoords
	Local $sTroopName = ""
	Local $iTroopIndex = -1
	Local $aCurrentTroopsEmpty[$eTroopCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ; Local Copy to reset Troops Array
	Local $aCurrentTroopsLog[0][3] ; [0] = Name [1] = Quantities [3] Xaxis

	$g_aiCurrentTroops = $aCurrentTroopsEmpty ; Reset Current Troops Array
	If UBound($aCurrentTroops, 1) >= 1 Then
		For $i = 0 To UBound($aCurrentTroops, 1) - 1 ; Loop through found Troops
			$aTempTroopArray = $aCurrentTroops[$i] ; Declare Array to Temp Array

			$iTroopIndex = TroopIndexLookup($aTempTroopArray[0], "getArmyTroops()") ; Get the Index of the Troop from the ShortName

			$aTroopCoords = StringSplit($aTempTroopArray[1], ",", $STR_NOCOUNT) ; Split the Coordinates where the Troop got found into X and Y

			If $iTroopIndex = -1 Then ContinueLoop

			Local $sTroopQuantity = getBarracksNewTroopQuantity(Slot($aTroopCoords[0], $aTroopCoords[1]), 236 + $g_iMidOffsetY, $bNeedCapture)
			Local $iMaxTroopQuantity = Floor($g_iTotalCampSpace / $g_aiTroopSpace[$iTroopIndex])
			While $g_iTotalCampSpace > 0 And StringLen($sTroopQuantity) > 1 And Number($sTroopQuantity) > $iMaxTroopQuantity
				$sTroopQuantity = StringTrimRight($sTroopQuantity, 1)
			WEnd
			$g_aiCurrentTroops[$iTroopIndex] = Number($sTroopQuantity)

			$sTroopName = $g_aiCurrentTroops[$iTroopIndex] >= 2 ? $g_asTroopNamesPlural[$iTroopIndex] : $g_asTroopNames[$iTroopIndex] ; Select the right Troop Name, If more than one then use the Plural
			_ArrayAdd($aCurrentTroopsLog, $sTroopName & "|" & $g_aiCurrentTroops[$iTroopIndex] & "|" & Slot($aTroopCoords[0], $aTroopCoords[1]))

		Next
	EndIf

	; Just a good log from left to right
	_ArraySort($aCurrentTroopsLog, 0, 0, 0, 2)
	For $index = 0 To UBound($aCurrentTroopsLog) - 1
		If $aCurrentTroopsLog[$index][1] > 0 And $bSetLog Then SetLog(" - " & $aCurrentTroopsLog[$index][1] & " " & $aCurrentTroopsLog[$index][0] & " Available")
	Next

	If $bCloseArmyWindow Then
		CloseWindow()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return
	EndIf

EndFunc   ;==>getArmyTroops
