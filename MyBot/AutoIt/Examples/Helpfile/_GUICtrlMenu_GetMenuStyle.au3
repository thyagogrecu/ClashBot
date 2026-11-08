#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>

Global $g_hWnd

Example()

Func Example()
	Local $hMain, $hFile

	; Open Notepad
	Run("notepad.exe")
	$g_hWnd = ("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($g_hWnd)
	$hFile = _GUICtrlMenu_GetItemSubMenu($hMain, 0)

	; Get/Set File menu style
	Writeln("File menu style: 0x" & Hex(_GUICtrlMenu_GetMenuStyle($hFile)))
	_GUICtrlMenu_SetMenuStyle($hFile, $MNS_NOCHECK)
	Writeln("File menu style: 0x" & Hex(_GUICtrlMenu_GetMenuStyle($hFile)))

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
