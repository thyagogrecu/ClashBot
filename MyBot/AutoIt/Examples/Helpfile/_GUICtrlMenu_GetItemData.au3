#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>

Global $g_hWnd

Example()

Func Example()
	Local $hMain

	; Open Notepad
	Run("notepad.exe")
	$g_hWnd = WinWaitActive("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($g_hWnd)

	; Get/Set File menu item data
	Writeln("File menu item data: " & _GUICtrlMenu_GetItemData($hMain, 0))
	_GUICtrlMenu_SetItemData($hMain, 0, 1234)
	Writeln("File menu item data: " & _GUICtrlMenu_GetItemData($hMain, 0))

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
