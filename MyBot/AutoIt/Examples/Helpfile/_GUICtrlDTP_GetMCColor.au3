#include "Extras\HelpFileInternals.au3"

#include <ColorConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiDateTimePicker.au3>

Example() ;use autoit built-in control

Func Example()
	; Create GUI
	GUICreate("DateTimePick Get/Set MCColor (v" & @AutoItVersion & ")", 400, 300)
	Local $hDTP = GUICtrlGetHandle(GUICtrlCreateDate("", 2, 6, 190))
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Set the display format
	_GUICtrlDTP_SetFormat($hDTP, "ddd MMM dd, yyyy hh:mm ttt")

	; Set month calendar background color
	_GUICtrlDTP_SetMCColor($hDTP, 2, $CLR_DARKSEAGREEN)

	; Get DTP colors
	_MemoWrite("Background between months: " & "0x" & Hex(_GUICtrlDTP_GetMCColor($hDTP, 0), 6))
	_MemoWrite("Text within months ......: " & "0x" & Hex(_GUICtrlDTP_GetMCColor($hDTP, 1), 6))
	_MemoWrite("Title background ........: " & "0x" & Hex(_GUICtrlDTP_GetMCColor($hDTP, 2), 6))
	_MemoWrite("Title text ..............: " & "0x" & Hex(_GUICtrlDTP_GetMCColor($hDTP, 3), 6))
	_MemoWrite("Background within months : " & "0x" & Hex(_GUICtrlDTP_GetMCColor($hDTP, 4), 6))
	_MemoWrite("Header trailing .........: " & "0x" & Hex(_GUICtrlDTP_GetMCColor($hDTP, 5), 6))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
