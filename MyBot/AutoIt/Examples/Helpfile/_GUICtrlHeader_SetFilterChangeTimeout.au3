#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>
#include <HeaderConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Set Filter ChangeTimeout (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hHeader = _GUICtrlHeader_Create($hGUI, $HDS_FILTERBAR)
	_MemoCreate(2, 52, 444, 220)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Set filter change timeout
	_GUICtrlHeader_SetFilterChangeTimeout($hHeader, 3000)

	; Set up filters
	_GUICtrlHeader_EditFilter($hHeader, 0)
	ControlSend("[ACTIVE]", "", "", "Filter 0{ENTER}")
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Filter 0 Changed")

	_GUICtrlHeader_EditFilter($hHeader, 1)
	ControlSend("[ACTIVE]", "", "", "Filter 1{ENTER}")
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Filter 1 Changed")

	_MemoMsgBoxStatus("", Default, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
