#include "Extras\HelpFileInternals.au3"

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPIConv.au3>
#include <WinAPIHObj.au3>
#include <WindowsStylesConstants.au3>

Global $g_aCodex, $g_hImage

Example()

Func Example()
	Local $hBitmap

	; Create GUI
	GUICreate("GDI+", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Initialize GDI+ library
	_GDIPlus_Startup()

	; Create an image to use for paramater lists
	$hBitmap = _ScreenCapture_Capture("", 0, 0, 1, 1)
	$g_hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)

	; Show encoder parameters
	$g_aCodex = _GDIPlus_Encoders()
	ShowCodex("Encoder")

	; Show decoder parameters
	$g_aCodex = _GDIPlus_Decoders()
	ShowCodex("Decoder")

	; Clean up resources
	_GDIPlus_ImageDispose($g_hImage)
	_WinAPI_DeleteObject($hBitmap)

	; Shut down GDI+ library
	_GDIPlus_Shutdown()

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Show codex information
Func ShowCodex($sTitle)
	Local $iI, $iJ, $iK, $sCLSID, $tData, $tParam, $tParams, $iParamSize = _GDIPlus_ParamSize()

	For $iI = 1 To $g_aCodex[0][0]
		$sCLSID = _GDIPlus_EncodersGetCLSID($g_aCodex[$iI][5])
		_MemoWrite("Image " & $sTitle & " " & $iI)
		_MemoWrite("  Codec GUID ............: " & $g_aCodex[$iI][1])
		_MemoWrite("  File format GUID ......: " & $g_aCodex[$iI][2])
		_MemoWrite("  Codec name ............: " & $g_aCodex[$iI][3])
		_MemoWrite("  Codec Dll file name ...: " & $g_aCodex[$iI][4])
		_MemoWrite("  Codec file format .....: " & $g_aCodex[$iI][5])
		_MemoWrite("  File name extensions ..: " & $g_aCodex[$iI][6])
		_MemoWrite("  Mime type .............: " & $g_aCodex[$iI][7])
		_MemoWrite("  Flags .................: 0x" & Hex($g_aCodex[$iI][8]))
		_MemoWrite("  Version ...............: " & $g_aCodex[$iI][9])
		_MemoWrite("  Signature count .......: " & $g_aCodex[$iI][10])
		_MemoWrite("  Signature size ........: " & $g_aCodex[$iI][11])
		_MemoWrite("  Signature pattern ptr .: 0x" & Hex($g_aCodex[$iI][12]))
		_MemoWrite("  Signature mask ptr ....: 0x" & Hex($g_aCodex[$iI][13]))

;~ 		If $sTitle = "Decoder" Then ContinueLoop

		_MemoWrite("  Parameter list size ...: " & _GDIPlus_EncodersGetParamListSize($g_hImage, $sCLSID))

		$tParams = _GDIPlus_EncodersGetParamList($g_hImage, $sCLSID)
		If @error Then
			_MemoWrite()
			ContinueLoop
		EndIf

		_MemoWrite("  Parameters Count ......: " & DllStructGetData($tParams, "Count"))
		_MemoWrite()
		For $iJ = 0 To DllStructGetData($tParams, "Count") - 1
			_MemoWrite("  Image " & $sTitle & " " & $iI & " Parameter " & $iJ)
			$tParam = DllStructCreate($tagGDIPENCODERPARAM, DllStructGetPtr($tParams, "GUID") + ($iJ * $iParamSize))
			_MemoWrite("    Parameter GUID ......: " & _WinAPI_StringFromGUID(DllStructGetPtr($tParam, "GUID")))
			_MemoWrite("    Number of values ....: " & DllStructGetData($tParam, "NumberOfValues"))
			_MemoWrite("    Parameter type.......: " & DllStructGetData($tParam, "Type"))
			_MemoWrite("    Parameter pointer ...: 0x" & Hex(DllStructGetData($tParam, "Values")))
			Switch DllStructGetData($tParam, "Type")
				Case 4
					$tData = DllStructCreate("int Data[" & DllStructGetData($tParam, "NumberOfValues") & "]", DllStructGetData($tParam, "Values"))
					For $iK = 1 To DllStructGetData($tParam, "NumberOfValues")
						_MemoWrite("      Value .............: " & DllStructGetData($tData, 1, $iK))
					Next
				Case 6
					$tData = DllStructCreate("int Low;int High", DllStructGetData($tParam, "Values"))
					_MemoWrite("      Low range .........: " & DllStructGetData($tData, "Low"))
					_MemoWrite("      High range ........: " & DllStructGetData($tData, "High"))
			EndSwitch
			_MemoWrite()
		Next
	Next
EndFunc   ;==>ShowCodex
