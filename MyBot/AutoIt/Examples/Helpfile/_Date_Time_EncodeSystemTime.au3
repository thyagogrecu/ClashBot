#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tSystem

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Encode a system time
	$tSystem = _Date_Time_EncodeSystemTime(@MON, @MDAY, @YEAR, @HOUR, @MIN, @SEC)
	_MemoWrite("Current date/time .: " & _Date_Time_SystemTimeToDateTimeStr($tSystem))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
