; using Standard UDF

#include "Extras\HelpFileInternals.au3"

#include <GuiEdit.au3>
#include <MsgBoxConstants.au3>

Example_External()

Func Example_External()
	Local $s_Text = 'Find And Replace Example with AutoIt ' & FileGetVersion(@AutoItExe) & @CRLF & _
			"this is a test" & @CRLF & _
			"this is only a test" & @CRLF & _
			"this testing should work for you as well as it does for me"
	Local $hTitle, $hHandle
	Local $sTitle = "[CLASS:Notepad]"

	Run("notepad.exe", "", @SW_MAXIMIZE)
	;Wait for the window "Untitled" to exist
	Local $hWnd = WinWait($sTitle)

	; Get the handle of a notepad window
	$hTitle = WinGetHandle($sTitle)
	If @error Then
		MsgBox($MB_SYSTEMMODAL, "Error", "Could not find the correct window")
	Else
		$hHandle = ControlGetHandle($hTitle, "", ControlGetFocus($hWnd))
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "Error", "Could not find the correct control")
		Else
			; Send some text directly to this window's edit control
			ControlSend($hTitle, "", ControlGetFocus($hWnd), $s_Text)
			_GUICtrlEdit_Find($hHandle, True)
		EndIf
	EndIf

	_NotepadForceClose($hWnd)
EndFunc   ;==>Example_External
