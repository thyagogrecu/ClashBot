#include <Color.au3>
#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3>
#include <WindowsStylesConstants.au3>

Global $g_idLbl_Msg, $g_hRichEdit

Example()

Func Example()
	Local $hGui, $iMsg, $idBtn_Next, $iStep = 0
	$hGui = GUICreate("Example (" & StringTrimRight(@ScriptName, StringLen(".exe")) & ")", 320, 350, -1, -1)
	$g_hRichEdit = _GUICtrlRichEdit_Create($hGui, "", 10, 10, 300, 220, _
			BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	$g_idLbl_Msg = GUICtrlCreateLabel("", 10, 235, 300, 60)
	$idBtn_Next = GUICtrlCreateButton("Next", 270, 310, 40, 30)
	GUISetState(@SW_SHOW)

	_GUICtrlRichEdit_SetText($g_hRichEdit, "Paragraph 1")
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
						_GUICtrlRichEdit_SetBkColor($g_hRichEdit, 0xE8CCCC)
						Report("1. Colored background")
					Case 2
						_GUICtrlRichEdit_SetBkColor($g_hRichEdit)
						Report("2. Back to white")
					Case 3
						_GUICtrlRichEdit_SetBkColor($g_hRichEdit, 0xB3B3C7)
						Report("3. Colored background again")
						; Stream all text to the Desktop so you can look at settings in Word
						_GUICtrlRichEdit_StreamToFile($g_hRichEdit, @DesktopDir & "\gcre.rtf")
						GUICtrlSetState($idBtn_Next, $GUI_DISABLE)
				EndSwitch
		EndSelect
	WEnd
EndFunc   ;==>Example

Func Report($sMsg)
	Local $iBngColor = _GUICtrlRichEdit_GetBkColor($g_hRichEdit)
	Local $aRet = _ColorGetRGB($iBngColor)
	$sMsg = $sMsg & @CRLF & @CRLF & $aRet[0] & ";" & $aRet[1] & ";" & $aRet[2] & " BngColor=0x" & Hex($iBngColor)
	GUICtrlSetData($g_idLbl_Msg, $sMsg)
EndFunc   ;==>Report
