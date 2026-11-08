#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GUIToolTip.au3>

Example()

Func Example()
	Local $hGUI = GUICreate("ToolTip Add Tool v(" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $iGUI = 1

	; create a tooltip control using default settings
	Local $hToolTip = _GUIToolTip_Create(0)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hToolTip = ' & $hToolTip & @CRLF & '>Error code: ' & @error & '    Extended code: ' & @extended & ' (0x' & Hex(@extended) & ')' & @CRLF) ;### Debug Console
	_MemoSetHandleInProcess($hToolTip)

	Local $idButton = GUICtrlCreateButton("Button", 30, 32, 130, 28)
	Local $hButton = GUICtrlGetHandle($idButton)

;~ 	$iGUI = 0 ; is OK
	; add a tool to the tooltip control
	_GUIToolTip_AddTool($hToolTip, $iGUI * $hGUI, "This is a ToolTip", $hButton)
	_GUIToolTip_AddTool($hToolTip, $iGUI * $hGUI, "This is a ToolTip for the non another ctrl's", $hGUI)

	GUISetState(@SW_SHOW)

	; Show the tooltip associated with the button
	Opt("MouseCoordMode", 2)
	MouseMove(50, 42, 0)
	Sleep(250)

	While 1
		If GUIGetMsg() = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd

	; Destroy the tooltip control
	_MemoResetHandleInProcess($hToolTip)
	_GUIToolTip_Destroy($hToolTip)
	GUIDelete($hGUI)
EndFunc   ;==>Example
