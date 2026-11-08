#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	GUICreate("TreeView Set Item Height (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlTreeView_SetUnicodeFormat($hTreeView, False)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $aidTVi_Item[6]
	For $x = 0 To UBound($aidTVi_Item) - 1
		$aidTVi_Item[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)
	Sleep(1000)

	_GUICtrlTreeView_SetItemHeight($idTreeView, $aidTVi_Item[2], 2)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
