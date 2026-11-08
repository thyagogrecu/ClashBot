#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiDateTimePicker.au3>
#include <StructureConstants.au3>

Global $g_tDate

Example()

Func Example()
	; Create GUI
	GUICreate("DateTimePick Get System TimeEx (v" & @AutoItVersion & ")", 400, 300)
	Local $hDTP = GUICtrlGetHandle(GUICtrlCreateDate("", 2, 6, 190))
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Set the display format
	_GUICtrlDTP_SetFormat($hDTP, "ddd MMM dd, yyyy hh:mm ttt")

	; Set system time
	$g_tDate = DllStructCreate($tagSYSTEMTIME)
	DllStructSetData($g_tDate, "Year", @YEAR)
	DllStructSetData($g_tDate, "Month", 8)
	DllStructSetData($g_tDate, "Day", 19)
	DllStructSetData($g_tDate, "Hour", 21)
	DllStructSetData($g_tDate, "Minute", 57)
	DllStructSetData($g_tDate, "Second", 34)
	_GUICtrlDTP_SetSystemTimeEx($hDTP, $g_tDate)

	; Display system time
	$g_tDate = _GUICtrlDTP_GetSystemTimeEx($hDTP)
	_MemoWrite("Selected date: " & GetDateStr())
	_MemoWrite("Selected time: " & GetTimeStr())

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example

; Returns the date portion
Func GetDateStr()
	Return StringFormat("%02d/%02d/%04d", DllStructGetData($g_tDate, "Month"), DllStructGetData($g_tDate, "Day"), DllStructGetData($g_tDate, "Year"))
EndFunc   ;==>GetDateStr

; Returns the time portion
Func GetTimeStr()
	Return StringFormat("%02d:%02d:%02d", DllStructGetData($g_tDate, "Hour"), DllStructGetData($g_tDate, "Minute"), DllStructGetData($g_tDate, "Second"))
EndFunc   ;==>GetTimeStr
