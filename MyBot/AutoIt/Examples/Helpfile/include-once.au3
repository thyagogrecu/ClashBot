; Use #include-once when creating UDFs so the file isn't included multiple times
; if you call the same UDF in multiple files.

#include-once

#include <MsgBoxConstants.au3>

; Add #include "Include-once.au3" at the top of your script.
; Then your script can call IncludeFunc().
; The execution will display a MsgBox.

Func IncludeFunc()
	MsgBox($MB_SYSTEMMODAL, "", "This is an example of including a file.")
EndFunc   ;==>IncludeFunc
