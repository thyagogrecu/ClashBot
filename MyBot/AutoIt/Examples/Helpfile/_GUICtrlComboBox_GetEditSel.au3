#include "Extras\HelpFileInternals.au3"

#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("ComboBox Get/Set Edit Sel (v" & @AutoItVersion & ")", 400, 296)
	Local $idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_BeginUpdate($idCombo)
	_GUICtrlComboBox_AddDir($idCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($idCombo)

	; Select Item
	_GUICtrlComboBox_SetCurSel($idCombo, 2)

	; Set Edit Sel
	_GUICtrlComboBox_SetEditSel($idCombo, 0, 4)

	; Get Edit Sel
	Local $aSel = _GUICtrlComboBox_GetEditSel($idCombo)
	_MemoWrite(StringFormat("Edit Sel: %d - %d", $aSel[0], $aSel[1]))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
