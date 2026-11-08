#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get Text Flags (v" & @AutoItVersion & ")", 450, 320, 100, 100)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Set parts
	Local $aParts[3] = [75, 150, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 0", 0, $SBT_POPOUT)
	_GUICtrlStatusBar_SetText($hStatus, "Part 1", 1, $SBT_NOBORDERS)
	_GUICtrlStatusBar_SetText($hStatus, "Part 2", 2, $SBT_NOTABPARSING)

	; Get text information
	For $iI = 0 To _GUICtrlStatusBar_GetCount($hStatus) - 1
		_MemoWrite("Part " & $iI & " text flags ..: 0x" & Hex(_GUICtrlStatusBar_GetTextFlags($hStatus, $iI)))
		_MemoWrite("Part " & $iI & " text length .: " & _GUICtrlStatusBar_GetTextLength($hStatus, $iI))
		_MemoWrite("Part " & $iI & " drawing type : 0x" & Hex(_GUICtrlStatusBar_GetTextLengthEx($hStatus, $iI)))
		_MemoWrite()
	Next

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
