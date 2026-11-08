#include "Extras\HelpFileInternals.au3"

#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("ComboBox Get/Set Item Height (v" & @AutoItVersion & ")", 400, 296)
	Local $idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_BeginUpdate($idCombo)
	_GUICtrlComboBox_AddDir($idCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($idCombo)

	; Get Item Height (selection field)
	_MemoWrite("Item Height (selection field): " & _GUICtrlComboBox_GetItemHeight($idCombo))

	; Get Item Height (list items)
	_MemoWrite("Item Height (list items): " & _GUICtrlComboBox_GetItemHeight($idCombo, 0))

	; Set Item Height (selection field)
	_GUICtrlComboBox_SetItemHeight($idCombo, 18)

	; Set Item Height (selection field)
	_GUICtrlComboBox_SetItemHeight($idCombo, 20, 0)

	; Get Item Height (selection field)
	_MemoWrite("Item Height (selection field): " & _GUICtrlComboBox_GetItemHeight($idCombo))

	; Get Item Height (list items)
	_MemoWrite("Item Height (list items): " & _GUICtrlComboBox_GetItemHeight($idCombo, 0))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
