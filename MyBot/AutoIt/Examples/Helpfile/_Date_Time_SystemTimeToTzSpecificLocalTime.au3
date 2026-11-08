#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tLocal, $tSystem

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Convert system time to local time
	$tSystem = _Date_Time_GetSystemTime()
	$tLocal = _Date_Time_SystemTimeToTzSpecificLocalTime($tSystem)
	_MemoWrite("System time to local time .: " & _Date_Time_SystemTimeToDateTimeStr($tLocal))

	$tLocal = _Date_Time_GetLocalTime()
	$tSystem = _Date_Time_TzSpecificLocalTimeToSystemTime($tLocal)
	_MemoWrite("Local time to system time .: " & _Date_Time_SystemTimeToDateTimeStr($tSystem))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
