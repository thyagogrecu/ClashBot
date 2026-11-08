#include "Extras\HelpFileInternals.au3"

#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

; Note the controlID from these button(s) can NOT be read with GUICtrlRead.

Example()

Func Example()
	Local $hGUI = GUICreate("Button Get/Set Note (v" & @AutoItVersion & ")", 400, 400)
	_MemoCreate(10, 75, 390, 315, $WS_VSCROLL)

	Local $hButton = _GUICtrlButton_Create($hGUI, "Button1", 10, 10, 160, 60, BitOR($BS_COMMANDLINK, $BS_DEFCOMMANDLINK))
	_GUICtrlButton_SetNote($hButton, "This is a test of Vista")

	GUISetState(@SW_SHOW)

	_MemoWrite("Note: " & _GUICtrlButton_GetNote($hButton))
	_MemoWrite("Note Length: " & _GUICtrlButton_GetNoteLength($hButton))
	_MemoWrite("Button Text: " & _GUICtrlButton_GetText($hButton))

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example
