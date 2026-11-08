#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3>
#include <WindowsStylesConstants.au3>

Global $g_idLbl_Msg, $g_hRichEdit

Example()

Func Example()
	Local $hGui, $iMsg, $idBtn_Next, $iStep = 0
	$hGui = GUICreate("Example (" & StringTrimRight(@ScriptName, StringLen(".exe")) & ")", 320, 350, -1, -1)
	$g_hRichEdit = _GUICtrlRichEdit_Create($hGui, "This is a test.", 10, 10, 300, 220, _
			BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	$g_idLbl_Msg = GUICtrlCreateLabel("", 10, 235, 300, 60)
	$idBtn_Next = GUICtrlCreateButton("Next", 270, 310, 40, 30)
	GUISetState(@SW_SHOW)

	_GUICtrlRichEdit_SetText($g_hRichEdit, "Paragraph 1")
	_GUICtrlRichEdit_SetSel($g_hRichEdit, 0, 4)

	While True
		$iMsg = GUIGetMsg()
		Select
			Case $iMsg = $GUI_EVENT_CLOSE
				_GUICtrlRichEdit_Destroy($g_hRichEdit) ; needed unless script crashes
				; GUIDelete() 	; is OK too
				Exit
			Case $iMsg = $idBtn_Next
				$iStep += 1
				Switch $iStep
					Case 1
						Report("Selected text is" & @CRLF & _GUICtrlRichEdit_GetSelText($g_hRichEdit))
						GUICtrlSetState($idBtn_Next, $GUI_DISABLE)
				EndSwitch
		EndSelect
	WEnd
EndFunc   ;==>Example

Func Report($sMsg)
	Local $aRet = _GUICtrlRichEdit_GetSelAA($g_hRichEdit)
	$sMsg = $sMsg & @CRLF & @CRLF & "Get function returns " & $aRet[0] & "," & $aRet[1]
	GUICtrlSetData($g_idLbl_Msg, $sMsg)
EndFunc   ;==>Report
