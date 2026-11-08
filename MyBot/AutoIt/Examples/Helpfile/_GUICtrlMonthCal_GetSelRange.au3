#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Month Calendar Get/Set Sel Range (v" & @AutoItVersion & ")", 400, 300)
	Local $idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, BitOR($WS_BORDER, $MCS_MULTISELECT), 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 392, 128, 0)
	GUISetState(@SW_SHOW)

	; Get/Set selection
	_GUICtrlMonthCal_SetSelRange($idMonthCal, @YEAR, @MON, 1, @YEAR, @MON, 7)
	Local $tRange = _GUICtrlMonthCal_GetSelRange($idMonthCal)
	_MemoWrite("Start date: " & StringFormat("%02d/%02d/%04d", DllStructGetData($tRange, "MinMonth"), _
			DllStructGetData($tRange, "MinDay"), _
			DllStructGetData($tRange, "MinYear")))
	_MemoWrite("End date .: " & StringFormat("%02d/%02d/%04d", DllStructGetData($tRange, "MaxMonth"), _
			DllStructGetData($tRange, "MaxDay"), _
			DllStructGetData($tRange, "MaxYear")))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
