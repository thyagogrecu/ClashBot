#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiToolbar.au3>
#include <WinAPIConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Toolbar Insrt Mark HiTest (v" & @AutoItVersion & ")", 400, 300)
	Local $hToolbar = _GUICtrlToolbar_Create($hGUI)
	_MemoCreate(2, 36, 396, 262, $WS_VSCROLL)
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
	$aStrings[0] = _GUICtrlToolbar_AddString($hToolbar, "&New Button")
	$aStrings[1] = _GUICtrlToolbar_AddString($hToolbar, "&Open Button")
	$aStrings[2] = _GUICtrlToolbar_AddString($hToolbar, "&Save Button")
	$aStrings[3] = _GUICtrlToolbar_AddString($hToolbar, "&Help Button")

	; Add buttons
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idHelp
	_GUICtrlToolbar_AddButton($hToolbar, $e_idNew, $STD_FILENEW, $aStrings[0])
	_GUICtrlToolbar_AddButton($hToolbar, $e_idOpen, $STD_FILEOPEN, $aStrings[1])
	_GUICtrlToolbar_AddButton($hToolbar, $e_idSave, $STD_FILESAVE, $aStrings[2])
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idHelp, $STD_HELP, $aStrings[3])

	; Set insert mark
	_GUICtrlToolbar_SetInsertMark($hToolbar, 1, 1)

	; Do insert mark hit test 1
	Local $aMark = _GUICtrlToolbar_InsertMarkHitTest($hToolbar, 0, 0)
	_MemoWrite("Index ........: " & $aMark[0])
	_MemoWrite("Relationship .: " & $aMark[1])

	; Do insert mark hit test 2
	Local $aRect = _GUICtrlToolbar_GetButtonRect($hToolbar, $e_idSave)
	$aMark = _GUICtrlToolbar_InsertMarkHitTest($hToolbar, $aRect[0], $aRect[1])
	_MemoWrite("Index ........: " & $aMark[0])
	_MemoWrite("Relationship .: " & $aMark[1])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
