#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get Rect (v" & @AutoItVersion & ")", 450, 320, 100, 100)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Set/Get parts
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; Get Part 0 rectangles
	Local $aRect = _GUICtrlStatusBar_GetRect($hStatus, 0)
	_MemoWrite("Part 0 left ...: " & $aRect[0])
	_MemoWrite("Part 0 top ....: " & $aRect[1])
	_MemoWrite("Part 0 right ..: " & $aRect[2])
	_MemoWrite("Part 0 bottom .: " & $aRect[3])

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
