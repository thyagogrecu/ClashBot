#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get/Set Unicode Format (v" & @AutoItVersion & ")", 450, 320, 100, 100)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Get/Set Unicode format
	_MemoWrite("Unicode format .: " & _GUICtrlStatusBar_GetUnicodeFormat($hStatus))
	_GUICtrlStatusBar_SetUnicodeFormat($hStatus, False)
	_MemoWrite("Unicode format .: " & _GUICtrlStatusBar_GetUnicodeFormat($hStatus))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
