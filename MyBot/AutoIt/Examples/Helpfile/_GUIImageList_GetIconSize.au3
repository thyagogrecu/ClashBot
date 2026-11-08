#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	GUICreate("ImageList Get/Set Icon Size (v" & @AutoItVersion & ")", 400, 300)
	Local $idListview = GUICtrlCreateListView("", 2, 2, 394, 199, BitOR($LVS_SHOWSELALWAYS, $LVS_NOSORTHEADER, $LVS_REPORT))
	_MemoCreate(2, 200, 396, 266, 0)
	GUISetState(@SW_SHOW)

	Local $hImage = _GUIImageList_Create(32, 32, 5, 3)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 110)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 131)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 165)
	_GUICtrlListView_SetImageList($idListview, $hImage, 1)

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Column 1", 120)
	_GUICtrlListView_AddColumn($idListview, "Column 2", 100)
	_GUICtrlListView_AddColumn($idListview, "Column 3", 100)

	; Add items
	_GUICtrlListView_AddItem($idListview, "Row 1: Col 1", 0)
	_GUICtrlListView_AddSubItem($idListview, 0, "Row 1: Col 2", 1, 1)
	_GUICtrlListView_AddSubItem($idListview, 0, "Row 1: Col 3", 2, 2)
	_GUICtrlListView_AddItem($idListview, "Row 2: Col 1", 1)
	_GUICtrlListView_AddSubItem($idListview, 1, "Row 2: Col 2", 1, 2)

	; Show image list icon size
	Local $aSize = _GUIImageList_GetIconSize($hImage)
	_MemoWrite("Image width : " & $aSize[0])
	_MemoWrite("Image height: " & $aSize[1])

	MsgBox($MB_SYSTEMMODAL, "Information", "Changing Icon Size")

	_GUIImageList_SetIconSize($hImage, 16, 16)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 110)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 131)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 165)
	_GUICtrlListView_SetImageList($idListview, $hImage, 1)

	$aSize = _GUIImageList_GetIconSize($hImage)
	_MemoWrite("Image width : " & $aSize[0])
	_MemoWrite("Image height: " & $aSize[1])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
