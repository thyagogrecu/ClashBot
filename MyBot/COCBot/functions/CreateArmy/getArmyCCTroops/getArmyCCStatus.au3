; #FUNCTION# ====================================================================================================================
; Name ..........: getArmyCCStatus
; Description ...: Reads Clan Castle request state from Army Overview button images.
; Syntax ........: getArmyCCStatus($bOpenArmyWindow = False, $bCloseArmyWindow = False)
; Parameters ....:
; Return values .:
; Author ........: Phael
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getArmyCCStatus($bOpenArmyWindow = False, $bCloseArmyWindow = False, $CheckWindow = True, $bSetLog = True, $bNeedCapture = True)

	If $g_bDebugSetLogTrain Or $g_bDebugSetLog Then SetLog("Begin getArmyCCStatus:", $COLOR_DEBUG1)

	If $CheckWindow Then
		If Not $bOpenArmyWindow And Not IsTrainPage() Then ; check for train page
			SetError(1)
			Return "Error" ; not open, not requested to be open - error.
		ElseIf $bOpenArmyWindow Then
			If Not OpenArmyOverview(True, "getArmyCCStatus()") Then
				SetError(2)
				Return "Error" ; not open, requested to be open - error.
			EndIf
			If _Sleep($DELAYCHECKARMYCAMP5) Then Return "Error"
		EndIf
	EndIf

	Local $sDirectory = @ScriptDir & "\ImgXML\ClanCastle\Request\ArmyOverview\"
	Local $aModels[3] = ["FullOrUnavailable", "Available", "AlreadyMade"]
	Local $sStatus = "Unknown", $iMatches = 0
	For $sModel In $aModels
		If Not $g_bRunState Then Return "Error"
		Local $aButton = decodeSingleCoord(FindImageInPlace2($sModel, $sDirectory & $sModel & "*.xml", 600, 350, 855, $g_iGAME_HEIGHT - 20, $bNeedCapture))
		If Not IsArray($aButton) Then ContinueLoop
		If UBound($aButton) <> 2 Then ContinueLoop
		$iMatches += 1
		$sStatus = ($sModel = "FullOrUnavailable" ? "Full" : $sModel)
	Next
	If $iMatches <> 1 Then $sStatus = "Unknown"
	$g_bCanRequestCC = ($sStatus = "Available")
	If $bSetLog Then
		Switch $sStatus
			Case "Full"
				SetLog("Clan Castle Full", $COLOR_INFO)
			Case "AlreadyMade"
				SetLog(" - Clan Castle request already made.", $COLOR_INFO)
		EndSwitch
	EndIf
	If $sStatus = "Unknown" Then SetDebugLog("Army Overview Clan Castle request state not recognized", $COLOR_DEBUG)

	If $bCloseArmyWindow Then
		CloseWindow()
		If _Sleep($DELAYCHECKARMYCAMP4) Then Return $sStatus
	EndIf

	Return $sStatus

EndFunc   ;==>getArmyCCStatus
