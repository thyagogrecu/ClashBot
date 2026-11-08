; #FUNCTION# ===========================================================================================================
; Name ..........: MultiBot
; Author ........: Phael
; Description ...: Manages MyBot profiles, emulator instances, launch parameters, and grouped process control.
; Remarks .......: Profile-specific actions preserve independent emulator and bot process ownership.
; ======================================================================================================================

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=images\MyBot.ico
#AutoIt3Wrapper_Outfile=MultiBot
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=MultiBot for MyBot.run
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; === DEPENDENCIES ===
#include "MyBot.run.version.au3"
#include <FileConstants.au3>
#include <MsgBoxConstants.au3>
#include <AutoItConstants.au3>
#include <ListBoxConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <GuiButton.au3>
#include <TrayConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <StringConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3>
#include <ProcessConstants.au3>
#include <WinAPIProc.au3>
#include <WinAPISys.au3>
#include <GuiMenu.au3>
#include <InetConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <EditConstants.au3>
#include <ColorConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>
#include <SendMessage.au3>

; === SINGLE INSTANCE HANDLING ===
If _Singleton("MultiBot", 1) = 0 Then
    ; Find window even if hidden
    Local $hWnd = WinGetHandle("MultiBot")
    If @error Then
        ; Try by class if title doesn't work
        Local $aWinList = WinList("[CLASS:AutoIt v3 GUI]")
        For $i = 1 To $aWinList[0][0]
            If StringInStr(WinGetTitle($aWinList[$i][1]), "MultiBot") Or WinGetTitle($aWinList[$i][1]) = "" Then
                $hWnd = $aWinList[$i][1]
                ExitLoop
            EndIf
        Next
    EndIf
    
    If $hWnd <> 0 Then
        ; Restore window
        WinSetState($hWnd, "", @SW_SHOW)
        WinSetState($hWnd, "", @SW_RESTORE)
        WinActivate($hWnd)
    EndIf
    Exit
EndIf

; === GLOBAL STATE ===
Global $g_sBotFile = "MyBot.run.exe"
Global $g_sBotFileAU3 = "MyBot.run.au3"
Global $g_sVersion = "1.0"
Global $g_sDirProfiles = @ScriptDir & "\Profiles\MultiBot-Profiles.ini"
Global $g_bMinimizedToTray = False
Global $g_hGui_Main, $g_hGui_Profile, $g_hGui_Emulator, $g_hGui_Instance, $g_hGui_Dir, $g_hGui_Parameter, $g_hGUI_AutoStart, $g_hGUI_Edit, $g_hListview_Main, $g_hLst_AutoStart, $g_hBtn_StartAll, $g_hBtn_RestartAll, $g_hBtn_StopAll, $g_hBtn_StartEmu, $g_hBtn_RestartEmu, $g_hBtn_StopEmu, $g_hMenu, $g_hMenuItem_ADBReset, $g_hMenuItem_ProfileDir, $g_hMenuItem_StartupDir, $g_hContext_Main, $g_hTrayItem_Exit, $g_hTrayItem_ADBReset, $g_hTrayItem_MyBotDir, $g_hTrayItem_ProfileDir
Global $g_hListview_Instances
Global $g_aGuiPos_Main
Global $g_sTypedProfile, $g_sSelectedEmulator
Global $g_sIniProfile, $g_sIniEmulator, $g_sIniInstance, $g_sIniDir, $g_sIniParameters
Global $g_iParameters = 6
Global Enum $eEdit = 1000, $eDelete, $eStartVM, $eStopVM, $eRestartVM, $eStartBot, $eStopBot, $eRestartBot

; === APPLICATION STARTUP ===
If @OSArch = "X86" Then
	$Wow6432Node = ""
	$HKLM = "HKLM"
Else
	$Wow6432Node = "\Wow6432Node"
	$HKLM = "HKLM64"
EndIf

Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
TraySetState(2)
TraySetClick(16)

GUI_Main()

; === MAIN WINDOW ===
Func GUI_Main()

	$g_hGui_Main = GUICreate("MultiBot", 280, 370, -1, -1, -1, 0x00040000)
	GUISetIcon(@ScriptDir & "\images\MyBot.ico", -1, $g_hGui_Main)
	$g_hMenu = GUICtrlCreateMenu("Menu")
	$g_hMenuItem_StartupDir = GUICtrlCreateMenuItem("MyBot Directory", $g_hMenu)
	$g_hMenuItem_ProfileDir = GUICtrlCreateMenuItem("Profile Directory", $g_hMenu)
	GUICtrlCreateMenuItem("", $g_hMenu)
	$g_hMenuItem_ADBReset = GUICtrlCreateMenuItem("ADB Reset", $g_hMenu)
	$g_hListview_Main = GUICtrlCreateListView("", 8, 4, 264, 250, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), -1)
	_GUICtrlListView_InsertColumn($g_hListview_Main, 1, "Setup", 264)
	$g_hBtn_Setup = GUICtrlCreateButton("New Setup", 8, 260, 264, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Use this Button to create a new Setup with your Profile, wished Emulator and Instance aswell as the Bot you want to use")
	$g_hBtn_StartAll = GUICtrlCreateButton("Start All Bots", 8, 290, 128, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Launch all configured bot profiles with a 1-second delay between each start")
	$g_hBtn_StopAll = GUICtrlCreateButton("Stop All Bots", 144, 290, 128, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Force-terminate all running MyBot.run.exe processes")
	$g_hBtn_StartEmu = GUICtrlCreateButton("Start All VMs", 8, 318, 128, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Start all configured emulator instances")
	$g_hBtn_StopEmu = GUICtrlCreateButton("Stop All VMs", 144, 318, 128, 25, $WS_GROUP)
	GUICtrlSetTip(-1, "Stop all configured emulator instances")

	$g_hContext_Main = _GUICtrlMenu_CreatePopup()
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 0, "Start VM", $eStartVM)
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 1, "Stop VM", $eStopVM)
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 2, "Restart VM", $eRestartVM)
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 3, "") ; Separator
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 4, "Start Bot", $eStartBot)
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 5, "Stop Bot", $eStopBot)
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 6, "Restart Bot", $eRestartBot)
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 7, "") ; Separator
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 8, "Edit", $eEdit)
	_GUICtrlMenu_InsertMenuItem($g_hContext_Main, 9, "Delete", $eDelete)

	Local $hAccel_EditProfile = GUICtrlCreateDummy()
	Local $aAccelerators[1][2] = [["{TAB}", $hAccel_EditProfile]]
	GUISetAccelerators($aAccelerators, $g_hGui_Main)

	GUISetState(@SW_SHOW)

	TraySetIcon(@ScriptDir & "\images\MyBot.ico")
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, "TrayShow")
	$g_hTrayItem_MyBotDir = TrayCreateItem("MyBot Directory")
	TrayItemSetOnEvent($g_hTrayItem_MyBotDir, "TrayOpenMyBotDir")
	TrayItemSetState($g_hTrayItem_MyBotDir, 4) ; Disable checkbox
	$g_hTrayItem_ProfileDir = TrayCreateItem("Profile Directory")
	TrayItemSetOnEvent($g_hTrayItem_ProfileDir, "TrayOpenProfileDir")
	TrayItemSetState($g_hTrayItem_ProfileDir, 4) ; Disable checkbox
	TrayCreateItem("") ; Separator
	$g_hTrayItem_ADBReset = TrayCreateItem("ADB Reset")
	TrayItemSetOnEvent($g_hTrayItem_ADBReset, "TrayADBReset")
	TrayItemSetState($g_hTrayItem_ADBReset, 4) ; Disable checkbox
	TrayCreateItem("") ; Separator
	$g_hTrayItem_Exit = TrayCreateItem("Exit")
	TrayItemSetOnEvent($g_hTrayItem_Exit, "TrayExit")
	TrayItemSetState($g_hTrayItem_Exit, 4) ; Disable checkbox
	Sleep(100)
	TraySetToolTip("MultiBot")
	TraySetState(1)

	GUIRegisterMsg($WM_CONTEXTMENU, "WM_CONTEXTMENU")
	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
	GUIRegisterMsg($WM_SIZE, "WM_SIZE")
	GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")


	UpdateList_Main()

	If IniRead($g_sDirProfiles, "Options", "DisplayVersSent", "") = "" Then IniWrite($g_sDirProfiles, "Options", "DisplayVersSent", "1.0")

	While 1

		$aMsg = GUIGetMsg(1)
		Switch $aMsg[1]

			Case $g_hGui_Main
				Switch $aMsg[0]
					Case $GUI_EVENT_CLOSE
						$g_bMinimizedToTray = True
						GUISetState(@SW_HIDE, $g_hGui_Main)

					Case $g_hMenuItem_ADBReset
						ADBReset()

					Case $g_hMenuItem_ProfileDir
						ShellExecute(@ScriptDir & "\Profiles\")


					Case $g_hMenuItem_StartupDir
						ShellExecute(@ScriptDir)

					Case $hAccel_EditProfile
						GUISetState(@SW_DISABLE, $g_hGui_Main)
						$g_aGuiPos_Main = WinGetPos($g_hGui_Main)
						GUI_Edit()
						UpdateList_Main()
						GUISetState(@SW_ENABLE, $g_hGui_Main)
						RestoreMainGui()

					Case $g_hBtn_Setup
						Local $bSetupStopped = False

						WinSetOnTop($g_hGui_Main, "", $WINDOWS_ONTOP)

						Do
							GUISetState(@SW_DISABLE, $g_hGui_Main)
							$g_aGuiPos_Main = WinGetPos($g_hGui_Main)
							$bSetupStopped = GUI_Profile()
							If $bSetupStopped Then ExitLoop
							$bSetupStopped = GUI_Emulator()
							If $bSetupStopped Then ExitLoop
							$bSetupStopped = GUI_Instance()
							If $bSetupStopped Then ExitLoop
							IniWrite($g_sDirProfiles, $g_sTypedProfile, "Dir", ".")
							$bSetupStopped = GUI_PARAMETER()
							If $bSetupStopped Then ExitLoop
						Until 1

						WinSetOnTop($g_hGui_Main, "", $WINDOWS_NOONTOP)
						If $bSetupStopped Then
						$bSetupStopped = False
						EndIf

						GUISetState(@SW_ENABLE, $g_hGui_Main)
						RestoreMainGui()
						UpdateList_Main()

					Case $g_hBtn_StartAll
						StartAll()

					Case $g_hBtn_StopAll
						StopAll()

					Case $g_hBtn_StartEmu
						StartEmu()

					Case $g_hBtn_StopEmu
						StopEmu()

		EndSwitch

	EndSwitch

	WEnd
EndFunc   ;==>GUI_Main

; === WINDOW RESTORATION ===
Func RestoreMainGui()
	$g_bMinimizedToTray = False
	GUISetState(@SW_SHOW, $g_hGui_Main)
	GUISetState(@SW_RESTORE, $g_hGui_Main)
	WinActivate($g_hGui_Main)
EndFunc   ;==>RestoreMainGui

; === PROFILE SELECTOR ===
Func GUI_Profile()
	$g_hGui_Profile = GUICreate("Profile", 255, 167, $g_aGuiPos_Main[0], $g_aGuiPos_Main[1] + 150, -1, -1, $g_hGui_Main)
	$hIpt_Profile = GUICtrlCreateInput("", 24, 72, 201, 21)
	$hBtn_Next = GUICtrlCreateButton("Next Step", 72, 120, 97, 25, $WS_GROUP)
	GUICtrlSetState($hBtn_Next, $GUI_DISABLE)
	GUICtrlCreateLabel("Enter the full profile name to continue", 24, 8, 204, 57)
	GUISetState()
	GUICtrlSetState($hIpt_Profile, $GUI_FOCUS)

	Local $bBtnEnabled = False


	While 1
		Local $aMsg = GUIGetMsg(1)
		Switch $aMsg[0]
			Case $GUI_EVENT_CLOSE
				$g_sTypedProfile = GUICtrlRead($hIpt_Profile)
				GUIDelete($g_hGui_Profile)
				Return -1
			Case $hBtn_Next
				$g_sTypedProfile = GUICtrlRead($hIpt_Profile)
				If $g_sTypedProfile = "" Then
					ContinueLoop
				Else
					Local $aSections = IniReadSectionNames($g_sDirProfiles)
					If IsArray($aSections) Then
						For $i = 1 To $aSections[0]
							If $aSections[$i] = $g_sTypedProfile Then
								MsgBox($MB_OK, "Error", "Profile already exists: " & $g_sTypedProfile, 0, $g_hGui_Profile)
								ContinueLoop 2
							EndIf
						Next
					EndIf
					IniWrite($g_sDirProfiles, $g_sTypedProfile, "Profile", $g_sTypedProfile)
					IniWrite($g_sDirProfiles, $g_sTypedProfile, "BotVers", "")
					GUIDelete($g_hGui_Profile)
					Return 0
				EndIf
		EndSwitch

		Local $bHasProfile = GUICtrlRead($hIpt_Profile) <> ""
		If $bHasProfile And Not $bBtnEnabled Then
			GUICtrlSetState($hBtn_Next, $GUI_ENABLE)
			$bBtnEnabled = True
		ElseIf Not $bHasProfile And $bBtnEnabled Then
			GUICtrlSetState($hBtn_Next, $GUI_DISABLE)
			$bBtnEnabled = False
		EndIf
	WEnd
EndFunc   ;==>GUI_Profile



; === EMULATOR SELECTOR ===
Func GUI_Emulator()
	$g_hGui_Emulator = GUICreate("Emulator", 258, 167, $g_aGuiPos_Main[0], $g_aGuiPos_Main[1] + 150, -1, -1, $g_hGui_Main)
	$hCmb_Emulator = GUICtrlCreateCombo("", 24, 72, 201, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hCmb_Emulator, "BlueStacks5|MEmu", "BlueStacks5")
	$hBtn_Next = GUICtrlCreateButton("Next Step", 72, 120, 97, 25, $WS_GROUP)
	GUICtrlCreateLabel("Select your emulator", 24, 8, 204, 57)
	GUISetState()
	GUICtrlSetState($hCmb_Emulator, $GUI_FOCUS)



	While 1
		Local $aMsg = GUIGetMsg(1)
		Switch $aMsg[0]
			Case $GUI_EVENT_CLOSE
				IniDelete($g_sDirProfiles, $g_sTypedProfile)
				GUIDelete($g_hGui_Emulator)
				Return -1
			Case $hBtn_Next
				$g_sSelectedEmulator = GUICtrlRead($hCmb_Emulator)
				IniWrite($g_sDirProfiles, $g_sTypedProfile, "Emulator", $g_sSelectedEmulator)
				GUIDelete($g_hGui_Emulator)
				Return 0

		EndSwitch
	WEnd
EndFunc   ;==>GUI_Emulator



; === INSTANCE SELECTOR ===
Func GUI_Instance()
	Local $hLbl_Instance = 0

	$g_hGui_Instance = GUICreate("Instance", 258, 167, $g_aGuiPos_Main[0], $g_aGuiPos_Main[1] + 150, -1, -1, $g_hGui_Main)
	$hIpt_Instance = GUICtrlCreateInput("", 24, 72, 201, 21)
	$hBtn_Next = GUICtrlCreateButton("Next Step", 72, 120, 97, 25, $WS_GROUP)
	$hLbl_Instance = GUICtrlCreateLabel("Please type in the Instance Name you want to use", 24, 8, 204, 57)
	GUISetState(@SW_HIDE, $g_hGui_Instance)

	Switch $g_sSelectedEmulator
		Case "BlueStacks", "BlueStacks2"
			Return
		Case "BlueStacks5"
			GUISetState(@SW_SHOW, $g_hGui_Instance)
			GUICtrlSetData($hLbl_Instance, "Enter your BlueStacks instance name. Example: Pie64, Pie64_1, Pie64_2, etc")
			GUICtrlSetData($hIpt_Instance, "Pie64_")
			GUICtrlSetState($hIpt_Instance, $GUI_FOCUS)
		Case "MEmu"
			GUISetState(@SW_SHOW, $g_hGui_Instance)
			GUICtrlSetData($hLbl_Instance, "Enter your MEmu instance name. Example: MEmu, MEmu_1, MEmu_2, etc")
			GUICtrlSetData($hIpt_Instance, "MEmu")
			GUICtrlSetState($hIpt_Instance, $GUI_FOCUS)
	EndSwitch

	While 1
		Local $aMsg = GUIGetMsg(1)
		Switch $aMsg[0]
			Case $GUI_EVENT_CLOSE
				GUIDelete($g_hGui_Instance)
				IniDelete($g_sDirProfiles, $g_sTypedProfile)
				Return -1
			Case $hBtn_Next
				$Inst = GUICtrlRead($hIpt_Instance)
				If $Inst = "" Then ContinueLoop

				IniWrite($g_sDirProfiles, $g_sTypedProfile, "Instance", $Inst)
				GUIDelete($g_hGui_Instance)
				Return 0

		EndSwitch

		If _IsPressed("0D") And WinActive($g_hGui_Instance) Then
			$Inst = GUICtrlRead($hIpt_Instance)
			If $Inst = "" Then ContinueLoop

			IniWrite($g_sDirProfiles, $g_sTypedProfile, "Instance", $Inst)
			GUIDelete($g_hGui_Instance)
			Return 0
		EndIf
	WEnd
EndFunc   ;==>GUI_Instance

; === DIRECTORY SELECTOR ===
Func GUI_DIR()
	$g_hGui_Dir = GUICreate("Directory", 258, 167, $g_aGuiPos_Main[0], $g_aGuiPos_Main[1] + 150, -1, -1, $g_hGui_Main)
	$hBtn_Folder = GUICtrlCreateButton("Choose Folder", 24, 72, 201, 21)
	$hBtn_Finish = GUICtrlCreateButton("Next", 72, 120, 97, 25, $WS_GROUP)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel("Select the MyBot folder containing MyBot.run.exe or .au3", 24, 8, 204, 57)
	GUISetState()

	Local $sFileSelectFolder = @ScriptDir

	If FileExists($sFileSelectFolder & "\" & $g_sBotFile) = 0 And FileExists($sFileSelectFolder & "\" & $g_sBotFileAU3) = 0 Then
		MsgBox($MB_OK, "Error", "MyBot.run.exe or .au3 not found in directory", 0, $g_hGui_Dir)
		IniDelete($g_sDirProfiles, $g_sTypedProfile)
		GUIDelete($g_hGui_Dir)
		Return -1
	Else
		GUICtrlSetState($hBtn_Finish, $GUI_ENABLE)
		GUICtrlSetState($hBtn_Folder, $GUI_DISABLE)
	EndIf



	While 1

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				IniDelete($g_sDirProfiles, $g_sTypedProfile)
				GUIDelete($g_hGui_Dir)
				Return -1

			Case $hBtn_Folder
				WinSetOnTop($g_hGui_Main, "", $WINDOWS_NOONTOP)
				Local $sFileSelectFolder = @ScriptDir
				WinSetOnTop($g_hGui_Main, "", $WINDOWS_ONTOP)

				If FileExists($sFileSelectFolder & "\" & $g_sBotFile) = 0 And FileExists($sFileSelectFolder & "\" & $g_sBotFileAU3) = 0 Then
					MsgBox($MB_OK, "Error", "MyBot.run.exe or .au3 not found in selected folder", 0, $g_hGui_Dir)
					ContinueLoop
				Else
					GUICtrlSetState($hBtn_Finish, $GUI_ENABLE)
				EndIf

			Case $hBtn_Finish

				IniWrite($g_sDirProfiles, $g_sTypedProfile, "Dir", ".")
				GUIDelete($g_hGui_Dir)
				ExitLoop


		EndSwitch
	WEnd




EndFunc   ;==>GUI_DIR

; === LAUNCH PARAMETERS ===
Func GUI_PARAMETER()
	Local $iEndResult
	Local $hChk_LightMode
	$g_hGui_Parameter = GUICreate("Special Parameters", 280, 190, $g_aGuiPos_Main[0], $g_aGuiPos_Main[1] + 150, -1, -1, $g_hGui_Main)
	GUICtrlCreateLabel("Select options to run the bot with special parameters. These are optional.", 8, 8, 264, 37)
	$hChk_DebugMode = GUICtrlCreateCheckbox("Debug Mode", 8, 50)
	GUICtrlSetTip(-1, "Enable debug mode for detailed logging and troubleshooting")
	$hChk_DpiAwareness = GUICtrlCreateCheckbox("DPI Awareness", 140, 50)
	GUICtrlSetTip(-1, "Enable DPI awareness to properly scale the interface on high-DPI displays")
	$hChk_HideAndroid = GUICtrlCreateCheckbox("Hide Android", 8, 70)
	GUICtrlSetTip(-1, "Hide the Android emulator window during bot operation")
	$hChk_LightMode = GUICtrlCreateCheckbox("Light Mode", 140, 70)
	GUICtrlSetTip(-1, "Skip loading the Stats and About tabs to reduce resource use")
	$hChk_MiniGUIMode = GUICtrlCreateCheckbox("Mini GUI Mode", 8, 90)
	GUICtrlSetTip(-1, "Launch the bot in a compact mini GUI mode")
	$hChk_NoWatchdog = GUICtrlCreateCheckbox("No Watchdog", 140, 90)
	GUICtrlSetTip(-1, "Disable the watchdog process that monitors bot stability")


	$hBtn_Finish = GUICtrlCreateButton("Finish", 92, 150, 97, 25, $WS_GROUP)
	GUISetState()



	While 1

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				IniDelete($g_sDirProfiles, $g_sTypedProfile)
				GUIDelete($g_hGui_Parameter)
				Return -1


			Case $hBtn_Finish
				$iEndResult = ""
				$iEndResult &= (GUICtrlRead($hChk_DebugMode) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_DpiAwareness) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_HideAndroid) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_MiniGUIMode) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_NoWatchdog) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_LightMode) = $GUI_CHECKED ? 1 : 0)
				IniWrite($g_sDirProfiles, $g_sTypedProfile, "Parameters", $iEndResult)
				GUIDelete($g_hGui_Parameter)
				ExitLoop


		EndSwitch
	WEnd




EndFunc   ;==>GUI_PARAMETER



; === PROFILE CONFIGURATION EDITOR ===
Func GUI_Edit()

	Local $iEndResult
	Local $hChk_UnlockMode
	Local $hChk_LightMode

	$aLstbx_GetSelTxt = _GUICtrlListView_GetSelectedIndices($g_hListview_Main, True)
	If Not IsArray($aLstbx_GetSelTxt) Or $aLstbx_GetSelTxt[0] < 1 Then Return

	$sLstbx_SelItem = _GUICtrlListView_GetItemText($g_hListview_Main, $aLstbx_GetSelTxt[1])
	ReadIni($sLstbx_SelItem)
	$g_sIniProfile = StringReplace($g_sIniProfile, '"', '')

	Local $sProfileConfig = GetBotProfileConfigPath($g_sIniProfile)
	Local $sGlobalConfig = @ScriptDir & "\Profiles\profile.ini"

	Local $bAutoStart = (Int(IniRead($sProfileConfig, "general", "AutoStart", 0)) = 1)
	Local $iAutoStartDelay = Int(IniRead($sProfileConfig, "general", "AutoStartDelay", 10))
	Local $bAutoHide = (Int(IniRead($sProfileConfig, "general", "HideAndroid", 0)) = 1)
	Local $bAutoAlign = (Int(IniRead($sProfileConfig, "general", "DisposeWindows", 0)) = 1)
	Local $iAlignPosition = Int(IniRead($sProfileConfig, "general", "DisposeWindowsPos", 6))
	If $iAlignPosition < 0 Or $iAlignPosition > 10 Then $iAlignPosition = 6
	Local $sOffsetX = IniRead($sProfileConfig, "other", "WAOffsetX", "")
	Local $sOffsetY = IniRead($sProfileConfig, "other", "WAOffsetY", "")
	Local $iAffinityMask = Int(IniRead($sProfileConfig, "android", "process.affinity.mask", 0))
	Local $iAndroidBackgroundMode = Int(IniRead($sProfileConfig, "android", "backgroundmode", 0))
	Local $iAndroidZoomoutMode = Int(IniRead($sProfileConfig, "android", "zoomoutmode", 0))
	Local $bAndroidAdbClick = (Int(IniRead($sProfileConfig, "android", "adb.click.enabled", 0)) = 1 Or Int(IniRead($sProfileConfig, "android", "adb.clicks.enabled", 0)) = 1)
	Local $bAndroidAdbClickDragScript = (Int(IniRead($sProfileConfig, "android", "adb.click.drag.script", 0)) = 1)
	Local $bAndroidCloseWithBot = (Int(IniRead($sProfileConfig, "android", "close", 0)) = 1)
	Local $bAndroidDedicatedAdbPort = (Int(IniRead($sProfileConfig, "android", "adb.dedicated.instance", 0)) = 1)
	Local $iAndroidAdbPath = NormalizeEditRange(Int(IniRead($sProfileConfig, "android", "adb.replace", 0)), 0, 1, 0)
	If $iAndroidBackgroundMode < 0 Or $iAndroidBackgroundMode > 2 Then $iAndroidBackgroundMode = 0
	If $iAndroidZoomoutMode < 0 Or $iAndroidZoomoutMode > 4 Then $iAndroidZoomoutMode = 0
	Local $iThreads = Int(IniRead($sProfileConfig, "general", "threads", 0))
	Local $bUnlockMode = (GetStoredUnlockModePreference($sLstbx_SelItem, $sProfileConfig) = "1")
	Local $iGlobalActiveBots = Int(IniRead($sGlobalConfig, "general", "globalactivebotsallowed", 2))
	Local $iGlobalThreads = Int(IniRead($sGlobalConfig, "general", "globalthreads", 0))
	Local $bBotStop = (Int(IniRead($sProfileConfig, "general", "BotStop", 0)) = 1)
	Local $iBotCommand = NormalizeEditRange(Int(IniRead($sProfileConfig, "general", "Command", 0)), 0, 7, 0)
	Local $iBotCond = NormalizeEditRange(Int(IniRead($sProfileConfig, "general", "Cond", 0)), 0, 7, 0)
	Local $iBotHour = NormalizeEditRange(Int(IniRead($sProfileConfig, "general", "Hour", 0)), 0, 24, 0)
	Local $bEnableRevenge = (Int(IniRead($sProfileConfig, "search", "EnableRevengeBattle", 0)) = 1)
	Local $bEnableRanked = (Int(IniRead($sProfileConfig, "search", "EnableRankedBattle", 0)) = 1)
	Local $bWaitForClanCastle = (Int(IniRead($sProfileConfig, "search", "ChkCastleWait", 0)) = 1)

	$g_hGUI_Edit = GUICreate("Edit Profile Settings", 430, 675, $g_aGuiPos_Main[0], $g_aGuiPos_Main[1] + 20, -1, -1, $g_hGui_Main)

	; Profile and Android options
	GUICtrlCreateGroup("Profile / Android", 8, 8, 414, 160)
	GUICtrlCreateLabel("Profile:", 20, 30, 58, 17)
	$hIpt_Profile = GUICtrlCreateInput($g_sIniProfile, 82, 27, 320, 21)
	GUICtrlCreateLabel("Emulator:", 20, 58, 58, 17)
	$hCmb_Emulator = GUICtrlCreateCombo("", 82, 55, 96, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hCmb_Emulator, "BlueStacks5|MEmu", $g_sIniEmulator)
	GUICtrlCreateLabel("Screencap:", 184, 58, 58, 17)
	$hCmb_AndroidBackgroundMode = GUICtrlCreateCombo("", 244, 55, 158, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hCmb_AndroidBackgroundMode, "Default|Use WinAPI (DirectX Only)|Use Screencap", GetAndroidBackgroundModeText($iAndroidBackgroundMode))
	GUICtrlCreateLabel("Instance:", 20, 86, 58, 17)
	$hIpt_Instance = GUICtrlCreateInput($g_sIniInstance, 82, 83, 96, 21)
	GUICtrlCreateLabel("Zoomout:", 184, 86, 58, 17)
	$hCmb_AndroidZoomoutMode = GUICtrlCreateCombo("", 244, 83, 158, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hCmb_AndroidZoomoutMode, "Default|Use minitouch script|Use dd script|WinAPI|Update shared_prefs", GetAndroidZoomoutModeText($iAndroidZoomoutMode))
	$hChk_AndroidAdbClick = GUICtrlCreateCheckbox("Use Minitouch for Click", 20, 115, 230, 20)
	$hChk_AndroidCloseWithBot = GUICtrlCreateCheckbox("Close Android && Bot", 258, 115, 154, 20)
	$hChk_AndroidAdbClickDragScript = GUICtrlCreateCheckbox("Use Minitouch for Accurate Click && Drag", 20, 141, 230, 20)
	$hChk_AndroidDedicatedAdbPort = GUICtrlCreateCheckbox("Use Dedicated ADB Port", 258, 141, 154, 20)
	If $bAndroidAdbClick Then GUICtrlSetState($hChk_AndroidAdbClick, $GUI_CHECKED)
	If $bAndroidAdbClickDragScript Then GUICtrlSetState($hChk_AndroidAdbClickDragScript, $GUI_CHECKED)
	If $bAndroidCloseWithBot Then GUICtrlSetState($hChk_AndroidCloseWithBot, $GUI_CHECKED)
	If $bAndroidDedicatedAdbPort Then GUICtrlSetState($hChk_AndroidDedicatedAdbPort, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Halt Attack
	GUICtrlCreateGroup("Halt Attack", 8, 170, 414, 70)
	$hChk_BotStop = GUICtrlCreateCheckbox("Enable", 20, 192, 64, 20)
	$hCmb_BotCommand = GUICtrlCreateCombo("", 88, 190, 112, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hCmb_BotCommand, GetHaltCommandList(), GetHaltCommandText($iBotCommand))
	GUICtrlCreateLabel("When", 208, 194, 36, 17)
	$hCmb_BotCond = GUICtrlCreateCombo("", 248, 190, 160, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hCmb_BotCond, GetHaltConditionList(), GetHaltConditionText($iBotCond))
	GUICtrlCreateLabel("Hours:", 88, 216, 42, 17)
	$hCmb_BotHour = GUICtrlCreateCombo("", 132, 213, 64, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hCmb_BotHour, GetHourList(), String($iBotHour))
	If $bBotStop Then GUICtrlSetState($hChk_BotStop, $GUI_CHECKED)
	If $iBotCond <> 5 Then GUICtrlSetState($hCmb_BotHour, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Attack options
	GUICtrlCreateGroup("Attack Options", 8, 242, 414, 48)
	$hChk_EnableRevenge = GUICtrlCreateCheckbox("Enable Revenge", 20, 262, 112, 20)
	$hChk_EnableRanked = GUICtrlCreateCheckbox("Enable Ranked", 142, 262, 104, 20)
	$hChk_WaitForClanCastle = GUICtrlCreateCheckbox("Wait For Clan Castle Troops", 256, 262, 158, 20)
	If $bEnableRevenge Then GUICtrlSetState($hChk_EnableRevenge, $GUI_CHECKED)
	If $bEnableRanked Then GUICtrlSetState($hChk_EnableRanked, $GUI_CHECKED)
	If $bWaitForClanCastle Then GUICtrlSetState($hChk_WaitForClanCastle, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Startup and alignment
	GUICtrlCreateGroup("Startup / Alignment", 8, 292, 414, 120)
	$hChk_AutoStart = GUICtrlCreateCheckbox("Auto Start", 20, 314, 90, 20)
	GUICtrlCreateLabel("Delay:", 118, 317, 48, 17)
	$hIpt_AutoStartDelay = GUICtrlCreateInput($iAutoStartDelay, 168, 313, 52, 21, BitOR($ES_CENTER, $ES_NUMBER))
	GUICtrlCreateLabel("sec.", 226, 317, 28, 17)
	$hChk_AutoHide = GUICtrlCreateCheckbox("Auto Hide Android", 258, 314, 112, 20)
	$hChk_AutoAlign = GUICtrlCreateCheckbox("Auto Align", 20, 339, 90, 20)
	GUICtrlCreateLabel("Position:", 118, 342, 48, 17)
	$hCmb_AlignPosition = GUICtrlCreateCombo("", 168, 338, 242, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	Local $sAlignmentList = "0,0: Android Emulator-Bot|0,0: Bot-Android Emulator|SNAP: Bot TopRight to Android|SNAP: Bot TopLeft to Android|SNAP: Bot BottomRight to Android|SNAP: Bot BottomLeft to Android|DOCK: Android into Bot|FIXED: Android - Bot TopRight|FIXED: Android - Bot TopLeft|FIXED: Android - Bot BottomRight|FIXED: Android - Bot BottomLeft"
	GUICtrlSetData($hCmb_AlignPosition, $sAlignmentList, GetAlignmentOptionText($iAlignPosition))
	GUICtrlCreateLabel("Offset X:", 20, 368, 55, 17)
	$hIpt_OffsetX = GUICtrlCreateInput($sOffsetX, 76, 364, 58, 20, $ES_CENTER)
	GUICtrlCreateLabel("Y:", 146, 368, 18, 17)
	$hIpt_OffsetY = GUICtrlCreateInput($sOffsetY, 166, 364, 58, 20, $ES_CENTER)
	GUICtrlCreateLabel("ADB Path:", 236, 368, 58, 17)
	Local $hCmb_AndroidAdbPath = GUICtrlCreateCombo("", 296, 364, 114, 21, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData($hCmb_AndroidAdbPath, "Emulator|MyBotRun", ($iAndroidAdbPath = 1 ? "MyBotRun" : "Emulator"))
	GUICtrlCreateLabel("Applied when profile starts.", 20, 390, 220, 17)
	If $bAutoStart Then GUICtrlSetState($hChk_AutoStart, $GUI_CHECKED)
	If $bAutoHide Then GUICtrlSetState($hChk_AutoHide, $GUI_CHECKED)
	If $bAutoAlign Then GUICtrlSetState($hChk_AutoAlign, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Processor and threads
	GUICtrlCreateGroup("Processor / Threads", 8, 424, 414, 96)
	GUICtrlCreateLabel("Android affinity:", 20, 447, 92, 17)
	$hIpt_Affinity = GUICtrlCreateInput($iAffinityMask, 114, 443, 52, 21, BitOR($ES_CENTER, $ES_NUMBER))
	GUICtrlCreateLabel("0 = all", 172, 447, 42, 17)
	GUICtrlCreateLabel("Profile threads:", 248, 447, 88, 17)
	$hIpt_Threads = GUICtrlCreateInput($iThreads, 350, 443, 52, 21, BitOR($ES_CENTER, $ES_NUMBER))
	GUICtrlCreateLabel("Active bots:", 20, 477, 92, 17)
	$hIpt_GlobalActiveBots = GUICtrlCreateInput($iGlobalActiveBots, 114, 473, 52, 21, BitOR($ES_CENTER, $ES_NUMBER))
	GUICtrlCreateLabel("Global threads:", 248, 477, 88, 17)
	$hIpt_GlobalThreads = GUICtrlCreateInput($iGlobalThreads, 350, 473, 52, 21, BitOR($ES_CENTER, $ES_NUMBER))
	GUICtrlCreateLabel("Shared values require restarting all bots.", 20, 499, 270, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	; Launch parameters
	GUICtrlCreateGroup("Launch Parameters", 8, 526, 414, 102)
	$hChk_DebugMode = GUICtrlCreateCheckbox("Debug", 20, 548, 80, 20)
	$hChk_DpiAwareness = GUICtrlCreateCheckbox("DPI Awareness", 150, 548, 118, 20)
	$hChk_HideAndroid = GUICtrlCreateCheckbox("Hide Android", 292, 548, 115, 20)
	$hChk_LightMode = GUICtrlCreateCheckbox("Light Mode", 20, 574, 90, 20)
	GUICtrlSetTip(-1, "Skip loading the Stats and About tabs to reduce resource use")
	$hChk_MiniGUIMode = GUICtrlCreateCheckbox("Mini GUI", 150, 574, 118, 20)
	$hChk_NoWatchdog = GUICtrlCreateCheckbox("No Watchdog", 292, 574, 115, 20)
	$hChk_UnlockMode = GUICtrlCreateCheckbox("Unlock Mode", 20, 600, 115, 20)
	GUICtrlSetTip(-1, "Keep the bot GUI controls available while the bot is running")
	If $bUnlockMode Then GUICtrlSetState($hChk_UnlockMode, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	NormalizeParameters($g_sIniParameters)
	Local $aParameters = StringSplit($g_sIniParameters, "", 2)
	If $aParameters[0] = 1 Then GUICtrlSetState($hChk_DebugMode, $GUI_CHECKED)
	If $aParameters[1] = 1 Then GUICtrlSetState($hChk_DpiAwareness, $GUI_CHECKED)
	If $aParameters[2] = 1 Then GUICtrlSetState($hChk_HideAndroid, $GUI_CHECKED)
	If $aParameters[3] = 1 Then GUICtrlSetState($hChk_MiniGUIMode, $GUI_CHECKED)
	If $aParameters[4] = 1 Then GUICtrlSetState($hChk_NoWatchdog, $GUI_CHECKED)
	If $aParameters[5] = 1 Then GUICtrlSetState($hChk_LightMode, $GUI_CHECKED)

	$hBtn_Save = GUICtrlCreateButton("Save", 112, 638, 96, 26, $WS_GROUP)
	$hBtn_Cancel = GUICtrlCreateButton("Cancel", 222, 638, 96, 26, $WS_GROUP)
	GUISetState()

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $hBtn_Cancel
				GUIDelete($g_hGUI_Edit)
				ExitLoop

			Case $hCmb_Emulator
					Switch GUICtrlRead($hCmb_Emulator)
						Case "MEmu"
							GUICtrlSetData($hIpt_Instance, "MEmu")
						Case Else
							GUICtrlSetData($hIpt_Instance, "Pie64_")
					EndSwitch

			Case $hCmb_BotCond
				GUICtrlSetState($hCmb_BotHour, (GetHaltConditionIndex(GUICtrlRead($hCmb_BotCond)) = 5 ? $GUI_ENABLE : $GUI_DISABLE))

			Case $hBtn_Save
				Local $sSelectedProfile = StringStripWS(GUICtrlRead($hIpt_Profile), 3)
				Local $sSelectedEmulator = GUICtrlRead($hCmb_Emulator)
				Local $sSelectedInstance = StringStripWS(GUICtrlRead($hIpt_Instance), 3)
				If $sSelectedProfile = "" Or $sSelectedInstance = "" Then
					MsgBox($MB_OK, "Error", "Profile name and instance cannot be empty.", 0, $g_hGUI_Edit)
					ContinueLoop
				EndIf

				Local $iDelay = Int(GUICtrlRead($hIpt_AutoStartDelay))
				If $iDelay < 0 Then $iDelay = 0
				Local $iProfileThreads = Int(GUICtrlRead($hIpt_Threads))
				If $iProfileThreads < 0 Then $iProfileThreads = 0
				Local $iMask = Int(GUICtrlRead($hIpt_Affinity))
				If $iMask < 0 Then $iMask = 0
				Local $iActiveBots = Int(GUICtrlRead($hIpt_GlobalActiveBots))
				If $iActiveBots < 1 Then $iActiveBots = 1
				Local $iSharedThreads = Int(GUICtrlRead($hIpt_GlobalThreads))
				If $iSharedThreads < 0 Then $iSharedThreads = 0
				Local $iSelectedAlign = GetAlignmentOptionIndex(GUICtrlRead($hCmb_AlignPosition))
				Local $sSelectedOffsetX = StringStripWS(GUICtrlRead($hIpt_OffsetX), 3)
				Local $sSelectedOffsetY = StringStripWS(GUICtrlRead($hIpt_OffsetY), 3)
				$sSelectedOffsetX = StringRegExp($sSelectedOffsetX, "^-?\d+$") ? Int($sSelectedOffsetX) : ""
				$sSelectedOffsetY = StringRegExp($sSelectedOffsetY, "^-?\d+$") ? Int($sSelectedOffsetY) : ""

				$iEndResult = ""
				$iEndResult &= (GUICtrlRead($hChk_DebugMode) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_DpiAwareness) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_HideAndroid) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_MiniGUIMode) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_NoWatchdog) = $GUI_CHECKED ? 1 : 0)
				$iEndResult &= (GUICtrlRead($hChk_LightMode) = $GUI_CHECKED ? 1 : 0)

				IniDelete($g_sDirProfiles, $sLstbx_SelItem)
				IniWrite($g_sDirProfiles, $sSelectedProfile, "Profile", $sSelectedProfile)
				IniWrite($g_sDirProfiles, $sSelectedProfile, "Emulator", $sSelectedEmulator)
				IniWrite($g_sDirProfiles, $sSelectedProfile, "Instance", $sSelectedInstance)
				IniWrite($g_sDirProfiles, $sSelectedProfile, "Dir", ".")
				IniWrite($g_sDirProfiles, $sSelectedProfile, "Parameters", $iEndResult)

				$sProfileConfig = GetBotProfileConfigPath($sSelectedProfile)
				DirCreate(@ScriptDir & "\Profiles\" & $sSelectedProfile)
				IniWrite($sProfileConfig, "general", "AutoStart", GUICtrlRead($hChk_AutoStart) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "general", "AutoStartDelay", $iDelay)
				IniWrite($sProfileConfig, "general", "HideAndroid", GUICtrlRead($hChk_AutoHide) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "general", "DisposeWindows", GUICtrlRead($hChk_AutoAlign) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "general", "DisposeWindowsPos", $iSelectedAlign)
				IniWrite($sProfileConfig, "other", "WAOffsetX", $sSelectedOffsetX)
				IniWrite($sProfileConfig, "other", "WAOffsetY", $sSelectedOffsetY)
				IniWrite($sProfileConfig, "android", "process.affinity.mask", $iMask)
				IniWrite($sProfileConfig, "android", "backgroundmode", GetAndroidBackgroundModeIndex(GUICtrlRead($hCmb_AndroidBackgroundMode)))
				IniWrite($sProfileConfig, "android", "zoomoutmode", GetAndroidZoomoutModeIndex(GUICtrlRead($hCmb_AndroidZoomoutMode)))
				IniWrite($sProfileConfig, "android", "adb.click.enabled", GUICtrlRead($hChk_AndroidAdbClick) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "android", "adb.clicks.enabled", GUICtrlRead($hChk_AndroidAdbClick) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "android", "adb.click.drag.script", GUICtrlRead($hChk_AndroidAdbClickDragScript) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "android", "close", GUICtrlRead($hChk_AndroidCloseWithBot) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "android", "adb.dedicated.instance", GUICtrlRead($hChk_AndroidDedicatedAdbPort) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "android", "adb.replace", GUICtrlRead($hCmb_AndroidAdbPath) = "MyBotRun" ? 1 : 0)
				IniWrite($sProfileConfig, "general", "threads", $iProfileThreads)
				IniWrite($sProfileConfig, "general", "BotStop", GUICtrlRead($hChk_BotStop) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "general", "Command", GetHaltCommandIndex(GUICtrlRead($hCmb_BotCommand)))
				Local $iSelectedBotCond = GetHaltConditionIndex(GUICtrlRead($hCmb_BotCond))
				IniWrite($sProfileConfig, "general", "Cond", $iSelectedBotCond)
				IniWrite($sProfileConfig, "general", "Hour", ($iSelectedBotCond = 5 ? NormalizeEditRange(Int(GUICtrlRead($hCmb_BotHour)), 1, 24, 1) : 0))
				IniWrite($sProfileConfig, "search", "EnableRevengeBattle", GUICtrlRead($hChk_EnableRevenge) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "search", "EnableRankedBattle", GUICtrlRead($hChk_EnableRanked) = $GUI_CHECKED ? 1 : 0)
				IniWrite($sProfileConfig, "search", "ChkCastleWait", GUICtrlRead($hChk_WaitForClanCastle) = $GUI_CHECKED ? 1 : 0)
				Local $iUnlockMode = (BitAND(GUICtrlRead($hChk_UnlockMode), $GUI_CHECKED) = $GUI_CHECKED) ? 1 : 0
				IniWrite($g_sDirProfiles, $sSelectedProfile, "UnlockMode", $iUnlockMode)
				If IniWrite($sProfileConfig, "general", "UnlockMode", $iUnlockMode) = 0 Then _
					MsgBox($MB_OK, "Error", "Could not save Unlock Mode in:" & @CRLF & $sProfileConfig, 0, $g_hGUI_Edit)
				IniWrite($sGlobalConfig, "general", "globalactivebotsallowed", $iActiveBots)
				IniWrite($sGlobalConfig, "general", "globalthreads", $iSharedThreads)

				GUIDelete($g_hGUI_Edit)
				UpdateList_Main()
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>GUI_Edit

; === PROFILE CONFIGURATION HELPERS ===
Func GetBotProfileConfigPath($sProfile)
	Return @ScriptDir & "\Profiles\" & StringReplace($sProfile, '"', '') & "\config.ini"
EndFunc   ;==>GetBotProfileConfigPath

Func GetStoredUnlockModePreference($sProfileSection, $sProfileConfig)
	Local $sValue = StringStripWS(IniRead($g_sDirProfiles, $sProfileSection, "UnlockMode", ""), 3)
	If $sValue <> "0" And $sValue <> "1" Then
		$sValue = StringStripWS(IniRead($sProfileConfig, "general", "UnlockMode", "0"), 3)
	EndIf
	If $sValue <> "1" Then $sValue = "0"

	IniWrite($g_sDirProfiles, $sProfileSection, "UnlockMode", $sValue)
	IniWrite($sProfileConfig, "general", "UnlockMode", $sValue)
	Return $sValue
EndFunc   ;==>GetStoredUnlockModePreference

Func SyncProfileUnlockModePreference($sProfileSection)
	Local $sProfileName = StringReplace(IniRead($g_sDirProfiles, $sProfileSection, "Profile", $sProfileSection), '"', '')
	If $sProfileName = "" Then Return

	Local $sProfileConfig = GetBotProfileConfigPath($sProfileName)
	Local $sUnlockMode = GetStoredUnlockModePreference($sProfileSection, $sProfileConfig)

	DirCreate(@ScriptDir & "\Profiles\" & $sProfileName)
	IniWrite($sProfileConfig, "general", "UnlockMode", $sUnlockMode)
EndFunc   ;==>SyncProfileUnlockModePreference

Func GetAlignmentOptionText($iIndex)
	Local $aOptions[11] = ["0,0: Android Emulator-Bot", "0,0: Bot-Android Emulator", "SNAP: Bot TopRight to Android", "SNAP: Bot TopLeft to Android", "SNAP: Bot BottomRight to Android", "SNAP: Bot BottomLeft to Android", "DOCK: Android into Bot", "FIXED: Android - Bot TopRight", "FIXED: Android - Bot TopLeft", "FIXED: Android - Bot BottomRight", "FIXED: Android - Bot BottomLeft"]
	If $iIndex < 0 Or $iIndex > 10 Then $iIndex = 6
	Return $aOptions[$iIndex]
EndFunc   ;==>GetAlignmentOptionText

Func GetAlignmentOptionIndex($sOption)
	For $i = 0 To 10
		If GetAlignmentOptionText($i) = $sOption Then Return $i
	Next
	Return 6
EndFunc   ;==>GetAlignmentOptionIndex

Func GetAndroidBackgroundModeText($iIndex)
	Local $aOptions[3] = ["Default", "Use WinAPI (DirectX Only)", "Use Screencap"]
	If $iIndex < 0 Or $iIndex >= UBound($aOptions) Then $iIndex = 0
	Return $aOptions[$iIndex]
EndFunc   ;==>GetAndroidBackgroundModeText

Func GetAndroidBackgroundModeIndex($sOption)
	For $i = 0 To 2
		If GetAndroidBackgroundModeText($i) = $sOption Then Return $i
	Next
	Return 0
EndFunc   ;==>GetAndroidBackgroundModeIndex

Func GetAndroidZoomoutModeText($iIndex)
	Local $aOptions[5] = ["Default", "Use minitouch script", "Use dd script", "WinAPI", "Update shared_prefs"]
	If $iIndex < 0 Or $iIndex >= UBound($aOptions) Then $iIndex = 0
	Return $aOptions[$iIndex]
EndFunc   ;==>GetAndroidZoomoutModeText

Func GetAndroidZoomoutModeIndex($sOption)
	For $i = 0 To 4
		If GetAndroidZoomoutModeText($i) = $sOption Then Return $i
	Next
	Return 0
EndFunc   ;==>GetAndroidZoomoutModeIndex

Func NormalizeEditRange($iValue, $iMin, $iMax, $iDefault)
	If $iValue < $iMin Or $iValue > $iMax Then Return $iDefault
	Return $iValue
EndFunc   ;==>NormalizeEditRange

Func GetHaltCommandText($iIndex)
	Local $aOptions[8] = ["Halt Attack", "Stop Bot", "Close Bot", "Close Android+Bot", "Shutdown PC", "Sleep PC", "Reboot PC", "Turn Idle"]
	If $iIndex < 0 Or $iIndex >= UBound($aOptions) Then $iIndex = 0
	Return $aOptions[$iIndex]
EndFunc   ;==>GetHaltCommandText

Func GetHaltCommandList()
	Local $sList = GetHaltCommandText(0)
	For $i = 1 To 7
		$sList &= "|" & GetHaltCommandText($i)
	Next
	Return $sList
EndFunc   ;==>GetHaltCommandList

Func GetHaltCommandIndex($sOption)
	For $i = 0 To 7
		If GetHaltCommandText($i) = $sOption Then Return $i
	Next
	Return 0
EndFunc   ;==>GetHaltCommandIndex

Func GetHaltConditionText($iIndex)
	Local $aOptions[8] = ["All Storages Full", "Gold Full", "Elixir Full", "Dark Full", "At Certain Time", "Bot Running For", "Donate Only", "Only Stay Online"]
	If $iIndex < 0 Or $iIndex >= UBound($aOptions) Then $iIndex = 0
	Return $aOptions[$iIndex]
EndFunc   ;==>GetHaltConditionText

Func GetHaltConditionList()
	Local $sList = GetHaltConditionText(0)
	For $i = 1 To 7
		$sList &= "|" & GetHaltConditionText($i)
	Next
	Return $sList
EndFunc   ;==>GetHaltConditionList

Func GetHaltConditionIndex($sOption)
	For $i = 0 To 7
		If GetHaltConditionText($i) = $sOption Then Return $i
	Next
	Return 0
EndFunc   ;==>GetHaltConditionIndex

Func GetNumberList($iMin, $iMax)
	Local $sList = String($iMin)
	For $i = $iMin + 1 To $iMax
		$sList &= "|" & $i
	Next
	Return $sList
EndFunc   ;==>GetNumberList

Func GetHourList()
	Return GetNumberList(0, 24)
EndFunc   ;==>GetHourList



; === AUTOSTART CONFIGURATION ===
Func GUI_AutoStart()
	Local $sText = ""

	$g_hGUI_AutoStart = GUICreate("Auto Start Setup", 258, 187, $g_aGuiPos_Main[0], $g_aGuiPos_Main[1] + 150, -1, -1, $g_hGui_Main)
	$g_hLst_AutoStart = GUICtrlCreateList("", 8, 48, 241, 84, BitOR($LBS_SORT, $LBS_NOTIFY, $LBS_NOSEL))
	GUICtrlCreateLabel("Add or Remove a Profile from Autostart" & @CRLF & "These are currently in the Folder:", 8, 8, 220, 34)
	$hBtn_Add = GUICtrlCreateButton("Add", 8, 144, 97, 25, $WS_GROUP)
	$hBtn_Remove = GUICtrlCreateButton("Remove", 152, 144, 97, 25, $WS_GROUP)
	GUISetState()


	$Lstbx_Sel = _GUICtrlListView_GetSelectedIndices($g_hListview_Main, True)
	If $Lstbx_Sel[0] > 0 Then
		For $i = 1 To $Lstbx_Sel[0]
			$sLstbx_SelItem = _GUICtrlListView_GetItemText($g_hListview_Main, $Lstbx_Sel[$i])
			If $sLstbx_SelItem <> "" Then
				ReadIni($sLstbx_SelItem)
				If FileExists(@StartupDir & "\MyBot -" & $g_sIniProfile & ".lnk") = 0 Then
					GUICtrlSetState($hBtn_Add, $GUI_ENABLE)
					GUICtrlSetState($hBtn_Remove, $GUI_DISABLE)
				Else
					GUICtrlSetState($hBtn_Add, $GUI_DISABLE)
					GUICtrlSetState($hBtn_Remove, $GUI_ENABLE)
				EndIf
			EndIf
		Next
	EndIf


	UpdateList_AS()

	While 1

		Switch GUIGetMsg()

			Case $GUI_EVENT_CLOSE
				GUIDelete($g_hGUI_AutoStart)
				ExitLoop

			Case $hBtn_Add

				$Lstbx_Sel = _GUICtrlListView_GetSelectedIndices($g_hListview_Main, True)
				If $Lstbx_Sel[0] > 0 Then
					For $i = 1 To $Lstbx_Sel[0]
						$sLstbx_SelItem = _GUICtrlListView_GetItemText($g_hListview_Main, $Lstbx_Sel[$i])
						If $sLstbx_SelItem <> "" Then
							ReadIni($sLstbx_SelItem)
							If $g_sIniEmulator = "MEmu" And Not ResolveMEmuProfileInstance($g_sIniInstance, $sLstbx_SelItem) Then ContinueLoop
							If FileExists($g_sIniDir & "\" & $g_sBotFile) = 1 Then
								$g_sBotFile = $g_sBotFile
							ElseIf FileExists($g_sIniDir & "\" & $g_sBotFileAU3) = 1 Then
								$g_sBotFile = $g_sBotFileAU3
							EndIf

							FileCreateShortcut($g_sIniDir & "\" & $g_sBotFile, @StartupDir & "\MyBot -" & $g_sIniProfile & ".lnk", $g_sIniDir, $g_sIniProfile & " " & ($g_sIniEmulator = "BlueStacks3" ? "BlueStacks2" : $g_sIniEmulator) & " " & $g_sIniInstance, "Shortcut for Bot Profile:" & $g_sIniProfile)

							UpdateList_AS()
							If FileExists(@StartupDir & "\MyBot -" & $g_sIniProfile & ".lnk") = 0 Then
								GUICtrlSetState($hBtn_Remove, $GUI_DISABLE)
								GUICtrlSetState($hBtn_Add, $GUI_ENABLE)
							Else
								GUICtrlSetState($hBtn_Remove, $GUI_ENABLE)
								GUICtrlSetState($hBtn_Add, $GUI_DISABLE)
							EndIf
						EndIf
					Next
				EndIf



			Case $hBtn_Remove

				$Lstbx_Sel = _GUICtrlListView_GetSelectedIndices($g_hListview_Main, True)
				If $Lstbx_Sel[0] > 0 Then
					For $i = 1 To $Lstbx_Sel[0]
						$sLstbx_SelItem = _GUICtrlListView_GetItemText($g_hListview_Main, $Lstbx_Sel[$i])
						If $sLstbx_SelItem <> "" Then
							ReadIni($sLstbx_SelItem)
							If FileExists(@StartupDir & "\MyBot -" & $g_sIniProfile & ".lnk") = 1 Then
								FileDelete(@StartupDir & "\MyBot -" & $g_sIniProfile & ".lnk")
								GUICtrlSetData($g_hLst_AutoStart, "")

							EndIf

							UpdateList_AS()
							If FileExists(@StartupDir & "\MyBot -" & $g_sIniProfile & ".lnk") = 0 Then
								GUICtrlSetState($hBtn_Remove, $GUI_DISABLE)
								GUICtrlSetState($hBtn_Add, $GUI_ENABLE)
							Else
								GUICtrlSetState($hBtn_Remove, $GUI_ENABLE)
								GUICtrlSetState($hBtn_Add, $GUI_DISABLE)
							EndIf
						EndIf

					Next
				EndIf


		EndSwitch

	WEnd
EndFunc   ;==>GUI_AutoStart

; === BULK PROCESS CONTROL ===
Func RunSetup()
	$Lstbx_Sel = _GUICtrlListView_GetSelectedIndices($g_hListview_Main, True)
	If $Lstbx_Sel[0] > 0 Then
		For $i = 1 To $Lstbx_Sel[0]
			$sLstbx_SelItem = _GUICtrlListView_GetItemText($g_hListview_Main, $Lstbx_Sel[$i])
			If $sLstbx_SelItem <> "" Then
				ReadIni($sLstbx_SelItem)
				If $g_sIniEmulator = "MEmu" And Not ResolveMEmuProfileInstance($g_sIniInstance, $sLstbx_SelItem) Then ContinueLoop
				Local $sEmulator = $g_sIniEmulator
				If $g_sIniEmulator = "BlueStacks3" Then $sEmulator = "BlueStacks2"
				$aParameters = StringSplit($g_sIniParameters, "")
				Local $sSpecialParameter = ($aParameters[1] = 1 ? " /debug" : "") & ($aParameters[2] = 1 ? " /dpiaware" : "") & ($aParameters[3] = 1 ? " /hideandroid" : "") & ($aParameters[4] = 1 ? " /minigui" : "") & ($aParameters[5] = 1 ? " /nowatchdog" : "") & ($aParameters[6] = 1 ? " /lightmode" : "")
				Local $sInstance = $g_sIniInstance
				If FileExists($g_sIniDir & "\" & $g_sBotFile) = 1 Then
					ShellExecute($g_sBotFile, $g_sIniProfile & " " & $sEmulator & " " & $sInstance & $sSpecialParameter, $g_sIniDir)
				ElseIf FileExists($g_sIniDir & "\" & $g_sBotFileAU3) = 1 Then
					ShellExecute($g_sBotFileAU3, $g_sIniProfile & " " & $sEmulator & " " & $sInstance & $sSpecialParameter, $g_sIniDir)
				Else
					MsgBox($MB_OK, "No Bot found", "Couldn't find any Bot in the Directory, please check if you have the mybot.run.exe or the mybot.run.au3 in the Dir and if you selected the right Dir!", 0, $g_hGui_Main)
				EndIf
			EndIf
		Next
	EndIf
EndFunc   ;==>RunSetup

Func StartAll()
	Local $aSections = GetSortedProfileSections()
	If IsArray($aSections) Then
		For $i = 1 To $aSections[0]
			ReadIni($aSections[$i])
			If $g_sIniEmulator = "MEmu" And Not ResolveMEmuProfileInstance($g_sIniInstance, $aSections[$i]) Then ContinueLoop
			Local $sEmulator = $g_sIniEmulator
			If $g_sIniEmulator = "BlueStacks3" Then $sEmulator = "BlueStacks2"
			Local $sInstance = $g_sIniInstance
			$aParameters = StringSplit($g_sIniParameters, "")
			Local $sSpecialParameter = ($aParameters[1] = 1 ? " /debug" : "") & ($aParameters[2] = 1 ? " /dpiaware" : "") & ($aParameters[3] = 1 ? " /hideandroid" : "") & ($aParameters[4] = 1 ? " /minigui" : "") & ($aParameters[5] = 1 ? " /nowatchdog" : "") & ($aParameters[6] = 1 ? " /lightmode" : "")
			If FileExists($g_sIniDir & "\" & $g_sBotFile) = 1 Then
				ShellExecute($g_sBotFile, $g_sIniProfile & " " & $sEmulator & " " & $sInstance & $sSpecialParameter, $g_sIniDir)
			ElseIf FileExists($g_sIniDir & "\" & $g_sBotFileAU3) = 1 Then
				ShellExecute($g_sBotFileAU3, $g_sIniProfile & " " & $sEmulator & " " & $sInstance & $sSpecialParameter, $g_sIniDir)
			Else
				MsgBox($MB_OK, "Error", "MyBot.run not found for profile: " & $g_sIniProfile, 0, $g_hGui_Main)
			EndIf
			Sleep(1000) ; Delay between profiles
		Next
	EndIf
EndFunc   ;==>StartAll

Func StopAll()
	Local $aProcesses = ProcessList("mybot.run.exe")
	For $i = 1 To $aProcesses[0][0]
		ProcessClose($aProcesses[$i][1])
	Next
EndFunc   ;==>StopAll

Func RestartAll()
	StopAll()
	Sleep(2000)
	StartAll()
EndFunc   ;==>RestartAll

Func CreateShortcut()
	Local $iCreatedSC = 0, $sBotFileName, $hSC
	$Lstbx_Sel = _GUICtrlListView_GetSelectedIndices($g_hListview_Main, True)
	If $Lstbx_Sel[0] > 0 Then
		For $i = 1 To $Lstbx_Sel[0]
			$sLstbx_SelItem = _GUICtrlListView_GetItemText($g_hListview_Main, $Lstbx_Sel[$i])
			If $sLstbx_SelItem <> "" Then
				ReadIni($sLstbx_SelItem)
				If $g_sIniEmulator = "MEmu" And Not ResolveMEmuProfileInstance($g_sIniInstance, $sLstbx_SelItem) Then ContinueLoop
				Local $sEmulator = $g_sIniEmulator
				If $g_sIniEmulator = "BlueStacks3" Then $sEmulator = "BlueStacks2"
				$aParameters = StringSplit($g_sIniParameters, "")
				Local $sSpecialParameter = ($aParameters[1] = 1 ? " /debug" : "") & ($aParameters[2] = 1 ? " /dpiaware" : "") & ($aParameters[3] = 1 ? " /hideandroid" : "") & ($aParameters[4] = 1 ? " /minigui" : "") & ($aParameters[5] = 1 ? " /nowatchdog" : "") & ($aParameters[6] = 1 ? " /lightmode" : "")
				If FileExists($g_sIniDir & "\" & $g_sBotFile) Then
					$sBotFileName = $g_sBotFile
				ElseIf FileExists($g_sIniDir & "\" & $g_sBotFileAU3) Then
					$sBotFileName = $g_sBotFileAU3
				Else
					MsgBox($MB_OK, "No Bot found", "Couldn't find any Bot in the Directory, please check if you have the mybot.run.exe or the mybot.run.au3 in the Dir and if you selected the right Dir!", 0, $g_hGui_Main)
				EndIf
				$hSC = FileCreateShortcut($g_sIniDir & "\" & $sBotFileName, @DesktopDir & "\MyBot -" & $g_sIniProfile & ".lnk", $g_sIniDir, $g_sIniProfile & " " & $sEmulator & " " & $g_sIniInstance & $sSpecialParameter, "Shortcut for Bot Profile:" & $g_sIniProfile)
				If $hSC = 1 Then $iCreatedSC += 1

			EndIf

		Next
		If $iCreatedSC = 1 Then
		ElseIf $iCreatedSC > 1 Then
		EndIf
		$iCreatedSC = 0
	EndIf
EndFunc   ;==>CreateShortcut

; === PROFILE LIST MANAGEMENT ===
Func UpdateList_Main()
	Local $j = 0, $aSections

	_GUICtrlListView_BeginUpdate($g_hListview_Main)
	_GUICtrlListView_DeleteAllItems($g_hListview_Main)
	$aSections = GetSortedProfileSections()
	If Not IsArray($aSections) Then
		_GUICtrlListView_EndUpdate($g_hListview_Main)
		Return
	EndIf
	For $i = 1 To $aSections[0]
		_GUICtrlListView_AddItem($g_hListview_Main, $aSections[$i])
		$j += 1
	Next
	_GUICtrlListView_EndUpdate($g_hListview_Main)
EndFunc   ;==>UpdateList_Main

Func GetSortedProfileSections()
	Local $aSections = IniReadSectionNames($g_sDirProfiles)
	If Not IsArray($aSections) Then Return SetError(1, 0, 0)

	_ArraySort($aSections, 0, 1)

	Local $aProfiles[1] = [0]
	For $i = 1 To $aSections[0]
		If $aSections[$i] = "Options" Then ContinueLoop

		$aProfiles[0] += 1
		ReDim $aProfiles[$aProfiles[0] + 1]
		$aProfiles[$aProfiles[0]] = $aSections[$i]
	Next

	Return $aProfiles
EndFunc   ;==>GetSortedProfileSections


Func UpdateList_AS()
	Local $aSections

	GUICtrlSetData($g_hLst_AutoStart, "")
	$aSections = GetSortedProfileSections()
	If IsArray($aSections) Then
		For $i = 1 To $aSections[0]
			$sProfiles = IniRead($g_sDirProfiles, $aSections[$i], "Profile", "")
			If FileExists(@StartupDir & "\MyBot -" & $sProfiles & ".lnk") Then
				GUICtrlSetData($g_hLst_AutoStart, $sProfiles)
			EndIf
		Next
	EndIf

EndFunc   ;==>UpdateList_AS

; === CONFIGURATION LOADING ===
Func ReadIni($sSelectedProfile)

	$g_sIniProfile = IniRead($g_sDirProfiles, $sSelectedProfile, "Profile", "")
	If StringRegExp($g_sIniProfile, " ") = 1 Then
		$g_sIniProfile = '"' & $g_sIniProfile & '"'
	EndIf
	$g_sIniEmulator = IniRead($g_sDirProfiles, $sSelectedProfile, "Emulator", "")
	$g_sIniInstance = IniRead($g_sDirProfiles, $sSelectedProfile, "Instance", "")
	$g_sIniDir = @ScriptDir ; Use script directory

	Local $iParam = ""
	For $i = 1 To $g_iParameters
		$iParam &= 0
	Next
	$g_sIniParameters = IniRead($g_sDirProfiles, $sSelectedProfile, "Parameters", $iParam)
	NormalizeParameters($g_sIniParameters)
	SyncProfileUnlockModePreference($sSelectedProfile)

EndFunc   ;==>ReadIni

Func NormalizeParameters(ByRef $sParameters)
	$sParameters = StringRegExpReplace($sParameters, "[^01]", "0")
	While StringLen($sParameters) < $g_iParameters
		$sParameters &= "0"
	WEnd
	If StringLen($sParameters) > $g_iParameters Then $sParameters = StringLeft($sParameters, $g_iParameters)
EndFunc   ;==>NormalizeParameters



; === CONTEXT MENU HANDLING ===
Func WM_CONTEXTMENU($hWnd, $msg, $wParam, $lParam)
	Local $tPoint = _WinAPI_GetMousePos(True, GUICtrlGetHandle($g_hListview_Main))
	Local $iY = DllStructGetData($tPoint, "Y")

	$lst2 = _GUICtrlListView_GetItemCount($g_hListview_Main)
	If $lst2 > 0 Then
		For $i = 0 To 50
			$iLstbx_GetSel = _GUICtrlListView_GetSelectedCount($g_hListview_Main)
			If $iLstbx_GetSel > 1 Then
				_GUICtrlMenu_SetItemDisabled($g_hContext_Main, 0)
				_GUICtrlMenu_SetItemDisabled($g_hContext_Main, 1)
				_GUICtrlMenu_SetItemDisabled($g_hContext_Main, 2)
				_GUICtrlMenu_SetItemDisabled($g_hContext_Main, 4)
				_GUICtrlMenu_SetItemDisabled($g_hContext_Main, 5)
				_GUICtrlMenu_SetItemDisabled($g_hContext_Main, 6)
				_GUICtrlMenu_SetItemDisabled($g_hContext_Main, 8)
				_GUICtrlMenu_SetItemDisabled($g_hContext_Main, 9)
			ElseIf $iLstbx_GetSel < 2 Then
				_GUICtrlMenu_SetItemEnabled($g_hContext_Main, 0)
				_GUICtrlMenu_SetItemEnabled($g_hContext_Main, 1)
				_GUICtrlMenu_SetItemEnabled($g_hContext_Main, 2)
				_GUICtrlMenu_SetItemEnabled($g_hContext_Main, 4)
				_GUICtrlMenu_SetItemEnabled($g_hContext_Main, 5)
				_GUICtrlMenu_SetItemEnabled($g_hContext_Main, 6)
				_GUICtrlMenu_SetItemEnabled($g_hContext_Main, 8)
				_GUICtrlMenu_SetItemEnabled($g_hContext_Main, 9)
			EndIf

			Local $aRect = _GUICtrlListView_GetItemRect($g_hListview_Main, $i)
			If ($iY >= $aRect[1]) And ($iY <= $aRect[3]) Then _ContextMenu($i)
		Next
		Return $GUI_RUNDEFMSG

	ElseIf _GUICtrlListView_GetItemCount($g_hListview_Main) < 1 Then
		Return
	EndIf
EndFunc   ;==>WM_CONTEXTMENU



Func _ContextMenu($sItem)
	Switch _GUICtrlMenu_TrackPopupMenu($g_hContext_Main, GUICtrlGetHandle($g_hListview_Main), -1, -1, 1, 1, 2)
		Case $eStartVM
			$sProfile = _GUICtrlListView_GetItemText($g_hListview_Main, $sItem)
			StartEmuProfile($sProfile)

		Case $eStopVM
			$sProfile = _GUICtrlListView_GetItemText($g_hListview_Main, $sItem)
			StopEmuProfile($sProfile)

		Case $eRestartVM
			$sProfile = _GUICtrlListView_GetItemText($g_hListview_Main, $sItem)
			RestartEmuProfile($sProfile)

		Case $eStartBot
			$sProfile = _GUICtrlListView_GetItemText($g_hListview_Main, $sItem)
			StartBotProfile($sProfile)

		Case $eStopBot
			$sProfile = _GUICtrlListView_GetItemText($g_hListview_Main, $sItem)
			StopBotProfile($sProfile)

		Case $eRestartBot
			$sProfile = _GUICtrlListView_GetItemText($g_hListview_Main, $sItem)
			RestartBotProfile($sProfile)

		Case $eEdit
			GUISetState(@SW_DISABLE, $g_hGui_Main)
			$g_aGuiPos_Main = WinGetPos($g_hGui_Main)
			GUI_Edit()
			UpdateList_Main()
			GUISetState(@SW_ENABLE, $g_hGui_Main)
			RestoreMainGui()

		Case $eDelete
			$sProfile = _GUICtrlListView_GetItemText($g_hListview_Main, $sItem)
			IniDelete($g_sDirProfiles, $sProfile)
			If FileExists(@StartupDir & "\MyBot -" & $sProfile & ".lnk") Then FileDelete(@StartupDir & "\MyBot -" & $sProfile & ".lnk")
			UpdateList_Main()

	EndSwitch
EndFunc   ;==>_ContextMenu


; === LIST NOTIFICATIONS ===
Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

	Local $hWndFrom, $iCode, $tNMHDR, $hWndListView
	$hWndListView = $g_hListview_Main
	If Not IsHWnd($g_hListview_Main) Then $hWndListView = GUICtrlGetHandle($g_hListview_Main)

	$tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode

				Case $NM_DBLCLK
					Local $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)

					$Index = DllStructGetData($tInfo, "Index")

					$subitemNR = DllStructGetData($tInfo, "SubItem")
					If $Index <> -1 Then
						If _IsPressed(10) Then
							$Lstbx_Sel = _GUICtrlListView_GetItemText($g_hListview_Main, $Index)
							ReadIni($Lstbx_Sel)
							ToolTip("Profile: " & $g_sIniProfile & @CRLF & "Emulator: " & $g_sIniEmulator & @CRLF & "Instance: " & $g_sIniInstance & @CRLF & "Directory: " & $g_sIniDir)
							Do
								Sleep(100)
							Until _IsPressed(10) = False
							ToolTip("")
						Else
							RunSetup()
						EndIf
					EndIf

			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

#Region Android
; === EMULATOR DISCOVERY ===
Func GetBlueStacksPath()
	$sBlueStacksPath = RegRead($HKLM & "\SOFTWARE\BlueStacks\", "InstallDir")
	$sPlusMode = RegRead($HKLM & "\SOFTWARE\BlueStacks\", "Engine") = "plus"
	$sFrontend = "HD-Frontend.exe"
	If $sPlusMode Then $sFrontend = "HD-Plus-Frontend.exe"
	$sBlueStacksPath = NormalizeDir($sBlueStacksPath)
	If $sBlueStacksPath = "" And FileExists(@ProgramFilesDir & "\BlueStacks\" & $sFrontend) = 1 Then
		$sBlueStacksPath = @ProgramFilesDir & "\BlueStacks\"
	EndIf

	Return $sBlueStacksPath
EndFunc   ;==>GetBlueStacksPath

Func NormalizeDir($sPath)
	If $sPath = "" Then Return ""
	If StringRight($sPath, 1) <> "\" Then $sPath &= "\"
	Return $sPath
EndFunc   ;==>NormalizeDir

Func GetBlueStacks5Path()
	Local $sBS5Path = ""

	; Check registry
	$sBS5Path = NormalizeDir(RegRead("HKLM\SOFTWARE\BlueStacks_nxt", "InstallDir"))
	If $sBS5Path <> "" And FileExists($sBS5Path & "HD-Player.exe") Then Return $sBS5Path

	; Check 64-bit registry
	$sBS5Path = NormalizeDir(RegRead("HKLM64\SOFTWARE\BlueStacks_nxt", "InstallDir"))
	If $sBS5Path <> "" And FileExists($sBS5Path & "HD-Player.exe") Then Return $sBS5Path

	; Check common paths
	Local $aPaths[] = [@ProgramFilesDir & "\BlueStacks_nxt\", _
						@ProgramFilesDir & "\BlueStacks X\", _
						"C:\Program Files\BlueStacks_nxt\", _
						"C:\Program Files (x86)\BlueStacks_nxt\"]

	For $sPath In $aPaths
		If FileExists($sPath & "HD-Player.exe") Then Return $sPath
	Next

	Return "" ; Not found
EndFunc   ;==>GetBlueStacks5Path

Func GetMEmuPath()
	Local $sMEmuPath = NormalizeDir(EnvGet("MEmu_Path"))
	If $sMEmuPath <> "" And FileExists($sMEmuPath & "MEmu.exe") Then Return $sMEmuPath
	If $sMEmuPath <> "" And FileExists($sMEmuPath & "MEmu\MEmu.exe") Then Return NormalizeDir($sMEmuPath & "MEmu")

	Local $aRegistryKeys[] = [$HKLM & "\SOFTWARE" & $Wow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", _
			"HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", _
			"HKLM64\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\"]

	For $sKey In $aRegistryKeys
		$sMEmuPath = NormalizeDir(RegRead($sKey, "InstallLocation"))
		If $sMEmuPath <> "" And FileExists($sMEmuPath & "MEmu\MEmu.exe") Then Return NormalizeDir($sMEmuPath & "MEmu")
		If $sMEmuPath <> "" And FileExists($sMEmuPath & "MEmu.exe") Then Return $sMEmuPath

		Local $sDisplayIcon = RegRead($sKey, "DisplayIcon")
		If $sDisplayIcon <> "" Then
			$sDisplayIcon = StripOuterQuotes(StringRegExpReplace($sDisplayIcon, ",\d+$", ""))
			Local $iLastSlash = StringInStr($sDisplayIcon, "\", 0, -1)
			If $iLastSlash > 0 Then
				$sMEmuPath = NormalizeDir(StringLeft($sDisplayIcon, $iLastSlash))
				If FileExists($sMEmuPath & "MEmu.exe") Then Return $sMEmuPath
			EndIf
		EndIf
	Next

	Local $aPaths[] = [@ProgramFilesDir & "\Microvirt\MEmu\", _
			@ProgramFilesDir & "\Microvirt\MEmuHyperv\", _
			"C:\Program Files\Microvirt\MEmu\", _
			"C:\Program Files (x86)\Microvirt\MEmu\"]

	For $sPath In $aPaths
		If FileExists($sPath & "MEmu.exe") Then Return NormalizeDir($sPath)
	Next

	Return ""
EndFunc   ;==>GetMEmuPath

Func GetMEmuInstanceName($sInstance)
	If $sInstance = "" Then $sInstance = "MEmu"
	Local $sMEmuPath = GetMEmuPath()
	If $sMEmuPath = "" Then Return ""

	Local $sVMPath = $sMEmuPath & "MemuHyperv VMs\"
	Local $hSearch = FileFindFirstFile($sVMPath & "*")
	If $hSearch = -1 Then Return ""

	While True
		Local $sRegisteredInstance = FileFindNextFile($hSearch)
		If @error Then ExitLoop
		If StringInStr(FileGetAttrib($sVMPath & $sRegisteredInstance), "D") And _
				FileExists($sVMPath & $sRegisteredInstance & "\" & $sRegisteredInstance & ".memu") And _
				StringCompare($sInstance, $sRegisteredInstance, $STR_NOCASESENSE) = 0 Then
			FileClose($hSearch)
			Return $sRegisteredInstance
		EndIf
	WEnd

	FileClose($hSearch)
	Return ""
EndFunc   ;==>GetMEmuInstanceName

Func ResolveMEmuProfileInstance(ByRef $sInstance, $sProfile)
	Local $sConfiguredInstance = ($sInstance = "" ? "MEmu" : $sInstance)
	Local $sRegisteredInstance = GetMEmuInstanceName($sConfiguredInstance)
	If $sRegisteredInstance = "" Then
		MsgBox($MB_OK, "Error", "MEmu instance not found: " & $sConfiguredInstance & @CRLF & "Profile: " & $sProfile, 0, $g_hGui_Main)
		Return False
	EndIf

	$sInstance = $sRegisteredInstance
	Return True
EndFunc   ;==>ResolveMEmuProfileInstance

Func IsAndroidInstalled($sAndroid)
	Local $sPath, $sFile, $bIsInstalled = False

	Switch $sAndroid
		Case "BlueStacks5"
			$sPath = GetBlueStacks5Path()
			$sFile = "HD-Player.exe"
		Case "MEmu"
			$sPath = GetMEmuPath()
			$sFile = "MEmu.exe"
	EndSwitch

	If $sPath <> "" And FileExists($sPath & $sFile) = 1 Then $bIsInstalled = True

	Return $bIsInstalled
EndFunc   ;==>IsAndroidInstalled

Func GetInstanceMgrPath($sAndroid)
	Local $sManagerPath

	Switch $sAndroid
		Case "BlueStacks5"
			$sManagerPath = GetBlueStacks5Path() & "BstkVMMgr.exe"
		Case "MEmu"
			$sManagerPath = NormalizeDir(EnvGet("MEmuHyperv_Path")) & "MEmuManage.exe"
			If Not FileExists($sManagerPath) Then $sManagerPath = GetMEmuPath() & "..\MEmuHyperv\MEmuManage.exe"
	EndSwitch

	Return $sManagerPath

EndFunc   ;==>GetInstanceMgrPath
#EndRegion Android
#Region CMD
; === COMMAND EXECUTION ===
Func LaunchConsole($sCMD, $sParameter, $iTimeOut = 10000)


	Local $sData, $iPID, $hTimer

	If StringLen($sParameter) > 0 Then $sCMD &= " " & $sParameter

	$hTimer = TimerInit()
	Local $bProcessKilled = False

	$iPID = Run($sCMD, "", @SW_HIDE, $STDERR_MERGED)
	If $iPID = 0 Then
		Return
	EndIf

	Local $hProcess
	If _WinAPI_GetVersion() >= 6.0 Then
		$hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_LIMITED_INFORMATION, 0, $iPID)
	Else
		$hProcess = _WinAPI_OpenProcess($PROCESS_QUERY_INFORMATION, 0, $iPID)
	EndIf

	$sData = ""
	$iDelaySleep = 100
	Local $iTimeOut_Sec = Round($iTimeOut / 1000)

	While True
		If $hProcess Then
			_WinAPI_WaitForSingleObject($hProcess, $iDelaySleep)
		Else
			Sleep($iDelaySleep)
		EndIf
		$sData &= StdoutRead($iPID)
		If @error Then ExitLoop
		If ($iTimeOut > 0 And TimerDiff($hTimer) > $iTimeOut) Then ExitLoop
	WEnd

	If $hProcess Then
		_WinAPI_CloseHandle($hProcess)
		$hProcess = 0
	EndIf

	CleanLaunchOutput($sData)

	If ProcessExists($iPID) Then
		If ProcessClose($iPID) = 1 Then
			$bProcessKilled = True
		EndIf
	EndIf
	StdioClose($iPID)
	Return $sData
EndFunc   ;==>LaunchConsole

Func CleanLaunchOutput(ByRef $output)

	$output = StringReplace($output, @CR & @CR, "")
	$output = StringReplace($output, @CRLF & @CRLF, "")
	If StringRight($output, 1) = @LF Then $output = StringLeft($output, StringLen($output) - 1)
	If StringRight($output, 1) = @CR Then $output = StringLeft($output, StringLen($output) - 1)
EndFunc   ;==>CleanLaunchOutput

; === EMULATOR PROCESS CONTROL ===
Func StartEmu()
	Local $aSections = GetSortedProfileSections()
	If Not IsArray($aSections) Then Return

	For $i = 1 To $aSections[0]
		Local $sProfile = $aSections[$i]
		ReadIni($sProfile)
		Local $sCmd = ""
		Switch $g_sIniEmulator
			Case "BlueStacks5"
				Local $sBS5Path = GetBlueStacks5Path()
				If $sBS5Path <> "" Then
					$sCmd = $sBS5Path & "HD-Player.exe"
					ShellExecute($sCmd, "--instance " & $g_sIniInstance)
				EndIf
			Case "MEmu"
				If Not ResolveMEmuProfileInstance($g_sIniInstance, $sProfile) Then ContinueLoop
				Local $sMEmuPath = GetMEmuPath()
				If $sMEmuPath <> "" Then
					$sCmd = $sMEmuPath & "MEmu.exe"
					ShellExecute($sCmd, $g_sIniInstance)
				EndIf
		EndSwitch
		Sleep(1000)
	Next
EndFunc

Func StopEmu()
	; Stop only emulator instances associated with configured profiles.
	Local $iCount = _GUICtrlListView_GetItemCount($g_hListview_Main)
	For $i = 0 To $iCount - 1
		Local $sProfile = _GUICtrlListView_GetItemText($g_hListview_Main, $i)
		StopEmuProfile($sProfile)
	Next
EndFunc

Func StartEmuProfile($sProfile)
	ReadIni($sProfile)
	Local $sCmd = ""
	Switch $g_sIniEmulator
		Case "BlueStacks5"
			Local $sBS5Path = GetBlueStacks5Path()
			If $sBS5Path <> "" Then
				$sCmd = $sBS5Path & "HD-Player.exe"
				ShellExecute($sCmd, "--instance " & $g_sIniInstance)
			Else
				MsgBox($MB_OK, "Error", "BlueStacks 5 not found - verify installation", 0, $g_hGui_Main)
			EndIf
		Case "MEmu"
			If Not ResolveMEmuProfileInstance($g_sIniInstance, $sProfile) Then Return
			Local $sMEmuPath = GetMEmuPath()
			If $sMEmuPath <> "" Then
				$sCmd = $sMEmuPath & "MEmu.exe"
				ShellExecute($sCmd, $g_sIniInstance)
			Else
				MsgBox($MB_OK, "Error", "MEmu not found - verify installation", 0, $g_hGui_Main)
			EndIf
	EndSwitch
EndFunc

Func StopEmuProfile($sProfile)
	ReadIni($sProfile)
	Switch $g_sIniEmulator
		Case "BlueStacks5"
			; Stop the specific BlueStacks instance using WMI
			Local $objWMIService = ObjGet("winmgmts:\\.\root\cimv2")
			Local $colProcesses = $objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'HD-Player.exe'")

			For $objProcess In $colProcesses
				Local $sCmdLine = $objProcess.CommandLine
				If CommandLineHasSwitchValue($sCmdLine, "--instance", $g_sIniInstance) Then
					$objProcess.Terminate()
					Sleep(500)
					ExitLoop
				EndIf
			Next
		Case "MEmu"
			If Not ResolveMEmuProfileInstance($g_sIniInstance, $sProfile) Then Return
			; Stop the specific MEmu instance using WMI.
			Local $objWMIService = ObjGet("winmgmts:\\.\root\cimv2")
			Local $colProcesses = $objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'MEmu.exe'")

			For $objProcess In $colProcesses
				Local $sCmdLine = $objProcess.CommandLine
				If CommandLineHasArgument($sCmdLine, $g_sIniInstance) Then
					$objProcess.Terminate()
					Sleep(500)
					ExitLoop
				EndIf
			Next
	EndSwitch
EndFunc

Func RestartEmuProfile($sProfile)
	StopEmuProfile($sProfile)
	Sleep(3000)
	StartEmuProfile($sProfile)
EndFunc

; === BOT PROCESS CONTROL ===
Func StartBotProfile($sProfile)
	ReadIni($sProfile)
	If $g_sIniEmulator = "MEmu" And Not ResolveMEmuProfileInstance($g_sIniInstance, $sProfile) Then Return
	Local $sEmulator = $g_sIniEmulator
	If $g_sIniEmulator = "BlueStacks3" Then $sEmulator = "BlueStacks2"
	$aParameters = StringSplit($g_sIniParameters, "")
	Local $sSpecialParameter = ($aParameters[1] = 1 ? " /debug" : "") & ($aParameters[2] = 1 ? " /dpiaware" : "") & ($aParameters[3] = 1 ? " /hideandroid" : "") & ($aParameters[4] = 1 ? " /minigui" : "") & ($aParameters[5] = 1 ? " /nowatchdog" : "") & ($aParameters[6] = 1 ? " /lightmode" : "")
	Local $sInstance = $g_sIniInstance
	If FileExists($g_sIniDir & "\\" & $g_sBotFile) = 1 Then
		ShellExecute($g_sBotFile, $g_sIniProfile & " " & $sEmulator & " " & $sInstance & $sSpecialParameter, $g_sIniDir)
	ElseIf FileExists($g_sIniDir & "\\" & $g_sBotFileAU3) = 1 Then
		ShellExecute($g_sBotFileAU3, $g_sIniProfile & " " & $sEmulator & " " & $sInstance & $sSpecialParameter, $g_sIniDir)
	Else
		MsgBox($MB_OK, "Error", "MyBot.run.exe or .au3 not found in profile directory", 0, $g_hGui_Main)
	EndIf
EndFunc

Func StopBotProfile($sProfile)
	ReadIni($sProfile)
	; Find and close MyBot.run.exe process for this specific profile
	Local $objWMIService = ObjGet("winmgmts:\\.\root\cimv2")
	Local $colProcesses = $objWMIService.ExecQuery("SELECT * FROM Win32_Process WHERE Name = 'MyBot.run.exe'")

	For $objProcess In $colProcesses
		Local $sCmdLine = $objProcess.CommandLine
		If CommandLineHasArgument($sCmdLine, StringReplace($g_sIniProfile, '"', '')) Then
			$objProcess.Terminate()
			Sleep(500)
			ExitLoop
		EndIf
	Next
EndFunc

; === COMMAND-LINE HELPERS ===
Func CommandLineHasSwitchValue($sCmdLine, $sSwitch, $sExpectedValue)
	Local $aTokens = StringRegExp($sCmdLine, '"[^"]*"|\S+', 3)
	If Not IsArray($aTokens) Then Return False

	For $i = 0 To UBound($aTokens) - 1
		Local $sToken = StripOuterQuotes($aTokens[$i])
		If $sToken = $sSwitch And $i + 1 < UBound($aTokens) Then
			Return StripOuterQuotes($aTokens[$i + 1]) = $sExpectedValue
		EndIf
		If StringLeft($sToken, StringLen($sSwitch) + 1) = $sSwitch & "=" Then
			Return StringTrimLeft($sToken, StringLen($sSwitch) + 1) = $sExpectedValue
		EndIf
	Next

	Return False
EndFunc

Func CommandLineHasArgument($sCmdLine, $sExpectedValue)
	Local $aTokens = StringRegExp($sCmdLine, '"[^"]*"|\S+', 3)
	If Not IsArray($aTokens) Then Return False

	For $i = 0 To UBound($aTokens) - 1
		If StripOuterQuotes($aTokens[$i]) = $sExpectedValue Then Return True
	Next

	Return False
EndFunc

Func StripOuterQuotes($sValue)
	If StringLen($sValue) >= 2 And StringLeft($sValue, 1) = '"' And StringRight($sValue, 1) = '"' Then
		Return StringMid($sValue, 2, StringLen($sValue) - 2)
	EndIf
	Return $sValue
EndFunc

Func RestartBotProfile($sProfile)
	StopBotProfile($sProfile)
	Sleep(2000)
	StartBotProfile($sProfile)
EndFunc

Func RestartEmu()
	StopEmu()
	Sleep(2000)
	StartEmu()
EndFunc

; === WINDOW AND TRAY EVENTS ===
Func _TrayEvent($iEvent = $TRAY_EVENT_PRIMARYDOWN)
	If $iEvent = $TRAY_EVENT_PRIMARYDOWN Then
		If $g_bMinimizedToTray Then
			$g_bMinimizedToTray = False
			GUISetState(@SW_RESTORE, $g_hGui_Main)
			WinActivate($g_hGui_Main)
		Else
			$g_bMinimizedToTray = True
			GUISetState(@SW_MINIMIZE, $g_hGui_Main)
		EndIf
	EndIf
EndFunc

Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
	If $hWnd = $g_hGui_Main Then
		If BitAND($wParam, 1) Then ; Minimized
			$g_bMinimizedToTray = True
			; Keep in taskbar
			Return $GUI_RUNDEFMSG
		ElseIf $wParam = 0 And $g_bMinimizedToTray Then ; Restored
			; Restore window
			$g_bMinimizedToTray = False
			GUISetState(@SW_RESTORE, $g_hGui_Main)
			WinActivate($g_hGui_Main)
			Return 0
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc

Func WM_SYSCOMMAND($hWnd, $iMsg, $wParam, $lParam)
	If $hWnd = $g_hGui_Main Then
		If $wParam = 0xF020 Then ; SC_MINIMIZE
			$g_bMinimizedToTray = True
			; Minimize to taskbar
			Return $GUI_RUNDEFMSG
		ElseIf $wParam = 0xF120 Then ; SC_RESTORE
			; Restore from taskbar
			$g_bMinimizedToTray = False
			Return $GUI_RUNDEFMSG
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc

; === TRAY ACTIONS ===
Func TrayShow()
	$g_bMinimizedToTray = False
	GUISetState(@SW_SHOW, $g_hGui_Main)
	GUISetState(@SW_RESTORE, $g_hGui_Main)
	WinActivate($g_hGui_Main)
EndFunc

Func TrayStartAll()
	StartAll()
EndFunc

Func TrayRestartAll()
	RestartAll()
EndFunc

Func TrayStopAll()
	StopAll()
EndFunc

Func TrayStartEmu()
	StartEmu()
EndFunc

Func TrayRestartEmu()
	RestartEmu()
EndFunc

Func TrayStopEmu()
	StopEmu()
EndFunc

Func TrayExit()
	_Exit()
EndFunc

Func TrayOpenMyBotDir()
	ShellExecute(@ScriptDir)
	TrayItemSetState($g_hTrayItem_MyBotDir, $TRAY_UNCHECKED)
EndFunc

Func TrayOpenProfileDir()
	ShellExecute(@ScriptDir & "\Profiles\")
	TrayItemSetState($g_hTrayItem_ProfileDir, $TRAY_UNCHECKED)
EndFunc

; === ADB CONTROL ===
Func TrayADBReset()
	ADBReset()
	TrayItemSetState($g_hTrayItem_ADBReset, $TRAY_UNCHECKED)
EndFunc

Func ADBReset()
	RunWait(@ComSpec & " /c taskkill /F /IM adb.exe >nul 2>&1", @ScriptDir, @SW_HIDE)
	RunWait(@ComSpec & " /c taskkill /F /IM hd-adb.exe >nul 2>&1", @ScriptDir, @SW_HIDE)
	TrayTip("MultiBot", "ADB Reset Completed", 3, $TIP_ICONASTERISK)
EndFunc

; === TRAY MENU ===
Func ShowTrayMenu()
	Local $aMousePos = MouseGetPos()
	Local $hTrayGui = GUICreate("Tray Menu", 120, 200, $aMousePos[0], $aMousePos[1] - 200, $WS_POPUP, $WS_EX_TOPMOST)
	GUISetBkColor(0xFFFFFF, $hTrayGui)
	Local $btnStartAll = GUICtrlCreateButton("Start All Bots", 10, 10, 100, 25)
	Local $btnRestartAll = GUICtrlCreateButton("Restart All Bots", 10, 40, 100, 25)
	Local $btnStopAll = GUICtrlCreateButton("Stop All Bots", 10, 70, 100, 25)
	Local $btnStartEmu = GUICtrlCreateButton("Start All VMs", 10, 100, 100, 25)
	Local $btnRestartEmu = GUICtrlCreateButton("Restart All VMs", 10, 130, 100, 25)
	Local $btnStopEmu = GUICtrlCreateButton("Stop All VMs", 10, 160, 100, 25)
	GUISetState(@SW_SHOW, $hTrayGui)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($hTrayGui)
				Return
			Case $btnStartAll
				TrayStartAll()
				GUIDelete($hTrayGui)
				Return
			Case $btnRestartAll
				TrayRestartAll()
				GUIDelete($hTrayGui)
				Return
			Case $btnStopAll
				TrayStopAll()
				GUIDelete($hTrayGui)
				Return
			Case $btnStartEmu
				TrayStartEmu()
				GUIDelete($hTrayGui)
				Return
			Case $btnRestartEmu
				TrayRestartEmu()
				GUIDelete($hTrayGui)
				Return
			Case $btnStopEmu
				TrayStopEmu()
				GUIDelete($hTrayGui)
				Return
		EndSwitch
	WEnd
EndFunc

; === SHUTDOWN ===
Func _Exit()
	Exit
EndFunc

#EndRegion CMD
