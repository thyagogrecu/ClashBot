#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Month Calendar Get/Set Month Delta (v" & @AutoItVersion & ")", 420, 300)
	Local $idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, BitOR($WS_BORDER, $MCS_MULTISELECT), 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 412, 128, 0)
	GUISetState(@SW_SHOW)

	; Get/Set month delta
	_GUICtrlMonthCal_SetMonthDelta($idMonthCal, 2)
	_MemoWrite("Month delta: " & _GUICtrlMonthCal_GetMonthDelta($idMonthCal))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
