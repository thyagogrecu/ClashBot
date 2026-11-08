#include "Extras\HelpFileInternals.au3"

#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $tInfo, $idCombo

	; Create GUI
	GUICreate("ComboBox Get ComboBox Info", 400, 296)
	$idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_BeginUpdate($idCombo)
	_GUICtrlComboBox_AddDir($idCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($idCombo)

	If _GUICtrlComboBox_GetComboBoxInfo($idCombo, $tInfo) Then
		_MemoWrite("Handle to the ComboBox .....: " & DllStructGetData($tInfo, "hCombo"))
		_MemoWrite("Handle to the Edit Box .....: " & DllStructGetData($tInfo, "hEdit"))
		_MemoWrite("Handle to the drop-down list: " & DllStructGetData($tInfo, "hList"))
	EndIf

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
