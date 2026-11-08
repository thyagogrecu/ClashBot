#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiDateTimePicker.au3>

Global $g_aDate

Example()

Func Example()
	; Create GUI
	GUICreate("DateTimePick Get/Set System Time (v" & @AutoItVersion & ")", 400, 300)
	Local $hDTP = GUICtrlGetHandle(GUICtrlCreateDate("", 2, 6, 190))
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Set the display format
	_GUICtrlDTP_SetFormat($hDTP, "ddd MMM dd, yyyy hh:mm ttt")

	; Set system time
	Local $a_Date[7] = [False, @YEAR, 8, 19, 21, 57, 34]
	_GUICtrlDTP_SetSystemTime($hDTP, $a_Date)

	; Display system time
	$g_aDate = _GUICtrlDTP_GetSystemTime($hDTP)
	_MemoWrite("Selected date: " & GetDateStr())
	_MemoWrite("Selected time: " & GetTimeStr())

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example

; Returns the date portion
Func GetDateStr()
	Return StringFormat("%02d/%02d/%04d", $g_aDate[1], $g_aDate[2], $g_aDate[0])
EndFunc   ;==>GetDateStr

; Returns the time portion
Func GetTimeStr()
	Return StringFormat("%02d:%02d:%02d", $g_aDate[3], $g_aDate[4], $g_aDate[5])
EndFunc   ;==>GetTimeStr
