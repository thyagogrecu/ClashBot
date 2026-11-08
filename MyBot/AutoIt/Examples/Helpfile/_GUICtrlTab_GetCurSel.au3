#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Get/Set Current Selected (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2")

	; Get/Set current selection
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Set Current Selection: #1")
	_GUICtrlTab_SetCurSel($idTab, 1)
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Current Selection: #" & _GUICtrlTab_GetCurSel($idTab))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
