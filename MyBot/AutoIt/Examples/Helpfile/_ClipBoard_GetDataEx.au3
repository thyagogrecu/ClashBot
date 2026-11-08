; == Example 1 use _ClipBoard_SetData()

#include "Extras\HelpFileInternals.au3"

#include <Clipboard.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIError.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Clipboard Get/Set DataEx (v" & @AutoItVersion & ")", 600, 450)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	Local $idBtn_SetData = GUICtrlCreateButton("Set ClipBoard Data", 150, 410, 120, 30)
	Local $idBtn_GetData = GUICtrlCreateButton("Get ClipBoard Data", 300, 410, 120, 30)
	GUISetState(@SW_SHOW)

	; Loop until the user exits.
	Local $hMemory, $tData
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idBtn_SetData
				_ClipBoard_SetData("ClipBoard Library")
			Case $idBtn_GetData
				; Open the clipboard
				If _ClipBoard_Open($hGUI) Then

					; Read clipboard text
					$hMemory = _ClipBoard_GetDataEx($CF_TEXT)
					If $hMemory = 0 Then _WinAPI_ShowError("_ClipBoard_GetDataEx failed")
					$tData = DllStructCreate("char Text[8192]", $hMemory)
					_MemoWrite(DllStructGetData($tData, "Text"))

					; Close the clipboard
					_ClipBoard_Close()
				Else
					_WinAPI_ShowError("_ClipBoard_Open failed")
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Example
