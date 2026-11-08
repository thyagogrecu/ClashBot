#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tDate

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get current system date
	$tDate = _Date_Time_GetSystemTime()
	_MemoWrite("Current system date .: " & _Date_Time_SystemTimeToDateStr($tDate))
	_MemoWrite("Current system date .: " & _Date_Time_SystemTimeToDateStr($tDate, 1))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
