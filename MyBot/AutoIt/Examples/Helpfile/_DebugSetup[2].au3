; == Sample 2 script using Report Notepad Window (5)

; will allow to run with old Notepad behaviour in Window 11
#RequireAdmin

#include <Debug.au3>

_DebugSetup("Check Excel", True, 5) ; Report Notepad Window
For $i = 1 To 4
	WinActivate("Microsoft Excel")
	; interact with Excel
	Send("{Down}")
	_DebugOut("Moved Mouse Down") ; forces debug notepad window to take control
Next
