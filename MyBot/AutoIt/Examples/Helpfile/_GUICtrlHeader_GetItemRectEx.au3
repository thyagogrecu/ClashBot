#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get Item RectEx (v" & @AutoItVersion & ")", 450, 300, 100, 100)
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
	Local $tRECT = _GUICtrlHeader_GetItemRectEx($hHeader, 0)
	_MemoWrite("Column 0 left .: " & DllStructGetData($tRECT, "Left"))
	_MemoWrite("Column 0 top ..: " & DllStructGetData($tRECT, "Top"))
	_MemoWrite("Column 0 right : " & DllStructGetData($tRECT, "Right"))
	_MemoWrite("Column 0 bottom: " & DllStructGetData($tRECT, "Bottom"))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
