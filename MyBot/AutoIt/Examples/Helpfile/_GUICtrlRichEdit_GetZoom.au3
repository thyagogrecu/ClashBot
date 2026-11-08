#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3>
#include <WindowsStylesConstants.au3>

Global $g_idLbl_Msg

Example()

Func Example()
	Local $hGui = GUICreate("RichEdit Get/Set Zoom (v" & @AutoItVersion & ")", 360, 350, -1, -1)
	Local $hRichEdit = _GUICtrlRichEdit_Create($hGui, "This is a test.", 10, 10, 340, 220, _
			BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	$g_idLbl_Msg = GUICtrlCreateLabel("", 10, 235, 300, 60)
	Local $idBtn_Next = GUICtrlCreateButton("Next", 270, 310, 40, 30)
	GUISetState(@SW_SHOW)

	_GUICtrlRichEdit_AppendText($hRichEdit, @CRLF & "This is appended text.")

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
						Report("1.Now zoomed to " & _GUICtrlRichEdit_GetZoom($hRichEdit) & "%")
					Case 2
						_GUICtrlRichEdit_SetZoom($hRichEdit, 6369) ; Max
						Report("2.Now zoomed to " & _GUICtrlRichEdit_GetZoom($hRichEdit) & "% Maximum value")
					Case 3
						_GUICtrlRichEdit_SetZoom($hRichEdit, 1.57) ; Min
						Report("3.Now zoomed to " & _GUICtrlRichEdit_GetZoom($hRichEdit) & "% Minimum value")
					Case 4
						_GUICtrlRichEdit_SetZoom($hRichEdit, 100)
						Report("4.Now zoomed reset to " & _GUICtrlRichEdit_GetZoom($hRichEdit) & "%")
						GUICtrlSetState($idBtn_Next, $GUI_DISABLE)
				EndSwitch
		EndSelect
	WEnd
EndFunc   ;==>Example

Func Report($sMsg)
	GUICtrlSetData($g_idLbl_Msg, $sMsg)
EndFunc   ;==>Report
