#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Get ItemRect - v(" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2")

	; Get tab 0 rectangle
	Local $aRect = _GUICtrlTab_GetItemRect($idTab, 0)
	Local $sRect = StringFormat("[%d, %d, %d, %d]", $aRect[0], $aRect[1], $aRect[2], $aRect[3])
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Tab 0 rectangle: " & $sRect)

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing
EndFunc   ;==>Example
