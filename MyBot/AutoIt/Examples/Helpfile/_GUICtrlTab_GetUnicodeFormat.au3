#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Control Get/Set Unicode Format (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2")

	; Get/Set Unicode format
	Local $bFormat = _GUICtrlTab_GetUnicodeFormat($idTab)
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Unicode format: " & $bFormat)
	_GUICtrlTab_SetUnicodeFormat($idTab, Not $bFormat)
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Unicode format: " & _GUICtrlTab_GetUnicodeFormat($idTab))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
