#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	GUICreate("TreeView Get/Set Children (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlListView_SetUnicodeFormat($idListview, False)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $aidTVi_Item[5], $iY = 0
	For $x = 0 To 3
		$aidTVi_Item[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] Item", $x), $idTreeView)
		For $y = 0 To 2
			$iY += 1
			GUICtrlCreateTreeViewItem(StringFormat("[%02d] Child", $iY), $aidTVi_Item[$x])
		Next
	Next
	$aidTVi_Item[4] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] Item no Child", 4), $idTreeView)
	_GUICtrlTreeView_EndUpdate($idTreeView)

	MsgBox($MB_SYSTEMMODAL, "Information", "Item 0 has Children? " & _GUICtrlTreeView_GetChildren($idTreeView, $aidTVi_Item[0]) & ", nb children = " & @extended)
	MsgBox($MB_SYSTEMMODAL, "Information", "Item 4 has Children? " & _GUICtrlTreeView_GetChildren($idTreeView, $aidTVi_Item[4]) & ", nb children = " & @extended)

	MsgBox($MB_SYSTEMMODAL, "Set Children", "Item 0 ? " & _GUICtrlTreeView_SetChildren($idTreeView, $aidTVi_Item[0]) & ", nb children = " & @extended)
	MsgBox($MB_SYSTEMMODAL, "Set Children", "Item 4 ? " & _GUICtrlTreeView_SetChildren($idTreeView, $aidTVi_Item[4]) & ", nb children = " & @extended)

	MsgBox($MB_SYSTEMMODAL, "Reset Children", "Item 0 ? " & _GUICtrlTreeView_SetChildren($idTreeView, $aidTVi_Item[0], False) & ", nb children = " & @extended)
	MsgBox($MB_SYSTEMMODAL, "Reset Children", "Item 4 ? " & _GUICtrlTreeView_SetChildren($idTreeView, $aidTVi_Item[4], False) & ", nb children = " & @extended)

	MsgBox($MB_SYSTEMMODAL, "Information", "Item 0 has Children? " & _GUICtrlTreeView_GetChildren($idTreeView, $aidTVi_Item[0]) & ", nb children = " & @extended)
	MsgBox($MB_SYSTEMMODAL, "Information", "Item 4 has Children? " & _GUICtrlTreeView_GetChildren($idTreeView, $aidTVi_Item[4]) & ", nb children = " & @extended)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
