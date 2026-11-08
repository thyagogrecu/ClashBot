; == Example 1 : _Ispressed using $vkey as string

#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIvkeysConstants.au3>

Local $hDLL = DllOpen("user32.dll")

While 1
	If _IsPressed("10", $hDLL) Then
		ConsoleWrite("_IsPressed - Shift Key was pressed. @extended = " & @extended & @CRLF)
		; Wait until key is released.
		While _IsPressed("10", $hDLL)
			Sleep(100)
		WEnd
		ConsoleWrite("_IsPressed - Shift Key was released. @extended = " & @extended & @CRLF)
	ElseIf _IsPressed("1B", $hDLL) Then
		ConsoleWrite("_IsPressed - Esc Key was pressed. @extended = " & @extended & @CRLF)
		MsgBox($MB_SYSTEMMODAL, "_IsPressed", "The Esc Key was pressed, therefore we will close the application.", 3)
		ExitLoop
	EndIf
	Sleep(100)
WEnd

DllClose($hDLL)
