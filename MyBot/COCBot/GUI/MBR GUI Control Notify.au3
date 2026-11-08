;#FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Notify
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func chkPBTGenabled()

	If GUICtrlRead($g_hChkNotifyTGEnable) = $GUI_CHECKED Then
		$g_bNotifyTGEnable = True
		GUICtrlSetState($g_hTxtNotifyTGToken, $GUI_ENABLE)
	Else
		$g_bNotifyTGEnable = False
		GUICtrlSetState($g_hTxtNotifyTGToken, $GUI_DISABLE)
	EndIf

	If $g_bNotifyTGEnable = True Then
		GUICtrlSetState($g_hChkNotifyRemote, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtNotifyOrigin, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertMatchFound, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertLastRaidIMG, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertClanGames, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertLastRaidTXT, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertOutOfSync, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertTakeBreak, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertVillageStats, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertLastAttack, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertAnotherDevice, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertCampFull, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertBuilderIdle, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertMaintenance, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertBAN, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyBOTUpdate, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertSmartWaitTime, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertSwitchAccount, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertLaboratoryIdle, $GUI_ENABLE)
		GUICtrlSetState($g_hChkNotifyAlertBuilderBaseSwitch, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnNotifyAll, $GUI_ENABLE)
		GUICtrlSetState($g_hBtnNotifyReset, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hChkNotifyRemote, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtNotifyOrigin, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertMatchFound, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertLastRaidIMG, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertClanGames, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertLastRaidTXT, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertOutOfSync, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertTakeBreak, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertVillageStats, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertLastAttack, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertAnotherDevice, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertCampFull, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertBuilderIdle, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertMaintenance, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertBAN, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyBOTUpdate, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertSmartWaitTime, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertSwitchAccount, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertLaboratoryIdle, $GUI_DISABLE)
		GUICtrlSetState($g_hChkNotifyAlertBuilderBaseSwitch, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnNotifyAll, $GUI_DISABLE)
		GUICtrlSetState($g_hBtnNotifyReset, $GUI_DISABLE)
	EndIf
	SetNotifyCalendarState()
EndFunc   ;==>chkPBTGenabled

Func SetNotifyCalendarState()
	Local $bHoursEnabled = $g_bNotifyTGEnable And GUICtrlRead($g_hChkNotifyOnlyHours) = $GUI_CHECKED
	Local $bWeekDaysEnabled = $bHoursEnabled And GUICtrlRead($g_hChkNotifyOnlyWeekDays) = $GUI_CHECKED

	GUICtrlSetState($g_hChkNotifyOnlyHours, $g_bNotifyTGEnable ? $GUI_ENABLE : $GUI_DISABLE)
	For $i = 0 To 23
		GUICtrlSetState($g_hChkNotifyhours[$i], $bHoursEnabled ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	GUICtrlSetState($g_hChkNotifyhoursE1, $bHoursEnabled ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_hChkNotifyhoursE2, $bHoursEnabled ? $GUI_ENABLE : $GUI_DISABLE)
	GUICtrlSetState($g_hChkNotifyOnlyWeekDays, $bHoursEnabled ? $GUI_ENABLE : $GUI_DISABLE)
	For $i = 0 To 6
		GUICtrlSetState($g_hChkNotifyWeekdays[$i], $bWeekDaysEnabled ? $GUI_ENABLE : $GUI_DISABLE)
	Next
	GUICtrlSetState($g_ahChkNotifyWeekdaysE, $bWeekDaysEnabled ? $GUI_ENABLE : $GUI_DISABLE)
EndFunc   ;==>SetNotifyCalendarState

Func NotifySelectAll()
	NotifySetAllOptions($GUI_CHECKED)
EndFunc   ;==>NotifySelectAll

Func NotifyResetAll()
	NotifySetAllOptions($GUI_UNCHECKED)
EndFunc   ;==>NotifyResetAll

Func NotifySetAllOptions($iState)
	Local $ahNotifyOptions[18] = [$g_hChkNotifyAlertLastAttack, $g_hChkNotifyAlertAnotherDevice, $g_hChkNotifyAlertCampFull, _
			$g_hChkNotifyAlertLastRaidIMG, $g_hChkNotifyAlertLastRaidTXT, $g_hChkNotifyAlertBAN, $g_hChkNotifyBOTUpdate, _
			$g_hChkNotifyAlertBuilderIdle, $g_hChkNotifyAlertOutOfSync, $g_hChkNotifyAlertLaboratoryIdle, $g_hChkNotifyAlertMaintenance, _
			$g_hChkNotifyAlertMatchFound, $g_hChkNotifyAlertSmartWaitTime, $g_hChkNotifyAlertSwitchAccount, $g_hChkNotifyAlertTakeBreak, _
			$g_hChkNotifyAlertBuilderBaseSwitch, $g_hChkNotifyAlertVillageStats, $g_hChkNotifyAlertClanGames]
	For $hControl In $ahNotifyOptions
		GUICtrlSetState($hControl, $iState)
	Next
EndFunc   ;==>NotifySetAllOptions

Func chkNotifyHours()
	If GUICtrlRead($g_hChkNotifyOnlyHours) <> $GUI_CHECKED Then
		GUICtrlSetState($g_hChkNotifyOnlyWeekDays, $GUI_UNCHECKED)
	EndIf
	SetNotifyCalendarState()
EndFunc   ;==>chkNotifyHours

Func chkNotifyhoursE1()
    Local $b = GUICtrlRead($g_hChkNotifyhoursE1) = $GUI_CHECKED And GUICtrlRead($g_hChkNotifyhours[0]) = $GUI_CHECKED
    For $i = 0 To 11
	   GUICtrlSetState($g_hChkNotifyhours[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
    Next
	Sleep(300)
	GUICtrlSetState($g_hChkNotifyhoursE1, $GUI_UNCHECKED)
EndFunc   ;==>chkNotifyhoursE1

Func chkNotifyhoursE2()
    Local $b = GUICtrlRead($g_hChkNotifyhoursE2) = $GUI_CHECKED And GUICtrlRead($g_hChkNotifyhours[12]) = $GUI_CHECKED
	For $i = 12 To 23
	   GUICtrlSetState($g_hChkNotifyhours[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
    Next
	Sleep(300)
	GUICtrlSetState($g_hChkNotifyhoursE2, $GUI_UNCHECKED)
EndFunc		;==>chkNotifyhoursE2

Func chkNotifyWeekDays()
	SetNotifyCalendarState()
EndFunc	;==>chkNotifyWeekDays

Func ChkNotifyWeekdaysE()
	Local $b = BitOR(GUICtrlRead($g_hChkNotifyWeekdays[0]), GUICtrlRead($g_hChkNotifyWeekdays[1]), GUICtrlRead($g_hChkNotifyWeekdays[2]), GUICtrlRead($g_hChkNotifyWeekdays[3]), GUICtrlRead($g_hChkNotifyWeekdays[4]), GUICtrlRead($g_hChkNotifyWeekdays[5]), GUICtrlRead($g_hChkNotifyWeekdays[6])) = $GUI_CHECKED
	For $i = 0 To 6
		GUICtrlSetState($g_hChkNotifyWeekdays[$i], $b ? $GUI_UNCHECKED : $GUI_CHECKED)
	Next
	Sleep(300)
	GUICtrlSetState($g_ahChkNotifyWeekdaysE, $GUI_UNCHECKED)
EndFunc   ;==>ChkNotifyWeekdaysE
