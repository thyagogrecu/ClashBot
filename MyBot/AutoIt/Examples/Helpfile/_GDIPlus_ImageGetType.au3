#include "Extras\HelpFileInternals.au3"

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPIHObj.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hBitmap, $hImage, $iImageType, $sImageType

	; Create GUI
	GUICreate("GDI+", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Initialize GDI+ library
	_GDIPlus_Startup()

	; Capture 32 bit bitmap
	$hBitmap = _ScreenCapture_Capture("")
	$hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)

	$iImageType = _GDIPlus_ImageGetType($hImage)
	Switch $iImageType
		Case $GDIP_IMAGETYPE_UNKNOWN
			$sImageType = "Unrecognized bitmap format or not image file"
		Case $GDIP_IMAGETYPE_BITMAP ; BMP, PNG, GIF, JPEG, TIFF, ICO, EXIF
			$sImageType = "Bitmap"
		Case $GDIP_IMAGETYPE_METAFILE ; EMF, WMF
			$sImageType = "Metafile"
	EndSwitch

	; Show image type: Unidentified = 0, Bitmap = 1, Metafile = 2)
	_MemoWrite("Image type: " & $sImageType) ;

	; Clean up resources
	_GDIPlus_ImageDispose($hImage)
	_WinAPI_DeleteObject($hBitmap)

	; Shut down GDI+ library
	_GDIPlus_Shutdown()

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
