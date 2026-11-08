#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>
#include <GuiImageList.au3>
#include <StructureConstants.au3>
#include <WinAPIGdi.au3>
#include <WinAPIGdiDC.au3>
#include <WinAPIMisc.au3>
#include <WinAPISysWin.au3>

Example()

Func Example()

	; Create GUI
	Local $hGUI = GUICreate("Header Create DragImage (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 32, 444, 240)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Create a drag image
	Local $hImage = _GUICtrlHeader_CreateDragImage($hHeader, 1)
	Local $aSize = _GUIImageList_GetIconSize($hImage)
	Local $hDC = _WinAPI_GetDC($hGUI)

	_MemoWrite("Image drag Handle: " & "0x" & Hex($hImage))
	_MemoWrite("IsPtr  = " & IsPtr($hImage) & " IsHWnd  = " & IsHWnd($hImage))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	Local $iMsg, $tPos, $tRECT
	; Show drag image at cursor position until user exits
	Do
		$iMsg = GUIGetMsg()
		If $iMsg = $GUI_EVENT_MOUSEMOVE Then
			If $tPos <> 0 Then
				$tRECT = DllStructCreate($tagRECT)
				DllStructSetData($tRECT, "Left", DllStructGetData($tPos, "X"))
				DllStructSetData($tRECT, "Top", DllStructGetData($tPos, "Y"))
				DllStructSetData($tRECT, "Right", DllStructGetData($tPos, "X") + $aSize[0])
				DllStructSetData($tRECT, "Bottom", DllStructGetData($tPos, "Y") + $aSize[1])
				_WinAPI_InvalidateRect($hGUI, $tRECT)
			EndIf
			$tRECT = _WinAPI_GetClientRect($hGUI)
			$tPos = _WinAPI_GetMousePos(True, $hGUI)
			If _WinAPI_PtInRect($tRECT, $tPos) Then
				_GUIImageList_Draw($hImage, 0, $hDC, DllStructGetData($tPos, "X"), DllStructGetData($tPos, "Y"))
			EndIf
		EndIf
	Until $iMsg = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
