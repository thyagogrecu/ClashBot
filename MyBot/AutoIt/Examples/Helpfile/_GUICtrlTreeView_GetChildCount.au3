#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()

	GUICreate("TreeView Get Child Count (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlListView_SetUnicodeFormat($idListview, False)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $aidTVi_Item[10]
	For $x = 0 To 6
		$aidTVi_Item[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
		For $y = 0 To 3
			GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $y), $aidTVi_Item[$x])
		Next
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	Local $iRand = 3
	MsgBox($MB_SYSTEMMODAL, "Information", StringFormat("Child Count for item index %d: %d", $iRand, _GUICtrlTreeView_GetChildCount($idTreeView, $aidTVi_Item[$iRand])))
	_GUICtrlTreeView_Expand($idTreeView, $aidTVi_Item[$iRand])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
