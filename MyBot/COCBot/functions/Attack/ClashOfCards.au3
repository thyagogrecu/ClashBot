; #FUNCTION# ===========================================================================================================
; Name ..........: Clash of Cards
; Author ........: CalebWeisgerber
; Description ...: Opens and claims card packs forced onto the post-battle screen during the August event.
; Remarks .......: The event gate is disabled; the implementation remains available and reuses generic reward templates.
; ======================================================================================================================

; === EVENT STATE ===
Global Const $g_bClashOfCardsEventEnabled = False ; Event ended; keep the implementation available for future use.

Func IsClashOfCardsEventActive()
	Return $g_bClashOfCardsEventEnabled And @MON = 8
EndFunc   ;==>IsClashOfCardsEventActive

; === SCREEN REGIONS ===
Global Const $g_aClashOfCardsTapRegion[4] = [280, 170, 600, 470]
Global Const $g_aClashOfCardsPageRegion[4] = [150, 325, 220, 380]
Global Const $g_aClashOfCardsButtonRegion[4] = [370, 480, 550, 555]

; === SCREEN DETECTION ===
Func IsClashOfCardsContinueVisible()
	Return _ColorCheck(_GetPixelColor(440, 500 + $g_iMidOffsetY, True), Hex(0xBFEB8E, 6), 20, Default, "CardContinue")
EndFunc   ;==>IsClashOfCardsContinueVisible

Func IsClashOfCardsPageVisible()
	; CardPage is only used as a boolean marker. Q1 avoids requiring objectpoints coordinates from the XML.
	Return QuickMIS("Q1", $g_sImgCardPage, _
			$g_aClashOfCardsPageRegion[0], $g_aClashOfCardsPageRegion[1] + $g_iMidOffsetY, _
			$g_aClashOfCardsPageRegion[2], $g_aClashOfCardsPageRegion[3] + $g_iMidOffsetY) > 0
EndFunc   ;==>IsClashOfCardsPageVisible

; === PACK HANDLING ===
Func CheckClashOfCards($bSetLog = True, $bAllowPostBattleFallback = False)
	; === VALIDATION ===
	If Not IsClashOfCardsEventActive() Then Return False
	If Not $g_bRunState Then Return False

	; === SCREEN STATE DETECTION ===
	Local $iTapX = 441
	Local $iTapY = 321 + $g_iMidOffsetY
	Local $bTapIconFound = False
	Local $bCardPageFound = IsClashOfCardsPageVisible()
	Local $bCardContinueFound = IsClashOfCardsContinueVisible()
	Local $hTapTemplate = FileFindFirstFile($g_sImgCardTapIcon & "*.xml")
	If $hTapTemplate <> -1 Then
		FileClose($hTapTemplate)
		$bTapIconFound = QuickMIS("BC1", $g_sImgCardTapIcon, _
				$g_aClashOfCardsTapRegion[0], $g_aClashOfCardsTapRegion[1] + $g_iMidOffsetY, _
				$g_aClashOfCardsTapRegion[2], $g_aClashOfCardsTapRegion[3] + $g_iMidOffsetY)
		If $bTapIconFound Then
			$iTapX = $g_iQuickMISX
			$iTapY = $g_iQuickMISY
		EndIf
	EndIf

	Local $aContinueButton = findButton("Continue", Default, 1, True)
	Local $bContinueFound = IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2
	Local $bClaimFound = QuickMIS("BC1", $g_sImgClaimRewardButton, _
			$g_aClashOfCardsButtonRegion[0], $g_aClashOfCardsButtonRegion[1] + $g_iMidOffsetY, _
			$g_aClashOfCardsButtonRegion[2], $g_aClashOfCardsButtonRegion[3] + $g_iMidOffsetY)
	If Not $bTapIconFound And Not $bCardPageFound And Not $bContinueFound And Not $bClaimFound And Not $bCardContinueFound And Not $bAllowPostBattleFallback Then Return False

	; === PACK OPENING ===
	If Not $bContinueFound And Not $bClaimFound And Not $bCardContinueFound And ($bTapIconFound Or $bCardPageFound Or $bAllowPostBattleFallback) Then
		If $bSetLog Then SetLog("Pack found, tapping to open", $COLOR_ACTION)
		For $i = 1 To 10
			Click($iTapX, $iTapY, 1, 0, "Tap Card Pack")
			If _Sleep(250) Then Return False
		Next
	ElseIf $bSetLog Then
		SetLog("Pack already open, skipping taps", $COLOR_ACTION)
	EndIf

	; === REWARD CLAIMING ===
	For $i = 1 To 10
		$aContinueButton = findButton("Continue", Default, 1, True)
		If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
			ClickP($aContinueButton, 1, 120, "Clash of Cards Continue")
			If $bSetLog Then SetLog("Pack opened and claimed", $COLOR_SUCCESS)
			Return True
		EndIf

		If QuickMIS("BC1", $g_sImgClaimRewardButton, _
				$g_aClashOfCardsButtonRegion[0], $g_aClashOfCardsButtonRegion[1] + $g_iMidOffsetY, _
				$g_aClashOfCardsButtonRegion[2], $g_aClashOfCardsButtonRegion[3] + $g_iMidOffsetY) Then
			Click($g_iQuickMISX, $g_iQuickMISY, 1, 0, "Clash of Cards Claim Reward")
			If $bSetLog Then SetLog("Pack opened and claimed", $COLOR_SUCCESS)
			Return True
		EndIf

		If IsClashOfCardsContinueVisible() Then
			Click(440, 520 + $g_iMidOffsetY, 1, 0, "Clash of Cards Continue")
			If $bSetLog Then SetLog("Pack opened and claimed", $COLOR_SUCCESS)
			Return True
		EndIf

		If _Sleep(300) Then Return False
	Next

	If $bSetLog Then SetLog("Action button not found", $COLOR_ERROR)
	Return False
EndFunc   ;==>CheckClashOfCards

; === TEST ===
Func ClashOfCards_Test()
	If Not IsClashOfCardsEventActive() Then
		SetLog("ClashOfCards_Test: event is only active in August", $COLOR_INFO)
		Return False
	EndIf

	Local $bTestCardPageFound = IsClashOfCardsPageVisible()
	If $bTestCardPageFound Then
		SetLog("ClashOfCards_Test: Card page found", $COLOR_SUCCESS)
	Else
		SetLog("ClashOfCards_Test: Card page not found", $COLOR_INFO)
	EndIf

	Local $hTapTemplate = FileFindFirstFile($g_sImgCardTapIcon & "*.xml")
	If $hTapTemplate <> -1 Then
		FileClose($hTapTemplate)
		If QuickMIS("BC1", $g_sImgCardTapIcon, _
				$g_aClashOfCardsTapRegion[0], $g_aClashOfCardsTapRegion[1] + $g_iMidOffsetY, _
				$g_aClashOfCardsTapRegion[2], $g_aClashOfCardsTapRegion[3] + $g_iMidOffsetY) Then
			SetLog("ClashOfCards_Test: Tap icon found at [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]", $COLOR_SUCCESS)
		Else
			SetLog("ClashOfCards_Test: Tap icon not found", $COLOR_INFO)
		EndIf
	Else
		SetLog("ClashOfCards_Test: upstream Tap icon template was not supplied; post-battle fallback is active", $COLOR_INFO)
	EndIf

	Local $aContinueButton = findButton("Continue", Default, 1, True)
	If IsArray($aContinueButton) And UBound($aContinueButton, 1) = 2 Then
		SetLog("ClashOfCards_Test: Continue button found", $COLOR_SUCCESS)
	Else
		SetLog("ClashOfCards_Test: Continue button not found", $COLOR_INFO)
	EndIf

	If QuickMIS("BC1", $g_sImgClaimRewardButton, _
			$g_aClashOfCardsButtonRegion[0], $g_aClashOfCardsButtonRegion[1] + $g_iMidOffsetY, _
			$g_aClashOfCardsButtonRegion[2], $g_aClashOfCardsButtonRegion[3] + $g_iMidOffsetY) Then
		SetLog("ClashOfCards_Test: Claim Reward button found at [" & $g_iQuickMISX & "," & $g_iQuickMISY & "]", $COLOR_SUCCESS)
	Else
		SetLog("ClashOfCards_Test: Claim Reward button not found", $COLOR_INFO)
	EndIf

	If IsClashOfCardsContinueVisible() Then
		SetLog("ClashOfCards_Test: Card Continue color found", $COLOR_SUCCESS)
	Else
		SetLog("ClashOfCards_Test: Card Continue color not found", $COLOR_INFO)
	EndIf

	Return True
EndFunc   ;==>ClashOfCards_Test
