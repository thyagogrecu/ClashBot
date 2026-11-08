#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiListView.au3>
#include <WindowsStylesConstants.au3>

Opt("GUIOnEventMode", 1)
Global $g_hListView, $g_hListView2, $g_hGUI1, $g_hGUI2, $g_iRun = 1
Global $g_iDock = 1, $g_iDock_Location = 1, $g_iX1, $g_iX2, $g_iY1, $g_iY2
Global $g_idMni_OptionsItem2, $g_idMni_OptionsItem3, $g_idMni_OptionsItem4
Global $g_idMni_Options2Item2, $g_idMni_Options2Item3, $g_idMni_Options2Item4

Example()

Func Example()
	$g_iRun = 1
	Local $idMnu_Options, $idMnu_OptionsItem1, $idMnu_Options2, $idMnu_Options2Item1, $iWidth = 450
	Local $idBtn_MoveLeft, $idBtn_MoveRight, $idBtn_Exit1, $idBtn_Exit2
	Local $idBtn_CopyRight, $idBtn_CopyLeft, $hImage
	Local $iStylesEx = BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_SUBITEMIMAGES)

	$g_hGUI1 = GUICreate("(External) ListView Copy Items (v" & @AutoItVersion & ")", $iWidth, 300, 10, 10)
	$idMnu_Options = GUICtrlCreateMenu("Options")
	$idMnu_OptionsItem1 = GUICtrlCreateMenu("Docking", $idMnu_Options)

	$g_idMni_OptionsItem2 = GUICtrlCreateMenuItem("Docked", $idMnu_OptionsItem1)
	GUICtrlCreateMenuItem("", $idMnu_OptionsItem1)
	$g_idMni_OptionsItem3 = GUICtrlCreateMenuItem("Side By Side", $idMnu_OptionsItem1)
	$g_idMni_OptionsItem4 = GUICtrlCreateMenuItem("Top And Bottom", $idMnu_OptionsItem1)
	GUICtrlSetState($g_idMni_OptionsItem2, $GUI_CHECKED)
	GUICtrlSetState($g_idMni_OptionsItem3, $GUI_CHECKED)
	GUICtrlSetOnEvent($g_idMni_OptionsItem2, "_SetDocking")
	GUICtrlSetOnEvent($g_idMni_OptionsItem3, "_SetDockSideBySide")
	GUICtrlSetOnEvent($g_idMni_OptionsItem4, "_SetDockTopAndBottom")

	GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
	GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

	; need the handle because UDF function(s) are used to create the items
	$g_hListView = GUICtrlGetHandle(GUICtrlCreateListView("", 2, 2, $iWidth - 100, 268, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE))
	_GUICtrlListView_SetExtendedListViewStyle($g_hListView, $iStylesEx)

	$idBtn_MoveRight = GUICtrlCreateButton("Move", $iWidth - 95, 35, 90, 20)
	GUICtrlSetOnEvent($idBtn_MoveRight, "_MoveRight")

	$idBtn_CopyRight = GUICtrlCreateButton("Copy", $iWidth - 95, 60, 90, 20)
	GUICtrlSetOnEvent($idBtn_CopyRight, "_CopyRight")

	$idBtn_Exit1 = GUICtrlCreateButton("Exit", $iWidth - 95, 140, 90, 25)
	GUICtrlSetOnEvent($idBtn_Exit1, "_Exit")

	$g_hGUI2 = GUICreate("Right/Bottom Window", $iWidth, 300, $iWidth + 15, 10)

	$idMnu_Options2 = GUICtrlCreateMenu("Options")
	$idMnu_Options2Item1 = GUICtrlCreateMenu("Docking", $idMnu_Options2)
	$g_idMni_Options2Item2 = GUICtrlCreateMenuItem("Docked", $idMnu_Options2Item1)
	GUICtrlCreateMenuItem("", $idMnu_Options2Item1)
	$g_idMni_Options2Item3 = GUICtrlCreateMenuItem("Side By Side", $idMnu_Options2Item1)
	$g_idMni_Options2Item4 = GUICtrlCreateMenuItem("Top And Bottom", $idMnu_Options2Item1)
	GUICtrlSetState($g_idMni_Options2Item2, $GUI_CHECKED)
	GUICtrlSetState($g_idMni_Options2Item3, $GUI_CHECKED)
	GUICtrlSetOnEvent($g_idMni_Options2Item2, "_SetDocking2")
	GUICtrlSetOnEvent($g_idMni_Options2Item3, "_SetDockSideBySide2")
	GUICtrlSetOnEvent($g_idMni_Options2Item4, "_SetDockTopAndBottom2")

	GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "SpecialEvents")
	GUISetOnEvent($GUI_EVENT_RESTORE, "SpecialEvents")

	$g_hListView2 = GUICtrlGetHandle(GUICtrlCreateListView("", 2, 2, $iWidth - 100, 268, BitOR($LVS_REPORT, $LVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE))
	_GUICtrlListView_SetExtendedListViewStyle($g_hListView2, $iStylesEx)

	$idBtn_MoveLeft = GUICtrlCreateButton("Move", $iWidth - 95, 35, 90, 20)
	GUICtrlSetOnEvent($idBtn_MoveLeft, "_MoveLeft")

	$idBtn_CopyLeft = GUICtrlCreateButton("Copy", $iWidth - 95, 60, 90, 20)
	GUICtrlSetOnEvent($idBtn_CopyLeft, "_CopyLeft")

	$idBtn_Exit2 = GUICtrlCreateButton("Exit", $iWidth - 95, 140, 90, 25)
	GUICtrlSetOnEvent($idBtn_Exit2, "_Exit")

	GUISetState(@SW_SHOW, $g_hGUI2)
	GUISetState(@SW_SHOW, $g_hGUI1)

	; Set ANSI format
	_GUICtrlListView_SetUnicodeFormat($g_hListView, False)

	; Load images
	$hImage = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 13)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 14)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 15)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 16)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 17)
	_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 18)
	_GUICtrlListView_SetImageList($g_hListView, $hImage, 1)
	_GUICtrlListView_SetImageList($g_hListView2, $hImage, 1)

	; Add columns
	_GUICtrlListView_AddColumn($g_hListView, "Column 1", 120)
	_GUICtrlListView_AddColumn($g_hListView, "Column 2", 100)
	_GUICtrlListView_AddColumn($g_hListView, "Column 3", 100)

	; Add columns
	_GUICtrlListView_AddColumn($g_hListView2, "Column 1", 120)
	_GUICtrlListView_AddColumn($g_hListView2, "Column 2", 100)
	_GUICtrlListView_AddColumn($g_hListView2, "Column 3", 100)

	; Add items
	_GUICtrlListView_AddItem($g_hListView, "Row 1: Col 1", 0)
	_GUICtrlListView_AddSubItem($g_hListView, 0, "Row 1: Col 2", 1, 1)
	_GUICtrlListView_AddSubItem($g_hListView, 0, "Row 1: Col 3", 2, 2)
	_GUICtrlListView_AddItem($g_hListView, "Row 2: Col 1", 1)
	_GUICtrlListView_AddSubItem($g_hListView, 1, "Row 2: Col 2", 1, 2)
	_GUICtrlListView_AddItem($g_hListView, "Row 3: Col 1", 2)
	_GUICtrlListView_AddItem($g_hListView, "Row 4: Col 1", 3)
	_GUICtrlListView_AddItem($g_hListView, "Row 5: Col 1", 4)
	_GUICtrlListView_AddSubItem($g_hListView, 4, "Row 5: Col 2", 1, 3)
	_GUICtrlListView_AddItem($g_hListView, "Row 6: Col 1", 5)
	_GUICtrlListView_AddSubItem($g_hListView, 5, "Row 6: Col 2", 1, 4)
	_GUICtrlListView_AddSubItem($g_hListView, 5, "Row 6: Col 3", 2, 3)

	While $g_iRun
		If $g_iDock Then _KeepWindowsDocked()
		Sleep(10)
	WEnd
EndFunc   ;==>Example

Func _SetDocking()
	If BitAND(GUICtrlRead($g_idMni_OptionsItem2), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($g_idMni_OptionsItem2, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item2, $GUI_UNCHECKED)
		$g_iDock = 0
	Else
		GUICtrlSetState($g_idMni_OptionsItem2, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item2, $GUI_CHECKED)
		$g_iDock = 2
	EndIf
	If $g_iDock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDocking

Func _SetDocking2()
	If BitAND(GUICtrlRead($g_idMni_Options2Item2), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($g_idMni_OptionsItem2, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item2, $GUI_UNCHECKED)
		$g_iDock = 0
	Else
		GUICtrlSetState($g_idMni_OptionsItem2, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item2, $GUI_CHECKED)
		$g_iDock = 2
	EndIf
	If $g_iDock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDocking2

Func _SetDockSideBySide()
	If BitAND(GUICtrlRead($g_idMni_OptionsItem3), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($g_idMni_OptionsItem3, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_OptionsItem4, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item3, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item4, $GUI_CHECKED)
		$g_iDock_Location = 2
	Else
		GUICtrlSetState($g_idMni_OptionsItem3, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_OptionsItem4, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item3, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item4, $GUI_UNCHECKED)
		$g_iDock_Location = 1
		If $g_iDock Then $g_iDock = 2
	EndIf
	If $g_iDock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDockSideBySide

Func _SetDockSideBySide2()
	If BitAND(GUICtrlRead($g_idMni_Options2Item3), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($g_idMni_OptionsItem3, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_OptionsItem4, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item3, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item4, $GUI_CHECKED)
		$g_iDock_Location = 2
	Else
		GUICtrlSetState($g_idMni_OptionsItem3, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_OptionsItem4, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item3, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item4, $GUI_UNCHECKED)
		$g_iDock_Location = 1
		If $g_iDock Then $g_iDock = 2
	EndIf
	If $g_iDock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDockSideBySide2

Func _SetDockTopAndBottom()
	If BitAND(GUICtrlRead($g_idMni_OptionsItem4), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($g_idMni_OptionsItem4, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_OptionsItem3, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item4, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item3, $GUI_CHECKED)
		$g_iDock_Location = 1
	Else
		GUICtrlSetState($g_idMni_OptionsItem4, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_OptionsItem3, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item4, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item3, $GUI_UNCHECKED)
		$g_iDock_Location = 2
		If $g_iDock Then $g_iDock = 2
	EndIf
	If $g_iDock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDockTopAndBottom

Func _SetDockTopAndBottom2()
	If BitAND(GUICtrlRead($g_idMni_Options2Item4), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($g_idMni_OptionsItem4, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_OptionsItem3, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item4, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item3, $GUI_CHECKED)
		$g_iDock_Location = 1
	Else
		GUICtrlSetState($g_idMni_OptionsItem4, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_OptionsItem3, $GUI_UNCHECKED)
		GUICtrlSetState($g_idMni_Options2Item4, $GUI_CHECKED)
		GUICtrlSetState($g_idMni_Options2Item3, $GUI_UNCHECKED)
		$g_iDock_Location = 2
		If $g_iDock Then $g_iDock = 2
	EndIf
	If $g_iDock Then _KeepWindowsDocked()
EndFunc   ;==>_SetDockTopAndBottom2

Func _KeepWindowsDocked()
	Local $a_PosWin1 = WinGetPos($g_hGUI1)
	Local $a_PosWin2 = WinGetPos($g_hGUI2)
	If $g_iDock_Location == 1 Then
		If (($a_PosWin1[0] <> $g_iX1 Or $a_PosWin1[1] <> $g_iY1) And BitAND(WinGetState($g_hGUI1), 8) Or $g_iDock = 2) Then
			$g_iX1 = $a_PosWin1[0]
			$g_iY1 = $a_PosWin1[1]
			$g_iX2 = $a_PosWin1[2] + $g_iX1
			$g_iY2 = $g_iY1
			WinMove($g_hGUI2, "", $g_iX2, $g_iY2)
			$g_iDock = 1
		ElseIf (($a_PosWin2[0] <> $g_iX2 Or $a_PosWin2[1] <> $g_iY2) And BitAND(WinGetState($g_hGUI2), 8)) Then
			$g_iX2 = $a_PosWin2[0]
			$g_iY2 = $a_PosWin2[1]
			$g_iX1 = $a_PosWin2[0] - $a_PosWin1[2]
			$g_iY1 = $g_iY2
			WinMove($g_hGUI1, "", $g_iX1, $g_iY1)
		EndIf
	Else
		If (($a_PosWin1[0] <> $g_iX1 Or $a_PosWin1[1] <> $g_iY1) And BitAND(WinGetState($g_hGUI1), 8) Or $g_iDock = 2) Then
			$g_iX1 = $a_PosWin1[0]
			$g_iY1 = $a_PosWin1[1]
			$g_iX2 = $g_iX1
			$g_iY2 = $a_PosWin1[3] + $g_iY1
			WinMove($g_hGUI2, "", $g_iX2, $g_iY2)
			$g_iDock = 1
		ElseIf (($a_PosWin2[0] <> $g_iX2 Or $a_PosWin2[1] <> $g_iY2) And BitAND(WinGetState($g_hGUI2), 8)) Then
			$g_iX2 = $a_PosWin2[0]
			$g_iY2 = $a_PosWin2[1]
			$g_iX1 = $g_iX2
			$g_iY1 = $a_PosWin2[1] - $a_PosWin1[3]
			WinMove($g_hGUI1, "", $g_iX1, $g_iY1)
		EndIf
	EndIf
EndFunc   ;==>_KeepWindowsDocked

Func _CopyRight()
	_GUICtrlListView_CopyItems($g_hListView, $g_hListView2)
EndFunc   ;==>_CopyRight

Func _MoveRight()
	_GUICtrlListView_CopyItems($g_hListView, $g_hListView2, 1)
EndFunc   ;==>_MoveRight

Func _CopyLeft()
	_GUICtrlListView_CopyItems($g_hListView2, $g_hListView)
EndFunc   ;==>_CopyLeft

Func _MoveLeft()
	_GUICtrlListView_CopyItems($g_hListView2, $g_hListView, 1)
EndFunc   ;==>_MoveLeft

Func _Exit()
	$g_iRun = 0
	GUIDelete($g_hGUI2)
	GUIDelete($g_hGUI1)
EndFunc   ;==>_Exit

Func SpecialEvents()
	Select
		Case @GUI_CtrlId = $GUI_EVENT_CLOSE
			_Exit()
	EndSelect
EndFunc   ;==>SpecialEvents
