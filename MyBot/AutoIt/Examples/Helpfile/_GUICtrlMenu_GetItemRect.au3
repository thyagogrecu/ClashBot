#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>

Global $g_hWnd

Example()

Func Example()
	Local $hMain, $aRect

	; Open Notepad
	Run("notepad.exe")
	$g_hWnd = WinWaitActive("[CLASS:Notepad]")
	$hMain = _GUICtrlMenu_GetMenu($g_hWnd)

	; Get File menu rectangle
	$aRect = _GUICtrlMenu_GetItemRect($g_hWnd, $hMain, 0)

	Writeln("File X1: " & $aRect[0])
	Writeln("File Y1: " & $aRect[1])
	Writeln("File X2: " & $aRect[2])
	Writeln("File Y2: " & $aRect[3])

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
