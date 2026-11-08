#include "Extras\HelpFileInternals.au3"

#include <Clipboard.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIError.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGUI, $iFormat, $iCount

	; Create GUI
	$hGUI = GUICreate("Clipboard", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Open the clipboard
	If _ClipBoard_Open($hGUI) Then

		; Show clipboard formats available
		_MemoWrite("Clipboard formats ..: " & _ClipBoard_CountFormats())

		; Enumerate clipboard formats
		Do
			$iFormat = _ClipBoard_EnumFormats($iFormat)
			If $iFormat <> 0 Then
				$iCount += 1
				_MemoWrite("Clipboard format " & $iCount & " .: " & _ClipBoard_FormatStr($iFormat))
			EndIf
		Until $iFormat = 0

		; Close the clipboard
		_ClipBoard_Close()
	Else
		_WinAPI_ShowError("_ClipBoard_Open failed")
	EndIf

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
