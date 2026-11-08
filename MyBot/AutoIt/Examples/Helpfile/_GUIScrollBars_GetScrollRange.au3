#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiScrollBars.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGUIMsg, $hGUI, $aRangeMinMax

	$hGUI = GUICreate("ScrollBar Example", 400, 400, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
	_MemoCreate(2, 2, 380, 380, BitOR($WS_HSCROLL, $WS_VSCROLL))
	GUICtrlSetResizing($_g_idLst_Memo, $GUI_DOCKALL)
	GUICtrlSetFont($_g_idLst_Memo, 9, 400, 0, "Courier New")
	GUISetBkColor(0x88AABB)

	GUISetState(@SW_SHOW)

	_GUIScrollBars_Init($hGUI)

	$aRangeMinMax = _GUIScrollBars_GetScrollRange($hGUI, $SB_VERT)
	_MemoWrite("Vertical Min/Max: " & $aRangeMinMax[0] & "/" & $aRangeMinMax[1])
	$aRangeMinMax = _GUIScrollBars_GetScrollRange($hGUI, $SB_HORZ)
	_MemoWrite("Horizontal Min/Max: " & $aRangeMinMax[0] & "/" & $aRangeMinMax[1])
	Sleep(1000)
	_GUIScrollBars_SetScrollRange($hGUI, $SB_VERT, 3, 30)
	$aRangeMinMax = _GUIScrollBars_GetScrollRange($hGUI, $SB_VERT)
	_MemoWrite("New Vertical Min/Max: " & $aRangeMinMax[0] & "/" & $aRangeMinMax[1])
	Sleep(1000)
	_GUIScrollBars_SetScrollRange($hGUI, $SB_HORZ, 10, 98)
	$aRangeMinMax = _GUIScrollBars_GetScrollRange($hGUI, $SB_HORZ)
	_MemoWrite("New Horizontal Min/Max: " & $aRangeMinMax[0] & "/" & $aRangeMinMax[1])

	While 1
		$hGUIMsg = GUIGetMsg()

		Switch $hGUIMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example
