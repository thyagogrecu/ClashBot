
; #FUNCTION# ====================================================================================================================
; Name ..........: SelectDropTroop
; Description ...:
; Syntax ........: SelectDropTroop($iTroopIndex)
; Parameters ....: $iTroopIndex : Index of any Troop from Barbarian to Siege Machines
; Return values .: None
; Author ........:
; Modified ......: Fliegerfaust (12/2018)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SelectDropTroop($iSlotIndex, $iClicks = 1, $iDelay = Default, $bCheckAttackPage = Default)
	If $iDelay = Default Then $iDelay = 0
	If $bCheckAttackPage = Default Then $bCheckAttackPage = True
	If $iSlotIndex < 0 Or $iSlotIndex >= UBound($g_avAttackTroops) Then Return False
	Local $aPosition = GetSlotPosition($iSlotIndex)
	If $aPosition[0] <= 0 Or $aPosition[1] <= 0 Or $aPosition[0] >= $g_iGAME_WIDTH Or $aPosition[1] >= $g_iGAME_HEIGHT Then Return False
	If $bCheckAttackPage And Not IsAttackPage() Then
		If _SleepAttack(100) Then Return False
		If Not IsAttackPage(True) Then
			SetDebugLog("Troop selection skipped: attack screen not confirmed", $COLOR_WARNING)
			Return False
		EndIf
	EndIf
	ClickP($aPosition, $iClicks, $iDelay, "#0111")
	Return True
EndFunc   ;==>SelectDropTroop

Func GetSlotPosition($iSlotIndex, $bOCRPosition = False)
	Local $aiReturnPosition[2] = [0, 0]

	If $iSlotIndex < 0 Or $iSlotIndex > UBound($g_avAttackTroops, 1) - 1 Then 
		SetDebugLog("GetSlotPosition(" & $iSlotIndex & ", " & $bOCRPosition & "): Invalid slot index: " & $iSlotIndex)
		Return $aiReturnPosition ;Invalid Slot Index returns Click Position X: 0 And Y:0
	EndIf
		
	If Not $bOCRPosition Then
		$aiReturnPosition[0] = $g_avAttackTroops[$iSlotIndex][2]
		$aiReturnPosition[1] = $g_avAttackTroops[$iSlotIndex][3]
	Else
		$aiReturnPosition[0] = $g_avAttackTroops[$iSlotIndex][4]
		$aiReturnPosition[1] = $g_avAttackTroops[$iSlotIndex][5]
	EndIf
	Return $aiReturnPosition
EndFunc   ;==>GetSlotPosition
