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

	_MemoWrite("Horizontal" & @CRLF & "--------------------------------------")
	_MemoWrite("Left of thumb: " & _GUIScrollBars_GetScrollBarXYThumbTop($hGUI, $OBJID_HSCROLL))
	_MemoWrite("Right of thumb: " & _GUIScrollBars_GetScrollBarXYThumbBottom($hGUI, $OBJID_HSCROLL) & @CRLF)

	_MemoWrite("Vertical" & @CRLF & "--------------------------------------")
	_MemoWrite("Top of thumb: " & _GUIScrollBars_GetScrollBarXYLineButton($hGUI, $OBJID_VSCROLL))
	_MemoWrite("Bottom of thumb: " & _GUIScrollBars_GetScrollBarXYThumbBottom($hGUI, $OBJID_VSCROLL))

	While 1
		$hGUIMsg = GUIGetMsg()

		Switch $hGUIMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example
