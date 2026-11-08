; #FUNCTION# ====================================================================================================================
; Name ..........: LocateHeroHall
; Description ...:
; Syntax ........: LocateHeroHall
; Parameters ....:
; Return values .: None
; Author ........: ProMac(07/2015)
; Modified ......: Moebius14(11/2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateHeroHall($bCollect = True, $bAutoOnly = False, $bManualOnly = False)
	If $g_iTownHallLevel < 7 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Hero Hall, so skip locating.", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aPreviousHeroHallPos[3] = [$g_aiHeroHallPos[0], $g_aiHeroHallPos[1], $g_aiHeroHallPos[2]]
	$g_aiHeroHallPos[0] = -1
	$g_aiHeroHallPos[1] = -1
	$g_aiHeroHallPos[2] = -1

	If Not $bManualOnly Then
		; auto locate
		If ImgLocateHeroHall(False, False, $aPreviousHeroHallPos) Then
			SetLog("Hero Hall Detected: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level: " & $g_aiHeroHallPos[2], $COLOR_SUCCESS)
			Return True
		EndIf

	EndIf

	If $bAutoOnly Then
		$g_aiHeroHallPos[0] = $aPreviousHeroHallPos[0]
		$g_aiHeroHallPos[1] = $aPreviousHeroHallPos[1]
		$g_aiHeroHallPos[2] = $aPreviousHeroHallPos[2]
		Return False
	EndIf

	If Not isInsideDiamond($aPreviousHeroHallPos) Then LogUnknownBuildingPosition("Hero Hall")

	If Not _LocateHeroHall($bCollect) Then
		$g_aiHeroHallPos[0] = $aPreviousHeroHallPos[0]
		$g_aiHeroHallPos[1] = $aPreviousHeroHallPos[1]
		$g_aiHeroHallPos[2] = $aPreviousHeroHallPos[2]
		Return False
	EndIf

	SetLog("Hero Hall Detected: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level: " & $g_aiHeroHallPos[2], $COLOR_SUCCESS)
	Return True

EndFunc   ;==>LocateHeroHall

Func _LocateHeroHall($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	WinGetAndroidHandle()
	checkMainScreen(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_HeroHall_01", "Click OK then click on your Hero Hall") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_HeroHall_02", "Locate Hero Hall"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiHeroHallPos[0] = Int($aPos[0])
			$g_aiHeroHallPos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiHeroHallPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Hero Hall Location Not Valid!" & @CRLF
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
						SetDebugLog(" Operator Error - Bad Hero Hall Location.", $COLOR_DEBUG)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Hero Hall Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $sHeroHallInfo[0] > 1 Or $sHeroHallInfo[0] = "" Then
			If StringInStr($sHeroHallInfo[1], "Hero") = 0 Then
				Local $sLocMsg = ($sHeroHallInfo[0] = "" ? "Nothing" : $sHeroHallInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Hero Hall?, It was a " & $sLocMsg & @CRLF
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
						SetDebugLog("Ok, you really think that's a Hero Hall?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_DEBUG)
						ClearScreen()
						ExitLoop
				EndSelect
			Else
				$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
			EndIf
		Else
			SetDebugLog(" Operator Error - Bad Hero Hall Location: " & "(" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & ")", $COLOR_DEBUG)
			$g_aiHeroHallPos[0] = -1
			$g_aiHeroHallPos[1] = -1
			$g_aiHeroHallPos[2] = -1
			ClearScreen()
			Return False
		EndIf
		SetLog("Hero Hall Detected: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level: " & $g_aiHeroHallPos[2], $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()
	Return True

EndFunc   ;==>_LocateHeroHall

; Image Search for Hero Hall
; #FUNCTION# ===========================================================================================================
; Name ..........: ImgLocateHeroHall
; Description ...: Confirms local image candidates by building name, then retries across the full village.
; Remarks .......: Commits coordinates only after confirmation.
; ======================================================================================================================
Func ImgLocateHeroHall($bSilent = False, $bKeepSelected = False, $aPreviousPos = Default)
	ZoomOut()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\Home Village\HeroHall\"
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
				If UBound($aInfo) >= 3 Then $bConfirmed = StringInStr($aInfo[1], "Hero") > 0
			EndIf
			If Not $bConfirmed Then
				ClearScreen()
				ContinueLoop
			EndIf
			If _Sleep($DELAYIMGLOCATE1) Then Return False
			$g_aiHeroHallPos[0] = $aPoint[0]
			$g_aiHeroHallPos[1] = $aPoint[1]
			$g_aiHeroHallPos[2] = $aInfo[2]
			If $bSilent Then SetLog("Hero Hall Detected: (" & $aPoint[0] & "," & $aPoint[1] & ")", $COLOR_SUCCESS)
			If Not $bKeepSelected Then ClearScreen()
			Return True
		Next
	Next
	If Not $bSilent Then SetDebugLog("Couldn't confirm Hero Hall on main village", $COLOR_DEBUG)
	If $g_bDebugImageSave Then SaveDebugImage("HeroHall", False)
	Return False
EndFunc   ;==>ImgLocateHeroHall
