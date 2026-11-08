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
	If Not _ClipBoard_Open($hGUI) Then _WinAPI_ShowError("_ClipBoard_Open failed")

	; Show clipboard formats available
	_MemoWrite("Clipboard formats ..: " & _ClipBoard_CountFormats())

	; Empty the clipboard
	If Not _ClipBoard_Empty() Then _WinAPI_ShowError("_ClipBoard_Empty failed")

	; Show clipboard formats available
	_MemoWrite("Clipboard formats ..: " & _ClipBoard_CountFormats())

	; Close the clipboard
	_ClipBoard_Close()

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
