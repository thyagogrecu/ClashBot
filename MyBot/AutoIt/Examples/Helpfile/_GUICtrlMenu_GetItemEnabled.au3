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

	; Get/Set Open enabled
	Writeln("Open is disabled: " & _GUICtrlMenu_GetItemDisabled($hFile, 1))
	_GUICtrlMenu_SetItemDisabled($hFile, 1)
	Writeln("Open is disabled: " & _GUICtrlMenu_GetItemDisabled($hFile, 1))
	_GUICtrlMenu_SetItemEnabled($hFile, 1)
	Writeln("Open is enabled : " & _GUICtrlMenu_GetItemEnabled($hFile, 1))

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
