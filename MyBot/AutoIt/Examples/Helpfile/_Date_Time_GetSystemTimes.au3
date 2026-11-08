#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $aTime

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get system times
	$aTime = _Date_Time_GetSystemTimes()

	_MemoWrite("Idle time ...: " & _Date_Time_FileTimeToStr($aTime[0]))
	_MemoWrite("System time .: " & _Date_Time_FileTimeToStr($aTime[1]))
	_MemoWrite("User time ...: " & _Date_Time_FileTimeToStr($aTime[2]))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
