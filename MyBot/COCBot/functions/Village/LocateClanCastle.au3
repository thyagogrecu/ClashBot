
; #FUNCTION# ====================================================================================================================
; Name ..........: LocateClanCastle
; Description ...: Locates Clan Castle manually (Temporary)
; Syntax ........: LocateClanCastle()
; Parameters ....:
; Return values .: None
; Author ........:
; Modified ......: KnowJack (06/2015) Sardo (08/2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateClanCastle($bCollect = True, $bAutoOnly = False, $bManualOnly = False)
	Local $aSavedPosition = $g_aiClanCastlePos
	Local $iSavedTroops = $g_aiClanCastleTroopsCap, $iSavedSpells = $g_aiClanCastleSpellsCap
	Local $bResult = ClanCastleLocationCore($bCollect, $bAutoOnly, $bManualOnly)
	If Not $bResult Then
		$g_aiClanCastlePos = $aSavedPosition
		$g_aiClanCastleTroopsCap = $iSavedTroops
		$g_aiClanCastleSpellsCap = $iSavedSpells
	EndIf
	Return $bResult
EndFunc   ;==>LocateClanCastle

; #FUNCTION# ===========================================================================================================
; Name ..........: ClanCastleLocationCore
; Description ...: Runs location while the caller restores state on failure or cancellation.
; ======================================================================================================================
Func ClanCastleLocationCore($bCollect = True, $bAutoOnly = False, $bManualOnly = False)
	Local $stext, $MsgBox, $iSilly = 0, $iStupid = 0, $sErrorText = "", $sInfo

	WinGetAndroidHandle()
	checkMainScreen(False)

	Local $aPreviousClanCastlePos[2] = [$g_aiClanCastlePos[0], $g_aiClanCastlePos[1]]
	Local $iPreviousClanCastleTroopsCap = $g_aiClanCastleTroopsCap
	Local $iPreviousClanCastleSpellsCap = $g_aiClanCastleSpellsCap
	$g_aiClanCastlePos[0] = -1
	$g_aiClanCastlePos[1] = -1

	If Not $bManualOnly Then
		If ImgLocateClanCastle($aPreviousClanCastlePos) Then Return True

	EndIf

	$g_aiClanCastlePos[0] = $aPreviousClanCastlePos[0]
	$g_aiClanCastlePos[1] = $aPreviousClanCastlePos[1]
	$g_aiClanCastleTroopsCap = $iPreviousClanCastleTroopsCap
	$g_aiClanCastleSpellsCap = $iPreviousClanCastleSpellsCap
	If $bAutoOnly Then Return False
	If Not isInsideDiamond($aPreviousClanCastlePos) Then LogUnknownBuildingPosition("Clan Castle")

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 500)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Clan_Castle_01", "Click OK then click on your Clan Castle") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", "Do not move mouse quickly after clicking location") & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", "Make sure the building name is visible for me!") & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Clan_Castle_02", "Locate Clan Castle"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiClanCastlePos[0] = $aPos[0]
			$g_aiClanCastlePos[1] = $aPos[1]
			If Not isInsideDiamond($g_aiClanCastlePos) Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Clan Castle Location Not Valid!" & @CRLF
						SetDebugLog("Location not valid, try again", $COLOR_DEBUG)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, why did you click @ (" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")?" & @CRLF & "  Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetDebugLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_DEBUG)
						$g_aiClanCastlePos[0] = -1
						$g_aiClanCastlePos[1] = -1
						ClearScreen()
						Return False
					Case Else
						SetDebugLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_DEBUG)
						$g_aiClanCastlePos[0] = -1
						$g_aiClanCastlePos[1] = -1
						ClearScreen()
						Return False
				EndSelect
			EndIf

		Else
			SetLog("Locate Clan Castle Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		$sInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY) ; 860x780
		If IsArray($sInfo) And ($sInfo[0] > 1 Or $sInfo[0] = "") Then
			If StringInStr($sInfo[1], "clan") = 0 Then
				Local $sLocMsg = ($sInfo[0] = "" ? "Nothing" : $sInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Clan Castle?, It was a " & $sLocMsg & @CRLF
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
						SetDebugLog("Quit joking, click the Clan Castle or restart bot and try again", $COLOR_DEBUG)
						$g_aiClanCastlePos[0] = -1
						$g_aiClanCastlePos[1] = -1
						ClearScreen()
						Return False
				EndSelect
			EndIf
			If $sInfo[2] = "Broken" Then
				SetLog("You did not rebuild your Clan Castle yet", $COLOR_ACTION)
			Else
				SetLog("Clan Castle Detected: (" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & "), Level: " & $sInfo[2], $COLOR_SUCCESS)
				SetClanCastleCapacity($sInfo[2])
			EndIf
		Else
			SetDebugLog(" Operator Error - Bad Clan Castle Location: " & "(" & $g_aiClanCastlePos[0] & "," & $g_aiClanCastlePos[1] & ")", $COLOR_DEBUG)
			$g_aiClanCastlePos[0] = -1
			$g_aiClanCastlePos[1] = -1
			ClearScreen()
			Return False
		EndIf
		ExitLoop
	WEnd

	ClearScreen()
	Return True
EndFunc   ;==>ClanCastleLocationCore

; #FUNCTION# ===========================================================================================================
; Name ..........: ImgLocateClanCastle
; Description ...: Confirms local image candidates by building name, then retries across the full village.
; Remarks .......: Commits coordinates only after confirmation.
; ======================================================================================================================
Func ImgLocateClanCastle($aPreviousPos = Default)
	ZoomOut()
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\Home Village\ClanCastle\"
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
				If UBound($aInfo) >= 3 Then $bConfirmed = StringInStr($aInfo[1], "clan") > 0
			EndIf
			If Not $bConfirmed Then
				ClearScreen()
				ContinueLoop
			EndIf
			If _Sleep($DELAYIMGLOCATE1) Then Return False
			$g_aiClanCastlePos[0] = $aPoint[0]
			$g_aiClanCastlePos[1] = $aPoint[1]

			If $aInfo[2] = "Broken" Then
				SetLog("You did not rebuild your Clan Castle yet", $COLOR_ACTION)
			Else
				SetLog("Clan Castle Detected: (" & $aPoint[0] & "," & $aPoint[1] & "), Level: " & $aInfo[2], $COLOR_SUCCESS)
				SetClanCastleCapacity($aInfo[2])
			EndIf
			ClearScreen()
			Return True
		Next
	Next
	SetDebugLog("Couldn't confirm Clan Castle on main village", $COLOR_DEBUG)
	If $g_bDebugImageSave Then SaveDebugImage("ClanCastle", False)
	Return False
EndFunc   ;==>ImgLocateClanCastle

Func SetClanCastleCapacity($iClanCastleLevel)
	Switch $iClanCastleLevel
		Case 1
			$g_aiClanCastleTroopsCap = 10
			$g_aiClanCastleSpellsCap = 0
		Case 2
			$g_aiClanCastleTroopsCap = 15
			$g_aiClanCastleSpellsCap = 0
		Case 3
			$g_aiClanCastleTroopsCap = 20
			$g_aiClanCastleSpellsCap = 0
		Case 4
			$g_aiClanCastleTroopsCap = 25
			$g_aiClanCastleSpellsCap = 1
		Case 5
			$g_aiClanCastleTroopsCap = 30
			$g_aiClanCastleSpellsCap = 1
		Case 6
			$g_aiClanCastleTroopsCap = 35
			$g_aiClanCastleSpellsCap = 1
		Case 7
			$g_aiClanCastleTroopsCap = 35
			$g_aiClanCastleSpellsCap = 2
		Case 8
			$g_aiClanCastleTroopsCap = 40
			$g_aiClanCastleSpellsCap = 2
		Case 9
			$g_aiClanCastleTroopsCap = 45
			$g_aiClanCastleSpellsCap = 2
		Case 10
			$g_aiClanCastleTroopsCap = 45
			$g_aiClanCastleSpellsCap = 3
		Case 11, 12
			$g_aiClanCastleTroopsCap = 50
			$g_aiClanCastleSpellsCap = 3
		Case 13
			$g_aiClanCastleTroopsCap = 55
			$g_aiClanCastleSpellsCap = 3
		Case 14
			$g_aiClanCastleTroopsCap = 55
			$g_aiClanCastleSpellsCap = 4
		Case Else
			SetLog("Unknown Clan Castle Level: " & $iClanCastleLevel, $COLOR_WARNING)
	EndSwitch
EndFunc   ;==>SetClanCastleCapacity
