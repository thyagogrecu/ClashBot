#include "Extras\HelpFileInternals.au3"

#include <DirConstants.au3>
#include <GuiComboBoxEx.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $hGUI, $aItem, $hCombo

	; Create GUI
	$hGUI = GUICreate("ComboBoxEx Get List Array", 400, 300)
	$hCombo = _GUICtrlComboBoxEx_Create($hGUI, "", 2, 2, 394, 100)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBoxEx_AddDir($hCombo, "", $DDL_DRIVES, False)

	; Get List
	$aItem = _GUICtrlComboBoxEx_GetListArray($hCombo)

	For $x = 1 To $aItem[0]
		_MemoWrite($aItem[$x])
	Next

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
