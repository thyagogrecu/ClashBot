; #FUNCTION# ====================================================================================================================
; Name ..........: LocateLab
; Description ...:
; Syntax ........: LocateLab()
; Parameters ....:
; Return values .: None
; Author ........: KnowJack (June 2015)
; Modified ......: Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateLab($bCollect = True, $bAutoOnly = False, $bManualOnly = False)
	If $g_iTownHallLevel < 3 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Lab, so skip locating.", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aPreviousLaboratoryPos[3] = [$g_aiLaboratoryPos[0], $g_aiLaboratoryPos[1], $g_aiLaboratoryPos[2]]
	$g_aiLaboratoryPos[0] = -1
	$g_aiLaboratoryPos[1] = -1
	$g_aiLaboratoryPos[2] = -1

	If Not $bManualOnly Then
		; auto locate
		If ImgLocateLab(False, False, $aPreviousLaboratoryPos) Then
			SetLog("Laboratory Detected: (" & $g_aiLaboratoryPos[0] & "," & $g_aiLaboratoryPos[1] & "), Level: " & $g_aiLaboratoryPos[2], $COLOR_SUCCESS)
			Return True
		EndIf


	EndIf

	If $bAutoOnly Then
		$g_aiLaboratoryPos[0] = $aPreviousLaboratoryPos[0]
		$g_aiLaboratoryPos[1] = $aPreviousLaboratoryPos[1]
		$g_aiLaboratoryPos[2] = $aPreviousLaboratoryPos[2]
		Return False
	EndIf

	If Not isInsideDiamond($aPreviousLaboratoryPos) Then LogUnknownBuildingPosition("Laboratory")

	If Not _LocateLab($bCollect) Then
		$g_aiLaboratoryPos[0] = $aPreviousLaboratoryPos[0]
		$g_aiLaboratoryPos[1] = $aPreviousLaboratoryPos[1]
		$g_aiLaboratoryPos[2] = $aPreviousLaboratoryPos[2]
		Return False
	EndIf

	Return True
EndFunc   ;==>LocateLab

Func _LocateLab($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	If $g_iTownHallLevel < 3 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Lab, so skip locating.", $COLOR_ACTION)
		Return
	EndIf

	WinGetAndroidHandle()
	checkMainScreen(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Laboratory_01", "Click OK then click on your Laboratory building") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Laboratory_02", "Locate Laboratory"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiLaboratoryPos[0] = Int($aPos[0])
			$g_aiLaboratoryPos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiLaboratoryPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Laboratory Location Not Valid!" & @CRLF
						SetDebugLog("Location not valid, try again", $COLOR_DEBUG)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetDebugLog("Operator Error - Bad Laboratory Location.", $COLOR_DEBUG)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Laboratory Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		Local $sLabInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY) ; 860x780
		If $sLabInfo[0] > 1 Or $sLabInfo[0] = "" Then
			If StringInStr($sLabInfo[1], "Lab") = 0 Then
				Local $sLocMsg = ($sLabInfo[0] = "" ? "Nothing" : $sLabInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the laboratory?, It was a " & $sLocMsg & @CRLF
						ContinueLoop
					Case $iSilly = 2
						$sErrorText = "Quit joking, That was " & $sLocMsg & @CRLF
						ContinueLoop
					Case $iSilly = 3
						$sErrorText = "This is not funny, why did you click " & $sLocMsg & "? Please stop!" & @CRLF
						ContinueLoop
					Case $iSilly = 4
						$sErrorText = $sLocMsg & " ?!?!?!" & @CRLF & @CRLF & "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iSilly > 4
						SetDebugLog("Ok, you really think that's a Laboratory?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_DEBUG)
						ClearScreen()
						ExitLoop
				EndSelect
			EndIf
		Else
			SetDebugLog("Operator Error - Bad Laboratory Location: " & "(" & $g_aiLaboratoryPos[0] & "," & $g_aiLaboratoryPos[1] & ")", $COLOR_DEBUG)
			$g_aiLaboratoryPos[0] = -1
			$g_aiLaboratoryPos[1] = -1
			ClearScreen()
			Return False
		EndIf
		$g_aiLaboratoryPos[2] = $sLabInfo[2]
		SetLog("Laboratory Detected: (" & $g_aiLaboratoryPos[0] & "," & $g_aiLaboratoryPos[1] & "), Level: " & $g_aiLaboratoryPos[2], $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()
	Return True

EndFunc   ;==>_LocateLab

; Image Search for Pet House
; #FUNCTION# ===========================================================================================================
; Name ..........: ImgLocateLab
; Description ...: Confirms local image candidates by building name, then retries across the full village.
; Remarks .......: Commits coordinates only after confirmation.
; ======================================================================================================================
Func ImgLocateLab($bSilent = False, $bKeepSelected = False, $aPreviousPos = Default)

	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\Home Village\Laboratory\"
	Local $sLocalArea = "", $iFirstPass = 1
	If IsArray($aPreviousPos) Then
		If UBound($aPreviousPos) >= 2 Then
			If $aPreviousPos[0] > 0 And $aPreviousPos[1] > 0 Then
				Local $iLeft = $aPreviousPos[0] - 90, $iTop = $aPreviousPos[1] - 90
				Local $iRight = $aPreviousPos[0] + 90, $iBottom = $aPreviousPos[1] + 90
				If $iLeft < 0 Then $iLeft = 0
				If $iTop < 0 Then $iTop = 0
				If $iRight > $g_iGAME_WIDTH Then $iRight = $g_iGAME_WIDTH
				If $iBottom > $g_iGAME_HEIGHT Then $iBottom = $g_iGAME_HEIGHT
				$sLocalArea = GetDiamondFromRect2($iLeft, $iTop, $iRight, $iBottom)
				$iFirstPass = 0
			EndIf
		EndIf
	EndIf
	; === CANDIDATE VALIDATION ===
	For $iPass = $iFirstPass To 1
		If Not $g_bRunState Then Return False
		Local $sArea = "FV"
		If $iPass = 0 Then $sArea = $sLocalArea
		Local $aMatches = findMultiple($sImgDir, $sArea, $sArea, 0, 1000, 1, "objectname,objectpoints", True)
		If Not IsArray($aMatches) Then ContinueLoop
		For $i = 0 To UBound($aMatches) - 1
			If Not $g_bRunState Then Return False
			Local $aMatch = $aMatches[$i]
			If Not IsArray($aMatch) Then ContinueLoop
			If UBound($aMatch) < 2 Then ContinueLoop
			Local $aPoint = decodeSingleCoord($aMatch[1])
			If Not IsArray($aPoint) Then ContinueLoop
			If UBound($aPoint) <> 2 Then ContinueLoop
			If Not isInsideDiamond($aPoint) Then ContinueLoop
			BuildingClick($aPoint[0], $aPoint[1])
			If _Sleep($DELAYIMGLOCATE1) Then Return False
			Local $aInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
			Local $bConfirmed = False
			If IsArray($aInfo) Then
				If UBound($aInfo) >= 3 Then $bConfirmed = StringInStr($aInfo[1], "Lab") > 0
			EndIf
			If Not $bConfirmed Then
				ClearScreen()
				ContinueLoop
			EndIf
			If _Sleep($DELAYIMGLOCATE1) Then Return False
			$g_aiLaboratoryPos[0] = $aPoint[0]
			$g_aiLaboratoryPos[1] = $aPoint[1]
			$g_aiLaboratoryPos[2] = $aInfo[2]
			If $bSilent Then SetLog("Laboratory Detected: (" & $aPoint[0] & "," & $aPoint[1] & ")", $COLOR_SUCCESS)
			If Not $bKeepSelected Then ClearScreen()
			Return True
		Next
	Next
	If Not $bSilent Then SetDebugLog("Couldn't confirm Laboratory on main village", $COLOR_DEBUG)
	If $g_bDebugImageSave Then SaveDebugImage("Laboratory", False)
	Return False
EndFunc   ;==>ImgLocateLab
