#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>

Global $g_hWnd

Example()

Func Example()
	Local $hMain, $hFile

	; Open Notepad
	Run("notepad.exe")
	$g_hWnd = WinWaitActive("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($g_hWnd)
	$hFile = _GUICtrlMenu_GetItemSubMenu($hMain, 0)

	; Get/Set File menu data
	Writeln("File data: " & _GUICtrlMenu_GetMenuData($hFile))
	_GUICtrlMenu_SetMenuData($hFile, 1234)
	Writeln("File data: " & _GUICtrlMenu_GetMenuData($hFile))

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
