#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>
#include <GuiImageList.au3>
#include <WinAPIGdi.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get/Set ImageList (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)
	_MemoCreate(2, 52, 444, 220)

	GUISetState(@SW_SHOW)

	; Create an image list with images
	Local $hImage = _GUIImageList_Create(11, 11)
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0xFF0000, 11, 11))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x00FF00, 11, 11))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x0000FF, 11, 11))
	Local $hPrevImageList = _GUICtrlHeader_SetImageList($hHeader, $hImage)

	_MemoWrite("Previous Image list handle ....: " & "0x" & Hex($hPrevImageList))
	_MemoWrite("IsPtr = " & IsPtr($hPrevImageList) & " IsHWnd = " & IsHWnd($hPrevImageList))

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100, 0, 0)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100, 0, 1)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100, 0, 2)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Show header information
	_MemoWrite("Image list handle ....: " & "0x" & Hex(_GUICtrlHeader_GetImageList($hHeader)))
	_MemoWrite("IsPtr = " & IsPtr(_GUICtrlHeader_GetImageList($hHeader)) & " IsHWnd = " & IsHWnd(_GUICtrlHeader_GetImageList($hHeader)))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
