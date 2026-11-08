; #FUNCTION# ====================================================================================================================
; Name ..........: isProblemAffect
; Description ...: Test the screen for possible error messages from CoC or Bluestacks
; Syntax ........: isProblemAffect($bNeedCaptureRegion), False is default.
; Parameters ....: $bNeedCaptureRegion = True will make a new 2x2 screencapture to identify the pixels to test, False will assume there is a full screen capture to use.
; Return values .: True if screen is blocked by an error message from CoC or BlueStacks
; Author ........: HungLe (05-2015)
; Modified ......: Hervidero (05-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......: Click
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isProblemAffect($bNeedCaptureRegion = False)
	Local $iGray = 0x282828
	If $g_iAndroidVersionAPI >= $g_iAndroidLollipop Then $iGray = 0x424242
	If _ColorCheck(_GetPixelColor(823, 32, $bNeedCaptureRegion), Hex(0xF8FCFF, 6), 10) Then Return False

	; Preserve the legacy signature before checking the current Android dialog layout.
	If _ColorCheck(_GetPixelColor(253, 395 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($iGray, 6), 10) And _
			_ColorCheck(_GetPixelColor(373, 395 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($iGray, 6), 10) And _
			_ColorCheck(_GetPixelColor(473, 395 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($iGray, 6), 10) And _
			_ColorCheck(_GetPixelColor(283, 395 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($iGray, 6), 10) And _
			_ColorCheck(_GetPixelColor(320, 395 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($iGray, 6), 10) And _
			_ColorCheck(_GetPixelColor(594, 395 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($iGray, 6), 10) Then Return True

	Local $aGray[2] = [$iGray, 0x1C1B1B]
	Local $iLast = $g_iAndroidVersionAPI >= 31 ? 1 : 0 ; Android 12 and later use the darker dialog theme.
	For $i = 0 To $iLast
		If _ColorCheck(_GetPixelColor(215, 267 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($aGray[$i], 6), 10) And _
				_ColorCheck(_GetPixelColor(430, 395 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($aGray[$i], 6), 10) And _
				_ColorCheck(_GetPixelColor(640, 395 + $g_iMidOffsetY, $bNeedCaptureRegion), Hex($aGray[$i], 6), 10) Then Return True
	Next
	Return False
EndFunc   ;==>isProblemAffect
