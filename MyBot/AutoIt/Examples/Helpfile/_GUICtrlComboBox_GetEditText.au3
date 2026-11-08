#include "Extras\HelpFileInternals.au3"

#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("ComboBox Get/Set Edit Text (v" & @AutoItVersion & ")", 400, 296)
	Local $idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_BeginUpdate($idCombo)
	_GUICtrlComboBox_AddDir($idCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($idCombo)

	; Set Edit Text
	_GUICtrlComboBox_SetEditText($idCombo, StringFormat("%d - Some New Text", Random(1, 20, 1)))

	; Get Edit Text
	_MemoWrite("Edit Text: " & _GUICtrlComboBox_GetEditText($idCombo))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
