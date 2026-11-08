#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get Borders Rect (v" & @AutoItVersion & ")", 450, 320, 100, 100)

	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Get border sizes
	_MemoWrite("Horizontal border width .: " & _GUICtrlStatusBar_GetBordersHorz($hStatus))
	_MemoWrite("Vertical border width ...: " & _GUICtrlStatusBar_GetBordersVert($hStatus))
	_MemoWrite("Width between rectangles : " & _GUICtrlStatusBar_GetBordersRect($hStatus))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
