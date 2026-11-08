#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3>
#include <WindowsStylesConstants.au3>

Global $g_idLbl_Msg, $g_hRichEdit

Example()

Func Example()
	Local $hGui, $iMsg, $idBtn_DoIt
	$hGui = GUICreate("Example (" & StringTrimRight(@ScriptName, StringLen(".exe")) & ")", 320, 350, -1, -1)
	$g_hRichEdit = _GUICtrlRichEdit_Create($hGui, "This is a test.", 10, 10, 300, 220, _
			BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	$g_idLbl_Msg = GUICtrlCreateLabel("", 10, 235, 300, 60)
	$idBtn_DoIt = GUICtrlCreateButton("Do it", 270, 310, 40, 30)
	GUISetState(@SW_SHOW)

	_GUICtrlRichEdit_SetSel($g_hRichEdit, 0, -1) ; select all

	While True
		$iMsg = GUIGetMsg()
		Select
			Case $iMsg = $GUI_EVENT_CLOSE
				_GUICtrlRichEdit_Destroy($g_hRichEdit) ; needed unless script crashes
				; GUIDelete() 	; is OK too
				Exit
			Case $iMsg = $idBtn_DoIt
				ChangeFontSize()
		EndSelect
	WEnd
EndFunc   ;==>Example

Func ChangeFontSize()
	Local $avArray, $iOld, $iNew
	$avArray = _GUICtrlRichEdit_GetFont($g_hRichEdit)
	$iOld = $avArray[0]
	_GUICtrlRichEdit_ChangeFontSize($g_hRichEdit, 2)
	$avArray = _GUICtrlRichEdit_GetFont($g_hRichEdit)
	$iNew = $avArray[0]
	Report("Was " & $iOld & " points; is now " & $iNew & " points")
EndFunc   ;==>ChangeFontSize

Func Report($sMsg)
	GUICtrlSetData($g_idLbl_Msg, $sMsg)
EndFunc   ;==>Report
