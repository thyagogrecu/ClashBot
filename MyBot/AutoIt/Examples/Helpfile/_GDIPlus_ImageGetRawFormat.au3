#include "Extras\HelpFileInternals.au3"

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPIHObj.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hBitmap, $hImage, $aRet

	; Create GUI
	GUICreate("GDI+", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Initialize GDI+ library
	_GDIPlus_Startup()

	; Capture 32 bit bitmap
	$hBitmap = _ScreenCapture_Capture("")
	$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)

	; Show image format for screen capture
	$aRet = _GDIPlus_ImageGetRawFormat($hImage)
	_MemoWrite("Image format of screen capture: " & $aRet[1]) ;
	_MemoWrite("GUID: " & $aRet[0]) ;
	_MemoWrite() ;

	; Save screen capture bitmap to file
	_GDIPlus_ImageSaveToFile($hImage, @MyDocumentsDir & "\GDIPlus_Image.jpg")

	; Clean up resources
	_GDIPlus_ImageDispose($hImage)
	_WinAPI_DeleteObject($hBitmap)

	; Load screen capture bitmap from file
	$hImage = _GDIPlus_ImageLoadFromFile(@MyDocumentsDir & "\GDIPlus_Image.jpg")

	; Show image format for saved file
	$aRet = _GDIPlus_ImageGetRawFormat($hImage)
	_MemoWrite("Image format of saved file: " & $aRet[1]) ;
	_MemoWrite("GUID: " & $aRet[0]) ;

	; Clean up resources
	_GDIPlus_ImageDispose($hImage)

	; Shut down GDI+ library
	_GDIPlus_Shutdown()

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
