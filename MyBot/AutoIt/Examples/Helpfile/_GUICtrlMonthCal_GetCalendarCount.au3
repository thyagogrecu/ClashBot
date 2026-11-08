#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $idMonthCal

	; Create GUI
	GUICreate("Month Calendar", 400, 300)
	$idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 392, 128, 0)
	GUISetState(@SW_SHOW)

	; Get/Set calendar border
	_MemoWrite("Calendar Count: " & _GUICtrlMonthCal_GetCalendarCount($idMonthCal))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
