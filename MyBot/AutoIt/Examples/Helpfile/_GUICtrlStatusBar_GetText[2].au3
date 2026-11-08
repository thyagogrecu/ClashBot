; == Example 2 : direct use with icon file

#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get/Set Text (v" & @AutoItVersion & ")", 450, 320, 100, 100)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Set parts
	Local $aParts[4] = [75, 150, 300, 400]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 0")
	_GUICtrlStatusBar_SetText($hStatus, "Part 1", 1)
	_GUICtrlStatusBar_SetText($hStatus, "Part 2", 2)
	_GUICtrlStatusBar_SetText($hStatus, "Part 3", 3)

	; Set icons
	_GUICtrlStatusBar_SetIcon($hStatus, 0, 23, "shell32.dll")
	_GUICtrlStatusBar_SetIcon($hStatus, 1, 40, "shell32.dll")

	; Show part text
	_MemoWrite("Part 0 text ........: " & _GUICtrlStatusBar_GetText($hStatus, 0))
	_MemoWrite("Part 1 text ........: " & _GUICtrlStatusBar_GetText($hStatus, 1))

	; Show icon handles
	_MemoWrite("Part 0 icon handle .: 0x" & Hex(_GUICtrlStatusBar_GetIcon($hStatus, 0)))
	_MemoWrite("Part 1 icon handle .: 0x" & Hex(_GUICtrlStatusBar_GetIcon($hStatus, 1)))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
