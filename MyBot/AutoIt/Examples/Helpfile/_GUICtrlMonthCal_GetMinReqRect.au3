#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Month Calendar Get Min Req Rect (v" & @AutoItVersion & ")", 400, 300)
	Local $idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, BitOR($WS_BORDER, $MCS_MULTISELECT), 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 392, 128, 0)
	GUISetState(@SW_SHOW)

	; Get minimum required height/width
	Local $tRECT = _GUICtrlMonthCal_GetMinReqRect($idMonthCal)
	_MemoWrite("Minimum required height: " & DllStructGetData($tRECT, "Bottom"))
	_MemoWrite("Minimum required width : " & DllStructGetData($tRECT, "Right"))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
