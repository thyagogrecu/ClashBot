; #FUNCTION# ====================================================================================================================
; Name ..........: OpenMEmu
; Description ...: Opens new MEmu instance
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Cosote (12-2015)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func OpenMEmu($bRestart = False)

	Local $PID, $hTimer, $iCount = 0, $process_killed, $cmdOutput, $connected_to, $cmdPar
	Local $sMEmuInstance = GetMEmuInstanceName($g_sAndroidInstance, "", True)
	If @error Then Return False
	$g_sAndroidInstance = $sMEmuInstance

	SetLog("Starting " & $g_sAndroidEmulator & " and Clash Of Clans", $COLOR_SUCCESS)

	Local $launchAndroid = (WinGetAndroidHandle() = 0 ? True : False)
	If $launchAndroid Then
		; Launch MEmu
		$cmdPar = GetAndroidProgramParameter()
		$PID = LaunchAndroid($g_sAndroidProgramPath, $cmdPar, $g_sAndroidPath)
		If $PID = 0 Then
			SetError(1, 1, -1)
			Return False
		EndIf
	EndIf

	$hTimer = __TimerInit()

	; Test ADB is connected
	$connected_to = ConnectAndroidAdb(False, False, 60 * 1000)
	If Not $g_bRunState Then Return False

	; Wait for device
	;$cmdOutput = LaunchConsole($g_sAndroidAdbPath, "-s " & $g_sAndroidAdbDevice & " wait-for-device", $process_killed, 60 * 1000)
	;If Not $g_bRunState Then Return

	; Wait for boot completed
	If WaitForAndroidBootCompleted($g_iAndroidLaunchWaitSec - __TimerDiff($hTimer) / 1000, $hTimer) Then Return False

	; Wait for UI Control, then CoC can be launched
	;While Not IsArray(ControlGetPos($g_sAndroidTitle, $g_sAppPaneName, $g_sAppClassInstance)) And __TimerDiff($hTimer) <= $g_iAndroidLaunchWaitSec * 1000
	;  If _Sleep(500) Then Return
	;WEnd

	If __TimerDiff($hTimer) >= $g_iAndroidLaunchWaitSec * 1000 Then ; if it took 4 minutes, Android/PC has major issue so exit
		SetLog("Serious error has occurred, please restart PC and try again", $COLOR_ERROR)
		SetLog($g_sAndroidEmulator & " refuses to load, waited " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds for window", $COLOR_ERROR)
		SetError(1, @extended, False)
		Return False
	EndIf

	SetLog($g_sAndroidEmulator & " Loaded, took " & Round(__TimerDiff($hTimer) / 1000, 2) & " seconds to begin", $COLOR_SUCCESS)

	Return True

EndFunc   ;==>OpenMEmu

Func GetMEmuProgramParameter($bAlternative = False)
	Local $sConfiguredInstance = ($g_sAndroidInstance = "" ? $g_avAndroidAppConfig[$g_iAndroidConfig][1] : $g_sAndroidInstance)
	Local $sMEmuInstance = GetMEmuInstanceName($sConfiguredInstance)
	If @error Then Return $sConfiguredInstance
	$g_sAndroidInstance = $sMEmuInstance

	If Not $bAlternative Or $g_sAndroidInstance <> $g_avAndroidAppConfig[$g_iAndroidConfig][1] Then
		; should be launched with these parameter
		Return $g_sAndroidInstance
	EndIf
	; default instance gets launched when no parameter was specified (this is the alternative way)
	Return ""
EndFunc   ;==>GetMEmuProgramParameter

Func GetMEmuInstanceName($sInstance = "", $sMEmuPath = "", $bSetLog = False)
	If $sInstance = "" Then $sInstance = $g_avAndroidAppConfig[$g_iAndroidConfig][1]
	If $sMEmuPath = "" Then $sMEmuPath = GetMEmuPath()

	Static $sCachedPath = "", $sCachedInstance = "", $sCachedResult = ""
	If StringCompare($sMEmuPath, $sCachedPath, $STR_CASESENSE) = 0 And _
			StringCompare($sInstance, $sCachedInstance, $STR_CASESENSE) = 0 Then Return $sCachedResult

	Local $sVMPath = $sMEmuPath & "MemuHyperv VMs\"
	Local $hSearch = FileFindFirstFile($sVMPath & "*")
	If $hSearch <> -1 Then
		While True
			Local $sRegisteredInstance = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			If StringInStr(FileGetAttrib($sVMPath & $sRegisteredInstance), "D") And _
					FileExists($sVMPath & $sRegisteredInstance & "\" & $sRegisteredInstance & ".memu") And _
					StringCompare($sInstance, $sRegisteredInstance, $STR_NOCASESENSE) = 0 Then
				FileClose($hSearch)
				$sCachedPath = $sMEmuPath
				$sCachedInstance = $sInstance
				$sCachedResult = $sRegisteredInstance
				If StringCompare($sInstance, $sRegisteredInstance, $STR_CASESENSE) <> 0 Then _
						SetDebugLog("Resolved MEmu instance " & $sInstance & " as " & $sRegisteredInstance)
				Return $sRegisteredInstance
			EndIf
		WEnd
		FileClose($hSearch)
	EndIf

	If $bSetLog Then SetLog("MEmu instance not found: " & $sInstance, $COLOR_ERROR)
	Return SetError(1, 0, "")
EndFunc   ;==>GetMEmuInstanceName

Func GetMEmuPath()
	Local $MEmu_Path = EnvGet("MEmu_Path") & "\MEmu\" ;RegRead($g_sHKLM & "\SOFTWARE\MEmu\", "InstallDir") ; Doesn't exist (yet)
	$__MEmu_Version = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayVersion")
	If FileExists($MEmu_Path & "MEmu.exe") = 0 Then ; work-a-round
		Local $InstallLocation = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "InstallLocation")
		If @error = 0 And FileExists($InstallLocation & "\MEmu\MEmu.exe") = 1 Then
			$MEmu_Path = $InstallLocation & "\MEmu\"
		Else
			Local $DisplayIcon = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayIcon")
			If @error = 0 Then
				Local $iLastBS = StringInStr($DisplayIcon, "\", 0, -1)
				$MEmu_Path = StringLeft($DisplayIcon, $iLastBS)
				If StringLeft($MEmu_Path, 1) = """" Then $MEmu_Path = StringMid($MEmu_Path, 2)
			Else
				$MEmu_Path = @ProgramFilesDir & "\Microvirt\MEmu\"
				SetError(0, 0, 0)
			EndIf
		EndIf
	EndIf
	$MEmu_Path = StringReplace($MEmu_Path, "\\", "\")
	Return $MEmu_Path
EndFunc   ;==>GetMEmuPath

Func GetMEmuAdbPath()
	Local $adbPath = GetMEmuPath() & "adb.exe"
	If FileExists($adbPath) Then Return $adbPath
	Return ""
EndFunc   ;==>GetMEmuAdbPath

Func MEmuManageCommandFailed($sOutput, $bAllowNotRunning = False)
	If $bAllowNotRunning And StringInStr($sOutput, "is not currently running") Then Return False
	Return StringInStr($sOutput, "MEmuManage.exe: error:") Or _
			StringInStr($sOutput, "VBoxManage.exe: error:") Or _
			StringInStr($sOutput, "Could not find a registered machine named") Or _
			StringInStr($sOutput, "VBOX_E_") Or StringInStr($sOutput, "MEMU_E_")
EndFunc   ;==>MEmuManageCommandFailed

Func RunMEmuManageChecked($sParameters, $bAllowNotRunning = False)
	Local $process_killed
	Local $sOutput = LaunchConsole($__VBoxManage_Path, $sParameters, $process_killed)
	Local $iLaunchError = @error
	If $iLaunchError Or $process_killed Or MEmuManageCommandFailed($sOutput, $bAllowNotRunning) Then
		SetLog("MEmu configuration command failed: " & $sParameters, $COLOR_ERROR)
		If $sOutput <> "" Then SetDebugLog($sOutput, $COLOR_ERROR)
		Return False
	EndIf
	Return True
EndFunc   ;==>RunMEmuManageChecked

Func SetMEmuLauncherResolution()
	Local $sMEmuConsolePath = GetMEmuPath() & "memuc.exe"
	If Not FileExists($sMEmuConsolePath) Then
		SetDebugLog("MEmu launcher configuration command not found: " & $sMEmuConsolePath)
		Return False
	EndIf

	Local $aValues[4][2] = [ _
			["is_customed_resolution", 1], _
			["resolution_width", $g_iAndroidClientWidth], _
			["resolution_height", $g_iAndroidClientHeight], _
			["vbox_dpi", 160] _
		]
	Local $bSuccess = True
	For $i = 0 To UBound($aValues) - 1
		Local $process_killed
		Local $sParameters = "setconfigex -n """ & $g_sAndroidInstance & """ " & $aValues[$i][0] & " " & $aValues[$i][1]
		Local $sOutput = LaunchConsole($sMEmuConsolePath, $sParameters, $process_killed)
		Local $iLaunchError = @error
		If $iLaunchError Or $process_killed Or StringInStr($sOutput, "ERROR") Or StringInStr($sOutput, "failed") Then
			SetDebugLog("MEmu launcher configuration command unavailable: " & $sParameters)
			If $sOutput <> "" Then SetDebugLog($sOutput)
			$bSuccess = False
		EndIf
	Next
	Return $bSuccess
EndFunc   ;==>SetMEmuLauncherResolution

Func GetMEmuBackgroundMode()

	Local $iDirectX = $g_iAndroidBackgroundModeDirectX
	Local $iOpenGL = $g_iAndroidBackgroundModeOpenGL
	; hack for super strange Windows Fall Creator Update with OpenGL and DirectX problems
	; doesn't have this issue with OSBuild : 17134
	If @OSBuild >= 16299 And @OSBuild < 17134 Then
		SetDebugLog("DirectX/OpenGL Fix applied for Windows Build 16299")
		$iDirectX = $g_iAndroidBackgroundModeOpenGL
		$iOpenGL = $g_iAndroidBackgroundModeDirectX
	EndIf
	; Only OpenGL is supported up to version 3.1.2.5

	; get OpenGL/DirectX config
	Local $aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: graphics_render_mode, value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)
	If @error = 0 Then
		Local $graphics_render_mode = $aRegExResult[0]
		SetDebugLog($g_sAndroidEmulator & " instance " & $g_sAndroidInstance & " rendering mode is " & $graphics_render_mode)
		Switch $graphics_render_mode
			Case "1" ; DirectX
				Return $iDirectX
			Case "2" ; DirectX+ available in version 3.6.7.0
				Return $iDirectX
			Case Else ; fallback to OpenGL
				Return $iOpenGL
		EndSwitch
	EndIf

	; PH MOD (Hyper-V MEmu fix): VBoxManage guestproperty bos donerse (yeni MEmu surumleri
	; Hyper-V kullaniyor, VBoxManage yok) render modunu dogrudan <instance>.memu dosyasindan oku.
	; graphics_render_mode value="1" (DirectX) => WinAPI background => minimize/arka plan shared-folder'siz calisir.
	Local $sMEmuVmConfig = GetMEmuPath() & "MemuHyperv VMs\" & $g_sAndroidInstance & "\" & $g_sAndroidInstance & ".memu"
	If FileExists($sMEmuVmConfig) Then
		Local $sMEmuVmContent = FileRead($sMEmuVmConfig)
		Local $aRenderFromFile = StringRegExp($sMEmuVmContent, 'graphics_render_mode"\s+value="([0-9]+)"', $STR_REGEXPARRAYMATCH)
		If Not @error Then
			SetDebugLog($g_sAndroidEmulator & " instance " & $g_sAndroidInstance & " rendering mode from .memu file is " & $aRenderFromFile[0])
			Switch $aRenderFromFile[0]
				Case "1", "2" ; DirectX / DirectX+
					Return $iDirectX
			EndSwitch
		EndIf
	EndIf

	; fallback to OpenGL
	Return $iOpenGL
EndFunc   ;==>GetMEmuBackgroundMode

Func InitMEmu($bCheckOnly = False)
	Local $process_killed, $aRegExResult, $g_sAndroidAdbDeviceHost, $g_sAndroidAdbDevicePort, $oops = 0
	Local $MEmuVersion = RegRead($g_sHKLM & "\SOFTWARE" & $g_sWow6432Node & "\Microsoft\Windows\CurrentVersion\Uninstall\MEmu\", "DisplayVersion")
	SetError(0, 0, 0)
	; Could also read MEmu paths from environment variables MEmu_Path and MEmuHyperv_Path
	Local $MEmu_Path = GetMEmuPath()
	Local $MEmu_Manage_Path = EnvGet("MEmuHyperv_Path") & "\MEmuManage.exe"
	If FileExists($MEmu_Manage_Path) = 0 Then
		$MEmu_Manage_Path = $MEmu_Path & "..\MEmuHyperv\MEmuManage.exe"
	EndIf

	If FileExists($MEmu_Path & "MEmu.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($MEmu_Path & "MEmu.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	Local $sPreferredADB = FindPreferredAdbPath()
	If $sPreferredADB = "" And FileExists($MEmu_Path & "adb.exe") = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find " & $g_sAndroidEmulator & ":", $COLOR_ERROR)
			SetLog($MEmu_Path & "adb.exe", $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	If FileExists($MEmu_Manage_Path) = 0 Then
		If Not $bCheckOnly Then
			SetLog("Serious error has occurred: Cannot find MEmu-Hyperv:", $COLOR_ERROR)
			SetLog($MEmu_Manage_Path, $COLOR_ERROR)
			SetError(1, @extended, False)
		EndIf
		Return False
	EndIf

	Local $sMEmuInstance = GetMEmuInstanceName($g_sAndroidInstance, $MEmu_Path, Not $bCheckOnly)
	If @error Then Return False
	$g_sAndroidInstance = $sMEmuInstance

	; Read ADB host and Port
	If Not $bCheckOnly Then
		;$g_iAndroidRecoverStrategy = 0
		; newer MEmu doesn't support yet ADB mouse click/minitouch
		Local $memuCurr = GetVersionNormalized($__MEmu_Version)
		Local $memu6 = GetVersionNormalized("6.0")
		If $memuCurr > $memu6 Then
			;SetDebugLog("Disable ADB Mouse Click as not support for " & $g_sAndroidEmulator & " version " & $MEmuVersion)
			;AndroidSupportFeaturesRemove(4) ; disable ADB Mouse Click support
		EndIf

		InitAndroidConfig(True) ; Restore default config

		; update global variables
		$g_sAndroidProgramPath = $MEmu_Path & "MEmu.exe"
		$g_sAndroidAdbPath = $sPreferredADB
		If $g_sAndroidAdbPath = "" Then $g_sAndroidAdbPath = $MEmu_Path & "adb.exe"
		$g_sAndroidVersion = $__MEmu_Version
		$__MEmu_Path = $MEmu_Path
		$g_sAndroidPath = $__MEmu_Path
		$__VBoxManage_Path = $MEmu_Manage_Path
		Local $sMEmuVmConfig = $__MEmu_Path & "MemuHyperv VMs\" & $g_sAndroidInstance & "\" & $g_sAndroidInstance & ".memu"
		Local $sMEmuVmContent = FileExists($sMEmuVmConfig) ? FileRead($sMEmuVmConfig) : ""
		If $sMEmuVmContent = "" Then
			If Not GetAndroidVMinfo($__VBoxVMinfo, $MEmu_Manage_Path) Then Return False
		EndIf

		If $sMEmuVmContent <> "" Then
			$aRegExResult = StringRegExp($sMEmuVmContent, '<Forwarding\s+name="ADB"[^>]*\shostip="([^"]+)"', $STR_REGEXPARRAYMATCH)
		Else
			$aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB.*host ip = ([^,]+),", $STR_REGEXPARRAYMATCH)
		EndIf
		If Not @error Then
			$g_sAndroidAdbDeviceHost = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDeviceHost = " & $g_sAndroidAdbDeviceHost, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Host", $COLOR_ERROR)
		EndIf

		If $sMEmuVmContent <> "" Then
			$aRegExResult = StringRegExp($sMEmuVmContent, '<Forwarding\s+name="ADB"[^>]*\shostport="(\d{3,5})"', $STR_REGEXPARRAYMATCH)
		Else
			$aRegExResult = StringRegExp($__VBoxVMinfo, "name = ADB.*host port = (\d{3,5}),", $STR_REGEXPARRAYMATCH)
		EndIf
		If Not @error Then
			$g_sAndroidAdbDevicePort = $aRegExResult[0]
			If $g_bDebugAndroid Then SetDebugLog("Func LaunchConsole: Read $g_sAndroidAdbDevicePort = " & $g_sAndroidAdbDevicePort, $COLOR_DEBUG)
		Else
			$oops = 1
			SetLog("Cannot read " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB Device Port", $COLOR_ERROR)
		EndIf

		If $oops <> 0 Then
			SetLog("Unable to initialize " & $g_sAndroidEmulator & "(" & $g_sAndroidInstance & ") ADB endpoint", $COLOR_ERROR)
			Return SetError(1, 0, False)
		EndIf
		$g_sAndroidAdbDevice = $g_sAndroidAdbDeviceHost & ":" & $g_sAndroidAdbDevicePort

		; get screencap paths: Name: 'picture', Host path: 'C:\Users\Administrator\Pictures\MEmu Photo' (machine mapping), writable
		$g_sAndroidPicturesPath = "/mnt/shell/emulated/0/Pictures/"
		$g_sAndroidSharedFolderName = "picture"
		ConfigureSharedFolder(0) ; something like C:\Users\Administrator\Pictures\MEmu Photo\

		$__VBoxGuestProperties = LaunchConsole($__VBoxManage_Path, "guestproperty enumerate " & $g_sAndroidInstance, $process_killed)

		; Update Android Screen and Window
		UpdateMEmuConfig()

	EndIf

	Return SetError($oops, 0, True)

EndFunc   ;==>InitMEmu

Func SetScreenMEmu()

	If Not InitAndroid() Then Return False

	Local $bError = False

	; MEmu's launcher configuration is authoritative at boot and rewrites the
	; hypervisor guest properties. Update it before writing the VM values.
	; Older or customized MEmu builds can reject MEMUC configuration keys.
	; Keep the hypervisor configuration and normal post-start recovery available.
	SetMEmuLauncherResolution()

	; Set width and height
	If Not RunMEmuManageChecked("guestproperty set " & $g_sAndroidInstance & " resolution_width " & $g_iAndroidClientWidth) Then $bError = True
	If Not RunMEmuManageChecked("guestproperty set " & $g_sAndroidInstance & " resolution_height " & $g_iAndroidClientHeight) Then $bError = True
	If Not RunMEmuManageChecked("guestproperty set " & $g_sAndroidInstance & " is_full_screen 0") Then $bError = True
	If Not RunMEmuManageChecked("guestproperty set " & $g_sAndroidInstance & " is_customed_resolution 1") Then $bError = True
	If Not RunMEmuManageChecked("guestproperty set " & $g_sAndroidInstance & " custom_resolution " & $g_iAndroidClientWidth & "x" & $g_iAndroidClientHeight) Then $bError = True
	; Set dpi
	If Not RunMEmuManageChecked("guestproperty set " & $g_sAndroidInstance & " vbox_dpi 160") Then $bError = True
	; MEmu 9 keeps the render surface at the previous size unless the running VM is told to resize too.
	; The persistent guest properties above are sufficient while the VM is closed.
	If Not RunMEmuManageChecked("controlvm " & $g_sAndroidInstance & " set_resolution " & $g_iAndroidClientWidth & " " & $g_iAndroidClientHeight & " 160", True) Then $bError = True

	ConfigureSharedFolder(1, True)
	ConfigureSharedFolder(2, True)
	; Re-read the MEmu VM file instead of trusting the command launch result.
	$__VBoxVMinfo = ""
	If Not ConfigureSharedFolder(0, True) Then $bError = True

	If $bError Then
		SetLog($g_sAndroidEmulator & " display configuration command failed", $COLOR_ERROR)
		Return False
	EndIf
	Return True

EndFunc   ;==>SetScreenMEmu

Func RebootMEmuSetScreen()

	Return RebootAndroidSetScreenDefault()

EndFunc   ;==>RebootMEmuSetScreen

Func CloseMEmu()
	If Not $g_bRunState Then Return True

	Local $process_killed
	Local $sOutput = LaunchConsole($__VBoxManage_Path, "controlvm " & $g_sAndroidInstance & " poweroff", $process_killed, 30000)
	Local $iLaunchError = @error
	If $iLaunchError Or $process_killed Or MEmuManageCommandFailed($sOutput, True) Then Return False

	Local $hStopTimer = __TimerInit()
	Do
		$sOutput = LaunchConsole($__VBoxManage_Path, "list runningvms", $process_killed)
		$iLaunchError = @error
		If $iLaunchError Or $process_killed Or MEmuManageCommandFailed($sOutput) Then Return False
		If StringInStr($sOutput, '"' & $g_sAndroidInstance & '"') = 0 Then Return True
		If _SleepStatus(500) Then Return False
	Until __TimerDiff($hStopTimer) >= 30000
	Return False

EndFunc   ;==>CloseMEmu

Func CheckScreenMEmu($bSetLog = True)

	If Not InitAndroid() Then Return False

	; MEmu can expose DPI-scaled guest properties even when its rendered client
	; is already correct. CheckScreenAndroid validates the authoritative live size.
	Local $iErrCnt = 0

	; check if shared folder exists
	If ConfigureSharedFolder(1, $bSetLog) Then $iErrCnt += 1

	If $iErrCnt > 0 Then Return False
	Return True

EndFunc   ;==>CheckScreenMEmu

Func UpdateMEmuConfig()

	Local $aRegExResult
	Local $iSizeConfig = FindMEmuWindowConfig()

	;MEmu "phone_layout" value="2" -> no system bar
	;MEmu "phone_layout" value="1" -> right system bar
	;MEmu "phone_layout" value="0" -> bottom system bar
	$aRegExResult = StringRegExp($__VBoxGuestProperties, "Name: phone_layout, value: (.+), timestamp:", $STR_REGEXPARRAYMATCH)

	If @error = 0 Then
		$__MEmu_PhoneLayout = $aRegExResult[0]
		If $iSizeConfig > -1 And $__MEmu_Window[$iSizeConfig][4] = "-1" Then
			SetDebugLog($g_sAndroidEmulator & " phone_layout is " & $__MEmu_PhoneLayout & ", but set to -1 to disable screen compensation")
			$__MEmu_PhoneLayout = $__MEmu_Window[$iSizeConfig][4]
		Else
			SetDebugLog($g_sAndroidEmulator & " phone_layout is " & $__MEmu_PhoneLayout)
		EndIf
	Else
		SetDebugLog("Cannot read " & $g_sAndroidEmulator & " guestproperty phone_layout!", $COLOR_ERROR)
		If $iSizeConfig > -1 Then
			$__MEmu_PhoneLayout = $__MEmu_Window[$iSizeConfig][4]
			SetDebugLog("Using phone_layout " & $__MEmu_PhoneLayout)
		EndIf
	EndIf
	SetError(0, 0, 0)

	Return UpdateMEmuWindowState()
EndFunc   ;==>UpdateMEmuConfig

Func FindMEmuWindowConfig()
	Local $v = GetVersionNormalized($g_sAndroidVersion)
	For $i = 0 To UBound($__MEmu_Window) - 1
		Local $v2 = GetVersionNormalized($__MEmu_Window[$i][0])
		If $v >= $v2 Then
			SetDebugLog("Using Window sizes of " & $g_sAndroidEmulator & " " & $__MEmu_Window[$i][0])
			Return $i
		EndIf
	Next
	SetDebugLog("Cannot find Window sizes of " & $g_sAndroidEmulator & " " & $g_sAndroidVersion)
	Return -1
EndFunc   ;==>FindMEmuWindowConfig

Func UpdateMEmuWindowState()
	; check if MEmu is open and Tool Bar is closed
	;$g_hAndroidWindow = WinGetHandle($g_sAndroidTitle)
	WinGetAndroidHandle()
	ControlGetPos($g_hAndroidWindow, $g_sAppPaneName, $g_sAppClassInstance)
	If @error = 1 Then
		; Window not found, nothing to do
		SetError(0, 0, 0)
		;Return False
	EndIf

	Local $acw = $g_avAndroidAppConfig[$g_iAndroidConfig][5]
	Local $ach = $g_avAndroidAppConfig[$g_iAndroidConfig][6]
	Local $aww = $g_avAndroidAppConfig[$g_iAndroidConfig][7]
	Local $awh = $g_avAndroidAppConfig[$g_iAndroidConfig][8]
	Local $tbw = $__MEmu_ToolBar_Width

	Local $iSizeConfig = FindMEmuWindowConfig()
	If $iSizeConfig > -1 Then
		$aww = $__MEmu_Window[$iSizeConfig][1]
		$awh = $__MEmu_Window[$iSizeConfig][2]
		$tbw = $__MEmu_Window[$iSizeConfig][3]
	EndIf

	Local $bToolBarVisible = True
	Local $i
	Local $Values[4][3] = [ _
			["Screen Width", $g_iAndroidClientWidth, $g_iAndroidClientWidth], _
			["Screen Height", $g_iAndroidClientHeight, $g_iAndroidClientHeight], _
			["Window Width", $g_iAndroidWindowWidth, $g_iAndroidWindowWidth], _
			["Window Height", $g_iAndroidWindowHeight, $g_iAndroidWindowHeight] _
			]
	Local $bChanged = False, $ok = False
	Local $toolBarPos = ControlGetPos($g_hAndroidWindow, "", "Qt5QWindowIcon3")
	If UBound($toolBarPos) = 4 Then
		Local $tbw_using = $tbw
		If $toolBarPos[2] > 20 And $toolBarPos[2] < 60 Then $tbw_using = $toolBarPos[2]
		SetDebugLog($g_sAndroidEmulator & " Tool Bar found, width = " & $toolBarPos[2] & ", height = " & $toolBarPos[3] & ", expected width = " & $tbw & ", using width = " & $tbw_using)
		$tbw = $tbw_using
		;ConsoleWrite("Qt5QWindowIcon3=" & $toolBarPos[0] & "," & $toolBarPos[1] & "," & $toolBarPos[2] & "," & $toolBarPos[3] & ($isVisible = 1 ? " visible" : " hidden")) ; 863,33,45,732
		;If $toolBarPos[2] = $tbw Then
		$bToolBarVisible = ControlCommand($g_hAndroidWindow, "", "Qt5QWindowIcon3", "IsVisible", "") = 1
		SetDebugLog($g_sAndroidEmulator & " Tool Bar is " & ($bToolBarVisible ? "visible" : "hidden"))
		$ok = True
		;EndIf
	EndIf
	If Not $ok Then
		SetDebugLog($g_sAndroidEmulator & " Tool Bar state is undetermined as treated as " & ($bToolBarVisible ? "visible" : "hidden"), $COLOR_ERROR)
	EndIf

	Local $w = ($bToolBarVisible ? 0 : $tbw)

	Switch $__MEmu_PhoneLayout
		Case "0" ; Bottom position (default)
			$Values[0][2] = $acw
			$Values[1][2] = $ach + $__MEmu_SystemBar
			$Values[2][2] = $aww - $w
			$Values[3][2] = $awh + $__MEmu_SystemBar
		Case "1" ; Right position
			$Values[0][2] = $acw + $__MEmu_SystemBar
			$Values[1][2] = $ach
			$Values[2][2] = $aww + $__MEmu_SystemBar - $w
			$Values[3][2] = $awh
		Case "2", "-1" ; Hidden or no PhoneLayout compensation
			$Values[0][2] = $acw
			$Values[1][2] = $ach
			$Values[2][2] = $aww - $w
			$Values[3][2] = $awh
		Case Else ; Unexpected Value
			SetDebugLog("Unsupported " & $g_sAndroidEmulator & " guestproperty phone_layout = " & $__MEmu_PhoneLayout, $COLOR_ERROR)
	EndSwitch

	$g_iAndroidClientWidth = $Values[0][2]
	$g_iAndroidClientHeight = $Values[1][2]
	$g_iAndroidWindowWidth = $Values[2][2]
	$g_iAndroidWindowHeight = $Values[3][2]

	For $i = 0 To UBound($Values) - 1
		If $Values[$i][1] <> $Values[$i][2] Then
			$bChanged = True
			SetDebugLog($g_sAndroidEmulator & " " & $Values[$i][0] & " updated from " & $Values[$i][1] & " to " & $Values[$i][2])
		EndIf
	Next

	Return $bChanged
EndFunc   ;==>UpdateMEmuWindowState

Func HideMEmuWindow($bHide = True, $hHWndAfter = Default)
	If Not IsHWnd($g_hAndroidWindow) Then Return False

	Static $hStyledWindow = 0
	Static $iOriginalExStyle = 0
	Local $iHiddenStyle = BitOR($WS_EX_TRANSPARENT, $WS_EX_TOOLWINDOW, $WS_EX_NOACTIVATE)
	Local $bTransResult = False
	Local $bSameStyledWindow = $hStyledWindow = $g_hAndroidWindow

	If Not $bSameStyledWindow Then
		$hStyledWindow = $g_hAndroidWindow
		$iOriginalExStyle = BitAND(_WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE), BitNOT($iHiddenStyle))
	EndIf

	If $bHide Then
		; SW_HIDE stops the MEmu render surface and breaks bot captures.
		; Keep it rendered at near-zero opacity and make it non-interactive.
		Local $iCurrentExStyle = _WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE)
		Local $iTransColor, $iTransAlpha
		Local $iLayeredFlags = _WinAPI_GetLayeredWindowAttributes($g_hAndroidWindow, $iTransColor, $iTransAlpha)
		; Reapplying WinSetTrans(1) to an already hidden DirectX window can freeze
		; its rendered surface. Skip only when the current HWND is fully hidden.
		If $bSameStyledWindow And _WinAPI_IsWindowVisible($g_hAndroidWindow) And _
				BitAND($iCurrentExStyle, $iHiddenStyle) = $iHiddenStyle And _
				BitAND($iLayeredFlags, $LWA_ALPHA) = $LWA_ALPHA And $iTransAlpha = 1 Then Return True
		If BitAND($iCurrentExStyle, $iHiddenStyle) <> $iHiddenStyle Then _
				_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, BitOR($iOriginalExStyle, $iHiddenStyle))
		$bTransResult = WinSetTrans($g_hAndroidWindow, "", 1)
		If Not _WinAPI_IsWindowVisible($g_hAndroidWindow) Then _WinAPI_ShowWindow($g_hAndroidWindow, @SW_SHOWNOACTIVATE)
	Else
		; Restore the normal opacity and original window behavior without focus.
		$bTransResult = WinSetTrans($g_hAndroidWindow, "", 255)
		_WinAPI_SetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE, $iOriginalExStyle)
		_WinAPI_ShowWindow($g_hAndroidWindow, @SW_SHOWNOACTIVATE)
	EndIf

	Local $iAppliedExStyle = _WinAPI_GetWindowLong($g_hAndroidWindow, $GWL_EXSTYLE)
	Local $bSuccess = $bTransResult And _WinAPI_IsWindowVisible($g_hAndroidWindow) And _
			($bHide ? BitAND($iAppliedExStyle, $iHiddenStyle) = $iHiddenStyle : $iAppliedExStyle = $iOriginalExStyle)
	If $g_bDebugSetLog Then SetDebugLog("HideMEmuWindow: " & $bHide, $COLOR_DEBUG)
	Return $bSuccess
EndFunc   ;==>HideMEmuWindow
