#include "Extras\HelpFileInternals.au3"

#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $idMonthCal

	; Create GUI
	GUICreate("Month Calendar Get Min Req Rect Array", 400, 300)
	$idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, BitOR($WS_BORDER, $MCS_MULTISELECT), 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 392, 128, BitOR($WS_VSCROLL, $ES_MULTILINE))
	GUICtrlSendMsg($_g_idLst_Memo, $EM_SETREADONLY, True, 0)
	GUICtrlSetBkColor($_g_idLst_Memo, 0xFFFFFF)
	GUISetState(@SW_SHOW)

	; Get minimum required height/width
	_MemoWrite(_FormatOutPut(_GUICtrlMonthCal_GetMinReqRectArray($idMonthCal)))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example

Func _FormatOutPut($aRect)
	Return "Minimum required Width: " & @TAB & $aRect[3] & @CRLF & "Minimum required Height:" & @TAB & $aRect[4]
EndFunc   ;==>_FormatOutPut
