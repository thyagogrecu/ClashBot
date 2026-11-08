#include "Extras\HelpFileInternals.au3"
#include "Extras\WM_NOTIFY.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>
#include <StructureConstants.au3>
#include <WindowsStylesConstants.au3>

Global $g_hHeader

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Edit/Get Filter (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	$g_hHeader = _GUICtrlHeader_Create($hGUI, $HDS_FILTERBAR)
	_MemoCreate(2, 52, 444, 220)

	GUISetState(@SW_SHOW)

; ANSI Format
;~ 	_GUICtrlHeader_SetUnicodeFormat($g_hHeader, False)

	; Add columns
	_GUICtrlHeader_AddItem($g_hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($g_hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($g_hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($g_hHeader, "Column 3", 100)

	; Set up filters
	_GUICtrlHeader_EditFilter($g_hHeader, 0)
	ControlSend("[ACTIVE]", "", "", "Filter 0{ENTER}")
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Filter 0 Changed")

	Local $sFilter = _GUICtrlHeader_GetFilterText($g_hHeader, 0)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sFilter = ' & $sFilter & @CRLF & '>Error code: ' & @error & '    Extended code: ' & @extended & ' (0x' & Hex(@extended) & ')' & @CRLF) ;### Debug Console

	_GUICtrlHeader_EditFilter($g_hHeader, 1)
	ControlSend("[ACTIVE]", "", "", "Filter 1{ENTER}")
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Filter 1 Changed")

	_MemoWrite("Filter Text of Column 1 : " & _GUICtrlHeader_GetFilterText($g_hHeader, 1))

	; Clear first filter
	_GUICtrlHeader_ClearFilter($g_hHeader, 0)
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Filter 0 Cleared")

	;Register WM_NOTIFY to handle $HDN_FILTERBTNCLICK messages
	_WM_NOTIFY_Register($_g_idLst_Memo)

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $tNMHDFILTERBTNCLICK

	Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	Local $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	Local $iCode = DllStructGetData($tNMHDR, "Code")
	Local $iColumn, $sText
	Switch $hWndFrom
		Case $g_hHeader
			Switch $iCode
			Case $HDN_FILTERBTNCLICK ; Notifies the header control's parent window when the filter button is clicked or in response to an $HDM_SETITEM message
					$tNMHDFILTERBTNCLICK = DllStructCreate($tagNMHDFILTERBTNCLICK, $lParam)
					$iColumn = DllStructGetData($tNMHDFILTERBTNCLICK, "Item")

					$sText = " Text = " & _GUICtrlHeader_GetFilterText($g_hHeader, $iColumn)
					_WM_NOTIFY_DebugEvent("$HDN_FILTERBTNCLICK", $tagNMHDFILTERBTNCLICK, $lParam, "IDFrom,,Item", $sText)

					;Return True  ; An $HDN_FILTERCHANGE notification will be sent to the header control's parent window
					; This notification gives the parent window an opportunity to synchronize its user interface elements
					Return False ; If you do not want the notification sent

				Case $HDN_FILTERCHANGE ; Notifies the header control's parent window that the attributes of a header control filter are being changed or edited
					$tNMHDFILTERBTNCLICK = DllStructCreate($tagNMHDFILTERBTNCLICK, $lParam)
					$iColumn = DllStructGetData($tNMHDFILTERBTNCLICK, "Item")

					$sText = " Text = " & _GUICtrlHeader_GetFilterText($g_hHeader, $iColumn)
					_WM_NOTIFY_DebugEvent("$HDN_FILTERCHANGE", $tagNMHDFILTERBTNCLICK, $lParam, "IDFrom,,Item", $sText)

					; no return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
