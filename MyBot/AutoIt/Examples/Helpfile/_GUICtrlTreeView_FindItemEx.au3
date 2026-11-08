#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	GUICreate("TreeView Find ItemEx (v" & @AutoItVersion & ")", 400, 300)
	Opt("GUIDataSeparatorChar", "\")

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlTreeView_SetUnicodeFormat($idTreeView, False)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $aidTVi_Item[10], $idTVi_Tmp
	For $x = 0 To 3
		$aidTVi_Item[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
		For $y = 0 To 2
			$idTVi_Tmp = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $y), $aidTVi_Item[$x])
		Next
	Next
	$aidTVi_Item[4] = GUICtrlCreateTreeViewItem(StringFormat("Looking for me?", $x), $idTVi_Tmp)
	For $x = 5 To 9
		$aidTVi_Item[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
		For $y = 0 To 2
			GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $y), $aidTVi_Item[$x])
		Next
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	Local $hItemFound = _GUICtrlTreeView_FindItemEx($idTreeView, "[03] New Item\[02] New Item\Looking for me?")
	If $hItemFound Then
		_GUICtrlTreeView_SelectItem($idTreeView, $hItemFound)
		MsgBox($MB_SYSTEMMODAL, "Information", "Item Found:" & @CRLF & "Handle: " & $hItemFound & @CRLF & "Text: " & _GUICtrlTreeView_GetText($idTreeView, $hItemFound))
	Else
		MsgBox($MB_SYSTEMMODAL, "Information", "Not Found")
	EndIf

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
