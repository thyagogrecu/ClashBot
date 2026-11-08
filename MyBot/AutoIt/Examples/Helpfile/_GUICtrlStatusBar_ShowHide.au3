#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar ShowHide (v" & @AutoItVersion & ")", 450, 320, 100, 100)

	; defaults to 1 part, no text
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Set parts
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 0")
	_GUICtrlStatusBar_SetText($hStatus, "Part 1", 1)
	_GUICtrlStatusBar_SetText($hStatus, "Part 2", 2)

	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Hide StatusBar")
	_GUICtrlStatusBar_ShowHide($hStatus, @SW_HIDE)

	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Show StatusBar")
	_GUICtrlStatusBar_ShowHide($hStatus, @SW_SHOW)

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
