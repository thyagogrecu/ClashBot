; == Example 2 direct use with icon file

#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WinAPIIcons.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get/Set Icon (v" & @AutoItVersion & ")", 450, 320)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)

	; Set parts
	Local $aParts[3] = [75, 150, 300] ;, 400]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 0")
	_GUICtrlStatusBar_SetText($hStatus, "Part 1", 1)

	; Set icons
	Local $hIcon1 = _GUICtrlStatusBar_SetIcon($hStatus, 0, 23, "shell32.dll")
	Local $hIcon2 = _GUICtrlStatusBar_SetIcon($hStatus, 1, 23, "shell32.dll")

	GUISetState(@SW_SHOW)

	; Show icon handles
	_MemoWrite("Part 0 icon handle .: 0x" & Hex(_GUICtrlStatusBar_GetIcon($hStatus, 0)))
	_MemoWrite("Part 1 icon handle .: 0x" & Hex(_GUICtrlStatusBar_GetIcon($hStatus, 1)))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	; Free icons
	_WinAPI_DestroyIcon($hIcon1)
	_WinAPI_DestroyIcon($hIcon2)

	GUIDelete()
EndFunc   ;==>Example
