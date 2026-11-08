#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tFileTime1, $tFileTime2

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Compare FAT Dates/Times
	$tFileTime1 = _Date_Time_DOSDateTimeToFileTime(0x3621, 0x11EF) ; 01/01/2007 02:15:30
	$tFileTime2 = _Date_Time_DOSDateTimeToFileTime(0x379F, 0x944A) ; 31/12/2007 18:34:20

	_MemoWrite("Result 1: " & _Date_Time_CompareFileTime($tFileTime1, $tFileTime2))
	_MemoWrite("Result 2: " & _Date_Time_CompareFileTime($tFileTime1, $tFileTime1))
	_MemoWrite("Result 3: " & _Date_Time_CompareFileTime($tFileTime2, $tFileTime1))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
