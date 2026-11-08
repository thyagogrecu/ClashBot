#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>

Global $g_hWnd

Example()

Func Example()
	Local $aInfo

	; Open Notepad
	Run("notepad.exe")
	$g_hWnd = WinWaitActive("[CLASS:Notepad]")

	; Get menu bar info
	$aInfo = _GUICtrlMenu_GetMenuBarInfo($g_hWnd)
	Writeln("Left ............: " & $aInfo[0])
	Writeln("Top .............: " & $aInfo[1])
	Writeln("Right ...........: " & $aInfo[2])
	Writeln("Bottom ..........: " & $aInfo[3])
	Writeln("Menu handle .....: 0x" & Hex($aInfo[4]))
	Writeln("Submenu Handle ..: 0x" & Hex($aInfo[5]))
	Writeln("Menu bar focused : " & $aInfo[6])
	Writeln("Menu item focused: " & $aInfo[7])

	_NotepadForceClose($g_hWnd)
EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
