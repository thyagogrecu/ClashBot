; #FUNCTION# ====================================================================================================================
; Name ..........: MBR Bot
; Description ...: This file contains the initialization and main loop sequences f0r the MBR Bot
; Author ........:  (2014)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
; AutoIt pragmas
#NoTrayIcon
#RequireAdmin
#AutoIt3Wrapper_UseX64=7n
;#AutoIt3Wrapper_Res_HiDpi=Y ; HiDpi will be set during run-time!
;#AutoIt3Wrapper_Run_AU3Check=n ; enable when running in folder with umlauts!
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/rsln /MI=3

#include "MyBot.run.version.au3"
#pragma compile(ProductName, My Bot)
#pragma compile(Out, MyBot.run.exe) ; Required

; Enforce variable declarations
Opt("MustDeclareVars", 1)

Global $g_sBotTitle = "" ;~ Don't assign any title here, use Func UpdateBotTitle()
Global $g_hFrmBot = 0 ; The main GUI window

; MBR includes
#include "COCBot\MBR Global Variables.au3"
#include "COCBot\functions\Config\DelayTimes.au3"
#include "COCBot\GUI\MBR GUI Design Splash.au3"
#include "COCBot\functions\Config\ScreenCoordinates.au3"
#include "COCBot\functions\Config\ImageDirectories.au3"
#include "COCBot\functions\Other\ExtMsgBox.au3"
#include "COCBot\functions\Other\MBRFunc.au3"
#include "COCBot\functions\Android\Android.au3"
#include "COCBot\functions\Android\Distributors.au3"
#include "COCBot\MBR GUI Design.au3"
#include "COCBot\MBR GUI Control.au3"
#include "COCBot\MBR Functions.au3"
#include "COCBot\functions\Attack\BuilderBase\BBSpam.au3"
#include "COCBot\functions\Village\CCSpam.au3"
#include "COCBot\functions\Attack\AttackCycle.au3"
#include "COCBot\functions\Image Search\ImgCapture.au3"
#include "COCBot\functions\Attack\AtkReport.au3"
#include "COCBot\functions\Other\Multilanguage.au3"
; MBR References.au3 must be last include
#include "COCBot\MBR References.au3"

; Autoit Options
Opt("GUIResizeMode", $GUI_DOCKALL) ; Default resize mode for dock android support
Opt("GUIEventOptions", 1) ; Handle minimize and restore for dock android support
Opt("GUICloseOnESC", 0) ; Don't send the $GUI_EVENT_CLOSE message when ESC is pressed.
Opt("WinTitleMatchMode", 3) ; Window Title exact match mode
Opt("GUIOnEventMode", 1)
Opt("MouseClickDelay", GetClickUpDelay()) ;Default: 10 milliseconds
Opt("MouseClickDownDelay", GetClickDownDelay()) ;Default: 5 milliseconds
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)

Global Enum _
	$eMaintenanceCollect = 0, $eMaintenanceCollectCCGold, _
	$eMaintenanceCheckTombs, $eMaintenanceCleanYard, $eMaintenanceAchievements, $eMaintenanceMagicItems, $eMaintenanceDailyChallenge, _
	$eMaintenanceReplayShare, $eMaintenanceNotifyReport, $eMaintenanceRequestCC, _
	$eMaintenanceHeroStatus, $eMaintenanceLaboratory, $eMaintenancePetHouse, $eMaintenanceHelperHut, _
	$eMaintenanceUpgradeHeroes, $eMaintenanceUpgradeBuilding, _
	$eMaintenanceAutoUpgrade, $eMaintenanceBlacksmith, $eMaintenanceForge, $eMaintenanceAutoUpgradeCC, $eMaintenanceUpgradeWall, _
	$eMaintenanceClanGames, $eMaintenanceBuilderBase, $eMaintenanceCount

Global Const $g_iMaintenanceFastMin = 2, $g_iMaintenanceFastMax = 4
Global Const $g_iMaintenanceStatusMin = 5, $g_iMaintenanceStatusMax = 10
Global Const $g_iMaintenanceUpgradeMin = 15, $g_iMaintenanceUpgradeMax = 30
Global Const $g_iMaintenanceCleanupMin = 30, $g_iMaintenanceCleanupMax = 60
Global Const $g_iMaintenanceBuilderBaseMin = 15, $g_iMaintenanceBuilderBaseMax = 30
Global Const $g_iMaintenanceBuilderBaseAttackMin = 5, $g_iMaintenanceBuilderBaseAttackMax = 10
Global Const $g_iMaintenanceRetryMin = 1, $g_iMaintenanceRetryMax = 2
Global Const $g_iMaintenanceClanGamesMin = 5, $g_iMaintenanceClanGamesMax = 10

Global $g_asMaintenanceActionNames[$eMaintenanceCount] = [ _
	"Collect", "CollectCCGold", _
	"CheckTombs", "CleanYard", "CollectAchievements", "CollectFreeMagicItems", "DailyChallenge", _
	"ReplayShare", "NotifyReport", "RequestCC", _
	"HeroStatus", "Laboratory", "PetHouse", "HelperHut", _
	"UpgradeHeroes", "UpgradeBuilding", _
	"AutoUpgrade", "Blacksmith", "ForgeClanCapitalGold", "AutoUpgradeCC", "UpgradeWall", _
	"ClanGames", "BuilderBaseMaintenance"]

Global $g_aiMaintenanceCollect[2] = [$eMaintenanceCollect, $eMaintenanceCollectCCGold]
Global $g_aiMaintenanceCleanup[5] = [$eMaintenanceCheckTombs, $eMaintenanceCleanYard, $eMaintenanceAchievements, $eMaintenanceMagicItems, $eMaintenanceDailyChallenge]
Global $g_aiMaintenanceCommunication[3] = [$eMaintenanceReplayShare, $eMaintenanceNotifyReport, $eMaintenanceRequestCC]
Global $g_aiMaintenanceStatus[2] = [$eMaintenanceLaboratory, $eMaintenancePetHouse]
Global $g_aiMaintenanceUpgrade[3] = [$eMaintenanceBlacksmith, $eMaintenanceForge, $eMaintenanceAutoUpgradeCC]
Global $g_aiMaintenanceAllUpgrades[3] = [$eMaintenanceBlacksmith, $eMaintenanceForge, $eMaintenanceAutoUpgradeCC]
Global $g_aiMaintenanceInitialStatus[3] = [$eMaintenanceLaboratory, $eMaintenancePetHouse, $eMaintenanceHelperHut]
Global $g_aiMaintenanceInitialCleanup[2] = [$eMaintenanceAchievements, $eMaintenanceMagicItems]
Global $g_aiMaintenanceInitialUpgrade[5] = [$eMaintenanceBlacksmith, $eMaintenanceUpgradeHeroes, $eMaintenanceUpgradeBuilding, $eMaintenanceAutoUpgrade, $eMaintenanceForge]
Global $g_asIdleActions[5] = ["Collect", "CheckTombs", "RequestCC", "DonateCC", "CleanYard"]

; Initialize bot launch time for restart timer
$g_hBotLaunchTime = __TimerInit()

; All executable code is in a function block, to detect coding errors, such as variable declaration scope problems
InitializeBot()
; Get All Emulators installed on machine.
getAllEmulators()

; Hand over control to main loop
MainLoop(CheckPrerequisites())

Func UpdateBotTitle()
	Local $sTitle = "MyBot PH MOD " & $g_sBotVersion
	Local $sConsoleTitle ; Console title has also Android Emulator Name
	If $g_sBotTitle = "" Then
		$g_sBotTitle = $sTitle
		$sConsoleTitle = $sTitle
	Else
		$g_sBotTitle = $sTitle & " (" & ($g_sAndroidInstance <> "" ? $g_sAndroidInstance : $g_sAndroidEmulator) & ")" ;Do not change this. If you do, multiple instances will not work.
		$sConsoleTitle = $sTitle & " " & $g_sAndroidEmulator & " (" & ($g_sAndroidInstance <> "" ? $g_sAndroidInstance : $g_sAndroidEmulator) & ")"
	EndIf
	If $g_hFrmBot <> 0 Then
		; Update Bot Window Title also
		WinSetTitle($g_hFrmBot, "", $g_sBotTitle)
		GUICtrlSetData($g_hLblBotTitle, $g_sBotTitle)
	EndIf
	; Update Console Window (if it exists)
	DllCall("kernel32.dll", "bool", "SetConsoleTitle", "str", "Console " & $sConsoleTitle)
	; Update try icon title
	TraySetToolTip($g_bDisableBotToolTips ? "" : $g_sBotTitle)

	SetDebugLog("Bot title updated to: " & $g_sBotTitle)
EndFunc   ;==>UpdateBotTitle

Func InitializeBot()

	ProcessCommandLine()

	If FileExists(@ScriptDir & "\EnableMBRDebug.txt") Then ; Set developer mode
		$g_bDevMode = True
		Local $aText = FileReadToArray(@ScriptDir & "\EnableMBRDebug.txt") ; check if special debug flags set inside EnableMBRDebug.txt file
		If Not @error Then
			For $l = 0 To UBound($aText) - 1
				If StringInStr($aText[$l], "DISABLEWATCHDOG", $STR_NOCASESENSEBASIC) <> 0 Then
					$g_bBotLaunchOption_NoWatchdog = True
					SetDebugLog("Watch Dog disabled by Developer Mode File Command", $COLOR_INFO)
				EndIf
			Next
		EndIf
	EndIf

	SetupProfileFolder() ; Setup profile folders

	SetLogCentered(" BOT LOG ") ; Initial text for log

	SetSwitchAccLog(_PadStringCenter(" SwitchAcc LOG ", 25, "="), $COLOR_BLACK, "Lucida Console", 8, False)

	DetectLanguage()
	If $g_iBotLaunchOption_Help Then
		ShowCommandLineHelp()
		Exit
	EndIf

	InitAndroidConfig()

	; early load of config
	Local $bConfigRead = FileExists($g_sProfileConfigPath)
	If $bConfigRead Or FileExists($g_sProfileBuildingPath) Then
		readConfig()
	EndIf
	; /minigui starts in normal mode so MyBot.run.dll receives the supported GUI initialization.
	; BotGuiModeToggle() later deletes the Normal controls and keeps only the Mini GUI.

	Local $sAndroidInfo = ""
	_ITaskBar_Init(False)
	_Crypt_Startup()
	__GDIPlus_Startup() ; Start GDI+ Engine (incl. a new thread)
	TCPStartup() ; Start the TCP service.

	CreateMainGUI() ; Just create the main window
	CreateSplashScreen() ; Create splash window

	; Ensure watchdog is launched (requires Bot Window for messaging)
	If Not $g_bBotLaunchOption_NoWatchdog Then LaunchWatchdog()

	InitializeMBR($sAndroidInfo, $bConfigRead)

	; Create GUI
	CreateMainGUIControls() ; Create all GUI Controls
	InitializeMainGUI() ; setup GUI Controls

	; Files/folders
	SetupFilesAndFolders()

	; Show main GUI
	ShowMainGUI()

	; Some final setup steps and checks
	FinalInitialization($sAndroidInfo)
	If $g_bBotLaunchOption_MiniGui And $g_iGuiMode = 1 Then BotGuiModeToggle()
	ApplyLaunchDock(True)

EndFunc   ;==>InitializeBot

Func ApplyLaunchDock($bImmediate = False)
	Static $hRetryTimer = 0
	If $g_iBotLaunchOption_Dock = 0 Then Return True
	If $g_iGuiMode <> 1 Or Not $g_bAndroidEmbed Then Return False
	If $g_bAndroidEmbedded Then
		$g_iBotLaunchOption_Dock = 0
		Return True
	EndIf
	If Not $bImmediate And $hRetryTimer <> 0 And __TimerDiff($hRetryTimer) < 5000 Then Return False

	$hRetryTimer = __TimerInit()
	If Not AndroidEmbed(True) Then Return False
	If $g_iBotLaunchOption_Dock = 2 And $g_bCustomTitleBarActive Then BotShrinkExpandToggle()
	$g_iBotLaunchOption_Dock = 0
	Return True
EndFunc   ;==>ApplyLaunchDock

; #FUNCTION# ====================================================================================================================
; Name ..........: ProcessCommandLine
; Description ...: Handle command line parameters
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func ProcessCommandLine()

	; Handle Command Line Launch Options and fill $g_asCmdLine
	If $CmdLine[0] > 0 Then
		For $i = 1 To $CmdLine[0]
			Local $bOptionDetected = True
			Switch $CmdLine[$i]
				; terminate bot if it exists (by window title!)
				Case "/restart", "/r", "-restart", "-r"
					$g_bBotLaunchOption_Restart = True
				Case "/autostart", "/a", "-autostart", "-a"
					$g_bBotLaunchOption_Autostart = True
				Case "/nowatchdog", "/nwd", "-nowatchdog", "-nwd"
					$g_bBotLaunchOption_NoWatchdog = True
				Case "/dpiaware", "/da", "-dpiaware", "-da"
					$g_bBotLaunchOption_ForceDpiAware = True
				Case "/dock1", "/d1", "-dock1", "-d1", "/dock", "/d", "-dock", "-d"
					$g_iBotLaunchOption_Dock = 1
					$g_bAndroidShieldDockEnabled = False
				Case "/dock2", "/d2", "-dock2", "-d2"
					$g_iBotLaunchOption_Dock = 2
					$g_bAndroidShieldDockEnabled = False
				Case "/nobotslot", "/nbs", "-nobotslot", "-nbs"
					$g_bBotLaunchOption_NoBotSlot = True
				Case "/debug", "/debugmode", "/dev", "/dm", "-debug", "-debugmode", "-dev", "-dm"
					$g_bDevMode = True
				Case "/minigui", "/mg", "-minigui", "-mg"
					$g_bBotLaunchOption_MiniGui = True
				Case "/lightmode", "/lm", "-lightmode", "-lm"
					$g_bBotLaunchOption_LightMode = True
				Case "/nogui", "/ng", "-nogui", "-ng"
					$g_iGuiMode = 0
				Case "/hideandroid", "/ha", "-hideandroid", "-ha"
					$g_bBotLaunchOption_HideAndroid = True
				Case "/minimizebot", "/minbot", "/mb", "-minimizebot", "-minbot", "-mb"
					$g_bBotLaunchOption_MinimizeBot = True
				Case "/console", "/c", "-console", "-c"
					$g_iBotLaunchOption_Console = True
					ConsoleWindow()
				Case "/?", "/h", "/help", "-?", "-h", "-help"
					; show command line help and exit
					$g_iBotLaunchOption_Help = True
				Case Else
					If StringInStr($CmdLine[$i], "/guipid=") Then
						Local $guidpid = Int(StringMid($CmdLine[$i], 9))
						If ProcessExists($guidpid) Then
							$g_iGuiPID = $guidpid
						Else
							SetDebugLog("GUI Process doesn't exist: " & $guidpid)
						EndIf
					ElseIf StringInStr($CmdLine[$i], "/profiles=") = 1 Then
						Local $sProfilePath = StringMid($CmdLine[$i], 11)
						If StringInStr(FileGetAttrib($sProfilePath), "D") Then
							$g_sProfilePath = $sProfilePath
						Else
							SetLog("Profiles Path doesn't exist: " & $sProfilePath, $COLOR_ERROR) ;
						EndIf
					Else
						$bOptionDetected = False
						$g_asCmdLine[0] += 1
						ReDim $g_asCmdLine[$g_asCmdLine[0] + 1]
						$g_asCmdLine[$g_asCmdLine[0]] = $CmdLine[$i]
					EndIf
			EndSwitch
			If $bOptionDetected Then SetDebugLog("Command Line Option detected: " & $CmdLine[$i])
		Next
	EndIf

	; Handle Command Line Parameters
	If $g_asCmdLine[0] > 0 Then
		$g_sProfileCurrentName = StringRegExpReplace($g_asCmdLine[1], '[/:*?"<>|]', '_')
	ElseIf FileExists($g_sProfilePath & "\profile.ini") Then
		$g_sProfileCurrentName = StringRegExpReplace(IniRead($g_sProfilePath & "\profile.ini", "general", "defaultprofile", ""), '[/:*?"<>|]', '_')
		If $g_sProfileCurrentName = "" Or Not FileExists($g_sProfilePath & "\" & $g_sProfileCurrentName) Then $g_sProfileCurrentName = "<No Profiles>"
	Else
		$g_sProfileCurrentName = "<No Profiles>"
	EndIf
EndFunc   ;==>ProcessCommandLine

; #FUNCTION# ====================================================================================================================
; Name ..........: InitializeAndroid
; Description ...: Initialize Android
; Syntax ........:
; Parameters ....: $bConfigRead - if config was already read and Android Emulator info loaded
; Return values .: None
; Author ........:
; Modified ......: cosote (Feb-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func InitializeAndroid($bConfigRead)

	Local $s = GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_06", "Initializing Android...")
	SplashStep($s)

	If $g_bBotLaunchOption_Restart = False Then
		; Change Android type and update variable
		If $g_asCmdLine[0] > 1 Then
			; initialize Android config
			InitAndroidConfig(True)

			Local $i
			For $i = 0 To UBound($g_avAndroidAppConfig) - 1
				If StringCompare($g_avAndroidAppConfig[$i][0], $g_asCmdLine[2]) = 0 Then
					$g_iAndroidConfig = $i
					SplashStep($s & "(" & $g_avAndroidAppConfig[$i][0] & ")...", False)
					If $g_avAndroidAppConfig[$i][1] <> "" And $g_asCmdLine[0] > 2 Then
						; Use Instance Name
						UpdateAndroidConfig($g_asCmdLine[3])
					Else
						UpdateAndroidConfig()
					EndIf
					SplashStep($s & "(" & $g_avAndroidAppConfig[$i][0] & ")", False)
					ExitLoop
				EndIf
			Next
		EndIf

		SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "StatusBar_Item_07", "Detecting Android..."))
		If $g_asCmdLine[0] < 2 And Not $bConfigRead Then
			DetectRunningAndroid()
			If Not $g_bFoundRunningAndroid Then DetectInstalledAndroid()
		EndIf

	Else

		; just increase step
		SplashStep($s)

	EndIf

	CleanSecureFiles()

	GetCOCDistributors() ; load of distributors to prevent rare bot freeze during boot

EndFunc   ;==>InitializeAndroid

; #FUNCTION# ====================================================================================================================
; Name ..........: SetupProfileFolder
; Description ...: Populate profile-related globals
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SetupProfileFolder()
	SetDebugLog("SetupProfileFolder: " & $g_sProfilePath & "\" & $g_sProfileCurrentName)
	$g_sProfileConfigPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\config.ini"
	$g_sProfileBuildingStatsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\stats_buildings.ini"
	$g_sProfileBuildingPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\building.ini"
	$g_sProfileClanGamesPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\clangames.ini"
	$g_sProfileLogsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Logs\"
	$g_sProfileLootsPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Loots\"
	$g_sProfileTempPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Temp\"
	$g_sProfileTempDebugPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Temp\Debug\"
	$g_sProfileDonateCapturePath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\'
	$g_sProfileDonateCaptureWhitelistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\White List\'
	$g_sProfileDonateCaptureBlacklistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\Black List\'
EndFunc   ;==>SetupProfileFolder

; #FUNCTION# ====================================================================================================================
; Name ..........: InitializeMBR
; Description ...: MBR setup routine
; Syntax ........:
; Parameters ....: $sAI - populated with AndroidInfo string in this function
;                  $bConfigRead - if config was already read and Android Emulator info loaded
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func InitializeMBR(ByRef $sAI, $bConfigRead)

	; license
	If Not FileExists(@ScriptDir & "\License.txt") Then
		Local $hDownload = InetGet("http://www.gnu.org/licenses/gpl-3.0.txt", @ScriptDir & "\License.txt")

		; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
		Local $i = 0
		Do
			Sleep($DELAYDOWNLOADLICENSE)
			$i += 1
		Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE) Or $i > 25

		InetClose($hDownload)
	EndIf

	; multilanguage
	If Not FileExists(@ScriptDir & "\Languages") Then DirCreate(@ScriptDir & "\Languages")
	;DetectLanguage()
	_ReadFullIni()
	; must be called after language is detected
	TranslateTroopNames()
	InitializeCOCDistributors()

	; check for compiled x64 version
	Local $sMsg = GetTranslatedFileIni("MBR GUI Design - Loading", "Compile_Script", "Don't Run/Compile the Script as (x64)! Try to Run/Compile the Script as (x86) to get the bot to work.\r\n" & _
			"If this message still appears, try to re-install AutoIt")
	If @AutoItX64 = 1 Then
		DestroySplashScreen()
		MsgBox(0, "", $sMsg)
		__GDIPlus_Shutdown()
		Exit
	EndIf

	; Initialize Android emulator
	InitializeAndroid($bConfigRead)

	; Update Bot title
	UpdateBotTitle()
	UpdateSplashTitle($g_sBotTitle & GetTranslatedFileIni("MBR GUI Design - Loading", "Loading_Profile", ", Profile: %s", $g_sProfileCurrentName))

	If $g_bBotLaunchOption_Restart = True Then
		If CloseRunningBot($g_sBotTitle, True) Then
			SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "Closing_previous", "Closing Previous Bot..."), False)
			If CloseRunningBot($g_sBotTitle) = True Then
				; wait for Mutexes to get disposed
				Sleep(3000)
				; check if Android is running
				WinGetAndroidHandle()
			EndIf
		EndIf
	EndIf

	Local $cmdLineHelp = GetTranslatedFileIni("MBR GUI Design - Loading", "Commandline_multiple_Bots", "By using the commandline (or a shortcut) you can start multiple Bots:\r\n" & _
			"     MyBot.run.exe [ProfileName] [EmulatorName] [InstanceName]\r\n\r\n" & _
			"With the first command line parameter, specify the Profilename (you can create profiles on the Bot/Profiles tab, if a " & _
			"profilename contains a {space}, then enclose the profilename in double quotes). " & _
			"With the second, specify the name of the Emulator and with the third, an Android Instance (not for BlueStacks). \r\n" & _
			"Supported Emulators are MEmu and BlueStacks5.\r\n\r\n" & _
			"Examples:\r\n" & _
			"     MyBot.run.exe MyVillage BlueStacks2\r\n" & _
			"     MyBot.run.exe ""My Second Village"" MEmu MEmu_1")

	$g_hMutex_BotTitle = CreateMutex($g_sBotTitle)
	$sAI = GetTranslatedFileIni("MBR GUI Design - Loading", "Android_instance_01", "%s", $g_sAndroidEmulator)
	Local $sAndroidInfo2 = $g_sAndroidEmulator & " (" & $g_sAndroidInstance & ")"
	If $g_sAndroidInstance <> "" Then
		$sAI = $sAndroidInfo2
	EndIf

	; Check if we are already running for this instance
	$sMsg = GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_01", "My Bot for %s is already running\r\n\r\n", $sAI)
	If $g_hMutex_BotTitle = 0 Then
		SetDebugLog($g_sBotTitle & " is already running, exit now")
		DestroySplashScreen()
		MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION, $MB_TOPMOST), $g_sBotTitle, $sMsg & $cmdLineHelp)
		__GDIPlus_Shutdown()
		Exit
	EndIf

	$sMsg = GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_02", "My Bot with Profile %s is already in use\r\n\r\n", $g_sProfileCurrentName)
	; Check if we are already running for this profile
	If aquireProfileMutex() = 0 Then
		ReleaseMutex($g_hMutex_BotTitle)
		releaseProfilesMutex(True)
		DestroySplashScreen()
		MsgBox(BitOR($MB_OK, $MB_ICONINFORMATION, $MB_TOPMOST), $g_sBotTitle, $sMsg & $cmdLineHelp)
		__GDIPlus_Shutdown()
		Exit
	EndIf

	; Get mutex
	$g_hMutex_MyBot = CreateMutex("MyBot.run")
	$g_bOnlyInstance = $g_hMutex_MyBot <> 0 ; And False
	SetDebugLog("My Bot is " & ($g_bOnlyInstance ? "" : "not ") & "the only running instance")

EndFunc   ;==>InitializeMBR

; #FUNCTION# ====================================================================================================================
; Name ..........: SetupFilesAndFolders
; Description ...: Checks for presence of needed files and folders, cleans up and creates as required
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SetupFilesAndFolders()

	;Migrate old shared_prefs locations
	Local $sOldProfiles = @MyDocumentsDir & "\MyBot.run-Profiles"
	If FileExists($sOldProfiles) = 1 And FileExists($g_sPrivateProfilePath) = 0 Then
		SetLog("Moving shared_prefs profiles folder")
		If DirMove($sOldProfiles, $g_sPrivateProfilePath) = 0 Then
			SetLog("Error moving folder " & $sOldProfiles, $COLOR_ERROR)
			SetLog("to new location " & $g_sPrivateProfilePath, $COLOR_ERROR)
			SetLog("Please resolve manually!", $COLOR_ERROR)
		Else
			SetLog("Moved shared_prefs profiles to " & $g_sPrivateProfilePath, $COLOR_SUCCESS)
		EndIf
	EndIf

	DirCreate($g_sProfilePresetPath)
	DirCreate($g_sPrivateProfilePath & "\" & $g_sProfileCurrentName)
	DirCreate($g_sProfilePath & "\" & $g_sProfileCurrentName)
	DirCreate($g_sProfileLogsPath)
	DirCreate($g_sProfileLootsPath)
	DirCreate($g_sProfileTempPath)
	DirCreate($g_sProfileTempDebugPath)

	$g_sProfileDonateCapturePath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\'
	$g_sProfileDonateCaptureWhitelistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\White List\'
	$g_sProfileDonateCaptureBlacklistPath = $g_sProfilePath & "\" & $g_sProfileCurrentName & '\Donate\Black List\'
	DirCreate($g_sProfileDonateCapturePath)
	DirCreate($g_sProfileDonateCaptureWhitelistPath)
	DirCreate($g_sProfileDonateCaptureBlacklistPath)

	;Migrate old bot without profile support to current one
	FileMove(@ScriptDir & "\*.ini", $g_sProfilePath & "\" & $g_sProfileCurrentName, $FC_OVERWRITE + $FC_CREATEPATH)
	DirCopy(@ScriptDir & "\Logs", $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Logs", $FC_OVERWRITE + $FC_CREATEPATH)
	DirCopy(@ScriptDir & "\Loots", $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Loots", $FC_OVERWRITE + $FC_CREATEPATH)
	DirCopy(@ScriptDir & "\Temp", $g_sProfilePath & "\" & $g_sProfileCurrentName & "\Temp", $FC_OVERWRITE + $FC_CREATEPATH)
	DirRemove(@ScriptDir & "\Logs", 1)
	DirRemove(@ScriptDir & "\Loots", 1)
	DirRemove(@ScriptDir & "\Temp", 1)

	;Setup profile if doesn't exist yet
	If FileExists($g_sProfileConfigPath) = 0 Then
		createProfile(True)
		applyConfig()
	EndIf

	If $g_bDeleteLogs Then DeleteFiles($g_sProfileLogsPath, "*.*", $g_iDeleteLogsDays, 0)
	If $g_bDeleteLoots Then DeleteFiles($g_sProfileLootsPath, "*.*", $g_iDeleteLootsDays, 0)
	If $g_bDeleteTemp Then
		DeleteFiles($g_sProfileTempPath, "*.*", $g_iDeleteTempDays, 0)
		DeleteFiles($g_sProfileTempDebugPath, "*.*", $g_iDeleteTempDays, 0, $FLTAR_RECUR)
	EndIf

	SetDebugLog("$g_sProfilePath = " & $g_sProfilePath)
	SetDebugLog("$g_sProfileCurrentName = " & $g_sProfileCurrentName)
	SetDebugLog("$g_sProfileLogsPath = " & $g_sProfileLogsPath)
EndFunc   ;==>SetupFilesAndFolders

; #FUNCTION# ====================================================================================================================
; Name ..........: FinalInitialization
; Description ...: Finalize various setup requirements
; Syntax ........:
; Parameters ....: $sAI: AndroidInfo for displaying in the log
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func FinalInitialization(Const $sAI)
	; check for VC2010, .NET software and MyBot Files and Folders
	Local $bCheckPrerequisitesOK = CheckPrerequisites(True)
	If $bCheckPrerequisitesOK Then
		MBRFunc(True) ; start MyBot.run.dll, after this point .net is initialized and threads popup all the time
		setAndroidPID() ; set Android PID
		SetBotGuiPID() ; set GUI PID
	EndIf

	If $g_bFoundRunningAndroid Then
		SetLog(GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_03", "Found running %s %s", $g_sAndroidEmulator, $g_sAndroidVersion), $COLOR_SUCCESS)
	EndIf
	If $g_bFoundInstalledAndroid Then
		SetLog("Found installed " & $g_sAndroidEmulator & " " & $g_sAndroidVersion, $COLOR_SUCCESS)
	EndIf
	SetLog(GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_04", "Android Emulator Configuration: %s", $sAI), $COLOR_SUCCESS)

	; Reset GUI to wait for remote GUI in no GUI mode
	$g_iGuiPID = @AutoItPID

	; Remember time in Milliseconds bot launched
	$g_iBotLaunchTime = __TimerDiff($g_hBotLaunchTime)

	; Wait for remote GUI to show when no GUI in this process
	If $g_iGuiMode = 0 Then
		SplashStep(GetTranslatedFileIni("MBR GUI Design - Loading", "Waiting_for_Remote_GUI", "Awaiting Remote GUI..."))
		SetDebugLog("Awaiting GUI Process...")

		Local $timer = __TimerInit()
		While $g_iGuiPID = @AutoItPID And __TimerDiff($timer) < 60000
			; wait for GUI Process updating $g_iGuiPID
			Sleep(50) ; must be Sleep as no run state!
		WEnd
		If $g_iGuiPID = @AutoItPID Then
			SetDebugLog("GUI Process not received, close bot")
			BotClose()
			$bCheckPrerequisitesOK = False
		Else
			SetDebugLog("Linked to GUI Process " & $g_iGuiPID)
		EndIf
	EndIf

	; destroy splash screen here (so we witness the 100% ;)
	DestroySplashScreen(False)
	If $bCheckPrerequisitesOK Then
		; only when bot can run, register with forum
		ForumAuthentication()
	EndIf

	; Allow now other bots to launch
	DestroySplashScreen()

	; Initialize controls used by Multi Stats
	UpdateMultiStats()
	SetDebugLog("Maximum of " & $g_iGlobalActiveBotsAllowed & " bots running at same time configured")
	SetDebugLog("MyBot.run launch time " & Round($g_iBotLaunchTime) & " ms")

	If $g_bAndroidShieldEnabled = False Then
		SetLog(GetTranslatedFileIni("MBR GUI Design - Loading", "Msg_Android_instance_05", "Android Shield not available for %s", @OSVersion), $COLOR_ACTION)
	EndIf

	DisableProcessWindowsGhosting()

	UpdateMainGUI()
EndFunc   ;==>FinalInitialization

; #FUNCTION# ====================================================================================================================
; Name ..........: MainLoop
; Description ...: Main application loop
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func MainLoop($bCheckPrerequisitesOK = True)
	Local $iStartDelay = 0

	If $bCheckPrerequisitesOK And ($g_bAutoStart Or $g_bRestarted) Then
		Local $iDelay = $g_iAutoStartDelay
		If $g_bRestarted Then $iDelay = 0
		$iStartDelay = $iDelay * 1000
		$g_iBotAction = $eBotStart
		; check if android should be hidden
		If $g_bBotLaunchOption_HideAndroid Then $g_bIsHidden = True
		; check if bot should be minimized
		If $g_bBotLaunchOption_MinimizeBot Then BotMinimizeRequest()
	EndIf

	Local $hStarttime = _Timer_Init()

	; Check the Supported Emulator versions
	CheckEmuNewVersions()

	;Reset Telegram message
	NotifyGetLastMessageFromTelegram()
	$g_iTGLastRemote = $g_sTGLast_UID

	While 1
		If _Sleep($DELAYSLEEP, True, False) Then Return
		ApplyLaunchDock()

		Local $diffhStarttime = _Timer_Diff($hStarttime)
		If Not $g_bRunState And $g_bNotifyTGEnable And $g_bNotifyRemoteEnable And $diffhStarttime > 1000 * 15 Then ; 15seconds
			$hStarttime = _Timer_Init()
			NotifyRemoteControlProcBtnStart()
		EndIf

		Switch $g_iBotAction
			Case $eBotStart
				BotStart($iStartDelay)
				$iStartDelay = 0 ; don't autostart delay in future
				If $g_iBotAction = $eBotStart Then $g_iBotAction = $eBotNoAction

			Case $eBotStop
				BotStop()
				If $g_iBotAction = $eBotStop Then $g_iBotAction = $eBotNoAction
				; Reset Telegram message
				$g_iTGLastRemote = $g_sTGLast_UID
			Case $eBotSearchMode
				BotSearchMode()
				If $g_iBotAction = $eBotSearchMode Then $g_iBotAction = $eBotNoAction
			Case $eBotClose
				BotClose()
		EndSwitch
	WEnd
EndFunc   ;==>MainLoop

Func __MaintenanceDue($iAction, $iMinMinutes, $iMaxMinutes, $bReset = False, $iDelayMinMinutes = -1, $iDelayMaxMinutes = -1)
	Static $aTimers[$g_iSwitchAccMaxAccounts][$eMaintenanceCount]
	Static $aCooldowns[$g_iSwitchAccMaxAccounts][$eMaintenanceCount]
	Static $aMinMinutes[$g_iSwitchAccMaxAccounts][$eMaintenanceCount]
	Static $aMaxMinutes[$g_iSwitchAccMaxAccounts][$eMaintenanceCount]
	Static $asProfileNames[$g_iSwitchAccMaxAccounts]

	Local $sProfileName = $g_sProfileCurrentName, $i
	If $sProfileName = "" Then $sProfileName = "Account:" & $g_iCurAccount
	Local $iAccount = -1, $iEmptySlot = -1
	For $i = 0 To $g_iSwitchAccMaxAccounts - 1
		If $asProfileNames[$i] = $sProfileName Then
			$iAccount = $i
			ExitLoop
		EndIf
		If $iEmptySlot = -1 And $asProfileNames[$i] = "" Then $iEmptySlot = $i
	Next
	If $iAccount = -1 Then
		$iAccount = $iEmptySlot
		If $iAccount = -1 Then
			$iAccount = $g_iCurAccount
			If $iAccount < 0 Or $iAccount >= $g_iSwitchAccMaxAccounts Then $iAccount = 0
			For $i = 0 To $eMaintenanceCount - 1
				$aTimers[$iAccount][$i] = 0
				$aCooldowns[$iAccount][$i] = 0
				$aMinMinutes[$iAccount][$i] = 0
				$aMaxMinutes[$iAccount][$i] = 0
			Next
		EndIf
		$asProfileNames[$iAccount] = $sProfileName
	EndIf
	If $iAction < 0 Or $iAction >= $eMaintenanceCount Then Return True

	If $bReset Then
		If $iDelayMinMinutes < 0 Then $iDelayMinMinutes = $iMinMinutes
		If $iDelayMaxMinutes < 0 Then $iDelayMaxMinutes = $iMaxMinutes
		$aTimers[$iAccount][$iAction] = __TimerInit()
		$aCooldowns[$iAccount][$iAction] = Random($iDelayMinMinutes, $iDelayMaxMinutes, 1) * 60000
		$aMinMinutes[$iAccount][$iAction] = $iMinMinutes
		$aMaxMinutes[$iAccount][$iAction] = $iMaxMinutes
		Return False
	EndIf

	If $aTimers[$iAccount][$iAction] = 0 Then Return True
	If $aMinMinutes[$iAccount][$iAction] <> $iMinMinutes Or $aMaxMinutes[$iAccount][$iAction] <> $iMaxMinutes Then Return True

	Return __TimerDiff($aTimers[$iAccount][$iAction]) >= $aCooldowns[$iAccount][$iAction]
EndFunc   ;==>__MaintenanceDue

Func __RunMaintenanceAction($iAction, $iMinMinutes, $iMaxMinutes, $bCheckReboot = False, $bForce = False)
	If $iAction < 0 Or $iAction >= $eMaintenanceCount Then
		SetLog("Invalid maintenance action ID: " & $iAction, $COLOR_ERROR)
		Return False
	EndIf
	If Not $bForce And Not __MaintenanceDue($iAction, $iMinMinutes, $iMaxMinutes) Then Return True
	If Not __RunBotCanContinue() Then Return False

	_RunFunction($g_asMaintenanceActionNames[$iAction])
	If Not __RunBotCanContinue() Then Return False
	If $bCheckReboot And CheckAndroidReboot() Then Return False
	If Not __RunBotCanContinue() Then Return False

	__MaintenanceDue($iAction, $iMinMinutes, $iMaxMinutes, True)
	Return True
EndFunc   ;==>__RunMaintenanceAction

Func __RunMaintenanceActions(ByRef $aActions, $iMinMinutes, $iMaxMinutes, $bCheckReboot = False)
	Local $aRunOrder[UBound($aActions)], $i, $iAction
	For $i = 0 To UBound($aActions) - 1
		$aRunOrder[$i] = $aActions[$i]
	Next
	_ArrayShuffle($aRunOrder)
	For $iAction In $aRunOrder
		If Not __RunMaintenanceAction($iAction, $iMinMinutes, $iMaxMinutes, $bCheckReboot) Then Return False
	Next
	Return True
EndFunc   ;==>__RunMaintenanceActions

Func __MaintenanceActionsDue(ByRef $aActions, $iMinMinutes, $iMaxMinutes)
	Local $iAction
	For $iAction In $aActions
		If __MaintenanceDue($iAction, $iMinMinutes, $iMaxMinutes) Then Return True
	Next
	Return False
EndFunc   ;==>__MaintenanceActionsDue

Func __ResetMaintenanceActions(ByRef $aActions, $iMinMinutes, $iMaxMinutes)
	Local $iAction
	For $iAction In $aActions
		__MaintenanceDue($iAction, $iMinMinutes, $iMaxMinutes, True)
	Next
EndFunc   ;==>__ResetMaintenanceActions

Func __RunClanGamesIfDue($bForce = False)
	Return __RunMaintenanceAction($eMaintenanceClanGames, $g_iMaintenanceClanGamesMin, $g_iMaintenanceClanGamesMax, False, $bForce)
EndFunc   ;==>__RunClanGamesIfDue

Func __RunBotCanContinue()
	Return $g_bRunState And Not $g_bRestart And Not $g_bRestartRunBot
EndFunc   ;==>__RunBotCanContinue

Func __RunBotStepReady($iDelay = 50)
	If Not __RunBotCanContinue() Then Return False
	If _Sleep($iDelay) Then Return False
	Return __RunBotCanContinue()
EndFunc   ;==>__RunBotStepReady

Func __RunBotInitialFlow()
	Local $bRunAccountInitialCheck = $g_bFirstStart

	; === ACCOUNT REMATCHING ===
	If Not $g_bRushAttackEnabled And ProfileSwitchAccountEnabled() And $g_bReMatchAcc Then
		SetLog("Rematching Account [" & $g_iNextAccount + 1 & "] with Profile [" & GUICtrlRead($g_ahCmbProfile[$g_iNextAccount]) & "]")
		If Not SwitchCoCAcc($g_iNextAccount) Then Return False
		If Not __RunBotCanContinue() Then Return False
	EndIf

	checkMainScreen(False)
	If Not __RunBotCanContinue() Then Return False

	If $g_bRushAttackEnabled Then
		$g_iCommandStop = -1
		; Read village values and update the GUI before Rush logs and execution.
		VillageReport(False, True, False)
		If Not __RunBotCanContinue() Then Return False
		Return True
	EndIf

	; === VILLAGE REPORT ===
	; BBSpam/CCSpam start here; Rush Attack is intercepted above.
	VillageReport(False, True)
	If Not __RunBotStepReady() Then Return False

	If $bRunAccountInitialCheck And Not $g_bSkipInitialCheck Then
		; === CLAN GAMES ===
		$g_bClanGamesCompleted = False
		If Not __RunClanGamesIfDue(True) Then Return False
		If Not __RunBotStepReady() Then Return False

		; === EQUIPMENT, LAB AND PET UPGRADES ===
		Laboratory()
		If Not __RunBotStepReady() Then Return False

		PetHouse()
		If Not __RunBotStepReady() Then Return False

		If $g_bChkCustomEquipmentOrderEnable Then
			Blacksmith()
			If Not __RunBotStepReady() Then Return False
		EndIf

		; === VILLAGE UPGRADES ===
		If Not RunVillageUpgrades() Then Return False

		If $g_bChkAppBuilder Or $g_bChkLabAssistant Then
			HelperHut()
			If Not __RunBotStepReady() Then Return False
		EndIf

		; === MISC COLLECTION ===
		If $g_bChkCollectAchievements Then
			CollectAchievements()
			If Not __RunBotStepReady() Then Return False
		EndIf

		If $g_bChkCollectFreeMagicItems Then
			CollectFreeMagicItems()
			If Not __RunBotStepReady() Then Return False
		EndIf

		If $g_bChkEnableCollectCCGold Then
			CollectCCGold()
			If Not __RunBotStepReady() Then Return False
		EndIf

		If ($g_bChkEnableForgeGold Or $g_bChkEnableForgeElix Or $g_bChkEnableForgeDE Or $g_bChkEnableForgeBBGold Or $g_bChkEnableForgeBBElix) And _
				($g_bUseGoldPassForgeOnly Or $g_iCmbForgeBuilder > 0) Then
			ForgeClanCapitalGold()
			If Not __RunBotStepReady() Then Return False
		EndIf

		If $g_bChkEnableAutoUpgradeCC And $g_bChkAutoUpgradeCCTreasury Then
			AutoUpgradeCC()
			If Not __RunBotStepReady() Then Return False
			__MaintenanceDue($eMaintenanceAutoUpgradeCC, $g_iMaintenanceUpgradeMin, $g_iMaintenanceUpgradeMax, True)
		EndIf
	EndIf

	; === MAIN BOT LOOP INITIALIZATION ===
	If Not $bRunAccountInitialCheck Then Return True
	FirstCheck()
	If Not __RunBotCanContinue() Then Return False
	If Not $g_bSkipInitialCheck Then
		If $g_iCommandStop = 0 Then
			HeroStatus()
			If Not __RunBotCanContinue() Then Return False
			__MaintenanceDue($eMaintenanceHeroStatus, $g_iMaintenanceStatusMin, $g_iMaintenanceStatusMax, True)
		EndIf

		__ResetMaintenanceActions($g_aiMaintenanceInitialStatus, $g_iMaintenanceStatusMin, $g_iMaintenanceStatusMax)
		__ResetMaintenanceActions($g_aiMaintenanceInitialCleanup, $g_iMaintenanceCleanupMin, $g_iMaintenanceCleanupMax)
		__ResetMaintenanceActions($g_aiMaintenanceInitialUpgrade, $g_iMaintenanceUpgradeMin, $g_iMaintenanceUpgradeMax)
		__MaintenanceDue($eMaintenanceCollectCCGold, $g_iMaintenanceFastMin, $g_iMaintenanceFastMax, True)
	EndIf
	Return True
EndFunc   ;==>__RunBotInitialFlow

Func runBot()
	Local $iWaitTime
	If Not $g_bRunState Or $g_bRestartRunBot Then Return
	While 1
		$g_bRestart = False
		If __RunBotInitialFlow() Then ExitLoop
		If Not $g_bRunState Or $g_bRestartRunBot Or Not $g_bRestart Then Return
	WEnd

	While 1
		If Not $g_bRunState Then ExitLoop
		If $g_bRestartRunBot Then Return
		If $g_bRushAttackEnabled Then
			RushAttackCycle()
			If Not $g_bRunState Then Return
			If $g_bRestart Then ContinueLoop
			If $g_bBotPaused Then Return
		EndIf

		;Restart bot after these seconds
		If $b_iAutoRestartDelay > 0 And __TimerDiff($g_hBotLaunchTime) > $b_iAutoRestartDelay * 1000 Then
			If RestartBot(False) Then Return
		EndIf

		PrepareDonateCC()
		If Not $g_bRunState Then Return
		$g_bFullArmy = False
		$g_bIsFullArmywithHeroesAndSpells = False
		$g_iCommandStop = -1
		If Not $g_bRunState Then Return
		If _Sleep(50) Then Return
		If $g_bRestart Then $g_bRestart = False
		checkObstacles() ; trap common error messages also check for reconnecting animation
		If $g_bRestart Then ContinueLoop
		If Not $g_bRunState Then Return
		Local $bMainScreenLocated = checkMainScreen(False)
		If $g_bRestart Then ContinueLoop
		If Not $g_bRunState Then Return

		If CheckAndroidReboot() Then ContinueLoop
		If Not $bMainScreenLocated Then ContinueLoop
		If Not $g_bIsClientSyncError Then
			If $g_bIsSearchLimit Then SetLog("Search limit hit", $COLOR_INFO)
			If _Sleep(50) Then Return
			VillageReport()
			If Not $g_bRunState Then Return
			If _Sleep(50) Then Return

			If BotCommand() Then btnStop()
			If Not $g_bRunState Then Return
			If $g_bOutOfGold And (Number($g_aiCurrentLoot[$eLootGold]) >= Number($g_iTxtRestartGold)) Then ; check if enough gold to begin searching again
				$g_bOutOfGold = False ; reset out of gold flag
				SetLog("Switching back to normal after no gold to search", $COLOR_SUCCESS)
				ContinueLoop ; Restart bot loop to reset $g_iCommandStop & $g_bTrainEnabled + $g_bDonationEnabled via BotCommand()
			EndIf
			If $g_bOutOfElixir And (Number($g_aiCurrentLoot[$eLootElixir]) >= Number($g_iTxtRestartElixir)) And (Number($g_aiCurrentLoot[$eLootDarkElixir]) >= Number($g_iTxtRestartDark)) Then ; check if enough elixir to begin searching again
				$g_bOutOfElixir = False ; reset out of elixir flag
				SetLog("Switching back to normal setting after no elixir to train", $COLOR_SUCCESS)
				ContinueLoop ; Restart bot loop to reset $g_iCommandStop & $g_bTrainEnabled + $g_bDonationEnabled via BotCommand()
			EndIf
			If Not $g_bRunState Then Return
			If _Sleep(50) Then Return
			If Not checkMainScreen(False, Default, False) Then ContinueLoop
			If $g_bRestart Then ContinueLoop
			Local $bMaintenanceUpgradeDue = False
			If $g_bIsSearchLimit Then
				If Not __RunMaintenanceAction($eMaintenanceCollect, $g_iMaintenanceFastMin, $g_iMaintenanceFastMax) Then ContinueLoop
			Else
				If Not __RunMaintenanceActions($g_aiMaintenanceCollect, $g_iMaintenanceFastMin, $g_iMaintenanceFastMax) Then ContinueLoop
			EndIf

			If Not $g_bIsSearchLimit Then
				If Not __RunMaintenanceActions($g_aiMaintenanceCleanup, $g_iMaintenanceCleanupMin, $g_iMaintenanceCleanupMax) Then ContinueLoop
			EndIf

			AddIdleTime()
			If Not $g_bRunState Then Return
			If $g_bRestart Then ContinueLoop
			If IsSearchAttackEnabled() Then
				If Not $g_bIsSearchLimit Then
					If Not __RunMaintenanceActions($g_aiMaintenanceCommunication, $g_iMaintenanceFastMin, $g_iMaintenanceFastMax, True) Then ContinueLoop
				EndIf
				_RunFunction('DonateCC,Train')
				If Not $g_bRunState Then Return
				If $g_bRestart Then ContinueLoop

				; Check if army is ready after training and execute attack cycle if needed
				If $g_bIsFullArmywithHeroesAndSpells And $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then
					AttackCycle(False) ; False for Routine Cycle
					; Exit the outer loop after an interrupted cycle.
					If $g_bRestart Then ContinueLoop
				EndIf

				If $g_bRestart Then ContinueLoop
			Else
				If $g_bRestart Then ContinueLoop
				_RunFunction('DonateCC,Train')
				If Not $g_bRunState Then Return
				If $g_bRestart Then ContinueLoop
			EndIf
			If $g_bRestart Then ContinueLoop

			If Not __RunMaintenanceAction($eMaintenanceHeroStatus, $g_iMaintenanceStatusMin, $g_iMaintenanceStatusMax) Then ContinueLoop
			If Not __RunMaintenanceActions($g_aiMaintenanceStatus, $g_iMaintenanceStatusMin, $g_iMaintenanceStatusMax, True) Then ContinueLoop
			If Not __RunMaintenanceAction($eMaintenanceHelperHut, $g_iMaintenanceStatusMin, $g_iMaintenanceStatusMax, True) Then ContinueLoop

			$bMaintenanceUpgradeDue = __MaintenanceActionsDue($g_aiMaintenanceAllUpgrades, $g_iMaintenanceUpgradeMin, $g_iMaintenanceUpgradeMax)
			If $bMaintenanceUpgradeDue Then
				If Not __RunMaintenanceActions($g_aiMaintenanceUpgrade, $g_iMaintenanceUpgradeMin, $g_iMaintenanceUpgradeMax, True) Then ContinueLoop
			EndIf

			Local $bBuilderBaseCycleRan = False, $bBuilderBaseCycleSucceeded = False, $bBuilderBaseResult = False
			If __BuilderBaseCycleEnabled() And Not __RunClanGamesIfDue() Then ContinueLoop

			While $g_bIsBBevent
				If SwitchForCGEvent() Then
					$bBuilderBaseResult = BuilderBase()
					If Not $g_bRunState Or $g_bRestart Or $g_bBotPaused Then Return
					$bBuilderBaseCycleRan = True
					If $bBuilderBaseResult Then
						$bBuilderBaseCycleSucceeded = True
					Else
						$g_bIsBBevent = 0
					EndIf
				Else
					ExitLoop
				EndIf
			WEnd

			Local $iBuilderBaseMinMinutes = $g_iMaintenanceBuilderBaseMin, $iBuilderBaseMaxMinutes = $g_iMaintenanceBuilderBaseMax
			If $g_bChkEnableBBAttack Then
				$iBuilderBaseMinMinutes = $g_iMaintenanceBuilderBaseAttackMin
				$iBuilderBaseMaxMinutes = $g_iMaintenanceBuilderBaseAttackMax
			EndIf

			If $bBuilderBaseCycleRan Then
				If $bBuilderBaseCycleSucceeded Then
					__MaintenanceDue($eMaintenanceBuilderBase, $iBuilderBaseMinMinutes, $iBuilderBaseMaxMinutes, True)
				Else
					__MaintenanceDue($eMaintenanceBuilderBase, $iBuilderBaseMinMinutes, $iBuilderBaseMaxMinutes, True, $g_iMaintenanceRetryMin, $g_iMaintenanceRetryMax)
				EndIf
			ElseIf __ShouldRunBuilderBaseCycle() And __MaintenanceDue($eMaintenanceBuilderBase, $iBuilderBaseMinMinutes, $iBuilderBaseMaxMinutes) Then
				$bBuilderBaseResult = _RunFunction($g_asMaintenanceActionNames[$eMaintenanceBuilderBase])
				If Not $g_bRunState Then Return
				If $g_bRestart Then ContinueLoop
				If CheckAndroidReboot() Then ContinueLoop
				If $bBuilderBaseResult Then
					__MaintenanceDue($eMaintenanceBuilderBase, $iBuilderBaseMinMinutes, $iBuilderBaseMaxMinutes, True)
				Else
					__MaintenanceDue($eMaintenanceBuilderBase, $iBuilderBaseMinMinutes, $iBuilderBaseMaxMinutes, True, $g_iMaintenanceRetryMin, $g_iMaintenanceRetryMax)
				EndIf
			EndIf

			If Not $g_bRunState Then Return

			If $g_bFirstStart Then SetDebugLog("First loop completed!")
			$g_bFirstStart = False ; already finished first loop since bot started.

			If ProfileSwitchAccountEnabled() Then
				If checkSwitchAcc() Then ContinueLoop
			EndIf
			If IsSearchAttackEnabled() Then
				If $g_bIsFullArmywithHeroesAndSpells Then
					SetDebugLog("Army is ready, skipping idle")
				Else
					Idle()
				EndIf
				If Not $g_bRunState Then Return
				If _Sleep(50) Then Return
				If $g_bRestart = True Then ContinueLoop

				If $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then
					AttackMain()
					$g_bSkipFirstZoomout = False
					If $g_bOutOfGold Then
						SetLog("Switching To Halt Attack: Stay Online/Collect Mode", $COLOR_ACTION)
						ContinueLoop
					EndIf
					If Not __RunBotCanContinue() Then Return
					If _Sleep(50) Then Return
					If $g_bRestart = True Then ContinueLoop
				EndIf
			Else
				If $g_bRestart Then ContinueLoop
				_RunFunction('DonateCC,Train')
				If Not $g_bRunState Then Return
				If $g_bRestart Then ContinueLoop
				_RunFunction('HeroStatus')
				If Not $g_bRunState Then Return
				If $g_bRestart Then ContinueLoop
				If SmartPause() Then Return
				If ProfileSwitchAccountEnabled() Then
					$g_iCommandStop = 2
					If checkSwitchAcc() Then ContinueLoop
				Else
					Local $bCloseGame = $g_bAttackPlannerCloseCoC Or $g_bAttackPlannerCloseAll Or $g_bAttackPlannerSuspendComputer
					If Not $bCloseGame Then
						$iWaitTime = Random($DELAYWAITATTACK1, $DELAYWAITATTACK2)
						SetLog("Attack not planned and skipped. Waiting random " & StringFormat("%0.1f", $iWaitTime / 1000) & " seconds", $COLOR_WARNING)
						If _SleepStatus($iWaitTime) Then Return False
					EndIf
				EndIf
			EndIf
		Else ;When error occurs directly goes to attack
			Local $sRestartText = $g_bIsSearchLimit ? " due search limit" : " after Out of Sync Error: Attack Now"
			SetLog("Restarted" & $sRestartText, $COLOR_INFO)
			;Use "CheckDonateOften" setting to run loop on hitting SearchLimit
			If $g_bIsSearchLimit And $g_bCheckDonateOften Then
				$g_bIsClientSyncError = False
				$g_bRestart = False
			EndIf
			If _Sleep($DELAYRUNBOT3) Then Return
			; OCR read current Village Trophies when OOS restart maybe due PB or else trophy-based halt conditions may use it.
			$g_aiCurrentLoot[$eLootTrophy] = Number(getTrophyMainScreen($aTrophies[0], $aTrophies[1]))
			If $g_bDebugSetLog Then SetDebugLog("Runbot Trophy Count: " & $g_aiCurrentLoot[$eLootTrophy], $COLOR_DEBUG)
			If Not $g_bIsSearchLimit Or Not $g_bCheckDonateOften Then AttackMain() ;If Search Limit hit, do main loop.
			If Not $g_bRunState Then Return
			$g_bSkipFirstZoomout = False
			If $g_bOutOfGold Then
				SetLog("Switching To Halt Attack: Stay Online/Collect Mode", $COLOR_ACTION)
				$g_bIsClientSyncError = False ; reset fast restart flag to stop OOS mode and start collecting resources
				ContinueLoop
			EndIf
			If _Sleep($DELAYRUNBOT5) Then Return
			If $g_bRestart = True Then ContinueLoop
		EndIf
	WEnd
EndFunc   ;==>runBot

Func Idle() ;Sequence that runs until Full Army
	$g_bIdleState = True
	Local $Result = _Idle()
	$g_bIdleState = False
	Return $Result
EndFunc   ;==>Idle

Func _Idle() ;Sequence that runs until Full Army

	Local $TimeIdle = 0 ;In Seconds
	If $g_bDebugSetLog Then SetDebugLog("Func Idle ", $COLOR_DEBUG)
	If $g_bSkipTrainingSystem Then
		CheckIfArmyIsReady(False)
		Return True
	EndIf

	While $g_bIsFullArmywithHeroesAndSpells = False

		CheckAndroidReboot()

		If ($g_iCommandStop = 0 Or $g_iCommandStop = 3) And ProfileSwitchAccountEnabled() Then
			If checkSwitchAcc() Then ExitLoop
			If Not $g_bRunState Then Return
		EndIf

		;Execute Notify Pending Actions
		NotifyPendingActions()
		If _Sleep($DELAYIDLE1) Then Return
		If $g_iCommandStop = -1 Then SetLog("Awaiting Full Army", $COLOR_ACTION)
		Local $hTimer = __TimerInit()
		If _Sleep($DELAYIDLE1) Then ExitLoop
		checkObstacles() ; trap common error messages also check for reconnecting animation
		checkMainScreen(False) ; required here due to many possible exits
		If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bTrainEnabled = True Then
			CheckIfArmyIsReady()
			If _Sleep($DELAYIDLE1) Then Return
			CloseWindow()
			If ($g_bIsFullArmywithHeroesAndSpells = False) Then
				If $g_bFullArmy Then
					SetLog("Clan Castle not ready, training continues", $COLOR_ACTION)
				Else
					SetLog("Army camp not full, training continues", $COLOR_ACTION)
				EndIf
				$g_iCommandStop = 0
			EndIf
		EndIf
		If $g_bRestart Then ExitLoop
		If Random(0, $g_iCollectAtCount - 1, 1) = 0 Then ; This is prevent from collecting all the time which isn't needed anyway, chance to run is 1/$g_iCollectAtCount
			_ArrayShuffle($g_asIdleActions)
			For $Index In $g_asIdleActions
				If Not $g_bRunState Then Return
				_RunFunction($Index)
				If Not $g_bRunState Then Return
				If $g_bRestart Then ExitLoop
				If CheckAndroidReboot() Then ContinueLoop 2
			Next
			If Not $g_bRunState Then Return
			If $g_bRestart Then ExitLoop
			If _Sleep($DELAYIDLE1) Or Not $g_bRunState Then ExitLoop
		ElseIf $g_bCheckDonateOften Then
			_RunFunction('DonateCC')
			If Not $g_bRunState Then Return
			If $g_bRestart Then ExitLoop
			If _Sleep($DELAYIDLE1) Or Not $g_bRunState Then ExitLoop
		EndIf
		If $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then AddIdleTime()
		checkMainScreen(False) ; required here due to many possible exits
		If $g_iCommandStop = -1 Then
			If ScriptRotationIsActive() Or $g_iActualTrainSkip < $g_iMaxTrainSkip Then
				If ScriptRotationIsActive() Or (Not ScriptRotationIsActive() And CheckNeedOpenTrain($g_sTimeBeforeTrain)) Then TrainSystem()
				HeroStatus()
				If $g_bRestart = True Then ExitLoop
				If _Sleep($DELAYIDLE1) Then ExitLoop
				checkMainScreen(False)
				$g_iActualTrainSkip = $g_iActualTrainSkip + 1
			Else
				SetLog("Humanize bot, prevent to delete and recreate troops " & $g_iActualTrainSkip + 1 & "/" & $g_iMaxTrainSkip, $color_blue)
				If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
					$g_iActualTrainSkip = 0
				EndIf
				CheckArmyCamp(True, True)
			EndIf
		EndIf
		If _Sleep($DELAYIDLE1) Then Return
		If $g_iCommandStop = 0 And $g_bTrainEnabled Then
			If Not ($g_bIsFullArmywithHeroesAndSpells) Then
				If ScriptRotationIsActive() Or $g_iActualTrainSkip < $g_iMaxTrainSkip Then
					If ScriptRotationIsActive() Or (Not ScriptRotationIsActive() And (CheckNeedOpenTrain($g_sTimeBeforeTrain) Or (ProfileSwitchAccountEnabled() And $g_iActiveDonate And $g_bChkDonate))) Then TrainSystem()
					HeroStatus()
					If $g_bRestart Then ExitLoop
					If _Sleep($DELAYIDLE1) Then ExitLoop
					checkMainScreen(False)
					If Not __RunBotCanContinue() Then Return
					$g_iActualTrainSkip = $g_iActualTrainSkip + 1
				Else
					If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
						$g_iActualTrainSkip = 0
					EndIf
					CheckArmyCamp(True, True)
					If Not $g_bRunState Then Return
				EndIf
			EndIf
			If $g_bIsFullArmywithHeroesAndSpells And $g_bTrainEnabled Then
				SetLog("Army Camp is full, stop training", $COLOR_ACTION)
				$g_iCommandStop = 3
			EndIf
		EndIf
		If _Sleep($DELAYIDLE1) Then Return
		If $g_bRestart Then ExitLoop

		$TimeIdle += Round(__TimerDiff($hTimer) / 1000, 2) ;In Seconds
		SetLog("Time Idle: " & StringFormat("%02i", Floor(Floor($TimeIdle / 60) / 60)) & ":" & StringFormat("%02i", Floor(Mod(Floor($TimeIdle / 60), 60))) & ":" & StringFormat("%02i", Floor(Mod($TimeIdle, 60))))

		If $g_bOutOfGold Or $g_bOutOfElixir Then Return ; Halt mode due low resources, only 1 idle loop

		If SmartPause() Then ExitLoop
		If ProfileSwitchAccountEnabled() Then
			If checkSwitchAcc() Then ExitLoop
		EndIf

		If ($g_iCommandStop = 3 Or $g_iCommandStop = 0) And $g_bTrainEnabled = False Then ExitLoop ; If training is not enabled, run only 1 idle loop

		If $g_iCommandStop = -1 Then ; Check if closing bot/emulator while training and not in halt mode
			If Not $g_bRunState Then Return
			If $g_bRestart Then ExitLoop ; if smart wait activated, exit to runbot in case user adjusted GUI or left emulator/bot in bad state
		EndIf
	WEnd
EndFunc   ;==>_Idle

Func AttackMain($bAllowEmptyCastle = False) ;Main control for attack functions
	Local $Result = __AttackMain($bAllowEmptyCastle)
	CleanSuperchargeTemplates()
	Return $Result
EndFunc   ;==>AttackMain

Func __AttackMain($bAllowEmptyCastle = False)
	If Not IsSearchAttackEnabled() Then
		If Not $g_bRunState Or $g_bRestart Then Return
		_RunFunction('DonateCC,Train')
		If Not __RunBotCanContinue() Then Return
		_RunFunction('HeroStatus')
		Return
	EndIf
	If Not $g_bRunState Or $g_bRestart Then Return
	If Not $bAllowEmptyCastle And Not $g_bRushAttackRunning And $g_bSearchCastleWaitEnable Then
		If Not IsFullClanCastle(False) Then
			$g_bIsFullArmywithHeroesAndSpells = False
			$g_bWaitForCCTroopSpell = True
			Return False
		EndIf
	EndIf
	If Not __RunBotCanContinue() Then Return False
	ClearScreen()
		If IsSearchModeActive($DB) Or IsSearchModeActive($LB) Then
			If Not $g_bRushAttackRunning And SmartPause() Then Return
			If Not $g_bRushAttackRunning And ProfileSwitchAccountEnabled() And ($g_aiAttackedCountSwitch[$g_iCurAccount] <= $g_aiAttackedCount - Number($g_iCmbMaxInARow + 1)) Then
				If checkSwitchAcc() Then Return
			EndIf
			If Not $g_bRushAttackRunning And $g_bUseCCBalanced Then ;launch profilereport() only if option balance D/R is activated
				ProfileReport()
				If Not $g_bRunState Then Return
				If _Sleep($DELAYATTACKMAIN1) Then Return
				checkMainScreen(False)
				If $g_bRestart Then Return
			EndIf
			While Not $g_bRushAttackRunning And $g_bIsBBevent
				If SwitchForCGEvent() Then
					BuilderBase()
					If Not $g_bRunState Or $g_bRestart Or $g_bBotPaused Then Return
				Else
					ExitLoop
				EndIf
			WEnd

			ClearScreen()
			If Not PrepareSearch($g_iMatchMode, $g_bRushAttackRunning) Then Return
			If Not $g_bRunState Then Return
			If $g_bOutOfGold Then Return ; Check flag for enough gold to search
			If $g_bRestart Then
				Return
			EndIf
			If Not VillageSearch() Then
				Return
			EndIf
			If $g_bOutOfGold Then Return ; Check flag for enough gold to search
			If Not $g_bRunState Then Return
			If $g_bRestart Then
				Return
			EndIf
			PrepareAttack($g_iMatchMode)
			If Not $g_bRunState Then Return
			If $g_bRestart Then
				Return
			EndIf
			Attack()
			If Not $g_bRunState Then Return
			If $g_bRestart Then
				Return
			EndIf
			ReturnHome($g_bTakeLootSnapShot)
			If Not $g_bRunState Then Return
			If $g_bAttackPerformed Then
				_RequestCC_WaitFallback(True)
				ScriptRotationRegisterCompletedAttack()
			EndIf
			If _Sleep($DELAYATTACKMAIN2) Then Return
			Return True
		Else
			SetLog("None of the search conditions match:", $COLOR_DEBUG)
			SetLog("Search count or Army Camp % is out of range in search settings", $COLOR_DEBUG)
			$g_bIsSearchLimit = False
			$g_bIsClientSyncError = False
			If ProfileSwitchAccountEnabled() Then
				If checkSwitchAcc() Then Return
			EndIf
			If SmartPause() Then Return
			If Not $g_bRunState Then Return
		EndIf
EndFunc   ;==>__AttackMain

Func Attack() ;Selects which algorithm
	$g_bAttackPerformed = False
	$g_bScriptRotationPhaseChanged = False
	$g_bAttackActive = True
	Local $Result = __Attack()
	$g_bAttackActive = False
	Return $Result
EndFunc   ;==>Attack

Func __Attack()
	SetLog("» START ATTACK «", $COLOR_ACTION)

	If GetEffectiveAttackAlgorithm($g_iMatchMode) = 1 Then
		If $g_bDebugSetLog Then SetDebugLog("Start Scripted Attack", $COLOR_ERROR)
		Algorithm_AttackCSV()
	ElseIf $g_iMatchMode = $DB And GetEffectiveAttackAlgorithm($DB) = 2 Then
		If $g_bDebugSetLog Then SetDebugLog("Start SmartFarm Attack", $COLOR_ERROR)
		; Variable to return : $Return[3]  [0] = To attack InSide  [1] = Quant. Sides  [2] = Name Sides
		Local $Nside = ChkSmartFarm()
		If Not $g_bRunState Then Return
		NormalizeSmartFarmPlan($Nside)
		AttackSmartFarm($Nside[1], $Nside[2])
	Else
		If $g_bDebugSetLog Then SetDebugLog("Start Standard Attack", $COLOR_ERROR)
		algorithm_AllTroops()
	EndIf
	$g_bAttackPerformed = True
EndFunc   ;==>__Attack

Func _RunFunction($action)
	FuncEnter(_RunFunction)
	If Not __RunBotCanContinue() Then Return FuncReturn()
	; ensure that builder base flag is false
	$g_bStayOnBuilderBase = False
	Local $Result = __RunFunction($action)
	; ensure that builder base flag is false
	$g_bStayOnBuilderBase = False
	Return FuncReturn($Result)
EndFunc   ;==>_RunFunction

Func __RunFunction($action)
	SetDebugLog("_RunFunction: " & $action & " BEGIN", $COLOR_DEBUG2)
	Local $Result
	Switch $action
		Case "Collect"
			Collect()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "CheckTombs"
			CheckTombs()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "CleanYard"
			CleanYard()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "ReplayShare"
			ReplayShare($g_bShareAttackEnableNow)
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "NotifyReport"
			NotifyReport()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "DonateCC"
			If $g_iActiveDonate And $g_bChkDonate Then
				If BalanceDonRec(True) Then DonateCC()
				If Not __RunBotCanContinue() Then Return
				If _Sleep(50) = False Then checkMainScreen(False)
			EndIf

		Case "DonateCC,Train"
			If $g_iActiveDonate And $g_bChkDonate Then
				If BalanceDonRec(True) Then DonateCC()
			EndIf
			If Not __RunBotCanContinue() Then Return
			If Not _Sleep(50) Then checkMainScreen(False)
			If Not __RunBotCanContinue() Then Return
			If $g_bTrainEnabled Then ; check for training enabled in halt mode
				If ScriptRotationIsActive() Then
					If Not ScriptRotationIsRecipeApplied() Then
						TrainSystem()
						If Not __RunBotCanContinue() Then Return
						_Sleep(50)
					EndIf
				ElseIf $g_iActualTrainSkip < $g_iMaxTrainSkip Then
					TrainSystem()
					If Not __RunBotCanContinue() Then Return
					_Sleep(50)
				Else
					SetLog("Humanize bot, prevent to delete and recreate troops " & $g_iActualTrainSkip + 1 & "/" & $g_iMaxTrainSkip, $color_blue)
					$g_iActualTrainSkip = $g_iActualTrainSkip + 1
					If $g_iActualTrainSkip >= $g_iMaxTrainSkip Then
						$g_iActualTrainSkip = 0
					EndIf
					CheckOverviewFullArmy(True, False) ; use true parameter to open train overview window
					If Not __RunBotCanContinue() Then Return
					If _Sleep(50) Then Return
					getArmySpells()
					If Not __RunBotCanContinue() Then Return
					If _Sleep(50) Then Return
					CloseWindow()
				EndIf
			Else
				If $g_bDebugSetlogTrain Then SetLog("Halt mode - training disabled", $COLOR_DEBUG)
			EndIf

		Case "DailyChallenge"
			DailyChallenges()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "RequestCC"
			RequestCC()
			If Not __RunBotCanContinue() Then Return
			If Not _Sleep(50) Then checkMainScreen(False)

		Case "Laboratory"
			Laboratory()
			If Not __RunBotCanContinue() Then Return
			If Not _Sleep(50) Then checkMainScreen(False)

		Case "PetHouse"
			PetHouse()
			If Not __RunBotCanContinue() Then Return
			If Not _Sleep(50) Then checkMainScreen(False)

		Case "HeroStatus"
			HeroStatus()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "HelperHut"
			HelperHut()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "ClanGames"
			_ClanGames()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "TakeWardenValues"
			TakeWardenValues()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "UpgradeHeroes"
			UpgradeHeroes()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "UpgradeBuilding"
			UpgradeBuilding()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "AutoUpgrade"
			AutoUpgrade()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "UpgradeWall"
			$g_iNbrOfWallsUpped = 0
			If UpgradeWallResourcesReady() Then UpgradeWall(True)
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "BuilderBaseMaintenance"
			If __BuilderBaseCycleEnabled() Then $Result = BuilderBase(False, False)
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "CollectAchievements"
			CollectAchievements()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "CollectFreeMagicItems"
			CollectFreeMagicItems()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "ForgeClanCapitalGold"
			ForgeClanCapitalGold()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "AutoUpgradeCC"
			AutoUpgradeCC()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case "CollectCCGold"
			CollectCCGold()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case ""
			SetDebugLog("Function call doesn't support empty string, please review array size", $COLOR_ERROR)

		Case "Blacksmith"
			Blacksmith()
			If Not __RunBotCanContinue() Then Return
			If _Sleep(50) Then Return

		Case Else
			SetLog("Unknown function call: " & $action, $COLOR_ERROR)
	EndSwitch

	SetDebugLog("_RunFunction: " & $action & " END", $COLOR_DEBUG2)
	Return $Result
EndFunc   ;==>__RunFunction

Func FirstCheck()
	If Not $g_bRunState Then Return

	$g_bRestart = False
	$g_bFullArmy = False
	$g_iCommandStop = -1

	If Not $g_bRunState Then Return
	If _Sleep(50) Then Return

	checkMainScreen(False)
	If $g_bRestart Then Return

	VillageReport()
	If Not $g_bRunState Then Return

	If $g_bOutOfGold And (Number($g_aiCurrentLoot[$eLootGold]) >= Number($g_iTxtRestartGold)) Then ; check if enough gold to begin searching again
		$g_bOutOfGold = False ; reset out of gold flag
		SetLog("Switching back to normal after no gold to search", $COLOR_SUCCESS)
		Return ; Restart bot loop to reset $g_iCommandStop & $g_bTrainEnabled + $g_bDonationEnabled via BotCommand()
	EndIf

	If $g_bOutOfElixir And (Number($g_aiCurrentLoot[$eLootElixir]) >= Number($g_iTxtRestartElixir)) And (Number($g_aiCurrentLoot[$eLootDarkElixir]) >= Number($g_iTxtRestartDark)) Then ; check if enough elixir to begin searching again
		$g_bOutOfElixir = False ; reset out of elixir flag
		SetLog("Switching back to normal setting after no elixir to train", $COLOR_SUCCESS)
		Return ; Restart bot loop to reset $g_iCommandStop & $g_bTrainEnabled + $g_bDonationEnabled via BotCommand()
	EndIf

	If BotCommand() Then btnStop()
	If $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then
		; VERIFY THE TROOPS AND ATTACK IF IS FULL
		TrainSystem()
		If Not $g_bRunState Then Return
		If _Sleep(50) Then Return

		HeroStatus()
		If Not $g_bRunState Then Return
		If _Sleep(50) Then Return

		SetDebugLog("Are You Ready? " & String($g_bIsFullArmywithHeroesAndSpells))
		If $g_bIsFullArmywithHeroesAndSpells Then
			; Just in case of new profile! or BotDetectFirstTime() failed on Initiate()
			If Not isInsideDiamond($g_aiTownHallPos) Then BotDetectFirstTime()

			; Now the bot can attack
			If $g_iCommandStop <> 0 And $g_iCommandStop <> 3 Then
				If Not $g_bRunState Then Return
				If SmartPause() Then Return
				AttackCycle(True) ; True for Initial Cycle
				If Not $g_bRunState Then Return
				If _Sleep(50) Then Return
			EndIf
		EndIf
	EndIf
EndFunc   ;==>FirstCheck

Func BuilderBase($bTest = False, $bCheckClanGamesOnReturn = True)
	Local $Result = __BuilderBase($bTest, $bCheckClanGamesOnReturn)
	If Not $Result And $g_bRunState And Not $g_bRestart And Not $g_bBotPaused And isOnBuilderBase(True) Then SwitchBetweenBases(True, False)
	; Prevent Builder Base state from leaking into Main Village.
	$g_bStayOnBuilderBase = False
	Return $Result
EndFunc   ;==>BuilderBase

Func __BuilderBase($bTest = False, $bCheckClanGamesOnReturn = True)
	; switch to builderbase and check it is builderbase
	If SwitchBetweenBases(True, True) And isOnBuilderBase() Then
		$g_bStayOnBuilderBase = True
		If Not __RunBotStepReady() Then Return False

		BuilderBaseReport()
		If Not __RunBotStepReady() Then Return False

		CollectBuilderBase()
		If Not __RunBotStepReady() Then Return False

		If Not RunBuilderBaseUpgrades() Then Return False

		; === DONATION HANDLING ===
		If $g_bChkDonate Then
			DonateCC()
			If Not $g_bRunState Then Return False
			If _Sleep(500) Then Return False
		EndIf
		
		ClockTowerBoost()
		If Not __RunBotStepReady() Then Return False

		CleanBBYard()
		If Not __RunBotStepReady() Then Return False

		AttackBB()
		If Not __RunBotStepReady() Then Return False

		; === DONATION HANDLING ===
		If $g_bChkDonate Then
			DonateCC()
			If Not $g_bRunState Then Return False
			If _Sleep(500) Then Return False
		EndIf

		CollectBuilderBase(False, False, False)
		If Not __RunBotStepReady() Then Return False

		BuilderBaseReport(True, True)
		If Not __RunBotStepReady() Then Return False

		; Switch back to normal village
		If Not SwitchBetweenBases(True, False) Then Return False
		If Not isOnMainVillage(True) Then Return False

		If Not __RunBotStepReady(Random(1500, 2000)) Then Return False
		If $bCheckClanGamesOnReturn Then
			_ClanGames()
			If Not __RunBotCanContinue() Then Return False
		EndIf
		Return True
	EndIf
	Return False
EndFunc   ;==>__BuilderBase

Func __BuilderBaseCycleEnabled()
	Return $g_bChkCollectBuilderBase Or $g_bChkStartClockTowerBoost Or $g_bAutoStarLabUpgradeEnable Or $g_bChkCleanBBYard Or $g_bChkEnableBBAttack Or $g_bAutoUpgradeBBEnabled Or $g_bAutoStarUpgradeBBEnabled Or _
			$g_bDoubleCannonUpgrade Or $g_bArcherTowerUpgrade Or $g_bMultiMortarUpgrade Or $g_bAnyDefUpgrade Or $g_bBattleMachineUpgrade Or $g_bBattlecopterUpgrade
EndFunc   ;==>__BuilderBaseCycleEnabled

Func __ShouldRunBuilderBaseCycle()
	If Not __BuilderBaseCycleEnabled() Then Return False
	If $g_iCommandStop <> 0 Then Return True

	Switch $g_iCmbBotCond
		Case 0 To 3, 7 ; All Storages/Gold/Elixir/Dark Full, or Only Stay Online.
			Return True
	EndSwitch

	Return False
EndFunc   ;==>__ShouldRunBuilderBaseCycle
