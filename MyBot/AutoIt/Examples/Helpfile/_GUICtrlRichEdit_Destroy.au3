#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGui, $iMsg, $idBtn_DoIt, $hRichEdit
	$hGui = GUICreate("Example (" & StringTrimRight(@ScriptName, StringLen(".exe")) & ")", 320, 350, -1, -1)
	$hRichEdit = _GUICtrlRichEdit_Create($hGui, "This is a test.", 10, 10, 300, 220, _
			BitOR($ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL))
	$idBtn_DoIt = GUICtrlCreateButton("Do it", 10, 260, 90, 25)

	GUISetState(@SW_SHOW)

	While True
		$iMsg = GUIGetMsg()
		Select
			Case $iMsg = $GUI_EVENT_CLOSE
				GUIDelete() ; needed unless script crashes if DoIt as not been pushed
				Exit
			Case $iMsg = $idBtn_DoIt
				_GUICtrlRichEdit_Destroy($hRichEdit)
		EndSelect
	WEnd
EndFunc   ;==>Example
