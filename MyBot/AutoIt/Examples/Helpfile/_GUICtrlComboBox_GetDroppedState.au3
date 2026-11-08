#include "Extras\HelpFileInternals.au3"

#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $idCombo

	; Create GUI
	GUICreate("ComboBox Get Dropped Stated", 400, 296)
	$idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_BeginUpdate($idCombo)
	_GUICtrlComboBox_AddDir($idCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($idCombo)

	; get dropped state
	_MemoWrite("Dropped Down State......: " & _GUICtrlComboBox_GetDroppedState($idCombo))

	Sleep(500)

	; show drop down
	_GUICtrlComboBox_ShowDropDown($idCombo, True)

	Sleep(500)

	; get dropped state
	_MemoWrite("Dropped Down State......: " & _GUICtrlComboBox_GetDroppedState($idCombo))

	Sleep(500)

	; hide drop down
	_GUICtrlComboBox_ShowDropDown($idCombo)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
