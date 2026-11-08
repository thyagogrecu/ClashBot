#include "Extras\HelpFileInternals.au3"

#include <ColorConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $idMonthCal

	; Create GUI
	GUICreate("Month Calendar Get Color Array", 425, 300)
	$idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; Create memo control
	_MemoCreate(4, 168, 417, 128, BitOR($WS_VSCROLL, $ES_MULTILINE))
	GUICtrlSendMsg($_g_idLst_Memo, $EM_SETREADONLY, True, 0)
	GUICtrlSetBkColor($_g_idLst_Memo, 0xFFFFFF)
	GUISetState(@SW_SHOW)

	_GUICtrlMonthCal_SetColor($idMonthCal, $MCSC_MONTHBK, $CLR_DARKSEAGREEN)

	; Get/Set calendar colors
	_MemoWrite(_FormatOutPut("Background color displayed between months:", _GUICtrlMonthCal_GetColorArray($idMonthCal, $MCSC_BACKGROUND)))
	_MemoWrite(_FormatOutPut(@CRLF & "Background color displayed within the month:", _GUICtrlMonthCal_GetColorArray($idMonthCal, $MCSC_MONTHBK)))
	_MemoWrite(_FormatOutPut(@CRLF & "Color used to display text within a month:", _GUICtrlMonthCal_GetColorArray($idMonthCal, $MCSC_TEXT)))
	_MemoWrite(_FormatOutPut(@CRLF & "Background color displayed in the calendar's title:", _GUICtrlMonthCal_GetColorArray($idMonthCal, $MCSC_TITLEBK)))
	_MemoWrite(_FormatOutPut(@CRLF & "Color used to display text within the calendar's title:", _GUICtrlMonthCal_GetColorArray($idMonthCal, $MCSC_TITLETEXT)))
	_MemoWrite(_FormatOutPut(@CRLF & "Color used to display header day and trailing day text:", _GUICtrlMonthCal_GetColorArray($idMonthCal, $MCSC_TRAILINGTEXT)))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example

Func _FormatOutPut($sText, $aColors)
	Return $sText & _
			@CRLF & @TAB & "COLORREF rgbcolor:" & @TAB & $aColors[1] & _
			@CRLF & @TAB & "Hex BGR color:" & @TAB & @TAB & $aColors[2] & _
			@CRLF & @TAB & "Hex RGB color:" & @TAB & @TAB & $aColors[3]
EndFunc   ;==>_FormatOutPut
