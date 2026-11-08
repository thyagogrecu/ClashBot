#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiToolbar.au3>
#include <WinAPIConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Toolbar Get/Set Button Text (v" & @AutoItVersion & ")", 400, 300)
	Local $hToolbar = _GUICtrlToolbar_Create($hGUI)
	_MemoCreate(2, 60, 396, 238, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Add standard system bitmaps
	Switch _GUICtrlToolbar_GetBitmapFlags($hToolbar)
		Case 0
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_SMALL_COLOR)
		Case 2
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)
	EndSwitch

	; Add strings
	Local $aStrings[4]
	$aStrings[0] = _GUICtrlToolbar_AddString($hToolbar, "&New")
	$aStrings[1] = _GUICtrlToolbar_AddString($hToolbar, "&Open")
	$aStrings[2] = _GUICtrlToolbar_AddString($hToolbar, "&Save")
	$aStrings[3] = _GUICtrlToolbar_AddString($hToolbar, "&Help")

	; Add buttons
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idHelp
	_GUICtrlToolbar_AddButton($hToolbar, $e_idNew, $STD_FILENEW, $aStrings[0])
	_GUICtrlToolbar_AddButton($hToolbar, $e_idOpen, $STD_FILEOPEN, $aStrings[1])
	_GUICtrlToolbar_AddButton($hToolbar, $e_idSave, $STD_FILESAVE, $aStrings[2])
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idHelp, $STD_HELP, $aStrings[3])

	; Show Save button text
	_MemoWrite("Save button text: " & _GUICtrlToolbar_GetButtonText($hToolbar, $e_idSave))

	; Change Save button text
	_GUICtrlToolbar_SetButtonText($hToolbar, $e_idSave, "&Close")

	; Show Save button text
	_MemoWrite("Save button text: " & _GUICtrlToolbar_GetButtonText($hToolbar, $e_idSave))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
