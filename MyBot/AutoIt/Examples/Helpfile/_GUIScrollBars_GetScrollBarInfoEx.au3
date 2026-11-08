#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiScrollBars.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGUIMsg, $hGUI, $tSCROLLBARINFO

	$hGUI = GUICreate("ScrollBar Example", 400, 400, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_SIZEBOX))
	_MemoCreate(2, 2, 380, 360, BitOR($WS_HSCROLL, $WS_VSCROLL))
	GUICtrlSetResizing($_g_idLst_Memo, $GUI_DOCKALL)
	GUICtrlSetFont($_g_idLst_Memo, 9, 400, 0, "Courier New")
	GUISetBkColor(0x88AABB)

	GUISetState(@SW_SHOW)

	_GUIScrollBars_Init($hGUI)

	$tSCROLLBARINFO = _GUIScrollBars_GetScrollBarInfoEx($hGUI, $OBJID_HSCROLL)
	_MemoWrite("Horizontal" & @CRLF & "--------------------------------------")
	_MemoWrite("Left.........: " & DllStructGetData($tSCROLLBARINFO, "Left"))
	_MemoWrite("Top..........: " & DllStructGetData($tSCROLLBARINFO, "Top"))
	_MemoWrite("Right........: " & DllStructGetData($tSCROLLBARINFO, "Right"))
	_MemoWrite("Bottom.......: " & DllStructGetData($tSCROLLBARINFO, "Bottom"))
	_MemoWrite("dxyLineButton: " & DllStructGetData($tSCROLLBARINFO, "dxyLineButton"))
	_MemoWrite("xyThumbTop...: " & DllStructGetData($tSCROLLBARINFO, "xyThumbTop"))
	_MemoWrite("xyThumbBottom: " & DllStructGetData($tSCROLLBARINFO, "xyThumbBottom"))
	For $x = 0 To 5
		_MemoWrite("rgstate[" & $x & "]...: " & DllStructGetData($tSCROLLBARINFO, "rgstate", $x + 1))
	Next

	While 1
		$hGUIMsg = GUIGetMsg()

		Switch $hGUIMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example
