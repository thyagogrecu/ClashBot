#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>
#include <GuiImageList.au3>
#include <WinAPIGdi.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get/Set ItemImage (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 52, 444, 220)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Create an image list with images
	Local $hImage = _GUIImageList_Create(11, 11)
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0xFF0000, 11, 11))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x00FF00, 11, 11))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x0000FF, 11, 11))
	_GUICtrlHeader_SetImageList($hHeader, $hImage)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100, 0, 0)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100, 0, 1)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100, 0, 2)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Show column 0 image
	_MemoWrite("Column 0 image: " & _GUICtrlHeader_GetItemImage($hHeader, 0))

	Sleep(1000)

	; Set column 0 image
	_GUICtrlHeader_SetItemImage($hHeader, 0, 2)

	; Show column 0 image
	_MemoWrite("Column 0 image: " & _GUICtrlHeader_GetItemImage($hHeader, 0))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
