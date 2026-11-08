#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Month Calendar Get/Set Sel Count (v" & @AutoItVersion & ")", 420, 300)
	Local $idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, BitOR($WS_BORDER, $MCS_MULTISELECT), 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 412, 128, 0)
	GUISetState(@SW_SHOW)

	; Get/Set maximum selection count
	_GUICtrlMonthCal_SetMaxSelCount($idMonthCal, 7)
	_MemoWrite("Maximum selction count: " & _GUICtrlMonthCal_GetMaxSelCount($idMonthCal))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
