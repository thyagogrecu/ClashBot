; #FUNCTION# ====================================================================================================================
; Name ..........: _GUICtrlSetTip
; Description ...: Replacement for GUICtrlSetTip because doesn't create a tool tip window control everytime
; Syntax ........:
; Parameters ....: See GUICtrlSetTip
; Return values .: See _GUIToolTip_AddTool
; Author ........: Cosote (06-2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $_GUI_MAIN_WIDTH
Global $g_hToolTip = 0

Func _GUICtrlSetTip($controlID, $tiptext, $title = Default, $icon = Default, $options = Default, $useControlID = True)
	If IsDeclared("g_bDisableBotToolTips") And $g_bDisableBotToolTips Then Return False

	If $g_hToolTip = 0 Then
		; attempt to create a tip control using the main form if available
		If IsDeclared("g_hFrmBot") And IsHWnd($g_hFrmBot) Then
			$g_hToolTip = _GUIToolTip_Create($g_hFrmBot)
			_BotToolTipConfigure()
		Else
			SetDebugLog("_GUICtrlSetTip: Missing $hToolTip! $controlID=" & $controlID, $COLOR_ERROR)
			Return False
		EndIf
	EndIf

	Local $hCtrl = ($useControlID = True ? GUICtrlGetHandle($controlID) : $controlID)
	If $hCtrl = 0 Then Return GUICtrlSetTip($controlID, $tiptext, $title, $icon, $options)

	Local $bAdded = _GUIToolTip_AddTool($g_hToolTip, 0, $tiptext, $hCtrl)
	If Not $bAdded And $useControlID Then Return GUICtrlSetTip($controlID, $tiptext, $title, $icon, $options)
	Return $bAdded
EndFunc   ;==>_GUICtrlSetTip

Func _BotToolTipConfigure()
	If $g_hToolTip = 0 Then Return False
	If IsDeclared("_GUI_MAIN_WIDTH") Then _GUIToolTip_SetMaxTipWidth($g_hToolTip, $_GUI_MAIN_WIDTH)
	_GUIToolTip_SetDelayTime($g_hToolTip, $TTDT_INITIAL, 150)
	_GUIToolTip_SetDelayTime($g_hToolTip, $TTDT_RESHOW, 50)
	_GUIToolTip_SetDelayTime($g_hToolTip, $TTDT_AUTOPOP, 15000)
	Return True
EndFunc   ;==>_BotToolTipConfigure

Func _BotToolTip($text = "", $x = Default, $y = Default, $title = Default, $icon = Default, $options = Default)
	If IsDeclared("g_bDisableBotToolTips") And $g_bDisableBotToolTips Then
		ToolTip("")
		Return
	EndIf
	Return ToolTip($text, $x, $y, $title, $icon, $options)
EndFunc   ;==>_BotToolTip

Func _GUICtrlGetControlID($hCtrl = -1)
	Local $aRet = DllCall("user32.dll", "int", "GetDlgCtrlID", "hwnd", ($hCtrl = -1 ? GUICtrlGetHandle(-1) : $hCtrl))
	Return (IsArray($aRet) ? $aRet[0] : -1)
EndFunc   ;==>_GUICtrlGetControlID
