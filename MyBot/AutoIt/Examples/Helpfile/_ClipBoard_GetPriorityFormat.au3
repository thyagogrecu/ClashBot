#include "Extras\HelpFileInternals.au3"

#include <Clipboard.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $aFormats[3] = [2, $CF_TEXT, $CF_OEMTEXT]

	; Create GUI
	GUICreate("Clipboard", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; See if there is any text in the clipboard
	_MemoWrite("Priority formats .:. " & _ClipBoard_GetPriorityFormat($aFormats))
	_MemoWrite("Unicode available .: " & _ClipBoard_IsFormatAvailable($CF_UNICODETEXT))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
