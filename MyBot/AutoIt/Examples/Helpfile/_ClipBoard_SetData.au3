#include "Extras\HelpFileInternals.au3"

#include <Clipboard.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $idBtn_SetData, $idBtn_GetData

	; Create GUI
	GUICreate("Clipboard", 600, 450)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	$idBtn_SetData = GUICtrlCreateButton("Set ClipBoard Data", 150, 410, 120, 30)
	$idBtn_GetData = GUICtrlCreateButton("Get ClipBoard Data", 300, 410, 120, 30)
	GUISetState(@SW_SHOW)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idBtn_SetData
				_ClipBoard_SetData("ClipBoard Library")
			Case $idBtn_GetData
				_MemoWrite(_ClipBoard_GetData())
		EndSwitch
	WEnd
EndFunc   ;==>Example
