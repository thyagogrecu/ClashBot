; =; == Example 1 : Created with UDF

#include "Extras\HelpFileInternals.au3"
#include "Extras\WM_NOTIFY.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <WindowsStylesConstants.au3>

Global $g_hTab

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Create (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	$g_hTab = _GUICtrlTab_Create($hGUI, 2, 2, 446, 266)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	_WM_NOTIFY_Register()

	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Create 3 Tabs")
	; Add tabs
	_GUICtrlTab_InsertItem($g_hTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($g_hTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($g_hTab, 2, "Tab 2")

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hWndTab = $g_hTab
	If Not IsHWnd($g_hTab) Then $hWndTab = GUICtrlGetHandle($g_hTab)

	Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	Local $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndTab
			Switch $iCode
				Case $NM_CLICK ; The user has clicked the left mouse button within the control
					_WM_NOTIFY_DebugEvent("$NM_CLICK", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
					; The return value is ignored by the tab control
				Case $NM_DBLCLK ; The user has double-clicked the left mouse button within the control
					_WM_NOTIFY_DebugEvent("$NM_DBLCLK", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
					; Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_RCLICK ; The user has clicked the right mouse button within the control
					_WM_NOTIFY_DebugEvent("$NM_RCLICK", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
					; Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_RDBLCLK ; The user has double-clicked the right mouse button within the control
					_WM_NOTIFY_DebugEvent("$NM_RDBLCLK", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
					; Return 1 ; nonzero to not allow the default processing
					Return 0 ; zero to allow the default processing
				Case $NM_RELEASEDCAPTURE ; control is releasing mouse capture
					_WM_NOTIFY_DebugEvent("$NM_RELEASEDCAPTURE", $tagNMHDR, $lParam, "hWndFrom,IDFrom")
					; No return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
