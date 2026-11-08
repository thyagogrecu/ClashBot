
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateTownHall
; Description ...: Locates TownHall
; Syntax ........: LocateTownHall()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (July 2015) Sardo 2015-08
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateTownHall($bLocationOnly = False, $bCollect = True, $bAutoOnly = False, $bManualOnly = False)
	Local $aSavedPosition = $g_aiTownHallPos
	Local $iSavedLevel = $g_iTownHallLevel
	Local $bResult = TownHallLocationCore($bLocationOnly, $bCollect, $bAutoOnly, $bManualOnly)
	If Not $bResult Then
		$g_aiTownHallPos = $aSavedPosition
		$g_iTownHallLevel = $iSavedLevel
	EndIf
	Return $bResult
EndFunc   ;==>LocateTownHall

; #FUNCTION# ===========================================================================================================
; Name ..........: TownHallLocationCore
; Description ...: Runs location while the caller restores state on failure or cancellation.
; ======================================================================================================================
Func TownHallLocationCore($bLocationOnly = False, $bCollect = True, $bAutoOnly = False, $bManualOnly = False)

	Local $sMsgBoxText, $MsgBox, $bGotTHLevel, $sLocMsg
	Local $iStupid = 0, $iSilly = 0, $sErrorText = ""

	WinGetAndroidHandle()
	checkMainScreen(False)

	Local $aPreviousTownHallPos[2] = [$g_aiTownHallPos[0], $g_aiTownHallPos[1]]
	Local $iPreviousTownHallLevel = $g_iTownHallLevel
	$g_aiTownHallPos[0] = -1
	$g_aiTownHallPos[1] = -1

	If Not $bManualOnly Then
		Local $bLocalTHSearch = False
		If $aPreviousTownHallPos[0] > 0 And $aPreviousTownHallPos[1] > 0 Then
			Local $iLeft = $aPreviousTownHallPos[0] - 90
			Local $iTop = $aPreviousTownHallPos[1] - 90
			Local $iRight = $aPreviousTownHallPos[0] + 90
			Local $iBottom = $aPreviousTownHallPos[1] + 90
			If $iLeft < 0 Then $iLeft = 0
			If $iTop < 0 Then $iTop = 0
			If $iRight > $g_iGAME_WIDTH Then $iRight = $g_iGAME_WIDTH
			If $iBottom > $g_iGAME_HEIGHT Then $iBottom = $g_iGAME_HEIGHT
			Local $sLocalArea = GetDiamondFromRect2($iLeft, $iTop, $iRight, $iBottom)
			imglocTHSearch(True, True, True, $sLocalArea, True)
			$bLocalTHSearch = True
		EndIf
		If Not isInsideDiamond($g_aiTownHallPos) Then imglocTHSearch(True, True, Not $bLocalTHSearch)
		If isInsideDiamond($g_aiTownHallPos) Then
			If $bLocationOnly Then
				SetLog("Town Hall Detected: (" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & "), Level: " & $g_iTownHallLevel, $COLOR_SUCCESS)
				ClearScreen()
				Return True
			EndIf
			BuildingClickP($g_aiTownHallPos, "#0349")
			If _Sleep($DELAYIMGLOCATE1) Then Return False
			$bGotTHLevel = GetTownHallLevel()
			If Not IsArray($bGotTHLevel) And $bGotTHLevel Then Return True
			ClearScreen()
		EndIf

	EndIf

	$g_aiTownHallPos[0] = $aPreviousTownHallPos[0]
	$g_aiTownHallPos[1] = $aPreviousTownHallPos[1]
	$g_iTownHallLevel = $iPreviousTownHallLevel
	If $bAutoOnly Then Return False
	If Not isInsideDiamond($aPreviousTownHallPos) Then LogUnknownBuildingPosition("Town Hall")

	While 1
		_ExtMsgBoxSet(1 + 64, 1, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$sMsgBoxText = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_TownHall_01", "Click OK then click on your Town Hall") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_TownHall_02", "Locate TownHall"), $sMsgBoxText, 30)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiTownHallPos[0] = $aPos[0]
			$g_aiTownHallPos[1] = $aPos[1]
			If _Sleep($DELAYLOCATETH1) Then Return False
			If Not isInsideDiamond($g_aiTownHallPos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "TownHall Location not valid!" & @CRLF
						SetDebugLog("Location not valid, try again", $COLOR_DEBUG)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & ")?" & @CRLF & "Please stop!" & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetDebugLog(" Operator Error - Bad TownHall Location: " & "(" & $g_aiTownHallPos[0] & "," & $g_aiTownHallPos[1] & ")", $COLOR_DEBUG)
						$g_aiTownHallPos[0] = -1
						$g_aiTownHallPos[1] = -1
						ClearScreen()
						Return False
				EndSelect
			EndIf

		Else
			SetLog("Locate TownHall Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		If Not $bLocationOnly Then
			$bGotTHLevel = GetTownHallLevel() ; Get/Save the users updated TH level
			$iSilly += 1
			If IsArray($bGotTHLevel) Or Not $bGotTHLevel Then
				If Not $bGotTHLevel Then
					$sLocMsg = "Nothing"
				Else
					$sLocMsg = $bGotTHLevel[1]
				EndIf
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not a TownHall?, It was a " & $sLocMsg & @CRLF
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
						SetDebugLog("Quit joking, Click on the TH, or restart bot and try again", $COLOR_DEBUG)
						$g_aiTownHallPos[0] = -1
						$g_aiTownHallPos[1] = -1
						ClearScreen()
						Return False
				EndSelect
			EndIf
		EndIf
		ExitLoop
	WEnd

	ClearScreen()
	Return True

EndFunc   ;==>TownHallLocationCore
