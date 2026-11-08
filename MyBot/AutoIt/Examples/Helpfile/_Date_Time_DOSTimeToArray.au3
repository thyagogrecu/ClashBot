#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $aDate

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Show FAT time
	$aDate = _Date_Time_DOSTimeToArray(0x944a) ; 18:34:20
	_MemoWrite("FAT time .: " & StringFormat("%02d:%02d:%02d", $aDate[0], $aDate[1], $aDate[2]))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
