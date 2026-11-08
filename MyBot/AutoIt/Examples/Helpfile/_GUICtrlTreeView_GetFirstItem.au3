#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)

	GUICreate("TreeView Get First Item (v" & @AutoItVersion & ")", 400, 300)

	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $idTVi_Item
	For $x = 0 To 6
		$idTVi_Item = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
		For $y = 0 To 2
			GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $y), $idTVi_Item)
		Next
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	Local $hFirst = _GUICtrlTreeView_GetFirstItem($idTreeView)
	MsgBox($MB_SYSTEMMODAL, "Information", "The handle of the first item: " & $hFirst)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
