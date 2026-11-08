; #FUNCTION# ====================================================================================================================
; Name ..........: LocateBlacksmith
; Description ...:
; Syntax ........: LocateBlacksmith()
; Parameters ....:
; Return values .: None
; Author ........: Moebius14 (Dec 2023)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateBlacksmith($bCollect = True, $bAutoOnly = False, $bManualOnly = False)
	If $g_iTownHallLevel < 8 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Blacksmith, so skip locating.", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aPreviousBlacksmithPos[3] = [$g_aiBlacksmithPos[0], $g_aiBlacksmithPos[1], $g_aiBlacksmithPos[2]]
	$g_aiBlacksmithPos[0] = -1
	$g_aiBlacksmithPos[1] = -1
	$g_aiBlacksmithPos[2] = -1

	If Not $bManualOnly Then
		; auto locate
		If ImgLocateBlacksmith(False, False, $aPreviousBlacksmithPos) Then
			SetLog("Blacksmith Detected: (" & $g_aiBlacksmithPos[0] & "," & $g_aiBlacksmithPos[1] & "), Level: " & $g_aiBlacksmithPos[2], $COLOR_SUCCESS)
			Return True
		EndIf

	EndIf

	If $bAutoOnly Then
		$g_aiBlacksmithPos[0] = $aPreviousBlacksmithPos[0]
		$g_aiBlacksmithPos[1] = $aPreviousBlacksmithPos[1]
		$g_aiBlacksmithPos[2] = $aPreviousBlacksmithPos[2]
		Return False
	EndIf

	If Not isInsideDiamond($aPreviousBlacksmithPos) Then LogUnknownBuildingPosition("Blacksmith")

	If Not _LocateBlacksmith($bCollect) Then
		$g_aiBlacksmithPos[0] = $aPreviousBlacksmithPos[0]
		$g_aiBlacksmithPos[1] = $aPreviousBlacksmithPos[1]
		$g_aiBlacksmithPos[2] = $aPreviousBlacksmithPos[2]
		Return False
	EndIf

	Return True
EndFunc   ;==>LocateBlacksmith

Func _LocateBlacksmith($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	WinGetAndroidHandle()
	checkMainScreen(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Blacksmith_01", "Click OK then click on your Blacksmith") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Blacksmith_02", "Locate Blacksmith"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiBlacksmithPos[0] = Int($aPos[0])
			$g_aiBlacksmithPos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiBlacksmithPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Blacksmith Location Not Valid!" & @CRLF
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
						SetDebugLog(" Operator Error - Bad Blacksmith Location.", $COLOR_DEBUG)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Blacksmith Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		Local $sBlacksmithInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $sBlacksmithInfo[0] > 1 Or $sBlacksmithInfo[0] = "" Then
			If StringInStr($sBlacksmithInfo[1], "smith") = 0 Then
				Local $sLocMsg = ($sBlacksmithInfo[0] = "" ? "Nothing" : $sBlacksmithInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Blacksmith?, It was a " & $sLocMsg & @CRLF
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
						SetDebugLog("Ok, you really think that's a Blacksmith?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_DEBUG)
						ClearScreen()
						ExitLoop
				EndSelect
			EndIf
		Else
			SetDebugLog(" Operator Error - Bad Blacksmith Location: " & "(" & $g_aiBlacksmithPos[0] & "," & $g_aiBlacksmithPos[1] & ")", $COLOR_DEBUG)
			$g_aiBlacksmithPos[0] = -1
			$g_aiBlacksmithPos[1] = -1
			ClearScreen()
			Return False
		EndIf
		$g_aiBlacksmithPos[2] = $sBlacksmithInfo[2]
		SetLog("Blacksmith Detected: (" & $g_aiBlacksmithPos[0] & "," & $g_aiBlacksmithPos[1] & "), Level: " & $g_aiBlacksmithPos[2], $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()
	Return True

EndFunc   ;==>_LocateBlacksmith

; Image Search for Blacksmith
; #FUNCTION# ===========================================================================================================
; Name ..........: ImgLocateBlacksmith
; Description ...: Confirms local image candidates by building name, then retries across the full village.
; Remarks .......: Commits coordinates only after confirmation.
; ======================================================================================================================
Func ImgLocateBlacksmith($bSilent = False, $bKeepSelected = False, $aPreviousPos = Default)

	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\Home Village\Blacksmith\"
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
				If UBound($aInfo) >= 3 Then $bConfirmed = StringInStr($aInfo[1], "Blacksmith") > 0
			EndIf
			If Not $bConfirmed Then
				ClearScreen()
				ContinueLoop
			EndIf
			If _Sleep($DELAYIMGLOCATE1) Then Return False
			$g_aiBlacksmithPos[0] = $aPoint[0]
			$g_aiBlacksmithPos[1] = $aPoint[1]
			$g_aiBlacksmithPos[2] = $aInfo[2]
			If $bSilent Then SetLog("Blacksmith Detected: (" & $aPoint[0] & "," & $aPoint[1] & ")", $COLOR_SUCCESS)
			If Not $bKeepSelected Then ClearScreen()
			Return True
		Next
	Next
	If Not $bSilent Then SetDebugLog("Couldn't confirm Blacksmith on main village", $COLOR_DEBUG)
	If $g_bDebugImageSave Then SaveDebugImage("Blacksmith", False)
	Return False
EndFunc   ;==>ImgLocateBlacksmith
