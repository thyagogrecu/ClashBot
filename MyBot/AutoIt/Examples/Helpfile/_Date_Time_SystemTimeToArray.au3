#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tTime, $aTime

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get current system time
	$tTime = _Date_Time_GetSystemTime()
	$aTime = _Date_Time_SystemTimeToArray($tTime)
	_MemoWrite("Month ........: " & $aTime[0])
	_MemoWrite("Day ..........: " & $aTime[1])
	_MemoWrite("Year .........: " & $aTime[2])
	_MemoWrite("Hour .........: " & $aTime[3])
	_MemoWrite("Minute .......: " & $aTime[4])
	_MemoWrite("Second .......: " & $aTime[5])
	_MemoWrite("Milliseconds .: " & $aTime[6])
	_MemoWrite("Day of week ..: " & $aTime[7])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
