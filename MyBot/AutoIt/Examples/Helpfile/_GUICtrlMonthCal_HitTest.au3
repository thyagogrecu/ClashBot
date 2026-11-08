#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WinAPIMisc.au3>
#include <WindowsStylesConstants.au3>

Global $g_idMonthCal, $g_hGUI

Example()

Func Example()
	; Create GUI
	$g_hGUI = GUICreate("Month Calendar Hit Test (v" & @AutoItVersion & ")", 400, 300)
	$g_idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 392, 128, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_MOUSEMOVE
				DoHitTest()
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>Example

; Perform hit test
Func DoHitTest()
	Local $tHit

	$tHit = _GUICtrlMonthCal_HitTest($g_idMonthCal, _WinAPI_GetMousePosX(True, $g_hGUI), _WinAPI_GetMousePosY(True, $g_hGUI))
	If BitAND(DllStructGetData($tHit, "Hit"), $MCHT_CALENDARDATE) <> 0 Then
		_MemoWrite("Date: " & StringFormat("%02d/%02d/%04d", DllStructGetData($tHit, "Month"), _
				DllStructGetData($tHit, "Day"), _
				DllStructGetData($tHit, "Year")))
	EndIf
EndFunc   ;==>DoHitTest
