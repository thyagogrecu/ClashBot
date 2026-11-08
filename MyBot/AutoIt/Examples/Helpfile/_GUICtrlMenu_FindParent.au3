#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>

Global $g_hWnd

Example()

Func Example()
	Run("notepad.exe")
	$g_hWnd = WinWaitActive("[CLASS:Notepad]")
	Local $hMain = _GUICtrlMenu_GetMenu($g_hWnd)

	; Show that Menu handle belongs to Notepad
	Writeln("Notepad handle: 0x" & Hex($g_hWnd))
	Writeln("Menu Parent ..: 0x" & Hex(_GUICtrlMenu_FindParent($hMain)))

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
