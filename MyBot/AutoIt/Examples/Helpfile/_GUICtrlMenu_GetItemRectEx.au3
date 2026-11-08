#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>

Global $g_hWnd

Example()

Func Example()
	Local $hMain, $tRECT

	; Open Notepad
	Run("notepad.exe")
	$g_hWnd = WinWaitActive("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($g_hWnd)

	; Get File menu rectangle
	$tRECT = _GUICtrlMenu_GetItemRectEx($g_hWnd, $hMain, 0)

	Writeln("File X1: " & DllStructGetData($tRECT, "Left"))
	Writeln("File Y1: " & DllStructGetData($tRECT, "Top"))
	Writeln("File X2: " & DllStructGetData($tRECT, "Right"))
	Writeln("File Y2: " & DllStructGetData($tRECT, "Bottom"))

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
