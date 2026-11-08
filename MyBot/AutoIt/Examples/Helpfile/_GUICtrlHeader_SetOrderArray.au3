#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get/Set Order Array (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 52, 444, 220)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Set order array
	Local $aOrder[5] = [4, 3, 1, 2, 0]
	_GUICtrlHeader_SetOrderArray($hHeader, $aOrder)

	; Show order array
	$aOrder = _GUICtrlHeader_GetOrderArray($hHeader)
	For $iI = 1 To $aOrder[0]
		_MemoWrite("Index: " & $iI - 1 & ", Order: " & $aOrder[$iI] & ' (' & _GUICtrlHeader_GetItemText($hHeader, $iI - 1) & ')')
	Next

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
