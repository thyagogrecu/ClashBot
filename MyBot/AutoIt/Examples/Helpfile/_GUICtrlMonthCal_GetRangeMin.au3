#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tMin, $tMax, $idMonthCal

	; Create GUI
	GUICreate("Month Calendar Get Range Min", 400, 300)
	$idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, BitOR($WS_BORDER, $MCS_MULTISELECT), 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 392, 128, 0)
	GUISetState(@SW_SHOW)

	; Get/Set range
	_GUICtrlMonthCal_SetRange($idMonthCal, @YEAR, 1, 1, @YEAR, 12, 31)
	$tMin = _GUICtrlMonthCal_GetRangeMin($idMonthCal)
	$tMax = _GUICtrlMonthCal_GetRangeMax($idMonthCal)
	_MemoWrite("Minimum selectable date: " & StringFormat("%02d/%02d/%04d", DllStructGetData($tMin, "Month"), _
			DllStructGetData($tMin, "Day"), _
			DllStructGetData($tMin, "Year")))
	_MemoWrite("Maximum selectable date: " & StringFormat("%02d/%02d/%04d", DllStructGetData($tMax, "Month"), _
			DllStructGetData($tMax, "Day"), _
			DllStructGetData($tMax, "Year")))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
