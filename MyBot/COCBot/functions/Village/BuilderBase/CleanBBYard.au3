; #FUNCTION# ===========================================================================================================
; Name ..........: CleanBBYard
; Author ........: Phael
; Description ...: Removes Builder Base obstacles from the lower and higher zones.
; Remarks .......: Test mode opens each obstacle and verifies the Remove button without confirming removal.
; ======================================================================================================================
Func CleanBBYard($bTest = False)
	If Not $g_bChkCleanBBYard And Not $bTest And Not TestCapture() Then Return 0
	$g_bStayOnBuilderBase = True

	Local $hObstaclesTimer = __TimerInit()
	Local $iRemovedCount = 0
	SetLog("Cleaning Yard", $COLOR_INFO)

	BuilderBaseReport(True)
	If Number($g_aiCurrentLootBB[$eLootElixirBB]) <= 50000 And Not $bTest Then
		SetLog("Current BB Elixir below 50000, skipping yard cleanup", $COLOR_DEBUG2)
		Return 0
	EndIf

	GotoLowerZone()
	ZoomOut()
	If _Sleep($DELAYRESPOND) Then Return $iRemovedCount

	$iRemovedCount += _CleanBBYardZone($g_sImgCleanBBLower, "lower zone", 20000, $bTest)

	If GotoHigherZone() Then
		$iRemovedCount += _CleanBBYardZone($g_sImgCleanBBHigher, "higher zone", 100000, $bTest)
		GotoLowerZone()
	Else
		SetLog("Could not switch to higher zone", $COLOR_WARNING)
	EndIf

	If $iRemovedCount = 0 Then
		SetLog($bTest ? "Test completed without removing obstacles" : "No Obstacles Found", $bTest ? $COLOR_BLACK : $COLOR_SUCCESS)
	EndIf
	If $g_bDebugSetLog Then SetDebugLog("Time: " & Round(__TimerDiff($hObstaclesTimer) / 1000, 2) & "'s", $COLOR_SUCCESS)
	UpdateStats()
	ClearScreen("Defaut", False)
	Return $iRemovedCount
EndFunc   ;==>CleanBBYard

; #FUNCTION# ===========================================================================================================
; Name ..........: _CleanBBYardZone
; Description ...: Detects and processes one obstacle in the selected Builder Base zone.
; Remarks .......: Repeats the search recursively after each removal, up to a depth of 30.
; ======================================================================================================================

Func _CleanBBYardZone($sImageDirectory, $sZoneName, $iMinimumElixir, $bTest, $iSearchDepth = 0)
	If $iSearchDepth >= 30 Then Return 0

	Local $aResult = QuickMIS("CNX", $sImageDirectory, 0, 0, $g_iGAME_WIDTH, $g_iGAME_HEIGHT)
	If Not IsArray($aResult) Or UBound($aResult) = 0 Then
		SetLog("No obstacles found on " & $sZoneName)
		Return 0
	EndIf

	For $i = 0 To UBound($aResult) - 1
		Local $iX = Number($aResult[$i][1]), $iY = Number($aResult[$i][2])
		If Not _IsInsideBBYardArea($iX, $iY) Then ContinueLoop
		If $bTest Then
			SetLog($aResult[$i][0] & " found (" & $iX & "," & $iY & ")", $COLOR_SUCCESS)
		ElseIf $g_bDebugSetLog Then
			SetDebugLog($aResult[$i][0] & " found (" & $iX & "," & $iY & ")", $COLOR_SUCCESS)
		EndIf
		If Not IsMainPageBuilderBase() Then Return 0
		Click($iX, $iY, 1, 120, "#0430")
		If _Sleep(1000) Then Return 0

		If ClickRemoveObstacleBB($bTest) Then
			If $bTest Then
				ClearScreen("Defaut", False)
				ContinueLoop
			EndIf
			SetLog("Obstacle Removed: (" & $iX & "," & $iY & ")", $COLOR_SUCCESS)
			If _Sleep($DELAYCHECKTOMBS2) Then Return 1
			ClearScreen("Defaut", False)
			If _Sleep($DELAYCHECKTOMBS1) Then Return 1
			BuilderBaseReport(True, False)
			Local $bUsesGold = StringLeft($aResult[$i][0], 4) = "Pond"
			Local $iCurrentLoot = $bUsesGold ? $g_aiCurrentLootBB[$eLootGoldBB] : $g_aiCurrentLootBB[$eLootElixirBB]
			Local $sLootName = $bUsesGold ? "Gold" : "Elixir"
			If Number($iCurrentLoot) <= $iMinimumElixir Then
				SetLog("Current BB " & $sLootName & " below " & $iMinimumElixir, $COLOR_DEBUG2)
				Return 1
			EndIf
			Return 1 + _CleanBBYardZone($sImageDirectory, $sZoneName, $iMinimumElixir, $bTest, $iSearchDepth + 1)
		EndIf

		If $bTest Then SetLog("Remove button not detected for " & $aResult[$i][0] & " at " & $iX & "," & $iY, $COLOR_WARNING)
		ClearScreen("Defaut", False)
	Next
	SetLog("No obstacles found on " & $sZoneName)
	Return 0
EndFunc   ;==>_CleanBBYardZone

; #FUNCTION# ===========================================================================================================
; Name ..........: _IsInsideBBYardArea
; Description ...: Accepts the external village diamond where obstacles spawn while excluding the surrounding interface.
; ======================================================================================================================

Func _IsInsideBBYardArea($iX, $iY)
	Local $iLeft = $ExternalArea[0][0], $iRight = $ExternalArea[1][0]
	Local $iTop = $ExternalArea[2][1], $iBottom = $ExternalArea[3][1]
	Local $iHalfWidth = ($iRight - $iLeft) / 2, $iHalfHeight = ($iBottom - $iTop) / 2
	If $iHalfWidth <= 0 Or $iHalfHeight <= 0 Then Return False

	Local $iCenterX = ($iLeft + $iRight) / 2, $iCenterY = ($iTop + $iBottom) / 2
	Return Abs($iX - $iCenterX) / $iHalfWidth + Abs($iY - $iCenterY) / $iHalfHeight <= 1
EndFunc   ;==>_IsInsideBBYardArea

; #FUNCTION# ===========================================================================================================
; Name ..........: ClickRemoveObstacleBB
; Description ...: Detects and clicks the Builder Base Remove button.
; Remarks .......: Test mode logs the detected confirmation and does not click it.
; ======================================================================================================================

Func ClickRemoveObstacleBB($bTest = False)
	Local $aiButton[0]
	Local $bButtonFound = False
	For $i = 0 To 20
		If QuickMIS("BC1", $g_sImgCleanBBRemoveButton, 292, 500, 575, $g_iGAME_HEIGHT - 60) Then
			Local $aiDetectedButton[2] = [$g_iQuickMISX, $g_iQuickMISY]
			$aiButton = $aiDetectedButton
			$bButtonFound = True
			ExitLoop
		EndIf
		If _Sleep(200) Then Return False
	Next
	If Not $bButtonFound Then $aiButton = findButton("RemoveObstacle", $g_sImgCleanBBRemoveButton & "RemoveObstacle*", 1, True)

	If Not IsArray($aiButton) Or UBound($aiButton) < 2 Then Return False
	If $bTest Then SetLog("[Remove Button]: detected at " & $aiButton[0] & "," & $aiButton[1], $COLOR_INFO)
	If $bTest Then
		SetLog("Test mode: removal confirmation not clicked", $COLOR_WARNING)
		Return True
	EndIf

	ClickP($aiButton)
	If _Sleep(1000) Then Return False
	Return True
EndFunc   ;==>ClickRemoveObstacleBB

; #FUNCTION# ===========================================================================================================
; Name ..........: GotoHigherZone
; Description ...: Uses the lower-zone tunnel to enter the higher Builder Base zone.
; Remarks .......: Returns True only when the tunnel is detected and clicked.
; ======================================================================================================================

Func GotoHigherZone()
	If Not QuickMIS("BC1", $g_sImgCleanBBDownTunnel, 150, 50 + $g_iMidOffsetY, 350, 250 + $g_iMidOffsetY) Then Return False
	SetDebugLog("Switching To Higher Zone", $COLOR_ACTION)
	Click($g_iQuickMISX, $g_iQuickMISY)
	If _Sleep(3000) Then Return False
	ZoomOut()
	Return IsMainPageBuilderBase()
EndFunc   ;==>GotoHigherZone

; #FUNCTION# ===========================================================================================================
; Name ..........: GotoLowerZone
; Description ...: Uses the higher-zone tunnel to return to the lower Builder Base zone.
; Remarks .......: Returns False when the higher-zone tunnel is not visible, including when already in LowerZone.
; ======================================================================================================================

Func GotoLowerZone()
	If Not QuickMIS("BC1", $g_sImgCleanBBUpTunnel, 300, 400 + $g_iMidOffsetY, 660, $g_iGAME_HEIGHT) Then Return False
	SetDebugLog("Switching To Lower Zone", $COLOR_ACTION)
	Click($g_iQuickMISX, $g_iQuickMISY)
	If _Sleep(3000) Then Return False
	ZoomOut()
	Return IsMainPageBuilderBase()
EndFunc   ;==>GotoLowerZone


; #FUNCTION# ===========================================================================================================
; Name ..........: TestBBTunnels
; Description ...: Tests Lower Zone to Higher Zone and back, validating the opposite tunnel after each transition.
; Remarks .......: Requires Builder Base open; first returns to Lower Zone when starting in Higher Zone.
; ======================================================================================================================
Func TestBBTunnels()
	SetLog("Testing Builder Base Tunnels", $COLOR_INFO)
	Local $bSuccess = False
	Do
		If Not $g_bRunState Then ExitLoop
		If Not isOnBuilderBase(True) Then
			SetLog("Open builder base before running this test", $COLOR_WARNING)
			ExitLoop
		EndIf
		ZoomOut()
		If Not $g_bRunState Then ExitLoop
		If QuickMIS("BC1", $g_sImgCleanBBUpTunnel, 300, 400 + $g_iMidOffsetY, 660, $g_iGAME_HEIGHT) Then
			If Not GotoLowerZone() Then ExitLoop
		EndIf
		If Not QuickMIS("BC1", $g_sImgCleanBBDownTunnel, 150, 50 + $g_iMidOffsetY, 350, 250 + $g_iMidOffsetY) Then
			SetLog("Lower Zone Tunnel Not Detected", $COLOR_WARNING)
			ExitLoop
		EndIf
		SetLog("Lower Zone To Higher Zone", $COLOR_ACTION)
		If Not GotoHigherZone() Then ExitLoop
		Local $bHigherConfirmed = False
		For $iAttempt = 1 To 5
			If Not $g_bRunState Then ExitLoop
			If QuickMIS("BC1", $g_sImgCleanBBUpTunnel, 300, 400 + $g_iMidOffsetY, 660, $g_iGAME_HEIGHT) Then
				$bHigherConfirmed = True
				ExitLoop
			EndIf
			If _Sleep(300) Then ExitLoop
		Next
		If Not $bHigherConfirmed Then
			SetLog("Higher Zone Not Confirmed", $COLOR_WARNING)
			ExitLoop
		EndIf
		SetLog("Higher Zone Reached", $COLOR_SUCCESS)
		SetLog("Higher Zone To Lower Zone", $COLOR_ACTION)
		If Not GotoLowerZone() Then ExitLoop
		For $iAttempt = 1 To 5
			If Not $g_bRunState Then ExitLoop
			If QuickMIS("BC1", $g_sImgCleanBBDownTunnel, 150, 50 + $g_iMidOffsetY, 350, 250 + $g_iMidOffsetY) Then
				$bSuccess = True
				ExitLoop
			EndIf
			If _Sleep(300) Then ExitLoop
		Next
		If $bSuccess Then
			SetLog("Returned To Lower Zone", $COLOR_SUCCESS)
		Else
			SetLog("Lower Zone Not Confirmed", $COLOR_WARNING)
		EndIf
	Until True
	Return $bSuccess
EndFunc   ;==>TestBBTunnels
