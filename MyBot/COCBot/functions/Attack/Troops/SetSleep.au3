; #FUNCTION# ====================================================================================================================
; Name ..........: SetSleep
; Description ...: Randomizes deployment wait time
; Syntax ........: SetSleep($type)
; Parameters ....: $type                - Flag for type return desired.
; Return values .: None
; Author ........:
; Modified ......: KnowJack (06/2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func SetSleep($iType)
	If IsKeepClicksActive() Then Return 0 ; fast bulk deploy
	Local $iTiming = GetAttackDropTiming()
	Local $iFactorZero = 10 * $iTiming
	Local $iFactorOne = 100 * $iTiming

	If $g_bAndroidAdbClick Then
		; adjust for slow ADB clicks the delay factor
		$iFactorZero = 10 * $iTiming
		$iFactorOne = 100 * $iTiming
	EndIf

	Switch $iType
		Case 0
			Return Round(Random(1, 10)) * $iFactorZero
		Case 1
			Return Round(Random(1, 10)) * $iFactorOne
	EndSwitch
EndFunc   ;==>SetSleep

Func GetAttackDropTiming()
	Local $iTiming = $g_iAttackDropTiming
	If $iTiming < 1 Or $iTiming > 9 Then $iTiming = 1
	Return $iTiming
EndFunc   ;==>GetAttackDropTiming

Func IsFastAttackDropTiming()
	Return GetAttackDropTiming() = 1
EndFunc   ;==>IsFastAttackDropTiming

; #FUNCTION# ====================================================================================================================
; Name ..........: _SleepAttack
; Description ...: Version of _Sleep() used in attack code so active keep clicks mode doesn't slow down bulk deploy
; Syntax ........: see _Sleep
; Parameters ....: see _Sleep
; Return values .: see _Sleep
; Author ........: cosote (2016)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func _SleepAttack($iDelay, $iSleep = True)
	If Not $g_bRunState Then
		ResumeAndroid()
		Return True
	EndIf
	If $g_bBotPaused Then
		TogglePauseSleep()
		If Not $g_bRunState Then Return True
	EndIf
	If IsKeepClicksActive() Then Return False
	Return _Sleep($iDelay, $iSleep)
EndFunc   ;==>_SleepAttack
