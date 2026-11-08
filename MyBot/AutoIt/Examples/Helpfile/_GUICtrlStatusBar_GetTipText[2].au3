; == Example 2 direct use with icon file

#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get/Set Tip Text (v" & @AutoItVersion & ")", 450, 320, 100, 100)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI, -1, "", $SBARS_TOOLTIPS)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)
	GUISetState(@SW_SHOW)

	; Set parts
	Local $aParts[4] = [75, 150, 300, 400]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Force tip to be shown when text is more than fits in the box", 1)

	; Set icon
	_GUICtrlStatusBar_SetIcon($hStatus, 0, 23, "shell32.dll")

	; Set text tips
	_GUICtrlStatusBar_SetTipText($hStatus, 0, "Tip works when only icon in part or text exceeds part")
	_GUICtrlStatusBar_SetTipText($hStatus, 1, "Force tip to be shown when text is more than fits in the box")

	_MemoWrite("Hold Mouse Cursor over part to see tip." & @CRLF)

	; Show text tips
	_MemoWrite("Text tip 0 .: " & _GUICtrlStatusBar_GetTipText($hStatus, 0) & @CRLF)
	_MemoWrite("Text tip 1 .: " & _GUICtrlStatusBar_GetTipText($hStatus, 1))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
