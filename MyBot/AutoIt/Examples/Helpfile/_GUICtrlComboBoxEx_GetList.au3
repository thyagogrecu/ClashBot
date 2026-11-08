#include "Extras\HelpFileInternals.au3"

#include <DirConstants.au3>
#include <GuiComboBoxEx.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $hGUI, $aItem, $sDelimiter = ";", $hCombo

	Opt("GUIDataSeparatorChar", $sDelimiter)

	; Create GUI
	$hGUI = GUICreate("ComboBoxEx Get List", 400, 300)
	$hCombo = _GUICtrlComboBoxEx_Create($hGUI, "", 2, 2, 394, 100)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBoxEx_AddDir($hCombo, "", $DDL_DRIVES, False)

	; Get List
	$aItem = StringSplit(_GUICtrlComboBoxEx_GetList($hCombo), $sDelimiter)

	For $x = 1 To $aItem[0]
		_MemoWrite($aItem[$x])
	Next

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
