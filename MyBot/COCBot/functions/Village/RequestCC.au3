; #FUNCTION# ====================================================================================================================
; Name ..........: RequestCC
; Description ...: Requests Clan Castle troops and Cake reinforcements through clan chat.
; Syntax ........: RequestCC()
; Parameters ....:
; Return values .: None
; Author ........: Phael
; Modified ......: Sardo(06-2015), KnowJack(10-2015), Sardo (08-2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func RequestCC($bReturnToVillage = True, $bPreserveCakeResult = False)

	If Not $bPreserveCakeResult Then $g_bCakeCCRequestSucceeded = False

	If Not $g_bRequestTroopsEnable Or Not $g_bDonationEnabled Then
		Return
	EndIf

	If Not $g_bRunState Then Return

	Local $bRequestDialogReady = False
	; If Cake Request is enabled, try to request cake first
	If $g_bCakeCCEnable Then
		If _RequestCC_Cake($bReturnToVillage, $bRequestDialogReady) Then
			Return
		EndIf

		If $g_bCakeCCOnly Then
			_RequestCC_SkipTroopRequest("Skipping Troop Request")
			If $bRequestDialogReady Then _RequestCC_CloseChat(Not $bReturnToVillage, True)
			Return
		EndIf
	EndIf

	; Cake requests are handled above; normal troop requests always respect the schedule.
	Local $hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
	If Not $g_abRequestCCHours[$hour[0]] Then
		SetLog("Clan Castle troop request not planned, skipping", $COLOR_ACTION)
		If $bRequestDialogReady Then _RequestCC_CloseChat(Not $bReturnToVillage, True)
		Return
	EndIf

	SetLog("Requesting Troops", $COLOR_ACTION)
	Local $bRestoreArmy = Not $bReturnToVillage
	Local $bChatOpened = $bRequestDialogReady, $bDialogOpened = $bRequestDialogReady
	Local $bRequested = False
	If $bRequestDialogReady Then
		$bRequested = _RequestCC_Send(0, True)
	Else
		$bRequested = _RequestCC_FromChat(False, $bChatOpened, $bDialogOpened)
	EndIf
	If $bChatOpened Then _RequestCC_CloseChat($bRestoreArmy, $bDialogOpened)
	Return $bRequested
EndFunc   ;==>RequestCC

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_CloseArmyOverview
; Description ...: Closes Army Overview after the attack readiness capacity check.
; ======================================================================================================================
Func _RequestCC_CloseArmyOverview($bClickPAtEnd)
	If Not $bClickPAtEnd Then Return
	If _Sleep($DELAYREQUESTCC1) Then Return
	CloseWindow2()
	If _Sleep(500) Then Return
	If Not IsMainPage(1) Then
		Click(Random(730, 800, 1), Random(25, 35, 1), 1, 120, "Return to Main Village")
		If _Sleep(500) Then Return
	EndIf
EndFunc   ;==>_RequestCC_CloseArmyOverview

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_SkipTroopRequest
; Description ...: Logs why the configured request flow was skipped.
; ======================================================================================================================
Func _RequestCC_SkipTroopRequest($sReason)
	SetLog($sReason, $COLOR_ACTION)
EndFunc   ;==>_RequestCC_SkipTroopRequest

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_Send
; Description ...: Opens the request dialog, applies the configured text and submits the request.
; Remarks .......: A request is confirmed by the chat button state; no estimated cooldown is used.
; ======================================================================================================================
Func _RequestCC_Send($aRequestButtonPos, $bDialogAlreadyOpen = False)
	Local $sSendButtonArea = GetDiamondFromRect("220,150,650,650")

	If Not $bDialogAlreadyOpen Then
		ClickP($aRequestButtonPos, 1, 120, "0336")
		If _Sleep(250) Then Return
		isGemOpen(True)
		If _Sleep(500) Then Return
	EndIf

	If Not IsWindowOpen($g_sImgSendRequestButton, 10, 100, $sSendButtonArea) Then
		SetLog("Request has already been made or request window not available", $COLOR_INFO)
		If _Sleep($DELAYMAKEREQUEST2) Then Return
	Else
		If $g_sRequestTroopsText <> "" Then
			If Not $g_bChkBackgroundMode And Not $g_bNoFocusTampering Then ControlFocus($g_hAndroidWindow, "", "")
			; fix for Android send text bug sending symbols like ``"
			AndroidSendText($g_sRequestTroopsText, True)
			Click(Int($g_avWindowCoordinates[0]), Int($g_avWindowCoordinates[1] - 100), 1, 100, "#0254")
			If _Sleep($DELAYMAKEREQUEST2) Then Return
			If SendText($g_sRequestTroopsText) = 0 Then
				SetLog(" Request text entry failed, try again", $COLOR_ERROR)
				Return
			EndIf
		EndIf
		If _Sleep($DELAYMAKEREQUEST2) Then Return ; wait time for text request to complete

		If Not IsWindowOpen($g_sImgSendRequestButton, 10, 100, $sSendButtonArea) Then
			SetDebugLog("Send request button not found", $COLOR_DEBUG)
			CheckMainScreen(False) ;emergency exit
			Return
		EndIf

		If Not $g_bChkBackgroundMode And Not $g_bNoFocusTampering Then ControlFocus($g_hAndroidWindow, "", "") ; make sure Android has window focus
		Local $CoordsX[2] = [$g_avWindowCoordinates[0] - 60, $g_avWindowCoordinates[0] + 30]
		Local $CoordsY[2] = [$g_avWindowCoordinates[1] - 15, $g_avWindowCoordinates[1] + 25]
		Local $ButtonClickX = Random($CoordsX[0], $CoordsX[1], 1)
		Local $ButtonClickY = Random($CoordsY[0], $CoordsY[1], 1)
		Click($ButtonClickX, $ButtonClickY, 1, 100, "#0256")
		Local $bConfirmed = False, $aStatePosition = 0
		For $iAttempt = 1 To 5
			If _Sleep(350) Then Return False
			Local $sAfterSend = _RequestCC_ChatState($aStatePosition)
			If $sAfterSend = "AlreadyMade" Then
				$bConfirmed = True
				ExitLoop
			EndIf
		Next
		If Not $bConfirmed Then
			SetLog("Troop request send not confirmed", $COLOR_WARNING)
			Return False
		EndIf
		SetDebugLog("Troop request confirmed in Clan Chat", $COLOR_SUCCESS)
		$g_bCanRequestCC = False
		Return True
	EndIf
	Return False
EndFunc   ;==>_RequestCC_Send

; #FUNCTION# ===========================================================================================================
; Name ..........: IsFullClanCastle
; Description ...: Checks reinforcement readiness using the clan chat request state.
; Remarks .......: Restores Army Overview for training callers when it was initially open.
; ======================================================================================================================
Func IsFullClanCastle($bRestoreArmy = True, $bArmyReady = True)
	If Not $g_bRunState Then Return False
	If Not $g_bSearchCastleWaitEnable Then
		_RequestCC_WaitFallback(True)
		Return True
	EndIf
	If $g_bCakeCCRequestSucceeded Then
		_RequestCC_WaitFallback(True)
		Return True
	EndIf
	Local $bWasArmyOpen = IsTrainPage(False, 1)
	If $bWasArmyOpen Then _RequestCC_CloseArmyOverview(True)
	If Not $g_bRunState Then Return False
	Local $bFull = _RequestCC_IsChatFull()
	If $bWasArmyOpen And $bRestoreArmy And $g_bRunState Then
		If Not OpenArmyOverview(True, "IsFullClanCastle return") Then Return False
	EndIf
	_RequestCC_LogTroopWait(Not $bFull)
	If _RequestCC_WaitFallback($bFull, $bArmyReady) Then Return True
	Return $bFull
EndFunc   ;==>IsFullClanCastle

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_Cake
; Description ...: Opens the chat request dialog and confirms free reinforcements using the Cake button models.
; Remarks .......: Uses the same Cake model in separate request and confirmation regions; no fixed confirmation click.
; ======================================================================================================================
Func _RequestCC_Cake($bReturnToVillage, ByRef $bRequestDialogReady)
	SetLog("Preparing Reinforcements", $COLOR_INFO)
	If Not _RequestCC_OpenChat() Then Return False
	Local $bDialogOpened = False, $bSucceeded = False
	Local $sCakeDirectory = @ScriptDir & "\ImgXML\ClanCastle\Request\Cake\"
	Do
		Local $aRequestPos = 0, $sState = ""
		For $iAttempt = 1 To 5
			$sState = _RequestCC_ChatState($aRequestPos)
			If $sState <> "" Then ExitLoop
			If _Sleep(350) Then ExitLoop
		Next
		If Not $g_bRunState Then ExitLoop
		Switch $sState
			Case "AlreadyMade"
				SetLog("The request for troops has already been made")
				_RequestCC_CloseChat(Not $bReturnToVillage)
				Return True
			Case "FullOrUnavailable"
				SetLog("Clan Castle Full", $COLOR_SUCCESS)
				_RequestCC_CloseChat(Not $bReturnToVillage)
				Return True
			Case "Available"
				; Continue with the request dialog.
			Case Else
				ExitLoop
		EndSwitch
		ClickP($aRequestPos, 1)
		$bDialogOpened = True
		If _Sleep(500) Then ExitLoop
		Local $aCake = 0
		Local $sCakeArea = GetDiamondFromRect2(540, 550 + $g_iGAME_HEIGHT - 732, 690, 635 + $g_iGAME_HEIGHT - 732)
		For $iAttempt = 1 To 5
			$aCake = decodeSingleCoord(findImage("Cake", $sCakeDirectory & "Cake*", $sCakeArea, 1, True))
			If IsArray($aCake) And UBound($aCake) = 2 Then ExitLoop
			If _Sleep(350) Then ExitLoop
		Next
		If Not $g_bRunState Then ExitLoop
		If Not IsArray($aCake) Or UBound($aCake) <> 2 Then
			Local $sSendArea = GetDiamondFromRect2(220, 150, 650, 650)
			Local $aSend = decodeSingleCoord(findImage("SendRequest", $g_sImgSendRequestButton, $sSendArea, 1, True))
			If IsArray($aSend) And UBound($aSend) = 2 Then
				$bRequestDialogReady = True
				SetLog("Oops, there's no cake left in the castle")
				Return False
			EndIf
			ExitLoop
		EndIf
		SetLog("Applying Cake Reinforcements", $COLOR_ACTION)
		ClickP($aCake, 1)
		If _Sleep(500) Then ExitLoop
		Local $aConfirm = 0
		Local $sConfirmArea = GetDiamondFromRect2(440, 425 + $g_iGAME_HEIGHT - 732, 640, 520 + $g_iGAME_HEIGHT - 732)
		For $iAttempt = 1 To 5
			$aConfirm = decodeSingleCoord(findImage("Cake", $sCakeDirectory & "Cake*", $sConfirmArea, 1, True))
			If IsArray($aConfirm) And UBound($aConfirm) = 2 Then ExitLoop
			If _Sleep(350) Then ExitLoop
		Next
		If Not $g_bRunState Or Not IsArray($aConfirm) Then ExitLoop
		If UBound($aConfirm) <> 2 Then ExitLoop
		ClickP($aConfirm, 1)
		If _Sleep($DELAYMAKEREQUEST2) Then ExitLoop
		For $iAttempt = 1 To 5
			If IsMainPage(1) Then
				$bSucceeded = True
				ExitLoop
			EndIf
			If _Sleep(350) Then ExitLoop
		Next
	Until True
	If $bSucceeded Then
		$g_bCanRequestCC = False
		$g_bWaitForCCTroopSpell = False
		$g_bCakeCCRequestSucceeded = True
		$g_bIsFullArmywithHeroesAndSpells = True
	Else
		SetLog("Cake request unavailable or not confirmed", $COLOR_WARNING)
	EndIf
	_RequestCC_CloseChat(Not $bReturnToVillage, $bDialogOpened And Not $bSucceeded)
	Return $bSucceeded
EndFunc   ;==>_RequestCC_Cake

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_OpenChat
; Description ...: Opens normal clan chat using the existing donation navigation controls.
; ======================================================================================================================
Func _RequestCC_OpenChat()
	If Not $g_bRunState Then Return False
	If Not IsMainPage(1) Then
		CloseWindow2(1)
		If _Sleep(500) Then Return False
		ClearScreen()
		If Not IsMainPage(1) Then
			SetLog("Clan Chat request: Main Village not confirmed", $COLOR_WARNING)
			Return False
		EndIf
	EndIf
	Local $aChatDown = findButton("ChatDown")
	If Not IsArray($aChatDown) Or UBound($aChatDown) < 2 Then
		If Not ClickB("ClanChat") Then Return False
		If _Sleep(500) Then Return False
	EndIf
	; The war pane can appear after the chat opening animation.
	For $iChatAttempt = 1 To 3
		If Not $g_bRunState Then Return False
		Local $aChatWar = findButton("ChatWar")
		If IsArray($aChatWar) And UBound($aChatWar) >= 2 Then
			SetDebugLog("Hiding Clan War panel before troop request", $COLOR_INFO)
			ClickP($aChatWar, 1)
			If _Sleep(500) Then Return False
			ExitLoop
		EndIf
		If $iChatAttempt < 3 Then
			If _Sleep(250) Then Return False
		EndIf
	Next
	If _ColorCheck(_GetPixelColor(400, 120 + $g_iMidOffsetY, True), Hex(0x4D4B4A, 6), 20) Then
		Click(390, 145 + $g_iMidOffsetY)
		If _Sleep(250) Then Return False
	EndIf
	Local $aUnderstand = decodeSingleCoord(FindImageInPlace2("I Understand", $g_sImgChatIUnterstand, 50, 370 + $g_iMidOffsetY, 280, 520 + $g_iMidOffsetY, True))
	If IsArray($aUnderstand) And UBound($aUnderstand) > 1 Then
		ClickP($aUnderstand)
		If _Sleep(500) Then Return False
	EndIf
	Return True
EndFunc   ;==>_RequestCC_OpenChat

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_IsChatFull
; Description ...: Checks the clan chat request button before resuming the attack cycle.
; Remarks .......: An unrecognized state does not satisfy the wait condition.
; ======================================================================================================================
Func _RequestCC_IsChatFull()
	If Not $g_bRunState Then Return False
	If $g_bCakeCCRequestSucceeded Then
		_RequestCC_WaitFallback(True)
		Return True
	EndIf
	If Not _RequestCC_OpenChat() Then Return False
	Local $aPosition = 0, $sState = _RequestCC_ChatState($aPosition)
	SetDebugLog("Clan Castle wait: chat request state " & ($sState = "" ? "Unknown" : $sState), $COLOR_DEBUG)
	If $sState <> "" Then $g_bCanRequestCC = ($sState = "Available")
	_RequestCC_CloseChat(False)
	If $sState = "FullOrUnavailable" Then Return True
	If $sState = "Available" And $g_bRequestTroopsEnable And $g_bDonationEnabled Then
		RequestCC(True, True)
		If $g_bCakeCCRequestSucceeded Then
		_RequestCC_WaitFallback(True)
		Return True
	EndIf
	EndIf
	Return False
EndFunc   ;==>_RequestCC_IsChatFull

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_ChatState
; Description ...: Reads exact request state names within the bottom-right corner of clan chat.
; Remarks .......: Uses the complete BMP state models from the current clan chat interface.
; ======================================================================================================================
Func _RequestCC_ChatState(ByRef $aPosition)
	$aPosition = 0
	If Not $g_bRunState Then Return ""
	Return _RequestCC_ChatBitmapState($aPosition)
EndFunc   ;==>_RequestCC_ChatState

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_ChatBitmapState
; Description ...: Distinguishes request states using the complete local reference captures at the fixed chat button.
; Remarks .......: Rejects uncertain or conflicting color comparisons. Does not move the interface.
; ======================================================================================================================
Func _RequestCC_ChatBitmapState(ByRef $aPosition)
	Local $aStates[3] = ["Available", "AlreadyMade", "FullOrUnavailable"]
	ForceCaptureRegion()
	_CaptureRegion2()
	Local $hScreen = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
	If $hScreen = 0 Then Return ""
	Local $fBest = 256, $fSecond = 256, $sBest = "", $aBestPosition[2]
	For $i = 0 To UBound($aStates) - 1
		Local $aFiles = _FileListToArray($g_sImgRequestCCButton, $aStates[$i] & "*.bmp", $FLTA_FILES)
		If Not IsArray($aFiles) Then ContinueLoop
		For $j = 1 To $aFiles[0]
			Local $aReference = StringRegExp($aFiles[$j], "-(\d+)-(\d+)_", $STR_REGEXPARRAYMATCH)
			If Not IsArray($aReference) Then ContinueLoop
			Local $hModel = _GDIPlus_BitmapCreateFromFile($g_sImgRequestCCButton & "\" & $aFiles[$j])
			If $hModel = 0 Then ContinueLoop
			Local $iWidth = _GDIPlus_ImageGetWidth($hModel), $iHeight = _GDIPlus_ImageGetHeight($hModel)
			Local $iCenterX = Number($aReference[0]), $iCenterY = Number($aReference[1]) + $g_iGAME_HEIGHT - 732
			Local $iLeft = $iCenterX - Int($iWidth / 2), $iTop = $iCenterY - Int($iHeight / 2)
			If $iWidth < 1 Or $iHeight < 1 Or $iLeft < 0 Or $iTop < 0 Or $iLeft + $iWidth > $g_iGAME_WIDTH Or $iTop + $iHeight > $g_iGAME_HEIGHT Then
				_GDIPlus_ImageDispose($hModel)
				ContinueLoop
			EndIf
			Local $fDifference = 256, $iBestDX = 0, $iBestDY = 0
			For $iDY = -2 To 2
				For $iDX = -2 To 2
					If $iLeft + $iDX < 0 Or $iTop + $iDY < 0 Or $iLeft + $iDX + $iWidth > $g_iGAME_WIDTH Or $iTop + $iDY + $iHeight > $g_iGAME_HEIGHT Then ContinueLoop
					Local $fCandidate = 0
					For $y = 0 To $iHeight - 1
						For $x = 0 To $iWidth - 1
							Local $iModel = _GDIPlus_BitmapGetPixel($hModel, $x, $y)
							Local $iScreen = _GDIPlus_BitmapGetPixel($hScreen, $iLeft + $x + $iDX, $iTop + $y + $iDY)
							$fCandidate += Abs(BitAND(BitShift($iModel, 16), 255) - BitAND(BitShift($iScreen, 16), 255))
							$fCandidate += Abs(BitAND(BitShift($iModel, 8), 255) - BitAND(BitShift($iScreen, 8), 255))
							$fCandidate += Abs(BitAND($iModel, 255) - BitAND($iScreen, 255))
						Next
					Next
					$fCandidate /= $iWidth * $iHeight * 3
					If $fCandidate < $fDifference Then
						$fDifference = $fCandidate
						$iBestDX = $iDX
						$iBestDY = $iDY
					EndIf
				Next
			Next
			_GDIPlus_ImageDispose($hModel)
			If $fDifference < $fBest Then
				If $sBest <> $aStates[$i] Then $fSecond = $fBest
				$fBest = $fDifference
				$sBest = $aStates[$i]
				$aBestPosition[0] = $iCenterX + $iBestDX
				$aBestPosition[1] = $iCenterY + $iBestDY
			ElseIf $sBest <> $aStates[$i] And $fDifference < $fSecond Then
				$fSecond = $fDifference
			EndIf
		Next
	Next
	_GDIPlus_ImageDispose($hScreen)
	If Not $g_bRunState Or $fBest > 12 Or $fSecond - $fBest < 3 Then Return ""
	$aPosition = $aBestPosition
	Return $sBest
EndFunc   ;==>_RequestCC_ChatBitmapState

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_FromChat
; Description ...: Requests troops through clan chat, or stops before sending in test mode.
; ======================================================================================================================
Func _RequestCC_FromChat($bTestOnly, ByRef $bChatOpened, ByRef $bDialogOpened)
	If Not _RequestCC_OpenChat() Then Return False
	$bChatOpened = True
	$bDialogOpened = False
	Local $aRequestPos = 0, $sState = ""
	For $iAttempt = 1 To 5
		$sState = _RequestCC_ChatState($aRequestPos)
		If $sState <> "" Then ExitLoop
		If _Sleep(350) Then Return False
	Next
	SetDebugLog("Clan Chat request state: " & ($sState = "" ? "Unknown" : $sState), $COLOR_INFO)
	Switch $sState
		Case "AlreadyMade"
			SetLog("The request for troops has already been made")
			Return False
		Case "FullOrUnavailable"
			SetLog("Clan Castle Full", $COLOR_SUCCESS)
			Return False
		Case "Available"
			$bDialogOpened = True
			If Not $bTestOnly Then Return _RequestCC_Send($aRequestPos)
		Case Else
			If $g_bDebugImageSave Then SaveDebugImage("RequestCCChatStateUnknown")
			Return False
	EndSwitch
	ClickP($aRequestPos, 1, 120, "#TEST_REQUEST_CHAT")
	If _Sleep(500) Then Return False
	Local $sSendArea = GetDiamondFromRect2(220, 150, 650, 650)
	If Not IsWindowOpen($g_sImgSendRequestButton, 10, 150, $sSendArea) Then Return False
	SetLog("Chat request test completed: stopped before sending; confirmation window left open", $COLOR_WARNING)
	Return True
EndFunc   ;==>_RequestCC_FromChat

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_CloseChat
; Description ...: Closes request dialogs and chat, restoring Army Overview for callers that require it.
; ======================================================================================================================
Func _RequestCC_CloseChat($bRestoreArmy = False, $bDialogOpened = False)
	If Not $g_bRunState Then Return
	If $bDialogOpened Then
		; Request and Cake dialogs have Cancel instead of a close X.
		For $iAttempt = 1 To 3
			If IsMainPage(1) Then ExitLoop
			Local $aCancel = findButton("Cancel", Default, 1, True)
			If Not IsArray($aCancel) Then ExitLoop
			If UBound($aCancel) <> 2 Then ExitLoop
			ClickP($aCancel, 1)
			If _Sleep(350) Then Return
		Next
		If Not IsMainPage(1) Then
			SetLog("Request dialog could not be closed", $COLOR_WARNING)
			Return
		EndIf
	EndIf
	CloseDonateChat()
	If _Sleep(250) Then Return
	If $bRestoreArmy Then OpenArmyOverview(True, "RequestCC chat return")
EndFunc   ;==>_RequestCC_CloseChat

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_LogTroopWait
; Description ...: Reports pending Clan Castle reinforcements at most once per minute per account.
; ======================================================================================================================
Func _RequestCC_LogTroopWait($bWaiting)
	Static $ahLastLog[$g_iSwitchAccMaxAccounts]
	Local $iAccount = $g_iCurAccount
	If $iAccount < 0 Or $iAccount >= UBound($ahLastLog) Then Return
	If Not $bWaiting Then
		$ahLastLog[$iAccount] = 0
		Return
	EndIf
	If Not $g_bRunState Then Return
	If $ahLastLog[$iAccount] = 0 Or __TimerDiff($ahLastLog[$iAccount]) >= 60000 Then
		SetLog("Awaiting Clan Castle Troops", $COLOR_ACTION)
		$ahLastLog[$iAccount] = __TimerInit()
	EndIf
EndFunc   ;==>_RequestCC_LogTroopWait

; #FUNCTION# ===========================================================================================================
; Name ..........: _RequestCC_WaitFallback
; Description ...: Tracks the fifteen-minute reinforcement wait across readiness checks for each account.
; Remarks .......: Starts only for a ready army and resets when full or after a performed attack.
; ======================================================================================================================
Func _RequestCC_WaitFallback($bReset, $bArmyReady = True)
	Static $ahWaitStart[$g_iSwitchAccMaxAccounts], $abReported[$g_iSwitchAccMaxAccounts]
	Local $iAccount = $g_iCurAccount
	If $iAccount < 0 Or $iAccount >= UBound($ahWaitStart) Then Return False
	If $bReset Then
		$ahWaitStart[$iAccount] = 0
		$abReported[$iAccount] = False
		Return False
	EndIf
	If Not $bArmyReady Or Not $g_bRunState Then Return False
	If $ahWaitStart[$iAccount] = 0 Then $ahWaitStart[$iAccount] = __TimerInit()
	If __TimerDiff($ahWaitStart[$iAccount]) < 15 * 60 * 1000 Then Return False
	If Not $abReported[$iAccount] Then
		SetLog("Maximum wait time reached, attacking anyway", $COLOR_WARNING)
		$abReported[$iAccount] = True
	EndIf
	Return True
EndFunc   ;==>_RequestCC_WaitFallback
