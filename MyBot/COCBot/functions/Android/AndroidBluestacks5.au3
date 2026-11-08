; #FUNCTION# ====================================================================================================================
; Name ..........: OpenBlueStacks5
; Description ...:
; Syntax ........: OpenBlueStacks5([$bRestart = False])
; Parameters ....: $bRestart            - [optional] a boolean value. Default is False.
; Return values .: None
; Author ........: xbebenk (2020)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func DoubleQuote($sString)
	Return Chr(34) & $sString & Chr(34)
EndFunc   ;==>DoubleQuote

Func GetBlueStacks5ProgramParameter($bAlternative = False)
	Return DoubleQuote("--instance") & " " & DoubleQuote($g_sAndroidInstance)
EndFunc   ;==>GetBlueStacks5ProgramParameter

Func IsBlueStacks5CommandLine($sCommandLine)
	Local $sInstanceParameter = "--instance " & $g_sAndroidInstance
	Local $iInstancePos = StringInStr($sCommandLine, $sInstanceParameter)
	If $iInstancePos = 0 Then Return False

	Local $iNextCharPos = $iInstancePos + StringLen($sInstanceParameter)
	If $iNextCharPos > StringLen($sCommandLine) Then Return True
	Return StringIsSpace(StringMid($sCommandLine, $iNextCharPos, 1))
EndFunc   ;==>IsBlueStacks5CommandLine

Func OpenBlueStacks5($bRestart = False)
	SetLog("Starting BlueStacks and Clash of Clans", $COLOR_SUCCESS)
	If Not InitAndroid() Then Return False
	; open newer BlueStacks versions 5
	Return _OpenBlueStacks5($bRestart)
EndFunc   ;==>OpenBlueStacks5

Func _OpenBlueStacks5($bRestart = False)

	Local $hTimer, $cmdPar
	Local $PID, $process_killed

	; always start ADB first to avoid ADB connection problems
	LaunchConsole($g_sAndroidAdbPath, AddSpace($g_sAndroidAdbGlobalOptions) & "start-server", $process_killed)

	$cmdPar = GetAndroidProgramParameter()
	If WinGetAndroidHandle() = 0 Then
		; HD-Player can replace its initial process with a new "--restarted" process.
		; Continue with the normal window wait even when the original PID exits.
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath, Default, False)
	Else
		SetLog("BlueStacks5 already loaded", $COLOR_SUCCESS)
	EndIf

	$hTimer = __TimerInit() ; start a timer for tracking BS start up time
	While $g_hAndroidControl = 0
		If Not $g_bRunState Then Return False
		_StatusUpdateTime($hTimer, $g_sAndroidEmulator & " Starting")
		If __TimerDiff($hTimer) > $g_iAndroidLaunchWaitSec * 1000 Then ; if no BS position is returned before the configured timeout, exit
			SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
			SetLog("BlueStacks refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds", $COLOR_ERROR)
			SetLog("Unable to continue...", $COLOR_WARNING)
			btnstop()
			SetError(1, 1, -1)
			Return False
		EndIf
		WinGetAndroidHandle()
	WEnd

	If $g_hAndroidControl Then
		ConnectAndroidAdb(False, False, 3000)
		If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec, $hTimer) Then Return False
		If Not $g_bRunState Then Return False
		SetLog("BlueStacks loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin", $COLOR_SUCCESS)
		Return True
	EndIf
	Return False
EndFunc   ;==>_OpenBlueStacks5

Func GetBlueStacks5AdbPath()
	Local $adbPath = $__BlueStacks_Path & "HD-Adb.exe"
	If FileExists($adbPath) Then Return $adbPath
	Return ""
EndFunc   ;==>GetBlueStacks5AdbPath

Func InitBlueStacks5X($bCheckOnly = False, $bAdjustResolution = False, $bLegacyMode = False)
	;Bluestacks5 doesn't have registry tree for engine, only installation dir info available on registry
	$__BlueStacks5_Version = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "Version")
	$__BlueStacks_Path = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "InstallDir")
	$__BlueStacks_Path = StringReplace($__BlueStacks_Path, "\\", "\")

	Local $frontend_exe = ["HD-Frontend.exe", "HD-Player.exe"]
	Local $i, $aFiles = [$frontend_exe, "HD-Adb.exe"]

	For $i = 0 To UBound($aFiles) - 1
		Local $File
		Local $bFileFound = False
		Local $aFiles2 = $aFiles[$i]
		If Not IsArray($aFiles2) Then Local $aFiles2 = [$aFiles[$i]]
		For $j = 0 To UBound($aFiles2) - 1
			$File = $__BlueStacks_Path & $aFiles2[$j]
			$bFileFound = FileExists($File)
			If $bFileFound Then
				; check if $frontend_exe is array, then convert
				If $i = 0 And IsArray($frontend_exe) Then $frontend_exe = $aFiles2[$j]
				ExitLoop
			EndIf
		Next
		If Not $bFileFound Then
			If Not $bCheckOnly Then
				SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
				SetLog($File, $COLOR_ERROR)
				SetError(1, @extended, False)
			EndIf
			Return False
		EndIf
	Next
	Local $sPreferredADB = FindPreferredAdbPath()

	If Not $bCheckOnly Then
		; update global variables
		$g_sAndroidPath = $__BlueStacks_Path
		$g_sAndroidProgramPath = $__BlueStacks_Path & $frontend_exe
		$g_sAndroidAdbPath = $sPreferredADB
		$g_sAndroidVersion = $__BlueStacks5_Version
		If Not ConfigureSharedFolderBlueStacks5(0, False) Then
			ConfigureSharedFolderBlueStacks5(1, False)
			If Not ConfigureSharedFolderBlueStacks5(0, False) Then _
				SetLog("BlueStacks5 shared folder is not available; ADB capture may be disabled", $COLOR_WARNING)
		EndIf
		WinGetAndroidHandle()
	EndIf

	Return True
EndFunc   ;==>InitBlueStacks5X

Func ConfigureSharedFolderBlueStacks5($iMode = 0, $bSetLog = Default)
	If $bSetLog = Default Then $bSetLog = True
	Local $bResult = False
	Local $__BlueStacks5_ProgramData = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "UserDefinedDir")
	Local $bNativeSharedFolderConfigured = IsBlueStacks5NativeSharedFolderConfigured($__BlueStacks5_ProgramData)
	$g_sAndroidPicturesPath = "/mnt/windows/BstSharedFolder/"
	If $__BlueStacks5_ProgramData <> "" And FileExists($__BlueStacks5_ProgramData) Then
		$g_sAndroidPicturesHostPath = $__BlueStacks5_ProgramData & "\Engine\UserData\SharedFolder\"
	Else
		$g_sAndroidPicturesHostPath = ""
	EndIf

	Switch $iMode
		Case 0 ; check the native host folder and BlueStacks shared-folder registration
			$bResult = $bNativeSharedFolderConfigured And FileExists($g_sAndroidPicturesHostPath)
		Case 1 ; create the native host folder; registration is applied with the display configuration
			If $g_sAndroidPicturesHostPath <> "" And Not FileExists($g_sAndroidPicturesHostPath) Then DirCreate($g_sAndroidPicturesHostPath)
			$bResult = FileExists($g_sAndroidPicturesHostPath)
			If $bSetLog And $bResult Then SetLog("BlueStacks5 native shared host folder is available", $COLOR_SUCCESS)
			If $bSetLog And Not $bResult Then SetLog("BlueStacks5 native shared host folder is not available", $COLOR_WARNING)
		Case 2 ; register the native shared folder while BlueStacks is closed
			Local $__Bluestacks5Conf = FileReadToArray($__BlueStacks5_ProgramData & "\bluestacks.conf")
			If FileExists($g_sAndroidPicturesHostPath) And IsArray($__Bluestacks5Conf) And EnsureBlueStacks5NativeSharedFolderConfigured($__Bluestacks5Conf) Then
				$bResult = _FileWriteFromArray($__BlueStacks5_ProgramData & "\bluestacks.conf", $__Bluestacks5Conf) <> 0
			EndIf
			If $bSetLog And Not $bResult Then SetLog("Unable to register BlueStacks5 native shared folder", $COLOR_WARNING)
	EndSwitch

	; Registration changes require a restart; preflight availability needs both host folder and registration.
	$g_bAndroidSharedFolderAvailable = $iMode <> 2 And $bNativeSharedFolderConfigured And FileExists($g_sAndroidPicturesHostPath)
	SetDebugLog("g_sAndroidPicturesHostPath = " & $g_sAndroidPicturesHostPath)
	SetDebugLog("g_sAndroidPicturesPath = " & $g_sAndroidPicturesPath)
	Return SetError(0, 0, $bResult)
EndFunc   ;==>ConfigureSharedFolderBlueStacks5

Func IsBlueStacks5NativeSharedFolderConfigured($__BlueStacks5_ProgramData)
	If $__BlueStacks5_ProgramData = "" Or Not FileExists($__BlueStacks5_ProgramData) Then Return False
	Local $__Bluestacks5Conf = FileReadToArray($__BlueStacks5_ProgramData & "\bluestacks.conf")
	If Not IsArray($__Bluestacks5Conf) Then Return False
	Local $sKey = "bst.shared_folders="
	For $i = 0 To UBound($__Bluestacks5Conf) - 1
		If StringLeft($__Bluestacks5Conf[$i], StringLen($sKey)) <> $sKey Then ContinueLoop
		Return BlueStacks5SharedFoldersContainNative($__Bluestacks5Conf[$i])
	Next
	Return False
EndFunc   ;==>IsBlueStacks5NativeSharedFolderConfigured

Func BlueStacks5SharedFoldersContainNative($sConfigLine)
	Local $sKey = "bst.shared_folders="
	Local $aSharedFolders = StringSplit(StringReplace(StringTrimLeft($sConfigLine, StringLen($sKey)), '"', ''), ",", $STR_NOCOUNT)
	For $sSharedFolder In $aSharedFolders
		If StringStripWS($sSharedFolder, $STR_STRIPALL) = "BstSharedFolder" Then Return True
	Next
	Return False
EndFunc   ;==>BlueStacks5SharedFoldersContainNative

Func EnsureBlueStacks5NativeSharedFolderConfigured(ByRef $__Bluestacks5Conf)
	If Not IsArray($__Bluestacks5Conf) Then Return False
	Local $sKey = "bst.shared_folders="
	For $i = 0 To UBound($__Bluestacks5Conf) - 1
		If StringLeft($__Bluestacks5Conf[$i], StringLen($sKey)) <> $sKey Then ContinueLoop
		If BlueStacks5SharedFoldersContainNative($__Bluestacks5Conf[$i]) Then Return True
		Local $sSharedFolders = StringStripWS(StringReplace(StringTrimLeft($__Bluestacks5Conf[$i], StringLen($sKey)), '"', ''), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
		If $sSharedFolders <> "" Then $sSharedFolders &= ","
		$__Bluestacks5Conf[$i] = $sKey & '"' & $sSharedFolders & 'BstSharedFolder"'
		Return True
	Next
	Local $iAppend = UBound($__Bluestacks5Conf)
	ReDim $__Bluestacks5Conf[$iAppend + 1]
	$__Bluestacks5Conf[$iAppend] = $sKey & '"BstSharedFolder"'
	Return True
EndFunc   ;==>EnsureBlueStacks5NativeSharedFolderConfigured

Func InitBlueStacks5($bCheckOnly = False)
	Local $bInstalled = InitBlueStacks5X($bCheckOnly, True)
	If Not $bInstalled Then Return False
	If $bInstalled And StringInStr($__BlueStacks5_Version, "5.") <> 1 Then
		SetLog("BlueStacks 5 supported version 5.x not found", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	Local $__BlueStacks5_ProgramData = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "UserDefinedDir")
	Local $__Bluestacks5Conf = FileReadToArray($__BlueStacks5_ProgramData & "\bluestacks.conf")
	If Not IsArray($__Bluestacks5Conf) Then
		If Not $bCheckOnly Then SetLog("Unable to read BlueStacks5 configuration", $COLOR_ERROR)
		Return False
	EndIf
	Local $bAdbPortFound = False

	For $i = 0 To UBound($__Bluestacks5Conf) - 1
		If StringInStr($__Bluestacks5Conf[$i], "bst.instance." & $g_sAndroidInstance & ".") Then
			Local $propkey = StringReplace($__Bluestacks5Conf[$i], "bst.instance." & $g_sAndroidInstance & ".", "")
			SetDebugLog($propkey)
			Local $aProperty = StringSplit($propkey, "=", $STR_NOCOUNT)
			If IsArray($aProperty) And UBound($aProperty) = 2 Then
				If $aProperty[0] = "adb_port" Then
					Local $port = StringReplace($aProperty[1], '"', '')
					If StringIsDigit($port) Then
						$g_sAndroidAdbDevice = "127.0.0.1:" & $port
						$bAdbPortFound = True
					EndIf
				EndIf
			EndIf
		EndIf
	Next
	If Not $bAdbPortFound Then
		If Not $bCheckOnly Then SetLog("Unable to find BlueStacks5 ADB port for instance " & $g_sAndroidInstance, $COLOR_ERROR)
		Return False
	EndIf

	If $bInstalled And Not $bCheckOnly Then
		$__VBoxManage_Path = $__BlueStacks_Path & "BstkVMMgr.exe"
		Local $bsNow = GetVersionNormalized($__BlueStacks5_Version)
		If $bsNow > GetVersionNormalized("5.0") Then
			If $bsNow >= GetVersionNormalized("5.22.250") Then
				$g_sAndroidAdbShellOptions = ""
			Else
				$g_sAndroidAdbShellOptions = " /data/anr/../../system/xbin/bstk/su root"
			EndIf

			; tcp forward not working in BS4
			$g_iAndroidAdbMinitouchMode = 1
		EndIf
	EndIf

	Return $bInstalled
EndFunc   ;==>InitBlueStacks5

Func GetBlueStacks5BackgroundMode()
	#cs
		If 9600 <= @OSBuild Then
			Return $g_iAndroidBackgroundModeDirectX
		Else
	#ce
	; check if BlueStacks 5 is running in OpenGL mode
	Local $__BlueStacks5_ProgramData = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "UserDefinedDir")
	Local $__Bluestacks5Conf = FileReadToArray($__BlueStacks5_ProgramData & "\bluestacks.conf")
	Local $GlRenderMode = "dx"
	If IsArray($__Bluestacks5Conf) Then
		For $i = 0 To UBound($__Bluestacks5Conf) - 1
			If StringInStr($__Bluestacks5Conf[$i], "bst.instance." & $g_sAndroidInstance & ".graphics_renderer=") Then
				Local $aRenderMode = StringRegExp($__Bluestacks5Conf[$i], '=\"(.+)\"', $STR_REGEXPARRAYMATCH)
				If IsArray($aRenderMode) Then $GlRenderMode = $aRenderMode[0]
				ExitLoop
			EndIf
		Next
	EndIf

	SetDebugLog("GlRenderMode = " & $GlRenderMode)
	Switch StringLower($GlRenderMode)
		Case "dx"
			Return $g_iAndroidBackgroundModeDirectX
		Case "gl", "vlcn", "vulkan"
			Return $g_iAndroidBackgroundModeOpenGL
		Case Else
			SetLog($g_sAndroidEmulator & " unsupported render mode " & $GlRenderMode, $COLOR_WARNING)
			Return 0
	EndSwitch
	;EndIf
EndFunc   ;==>GetBlueStacks5BackgroundMode

Func RestartBlueStacks5CoC()
	If Not $g_bRunState Then Return False
	Local $cmdOutput
	If Not InitAndroid() Then Return False
	If WinGetAndroidHandle() = 0 Then Return False
	$cmdOutput = AndroidAdbSendShellCommand("am start -W -n " & $g_sAndroidGamePackage & "/" & $g_sAndroidGameClass, 60000) ; timeout of 1 Minute ; disabled -S due to long wait after 2017 Dec. Update
	SetLog("Restarting Game Instance", $COLOR_ACTION)
	Return True
EndFunc   ;==>RestartBlueStacks5CoC

Global $g_iBlueStacks5Dpi = 160

Func CheckScreenBlueStacks5($bSetLog = True)
	Local $__BlueStacks5_ProgramData = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "UserDefinedDir")
	Local $sConfigPath = $__BlueStacks5_ProgramData & "\bluestacks.conf"
	Local $__Bluestacks5Conf = FileReadToArray($sConfigPath)
	If Not IsArray($__Bluestacks5Conf) Then
		If $bSetLog Then SetLog("Unable to read BlueStacks5 configuration", $COLOR_ERROR)
		Return False
	EndIf

	Local $aiSearch = ["bst.instance." & $g_sAndroidInstance & ".fb_width=", _
			"bst.instance." & $g_sAndroidInstance & ".fb_height=", _
			"bst.instance." & $g_sAndroidInstance & ".dpi=", _
			"bst.instance." & $g_sAndroidInstance & ".gl_win_height=", _
			"bst.instance." & $g_sAndroidInstance & ".display_name=", _
			"bst.instance." & $g_sAndroidInstance & ".show_sidebar=", _
			"bst.instance." & $g_sAndroidInstance & ".google_login_popup_shown=", _
			"bst.enable_adb_access="]

	Local $aiMustBe = ['bst.instance.' & $g_sAndroidInstance & '.fb_width="' & $g_iAndroidClientWidth & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.fb_height="' & $g_iAndroidClientHeight & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.dpi="' & $g_iBlueStacks5Dpi & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.gl_win_height="' & $g_iAndroidClientHeight & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.display_name="BlueStacks5-' & $g_sAndroidInstance & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.show_sidebar="0"', _
			"bst.instance." & $g_sAndroidInstance & '.google_login_popup_shown="0"', _
			'bst.enable_adb_access="1"']

	For $iSearch = 0 To UBound($aiSearch) - 1
		Local $bFound = False
		For $i = 0 To UBound($__Bluestacks5Conf) - 1
			If StringInStr($__Bluestacks5Conf[$i], $aiSearch[$iSearch]) Then
				$bFound = True
				SetDebugLog($__Bluestacks5Conf[$i])
				If StringInStr($__Bluestacks5Conf[$i], $aiMustBe[$iSearch]) = 0 Then
					If $bSetLog = True Then SetLog("Please wait, Bot will configure your Bluestacks5", $COLOR_ERROR)
					Return False
				EndIf
				ExitLoop
			EndIf
		Next
		If Not $bFound Then
			If $bSetLog Then SetLog("BlueStacks5 configuration is incomplete; applying display settings", $COLOR_ACTION)
			Return False
		EndIf
	Next
	Return True
EndFunc   ;==>CheckScreenBlueStacks5

Func SetScreenBlueStacks5()
	Local $__BlueStacks5_ProgramData = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks_nxt\", "UserDefinedDir")
	Local $sConfigPath = $__BlueStacks5_ProgramData & "\bluestacks.conf"
	Local $__Bluestacks5Conf = FileReadToArray($sConfigPath)
	If Not IsArray($__Bluestacks5Conf) Then
		SetLog("Unable to read BlueStacks5 configuration", $COLOR_ERROR)
		Return False
	EndIf
	If Not ConfigureSharedFolderBlueStacks5(1, False) Then
		SetLog("Unable to create BlueStacks5 native shared folder", $COLOR_ERROR)
		Return False
	EndIf

	Local $aiSearch = ["bst.instance." & $g_sAndroidInstance & ".fb_width=", _
			"bst.instance." & $g_sAndroidInstance & ".fb_height=", _
			"bst.instance." & $g_sAndroidInstance & ".dpi=", _
			"bst.instance." & $g_sAndroidInstance & ".gl_win_height=", _
			"bst.instance." & $g_sAndroidInstance & ".display_name=", _
			"bst.instance." & $g_sAndroidInstance & ".show_sidebar=", _
			"bst.instance." & $g_sAndroidInstance & ".google_login_popup_shown=", _
			"bst.enable_adb_access="]

	Local $aiMustBe = ['bst.instance.' & $g_sAndroidInstance & '.fb_width="' & $g_iAndroidClientWidth & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.fb_height="' & $g_iAndroidClientHeight & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.dpi="' & $g_iBlueStacks5Dpi & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.gl_win_height="' & $g_iAndroidClientHeight & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.display_name="BlueStacks5-' & $g_sAndroidInstance & '"', _
			'bst.instance.' & $g_sAndroidInstance & '.show_sidebar="0"', _
			"bst.instance." & $g_sAndroidInstance & '.google_login_popup_shown="0"', _
			'bst.enable_adb_access="1"']

	Local $abFound[UBound($aiSearch)]
	For $i = 0 To UBound($__Bluestacks5Conf) - 1
		For $iSearch = 0 To UBound($aiSearch) - 1
			If StringInStr($__Bluestacks5Conf[$i], $aiSearch[$iSearch]) Then
				$__Bluestacks5Conf[$i] = $aiMustBe[$iSearch]
				$abFound[$iSearch] = True
			EndIf
		Next
	Next
	For $iSearch = 0 To UBound($aiSearch) - 1
		If Not $abFound[$iSearch] Then
			Local $iAppend = UBound($__Bluestacks5Conf)
			ReDim $__Bluestacks5Conf[$iAppend + 1]
			$__Bluestacks5Conf[$iAppend] = $aiMustBe[$iSearch]
		EndIf
	Next
	If Not EnsureBlueStacks5NativeSharedFolderConfigured($__Bluestacks5Conf) Then
		SetLog("Unable to configure BlueStacks5 native shared folder", $COLOR_ERROR)
		Return False
	EndIf

	If _FileWriteFromArray($sConfigPath, $__Bluestacks5Conf) = 0 Then
		SetLog("Unable to update BlueStacks5 configuration", $COLOR_ERROR)
		Return False
	EndIf
	Return True
EndFunc   ;==>SetScreenBlueStacks5

Func ConfigBlueStacks5WindowManager()
	If Not $g_bRunState Then Return
	Local $cmdOutput
	; shell wm density $g_iBlueStacks5Dpi
	; shell wm size 860x732
	; shell reboot

	; Reset Window Manager size
	$cmdOutput = AndroidAdbSendShellCommand("wm size reset", Default, Default, False)

	; Set expected dpi
	$cmdOutput = AndroidAdbSendShellCommand("wm density " & $g_iBlueStacks5Dpi, Default, Default, False)

	; Set font size to normal
	AndroidSetFontSizeNormal()
EndFunc   ;==>ConfigBlueStacks5WindowManager

Func RebootBlueStacks5SetScreen($bOpenAndroid = True)

	If Not InitAndroid() Then Return False

	ConfigBlueStacks5WindowManager()

	; Close Android
	CloseAndroid("RebootBlueStacks5SetScreen")
	If _Sleep(1000) Then Return False

	If Not SetScreenAndroid() Then Return False
	If Not $g_bRunState Then Return False

	If $bOpenAndroid Then
		; Start Android
		Return OpenAndroid(True)
	EndIf

	Return True

EndFunc   ;==>RebootBlueStacks5SetScreen

Func GetBlueStacks5RunningInstance($bStrictCheck = True)
	WinGetAndroidHandle()
	Local $a[2] = [$g_hAndroidWindow, ""]
	If $g_hAndroidWindow <> 0 Then Return $a
	If $bStrictCheck Then Return False
	Local $WinTitleMatchMode = Opt("WinTitleMatchMode", -3) ; in recent 2.3.x can be also "BlueStacks App Player"
	Local $h = WinGetHandle("Bluestacks App Player", "") ; Need fixing as BS2 Emulator can have that title when configured in registry
	If @error = 0 Then
		$a[0] = $h
	EndIf
	Opt("WinTitleMatchMode", $WinTitleMatchMode)
	Return $a
EndFunc   ;==>GetBlueStacks5RunningInstance

Func BlueStacks5BotStartEvent()
	Return AndroidCloseSystemBar()
EndFunc   ;==>BlueStacks5BotStartEvent

Func BlueStacks5BotStopEvent()
	Return AndroidOpenSystemBar()
EndFunc   ;==>BlueStacks5BotStopEvent

Func GetBlueStacks5SvcPid()
	; find process PID
	Local $PID = ProcessExists2("HD-Service.exe")
	Return $PID
EndFunc   ;==>GetBlueStacks5SvcPid

Func CloseBlueStacks5()

	Local $bOops = False

	If Not InitAndroid() Then Return

	If Not CloseUnsupportedBlueStacksX(False) Then
		; BlueStacks 5 supports multiple instance
		Local $aFiles = ["HD-Frontend.exe", "HD-Plus-Service.exe", "HD-Service.exe"]

		Local $bError = False
		For $sFile In $aFiles
			Local $PID
			$PID = ProcessExists2($sFile, $g_sAndroidInstance)
			If $PID Then
				ShellExecute(@WindowsDir & "\System32\taskkill.exe", " -f -t -pid " & $PID, "", Default, @SW_HIDE)
				If _Sleep(1000) Then Return ; Give OS time to work
			EndIf
		Next
		If _Sleep(1000) Then Return ; Give OS time to work
		For $sFile In $aFiles
			Local $PID
			$PID = ProcessExists2($sFile, $g_sAndroidInstance)
			If $PID Then
				SetLog($g_sAndroidEmulator & " failed to kill " & $sFile, $COLOR_ERROR)
			EndIf
		Next

		; also close vm
		CloseVboxAndroidSvc()
	Else
		SetDebugLog("Closing BlueStacks: " & $__BlueStacks_Path & "HD-Quit.exe")
		RunWait($__BlueStacks_Path & "HD-Quit.exe")
		If @error <> 0 Then SetLog($g_sAndroidEmulator & " failed to quit", $COLOR_ERROR)
	EndIf

	If _Sleep(2000) Then Return ; wait a bit

	If $bOops Then
		SetError(1, @extended, -1)
	EndIf

EndFunc   ;==>CloseBlueStacks5

Func BlueStacks5AdjustClickCoordinates(ByRef $x, ByRef $y)
	$x = Round(32767.0 / $g_iAndroidClientWidth * $x)
	$y = Round(32767.0 / $g_iAndroidClientHeight * $y)
EndFunc   ;==>BlueStacks5AdjustClickCoordinates

Func CloseUnsupportedBlueStacksX($bClose = True)
	Local $WinTitleMatchMode = Opt("WinTitleMatchMode", -3) ; in recent 2.3.x can be also "BlueStacks App Player"
	Local $sPartnerExePath = RegRead($g_sHKLM & "\SOFTWARE\BlueStacks\Config\", "PartnerExePath")
	If IsArray(ControlGetPos("Bluestacks App Player", "", "")) Or ($sPartnerExePath And ProcessExists2($sPartnerExePath)) Then ; $g_avAndroidAppConfig[1][4]
		Opt("WinTitleMatchMode", $WinTitleMatchMode)
		; Offical "Bluestacks App Player" v2.0 not supported because it changes the Android Screen!!!
		If $bClose = True Then
			SetLog("MyBot doesn't work with " & $g_sAndroidEmulator & " App Player", $COLOR_ERROR)
			SetLog("Please let MyBot start " & $g_sAndroidEmulator & " automatically", $COLOR_INFO)
			RebootBlueStacks5SetScreen(False)
		EndIf
		Return True
	EndIf
	Opt("WinTitleMatchMode", $WinTitleMatchMode)
	Return False
EndFunc   ;==>CloseUnsupportedBlueStacksX
