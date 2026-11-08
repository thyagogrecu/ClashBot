#include "Extras\HelpFileInternals.au3"

#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $tRECT, $idCombo

	; Create GUI
	GUICreate("ComboBox Get Dropped Control RectEx", 400, 296)
	$idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_BeginUpdate($idCombo)
	_GUICtrlComboBox_AddDir($idCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($idCombo)

	; Get Dropped Control Rect
	$tRECT = _GUICtrlComboBox_GetDroppedControlRectEx($idCombo)

	_MemoWrite("X coordinate of the upper left corner ......: " & DllStructGetData($tRECT, "Left"))
	_MemoWrite("Y coordinate of the upper left corner ......: " & DllStructGetData($tRECT, "Top"))
	_MemoWrite("X coordinate of the lower right corner .....: " & DllStructGetData($tRECT, "Right"))
	_MemoWrite("Y coordinate of the lower right corner .....: " & DllStructGetData($tRECT, "Bottom"))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
