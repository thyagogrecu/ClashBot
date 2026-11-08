#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	GUICreate("TreeView Get/Set Bold (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $aidTVi_Item[6], $hRandomItem
	For $x = 0 To UBound($aidTVi_Item) - 1
		$aidTVi_Item[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	$hRandomItem = Random(0, UBound($aidTVi_Item) - 1, 1)
	MsgBox($MB_SYSTEMMODAL, "Information", StringFormat("Item %d Bold? %s", $hRandomItem, _GUICtrlTreeView_GetBold($idTreeView, $aidTVi_Item[$hRandomItem])))
	_GUICtrlTreeView_SetBold($idTreeView, $aidTVi_Item[$hRandomItem])
	MsgBox($MB_SYSTEMMODAL, "Information", StringFormat("Item %d Bold? %s", $hRandomItem, _GUICtrlTreeView_GetBold($idTreeView, $aidTVi_Item[$hRandomItem])))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
