#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get Borders (v" & @AutoItVersion & ")", 450, 320, 100, 100)

	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)

	GUISetState(@SW_SHOW)

	; Get border sizes
	Local $aInfo = _GUICtrlStatusBar_GetBorders($hGUI)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aInfo = ' & $aInfo & @CRLF & '>Error code: ' & @error & '    Extended code: ' & @extended & ' (0x' & Hex(@extended) & ')' & @CRLF) ;### Debug Console
	_MemoWrite("Horizontal border width .: " & $aInfo[0])
	_MemoWrite("Vertical border width ...: " & $aInfo[1])
	_MemoWrite("Width between rectangles : " & $aInfo[2])

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
