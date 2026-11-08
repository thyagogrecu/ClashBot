; #FUNCTION# ====================================================================================================================
; Name ..........: GetBuildingEdge, BuildingXY
; Description ...: GetBuildingEdge, BuildingXY: To detect the edge of the enemy base the DE STorage or Townhall is on, when Redline is not used.
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Knowskones (2015)
; Modified ......: Hervidero (2015), CodeSlinger69 (01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_iBuildingLoc = 0, $g_iBuildingLocX = 0, $g_iBuildingLocY = 0

Func GetBuildingEdge($TypeBuilding = $eSideBuildingDES) ;Using $g_iBuildingLoc x y we are finding which side the building is located, only needed when not using redline.
	Local $TypeBuildingName

	BuildingXY($TypeBuilding) ; Get XY coord for Building

	Switch $TypeBuilding
		Case $eSideBuildingDES
			$TypeBuildingName = "DE Storage"
		Case $eSideBuildingTH
			$TypeBuildingName = "TownHall"
	EndSwitch

	If $g_iBuildingLoc = 1 Then
		If ($g_iBuildingLocX = 430) And ($g_iBuildingLocY = 313) Then
			SetLog($TypeBuildingName & " Located in Middle... Attacking Random Side", $COLOR_INFO)
			$g_iBuildingEdge = (Random(Round(0, 3)))
		ElseIf ($g_iBuildingLocX >= 430) And ($g_iBuildingLocY >= 313) Then
			SetLog($TypeBuildingName & " Located Bottom Right... Attacking Bottom Right", $COLOR_INFO)
			$g_iBuildingEdge = 0
		ElseIf ($g_iBuildingLocX > 430) And ($g_iBuildingLocY < 313) Then
			SetLog($TypeBuildingName & " Located Top Right... Attacking Top Right", $COLOR_INFO)
			$g_iBuildingEdge = 3
		ElseIf ($g_iBuildingLocX <= 430) And ($g_iBuildingLocY <= 313) Then
			SetLog($TypeBuildingName & " Located Top Left... Attacking Top Left", $COLOR_INFO)
			$g_iBuildingEdge = 1
		ElseIf ($g_iBuildingLocX < 430) And ($g_iBuildingLocY > 313) Then
			SetLog($TypeBuildingName & " Located Bottom Left... Attacking Bottom Left", $COLOR_INFO)
			$g_iBuildingEdge = 2
		EndIf
	ElseIf $g_iBuildingLoc = 0 Then
		SetLog($TypeBuildingName & " Not Located... Attacking Random Side", $COLOR_INFO)
		$g_iBuildingEdge = (Random(Round(0, 3)))
	EndIf
EndFunc   ;==>GetBuildingEdge

Func BuildingXY($TypeBuilding = $eSideBuildingDES)
	Local $TypeBuildingName

	; USES OLD OPENCV DETECTION
	_CaptureRegion2(230, 170, 630, 440)
	Switch $TypeBuilding
		Case $eSideBuildingDES
			$TypeBuildingName = "DE Storage"
			$g_iBuildingToLoc = GetLocationDarkElixirStorage()
		Case $eSideBuildingTH
			$TypeBuildingName = "TownHall"
			$g_iBuildingToLoc = GetLocationTownHall()
	EndSwitch

	Local $pixel
	If (UBound($g_iBuildingToLoc) > 1) Then
		Local $centerPixel[2] = [430, 313]
		Local $arrPixelCloser = _FindPixelCloser($g_iBuildingToLoc, $centerPixel, 1)
		$pixel = $arrPixelCloser[0]
	ElseIf (UBound($g_iBuildingToLoc) > 0) Then
		$pixel = $g_iBuildingToLoc[0]
	Else
		$pixel = -1
	EndIf

	If $pixel = -1 Then
		$g_iBuildingLoc = 0
		SetLog(" == " & $TypeBuildingName & " Not Found ==")
	Else
		$pixel[0] += 230 ; compensate CaptureRegion reduction
		$pixel[1] += 170 ; compensate CaptureRegion reduction
		SetLog("== " & $TypeBuildingName & " : [" & $pixel[0] & "," & $pixel[1] & "] ==", $COLOR_INFO)
		If _Sleep(1000) Then Return False
		$g_iBuildingLocX = $pixel[0] ; compensation for $x center
		$g_iBuildingLocY = $pixel[1] ; compensation for $y center
		$g_iBuildingLoc = 1
	EndIf
EndFunc   ;==>BuildingXY
