#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	GUICreate("TreeView Expanded Once (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $aidTVi_Item[5]
	For $x = 0 To 4
		$aidTVi_Item[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
		For $y = 0 To 2
			GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $y), $aidTVi_Item[$x])
		Next
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	MsgBox($MB_SYSTEMMODAL, "Information", "Expand item 0")
	_GUICtrlTreeView_Expand($idTreeView, $aidTVi_Item[0])

	MsgBox($MB_SYSTEMMODAL, "Information", "Collapse item 0")
	_GUICtrlTreeView_Expand($idTreeView, $aidTVi_Item[0], False)

	MsgBox($MB_SYSTEMMODAL, "Information", "Item 0 expanded at least once? " & _GUICtrlTreeView_ExpandedOnce($idTreeView, $aidTVi_Item[0]))
	MsgBox($MB_SYSTEMMODAL, "Information", "Item 1 expanded at least once? " & _GUICtrlTreeView_ExpandedOnce($idTreeView, $aidTVi_Item[1]))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
