#include <Misc.au3>
#include <WinAPISysWin.au3>

Opt('TrayAutoPause', 0)

Example()

Func Example()
	Local $hTimerProc = DllCallbackRegister('_TimerProc', 'none', 'hwnd;uint;uint_ptr;dword')

	Local $iTimerID = _WinAPI_SetTimer(0, 0, 1000, DllCallbackGetPtr($hTimerProc))

	; close script by pressing {ESC}
	Do
		Sleep(100)
	Until _IsPressed('1B')

	_WinAPI_KillTimer(0, $iTimerID)
	DllCallbackFree($hTimerProc)

EndFunc   ;==>Example

Func _TimerProc($hWnd, $iMsg, $iTimerID, $iTime)
	#forceref $hWnd, $iMsg, $iTimerID, $iTime
	Local Static $iCount = 1

	ToolTip("$iCount = " & $iCount, Default, Default, "Press {ESC} to close the script")
	$iCount += 1
EndFunc   ;==>_TimerProc
