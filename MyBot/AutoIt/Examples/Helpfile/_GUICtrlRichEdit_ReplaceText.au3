#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGui = GUICreate("RichEdit Replace Text (v" & @AutoItVersion & ")", 340, 350, -1, -1)
	Local $hRichEdit = _GUICtrlRichEdit_Create($hGui, "This is a test.", 10, 10, 320, 220, _
			BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	Local $idLbl_Msg = GUICtrlCreateLabel("", 10, 235, 300, 60)
	Local $idBtn_Next = GUICtrlCreateButton("Next", 270, 310, 40, 30)
	GUISetState(@SW_SHOW)

	_GUICtrlRichEdit_SetText($hRichEdit, "First paragraph")
	Local $iMsg, $iStep = 0
	While True
		$iMsg = GUIGetMsg()
		Select
			Case $iMsg = $GUI_EVENT_CLOSE
				_GUICtrlRichEdit_Destroy($hRichEdit) ; needed unless script crashes
				; GUIDelete() 	; is OK too
				Exit
			Case $iMsg = $idBtn_Next
				$iStep += 1
				Switch $iStep
					Case 1
						_GUICtrlRichEdit_SetSel($hRichEdit, 0, 5)
					Case 2
						_GUICtrlRichEdit_ReplaceText($hRichEdit, "1st")
						GUICtrlSetData($idLbl_Msg, "Text has been replaced")
					Case 3
						_GUICtrlRichEdit_SetSel($hRichEdit, 0, 3)
						_GUICtrlRichEdit_ReplaceText($hRichEdit, "")
						GUICtrlSetData($idLbl_Msg, "1st has been deleted")
						GUICtrlSetState($idBtn_Next, $GUI_DISABLE)
				EndSwitch
		EndSelect
	WEnd
EndFunc   ;==>Example
