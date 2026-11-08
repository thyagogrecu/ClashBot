#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header AddItem (v" & @AutoItVersion & ")", 450, 300, 100, 100)

	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 52, 444, 220)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 75)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 75)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 75)
	_GUICtrlHeader_AddItem($hHeader, "Column 4", 75)

	_MemoWrite("Column count: " & _GUICtrlHeader_GetItemCount($hHeader))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
