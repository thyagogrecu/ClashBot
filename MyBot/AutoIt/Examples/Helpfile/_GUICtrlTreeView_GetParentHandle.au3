#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	GUICreate("TreeView Get Parent Handle (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlTreeView_SetUnicodeFormat($idTreeView, False)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $idTVi_Item, $idTVi_Child
	For $x = 0 To 10
		$idTVi_Item = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
		_GUICtrlTreeView_GetItemHandle($idTreeView, $idTVi_Item)
		For $y = 0 To 2
			$idTVi_Child = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $y), $idTVi_Item)
		Next
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	_GUICtrlTreeView_SelectItem($idTreeView, $idTVi_Child)
	MsgBox($MB_SYSTEMMODAL, "Information", "Parent Handle: " & _GUICtrlTreeView_GetParentHandle($idTreeView, $idTVi_Child))
	_GUICtrlTreeView_SelectItem($idTreeView, _GUICtrlTreeView_GetParentHandle($idTreeView, $idTVi_Child))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
