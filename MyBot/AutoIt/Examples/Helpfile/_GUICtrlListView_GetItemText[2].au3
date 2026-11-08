; == Example 2 : _GUICtrlListView_SetItemText() with $iSubItem = - 1

#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	Local $idListview
	GUICreate("ListView Set Item Text", 400, 300)
	$idListview = GUICtrlCreateListView("Item        |subitem        |subitem        ", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	; Add row 0
	GUICtrlCreateListViewItem("Item 0|SubItem1|SubItem2", $idListview)
	MsgBox($MB_TOPMOST, "", "Before modifying all text at once")

	; Alter all text at once in row 0
	_GUICtrlListView_SetItemText($idListview, 0, "Item 0_alt|SubItem1_alt|SubItem2_alt", -1)
	MsgBox($MB_TOPMOST, "Parameter $iSubItem = - 1", "All text has been altered at once")

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
