#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiToolbar.au3>
#include <WinAPIConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Toolbar Get/Set Color (v" & @AutoItVersion & ")", 400, 300)
	Local $hToolbar = _GUICtrlToolbar_Create($hGUI)
	_MemoCreate(2, 36, 396, 262, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlToolbar_SetUnicodeFormat($hToolbar, False)

	; Add standard system bitmaps
	Switch _GUICtrlToolbar_GetBitmapFlags($hToolbar)
		Case 0
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_SMALL_COLOR)
		Case 2
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)
	EndSwitch

	; Add buttons
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idHelp
	_GUICtrlToolbar_AddButton($hToolbar, $e_idNew, $STD_FILENEW)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idOpen, $STD_FILEOPEN)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idSave, $STD_FILESAVE)
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idHelp, $STD_HELP)

	; Change Color Scheme
	_GUICtrlToolbar_SetColorScheme($hToolbar, 0x00ffff, 0x800000)

	; Show Color Scheme
	Local $aScheme = _GUICtrlToolbar_GetColorScheme($hToolbar)
	_MemoWrite("Highlight: " & '0x' & Hex($aScheme[0], 6))
	_MemoWrite("Shadow: " & '0x' & Hex($aScheme[1], 6))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
