#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiMenu.au3>
#include <GuiToolbar.au3>
#include <StructureConstants.au3>
#include <WinAPIConstants.au3>
#include <WindowsNotifsConstants.au3>
#include <WindowsStylesConstants.au3>

Global $g_hGUI

Example()

Func Example()
	Local $hToolbar
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idHelp

	; Create GUI
	$g_hGUI = GUICreate("Toolbar", 400, 300)
	$hToolbar = _GUICtrlToolbar_Create($g_hGUI)
	_GUICtrlToolbar_SetExtendedStyle($hToolbar, $TBSTYLE_EX_DRAWDDARROWS)
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
	_GUICtrlToolbar_AddButton($hToolbar, $e_idNew, $STD_FILENEW, 0, $BTNS_DROPDOWN)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idOpen, $STD_FILEOPEN)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idSave, $STD_FILESAVE)
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idHelp, $STD_HELP)

	; Show extended styles in use
	_MemoWrite("Extended sytles: " & _GUICtrlToolbar_GetExtendedStyle($hToolbar))

	GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Handle TBN_DROPDOWN message
Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $tNMHDR, $iCode, $hMenu

	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$iCode = DllStructGetData($tNMHDR, "Code")

	If $iCode = $TBN_DROPDOWN Then
		$hMenu = _GUICtrlMenu_CreatePopup()
		_GUICtrlMenu_AddMenuItem($hMenu, "Template 1", 2000)
		_GUICtrlMenu_AddMenuItem($hMenu, "Template 2", 2001)
		_GUICtrlMenu_AddMenuItem($hMenu, "Template 3", 2002)
		_GUICtrlMenu_TrackPopupMenu($hMenu, $g_hGUI)
		_GUICtrlMenu_DestroyMenu($hMenu)
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
