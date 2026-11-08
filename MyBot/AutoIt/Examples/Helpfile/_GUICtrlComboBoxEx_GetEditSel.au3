#include "Extras\HelpFileInternals.au3"

#include <GuiComboBoxEx.au3>
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("ComboBoxEx Get/Set Edit Sel (v" & @AutoItVersion & ")", 400, 300)
	Local $hCombo = _GUICtrlComboBoxEx_Create($hGUI, "", 2, 2, 394, 70, BitOR($CBS_SIMPLE, $WS_VSCROLL, $WS_BORDER))
	_MemoCreate(2, 72, 396, 226, 0)
	GUISetState(@SW_SHOW)

	Local $hImage = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 110)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 131)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 165)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 168)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 137)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 146)
	_GUIImageList_Add($hImage, _GUICtrlComboBoxEx_CreateSolidBitMap($hCombo, 0xFF0000, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlComboBoxEx_CreateSolidBitMap($hCombo, 0x00FF00, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlComboBoxEx_CreateSolidBitMap($hCombo, 0x0000FF, 16, 16))
	_GUICtrlComboBoxEx_SetImageList($hCombo, $hImage)

	; Add strings
	For $x = 0 To 8
		_GUICtrlComboBoxEx_AddString($hCombo, StringFormat("%03d : string", $x), $x, $x)
	Next

	;Set Cur Sel
	_GUICtrlComboBoxEx_SetCurSel($hCombo, 5)

	;Set Edit Sel
	_GUICtrlComboBoxEx_SetEditSel($hCombo, 0, 4)

	;Get Edit Sel
	Local $aSel = _GUICtrlComboBoxEx_GetEditSel($hCombo)
	_MemoWrite(StringFormat("Selected: [%d][%d]", $aSel[0], $aSel[1]))

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
