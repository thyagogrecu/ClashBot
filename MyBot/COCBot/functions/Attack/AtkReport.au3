; #FUNCTION# ===========================================================================================================
; Name ..........: Attack Report Test
; Author ........: Phael
; Description ...: Runs AttackReport OCR against a PNG loaded into TestCapture.
; Remarks .......: Attack totals and database stats are not updated.
; ======================================================================================================================
Func AtkReport($sPngPath, $vMode = "normal")
	; === TEST INITIALIZATION ===
	Local $sMode = _AtkReportMode($vMode)
	Local $bRevengeBattle = ($sMode = "revenge")
	Local $bRankedBattle = ($sMode = "ranked")

	; === IMAGE VALIDATION ===
	If Not FileExists($sPngPath) Then
		SetLog("[AtkReport] Test image not found: " & $sPngPath, $COLOR_ERROR)
		Return False
	EndIf

	Local $hHBitmap = _AtkReportLoadPngAsHBitmap($sPngPath)
	If $hHBitmap = 0 Then Return False

	; === STATE BACKUP ===
	Local $bRunState = $g_bRunState
	Local $bOcrForceCaptureRegion = OcrForceCaptureRegion()

	; === CAPTURE SETUP ===
	SetLog("[AtkReport] Testing PNG: " & $sPngPath, $COLOR_INFO)
	SetLog("[AtkReport] Mode: " & _AtkReportModeText($sMode), $COLOR_INFO)

	$g_bRunState = True
	OcrForceCaptureRegion(True)
	TestCapture($hHBitmap)
	_CaptureRegion()
	_CaptureRegion2Sync()

	; === REPORT EXECUTION ===
	AttackReport($bRevengeBattle, True, $bRankedBattle)

	; === STATE RESTORATION ===
	_AtkReportRestoreCaptureState($bRunState, $bOcrForceCaptureRegion)
	Return True
EndFunc   ;==>AtkReport

; === HELPERS ===

Func _AtkReportMode($vMode)
	If IsString($vMode) Then
		Local $sMode = StringLower(StringStripWS($vMode, $STR_STRIPALL))
		If $sMode = "normal" Or $sMode = "n" Then Return "normal"
		If $sMode = "ranked" Or $sMode = "rk" Then Return "ranked"
		If $sMode = "revenge" Or $sMode = "rv" Or $sMode = "r" Then Return "revenge"
		Return "normal"
	EndIf

	Return ($vMode = True ? "revenge" : "normal")
EndFunc   ;==>_AtkReportMode

Func _AtkReportModeText($sMode)
	Switch $sMode
		Case "ranked"
			Return "Ranked"
		Case "revenge"
			Return "Revenge"
	EndSwitch

	Return "Normal"
EndFunc   ;==>_AtkReportModeText

Func _AtkReportLoadPngAsHBitmap($sPngPath)
	Local $hBitmap = _GDIPlus_BitmapCreateFromFile($sPngPath)
	If $hBitmap = 0 Then
		SetLog("[AtkReport] Could not load PNG: " & $sPngPath, $COLOR_ERROR)
		Return 0
	EndIf

	Local $hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap)

	If $hHBitmap = 0 Then
		SetLog("[AtkReport] Could not create bitmap handle: " & $sPngPath, $COLOR_ERROR)
		Return 0
	EndIf

	Return $hHBitmap
EndFunc   ;==>_AtkReportLoadPngAsHBitmap

Func _AtkReportRestoreCaptureState($bRunState, $bOcrForceCaptureRegion)
	OcrForceCaptureRegion($bOcrForceCaptureRegion)
	$g_bRunState = $bRunState

	If $g_hBitmap <> 0 Then GdiDeleteBitmap($g_hBitmap)
	If $g_hHBitmap2 <> 0 And $g_hHBitmap2 <> $g_hHBitmapTest And $g_hHBitmap2 <> $g_hHBitmap Then GdiDeleteHBitmap($g_hHBitmap2)

	$g_hHBitmap = 0
	TestCapture(0)
EndFunc   ;==>_AtkReportRestoreCaptureState

; #FUNCTION# ===========================================================================================================
; Name ..........: TestBattleOCR
; Description ...: Reads battle resources and damage from a selected PNG using the runtime OCR functions.
; Remarks .......: Saves each crop and its OCR result without interacting with the emulator or updating attack stats.
; ======================================================================================================================
Func TestBattleOCR($sPngPath = Default)
	If $sPngPath = Default Then
		$sPngPath = FileOpenDialog("Select Battle OCR PNG", $g_sProfileTempPath, "PNG (*.png)", $FD_FILEMUSTEXIST, "", $g_hFrmBot)
		If @error Then Return False
	EndIf
	If TestCapture() Then
		SetLog("[BattleOCR] Another image test is active", $COLOR_ERROR)
		Return False
	EndIf
	Local $hImage = _GDIPlus_BitmapCreateFromFile($sPngPath)
	If $hImage = 0 Then
		SetLog("[BattleOCR] Could not load PNG", $COLOR_ERROR)
		Return False
	EndIf
	If _GDIPlus_ImageGetWidth($hImage) <> $g_iGAME_WIDTH Or _GDIPlus_ImageGetHeight($hImage) <> $g_iGAME_HEIGHT Then
		_GDIPlus_BitmapDispose($hImage)
		SetLog("[BattleOCR] PNG must match the game resolution (" & $g_iGAME_WIDTH & "x" & $g_iGAME_HEIGHT & ")", $COLOR_ERROR)
		Return False
	EndIf
	Local $hTest = _GDIPlus_BitmapCreateDIBFromBitmap($hImage)
	_GDIPlus_BitmapDispose($hImage)
	If $hTest = 0 Then Return False
	Local $sOutput = @ScriptDir & "\lib\debug\BattleOCR_" & @YEAR & @MON & @MDAY & "_" & @HOUR & @MIN & @SEC & "_" & @MSEC
	If Not DirCreate($sOutput) Then
		_WinAPI_DeleteObject($hTest)
		Return False
	EndIf

	; === CAPTURE STATE ===
	Local $hPreviousCapture = $g_hHBitmap2
	Local $bPreviousForce = OcrForceCaptureRegion(True)
	$g_hHBitmap2 = 0
	TestCapture($hTest)
	Local $aFields[4] = ["Gold", "Elixir", "DarkElixir", "OverallDamage"]
	Local $aValues[4]
	Local $aAreas[4] = ["45,68,90,16", "45,98,90,16", "45,126,75,18", "780," & (527 + $g_iBottomOffsetY) & ",66,20"]
	Local $sReport = "PNG: " & $sPngPath & @CRLF
	Local $bSuccess = True
	SetLog("[BattleOCR] Testing PNG: " & $sPngPath, $COLOR_INFO)
	For $i = 0 To 3
		Local $sValue = ""
		Switch $i
			Case 0
				$sValue = getGoldVillageSearch(45, 68)
			Case 1
				$sValue = getElixirVillageSearch(45, 98)
			Case 2
				$sValue = getDarkElixirVillageSearch(45, 126)
			Case 3
				$sValue = getOcrOverAllDamage(780, 527 + $g_iBottomOffsetY, 66)
		EndSwitch
		Local $hCrop = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
		If $hCrop <> 0 Then
			If Not _GDIPlus_ImageSaveToFile($hCrop, $sOutput & "\" & $aFields[$i] & ".png") Then $bSuccess = False
			_GDIPlus_BitmapDispose($hCrop)
		Else
			$bSuccess = False
		EndIf
		Local $sLine = $aFields[$i] & ": " & ($sValue = "" ? "OCR unavailable" : $sValue) & " | Area x,y,w,h: " & $aAreas[$i]
		$aValues[$i] = ($sValue = "" ? "Unavailable" : _NumberFormat($sValue))
		$sReport &= $sLine & @CRLF
		If $sValue = "" And $i <> 2 Then $bSuccess = False
	Next

	; === STATE RESTORATION ===
	If $g_hHBitmap2 <> 0 And $g_hHBitmap2 <> $hTest Then GdiDeleteHBitmap($g_hHBitmap2)
	$g_hHBitmap2 = $hPreviousCapture
	TestCapture(0)
	OcrForceCaptureRegion($bPreviousForce)
	If Not FileWrite($sOutput & "\Results.txt", $sReport) Then $bSuccess = False
	SetLog("Loot: [G]: " & $aValues[0] & " [E]: " & $aValues[1] & " [DE]: " & $aValues[2], $COLOR_SUCCESS)
	SetLog("Overall Damage: " & $aValues[3] & ($aValues[3] = "Unavailable" ? "" : "%"), $COLOR_SUCCESS)
	SetDebugLog("[BattleOCR] Crops and results saved to " & $sOutput)
	SetLog("BattleOCR PNG Test Finished", $COLOR_INFO)
	Return $bSuccess
EndFunc   ;==>TestBattleOCR
