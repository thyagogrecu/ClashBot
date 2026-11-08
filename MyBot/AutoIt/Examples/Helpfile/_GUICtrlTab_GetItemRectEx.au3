#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Control Get Item RectEx (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2")

	; Get item 0 rectangle
	Local $tRECT = _GUICtrlTab_GetItemRectEx($idTab, 0)
	Local $sRect = StringFormat("[%d, %d, %d, %d]", DllStructGetData($tRECT, "Left"), _
			DllStructGetData($tRECT, "Top"), _
			DllStructGetData($tRECT, "Right"), _
			DllStructGetData($tRECT, "Bottom"))
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Display #0 rectangle: " & $sRect)

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
