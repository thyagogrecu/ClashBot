; #FUNCTION# ===========================================================================================================
; Name ..........: CheckAndroidRebootCondition
; Author ........: Phael
; Description ...: Checks graphics, network and emulator error flags that require an Android reboot.
; Remarks .......: Time-based preventive reboot is not used.
; ======================================================================================================================
#include-once

Func CheckAndroidRebootCondition()
	; check for additional reboot conditions
	Select
		Case $g_bGfxError
			$g_bGfxError = False
			$g_iGfxErrorCount = 0
			SetLog("Reboot " & $g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") due to detected Gfx Errors")
			Return True
		Case $g_bNetworkError
			$g_bNetworkError = False
			SetLog("Reboot " & $g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") due to detected Network Error")
			Return True
		Case $g_bErrorWindow
			$g_bErrorWindow = False
			SetLog("Reboot " & $g_sAndroidEmulator & " (" & $g_sAndroidInstance & ") due to detected Error Window")
			Return True
	EndSelect

	Return False
EndFunc   ;==>CheckAndroidRebootCondition
