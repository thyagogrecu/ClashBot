#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>
#include <WinAPIGdi.au3>
#include <WindowsSysColorConstants.au3>

Global $g_hWnd

Example()

Func Example()
	Local $hMain, $hFile, $hBrush

	; Open Notepad
	Run("notepad.exe")
	$g_hWnd = WinWaitActive("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($g_hWnd)
	$hFile = _GUICtrlMenu_GetItemSubMenu($hMain, 0)

	; File menu background
	Writeln("File menu background: 0x" & Hex(_GUICtrlMenu_GetMenuBackground($hFile)))
	$hBrush = _WinAPI_GetSysColorBrush($COLOR_INFOBK)
	_GUICtrlMenu_SetMenuBackground($hFile, $hBrush)
	Writeln("File menu background: 0x" & Hex(_GUICtrlMenu_GetMenuBackground($hFile)))

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
