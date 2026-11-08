#include <WinAPISys.au3>

Local $hWnd = _WinAPI_GetCapture()
MsgBox(0, "Mouse capture Handle", $hWnd)
