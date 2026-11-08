#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get RectEx (v" & @AutoItVersion & ")", 450, 320, 100, 100)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Set/Get parts
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; Get part 0 rectangles
	Local $tRECT = _GUICtrlStatusBar_GetRectEx($hStatus, 0)
	_MemoWrite("Part 0 left ...: " & DllStructGetData($tRECT, "Left"))
	_MemoWrite("Part 0 top ....: " & DllStructGetData($tRECT, "Top"))
	_MemoWrite("Part 0 right ..: " & DllStructGetData($tRECT, "Right"))
	_MemoWrite("Part 0 bottom .: " & DllStructGetData($tRECT, "Bottom"))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
