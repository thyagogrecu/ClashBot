#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get ItemRect (v" & @AutoItVersion & ")", 450, 300, 100, 100)

	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 52, 444, 220)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Show column 1 rectangle
	Local $aRect = _GUICtrlHeader_GetItemRect($hHeader, 0)
	_MemoWrite("Column 0 left .: " & $aRect[0])
	_MemoWrite("Column 0 top ..: " & $aRect[1])
	_MemoWrite("Column 0 right : " & $aRect[2])
	_MemoWrite("Column 0 bottom: " & $aRect[3])

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
