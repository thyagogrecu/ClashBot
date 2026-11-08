#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Get RowCount - v(" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266, 0, $TCS_MULTILINE)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	For $x = 0 To 10
		_GUICtrlTab_InsertItem($idTab, $x, "Tab " & $x)
	Next

	; Get row count
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Row count: " & _GUICtrlTab_GetRowCount($idTab))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
