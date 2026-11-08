#include "Extras\HelpFileInternals.au3"

#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

; Note: The handle from these button(s) can NOT be read with GUICtrlRead

Example()

Func Example()
	Local $hGUI

	$hGUI = GUICreate("Buttons", 400, 400)
	_MemoCreate(10, 65, 390, 325, $WS_VSCROLL)

	Local $hBtn = _GUICtrlButton_Create($hGUI, "Button1", 10, 10, 160, 40, BitOR($BS_COMMANDLINK, $BS_DEFPUSHBUTTON, $BS_PUSHLIKE))
	_GUICtrlButton_SetNote($hBtn, "This is a test of Vista")

	GUISetState(@SW_SHOW)

	_MemoWrite("Note: " & _GUICtrlButton_GetNote($hBtn))
	_MemoWrite("Note Length: " & _GUICtrlButton_GetNoteLength($hBtn))
	_MemoWrite("Button Text: " & _GUICtrlButton_GetText($hBtn))

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example
