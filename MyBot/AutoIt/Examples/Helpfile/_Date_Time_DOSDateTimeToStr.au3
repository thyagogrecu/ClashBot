#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $sDate

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Show FAT date/time
	$sDate = _Date_Time_DOSDateTimeToStr(0x3621, 0x944a) ; 01/01/2007 18:34:20
	_MemoWrite("FAT date/time .: " & $sDate)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
