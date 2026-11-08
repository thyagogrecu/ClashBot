#include "Extras\HelpFileInternals.au3"

#include <DirConstants.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $aList, $idCombo
	Opt("GUIDataSeparatorChar", ",") ; set seperator char to char we want to use

	; Create GUI
	GUICreate("ComboBox Get List", 400, 296)
	$idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_AddDir($idCombo, "", $DDL_DRIVES, False)

	; Get List
	$aList = StringSplit(_GUICtrlComboBox_GetList($idCombo), ",")
	For $x = 1 To $aList[0]
		_MemoWrite($aList[$x])
	Next

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
