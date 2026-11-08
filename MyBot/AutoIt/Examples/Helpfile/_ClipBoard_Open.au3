#include "Extras\HelpFileInternals.au3"

#include <Clipboard.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIError.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGUI

	; Create GUI
	$hGUI = GUICreate("Clipboard", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Open the clipboard
	If _ClipBoard_Open($hGUI) Then

		ShowData($hGUI)

		; Close the clipboard
		_ClipBoard_Close()
	Else
		_WinAPI_ShowError("_ClipBoard_Open failed")
	EndIf

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Show clipboard statistics
Func ShowData($hGUI)
	_MemoWrite("GUI handle ............: " & $hGUI)
	_MemoWrite("Clipboard owner .......: " & _ClipBoard_GetOwner())
	_MemoWrite("Clipboard open window .: " & _ClipBoard_GetOpenWindow())
	_MemoWrite("Clipboard sequence ....: " & _ClipBoard_GetSequenceNumber())
	_MemoWrite()
EndFunc   ;==>ShowData
