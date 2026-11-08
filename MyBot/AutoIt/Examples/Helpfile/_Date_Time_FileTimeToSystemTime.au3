#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tFile, $tSystem

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Encode a file time
	$tFile = _Date_Time_EncodeFileTime(@MON, @MDAY, @YEAR, @HOUR, @MIN, @SEC)
	$tSystem = _Date_Time_FileTimeToSystemTime($tFile)
	_MemoWrite("System file time .: " & _Date_Time_SystemTimeToDateTimeStr($tSystem))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
