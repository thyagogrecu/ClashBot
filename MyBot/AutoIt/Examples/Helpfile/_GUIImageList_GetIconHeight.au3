#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <WinAPIGdi.au3>
#include <WinAPIGdiDC.au3>

Example()

Func Example()
	Local $hImage, $hGUI, $hDC

	$hGUI = GUICreate("ImageList Get Icon Height", 400, 300)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Load images
	$hImage = _GUIImageList_Create(32, 24)
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0xFF0000, 32, 24))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x00FF00, 32, 24))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x0000FF, 32, 24))

	; Draw images
	$hDC = _WinAPI_GetDC($hGUI)
	_GUIImageList_Draw($hImage, 0, $hDC, 4, 4)
	_GUIImageList_Draw($hImage, 1, $hDC, 40, 4)
	_GUIImageList_Draw($hImage, 2, $hDC, 76, 4)

	_WinAPI_ReleaseDC($hGUI, $hDC)

	; Show image list icon size
	_MemoWrite("Image width : " & _GUIImageList_GetIconWidth($hImage))
	_MemoWrite("Image height: " & _GUIImageList_GetIconHeight($hImage))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
