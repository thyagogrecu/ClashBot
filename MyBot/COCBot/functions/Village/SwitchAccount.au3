; #FUNCTION# ====================================================================================================================
; Name ..........: Switch Account
; Description ...: This file contains the Sequence that runs all MBR Bot
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: chalicucu (6/2016), demen (4/2017)
; Modified ......: Moebius14 (08/2023)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; Return True or False if Switch Account is enabled and current profile in configured list
Func ProfileSwitchAccountEnabled()
	If Not $g_bChkSwitchAcc Or Not aquireSwitchAccountMutex() Then Return False
	Return SetError(0, 0, _ArraySearch($g_asProfileName, $g_sProfileCurrentName) >= 0)
EndFunc   ;==>ProfileSwitchAccountEnabled

; Return True or False if specified Profile is enabled for Switch Account and controlled by this bot instance
Func SwitchAccountEnabled($IdxOrProfilename = $g_sProfileCurrentName)
	Local $sProfile
	Local $iIdx
	If IsInt($IdxOrProfilename) Then
		$iIdx = $IdxOrProfilename
		If $iIdx < 0 Or $iIdx >= UBound($g_asProfileName) Then Return False
		$sProfile = $g_asProfileName[$iIdx]
	Else
		$sProfile = $IdxOrProfilename
		$iIdx = _ArraySearch($g_asProfileName, $sProfile)
	EndIf

	If Not $sProfile Or $iIdx < 0 Or Not $g_abAccountNo[$iIdx] Then
		; not in list or not enabled
		Return False
	EndIf

	; check if mutex is or can be aquired
	Return aquireProfileMutex($sProfile) <> 0
EndFunc   ;==>SwitchAccountEnabled

; retuns copy of $g_abAccountNo validated with SwitchAccountEnabled
Func AccountNoActive()
	Local $iAccountCount = UBound($g_abAccountNo)
	Local $a[$iAccountCount]

	For $i = 0 To $iAccountCount - 1
		$a[$i] = SwitchAccountEnabled($i)
	Next

	Return $a
EndFunc   ;==>AccountNoActive

Func InitiateSwitchAcc($bMainVillageConfirmed = False) ; Checking profiles setup in Mybot, First matching CoC Acc with current profile, Reset all Timers relating to Switch Acc Mode.
	If Not ProfileSwitchAccountEnabled() Or Not $g_bInitiateSwitchAcc Then Return
	$g_iNextAccount = -1
	Local $iStartingAccount = _ArraySearch($g_asProfileName, $g_sProfileCurrentName)
	Local $bStartingAccountActive = False
	SetLog("Switch Account Enabled", $COLOR_INFO)
	SetSwitchAccLog("Initiating: " & $g_iTotalAcc + 1 & " Accounts", $COLOR_SUCCESS)

	If Not $g_bRunState Then Return
	For $i = 0 To $g_iTotalAcc
		; listing all accounts
		Local $sBotType = "Idle"
		If $g_abAccountNo[$i] Then
			If SwitchAccountEnabled($i) Then
				$sBotType = "Active"
				If $g_iNextAccount = -1 Then $g_iNextAccount = $i
				If $i = $iStartingAccount Then $bStartingAccountActive = True
			Else
				$sBotType = "Other Bot"
			EndIf
		EndIf
		SetLog("  - Account [" & $i + 1 & "]: " & $g_asProfileName[$i] & " - " & $sBotType)
		SetSwitchAccLog("  - Acc. " & $i + 1 & ": " & $sBotType)
	Next
	If $bStartingAccountActive Then $g_iNextAccount = $iStartingAccount
	If $g_iNextAccount < 0 Then
		SetLog("No Switch Account profile is available for this bot instance", $COLOR_ERROR)
		SetSwitchAccLog("No available account", $COLOR_ERROR)
		Return
	EndIf
	$g_iCurAccount = $g_iNextAccount ; make sure no crash
	SwitchAccountVariablesReload("Reset")
	SetLog("Starting With Account [" & $g_iNextAccount + 1 & "]")
	SetSwitchAccLog("Start With Account [" & $g_iNextAccount + 1 & "]")
	If Not SwitchCOCAcc($g_iNextAccount, $bMainVillageConfirmed) Then Return
EndFunc   ;==>InitiateSwitchAcc

Func CheckSwitchAcc()
	Local $abAccountNo = AccountNoActive()
	If Not $g_bRunState Then Return
	Local $aActiveAccount = _ArrayFindAll($abAccountNo, True)
	If UBound($aActiveAccount) <= 1 Then Return

	Local $bReachAttackLimit = ($g_aiAttackedCountSwitch[$g_iCurAccount] <= $g_aiAttackedCount - Number($g_iCmbMaxInARow + 1))
	Local $bForceSwitch = False

	If $g_iCommandStop = 0 Or $g_iCommandStop = 3 Then ; Forced to switch when in halt attack mode
		SetLog("Halt Attack Mode Enabled - Switching Account", $COLOR_ACTION)
		SetSwitchAccLog(" - Halt Attack, Force Switch")
		$bForceSwitch = True
	ElseIf $g_iCommandStop = 1 Then
		SetLog("Account Disabled - Switching Account", $COLOR_ACTION)
		SetSwitchAccLog(" - Turn Idle, Force Switch")
		$bForceSwitch = True
	ElseIf $g_iCommandStop = 2 Then
		SetLog("Account Schedule Enabled - Switching Account", $COLOR_ACTION)
		SetSwitchAccLog(" - Off Schedule, Force Switch")
		$bForceSwitch = True
	ElseIf $g_bSwitchAccWaitForCC And $g_bWaitForCCTroopSpell Then
		SetLog("Awaiting CC Troops/Spells - Switching Account", $COLOR_ACTION)
		SetSwitchAccLog(" - Waiting For CC")
		$bForceSwitch = True
	ElseIf $g_bAllBarracksUpgd Then ;Check if all barrack are upgrading, no army can be train --> Force Switch Account
		SetLog("Seems all your barracks are upgrading", $COLOR_INFO)
		SetLog("No troops can be trained, switching account", $COLOR_INFO)
		SetSwitchAccLog(" - All Barracks Upgrading, Force Switch")
		$bForceSwitch = True
	Else
		If $bReachAttackLimit Then
			SetLog("This account has attacked " & Number($g_iCmbMaxInARow + 1) & " time" & (Number($g_iCmbMaxInARow + 1) > 1 ? "s in a row" : "") & ", switching to another account", $COLOR_INFO)
			SetSwitchAccLog(" - Reach Attack Limit: " & $g_aiAttackedCount - $g_aiAttackedCountSwitch[$g_iCurAccount])
			$bForceSwitch = True
		EndIf
	EndIf

	If Not $bForceSwitch Then
		If Not $g_bRunState Then Return
		If _Sleep(500) Then Return
		Return False
	Else
		SetLog("Starting Switch Account", $COLOR_INFO)
		$g_iNextAccount = $g_iCurAccount + 1 ; Classic Switch in Order
		If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0
		Local $iGuard = 0
		While $abAccountNo[$g_iNextAccount] = False
			$g_iNextAccount += 1
			If $g_iNextAccount > $g_iTotalAcc Then $g_iNextAccount = 0     ; avoid idle Account
			$iGuard += 1
			If $iGuard > $g_iTotalAcc Then
				SetLog("No active account found for switch", $COLOR_ERROR)
				Return
			EndIf
			SetDebugLog("- While Account: " & $g_asProfileName[$g_iNextAccount] & " number: " & $g_iNextAccount + 1)
		WEnd
	EndIf

	If Not $g_bRunState Then Return

	SetDebugLog("- Current Account: " & $g_asProfileName[$g_iCurAccount] & " number: " & $g_iCurAccount + 1)
	SetDebugLog("- Next Account: " & $g_asProfileName[$g_iNextAccount] & " number: " & $g_iNextAccount + 1)

	If $g_iNextAccount <> $g_iCurAccount Then
		If Not SwitchAccountBeforeSwitchActions() Then Return False
		If SwitchCOCAcc($g_iNextAccount, True) Then
			$g_bRestart = True
			$g_bRestartRunBot = True
			Return True
		EndIf
	EndIf
	If Not $g_bRunState Then Return

	Return False
EndFunc   ;==>CheckSwitchAcc

Func SwitchAccountBeforeSwitchActions()
	If Not $g_bRunState Then Return False
	If Not SwitchAccountEnsureMainVillage("pre-switch actions") Then Return False
	
	If $g_bRequestTroopsEnable Then
		RequestCC()
		If Not $g_bRunState Then Return False
		If _Sleep(500) Then Return False
	EndIf

	If $g_bChkDonate Then
		DonateCC()
		If Not $g_bRunState Then Return False
		If _Sleep(500) Then Return False
	EndIf

	HelperHut()
	If Not $g_bRunState Then Return False
	If _Sleep(500) Then Return False
	
	If Not SwitchAccountEnsureMainVillage("pre-switch actions") Then Return False
	Return True
EndFunc   ;==>SwitchAccountBeforeSwitchActions

Func SwitchAccountEnsureMainVillage($sReason = "")
	If Not $g_bRunState Then Return False

	$g_bStayOnBuilderBase = False
	If isOnMainVillage(True) Then Return True

	If isOnBuilderBase(True) Or IsMainPageBuilderBase(1) Then
		SetLog("Returning to Main Village before " & $sReason, $COLOR_INFO)
		If Not SwitchBetweenBases(True, False) Then
			SetLog("Cannot return to Main Village before " & $sReason, $COLOR_ERROR)
			Return False
		EndIf
		If isOnMainVillage(True) Then Return True
	EndIf

	If checkMainScreen(True, False) Then Return True
	If isOnBuilderBase(True) Then
		SetLog("Builder Base detected after locating screen, returning to Main Village", $COLOR_INFO)
		If SwitchBetweenBases(True, False) And isOnMainVillage(True) Then Return True
	EndIf

	SetLog("Main Village not available before " & $sReason, $COLOR_ERROR)
	Return False
EndFunc   ;==>SwitchAccountEnsureMainVillage

Func SwitchCOCAcc($NextAccount, $bMainVillageConfirmed = False)
	Local $abAccountNo = AccountNoActive()
	Local $iPreviousAccount = $g_iCurAccount
	Local $sPreviousProfileName = $g_sProfileCurrentName
	If $NextAccount < 0 Or $NextAccount > $g_iTotalAcc Then $NextAccount = _ArraySearch($abAccountNo, True)
	If $NextAccount < 0 Or $NextAccount > $g_iTotalAcc Then
		SetLog("No active account available to switch", $COLOR_ERROR)
		Return False
	EndIf

	Static $iRetry = 0, $bRetryingSwitchAccount = False
	Local $bResult
	If Not $g_bRunState Then Return

	SetLog("Switching To Account [" & $NextAccount + 1 & "]")

	Local $bSharedPrefs = $g_bChkSharedPrefs And HaveSharedPrefs($g_asProfileName[$NextAccount])
	Local $bSharedPrefsReloaded = False
	If $bSharedPrefs And $g_PushedSharedPrefsProfile = $g_asProfileName[$NextAccount] Then
		; shared prefs already pushed
		$bSharedPrefs = False ; don't push again
		SetLog("Profile shared_prefs already pushed")
		If Not $g_bRunState Then Return
		If IsSettingPage(False, 1) Then CloseWindow(2)
		If Not $g_bRunState Then Return
		$bSharedPrefsReloaded = IsMainPage(1) Or IsMainPageBuilderBase(1)
		$bResult = $bSharedPrefsReloaded
		If Not $bResult Then SetLog("Main screen not detected after loading shared_prefs", $COLOR_ERROR)
	Else
		If Not $g_bRunState Then Return
		If $bSharedPrefs Then
			CloseCoC(False)
			If Not $g_bRunState Then Return
			If PushSharedPrefs($g_asProfileName[$NextAccount], False) Then
				Local $bWasSharedPrefsSwitchInProgress = $g_bSharedPrefsSwitchInProgress
				$g_bSharedPrefsSwitchInProgress = True
				OpenCoC()
				$g_bSharedPrefsSwitchInProgress = $bWasSharedPrefsSwitchInProgress
				If Not $g_bRunState Then Return
				$bSharedPrefsReloaded = IsMainPage(1) Or IsMainPageBuilderBase(1)
				$bResult = $bSharedPrefsReloaded
				If Not $bResult Then SetLog("Main screen not detected after loading shared_prefs", $COLOR_ERROR)
			Else
				$bResult = False
				SetLog("Could not load shared_prefs for account [" & $NextAccount + 1 & "]", $COLOR_ERROR)
			EndIf
		Else
		Local $bMainVillageReady = $bMainVillageConfirmed
		If Not $bMainVillageReady Then $bMainVillageReady = SwitchAccountEnsureMainVillage("opening settings")
		If Not $bMainVillageReady Then
			$bResult = False
		Else
			If Not SwitchCOCAcc_OpenSettings() Then
				$bResult = False
				SetLog("Cannot open Settings to switch account", $COLOR_ERROR)
				
				; Attempt to recover by restarting Clash of Clans
				SetLog("Restarting Game Instance", $COLOR_ACTION)
				CloseCoC()
				If _Sleep(2500) Then Return
				OpenCoC()
				If _Sleep(5000) Then Return
				waitMainScreen()
				If Not $g_bRunState Then Return
			Else
				While 1
					If Not IsSettingPage() Then ExitLoop

					If $g_bChkSharedPrefs Then
						Switch SwitchCOCAcc_DisconnectConnect($bResult, $bSharedPrefs)
							Case 0
								Return
							Case -1
								ExitLoop
						EndSwitch
						Switch SwitchCOCAcc_ClickAccount($bResult, $NextAccount, $bSharedPrefs)
							Case "OK"
								; all good
								If $g_bChkSharedPrefs Then
									If $bSharedPrefs Then
										CloseCoC(False)
										$bResult = True
										ExitLoop
									Else
										SetLog($g_asProfileName[$NextAccount] & " missing shared_prefs, using normal switch account", $COLOR_WARNING)
									EndIf
								EndIf
							Case "Error"
								; some problem
								ExitLoop
							Case "Exit"
								; no $g_bRunState
								Return
						EndSwitch
					ElseIf $g_bChkSuperCellID Then
						Switch SwitchCOCAcc_ConnectedSCID($bResult)
							Case "OK"
								; all good
							Case "Error"
								; some problem
								ExitLoop
							Case "Exit"
								; no $g_bRunState
								Return
						EndSwitch
						Switch SwitchCOCAcc_ClickAccountSCID($bResult, $NextAccount, 2)
							Case "OK"
								; all good
							Case "Error"
								; some problem
								ExitLoop
							Case "Exit"
								; no $g_bRunState
								Return
						EndSwitch

					EndIf
					ExitLoop
				WEnd
			EndIf
		EndIf
		EndIf
		If _Sleep(500) Then Return
	EndIf

	If $bResult Then
		$iRetry = 0
		$g_bReMatchAcc = False
		If Not $g_bRunState Then Return
		If Not $g_bInitiateSwitchAcc Then SwitchAccountVariablesReload("Save")
		If $g_ahTimerSinceSwitched[$g_iCurAccount] <> 0 Then
			If Not $g_bReMatchAcc Then SetSwitchAccLog(" - Acc. " & $g_iCurAccount + 1 & ", Online: " & Int(__TimerDiff($g_ahTimerSinceSwitched[$g_iCurAccount]) / 1000 / 60) & "m")
			SetTime(True)
			$g_aiRunTime[$g_iCurAccount] += __TimerDiff($g_ahTimerSinceSwitched[$g_iCurAccount])
			$g_ahTimerSinceSwitched[$g_iCurAccount] = 0
		EndIf

		Local $bProfileChange = $g_sProfileCurrentName <> $g_asProfileName[$NextAccount]
		If $bProfileChange And $g_sWindowLayoutProfile = "" Then $g_sWindowLayoutProfile = $g_sProfileCurrentName
		If $bProfileChange Then saveConfig() ; Save before loading the next account state

		$g_iCurAccount = $NextAccount
		SwitchAccountVariablesReload()

		$g_ahTimerSinceSwitched[$g_iCurAccount] = __TimerInit()
		$g_hTimerSinceAccountSwitch = __TimerInit()
		$g_bInitiateSwitchAcc = False
		If $bProfileChange Then
			If $g_iGuiMode = 1 Then
				; normal GUI Mode
				_GUICtrlComboBox_SetCurSel($g_hCmbProfile, _GUICtrlComboBox_FindStringExact($g_hCmbProfile, $g_asProfileName[$NextAccount]))
				If Not LoadProfile(False) Then _GUICtrlComboBox_SelectString($g_hCmbProfile, $g_sProfileCurrentName)
				DisableGUI_AfterLoadNewProfile()
			Else
				; mini or headless GUI Mode
				; saveConfig()
				$g_sProfileCurrentName = $g_asProfileName[$NextAccount]
				LoadProfile(False)
			EndIf
			AutoAlignWindowsCheck()
		EndIf

		SetSwitchAccLog("Switched To Account [" & $NextAccount + 1 & "]", $COLOR_SUCCESS)
		CreateLogFile() ; Cause use of the right log file after switch
		If Not $g_bRunState Then Return

		If $g_bBBSpamDisabledDueToFull Then
			If Not ($g_bCCSpamEnabled Or $g_bRushAttackEnabled) Then
				$g_bBBSpamEnabled = True
				If $g_hbtnBBSpam <> 0 Then
					GUICtrlSetData($g_hbtnBBSpam, "BBSpam")
					GUICtrlSetBkColor($g_hbtnBBSpam, 0x90EE90) ; Light green background
				EndIf
				SetLog("» BB SPAM RE-ENABLED FOR NEXT ACCOUNT «", $COLOR_SUCCESS)
			EndIf
			$g_bBBSpamDisabledDueToFull = False
		EndIf

		If $g_bRushAttackReenableAfterSwitch Then
			If Not ($g_bBBSpamEnabled Or $g_bCCSpamEnabled) Then
				$g_bRushAttackEnabled = True
				$g_bRushAttackRunning = False
				If $g_hBtnRushAttack <> 0 Then
					GUICtrlSetData($g_hBtnRushAttack, "Rush")
					GUICtrlSetBkColor($g_hBtnRushAttack, 0x90EE90)
				EndIf
				SetLog("» RUSH ATTACK RE-ENABLED FOR NEXT ACCOUNT «", $COLOR_SUCCESS)
			EndIf
			$g_bRushAttackReenableAfterSwitch = False
		EndIf

		If $g_bChkSharedPrefs And Not $bSharedPrefsReloaded Then
			; disconnect account again for saving shared_prefs
			waitMainScreen()
			If SwitchAccountEnsureMainVillage("saving shared_prefs") Then
				If SwitchCOCAcc_OpenSettings() Then
					If SwitchCOCAcc_DisconnectConnect($bResult, $g_bChkSharedPrefs) = -1 Then Return ;Return if Error happend

					Switch SwitchCOCAcc_ClickAccount($bResult, $NextAccount, $g_bChkSharedPrefs, False)
						Case "OK"
							; all good
							PullSharedPrefs()
					EndSwitch
				EndIf
			EndIf
		EndIf
		If Not $g_bRunState Then Return
	Else
		$iRetry += 1
		$g_bReMatchAcc = True
		SetLog("Switching Account Failed!", $COLOR_ERROR)
		SetSwitchAccLog("Switching To Account " & $NextAccount + 1 & " Failed!", $COLOR_ERROR)
		If $iRetry = 1 Then
			If $g_bRunState And Not $bRetryingSwitchAccount Then
				$bRetryingSwitchAccount = True
				SetLog("Restarting bot to retry account switching", $COLOR_ACTION)
				SetSwitchAccLog("Restarting bot to retry account switching", $COLOR_ACTION)
				btnStop()
				_Sleep(3000, True, False)
				btnStart()
				$bRetryingSwitchAccount = False
			EndIf
		ElseIf $iRetry <= 3 Then
			Local $ClickPoint = $aCloseTabSCID
			ClickP($ClickPoint, 1, 500)
			If _Sleep(1500) Then Return
			CloseWindow2()
			If _Sleep(500) Then Return
			checkMainScreen()
		Else
			$iRetry = 0
			;HArchH Testing for close Android on repeated switch fail.
			SetLog("Switching account failed too many times, restarting emulator", $COLOR_ERROR)
			SetSwitchAccLog("Too many fails, restarting emulator", $COLOR_ERROR)
			If _Sleep(2000) Then Return
			CloseAndroid("Restart Emulator")
		EndIf
		If Not $g_bRunState Then Return
		Return False
	EndIf
	waitMainScreen()
	If Not $g_bRunState Then Return
	CheckObstacles()

	SetLog("Switched Account - Loaded Town Hall Level: " & $g_iTownHallLevel)
	GUICtrlSetData($g_hGrpVillage, GetTranslatedFileIni("MBR Main GUI", "Tab_02", "Village") & "[TH" & $g_iTownHallLevel & "]" & ": " & $g_sProfileCurrentName)

	;Display Level TH in Stats
	GUICtrlSetData($g_hLblTHLevels, "")
	_GUI_Value_STATE("HIDE", $g_aGroupListTHLevels)
	GUICtrlSetState($g_ahPicTHLevels[$g_iTownHallLevel], $GUI_SHOW)
	GUICtrlSetData($g_hLblTHLevels, $g_iTownHallLevel)

	If $NextAccount <> $iPreviousAccount Then PushMsg("SwitchAccount", $sPreviousProfileName)

	RestartMBRFunc("Account Switch")

	Return True
EndFunc   ;==>SwitchCOCAcc

Func SwitchCOCAcc_OpenSettings()
	If Not $g_bRunState Then Return False
	If IsSettingPage(False, 1) Then Return True

	Click(Random(42, 54, 1), Random(76, 88, 1), 1, 120, "Open Player Profile")
	If _Sleep(750) Then Return False

	Click(Random(693, 703, 1), Random(146, 156, 1), 1, 120, "Open Settings")
	If _Sleep(500) Then Return False
	Return IsSettingPage()
EndFunc   ;==>SwitchCOCAcc_OpenSettings

Func SwitchCOCAcc_DisconnectConnect(ByRef $bResult, $bDisconnectOnly = $g_bChkSharedPrefs)
	If Not $g_bRunState Then Return -1

	For $i = 0 To 20 ; Checking Green Connect Button continuously in 20sec
		; SupercellID
		Local $aSuperCellIDConnected = decodeSingleCoord(findImage("SupercellID Connected", $g_sImgSupercellIDConnected, GetDiamondFromRect("660,150,760,200"), 1, True, Default))
		If IsArray($aSuperCellIDConnected) And UBound($aSuperCellIDConnected, 1) >= 2 Then
			SetLog("Account connected to SuperCell ID")
			Return 1
		EndIf
		If $i = 20 Then
			$bResult = False
			Return -1
		EndIf
		If _Sleep(400) Then Return 0
		If Not $g_bRunState Then Return 0
	Next

	Return -1
EndFunc   ;==>SwitchCOCAcc_DisconnectConnect

Func SwitchCOCAcc_ClickAccount(ByRef $bResult, $iNextAccount, $bStayDisconnected = $g_bChkSharedPrefs, $bLateDisconnectButtonCheck = True)
	FuncEnter(SwitchCOCAcc_ClickAccount)

	Local $aSearchForAccount, $aCoordinates[0][2], $aTempArray

	For $i = 0 To 20 ; Checking Account List continuously in 20sec
		; SupercellID
		Local $aSuperCellIDConnected = decodeSingleCoord(findImage("SupercellID Connected", $g_sImgSupercellIDConnected, GetDiamondFromRect("660,150,760,200"), 1, True, Default))
		If IsArray($aSuperCellIDConnected) And UBound($aSuperCellIDConnected, 1) >= 2 Then
			SetLog("Account connected to SuperCell ID, cannot disconnect")
			If $bStayDisconnected Then
				ClickAway()
				Return FuncReturn("OK")
			EndIf
		EndIf
		If $i = 20 Then
			$bResult = False
			Return FuncReturn("Error")
		EndIf
		If _Sleep(400) Then Return FuncReturn("Exit")
		If Not $g_bRunState Then Return FuncReturn("Exit")
	Next
	Return FuncReturn("") ; should never get here
EndFunc   ;==>SwitchCOCAcc_ClickAccount

Func SwitchCOCAcc_ConnectedSCID(ByRef $bResult)
	For $i = 0 To 20
		Local $aSuperCellIDReload = decodeSingleCoord(findImage("SupercellID Reload", $g_sImgSupercellIDReload, GetDiamondFromRect("550,175,610,235"), 1, True, Default))
		If IsArray($aSuperCellIDReload) And UBound($aSuperCellIDReload, 1) >= 2 Then
			Click($aSuperCellIDReload[0], $aSuperCellIDReload[1], 1, 120, "Click Reload SC_ID")
			SetLog("   1. Click Reload Supercell ID")
			If $g_bDebugSetLog Then SetSwitchAccLog("   1. Click Reload Supercell ID")
			If _Sleep(3000) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			Return "OK"
		EndIf

		If $i = 20 Then
			SetDebugLog("Supercell ID Reload image not found, using fallback click", $COLOR_WARNING)
			Click(Random(572, 582, 1), Random(200, 210, 1), 1, 120, "Click Reload SC_ID Fallback")
			SetLog("   1. Click Reload Supercell ID")
			If $g_bDebugSetLog Then SetSwitchAccLog("   1. Click Reload Supercell ID")
			If _Sleep(3000) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			Return "OK"
		EndIf
		If _Sleep(400) Then Return "Exit"
		If Not $g_bRunState Then Return "Exit"
	Next
	Return ""
EndFunc   ;==>SwitchCOCAcc_ConnectedSCID

Func SwitchCOCAcc_ClickAccountSCID(ByRef $bResult, $NextAccount, $iStep = 2, $bVerifyAcc = True, $bDebuglog = $g_bDebugSetLog, $bDebugImageSave = $g_bDebugImageSave)
	Local $sAccountDiamond = GetDiamondFromRect2(540, 323 + $g_iMidOffsetY, 590, 695 + $g_iMidOffsetY)
	Local $aSuperCellIDWindowsUI
	Local $iIndexSCID = $NextAccount
	Local $aSearchForAccount, $aCoordinates[0][2], $aTempArray

	If Not $g_bRunState Then Return "Exit"

	For $i = 0 To 30 ; Checking "New SuperCellID UI" continuously in 30sec
		$aSuperCellIDWindowsUI = decodeSingleCoord(findImage("SupercellID Windows", $g_sImgSupercellIDWindows, GetDiamondFromRect2(670, 80, 810, 140 + $g_iMidOffsetY), 1, True, Default))
		If _Sleep(500) Then Return "Exit"
		If IsArray($aSuperCellIDWindowsUI) And UBound($aSuperCellIDWindowsUI, 1) >= 2 Then
			SetLog("Loading Profile List...")
			If _Sleep(3000) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"

			If $bVerifyAcc Then
				; verifiy SCID Account slots has not moved for accounts 0 to 3
				If $g_iTotalAcc < 4 Then

					If Not IsSCIDAccComplete($g_iTotalAcc) Then
						$bResult = False
						Return "Error"
					EndIf

				Else

					If Not IsSCIDAccComplete() Then
						$bResult = False
						Return "Error"
					EndIf

				EndIf
			EndIf

			; Make Drag only when SCID window is visible.
			If Not SCIDragIfNeeded($NextAccount, $bVerifyAcc) Then
				SetLog("SCIDragIfNeeded Failed")
				$bResult = False
				Return "Error"
			EndIf

			If $g_bDebugSetLog Then SetSwitchAccLog("Switching To Account: " & $NextAccount + 1, $COLOR_DEBUG)

			If $bDebugImageSave Then SaveDebugDiamondImage("ClickAccountSCID", $sAccountDiamond)

			$aSearchForAccount = decodeMultipleCoords(findImage("Account Locations", $g_sImgSupercellIDSlots, $sAccountDiamond, 0, True, Default))
			If _Sleep(500) Then Return "Exit"
			If Not $g_bRunState Then Return "Exit"
			If IsArray($aSearchForAccount) And UBound($aSearchForAccount) > 0 Then
				SetDebugLog("SCID Accounts: " & UBound($aSearchForAccount), $COLOR_DEBUG)
				SetLog("SCID Accounts: " & UBound($aSearchForAccount), $COLOR_DEBUG)

				If $g_bDebugSetLog Then SetSwitchAccLog("SCID Accounts: " & UBound($aSearchForAccount), $COLOR_DEBUG)

				; Correct Index for Profile if needs to drag
				If $NextAccount >= 3 And UBound($aSearchForAccount) == 4 Then $iIndexSCID = 3 ; based on drag logic, the account will always be the bottom one

				; fixes weird issue with arrays after getting image info
				For $j = 0 To UBound($aSearchForAccount) - 1
					$aTempArray = $aSearchForAccount[$j]
					_ArrayAdd($aCoordinates, $aTempArray[0] & "|" & $aTempArray[1], 0, "|", @CRLF, $ARRAYFILL_FORCE_NUMBER)
				Next

				_ArraySort($aCoordinates, 0, 0, 0, 1) ; sort by column 1 [Y]... this is to keep them in order of actual list

				If IsArray($aCoordinates) And UBound($aCoordinates) > 1 And UBound($aCoordinates, $UBOUND_ROWS) > 1 Then

					; list all account see-able after drag on debug chat
					Local $iProfiles = UBound($g_asProfileName)

					For $j = 0 To UBound($aCoordinates) - 1
						SetDebugLog("[" & $j + 1 & "] Account coordinates: " & $aCoordinates[$j][0] & "," & $aCoordinates[$j][1] & " named: " & $g_asProfileName[$NextAccount - $iIndexSCID + $j])
						If $g_bDebugSetLog Then SetSwitchAccLog("[" & $j + 1 & "] A/C coord: " & $aCoordinates[$j][0] & "," & $aCoordinates[$j][1] & " Profile: " & $g_asProfileName[$NextAccount - $iIndexSCID + $j])
					Next

					SetLog("   " & $iStep & ". Click Account [" & $NextAccount + 1 & "] Supercell ID - Profile: " & $g_asProfileName[$NextAccount])

					Local $AccountX = Random($aCoordinates[$iIndexSCID][0] - 20, $aCoordinates[$iIndexSCID][0] + 190, 1)
					Local $AccountY = Random($aCoordinates[$iIndexSCID][1] - 20, $aCoordinates[$iIndexSCID][1] + 25, 1)
					Click($AccountX, $AccountY, 1, 120, "#0155") ;Click Account
					If _Sleep(750) Then Return "Exit"
					SetLog("   " & $iStep + 1 & ". Loading Clash of Clans!")
					$bResult = True
					Return "OK"

				EndIf

			EndIf
		EndIf

		If $i = 30 Then
			$bResult = False
			Return "Error"
		EndIf
		If _Sleep(400) Then Return "Exit"
		If Not $g_bRunState Then Return "Exit"
	Next
	Return "" ; should never get here
EndFunc   ;==>SwitchCOCAcc_ClickAccountSCID

Func DisableGUI_AfterLoadNewProfile()
	If $g_bUnlockMode Then
		EnableGuiControls(True, True)
		Return
	EndIf
	$g_bGUIControlDisabled = True
	For $i = $g_hFirstControlToHide To $g_hLastControlToHide
		If IsAlwaysEnabledControl($i) Then ContinueLoop
		If $i >= $g_hClanGamesTV And $i < $g_hChkForceAttackOnClanGames Then ContinueLoop
		If $i >= $g_hChkForceAttackOnClanGames And $i <= $g_hBtnCGSettingsClose Then ContinueLoop
		If BitAND(GUICtrlGetState($i), $GUI_ENABLE) Then GUICtrlSetState($i, $GUI_DISABLE)
	Next
	ControlEnable("", "", $g_hCmbGUILanguage)
	$g_bGUIControlDisabled = False
EndFunc   ;==>DisableGUI_AfterLoadNewProfile

Func aquireSwitchAccountMutex($iSwitchAccountGroup = $g_iCmbSwitchAcc, $bReturnOnlyMutex = False, $bShowMsgBox = False)
	Local $sMsg = GetTranslatedFileIni("MBR GUI Design Child Bot - Profiles", "Msg_SwitchAccounts_InUse", "Switch Accounts Group %s is already in use or active", $iSwitchAccountGroup)
	If $iSwitchAccountGroup Then
		Local $hMutex_Profile = 0
		If $g_ahMutex_SwitchAccountsGroup[0] = $iSwitchAccountGroup And $g_ahMutex_SwitchAccountsGroup[1] Then
			$hMutex_Profile = $g_ahMutex_SwitchAccountsGroup[1]
		Else
			$hMutex_Profile = CreateMutex(StringReplace($g_sProfilePath & "\SwitchAccount.0" & $iSwitchAccountGroup, "\", "-"))
			$g_ahMutex_SwitchAccountsGroup[0] = $iSwitchAccountGroup
			$g_ahMutex_SwitchAccountsGroup[1] = $hMutex_Profile
		EndIf
		If $bReturnOnlyMutex Then
			Return $hMutex_Profile
		EndIf

		If $hMutex_Profile = 0 Then
			; mutex already in use
			SetLog($sMsg, $COLOR_ERROR)
			;SetLog($sMsg, "Cannot switch to profile " & $sProfile, $COLOR_ERROR)
			If $bShowMsgBox Then
				MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION, $MB_TOPMOST), $g_sBotTitle, $sMsg)
			EndIf
		EndIf
		Return $hMutex_Profile <> 0
	EndIf
	Return False
EndFunc   ;==>aquireSwitchAccountMutex

Func releaseSwitchAccountMutex()
	If $g_ahMutex_SwitchAccountsGroup[1] Then
		ReleaseMutex($g_ahMutex_SwitchAccountsGroup[1])
		$g_ahMutex_SwitchAccountsGroup[0] = 0
		$g_ahMutex_SwitchAccountsGroup[1] = 0
		Return True
	EndIf
	Return False
EndFunc   ;==>releaseSwitchAccountMutex

; Checks if "Log in with Supercell ID" boot screen shows up and closes CoC and pushes shared_prefs to fix Or Click on Current account if SCID Connect Mode
Func CheckLoginWithSupercellIDScreen()

	Local $bResult = False

	If Not $g_bRunState Then Return

	; "Log in with Supercell ID" check be there, validate with imgloc
	Local $aiLogin = decodeSingleCoord(FindImageInPlace2("LoginWithSupercellID", $g_sImgLoginWithSupercellID, 100, 595 + $g_iBottomOffsetY, 425, 655 + $g_iBottomOffsetY, True))

	If IsArray($aiLogin) And UBound($aiLogin) = 2 Then
		Local $iAccount = 0 ; default first account on list

		SetLog("Verified Log in with Supercell ID boot screen for login")

		If $g_bChkSharedPrefs Then
			If HaveSharedPrefs($g_sProfileCurrentName) Then
				SetLog("Close CoC and push shared_prefs for Supercell ID screen")
				PushSharedPrefs()
				Return True
			Else
				SetLog("Shared_prefs not pulled", $COLOR_ERROR)
				SetLog("Please pull shared_prefs in tab Bot/Profiles", $COLOR_INFO)
				Click($aiLogin[0], $aiLogin[1], 1, 120, "Click Log in with SC_ID")
				If _Sleep(2000) Then Return
				$bResult = True
				If ProfileSwitchAccountEnabled() Then
					$iAccount = _ArraySearch($g_asProfileName, $g_sProfileCurrentName)
				Else
					If $g_bOnlySCIDAccounts Then $iAccount = $g_iWhatSCIDAccount2Use
				EndIf
				Switch SwitchCOCAcc_ClickAccountSCID($bResult, $iAccount, 1, False)
					Case "OK"
						; all good
						Return True
					Case "Error"
						; some problem
					Case "Exit"
						; no $g_bRunState
				EndSwitch
			EndIf
		EndIf

		If $g_bChkSuperCellID Then
			Click($aiLogin[0], $aiLogin[1], 1, 120, "Click Log in with SC_ID")
			If _Sleep(2000) Then Return
			$bResult = True
			If ProfileSwitchAccountEnabled() Then
				$iAccount = _ArraySearch($g_asProfileName, $g_sProfileCurrentName)
			Else
				If $g_bOnlySCIDAccounts Then $iAccount = $g_iWhatSCIDAccount2Use
			EndIf
			Switch SwitchCOCAcc_ClickAccountSCID($bResult, $iAccount, 1, False)
				Case "OK"
					; all good
					Return True
				Case "Error"
					; some problem
				Case "Exit"
					; no $g_bRunState
			EndSwitch
		EndIf
	EndIf
	Return False
EndFunc   ;==>CheckLoginWithSupercellIDScreen

Func SwitchAccountCheckProfileInUse($sNewProfile)
	; now check if profile is used in another group
	Local $sInGroups = ""
	For $g = 1 To 8
		If $g = $g_iCmbSwitchAcc Then ContinueLoop
		; find group this profile belongs to: no switch profile config is saved in config.ini on purpose!
		Local $sSwitchAccFile = $g_sProfilePath & "\SwitchAccount.0" & $g & ".ini"
		If FileExists($sSwitchAccFile) = 0 Then ContinueLoop
		Local $sProfile
		Local $bEnabled
		Local $iTotalCocAccount = Int(IniRead($sSwitchAccFile, "SwitchAccount", "TotalCocAccount", 0))
		If $iTotalCocAccount > UBound($g_asProfileName) - 1 Then $iTotalCocAccount = UBound($g_asProfileName) - 1
		For $i = 1 To $iTotalCocAccount + 1
			$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "Enable", "") = "1"
			If $bEnabled Then
				$bEnabled = IniRead($sSwitchAccFile, "SwitchAccount", "AccountNo." & $i, "") = "1"
				If $bEnabled Then
					$sProfile = IniRead($sSwitchAccFile, "SwitchAccount", "ProfileName." & $i, "")
					If $sProfile = $sNewProfile Then
						; found profile
						If $sInGroups <> "" Then $sInGroups &= ", "
						$sInGroups &= $g
					EndIf
				EndIf
			EndIf
		Next
	Next

	If $sInGroups Then
		If StringLen($sInGroups) > 2 Then
			$sInGroups = "used in groups " & $sInGroups
		Else
			$sInGroups = "used in group " & $sInGroups
		EndIf
	EndIf

	; test if profile can be aquired
	Local $iAquired = aquireProfileMutex($sNewProfile)
	If $iAquired Then
		If $iAquired = 1 Then
			; ok, release again
			releaseProfileMutex($sNewProfile)
		EndIf

		If $sInGroups Then
			; write to log
			SetLog("Profile " & $sNewProfile & " not active, but " & $sInGroups & "!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " " & $sInGroups & "!", $COLOR_ERROR)
			Return False
		EndIf

		Return True
	Else
		; write to log
		If $sInGroups Then
			SetLog("Profile " & $sNewProfile & " active and " & $sInGroups & "!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " active & " & $sInGroups & "!", $COLOR_ERROR)
		Else
			SetLog("Profile " & $sNewProfile & " active in another bot instance!", $COLOR_ERROR)
			SetSwitchAccLog($sNewProfile & " active!", $COLOR_ERROR)
		EndIf
		Return False
	EndIf
EndFunc   ;==>SwitchAccountCheckProfileInUse

Func SCIDragIfNeeded($iSCIDAccount, $bVerifyAcc = True)
	If Not $g_bRunState Then Return

	If $iSCIDAccount < 4 Then Return True

	Local Const $iDragPixelsPerAccount = 104
	Local Const $iMaxDragPixels = 220
	Local $iDragRemaining = $iDragPixelsPerAccount * ($iSCIDAccount - 3)

	While $iDragRemaining > 0
		Local $iDragPixels = ($iDragRemaining > $iMaxDragPixels) ? $iMaxDragPixels : $iDragRemaining
		Local $x1 = Random(560, 790, 1)
		Local $x2 = Random($x1 - 20, $x1 + 20, 1)
		Local $y = Random(650, 690, 1)

		SetLog("ClickDrag SCID Window(" & $x1 & "," & $y & ")")
		SetLog("ClickDrag SCID Window(" & $x2 & "," & $y - $iDragPixels & ")")

		ClickDrag($x1, $y, $x2, $y - $iDragPixels, 500, True)
		If _Sleep(650) Then Return
		$iDragRemaining -= $iDragPixels
	WEnd
	If _Sleep(1000) Then Return

	If $bVerifyAcc Then
		If Not IsSCIDAccComplete($iSCIDAccount, $iSCIDAccount < 8) Then Return False
	EndIf

	Return True
EndFunc   ;==>SCIDragIfNeeded

Func IsSCIDAccComplete($iAccounts = 3, $bRequireProfileImage = True)
	SetLog("Checking SCID Account Slots", $COLOR_INFO)
	Local $iDistanceBetweenAccounts = 96
	Local $aiHeadCoord
	Local $aiSearchArea[4] = [455, 347, 845, 437]
	Local $bSaveImage = False
	Local $bResult = True
	Local $iLoop = 3

	Local $sFolder = @ScriptDir & "\Profiles\SCID_Errors\"
	Local $j = 0

	; Profile Index offset
	SetDebugLog("$iAccounts : " & $iAccounts)
	If $iAccounts < 4 Then
		Local $j = 0
		$iLoop = $iAccounts
	Else
		Local $j = $iAccounts - 3
	EndIf

	; check the barbarians are in their expected location
	For $i = 0 To $iLoop
		Local $sProfileFolder = @ScriptDir & "\Profiles\" & $g_asProfileName[$i + $j] & "\"

		SetLog("Checking SCID Slot: " & $i)

		; SCIDHead is the primary account-slot detector.
		$aiHeadCoord = decodeSingleCoord(findImage("IsSCIDAccComplete", $g_sImgSupercellIDSlots, GetDiamondFromArray($aiSearchArea), 1, True))
		Local $bHeadFound = False
		If IsArray($aiHeadCoord) Then $bHeadFound = UBound($aiHeadCoord, $UBOUND_ROWS) >= 2

		If Not $bHeadFound Then
			SetSwitchAccLog("Slot: " & $i & " Barbarian Head missing!")
			$bSaveImage = True
			$bResult = False
		Else
			Local $Oldfilename = String($g_asProfileName[$i + $j] & "_0_98.png")
			Local $filename = String($g_asProfileName[$i + $j] & "_0_91.png")
			If FileExists($sProfileFolder & $Oldfilename) Then
				FileMove($sProfileFolder & $Oldfilename, $sProfileFolder & $filename)
				If _Sleep($DELAYRESPOND) Then Return
				FileDelete($sProfileFolder & $Oldfilename)
			EndIf

			; Check if any reference images exist
			Local $aImageSuffixes[1] = ["_0_91.png"]
			Local $bAnyImageExists = False
			For $k = 0 To UBound($aImageSuffixes) - 1
				Local $currentFilename = String($g_asProfileName[$i + $j] & $aImageSuffixes[$k])
				If FileExists($sProfileFolder & $currentFilename) Then
					$bAnyImageExists = True
					ExitLoop
				EndIf
			Next

			If $bAnyImageExists And $bRequireProfileImage Then
				Local $bImageFound = False
				Local $aiVillageNameCoord

				For $k = 0 To UBound($aImageSuffixes) - 1
					Local $currentFilename = String($g_asProfileName[$i + $j] & $aImageSuffixes[$k])
					If Not FileExists($sProfileFolder & $currentFilename) Then ContinueLoop

					For $iProfileTry = 1 To 3
						$aiVillageNameCoord = decodeSingleCoord(findImage("IsSCIDAccComplete", $sProfileFolder & $currentFilename, GetDiamondFromArray($aiSearchArea), 1, True))
						If IsArray($aiVillageNameCoord) And UBound($aiVillageNameCoord, $UBOUND_ROWS) >= 2 Then
							SetSwitchAccLog("Image: " & $g_asProfileName[$i + $j] & " - OK! (Using " & $currentFilename & ")")
							SetLog("SCID Account Image: " & $g_asProfileName[$i + $j] & " - OK! (Using " & $currentFilename & ")")
							$bImageFound = True
							ExitLoop 2
						EndIf
						If _Sleep(600) Then Return
					Next
				Next

				If Not $bImageFound Then
					SetSwitchAccLog("Image: " & $g_asProfileName[$i + $j] & " - Missing!")
					SetLog("SCID Account Image: " & $g_asProfileName[$i + $j] & " - Missing!")
					$bSaveImage = True
					$bResult = False
				EndIf
			ElseIf Not $bAnyImageExists Then
				Local $x = $aiHeadCoord[0] - 13
				Local $y = $aiHeadCoord[1] - 26
				Local $oBitmap = _GDIPlus_BitmapCreateFromHBITMAP($g_hHBitmap2)
				Local $hClone = _GDIPlus_BitmapCloneArea($oBitmap, $x, $y, 96, 20, $GDIP_PXF24RGB)
				_GDIPlus_ImageSaveToFile($hClone, $sProfileFolder & $filename)
				_GDIPlus_BitmapDispose($hClone)
				_GDIPlus_BitmapDispose($oBitmap)
				SetSwitchAccLog($g_asProfileName[$i + $j] & " Image Stored: " & $filename)
				SetLog($g_asProfileName[$i + $j] & " Image Stored: " & $filename, $COLOR_SUCCESS)
			Else
				SetDebugLog("Skipping SCID profile image validation for " & $g_asProfileName[$i + $j], $COLOR_DEBUG)
			EndIf
		EndIf

		$aiSearchArea[1] = ($aiSearchArea[1] + $iDistanceBetweenAccounts)
		$aiSearchArea[3] = ($aiSearchArea[3] + $iDistanceBetweenAccounts)

		If _Sleep(250) Then Return

		If $i = 3 Then ExitLoop
	Next

	If $bSaveImage = True Then
		If Not FileExists($sFolder) Then DirCreate($sFolder)
		SaveSCIDebugImage("SCID_Errors", False)
	EndIf

	Return $bResult
EndFunc   ;==>IsSCIDAccComplete
