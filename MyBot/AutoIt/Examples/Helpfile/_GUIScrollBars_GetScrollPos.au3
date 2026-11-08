#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiScrollBars.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGUIMsg, $hGUI

	$hGUI = GUICreate("ScrollBar Example", 400, 400, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
	_MemoCreate(2, 2, 380, 380, BitOR($WS_HSCROLL, $WS_VSCROLL))
	GUICtrlSetResizing($_g_idLst_Memo, $GUI_DOCKALL)
	GUICtrlSetFont($_g_idLst_Memo, 9, 400, 0, "Courier New")
	GUISetBkColor(0x88AABB)

	GUISetState(@SW_SHOW)

	_GUIScrollBars_Init($hGUI)

	_GUIScrollBars_SetScrollInfoPos($hGUI, $SB_HORZ, 10)
	_MemoWrite("Scroll Pos Horizontal: " & _GUIScrollBars_GetScrollPos($hGUI, $SB_HORZ))
	Sleep(1000)
	_GUIScrollBars_SetScrollInfoPos($hGUI, $SB_HORZ, 0)
	_MemoWrite("Scroll Pos Horizontal: " & _GUIScrollBars_GetScrollPos($hGUI, $SB_HORZ))
	Sleep(1000)
	_GUIScrollBars_SetScrollInfoPos($hGUI, $SB_VERT, 20)
	_MemoWrite("Scroll Pos Vertical: " & _GUIScrollBars_GetScrollPos($hGUI, $SB_VERT))
	Sleep(1000)
	_GUIScrollBars_SetScrollInfoPos($hGUI, $SB_VERT, 0)
	_MemoWrite("Scroll Pos Vertical: " & _GUIScrollBars_GetScrollPos($hGUI, $SB_VERT))

	While 1
		$hGUIMsg = GUIGetMsg()

		Switch $hGUIMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example
