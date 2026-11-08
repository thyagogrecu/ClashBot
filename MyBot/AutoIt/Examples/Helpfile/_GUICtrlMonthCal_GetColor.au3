#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Month Calendar Get/Set Color (v" & @AutoItVersion & ")", 400, 300)
	Local $idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; Create memo control
	_MemoCreate(4, 188, 392, 108, 0)
	GUISetState(@SW_SHOW)

	; Get/Set calendar color
	_MemoWrite("Background: 0x" & Hex(_GUICtrlMonthCal_GetColor($idMonthCal, $MCSC_MONTHBK), 6))
	_GUICtrlMonthCal_SetColor($idMonthCal, $MCSC_TEXT, 0xB02B00)
	_GUICtrlMonthCal_SetColor($idMonthCal, $MCSC_TITLEBK, 0x5EFFFE)
	_GUICtrlMonthCal_SetColor($idMonthCal, $MCSC_TITLETEXT, 0x0000FF)
	_GUICtrlMonthCal_SetColor($idMonthCal, $MCSC_MONTHBK, 0x87C4FF)
	_GUICtrlMonthCal_SetColor($idMonthCal, $MCSC_TRAILINGTEXT, 0x997777)
	_MemoWrite("Background: 0x" & Hex(_GUICtrlMonthCal_GetColor($idMonthCal, $MCSC_MONTHBK), 6))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
