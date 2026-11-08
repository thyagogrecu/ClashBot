#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Month Calendar Get/Set Cur Sel (v" & @AutoItVersion & ")", 400, 300)
	Local $idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 392, 128, 0)
	GUISetState(@SW_SHOW)

	; Get/Set current selection
	_GUICtrlMonthCal_SetCurSel($idMonthCal, @YEAR, 8, 19)
	Local $tTime = _GUICtrlMonthCal_GetCurSel($idMonthCal)
	_MemoWrite("Current selection : " & StringFormat("%02d/%02d/%04d", DllStructGetData($tTime, "Month"), _
			DllStructGetData($tTime, "Day"), _
			DllStructGetData($tTime, "Year")))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
