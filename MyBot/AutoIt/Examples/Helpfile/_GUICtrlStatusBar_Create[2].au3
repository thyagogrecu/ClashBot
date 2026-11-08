; == Example 2 : with part width array of 3 elements

#include "Extras\HelpFileInternals.au3"
#include "Extras\WM_NOTIFY.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Global $g_hMainGUI, $g_hStatus

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Create (v" & @AutoItVersion & ")", 450, 320, 100, 100)

	; sets parts with no text
	Local $aParts[3] = [75, 150, -1]
	$g_hStatus = _GUICtrlStatusBar_Create($hGUI, $aParts)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)

	GUISetState(@SW_SHOW)

	_MemoWrite("StatusBar Created with:" & @CRLF & _
			@TAB & "Handle to GUI window" & @CRLF & _
			@TAB & "part width array of 3 elements" & @CRLF)

	_WM_NOTIFY_Register($_g_idLst_Memo)

	; Get border sizes
	_MemoWrite("Horizontal border width .: " & _GUICtrlStatusBar_GetBordersHorz($g_hStatus))
	_MemoWrite("Vertical border width ...: " & _GUICtrlStatusBar_GetBordersVert($g_hStatus))
	_MemoWrite("Width between rectangles : " & _GUICtrlStatusBar_GetBordersRect($g_hStatus))
	_MemoWrite("")

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUISetState(@SW_ENABLE, $g_hMainGUI)
	GUIDelete($hGUI)
EndFunc   ;==>Example

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam

	Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	Local $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $g_hStatus
			Switch $iCode
				Case $NM_CLICK ; The user has clicked the left mouse button within the control
					_WM_NOTIFY_DebugEvent("$NM_CLICK", $tagNMMOUSE, $lParam, "IDFrom,,ItemSpec,ItemData,X,Y,HitInfo")
					Return True ; indicate that the mouse click was handled and suppress default processing by the system
					; Return FALSE ;to allow default processing of the click.
				Case $NM_DBLCLK ; The user has double-clicked the left mouse button within the control
					_WM_NOTIFY_DebugEvent("$NM_DBLCLK", $tagNMMOUSE, $lParam, "IDFrom,,ItemSpec,ItemData,X,Y,HitInfo")
					Return True ; indicate that the mouse click was handled and suppress default processing by the system
					; Return FALSE ;to allow default processing of the click.
				Case $NM_RCLICK ; The user has clicked the right mouse button within the control
					_WM_NOTIFY_DebugEvent("$NM_RCLICK", $tagNMMOUSE, $lParam, "IDFrom,,ItemSpec,ItemData,X,Y,HitInfo")
					Return True ; indicate that the mouse click was handled and suppress default processing by the system
					; Return FALSE ;to allow default processing of the click.
				Case $NM_RDBLCLK ; The user has double-clicked the right mouse button within the control
					_WM_NOTIFY_DebugEvent("$NM_RDBLCLK", $tagNMMOUSE, $lParam, "IDFrom,,ItemSpec,ItemData,X,Y,HitInfo")
					Return True ; indicate that the mouse click was handled and suppress default processing by the system
					; Return FALSE ;to allow default processing of the click.
				Case $SBN_SIMPLEMODECHANGE ; Simple mode changes
					_WM_NOTIFY_DebugEvent("$SBN_SIMPLEMODECHANGE", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
				; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
