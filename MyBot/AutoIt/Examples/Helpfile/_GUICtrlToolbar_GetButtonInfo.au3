#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiToolbar.au3>
#include <WinAPIConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGUI, $hToolbar, $aButton
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idHelp

	; Create GUI
	$hGUI = GUICreate("Toolbar", 400, 300)
	$hToolbar = _GUICtrlToolbar_Create($hGUI)
	_MemoCreate(2, 36, 396, 262, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Add standard system bitmaps
	Switch _GUICtrlToolbar_GetBitmapFlags($hToolbar)
		Case 0
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_SMALL_COLOR)
		Case 2
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)
	EndSwitch

	; Add buttons
	_GUICtrlToolbar_AddButton($hToolbar, $e_idNew, $STD_FILENEW)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idOpen, $STD_FILEOPEN)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idSave, $STD_FILESAVE)
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idHelp, $STD_HELP)

	; Set Save button information
	_GUICtrlToolbar_SetButtonInfo($hToolbar, $e_idSave, $STD_PRINT, BitOR($TBSTATE_PRESSED, $TBSTATE_ENABLED), -1, 100, 1234)

	; Show Save button information
	$aButton = _GUICtrlToolbar_GetButtonInfo($hToolbar, $e_idSave)
	_MemoWrite("Image index ....: " & $aButton[0])
	_MemoWrite("State flags ....: " & $aButton[1])
	_MemoWrite("Style flags ....: " & $aButton[2])
	_MemoWrite("Button width ...: " & $aButton[3])
	_MemoWrite("Param ..........: " & $aButton[4])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
