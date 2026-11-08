#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Control HitTest (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2")

	; Do a hit test
	Local $aHit = _GUICtrlTab_HitTest($idTab, 80, 10)
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Point [80,10] is over tab " & $aHit[0])

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
