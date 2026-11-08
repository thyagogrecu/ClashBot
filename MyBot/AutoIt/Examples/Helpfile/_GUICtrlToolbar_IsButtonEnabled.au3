#include <GUIConstantsEx.au3>
#include <GuiToolbar.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIConstants.au3>

Example()

Func Example()
	Local $hGUI, $hToolbar, $aStrings[4]
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idHelp

	; Create GUI
	$hGUI = GUICreate("Toolbar", 400, 300)
	$hToolbar = _GUICtrlToolbar_Create($hGUI)
	GUISetState(@SW_SHOW)

	; Add standard system bitmaps
	Switch _GUICtrlToolbar_GetBitmapFlags($hToolbar)
		Case 0
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_SMALL_COLOR)
		Case 2
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)
	EndSwitch

	; Add strings
	$aStrings[0] = _GUICtrlToolbar_AddString($hToolbar, "&New Button")
	$aStrings[1] = _GUICtrlToolbar_AddString($hToolbar, "&Open Button")
	$aStrings[2] = _GUICtrlToolbar_AddString($hToolbar, "&Save Button")
	$aStrings[3] = _GUICtrlToolbar_AddString($hToolbar, "&Help Button")

	; Add buttons
	_GUICtrlToolbar_AddButton($hToolbar, $e_idNew, $STD_FILENEW, $aStrings[0])
	_GUICtrlToolbar_AddButton($hToolbar, $e_idOpen, $STD_FILEOPEN, $aStrings[1])
	_GUICtrlToolbar_AddButton($hToolbar, $e_idSave, $STD_FILESAVE, $aStrings[2])
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idHelp, $STD_HELP, $aStrings[3])

	; Disable Help button
	MsgBox($MB_SYSTEMMODAL, "Information", "Help button enabled: " & _GUICtrlToolbar_IsButtonEnabled($hToolbar, $e_idHelp))
	_GUICtrlToolbar_EnableButton($hToolbar, $e_idHelp, False)
	MsgBox($MB_SYSTEMMODAL, "Information", "Help button enabled: " & _GUICtrlToolbar_IsButtonEnabled($hToolbar, $e_idHelp))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
