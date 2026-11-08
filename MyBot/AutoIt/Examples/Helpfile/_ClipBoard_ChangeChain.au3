#include "Extras\HelpFileInternals.au3"

#include <Clipboard.au3>
#include <GUIConstantsEx.au3>
#include <SendMessage.au3>
#include <WindowsNotifsConstants.au3>
#include <WindowsStylesConstants.au3>

Global $g_hNext = 0

Example()

Func Example()
	Local $hGUI

	; Create GUI
	$hGUI = GUICreate("Clipboard", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Initialize clipboard viewer
	$g_hNext = _ClipBoard_SetViewer($hGUI)

	GUIRegisterMsg($WM_CHANGECBCHAIN, "WM_CHANGECBCHAIN")
	GUIRegisterMsg($WM_DRAWCLIPBOARD, "WM_DRAWCLIPBOARD")

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	; Shut down clipboard viewer
	_ClipBoard_ChangeChain($hGUI, $g_hNext)
EndFunc   ;==>Example

; Handle $WM_CHANGECBCHAIN messages
Func WM_CHANGECBCHAIN($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg
	; Show that message was received
	_MemoWrite("***** $WM_CHANGECBCHAIN *****")

	; If the next window is closing, repair the chain
	If $wParam = $g_hNext Then
		$g_hNext = $lParam
		; Otherwise pass the message to the next viewer
	ElseIf $g_hNext <> 0 Then
		_SendMessage($g_hNext, $WM_CHANGECBCHAIN, $wParam, $lParam, 0, "hwnd", "hwnd")
	EndIf
EndFunc   ;==>WM_CHANGECBCHAIN

; Handle $WM_DRAWCLIPBOARD messages
Func WM_DRAWCLIPBOARD($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg
	; Display any text on clipboard
	_MemoWrite(_ClipBoard_GetData())

	; Pass the message to the next viewer
	If $g_hNext <> 0 Then _SendMessage($g_hNext, $WM_DRAWCLIPBOARD, $wParam, $lParam)
EndFunc   ;==>WM_DRAWCLIPBOARD
