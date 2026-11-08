#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Month Calendar Get/Set Unicode Format (v" & @AutoItVersion & ")", 440, 300)
	Local $idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 432, 128, 0)
	GUISetState(@SW_SHOW)

	; Get/Set Unicode setting
	_GUICtrlMonthCal_SetUnicodeFormat($idMonthCal, False)
	_MemoWrite("Unicode: " & _GUICtrlMonthCal_GetUnicodeFormat($idMonthCal))
	_GUICtrlMonthCal_SetUnicodeFormat($idMonthCal, True)
	_MemoWrite("Unicode: " & _GUICtrlMonthCal_GetUnicodeFormat($idMonthCal))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
