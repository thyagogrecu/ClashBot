#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsNotifsConstants.au3>

Global $g_hStatus

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Resize (v" & @AutoItVersion & ")", 450, 320, 100, 100, $WS_OVERLAPPEDWINDOW)

	; Set parts
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)
	$g_hStatus = $hStatus

	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 0")
	_GUICtrlStatusBar_SetText($hStatus, "Part 1", 1)
	_GUICtrlStatusBar_SetText($hStatus, "Part 2", 2)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	GUIRegisterMsg($WM_SIZE, "WM_SIZE")

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example

; Resize the status bar when GUI size changes
Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam, $lParam
	_GUICtrlStatusBar_Resize($g_hStatus)
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE
