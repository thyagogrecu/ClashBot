#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIGdi.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Control Set Padding - v(" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Create images
	Local $hImage = _GUIImageList_Create()
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0xFF0000, 16, 16))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x00FF00, 16, 16))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x0000FF, 16, 16))
	_GUICtrlTab_SetImageList($idTab, $hImage)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0", 0)
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1", 1)
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2", 2)
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Set Padding")

	_GUICtrlTab_DeleteAllItems($idTab)
	_GUICtrlTab_SetPadding($idTab, 20, 4)
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0", 0)
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1", 1)
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2", 2)

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
