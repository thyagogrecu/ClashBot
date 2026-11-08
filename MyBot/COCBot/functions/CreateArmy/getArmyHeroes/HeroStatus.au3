; #FUNCTION# ===========================================================================================================
; Name ..........: HeroStatus
; Author ........: Phael
; Description ...: Checks hero availability and upgrade status in the Hero Hall and updates the GUI.
; Remarks .......: Evaluates every hero unlocked for the current Town Hall and retains per-hero GUI state.
; ======================================================================================================================

; === GLOBAL STATE ===
; Hero Hall Slot X Positions: King=65, Queen=218, Prince=371, Warden=523, Champion=676, Duke=718 (after 153px left swipe)
Global $g_aHeroSlotX[6] = [65, 218, 371, 523, 676, 718]

; === HERO STATUS FLOW ===
Func HeroStatus()

	If $g_iTownHallLevel < 7 Then
		SetDebugLog("Town Hall level " & $g_iTownHallLevel & " has no Hero Hall", $COLOR_DEBUG)
		Return
	EndIf
	If Not HeroHallValuesCheck() Then
		SetLog("Please check Hero Hall Values Now !", $COLOR_ERROR)
		SetLog("MBR cannot run correctly without Hero Hall Values : LOCATE !", $COLOR_ERROR)
	EndIf


	Local Static $iLastHeroStatusCheck[$g_iSwitchAccMaxAccounts]
	If $g_bFirstStartHeroStatus Then $iLastHeroStatusCheck[$g_iCurAccount] = ""

	; Check if is a valid date
	If _DateIsValid($iLastHeroStatusCheck[$g_iCurAccount]) Then
		Local $iLastCheck = _DateDiff('s', $iLastHeroStatusCheck[$g_iCurAccount], _NowCalc()) ; elapse time from last check (minutes)
		SetDebugLog("Hero Hall LastCheck: " & $iLastHeroStatusCheck[$g_iCurAccount] & ", Check DateCalc: " & $iLastCheck)
		; A check each from 1.5 to 2 hours [1.5*60 = 90 to 2*60 = 120]
		Local $iDelayToCheck = Random(90, 120, 1) * 60 ; Convert in seconds
		If $iLastCheck < $iDelayToCheck Then
			If _Sleep(1000) Then Return
			Return
		EndIf
	EndIf

	ClearScreen()

	SetLog("Checking Heroes Status", $COLOR_INFO)
	Local $aiSavedHeroHallPos = $g_aiHeroHallPos
	Local $bHeroHallSelected = ImgLocateHeroHall(True, True)
	If Not $bHeroHallSelected Then
		$g_aiHeroHallPos = $aiSavedHeroHallPos
		If $g_aiHeroHallPos[0] <= 0 Or $g_aiHeroHallPos[1] <= 0 Then Return
	EndIf

	If Not $bHeroHallSelected Then
		BuildingClick($g_aiHeroHallPos[0], $g_aiHeroHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
	EndIf
	Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
	If StringInStr($sHeroHallInfo[1], "Hero") Then
		If $g_aiHeroHallPos[2] <> $sHeroHallInfo[2] Then
			$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
		EndIf
		Local $HeroHallButton = FindButton("HeroHallButton")
		If IsArray($HeroHallButton) And UBound($HeroHallButton) = 2 Then
			ClickP($HeroHallButton)
			If _Sleep(Random(1500, 2000, 1)) Then Return
		Else
			SetLog("Hero Hall Button not found", $COLOR_ERROR)
			ClearScreen()
			Return ; Hero Hall button not found, cannot proceed
		EndIf
	Else
		SetLog("BuildingInfo did not detect Hero Hall, aborting check", $COLOR_ERROR)
		ClearScreen()
		Return
	EndIf

	$iLastHeroStatusCheck[$g_iCurAccount] = _NowCalc() ; Update last check time
	$g_bFirstStartHeroStatus = 0

	; Check ALL Heroes unlocked at this Hero Hall level
	; Always re-verifies every unlocked hero to keep the GUI status current
	Local $iMaxHeroIndex = 5 ; default: all 6 heroes (indices 0 > 5)
	Switch $g_aiHeroHallPos[2]
		Case 1, 2
			$iMaxHeroIndex = 0 ; King only
		Case 3, 4
			$iMaxHeroIndex = 1 ; King + Queen
		Case 5, 6
			$iMaxHeroIndex = 2 ; King + Queen + Prince
		Case Else
			$iMaxHeroIndex = 5 ; Level 7+: all heroes
	EndSwitch
	Local $aCheckList[0]
	For $i = 0 To $iMaxHeroIndex
		_ArrayAdd($aCheckList, $i)
	Next

	For $j = 0 To UBound($aCheckList) - 1
		Local $iHero = $aCheckList[$j]
		; brief pause before operating on this hero
		If _Sleep(500) Then Return
		Switch $iHero
			Case 0
				_HeroStatus_CheckKing(False)
			Case 1
				_HeroStatus_CheckQueen(False)
			Case 2
				_HeroStatus_CheckPrince(False)
			Case 3
				_HeroStatus_CheckWarden(False)
			Case 4
				_HeroStatus_CheckChampion(False)
			Case 5
				_HeroStatus_CheckDuke(False)
		EndSwitch
	Next
	; after all checks close window once
	CloseWindow()
EndFunc   ;==>HeroStatus

; === CARD STATE DETECTION ===
; #FUNCTION# ===========================================================================================================
; Name ..........: _IsCardGray
; Description ...: Detects an unavailable hero from the color spread of its Hero Hall card.
; Remarks .......: Samples one MidOffset-adjusted pixel and compares RGB channel spread with the configured threshold.
; ======================================================================================================================

Func _IsCardGray($iX, $iThreshold = 30, $iY = 225)
	Local $sColor = _GetPixelColor($iX, $iY + $g_iMidOffsetY, True)
	Local $iR = Dec(StringMid($sColor, 1, 2))
	Local $iG = Dec(StringMid($sColor, 3, 2))
	Local $iB = Dec(StringMid($sColor, 5, 2))
	Local $iMax = $iR
	If $iG > $iMax Then $iMax = $iG
	If $iB > $iMax Then $iMax = $iB
	Local $iMin = $iR
	If $iG < $iMin Then $iMin = $iG
	If $iB < $iMin Then $iMin = $iB
	SetDebugLog("_IsCardGray X=" & $iX & " Y=" & $iY & " color=" & $sColor & " spread=" & ($iMax - $iMin) & " threshold=" & $iThreshold, $COLOR_DEBUG)
	Return ($iMax - $iMin) < $iThreshold
EndFunc   ;==>_IsCardGray

; === UPGRADE STATE DETECTION ===
; Per-hero status checkers - called by HeroStatus(). Hero Hall window must be open.

; #FUNCTION# ===========================================================================================================
; Name ..........: _IsHeroUpgrading
; Description ...: Detects hero upgrade state from the Upgrade and Finish Now button pixels.
; Remarks .......: Absence of both green button states is treated as max level and ready.
; ======================================================================================================================

Func _IsHeroUpgrading($iIconX, $iIconY = 429)
	Local $iScreenY = $iIconY + $g_iMidOffsetY

	Local $sColor = _GetPixelColor($iIconX, $iScreenY, True)
	Local $iG = Dec(StringMid($sColor, 3, 2))
	Local $iB = Dec(StringMid($sColor, 5, 2))
	If $iG > 150 And $iG > $iB + 50 Then ; LEFT green = Upgrade button -> Ready
		SetDebugLog("_IsHeroUpgrading: GREEN LEFT #" & $sColor & " -> Ready", $COLOR_DEBUG)
		Return False
	EndIf

	Local $sColorR = _GetPixelColor($iIconX + 95, $iScreenY, True)
	Local $iGR = Dec(StringMid($sColorR, 3, 2))
	Local $iBR = Dec(StringMid($sColorR, 5, 2))
	If $iGR > 150 And $iGR > $iBR + 50 Then ; RIGHT green = Finish Now -> Upgrading
		SetDebugLog("_IsHeroUpgrading: GREEN RIGHT #" & $sColorR & " -> Upgrading", $COLOR_DEBUG)
		Return True
	EndIf

	SetDebugLog("_IsHeroUpgrading: no green -> MaxLevel -> Ready", $COLOR_DEBUG)
	Return False
EndFunc   ;==>_IsHeroUpgrading

; === PER-HERO STATUS CHECKS ===
Func _HeroStatus_CheckKing($bCloseWindow = True)
	Local $bInitalXcoord = 67
	Local $bDistanceSlot = 153
	Local $bXcoords[6] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4, $bInitalXcoord + $bDistanceSlot * 5]
	; --- Hero card color now uses test coordinate base X=240,Y=225 (spacing handled by $bXcoords) ---
	Local $iGrayYOffset = 225
	; calculate offset to align first hero x to 240 instead of (67+60)
	Local $iGrayXOffset = 240 - ($bInitalXcoord + 60)
	If _IsCardGray($bXcoords[0] + $iGrayXOffset, 30, $iGrayYOffset) Then
		GUICtrlSetState($g_hPicKingGray, $GUI_SHOW)
		GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[0] & " Status: Unavailable", $COLOR_DEBUG)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; --- Card is colored: hero is available ? check MaxLevel ? Upgrading ? Ready ---
	Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[0] + 20, 420 + $g_iMidOffsetY, $bXcoords[0] + 100, 445 + $g_iMidOffsetY, True))
	If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
		GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
		$g_iHeroUpgrading[0] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion, $eHeroDuke))
		SetLog($g_asHeroNames[0] & " Status: Ready", $COLOR_SUCCESS)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; x=65 y=459 (screen)
	If _IsHeroUpgrading($g_aHeroSlotX[0], 429) Then
		GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[0] & " Status: Upgrading", $COLOR_INFO)
		$g_iHeroUpgrading[0] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
		If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroKing) = $eHeroKing) Or _
				($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroKing) = $eHeroKing) Then
			If $g_iSearchNotWaitHeroesEnable Then
			Else
				SetLog("King upgrading and wait enabled, disable wait for King or may never attack", $COLOR_ERROR)
			EndIf
			_GUI_Value_STATE("SHOW", $groupKingSleeping)
		EndIf
	Else
		GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
		$g_iHeroUpgrading[0] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion, $eHeroDuke))
		SetLog($g_asHeroNames[0] & " Status: Ready", $COLOR_SUCCESS)
	EndIf
	If $bCloseWindow Then CloseWindow()
	Return
EndFunc   ;==>_HeroStatus_CheckKing

Func _HeroStatus_CheckQueen($bCloseWindow = True)
	Local $bInitalXcoord = 67
	Local $bDistanceSlot = 153
	Local $bXcoords[6] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4, $bInitalXcoord + $bDistanceSlot * 5]
	; --- Hero card color now uses test coordinate base X=240,Y=225 (spacing handled by $bXcoords) ---
	Local $iGrayYOffset = 225
	Local $iGrayXOffset = 240 - ($bInitalXcoord + 60)
	If _IsCardGray($bXcoords[1] + $iGrayXOffset, 30, $iGrayYOffset) Then
		GUICtrlSetState($g_hPicQueenGray, $GUI_SHOW)
		GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[1] & " Status: Unavailable", $COLOR_DEBUG)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; --- Card is colored: hero is available ? check MaxLevel ? Upgrading ? Ready ---
	Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[1] + 20, 420 + $g_iMidOffsetY, $bXcoords[1] + 100, 445 + $g_iMidOffsetY, True))
	If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
		GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
		$g_iHeroUpgrading[1] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion, $eHeroDuke))
		SetLog($g_asHeroNames[1] & " Status: Ready", $COLOR_SUCCESS)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; x=218 y=459 (screen)
	If _IsHeroUpgrading($g_aHeroSlotX[1], 429) Then
		GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[1] & " Status: Upgrading", $COLOR_INFO)
		$g_iHeroUpgrading[1] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
		If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroQueen) = $eHeroQueen) Or _
				($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroQueen) = $eHeroQueen) Then
			If $g_iSearchNotWaitHeroesEnable Then
			Else
				SetLog("Queen upgrading and wait enabled, disable wait for Queen or may never attack", $COLOR_ERROR)
			EndIf
			_GUI_Value_STATE("SHOW", $groupQueenSleeping)
		EndIf
	Else
		GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
		$g_iHeroUpgrading[1] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroPrince, $eHeroWarden, $eHeroChampion, $eHeroDuke))
		SetLog($g_asHeroNames[1] & " Status: Ready", $COLOR_SUCCESS)
	EndIf
	If $bCloseWindow Then CloseWindow()
	Return
EndFunc   ;==>_HeroStatus_CheckQueen

Func _HeroStatus_CheckPrince($bCloseWindow = True)
	Local $bInitalXcoord = 67
	Local $bDistanceSlot = 153
	Local $bXcoords[6] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4, $bInitalXcoord + $bDistanceSlot * 5]
	; --- Hero card color now uses test coordinate base X=240,Y=225 (spacing handled by $bXcoords) ---
	Local $iGrayYOffset = 225
	Local $iGrayXOffset = 240 - ($bInitalXcoord + 60)
	If _IsCardGray($bXcoords[2] + $iGrayXOffset, 30, $iGrayYOffset) Then
		GUICtrlSetState($g_hPicPrinceGray, $GUI_SHOW)
		GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[2] & " Status: Unavailable", $COLOR_DEBUG)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; --- Card is colored: hero is available ? check MaxLevel ? Upgrading ? Ready ---
	Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[2] + 20, 420 + $g_iMidOffsetY, $bXcoords[2] + 100, 445 + $g_iMidOffsetY, True))
	If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
		GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
		$g_iHeroUpgrading[2] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion, $eHeroDuke))
		SetLog($g_asHeroNames[2] & " Status: Ready", $COLOR_SUCCESS)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; x=371 y=459 (screen)
	If _IsHeroUpgrading($g_aHeroSlotX[2], 429) Then
		GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[2] & " Status: Upgrading", $COLOR_INFO)
		$g_iHeroUpgrading[2] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
		If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroPrince) = $eHeroPrince) Or _
				($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroPrince) = $eHeroPrince) Then
			If $g_iSearchNotWaitHeroesEnable Then
			Else
				SetLog("Prince upgrading and wait enabled, disable wait for Prince or may never attack", $COLOR_ERROR)
			EndIf
			_GUI_Value_STATE("SHOW", $groupPrinceSleeping)
		EndIf
	Else
		GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
		$g_iHeroUpgrading[2] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroWarden, $eHeroChampion, $eHeroDuke))
		SetLog($g_asHeroNames[2] & " Status: Ready", $COLOR_SUCCESS)
	EndIf
	If $bCloseWindow Then CloseWindow()
	Return
EndFunc   ;==>_HeroStatus_CheckPrince

Func _HeroStatus_CheckWarden($bCloseWindow = True)
	Local $bInitalXcoord = 67
	Local $bDistanceSlot = 153
	Local $bXcoords[6] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4, $bInitalXcoord + $bDistanceSlot * 5]
	; --- Hero card color now uses test coordinate base X=240,Y=225 (spacing handled by $bXcoords) ---
	Local $iGrayYOffset = 225
	Local $iGrayXOffset = 240 - ($bInitalXcoord + 60)
	If _IsCardGray($bXcoords[3] + $iGrayXOffset, 30, $iGrayYOffset) Then
		GUICtrlSetState($g_hPicWardenGray, $GUI_SHOW)
		GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[3] & " Status: Unavailable", $COLOR_DEBUG)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; --- Card is colored: hero is available ? check MaxLevel ? Upgrading ? Ready ---
	Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[3] + 20, 420 + $g_iMidOffsetY, $bXcoords[3] + 100, 445 + $g_iMidOffsetY, True))
	If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
		GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
		$g_iHeroUpgrading[3] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion, $eHeroDuke))
		SetLog($g_asHeroNames[3] & " Status: Ready", $COLOR_SUCCESS)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; x=523 y=459 (screen)
	If _IsHeroUpgrading($g_aHeroSlotX[3], 429) Then
		GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[3] & " Status: Upgrading", $COLOR_INFO)
		$g_iHeroUpgrading[3] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
		If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroWarden) = $eHeroWarden) Or _
				($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroWarden) = $eHeroWarden) Then
			If $g_iSearchNotWaitHeroesEnable Then
			Else
				SetLog("Warden upgrading and wait enabled, disable wait for Warden or may never attack", $COLOR_ERROR)
			EndIf
			_GUI_Value_STATE("SHOW", $groupWardenSleeping)
		EndIf
	Else
		GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
		$g_iHeroUpgrading[3] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroChampion, $eHeroDuke))
		SetLog($g_asHeroNames[3] & " Status: Ready", $COLOR_SUCCESS)
	EndIf
	If $bCloseWindow Then CloseWindow()
	Return
EndFunc   ;==>_HeroStatus_CheckWarden

Func _HeroStatus_CheckChampion($bCloseWindow = True)
	Local $bInitalXcoord = 67
	Local $bDistanceSlot = 153
	Local $bXcoords[6] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4, $bInitalXcoord + $bDistanceSlot * 5]
	; --- Hero card color now uses test coordinate base X=240,Y=225 (spacing handled by $bXcoords) ---
	Local $iGrayYOffset = 225
	Local $iGrayXOffset = 240 - ($bInitalXcoord + 60)
	If _IsCardGray($bXcoords[4] + $iGrayXOffset, 30, $iGrayYOffset) Then
		GUICtrlSetState($g_hPicChampionGray, $GUI_SHOW)
		GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[4] & " Status: Unavailable", $COLOR_DEBUG)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; --- Card is colored: hero is available ? check MaxLevel ? Upgrading ? Ready ---
	Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[4] + 20, 420 + $g_iMidOffsetY, $bXcoords[4] + 100, 445 + $g_iMidOffsetY, True))
	If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
		GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
		$g_iHeroUpgrading[4] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroDuke))
		SetLog($g_asHeroNames[4] & " Status: Ready", $COLOR_SUCCESS)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; x=676 y=459 (screen)
	If _IsHeroUpgrading($g_aHeroSlotX[4], 429) Then
		GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[4] & " Status: Upgrading", $COLOR_INFO)
		$g_iHeroUpgrading[4] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
		If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroChampion) = $eHeroChampion) Or _
				($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroChampion) = $eHeroChampion) Then
			If $g_iSearchNotWaitHeroesEnable Then
			Else
				SetLog("Champion upgrading and wait enabled, disable wait for Champion or may never attack", $COLOR_ERROR)
			EndIf
			_GUI_Value_STATE("SHOW", $groupChampionSleeping)
		EndIf
	Else
		GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
		$g_iHeroUpgrading[4] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroDuke))
		SetLog($g_asHeroNames[4] & " Status: Ready", $COLOR_SUCCESS)
	EndIf
	If $bCloseWindow Then CloseWindow()
	Return
EndFunc   ;==>_HeroStatus_CheckChampion

Func _HeroStatus_CheckDuke($bCloseWindow = True)
	ClickDrag(400, 300 + $g_iMidOffsetY, 247, 300 + $g_iMidOffsetY, 50) ; Swipe left 153px (one slot width) to reveal Dragon Duke (6th slot)
	If _Sleep(800) Then Return
	Local $bInitalXcoord = 67
	Local $bDistanceSlot = 153
	Local $bXcoords[6] = [$bInitalXcoord, $bInitalXcoord + $bDistanceSlot, $bInitalXcoord + $bDistanceSlot * 2, $bInitalXcoord + $bDistanceSlot * 3, $bInitalXcoord + $bDistanceSlot * 4, $bInitalXcoord + $bDistanceSlot * 5]
	; --- Hero card color now uses test coordinate base X=240,Y=225 (spacing handled by $bXcoords) ---
	Local $iGrayYOffset = 225
	Local $iGrayXOffset = 240 - ($bInitalXcoord + 60)
	If _IsCardGray($bXcoords[4] + $iGrayXOffset, 30, $iGrayYOffset) Then
		GUICtrlSetState($g_hPicDukeGray, $GUI_SHOW)
		GUICtrlSetState($g_hPicDukeRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[5] & " Status: Unavailable", $COLOR_DEBUG)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; --- Card is colored: hero is available ? check MaxLevel ? Upgrading ? Ready ---
	Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[4] + 20, 420 + $g_iMidOffsetY, $bXcoords[4] + 100, 445 + $g_iMidOffsetY, True))
	If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
		GUICtrlSetState($g_hPicDukeGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeGreen, $GUI_SHOW)
		$g_iHeroUpgrading[5] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
		SetLog($g_asHeroNames[5] & " Status: Ready", $COLOR_SUCCESS)
		If $bCloseWindow Then CloseWindow()
		Return
	EndIf
	; x=718 y=459 (screen) - Duke position after 153px left swipe
	If _IsHeroUpgrading($g_aHeroSlotX[5], 429) Then
		GUICtrlSetState($g_hPicDukeGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicDukeBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeGreen, $GUI_HIDE)
		SetLog($g_asHeroNames[5] & " Status: Upgrading", $COLOR_INFO)
		$g_iHeroUpgrading[5] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroDuke)
		If ($g_abAttackTypeEnable[$DB] And BitAND($g_aiAttackUseHeroes[$DB], $g_aiSearchHeroWaitEnable[$DB], $eHeroDuke) = $eHeroDuke) Or _
				($g_abAttackTypeEnable[$LB] And BitAND($g_aiAttackUseHeroes[$LB], $g_aiSearchHeroWaitEnable[$LB], $eHeroDuke) = $eHeroDuke) Then
			If $g_iSearchNotWaitHeroesEnable Then
			Else
				SetLog("Warning: Dragon Duke Upgrading & Wait enabled, Disable Wait for Duke or may never attack!", $COLOR_ERROR)
			EndIf
			_GUI_Value_STATE("SHOW", $groupDukeSleeping)
		EndIf
	Else
		GUICtrlSetState($g_hPicDukeGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeRed, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeGreen, $GUI_SHOW)
		$g_iHeroUpgrading[5] = 0
		$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion))
		SetLog($g_asHeroNames[5] & " Status: Ready", $COLOR_SUCCESS)
	EndIf
	If $bCloseWindow Then CloseWindow()
	Return
EndFunc   ;==>_HeroStatus_CheckDuke


; === VISUAL STATE HELPERS ===
Func HideShields($bHide = False)
	Local Static $ShieldState[40]
	Local $counter
	If $bHide = True Then
		$counter = 0
		For $i = $g_hPicKingGray To $g_hLbLPetTime
			$ShieldState[$counter] = GUICtrlGetState($i)
			GUICtrlSetState($i, $GUI_HIDE)
			$counter += 1
		Next
	Else
		$counter = 0
		For $i = $g_hPicKingGray To $g_hLbLPetTime
			If $ShieldState[$counter] = 80 Then
				GUICtrlSetState($i, $GUI_SHOW)
			EndIf
			$counter += 1
		Next
	EndIf
EndFunc   ;==>HideShields


; === HERO HALL VALIDATION ===
Func HeroHallValuesCheck()
	If $g_iTownHallLevel > 6 Then
		If $g_aiHeroHallPos[1] = "" Or $g_aiHeroHallPos[1] = -1 Or $g_aiHeroHallPos[2] = -1 Then
			Local $BackToMain = False
			If IsMainGrayed() Then
				$BackToMain = True
				CloseWindow2()
			EndIf
			If ImgLocateHeroHall() Then
				SetLog("Hero Hall found at (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level: " & $g_aiHeroHallPos[2], $COLOR_DEBUG)
				ClearScreen()
				If $BackToMain Then OpenArmyOverview(True, "HeroHallValuesCheck()")
				Return True
			EndIf
			Return False
		EndIf
		Return True
	EndIf
	Return True ; For TH <= 6, no Hero Hall to check, so always return True
EndFunc   ;==>HeroHallValuesCheck
