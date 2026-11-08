#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>
#include <WinAPISysWin.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Layout (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 52, 444, 220)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Get header layout
	Local $tRECT = _WinAPI_GetClientRect($hGUI)
	Local $tPos = _GUICtrlHeader_Layout($hHeader, $tRECT)

	; Show header layout
	_MemoWrite("Window handle .....: " & DllStructGetData($tPos, "hWnd"))
	_MemoWrite("Z order handle ....: " & DllStructGetData($tPos, "InsertAfter"))
	_MemoWrite("Horizontal position: " & DllStructGetData($tPos, "X"))
	_MemoWrite("Vertical position .: " & DllStructGetData($tPos, "Y"))
	_MemoWrite("Width .............: " & DllStructGetData($tPos, "CX"))
	_MemoWrite("Height ............: " & DllStructGetData($tPos, "CY"))
	_MemoWrite("Flags .............: " & DllStructGetData($tPos, "Flags"))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
