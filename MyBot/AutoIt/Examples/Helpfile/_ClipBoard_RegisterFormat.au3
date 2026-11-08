#include "Extras\HelpFileInternals.au3"

#include <Clipboard.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIError.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $iFormat

	; Create GUI
	GUICreate("Clipboard", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Register a new clipboard format
	$iFormat = _ClipBoard_RegisterFormat("AutoIt Library Text")
	If $iFormat <> 0 Then

		; Show new format
		_MemoWrite(_ClipBoard_GetFormatName($iFormat))
	Else
		_WinAPI_ShowError("_ClipBoard_RegisterFormat failed")
	EndIf

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
