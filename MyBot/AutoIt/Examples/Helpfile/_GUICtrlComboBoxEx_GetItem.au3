#include "Extras\HelpFileInternals.au3"

#include <GuiComboBoxEx.au3>
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	Local $hGUI, $hImage, $aItem, $hCombo

	; Create GUI
	$hGUI = GUICreate("ComboBoxEx Get/Set Item (v" & @AutoItVersion & ")", 400, 300)
	$hCombo = _GUICtrlComboBoxEx_Create($hGUI, "", 2, 2, 394, 100)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	$hImage = _GUIImageList_Create(16, 16, 5, 3)
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

	For $x = 0 To 8
		_GUICtrlComboBoxEx_AddString($hCombo, StringFormat("%03d : string", $x), $x, $x)
	Next

	;Set Item indent
	_GUICtrlComboBoxEx_SetItemIndent($hCombo, 1, 1)

	$aItem = _GUICtrlComboBoxEx_GetItem($hCombo, 1)
	_MemoWrite("Item Text : " & $aItem[0])
	_MemoWrite("Item Len ..........................: " & $aItem[1])
	_MemoWrite("# image widths to indent ..........: " & $aItem[2])
	_MemoWrite("0-based item image index .......: " & $aItem[3])
	_MemoWrite("0-based item state image index .: " & $aItem[4])
	_MemoWrite("0-based item image overlay index: " & $aItem[5])
	_MemoWrite("Item application defined value ....: " & $aItem[6])

	; Change item 1
	MsgBox($MB_SYSTEMMODAL, "Information", "Changing item 1")
	_GUICtrlComboBoxEx_SetItem($hCombo, "New Item 1", 1)

	; show drop down
	_GUICtrlComboBoxEx_ShowDropDown($hCombo, True)

	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
