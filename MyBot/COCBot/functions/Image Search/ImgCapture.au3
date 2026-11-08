; #FUNCTION# ===========================================================================================================
; Name ..........: Image Capture
; Author ........: Phael
; Description ...: Captures PNG or BMP markers from the current game screen for imgxml.
; Remarks .......: Stores reference coordinates and matching tolerance in the filename.
; ======================================================================================================================

; === MANUAL IMAGE CAPTURE ===
Func ImgCapture($sCode, $iX, $iY, $iSize = 32, $iIndex = 0, $iMatch = 92, $bOverwrite = False, $sFormat = "png")
	Local $hBitmap = ImgCaptureCreateScreenBitmap()
	If $hBitmap = 0 Then
		SetLog("[ImgCapture] Could not create bitmap from capture", $COLOR_ERROR)
		Return SetError(5, 0, "")
	EndIf

	Local $sSaved = ImgCaptureFromBitmap($hBitmap, $sCode, $iX, $iY, $iSize, $iIndex, $iMatch, $bOverwrite, $sFormat)
	_GDIPlus_BitmapDispose($hBitmap)

	If $sSaved = "" Then Return SetError(@error, 0, "")
	Return $sSaved
EndFunc   ;==>ImgCapture

Func ImgCaptureFromBitmap($hBitmap, $sCode, $iX, $iY, $iSize = 32, $iIndex = 0, $iMatch = 92, $bOverwrite = False, $sFormat = "png")
	$sCode = ImgCaptureCode($sCode)
	If $sCode = "" Then
		SetLog("[ImgCapture] Invalid image prefix", $COLOR_ERROR)
		Return SetError(1, 0, "")
	EndIf

	$iX = Int($iX)
	$iY = Int($iY)
	Local $aSize = ImgCaptureParseSize($iSize)
	If Not IsArray($aSize) Then
		SetLog("[ImgCapture] Invalid marker size: " & $iSize, $COLOR_ERROR)
		Return SetError(2, 0, "")
	EndIf
	Local $iLeft = $iX - Int($aSize[0] / 2)
	Local $iTop = $iY - Int($aSize[1] / 2)
	If $iLeft < 0 Or $iTop < 0 Or ($iLeft + $aSize[0]) > $g_iGAME_WIDTH Or ($iTop + $aSize[1]) > $g_iGAME_HEIGHT Then
		SetLog("[ImgCapture] Marker is outside game bounds: " & $iX & "," & $iY, $COLOR_ERROR)
		Return SetError(3, 0, "")
	EndIf

	If $hBitmap = 0 Then
		SetLog("[ImgCapture] Invalid frozen bitmap", $COLOR_ERROR)
		Return SetError(5, 0, "")
	EndIf

	Return ImgCaptureSaveFromBitmap($hBitmap, $sCode, $iX, $iY, $iSize, $iIndex, $iMatch, $bOverwrite, $sFormat)
EndFunc   ;==>ImgCaptureFromBitmap

; === SCENERY CAPTURE ===
Func CaptureScenery($sCode = "CS", $iX = Default, $iY = Default, $iSize = 32, $iIndex = 0, $iMatch = 92, $bOverwrite = False, $sFormat = "png")
	If $iX = Default Or $iY = Default Then Return CaptureSceneryAuto($sCode, 2, $iSize, $iIndex, $iMatch, $bOverwrite, 0, 0, 0, 0, $sFormat)
	Return ImgCapture($sCode, $iX, $iY, $iSize, $iIndex, $iMatch, $bOverwrite, $sFormat)
EndFunc   ;==>CaptureScenery

; #FUNCTION# ===========================================================================================================
; Name ..........: CaptureSceneryAuto
; Description ...: Selects textured scenery points from the current game screen and saves image markers.
; Remarks .......: The default scan stays inside the VillageScenery search zone and below most interface controls.
; ======================================================================================================================

Func CaptureSceneryAuto($sCode = "CS", $iCount = 2, $iSize = 32, $iIndexOffset = 0, $iMatch = 92, $bOverwrite = False, $iLeft = 0, $iTop = 0, $iRight = 0, $iBottom = 0, $sFormat = "png")
	$sCode = ImgCaptureCode($sCode)
	If $sCode = "" Then
		SetLog("[CaptureScenery] Invalid scenery prefix", $COLOR_ERROR)
		Return SetError(1, 0, 0)
	EndIf

	$iCount = Int($iCount)
	$iSize = Int($iSize)
	If $iCount < 1 Or $iSize < 8 Then
		SetLog("[CaptureScenery] Invalid auto capture parameters", $COLOR_ERROR)
		Return SetError(2, 0, 0)
	EndIf

	If $iRight <= $iLeft Then $iRight = $g_iGAME_WIDTH
	If $iBottom <= $iTop Then $iBottom = $g_iGAME_HEIGHT

	Local $hBitmap = ImgCaptureCreateScreenBitmap()
	If $hBitmap = 0 Then
		SetLog("[CaptureScenery] Could not create bitmap from capture", $COLOR_ERROR)
		Return SetError(3, 0, 0)
	EndIf

	Local $aCandidates = CaptureSceneryFindCandidates($hBitmap, $iLeft, $iTop, $iRight, $iBottom, $iSize, $iCount)
	If Not IsArray($aCandidates) Or UBound($aCandidates, $UBOUND_ROWS) = 0 Then
		_GDIPlus_BitmapDispose($hBitmap)
		SetLog("[CaptureScenery] No dynamic scenery points found", $COLOR_ERROR)
		Return SetError(4, 0, 0)
	EndIf

	Local $iSaved = 0
	For $i = 0 To UBound($aCandidates, $UBOUND_ROWS) - 1
		Local $sCandidateCode = $sCode & ($i = 0 ? "" : $i + 1)
		If ImgCaptureSaveFromBitmap($hBitmap, $sCandidateCode, $aCandidates[$i][0], $aCandidates[$i][1], $iSize, $iIndexOffset, $iMatch, $bOverwrite, $sFormat) <> "" Then $iSaved += 1
	Next

	_GDIPlus_BitmapDispose($hBitmap)
	SetLog("[CaptureScenery] Auto Saved: " & $iSaved & "/" & UBound($aCandidates, $UBOUND_ROWS), ($iSaved > 0 ? $COLOR_SUCCESS : $COLOR_WARNING))
	Return $iSaved
EndFunc   ;==>CaptureSceneryAuto

; === SCENERY CANDIDATE SELECTION ===

Func CaptureSceneryFindCandidates($hBitmap, $iLeft, $iTop, $iRight, $iBottom, $iSize, $iCount)
	Local $iStep = 8
	Local $iHalf = Int($iSize / 2)
	Local $aPool[0][3]

	$iLeft = Int($iLeft)
	$iTop = Int($iTop)
	$iRight = Int($iRight)
	$iBottom = Int($iBottom)
	If $iLeft < 0 Then $iLeft = 0
	If $iTop < 0 Then $iTop = 0
	If $iRight > $g_iGAME_WIDTH Then $iRight = $g_iGAME_WIDTH
	If $iBottom > $g_iGAME_HEIGHT Then $iBottom = $g_iGAME_HEIGHT

	; Build a pool of valid textured points inside the scenery-safe polygons.
	For $y = $iTop + $iHalf To $iBottom - $iHalf Step $iStep
		For $x = $iLeft + $iHalf To $iRight - $iHalf Step $iStep
			If Not CaptureSceneryIsAllowedPoint($x, $y) Then ContinueLoop
			Local $iScore = CaptureSceneryPatchScore($hBitmap, $x - $iHalf, $y - $iHalf, $iSize)
			If $iScore <= 0 Then ContinueLoop
			CaptureSceneryAddPoolCandidate($aPool, $x, $y, $iScore)
		Next
	Next

	If UBound($aPool, $UBOUND_ROWS) = 0 Then Return SetError(1, 0, 0)

	Local $aChosen[0][3]
	Local $iMinDistance = Int($iSize * 1.5)
	Local $iMaxAttempts = UBound($aPool, $UBOUND_ROWS) * 4
	If $iMaxAttempts < 50 Then $iMaxAttempts = 50

	; Pick randomly from the valid pool so the generated markers do not repeat fixed coordinates.
	For $iAttempt = 1 To $iMaxAttempts
		Local $iPick = Random(0, UBound($aPool, $UBOUND_ROWS) - 1, 1)
		If Not CaptureSceneryIsFarEnough($aChosen, $aPool[$iPick][0], $aPool[$iPick][1], $iMinDistance) Then ContinueLoop

		Local $iRow = UBound($aChosen, $UBOUND_ROWS)
		ReDim $aChosen[$iRow + 1][3]
		$aChosen[$iRow][0] = $aPool[$iPick][0]
		$aChosen[$iRow][1] = $aPool[$iPick][1]
		$aChosen[$iRow][2] = $aPool[$iPick][2]
		If UBound($aChosen, $UBOUND_ROWS) >= $iCount Then ExitLoop
	Next

	If UBound($aChosen, $UBOUND_ROWS) = 0 Then Return SetError(2, 0, 0)
	Return $aChosen
EndFunc   ;==>CaptureSceneryFindCandidates

Func CaptureSceneryAddPoolCandidate(ByRef $aPool, $iX, $iY, $iScore)
	Local $iRows = UBound($aPool, $UBOUND_ROWS)
	ReDim $aPool[$iRows + 1][3]
	$aPool[$iRows][0] = $iX
	$aPool[$iRows][1] = $iY
	$aPool[$iRows][2] = $iScore
EndFunc   ;==>CaptureSceneryAddPoolCandidate

Func CaptureSceneryIsFarEnough(ByRef $aChosen, $iX, $iY, $iMinDistance)
	For $i = 0 To UBound($aChosen, $UBOUND_ROWS) - 1
		If Abs($iX - $aChosen[$i][0]) < $iMinDistance And Abs($iY - $aChosen[$i][1]) < $iMinDistance Then Return False
	Next

	Return True
EndFunc   ;==>CaptureSceneryIsFarEnough

; === SAFE SCENERY AREAS ===

Func CaptureSceneryIsAllowedPoint($iX, $iY)
	; Limit scenery captures to safe outside-scenery bands, away from ingame buttons.
	If Not CaptureSceneryInsideSafeArea($iX, $iY) Then Return False

	; Avoid the playable village diamond. Scenery markers should come from the outside scenery band.
	If CaptureSceneryInsideVillageDiamond($iX, $iY) Then Return False

	; Avoid HUD and buttons while keeping the marked scenery bands available.
	If $iY < 55 Then Return False
	If CaptureSceneryInsideRect($iX, $iY, 650, 0, 850, 205) Then Return False
	If CaptureSceneryInsideRect($iX, $iY, 0, 60, 95, 390) Then Return False
	If CaptureSceneryInsideRect($iX, $iY, 0, 620, 340, 730) Then Return False
	If CaptureSceneryInsideRect($iX, $iY, 775, 495, 850, 620) Then Return False
	If CaptureSceneryInsideRect($iX, $iY, 675, 620, 850, 730) Then Return False

	Return True
EndFunc   ;==>CaptureSceneryIsAllowedPoint

Func CaptureSceneryInsideSafeArea($iX, $iY)
	Local $aPolygons = StringSplit(CaptureScenerySafeAreaPolygons(), ";", $STR_NOCOUNT)
	For $i = 0 To UBound($aPolygons) - 1
		If CaptureSceneryInsidePolygon($iX, $iY, CaptureSceneryScalePolygon($aPolygons[$i])) Then Return True
	Next

	Return False
EndFunc   ;==>CaptureSceneryInsideSafeArea

Func CaptureScenerySafeAreaPolygons()
	; Coordinates are based on the normal 860x720 game view and scaled when needed.
	Local $sTopForest = "555,55|625,52|692,155|660,184|625,138|552,80"
	Local $sRightGrass = "760,205|860,235|860,285|815,280|760,242"
	Local $sBottomRightForest = "500,650|620,505|720,430|860,365|860,505|770,580|690,690|530,720"
	Local $sLeftRocks = "25,410|78,430|160,545|125,550|30,462"
	Local $sBottomLeftRocks = "190,540|245,535|285,585|262,615|195,582"

	Return $sTopForest & ";" & $sRightGrass & ";" & $sBottomRightForest & ";" & $sLeftRocks & ";" & $sBottomLeftRocks
EndFunc   ;==>CaptureScenerySafeAreaPolygons

Func CaptureSceneryScalePolygon($sPolygon)
	Local $aPoints = StringSplit($sPolygon, "|", $STR_NOCOUNT)
	Local $sScaled = ""
	For $i = 0 To UBound($aPoints) - 1
		Local $aPoint = StringSplit($aPoints[$i], ",", $STR_NOCOUNT)
		If UBound($aPoint) < 2 Then ContinueLoop
		Local $iScaledX = Int(Number($aPoint[0]) * $g_iGAME_WIDTH / 860)
		Local $iScaledY = Int(Number($aPoint[1]) * $g_iGAME_HEIGHT / 720)
		If $sScaled <> "" Then $sScaled &= "|"
		$sScaled &= $iScaledX & "," & $iScaledY
	Next

	Return $sScaled
EndFunc   ;==>CaptureSceneryScalePolygon

Func CaptureSceneryInsideVillageDiamond($iX, $iY)
	; Approximate the outer village diamond shown by the green reference lines:
	; top center, right center, bottom center, left center.
	Local $iCenterX = Int($g_iGAME_WIDTH / 2)
	Local $iCenterY = Int($g_iGAME_HEIGHT / 2)
	Local $iTopY = 0
	Local $iBottomY = $g_iGAME_HEIGHT - 10
	Local $iLeftX = 0
	Local $iRightX = $g_iGAME_WIDTH

	Local $sDiamond = $iCenterX & "," & $iTopY & "|" & $iRightX & "," & $iCenterY & "|" & $iCenterX & "," & $iBottomY & "|" & $iLeftX & "," & $iCenterY
	Return CaptureSceneryInsidePolygon($iX, $iY, $sDiamond)
EndFunc   ;==>CaptureSceneryInsideVillageDiamond

Func CaptureSceneryInsideRect($iX, $iY, $iLeft, $iTop, $iRight, $iBottom)
	Return $iX >= $iLeft And $iX <= $iRight And $iY >= $iTop And $iY <= $iBottom
EndFunc   ;==>CaptureSceneryInsideRect

Func CaptureSceneryInsidePolygon($iX, $iY, $sPolygon)
	Local $aPoints = StringSplit($sPolygon, "|", $STR_NOCOUNT)
	Local $bInside = False
	Local $j = UBound($aPoints) - 1

	For $i = 0 To UBound($aPoints) - 1
		Local $aPointI = StringSplit($aPoints[$i], ",", $STR_NOCOUNT)
		Local $aPointJ = StringSplit($aPoints[$j], ",", $STR_NOCOUNT)
		Local $xi = Number($aPointI[0])
		Local $yi = Number($aPointI[1])
		Local $xj = Number($aPointJ[0])
		Local $yj = Number($aPointJ[1])

		If (($yi > $iY) <> ($yj > $iY)) And ($iX < ($xj - $xi) * ($iY - $yi) / ($yj - $yi) + $xi) Then $bInside = Not $bInside
		$j = $i
	Next

	Return $bInside
EndFunc   ;==>CaptureSceneryInsidePolygon

; === PATCH SCORING ===

Func CaptureSceneryPatchScore($hBitmap, $iLeft, $iTop, $iSize)
	Local $iStep = 4
	Local $iScore = 0
	Local $iSamples = 0
	Local $iDark = 0
	Local $iBright = 0

	For $y = $iTop To $iTop + $iSize - $iStep - 1 Step $iStep
		For $x = $iLeft To $iLeft + $iSize - $iStep - 1 Step $iStep
			Local $iColor = _GDIPlus_BitmapGetPixel($hBitmap, $x, $y)
			Local $iColorX = _GDIPlus_BitmapGetPixel($hBitmap, $x + $iStep, $y)
			Local $iColorY = _GDIPlus_BitmapGetPixel($hBitmap, $x, $y + $iStep)

			Local $iR = BitAND(BitShift($iColor, 16), 0xFF)
			Local $iG = BitAND(BitShift($iColor, 8), 0xFF)
			Local $iB = BitAND($iColor, 0xFF)
			Local $iLuma = Int(($iR * 30 + $iG * 59 + $iB * 11) / 100)
			If $iLuma < 25 Then $iDark += 1
			If $iLuma > 235 Then $iBright += 1

			$iScore += CaptureSceneryColorDistance($iColor, $iColorX)
			$iScore += CaptureSceneryColorDistance($iColor, $iColorY)
			$iSamples += 1
		Next
	Next

	If $iSamples = 0 Then Return 0
	If $iDark > ($iSamples * 0.55) Or $iBright > ($iSamples * 0.55) Then Return 0
	Return Int($iScore / $iSamples)
EndFunc   ;==>CaptureSceneryPatchScore

Func CaptureSceneryColorDistance($iColorA, $iColorB)
	Local $iRA = BitAND(BitShift($iColorA, 16), 0xFF)
	Local $iGA = BitAND(BitShift($iColorA, 8), 0xFF)
	Local $iBA = BitAND($iColorA, 0xFF)
	Local $iRB = BitAND(BitShift($iColorB, 16), 0xFF)
	Local $iGB = BitAND(BitShift($iColorB, 8), 0xFF)
	Local $iBB = BitAND($iColorB, 0xFF)
	Return Abs($iRA - $iRB) + Abs($iGA - $iGB) + Abs($iBA - $iBB)
EndFunc   ;==>CaptureSceneryColorDistance

; === BITMAP AND FILE HELPERS ===

Func ImgCaptureCreateScreenBitmap()
	ForceCaptureRegion()
	_CaptureRegion2()
	Return _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
EndFunc   ;==>ImgCaptureCreateScreenBitmap

Func ImgCaptureSaveFromBitmap($hBitmap, $sCode, $iX, $iY, $iSize, $iIndex, $iMatch, $bOverwrite, $sFormat = "png")
	Local $aSize = ImgCaptureParseSize($iSize)
	If Not IsArray($aSize) Then Return SetError(2, 0, "")
	Local $iLeft = Int($iX) - Int($aSize[0] / 2)
	Local $iTop = Int($iY) - Int($aSize[1] / 2)
	Local $sDir = @ScriptDir & "\imgxml\"
	DirCreate($sDir)

	$sFormat = ImgCaptureFormat($sFormat)
	Local $sFileName = $sCode & "-" & Int($iX) & "-" & Int($iY) & "_" & Int($iIndex) & "_" & Int($iMatch) & "." & $sFormat
	Local $sFullPath = $sDir & $sFileName
	If FileExists($sFullPath) And Not $bOverwrite Then
		SetDebugLog("[CaptureScenery] Marker already exists: " & $sFileName, $COLOR_DEBUG)
		Return SetError(1, 0, "")
	EndIf

	Local $hCrop = _GDIPlus_BitmapCloneArea($hBitmap, $iLeft, $iTop, $aSize[0], $aSize[1], ($sFormat = "bmp" ? $GDIP_PXF24RGB : $GDIP_PXF32ARGB))
	If $hCrop = 0 Then
		SetLog("[CaptureScenery] Could not crop marker: " & $iX & "," & $iY, $COLOR_ERROR)
		Return SetError(2, 0, "")
	EndIf

	Local $bSaved = _GDIPlus_ImageSaveToFile($hCrop, $sFullPath)
	_GDIPlus_BitmapDispose($hCrop)

	If Not $bSaved Then
		SetLog("[CaptureScenery] Could not save marker: " & $sFileName, $COLOR_ERROR)
		Return SetError(3, 0, "")
	EndIf

	SetLog("[CaptureScenery] Saved: " & $sFileName, $COLOR_SUCCESS)
	Return $sFullPath
EndFunc   ;==>ImgCaptureSaveFromBitmap

Func ImgCaptureCode($sCode)
	Local $sPrefix = StringStripWS($sCode, $STR_STRIPALL)
	$sPrefix = StringRegExpReplace($sPrefix, '[\\/:*?"<>|]', "")
	Return $sPrefix
EndFunc   ;==>ImgCaptureCode

Func ImgCaptureFormat($sFormat)
	$sFormat = StringLower(StringStripWS($sFormat, $STR_STRIPALL))
	Switch $sFormat
		Case "bmp"
			Return "bmp"
		Case Else
			Return "png"
	EndSwitch
EndFunc   ;==>ImgCaptureFormat


; #FUNCTION# ===========================================================================================================
; Name ..........: ImgCaptureParseSize
; Description ...: Parses a square size or width x height in pixels, with at least eight pixels per dimension.
; ======================================================================================================================
Func ImgCaptureParseSize($vSize)
	Local $sSize = StringLower(StringStripWS(String($vSize), $STR_STRIPALL))
	If Not StringRegExp($sSize, "^\d+(?:x\d+)?$") Then Return SetError(1, 0, 0)
	Local $aParts = StringSplit($sSize, "x", $STR_NOCOUNT)
	Local $aSize[2] = [Int($aParts[0]), Int($aParts[0])]
	If UBound($aParts) = 2 Then $aSize[1] = Int($aParts[1])
	If $aSize[0] < 8 Or $aSize[1] < 8 Or $aSize[0] > $g_iGAME_WIDTH Or $aSize[1] > $g_iGAME_HEIGHT Then Return SetError(1, 0, 0)
	Return $aSize
EndFunc   ;==>ImgCaptureParseSize
