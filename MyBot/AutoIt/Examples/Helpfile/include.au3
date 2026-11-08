#include "include-TIME.au3"

#include <MsgBoxConstants.au3>

; Running "include.au3" will output two message boxes:
; one with the time, followed by one with 'Example'

MsgBox($MB_SYSTEMMODAL, "MsgBox #2", "Example")

Exit
