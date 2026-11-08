#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tFile, $tSystem

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get system time
	$tSystem = _Date_Time_GetSystemTime()
	$tFile = _Date_Time_SystemTimeToFileTime($tSystem)
	_MemoWrite("File time .: " & _Date_Time_FileTimeToStr($tFile))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
