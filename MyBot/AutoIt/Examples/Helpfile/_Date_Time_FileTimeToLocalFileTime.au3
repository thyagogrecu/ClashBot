#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tFile, $tLocal

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get system time
	Local $tSystem = _Date_Time_GetSystemTime()
	$tFile = _Date_Time_SystemTimeToFileTime($tSystem)
	;	--------------------------------------
	$tLocal = _Date_Time_FileTimeToLocalFileTime($tFile)
	_MemoWrite("Local file time .: " & _Date_Time_FileTimeToStr($tLocal))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
