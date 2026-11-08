; #FUNCTION# ====================================================================================================================
; Name ..........: LocateHelperHut
; Description ...:
; Syntax ........: LocateHelperHut()
; Parameters ....:
; Return values .: None
; Author ........: Moebius14 (Nov 2024)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateHelperHut($bCollect = True, $bAutoOnly = False, $bManualOnly = False)
	If $g_iTownHallLevel < 9 Then
		SetLog("Townhall Level " & $g_iTownHallLevel & " has no Helper Hut, so skip locating", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aPreviousHelperHutPos[2] = [$g_aiHelperHutPos[0], $g_aiHelperHutPos[1]]
	$g_aiHelperHutPos[0] = -1
	$g_aiHelperHutPos[1] = -1

	If Not $bManualOnly Then
		; auto locate
		If ImgLocateHelperHut(False, False, $aPreviousHelperHutPos) Then
			SetLog("Helper Hut Detected: (" & $g_aiHelperHutPos[0] & "," & $g_aiHelperHutPos[1] & ")", $COLOR_SUCCESS)
			Return True
		EndIf

	EndIf

	If $bAutoOnly Then
		$g_aiHelperHutPos[0] = $aPreviousHelperHutPos[0]
		$g_aiHelperHutPos[1] = $aPreviousHelperHutPos[1]
		Return False
	EndIf

	If Not isInsideDiamond($aPreviousHelperHutPos) Then LogUnknownBuildingPosition("Helper Hut")

	If Not _LocateHelperHut($bCollect) Then
		$g_aiHelperHutPos[0] = $aPreviousHelperHutPos[0]
		$g_aiHelperHutPos[1] = $aPreviousHelperHutPos[1]
		Return False
	EndIf

	Return True
EndFunc   ;==>LocateHelperHut

Func _LocateHelperHut($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	WinGetAndroidHandle()
	checkMainScreen(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_HelperHut_01", "Click OK then click on your Helper Hut") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_HelperHut_02", "Locate Helper Hut"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiHelperHutPos[0] = Int($aPos[0])
			$g_aiHelperHutPos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiHelperHutPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Helper Hut Location Not Valid!" & @CRLF
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
						SetDebugLog(" Operator Error - Bad Helper Hut Location.", $COLOR_DEBUG)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Helper Hut Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		Local $sHelperHutInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $sHelperHutInfo[0] > 1 Or $sHelperHutInfo[0] = "" Then
			If StringInStr($sHelperHutInfo[1], "Helper") = 0 Then
				Local $sLocMsg = ($sHelperHutInfo[0] = "" ? "Nothing" : $sHelperHutInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Helper Hut?, It was a " & $sLocMsg & @CRLF
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
						SetDebugLog("Ok, you really think that's a Helper Hut?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_DEBUG)
						ClearScreen()
						ExitLoop
				EndSelect
			EndIf
		Else
			SetDebugLog(" Operator Error - Bad Helper Hut Location: " & "(" & $g_aiHelperHutPos[0] & "," & $g_aiHelperHutPos[1] & ")", $COLOR_DEBUG)
			$g_aiHelperHutPos[0] = -1
			$g_aiHelperHutPos[1] = -1
			ClearScreen()
			Return False
		EndIf
		SetLog("Helper Hut Detected: (" & $g_aiHelperHutPos[0] & "," & $g_aiHelperHutPos[1] & ")", $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()
	Return True

EndFunc   ;==>_LocateHelperHut

; Image Search for Helper Hut
; #FUNCTION# ===========================================================================================================
; Name ..........: ImgLocateHelperHut
; Description ...: Confirms local image candidates by building name, then retries across the full village.
; Remarks .......: Commits coordinates only after confirmation.
; ======================================================================================================================
Func ImgLocateHelperHut($bSilent = False, $bKeepSelected = False, $aPreviousPos = Default)

	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\Home Village\HelperHut\"
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
				If UBound($aInfo) >= 3 Then $bConfirmed = StringInStr($aInfo[1], "Helper") > 0
			EndIf
			If Not $bConfirmed Then
				ClearScreen()
				ContinueLoop
			EndIf
			If _Sleep($DELAYIMGLOCATE1) Then Return False
			$g_aiHelperHutPos[0] = $aPoint[0]
			$g_aiHelperHutPos[1] = $aPoint[1]

			If $bSilent Then SetLog("Helper Hut Detected: (" & $aPoint[0] & "," & $aPoint[1] & ")", $COLOR_SUCCESS)
			If Not $bKeepSelected Then ClearScreen()
			Return True
		Next
	Next
	If Not $bSilent Then SetDebugLog("Couldn't confirm Helper Hut on main village", $COLOR_DEBUG)
	If $g_bDebugImageSave Then SaveDebugImage("HelperHut", False)
	Return False
EndFunc   ;==>ImgLocateHelperHut
