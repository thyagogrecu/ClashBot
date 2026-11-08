#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get Height/Width (v" & @AutoItVersion & ")", 450, 320, 100, 100)

	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Get parts height/width
	_MemoWrite("Height of parts .: " & _GUICtrlStatusBar_GetHeight($hStatus))
	_MemoWrite("Width of part 0 .: " & _GUICtrlStatusBar_GetWidth($hStatus, 0))
	_MemoWrite("Width of part 1 .: " & _GUICtrlStatusBar_GetWidth($hStatus, 1))
	_MemoWrite("Width of part 2 .: " & _GUICtrlStatusBar_GetWidth($hStatus, 2))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
