; == Example Created with UDF

#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Get/Set Item Param (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hTab = _GUICtrlTab_Create($hGUI, 2, 2, 446, 266)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($hTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($hTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($hTab, 2, "Tab 2")

	; Get/Set tab 0 parameter
	_GUICtrlTab_SetItemParam($hTab, 0, 1234)
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Tab 0 parameter: " & _GUICtrlTab_GetItemParam($hTab, 0))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
