#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>
#include <GuiImageList.au3>
#include <WinAPIGdi.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get/Set ItemDisplay (v" & @AutoItVersion & ")", 450, 300, 100, 100)
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
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100, 0)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100, 0, 1)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100, 0, 2)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Set column 0 bitmap
	_GUICtrlHeader_SetItemBitmap($hHeader, 0, _WinAPI_CreateSolidBitmap($hGUI, 0x000000, 11, 11))

	; Set column 0 display
	_GUICtrlHeader_SetItemDisplay($hHeader, 0, 1 + 2 + 8 + 16) ; String (8), Bitmap(1) and Image(16) are displayed on right (2)

	; Show column 0 display
	_MemoWrite("Column 0 display: 0x" & Hex(_GUICtrlHeader_GetItemDisplay($hHeader, 0)))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
