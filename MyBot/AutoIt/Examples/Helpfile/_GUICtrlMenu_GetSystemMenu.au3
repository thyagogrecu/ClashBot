#include "Extras\HelpFileInternals.au3"

#include <GuiMenu.au3>

Global $g_hWnd

Example()

Func Example()
	Local $hMenu, $iCount, $iI

	; Open Notepad
	Run("notepad.exe")
	$g_hWnd = WinWaitActive("[CLASS:Notepad]")
	$hMenu = _GUICtrlMenu_GetSystemMenu($g_hWnd)

	; Play with system menu
	_GUICtrlMenu_InsertMenuItem($hMenu, 5, "&AutoIt")

	; Display system menu
	$iCount = _GUICtrlMenu_GetItemCount($hMenu)
	Writeln("System menu handle: 0x" & Hex($hMenu))
	Writeln("Item count .......: " & $iCount)
	For $iI = 0 To $iCount - 1
		Writeln("Item " & $iI & " text ......: " & _GUICtrlMenu_GetItemText($hMenu, $iI))
	Next

	_NotepadForceClose($g_hWnd)

EndFunc   ;==>Example

; Write a line of text to Notepad
Func Writeln($sText, $hWnd = $g_hWnd)
	ControlSend($hWnd, "", ControlGetFocus($hWnd), $sText & @CRLF)
EndFunc   ;==>Writeln
