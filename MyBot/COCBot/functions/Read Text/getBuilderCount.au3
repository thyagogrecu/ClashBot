; #FUNCTION# ====================================================================================================================
; Name ..........: getBuilderCount
; Description ...: updates global builder count variables
; Syntax ........: getBuilderCount([$bSuppressLog = False], [$bBuilderBase = False])
; Parameters ....: $bSuppressLog        - [optional] a boolean value that stops log of builder count. Default is False.
; Parameters ....: $bBuilderBase        - [optional] Set to True if you want to get Builder Count on Builder Base. Default is False -> Read Normal Village Count
; Return values .: None
; Author ........: MonkeyHunter (06-2016)
; Modified ......: Fliegerfaust (06-2017), Moebius14 (07-2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func getBuilderCount($bSuppressLog = False, $bBuilderBase = False)

	Local $sBuilderInfo, $aGetBuilders, $bIsMainPage = False
	Local $iBuilderOcrX = $aBuildersDigits[0], $iBuilderOcrY = $aBuildersDigits[1]

	If Not $bBuilderBase Then
		$bIsMainPage = IsMainPage(1)
	Else
		$bIsMainPage = IsMainPageBuilderBase(1)
	EndIf

	If $bIsMainPage Then ; check for proper window location

		If Not $bBuilderBase Then
			Local $ExtraBuilderCount = 0
			If UBound(decodeSingleCoord(FindImageInPlace2("GobBuilder", $g_sImgGobBuilder, 735, 510 + $g_iBottomOffsetY, 800, 540 + $g_iBottomOffsetY, True))) > 1 Then $ExtraBuilderCount = 1
			$iBuilderOcrX = $aBuildersDigits[0]
			$iBuilderOcrY = $aBuildersDigits[1]
			Local $aMainBuilderOcrOffset[5] = [0, -3, 3, -6, 6]
			For $i = 0 To UBound($aMainBuilderOcrOffset) - 1
				Local $sMainBuilderInfoRaw = getBuilders($iBuilderOcrX, $iBuilderOcrY + $aMainBuilderOcrOffset[$i], True)
				$sBuilderInfo = _NormalizeBuilderCount($sMainBuilderInfoRaw)
				SetDebugLog("Main Village builders OCR raw [Y" & ($aMainBuilderOcrOffset[$i] >= 0 ? "+" : "") & $aMainBuilderOcrOffset[$i] & "]: '" & $sMainBuilderInfoRaw & "'", $COLOR_DEBUG)
				If StringRegExp($sBuilderInfo, "^\d+#\d+$") Then ExitLoop
			Next
		Else
			$iBuilderOcrX = $aBuildersDigitsBuilderBase[0]
			$iBuilderOcrY = $aBuildersDigitsBuilderBase[1]
			Local $aBuilderOcrOffset[3] = [0, -1, 1]
			For $i = 0 To UBound($aBuilderOcrOffset) - 1
				Local $sBuilderInfoRaw = getBuilders($iBuilderOcrX, $iBuilderOcrY + $aBuilderOcrOffset[$i], True, True)
				$sBuilderInfo = _NormalizeBuilderCount($sBuilderInfoRaw)
				SetDebugLog("Builder Base builders OCR raw [Y" & ($aBuilderOcrOffset[$i] >= 0 ? "+" : "") & $aBuilderOcrOffset[$i] & "]: '" & $sBuilderInfoRaw & "'", $COLOR_DEBUG)
				If StringRegExp($sBuilderInfo, "^\d+#\d+$") Then ExitLoop
			Next
		EndIf
		If StringRegExp($sBuilderInfo, "^\d+#\d+$") Then ; check for valid OCR read
			$aGetBuilders = StringSplit($sBuilderInfo, "#", $STR_NOCOUNT) ; Split into free and total builder strings
			If Not $bBuilderBase Then
				$g_iFreeBuilderCount = Int($aGetBuilders[0] - $ExtraBuilderCount) ; update global values
				If $ExtraBuilderCount = 1 And Number($aGetBuilders[0]) = 0 Then $g_iFreeBuilderCount = 0
				If $g_iTestFreeBuilderCount <> -1 Then $g_iFreeBuilderCount = $g_iTestFreeBuilderCount ; used for test cases
				$g_iTotalBuilderCount = Int($aGetBuilders[1] - $ExtraBuilderCount)
				If $g_bDebugSetLog And Not $bSuppressLog Then SetLog("No. of Free/Total Builders: " & $g_iFreeBuilderCount & "/" & $g_iTotalBuilderCount, $COLOR_DEBUG)
			Else
				$g_iFreeBuilderCountBB = Int($aGetBuilders[0]) ; update global values
				$g_iTotalBuilderCountBB = Int($aGetBuilders[1])
				If $g_bDebugSetLog And Not $bSuppressLog Then SetLog("No. of Free/Total Builders: " & $g_iFreeBuilderCountBB & "/" & $g_iTotalBuilderCountBB, $COLOR_DEBUG)
			EndIf
			$g_iGfxErrorCount = 0
			Return True ; Happy Monkey returns!
		Else
			SetLog("Bad OCR Read Free/Total Builders", $COLOR_ERROR) ; OCR returned unusable value?
			SetLog("Keeping previous " & ($bBuilderBase ? "Builder Base" : "Main Village") & " builder values", $COLOR_WARNING)
			If $g_bDebugImageSave Then SaveDebugImage($bBuilderBase ? "getBuilderCount_BB_" : "getBuilderCount_")
			Return False
		EndIf
	Else
		SetLog("Unable to read builders info at this time", $COLOR_ERROR)
		; drop down to error handling code
	EndIf
	If $g_bDebugSetLog Or $g_bDebugImageSave Then SaveDebugImage("getBuilderCount_")
	If checkObstacles() And Not $g_bRestart Then checkMainScreen() ; trap common error messages
	Return False
EndFunc   ;==>getBuilderCount

; #FUNCTION# ===========================================================================================================
; Name ..........: getLabBuilderCount
; Description ...: Reads the laboratory availability counter beside the main village builder count.
; Remarks .......: Resolves an ambiguous 1/2 in Research; raw mode returns the displayed counter.
; ======================================================================================================================

Func getLabBuilderCount($bRawCount = False)
	Local $aYOffset[3] = [0, -1, 1]
	For $i = 0 To UBound($aYOffset) - 1
		Local $sRaw = getBuilders($aLabBuilderDigits[0], $aLabBuilderDigits[1] + $aYOffset[$i], True, False, 18)
		Local $sCount = _NormalizeBuilderCount($sRaw)
		If StringRegExp($sCount, "^[0-2]#[12]$") Then
			If $bRawCount Or StringRight($sCount, 1) = "1" Then Return $sCount
			Switch StringLeft($sCount, 1)
				Case "0"
					Return "0#1"
				Case "2"
					Return "1#1"
				Case Else
					Return _ReadNormalLabSlotAvailability()
			EndSwitch
		EndIf
	Next
	Return ""
EndFunc   ;==>getLabBuilderCount

; #FUNCTION# ===========================================================================================================
; Name ..........: _NormalizeBuilderCount
; Description ...: Normalizes Main Village and Builder Base free/total builder OCR results.
; Remarks .......: Supports # and / separators and rejects inconsistent free/total values.
; ======================================================================================================================

Func _NormalizeBuilderCount($sRaw)
	Local $sResult = StringStripWS(StringReplace($sRaw, "/", "#"), $STR_STRIPALL)
	If StringRegExp($sResult, "^\d#\d$") Then
		Local $aBuilderCount = StringSplit($sResult, "#", $STR_NOCOUNT)
		If Number($aBuilderCount[1]) > 0 And Number($aBuilderCount[0]) <= Number($aBuilderCount[1]) Then Return $sResult
	EndIf

	; OCR can omit the separator and return values like "0 6"; accept only a plausible two-digit free/total pair.
	Local $sDigits = StringRegExpReplace($sResult, "\D", "")
	If StringLen($sDigits) = 2 Then
		Local $iFreeBuilders = Number(StringLeft($sDigits, 1))
		Local $iTotalBuilders = Number(StringRight($sDigits, 1))
		If $iTotalBuilders > 0 And $iTotalBuilders <= 7 And $iFreeBuilders <= $iTotalBuilders Then Return $iFreeBuilders & "#" & $iTotalBuilders
	EndIf

	Return ""
EndFunc   ;==>_NormalizeBuilderCount
