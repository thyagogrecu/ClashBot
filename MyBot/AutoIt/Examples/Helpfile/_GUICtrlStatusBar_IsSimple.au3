#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Is/Set Simple (v" & @AutoItVersion & ")", 450, 320, 100, 100)

	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Get/Set simple format
	_MemoWrite("Simple mode on .: " & _GUICtrlStatusBar_IsSimple($hStatus))
	Sleep(1000)
	_GUICtrlStatusBar_SetSimple($hStatus, True)
	_MemoWrite("Simple mode on .: " & _GUICtrlStatusBar_IsSimple($hStatus))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
