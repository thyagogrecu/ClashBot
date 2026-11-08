; #FUNCTION# ====================================================================================================================
; Name ..........: MakeScreenshot
; Description ...: This file creates a snapshot of the user base
; Syntax ........: MakeScreenshot($TargetDir[, $type = "jpg"])
; Parameters ....: $TargetDir           - required - location to save file
;                  $type                - [optional] string - type of image to save ("jpg", "png", "bmp"). Default is "jpg".
; Return values .: None
; Author ........: Sardo (2015-06)
; Modified ......: Hervidero, ProMac (2015-10), MonkeyHunter (2016-2)
; Remarks .......: This file is part of MyBot Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func MakeScreenshot($TargetDir, $type = "jpg")

	Local $sTargetDir = $TargetDir
	If StringRight($sTargetDir, 1) <> "\" And StringRight($sTargetDir, 1) <> "/" Then $sTargetDir &= "\"
	If Not FileExists($sTargetDir) Then
		If DirCreate($sTargetDir) = 0 Then
			SetLog("Screenshot folder not created: " & $sTargetDir, $COLOR_ERROR)
			$g_bMakeScreenshotNow = False
			Return
		EndIf
	EndIf

	If WinGetAndroidHandle() <> 0 Then

		Local $SuspendMode
		Local $iLeft = 0, $iTop = 0, $iRight = $g_iAndroidClientWidth, $iBottom = $g_iAndroidClientHeight ; set size of ENTIRE screen to save
		Local $iW = Number($iRight) - Number($iLeft)
		Local $iH = Number($iBottom) - Number($iTop)
		Local $hHBitmapScreenshot = _CaptureRegion($iLeft, $iTop, $iRight, $iBottom, True)
		Local $hBitmapScreenshot = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmapScreenshot)
		Local $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmapScreenshot) ; Get graphics content from bitmap image
		Local $hBrush = _GDIPlus_BrushCreateSolid(0xFF000029) ;create a brush AARRGGBB (using 0x000029 = Dark Blue)
		Local $bIsMainVillageScreenshot = _ColorCheck( _
				Hex(_GDIPlus_BitmapGetPixel($hBitmapScreenshot, $aIsMain[0], $aIsMain[1]), 6), _
				Hex($aIsMain[2], 6), $aIsMain[3])

	    If $g_bScreenshotHideName Then
			_GDIPlus_GraphicsFillRect($hGraphic, 0, 0, 250, 63, $hBrush) ;draw filled rectangle on the image to hide the user IGN
			If $bIsMainVillageScreenshot Then
				If $g_aiClanCastlePos[0] = -1 Or $g_aiClanCastlePos[1] = -1 Then
					SetLog("Screenshot warning: Locate the Clan Castle to hide the clanname!", $COLOR_ERROR)
				Else
					Local $xCC = $g_aiClanCastlePos[0]
					Local $yCC = $g_aiClanCastlePos[1]
					ConvertToVillagePos($xCC, $yCC)
					_GDIPlus_GraphicsFillRect($hGraphic, $xCC - 31, $yCC - 3, 66, 20, $hBrush) ; hide Clan Castle name only on the home village
				EndIf
			EndIf
		EndIf
		Local $Date = @YEAR & "-" & @MON & "-" & @MDAY
		Local $Time = @HOUR & "." & @MIN & "." & @SEC
		Local $filename = $Date & "_" & $Time & "." & $type  ; most systems support type = png, jpg, bmp, gif, tif
		_GDIPlus_ImageSaveToFile($hBitmapScreenshot, $sTargetDir & $filename)
		If FileExists($sTargetDir & $filename) = 1 Then
			If $g_sProfileTempPath = $sTargetDir Then
				SetLog("Screenshot saved: .\Profiles\" & $g_sProfileCurrentName & "\Temp\" & $filename)
			Else
				SetLog("Screenshot saved: " & $sTargetDir & $filename)
			EndIf
		Else
			SetLog("Screenshot file not created: " & $sTargetDir & $filename, $COLOR_ERROR)
		EndIf
		$g_bMakeScreenshotNow = False
		;reduce mem
		_GDIPlus_BrushDispose($hBrush)
		_GDIPlus_GraphicsDispose($hGraphic)
		_GDIPlus_BitmapDispose($hBitmapScreenshot)
		_WinAPI_DeleteObject($hHBitmapScreenshot)

	Else
		SetLog("Not in game", $COLOR_ERROR)
	EndIf

EndFunc   ;==>MakeScreenshot
