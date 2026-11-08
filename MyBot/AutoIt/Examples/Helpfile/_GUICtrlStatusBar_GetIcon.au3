; == Example 1 use with icon handle

#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WinAPIIcons.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get/Set Icon (v" & @AutoItVersion & ")", 450, 320, 100, 100)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Set parts
	Local $aParts[4] = [75, 150, 300, 400]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 1")
	_GUICtrlStatusBar_SetText($hStatus, "Part 2", 1)

	; Set icons
	Local $ahIcons[2]
	$ahIcons[0] = _WinAPI_LoadShell32Icon(23)
	$ahIcons[1] = _WinAPI_LoadShell32Icon(40)
	_GUICtrlStatusBar_SetIcon($hStatus, 0, $ahIcons[0])
	_GUICtrlStatusBar_SetIcon($hStatus, 1, $ahIcons[1])

	; Show icon handles
	_MemoWrite("Part 0 icon handle .: 0x" & Hex(_GUICtrlStatusBar_GetIcon($hStatus, 0)))
	_MemoWrite("IsPtr = " & IsPtr(_GUICtrlStatusBar_GetIcon($hStatus, 0)) & " IsHWnd = " & IsHWnd(_GUICtrlStatusBar_GetIcon($hStatus, 0)))
	_MemoWrite("Part 1 icon handle .: 0x" & Hex(_GUICtrlStatusBar_GetIcon($hStatus, 1)))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
Until GUIGetMsg() = $GUI_EVENT_CLOSE

	; Free icons
	_WinAPI_DestroyIcon($ahIcons[0])
	_WinAPI_DestroyIcon($ahIcons[1])

	GUIDelete()
EndFunc   ;==>Example
