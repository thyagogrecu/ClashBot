; #FUNCTION# ====================================================================================================================
; Name ..........: SwitchBetweenBases
; Description ...: Switches Between Normal Village and Builder Base
; Syntax ........: SwitchBetweenBases()
; Parameters ....:
; Return values .: True: Successfully switched Bases  -  False: Failed to switch Bases
; Author ........: Fliegerfaust (05-2017)
; Modified ......: GrumpyHog (08-2022), Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func SwitchBetweenBases($bCheckMainScreen = True, $GoToBB = False)
	Static $bSwitchActive = False, $aiFailedPasses[$g_iSwitchAccMaxAccounts][2]
	If Not $g_bRunState Or $bSwitchActive Then Return False
	Local $iAccount = $g_iCurAccount, $iDirection = ($GoToBB ? 1 : 0)
	If $iAccount < 0 Or $iAccount >= UBound($aiFailedPasses) Then Return False
	$bSwitchActive = True
	Local $bResult = _SwitchBetweenBases($bCheckMainScreen, $GoToBB)
	If $bResult Then
		$aiFailedPasses[$iAccount][$iDirection] = 0
	ElseIf $g_bRunState And Not $g_bRestart And Not $g_bBotPaused Then
		$aiFailedPasses[$iAccount][$iDirection] += 1
		If $aiFailedPasses[$iAccount][$iDirection] = 1 Then
			SetLog("Base switch failed after 4 attempts; restarting game before one final retry", $COLOR_WARNING)
			RestartAndroidCoC()
			If $g_bRunState Then $g_bRestart = True
		Else
			SetLog("Base switch failed again after recovery; stopping bot to prevent repeated boat clicks", $COLOR_ERROR)
			$aiFailedPasses[$iAccount][$iDirection] = 0
			BotStop()
		EndIf
	EndIf
	$bSwitchActive = False
	Return $bResult
EndFunc   ;==>SwitchBetweenBases

; #FUNCTION# ===========================================================================================================
; Name ..........: _SwitchBetweenBases
; Description ...: Makes up to four boat-switch attempts and validates the requested destination.
; Remarks .......: Recovery and the cross-call failure limit are handled by SwitchBetweenBases.
; ======================================================================================================================
Func _SwitchBetweenBases($bCheckMainScreen = True, $GoToBB = False)
	Local $sSwitchFrom, $sSwitchTo, $bIsOnBuilderBase = False, $bIsOnMainVillage = False, $aButtonCoords, $avBoat, $avTempArray
	Local $sTile, $sTileDir, $sRegionToSearch
	Local $bSwitched = False

	If Not $g_bRunState Then Return

	For $i = 0 To 3
		$bIsOnBuilderBase = isOnBuilderBase(True)
		$bIsOnMainVillage = Not $bIsOnBuilderBase And (isOnMainVillage(True) Or IsMainPage(1))

		If ($GoToBB And $bIsOnBuilderBase) Or (Not $GoToBB And $bIsOnMainVillage) Then
			$g_bStayOnBuilderBase = $GoToBB
			If $bCheckMainScreen Then checkMainScreen(True, $GoToBB)
			Return True
		EndIf

		If $bIsOnBuilderBase Then
			$sSwitchFrom = "Builder Base"
			$sSwitchTo = "Normal Village"
			$sTile = "BoatBuilderBase"
			$sTileDir = $g_sImgBoatBB
			$sRegionToSearch = GetDiamondFromRect("480,40,710,250")
		Else
			$sSwitchFrom = "Normal Village"
			$sSwitchTo = "Builder Base"
			$sTile = "BoatNormalVillage"
			$sTileDir = $g_sImgBoat
			$sRegionToSearch = GetDiamondFromRect("60,430,390,630")
		EndIf

		If _Sleep(250) Then Return
		If Not $g_bRunState Then Return

		ZoomOut() ; ensure boat is visible

		If $bIsOnBuilderBase Then SwitchToBuilderBase()

		If Not $g_bRunState Then Return

		If $bIsOnBuilderBase And $g_iTree = $eTreeOO Then $sRegionToSearch = GetDiamondFromRect("650,180,820,360")

		For $b = 0 To 9
			$avBoat = 0
			If $bIsOnBuilderBase Then
				$avBoat = findMultiple($sTileDir & "BoatBBFront*.bmp", $sRegionToSearch, $sRegionToSearch, 0, 1000, 1, "objectname,objectpoints", True)
			EndIf
			If Not IsArray($avBoat) Or UBound($avBoat) = 0 Then
				$avBoat = findMultiple($sTileDir, $sRegionToSearch, $sRegionToSearch, 0, 1000, 1, "objectname,objectpoints", True)
			EndIf
			; The shared Boat folder contains models for both villages.
			If IsArray($avBoat) Then
				For $k = UBound($avBoat) - 1 To 0 Step -1
					$avTempArray = $avBoat[$k]
					Local $sBoatName = StringRegExpReplace($avTempArray[0], "^.*[\\/]", "")
					If (StringLeft($sBoatName, 6) = "BoatBB") <> $bIsOnBuilderBase Then _ArrayDelete($avBoat, $k)
				Next
			EndIf
			If IsArray($avBoat) And UBound($avBoat, $UBOUND_ROWS) > 0 Then ExitLoop
			If _Sleep(250) Then Return
		Next

		If Not IsArray($avBoat) Or UBound($avBoat, $UBOUND_ROWS) <= 0 Then
			SetLog("Couldn't find boat on " & $sSwitchFrom, $COLOR_ERROR)
			If $g_bDebugImageSave Then SaveDebugImage("SwitchBetweenBases", False)
			If $i = 2 Then
				If $GoToBB And $sSwitchFrom = "Normal Village" Then $g_bStayOnBuilderBase = False
			EndIf
			If $i = 3 Then Return False
		Else
			; loop through the detected images
			For $j = 0 To UBound($avBoat, $UBOUND_ROWS) - 1
				$avTempArray = $avBoat[$j]
				SetLog($sSwitchFrom & " Boat Detected", $COLOR_SUCCESS)
				$aButtonCoords = decodeSingleCoord($avTempArray[1])

				If IsArray($aButtonCoords) And UBound($aButtonCoords, $UBOUND_ROWS) = 2 Then
					ClickP($aButtonCoords)
					If _Sleep($DELAYSWITCHBASES1) Then Return

					; switch can take up to 2 Seconds, check for 3 additional Seconds...
					Local $hTimerHandle = __TimerInit()
					$bSwitched = False
					While __TimerDiff($hTimerHandle) < 3000 And Not $bSwitched
						If _Sleep(250) Then Return
						If Not $g_bRunState Then Return
						ForceCaptureRegion()
						If $GoToBB Then
							$bSwitched = isOnBuilderBase(True)
						Else
							$bSwitched = Not isOnBuilderBase(True) And (isOnMainVillage(True) Or IsMainPage(1))
						EndIf
					WEnd

					If $bSwitched Then
						$g_bStayOnBuilderBase = $GoToBB
						If $bCheckMainScreen Then checkMainScreen(True, Not $bIsOnBuilderBase)
						If $g_bNotifyAlertBuilderBaseSwitch Then PushMsg("BuilderBaseSwitch", $sSwitchFrom & " -> " & $sSwitchTo)
						Return True
					Else
						SetDebugLog("Switch to " & $sSwitchTo & " not confirmed yet; retrying", $COLOR_DEBUG)
						If $i = 2 And $GoToBB And $sSwitchTo = "Builder Base" Then $g_bStayOnBuilderBase = False
						ExitLoop ; Refresh boat positions on the next attempt.
					EndIf
				Else
					SetLog("[" & $i & "] SwitchBetweenBases Tile: " & $sTile, $COLOR_ERROR)
					SetLog("[" & $i & "] SwitchBetweenBases isOnBuilderBase: " & isOnBuilderBase(True), $COLOR_ERROR)
					If $bIsOnBuilderBase Then
						SetLog("Cannot find the boat on the coast", $COLOR_ERROR)
					Else
						SetLog("Cannot find the boat on the coast. Maybe it is still broken or not visible", $COLOR_ERROR)
						If $i = 2 Then $g_bStayOnBuilderBase = False
					EndIf

				EndIf
			Next
		EndIf

		If _Sleep(3000) Then Return
		If Not $g_bRunState Then Return
	Next

	Return False
EndFunc   ;==>_SwitchBetweenBases

Func SwitchToBuilderBase()
	If QuickMIS("BC1", $sImgTunnel, 0, 190 + $g_iMidOffsetY, $g_iGAME_WIDTH, $g_iGAME_HEIGHT) Then
		If $g_iQuickMISName = "OOTunnel" Then
			SetDebugLog("Found OOTunnel", $COLOR_INFO)
			Click($g_iQuickMISX - Random(25, 70, 1), $g_iQuickMISY + Random(0, 30, 1))
		Else
			SetDebugLog("Found BBTunnel", $COLOR_INFO)
			Click($g_iQuickMISX - Random(30, 50, 1), $g_iQuickMISY + Random(10, 40, 1))
		EndIf
		If _Sleep(2000) Then Return
		ZoomOut()
		Return True
	Else
		SetDebugLog("Failed to locate the tunnel", $COLOR_INFO)
		If $g_bDebugImageSave Then SaveDebugImage("OO2BBTunnel") ;
		Return False
	EndIf
EndFunc   ;==>SwitchToBuilderBase


; #FUNCTION# ===========================================================================================================
; Name ..........: TestBBNavigation
; Description ...: Tests a round trip from Main Village to Builder Base and back using the production boat flow.
; Remarks .......: Requires Main Village open; validates each destination before proceeding.
; ======================================================================================================================
Func TestBBNavigation()
	SetLog("Testing Builder Base Navigation", $COLOR_INFO)
	Local $bSuccess = False
	Do
		If Not $g_bRunState Then ExitLoop
		If isOnBuilderBase(True) Or Not (isOnMainVillage(True) Or IsMainPage(1)) Then
			SetLog("Open main village before running this test", $COLOR_WARNING)
			ExitLoop
		EndIf
		SetLog("Main Village To Builder Base", $COLOR_ACTION)
		If Not SwitchBetweenBases(False, True) Then
			SetLog("Couldn't Enter Builder Base", $COLOR_ERROR)
			ExitLoop
		EndIf
		If Not isOnBuilderBase(True) Then
			SetLog("Builder Base Not Confirmed", $COLOR_WARNING)
			ExitLoop
		EndIf
		SetLog("Builder Base Reached", $COLOR_SUCCESS)
		SetLog("Builder Base To Main Village", $COLOR_ACTION)
		If Not SwitchBetweenBases(False, False) Then
			SetLog("Couldn't Return To Main Village", $COLOR_ERROR)
			ExitLoop
		EndIf
		If isOnBuilderBase(True) Or Not (isOnMainVillage(True) Or IsMainPage(1)) Then
			SetLog("Main Village Not Confirmed", $COLOR_WARNING)
			ExitLoop
		EndIf
		SetLog("Returned To Main Village", $COLOR_SUCCESS)
		$bSuccess = True
	Until True
	Return $bSuccess
EndFunc   ;==>TestBBNavigation
