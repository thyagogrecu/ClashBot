#include "Extras\HelpFileInternals.au3"

#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WinAPITheme.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Set BkColor (v" & @AutoItVersion & ")", 450, 320, 100, 100)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; to allow the setting of Bk Color at least under Windows 10
	_WinAPI_SetWindowTheme($hStatus, "", "")

	; Set parts
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 0")
	_GUICtrlStatusBar_SetText($hStatus, "Part 1", 1)
	_GUICtrlStatusBar_SetText($hStatus, "Part 2", 2)

	; Set background color
	_GUICtrlStatusBar_SetBkColor($hStatus, $CLR_DARKSEAGREEN)

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
