#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiScrollBars.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGUIMsg, $hGUI, $aRect

	$hGUI = GUICreate("ScrollBar Example", 400, 400, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
	_MemoCreate(2, 2, 380, 360, BitOR($WS_HSCROLL, $WS_VSCROLL))
	GUICtrlSetResizing($_g_idLst_Memo, $GUI_DOCKALL)
	GUICtrlSetFont($_g_idLst_Memo, 9, 400, 0, "Courier New")
	GUISetBkColor(0x88AABB)

	GUISetState(@SW_SHOW)

	_GUIScrollBars_Init($hGUI)

	$aRect = _GUIScrollBars_GetScrollBarRect($hGUI, $OBJID_HSCROLL)
	_MemoWrite("Horizontal" & @CRLF & "--------------------------------------")
	_MemoWrite("Left.........: " & $aRect[0])
	_MemoWrite("Top..........: " & $aRect[1])
	_MemoWrite("Right........: " & $aRect[2])
	_MemoWrite("Bottom.......: " & $aRect[3])

	$aRect = _GUIScrollBars_GetScrollBarRect($hGUI, $OBJID_VSCROLL)
	_MemoWrite(@CRLF & "--------------------------------------" & @CRLF & "Vertical" & @CRLF & "--------------------------------------")
	_MemoWrite("Left.........: " & $aRect[0])
	_MemoWrite("Top..........: " & $aRect[1])
	_MemoWrite("Right........: " & $aRect[2])
	_MemoWrite("Bottom.......: " & $aRect[3])

	While 1
		$hGUIMsg = GUIGetMsg()

		Switch $hGUIMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example
