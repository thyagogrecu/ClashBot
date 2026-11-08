#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	GUICreate("TreeView Set Checked By Index (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlTreeView_SetUnicodeFormat($idTreeView, False)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $aidTVi_Item[6]
	For $x = 0 To UBound($aidTVi_Item) - 1
		$aidTVi_Item[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
		For $y = 0 To 5
			GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Child Item", $y), $aidTVi_Item[$x])
		Next
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	Local $hRandomItem = 5
	Local $iRandIndex = 4
	MsgBox($MB_SYSTEMMODAL, "Information", _
			StringFormat("Set Child Item index[%d] of Item Index[%d]: %s", $iRandIndex, $hRandomItem, _
			_GUICtrlTreeView_SetCheckedByIndex($idTreeView, $aidTVi_Item[$hRandomItem], $iRandIndex)))

	Local $hSet = _GUICtrlTreeView_GetItemByIndex($idTreeView, $aidTVi_Item[$hRandomItem], $iRandIndex)
	_GUICtrlTreeView_EnsureVisible($idTreeView, $hSet)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
