; #FUNCTION# ====================================================================================================================
; Name ..........: Collect Free Magic Items from trader
; Description ...:
; Syntax ........: CollectFreeMagicItems()
; Parameters ....:
; Return values .: None
; Author ........: ProMac (03-2018)
; Modified ......: Moebius14 (09-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func CollectFreeMagicItems($bTest = False)
	If Not $g_bChkCollectFreeMagicItems Or Not $g_bRunState Then Return

	Local Static $iLastTimeChecked[$g_iSwitchAccMaxAccounts]
	If $iLastTimeChecked[$g_iCurAccount] = @MDAY And Not $bTest Then Return

	ClearScreen()

	If Not IsMainPage() Then Return

	SetLog("Collecting Free Magic Items", $COLOR_INFO)
	If _Sleep($DELAYCOLLECT2) Then Return

	; Check Trader Icon on Main Village
	If Not OpenTraderWindow() Then Return

	If Not $g_bRunState Then Return

	$iLastTimeChecked[$g_iCurAccount] = @MDAY

	Local $aOcrPositions[3][2] = [[275, 357], [480, 357], [685, 357]]
	Local $ItemPosition = ""
	Local $Collected = 0
	Local $aResults = GetFreeMagic()
	Local $aGem[3]

	For $t = 0 To UBound($aResults) - 1
		$aGem[$t] = $aResults[$t][0]
	Next
	For $i = 0 To UBound($aResults) - 1
		$ItemPosition = $i + 1
		If Not $bTest Then
			If $aResults[$i][0] = "FREE" Then
				Click($aResults[$i][1], $aResults[$i][2])
				If _Sleep(Random(3000, 4000, 1)) Then Return
				If isGemOpen(True) Then
					SetLog("Free magic item collection failed, Gems Window popped up", $COLOR_ERROR)
				EndIf
				SetLog("Free Magic Item Detected - Slot: #" & $ItemPosition, $COLOR_SUCCESS)
				If WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 15, 1) Then
					SetLog("Free Magic Item Collected - Slot: #" & $ItemPosition, $COLOR_SUCCESS)
					$aGem[$i] = "Collected"
					If _Sleep(1500) Then Return
					$Collected += 1
				EndIf
			ElseIf $aResults[$i][0] = "FreeFull" Then
				SetLog("Free Magic Item Detected - Slot: #" & $ItemPosition, $COLOR_SUCCESS)
				SetLog("But item can't be collected, stock is full")
				$aGem[$i] = "Full"
			ElseIf $aResults[$i][0] = "Full" Then
				$aGem[$i] = "Full"
			ElseIf $aResults[$i][0] = "SoldOut" Then
				SetLog("Free Magic Item Detected - Slot: #" & $ItemPosition, $COLOR_SUCCESS)
				SetLog("The item is out of stock")
				$aGem[$i] = "Sold Out"
				If _Sleep(Random(2000, 4000, 1)) Then Return
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Next

	If Not $Collected Then
		SetLog("No free rewards to collect")
	EndIf

	CloseWindow2()
	If _Sleep(1000) Then Return
EndFunc   ;==>CollectFreeMagicItems

Func GetFreeMagic()
	Local $aOcrPositions[3][2] = [[275, 357], [480, 357], [685, 357]]
	Local $aClickFreeItemPositions[3][2] = [[305, 280], [512, 280], [723, 280]]
	Local $aResults[0][3]

	For $i = 0 To UBound($aOcrPositions) - 1
		Local $bSoldOut = WaitforPixel($aOcrPositions[$i][0] + 25, $aOcrPositions[$i][1] - 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] - 25, "AD590D", 15, 1)
		Local $Read = $bSoldOut ? "SoldOut" : ReadFreeMagicValue($aOcrPositions[$i][0], $aOcrPositions[$i][1], $i + 1)

		If $Read = "FREE" Then
			If WaitforPixel($aOcrPositions[$i][0] + 33, $aOcrPositions[$i][1] + 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] + 31, "969696", 10, 1) Then
				$Read = "FreeFull"
			EndIf
		EndIf

		If $Read = "" Then $Read = "N/A"
		If StringRegExp($Read, "^\d+$") Then
			$Read = $Read & " Gems"
			If WaitforPixel($aOcrPositions[$i][0] + 33, $aOcrPositions[$i][1] + 30, $aOcrPositions[$i][0] + 35, $aOcrPositions[$i][1] + 31, "b4b4b4", 10, 1) Then
				$Read = "Full"
			EndIf
		EndIf
		_ArrayAdd($aResults, $Read & "|" & $aClickFreeItemPositions[$i][0] & "|" & $aClickFreeItemPositions[$i][1])
	Next
	Return $aResults
EndFunc   ;==>GetFreeMagic

Func ReadFreeMagicValue($iX, $iY, $iSlot)
	Local $aModels[3] = ["coc-freemagicitems", "coc-CostsUpgrades", "coc-ms"]
	Local $aReadAreas[5][5] = [[0, 0, 60, 25, 12], [0, 8, 60, 18, 3], [5, 8, 48, 18, 3], [-4, 5, 68, 20, 2], [-10, -4, 80, 33, 1]]
	Local $aValues[0][2]

	For $iModel = 0 To UBound($aModels) - 1
		For $iArea = 0 To UBound($aReadAreas) - 1
			Local $sRawRead = StringStripWS(getOcrAndCapture($aModels[$iModel], $iX + $aReadAreas[$iArea][0], $iY + $aReadAreas[$iArea][1], $aReadAreas[$iArea][2], $aReadAreas[$iArea][3], True), 8)
			Local $sUpperRead = StringUpper($sRawRead)
			SetDebugLog("Free Magic OCR slot #" & $iSlot & " [" & $aModels[$iModel] & "] try #" & ($iArea + 1) & ": '" & $sRawRead & "'")

			If StringInStr($sUpperRead, "FREE") Then Return "FREE"

			Local $sDigits = StringRegExpReplace($sRawRead, "\D", "")
			If $sDigits = "" Then ContinueLoop

			Local $iValue = Number($sDigits)
			If $iModel > 0 And IsLikelyTraderGemIconNoise($iValue) Then ContinueLoop
			Local $iWeight = $aReadAreas[$iArea][4]

			; Recover common two-digit gem prices when OCR drops the last digit.
			If $iValue < 10 Then
				Switch $iValue
					Case 3
						$iValue = 30
					Case 5
						$iValue = 50
					Case 6
						$iValue = 60
					Case 7
						$iValue = 75
					Case 9
						$iValue = 90
					Case Else
						ContinueLoop
				EndSwitch
				$iWeight = _Max(1, Int($iWeight / 2))
			Else
				$iWeight += 3
			EndIf

			If $iValue < 10 Or $iValue > 9999 Then ContinueLoop
			If $iModel = 0 Then $iWeight += 2
			If IsCommonTraderGemPrice($iValue) Then $iWeight += 2
			If Not IsCommonTraderGemPrice($iValue) And $iArea > 0 Then $iWeight -= 4

			Local $bAdded = False
			For $i = 0 To UBound($aValues) - 1
				If $aValues[$i][0] = $iValue Then
					$aValues[$i][1] += $iWeight
					$bAdded = True
					ExitLoop
				EndIf
			Next
			If Not $bAdded Then _ArrayAdd($aValues, $iValue & "|" & $iWeight)
		Next
	Next

	If UBound($aValues) = 0 Then Return ""

	Local $iBestValue = 0, $iBestWeight = -1
	For $i = 0 To UBound($aValues) - 1
		If $aValues[$i][1] > $iBestWeight Then
			$iBestValue = $aValues[$i][0]
			$iBestWeight = $aValues[$i][1]
		EndIf
	Next

	SetDebugLog("Free Magic OCR slot #" & $iSlot & " selected: " & $iBestValue & " (score " & $iBestWeight & ")")
	Return String($iBestValue)
EndFunc   ;==>ReadFreeMagicValue

Func IsLikelyTraderGemIconNoise($iValue)
	Local $aNoiseValues[7] = [111, 313, 413, 1111, 1113, 11111, 11113]
	For $i = 0 To UBound($aNoiseValues) - 1
		If $aNoiseValues[$i] = $iValue Then Return True
	Next
	Return False
EndFunc   ;==>IsLikelyTraderGemIconNoise

Func IsCommonTraderGemPrice($iValue)
	Local $aCommonPrices[28] = [10, 15, 20, 25, 30, 35, 40, 45, 50, 60, 65, 70, 75, 80, 90, 100, 115, 120, 150, 200, 250, 300, 400, 500, 600, 750, 900, 925]
	For $i = 0 To UBound($aCommonPrices) - 1
		If $aCommonPrices[$i] = $iValue Then Return True
	Next
	Return False
EndFunc   ;==>IsCommonTraderGemPrice

Func OpenTraderWindow()
	Local $Found = False
	Local $Area[4] = [90, 100 + $g_iMidOffsetY, 210, 210 + $g_iMidOffsetY]
	If IsCustomScenery(True, "Upper") Then
		$Area[0] = 120
		$Area[1] = 145 + $g_iMidOffsetY
		$Area[2] = 240
		$Area[3] = 230 + $g_iMidOffsetY
	EndIf
	For $i = 1 To 5
		If QuickMIS("BC1", $g_sImgTrader, $Area[0], $Area[1], $Area[2], $Area[3]) Then
			Click($g_iQuickMISX, $g_iQuickMISY)
			If _Sleep(1500) Then Return
			$Found = True
			ExitLoop
		EndIf
		If _Sleep(1000) Then Return
	Next
	If Not $Found Then
		SetLog("Trader Unavailable", $COLOR_DEBUG)
		SetLog("Rechecking in the next loop", $COLOR_DEBUG)
		Return False
	Else
		WaitForClanMessage("WeeklyDeals")
		; Locate the Gems tab itself. Event Deals changes its slot, not its image.
		For $i = 1 To 5
			If QuickMIS("BC1", $g_sImgTraderGems, 35, 165 + $g_iMidOffsetY, 150, 340 + $g_iMidOffsetY) Then
				Click($g_iQuickMISX, $g_iQuickMISY)
				If _Sleep(500) Then Return False
			Local $aiDailyDiscount = decodeSingleCoord(findImage("DailyDiscount", $g_sImgDailyDiscountWindow, GetDiamondFromRect("420,105,510,155"), 1, True, Default))
			If IsArray($aiDailyDiscount) And UBound($aiDailyDiscount, 1) > 1 Then Return True
			EndIf
			If _Sleep(250) Then Return False
		Next

		SetLog("Cannot open Gems Menu", $COLOR_ERROR)
		CloseWindow()
		Return False
	EndIf
EndFunc   ;==>OpenTraderWindow
