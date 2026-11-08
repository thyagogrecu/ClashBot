#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Get/Set HighlightItem - v(" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266, $TCS_BUTTONS)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2")

	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Tab Set HighlightItem tab 1")
	; Highlight tab 1
	_GUICtrlTab_HighlightItem($idTab, 1)

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
