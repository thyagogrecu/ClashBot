; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchAttackEnabled
; Description ...: Determines if user has selected to not attack. Uses GUI schedule, random time, or daily attack limit options to stop attacking
; Syntax ........: IsSearchAttackEnabled()
; Parameters ....:
; Return values .: True = attacking is enabled, False = attacking is disabled
; Author ........: MonkeyHunter (06-2016)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; ===============================================================================================================================
Func IsSearchAttackEnabled()
	SetDebugLog("Begin IsSearchAttackScheduled:", $COLOR_DEBUG1)

	If $g_bAttackPlannerEnable = False Then Return True

	Local $sStartTime = "", $sEndTime = ""
	Local $aNoAttackTimes[2] = [$sStartTime, $sEndTime]
	Local $iWaitTime = 0
	Local $bCloseGame = $g_bAttackPlannerCloseCoC Or $g_bAttackPlannerCloseAll Or $g_bAttackPlannerSuspendComputer
	SetDebugLog("$bCloseGame:" & $bCloseGame, $COLOR_DEBUG)

	If $g_bAttackPlannerDayLimit And _OverAttackLimit() Then
		SetLog("Daily attack limit reached, skip attacks till new day starts!", $COLOR_INFO)
		If _Sleep($DELAYRESPOND) Then Return True
		If $bCloseGame Then
			$iWaitTime = _getTimeRemainTimeToday()
			UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer)
			If $g_bCloseWhileTrainingEnable Then
				$MaxConsecutiveAttacks = Random($g_iAttackconsecutiveMin, $g_iAttackconsecutiveMax, 1)
				$g_aiAttackedCountPause = $g_aiAttackedCount
			EndIf
			$g_bRestart = True
			Return False
		Else
			Return False
		EndIf
	EndIf

	If $g_bAttackPlannerRandomEnable Then
		$aNoAttackTimes = _getDailyRandomStartEnd($g_iAttackPlannerRandomTime)
		If @error Then
			SetLog(@extended, $COLOR_ERROR)
			Return True
		EndIf
		If _IsTimeInRange($aNoAttackTimes[0], $aNoAttackTimes[1]) Then
			SetLog("Attack schedule random skip time found", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return True
			If $bCloseGame Then
				$iWaitTime = _DateDiff("s", _NowCalc(), $aNoAttackTimes[1])
				If @error Then
					_logErrorDateDiff(@error)
					SetError(1, "Can not find NoAttack wait time", True)
					Return True
				EndIf
				UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer)
				If $g_bCloseWhileTrainingEnable Then
					$MaxConsecutiveAttacks = Random($g_iAttackconsecutiveMin, $g_iAttackconsecutiveMax, 1)
					$g_aiAttackedCountPause = $g_aiAttackedCount
				EndIf
				$g_bRestart = True
				Return False
			Else
				Return False
			EndIf
		Else
			Return True
		EndIf
	Else
		If Not IsPlannedTimeNow() Then
			SetLog("Attack schedule planned skip time found", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return True
			If $bCloseGame Then
				$iWaitTime = _getPlannedAttackWaitTime()
				SetDebugLog("Stop attack wait time= " & $iWaitTime & " Seconds", $COLOR_DEBUG)
				UniversalCloseWaitOpenCoC($iWaitTime * 1000, "IsSearchAttackScheduled_", $g_bAttackPlannerCloseAll, True, $g_bAttackPlannerSuspendComputer)
				If $g_bCloseWhileTrainingEnable Then
					$MaxConsecutiveAttacks = Random($g_iAttackconsecutiveMin, $g_iAttackconsecutiveMax, 1)
					$g_aiAttackedCountPause = $g_aiAttackedCount
				EndIf
				$g_bRestart = True
				Return False
			Else
				Return False
			EndIf
		EndIf
	EndIf
	Return True
EndFunc   ;==>IsSearchAttackEnabled

Func _getTimeRemainTimeToday()
	Local $iTimeRemain = _DateDiff("s", _NowCalc(), _NowCalcDate() & " 23:59:59")
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not determine time remaining today", 0)
		Return 0
	EndIf
	SetDebugLog("getTimeRemainToday= " & $iTimeRemain & " Seconds", $COLOR_DEBUG)
	Return $iTimeRemain
EndFunc   ;==>_getTimeRemainTimeToday

Func _IsTimeAfter($sCompareTime, $sCurrentTime = _NowCalc())
	Local $bResult = _DateDiff("s", $sCurrentTime, $sCompareTime) < 0
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not check if time is after", False)
		Return False
	EndIf
	SetDebugLog("IsTimeAfter: " & $bResult, $COLOR_DEBUG)
	Return $bResult
EndFunc   ;==>_IsTimeAfter

Func _IsTimeBefore($sCompareTime, $sCurrentTime = _NowCalc())
	Local $bResult = _DateDiff("s", $sCurrentTime, $sCompareTime) > 0
	If @error Then
		_logErrorDateDiff(@error)
		SetError(1, "Can not check if time is before", False)
		Return False
	EndIf
	SetDebugLog("IsTimeBefore: " & $bResult, $COLOR_DEBUG)
	Return $bResult
EndFunc   ;==>_IsTimeBefore

Func _IsTimeInRange($sStartTime, $sEndTime)
	Local $sCurrentTime = _NowCalc()
	Local $bResult = _IsTimeAfter($sStartTime, $sCurrentTime) And _IsTimeBefore($sEndTime, $sCurrentTime)
	SetDebugLog("IsTimeInRange: " & $bResult, $COLOR_DEBUG)
	Return $bResult
EndFunc   ;==>_IsTimeInRange

Func _getDailyRandomStartEnd($iDuration = 4)
	Local Static $iNowDay = -1
	If Not ($iDuration >= 0 And $iDuration <= 24) Then
		SetError(1, "Invalid duration for _getDailyRandomStartEnd")
		Return
	EndIf
	Local Static $aNoAttackTimes[2] = ["", ""]
	Local $iDayKey = @YEAR * 1000 + @YDAY
	If $iNowDay <> $iDayKey Then
		Local $iStartHour = Int(_getDailyRandom() * 24)
		If $iStartHour > 23 Then $iStartHour = 23
		Local $sStartDate = _NowCalcDate()
		Local $sStartTime = $sStartDate & " " & StringFormat("%02d:00:00", $iStartHour)
		If _DateDiff("s", _NowCalc(), $sStartTime) <= 0 Then $sStartTime = _DateAdd("d", 1, $sStartDate) & " " & StringFormat("%02d:00:00", $iStartHour)
		If @error Then
			_logErrorDateDiff(@error)
			SetError(2, "Can not create random start time")
			Return
		EndIf
		$aNoAttackTimes[0] = $sStartTime
		$aNoAttackTimes[1] = _DateAdd("h", Int($iDuration), $sStartTime)
		If @error Then
			_logErrorDateDiff(@error)
			SetError(3, "Can not create random end time")
			Return
		EndIf
		$iNowDay = $iDayKey
		SetDebugLog("StartHour: " & $iStartHour & " Duration: " & $iDuration, $COLOR_DEBUG)
	EndIf
	SetDebugLog("NoAttackStart: " & $aNoAttackTimes[0] & "NoAttackEnd: " & $aNoAttackTimes[1], $COLOR_DEBUG)
	Return $aNoAttackTimes
EndFunc   ;==>_getDailyRandomStartEnd

Func _getDailyRandom()
	Local Static $iDailyRandomValue = Random(0.001, 1, 4)
	Local Static $iNowDay = @YDAY
	If $iNowDay <> @YDAY Then
		$iDailyRandomValue = Round(Random(0.001, 1), 4)
		$iNowDay = @YDAY
		SetDebugLog("New day = new random value!", $COLOR_DEBUG)
	EndIf
	SetDebugLog("DailyRandomValue=" & StringFormat("%0.5f", $iDailyRandomValue), $COLOR_DEBUG)
	Return $iDailyRandomValue
EndFunc   ;==>_getDailyRandom

Func IsPlannedTimeNow()
	Local $hour, $hourloot
	If $g_abPlannedAttackWeekDays[@WDAY - 1] = True Then
		$hour = StringSplit(_NowTime(4), ":", $STR_NOCOUNT)
		$hourloot = $hour[0]
		If $g_abPlannedAttackHours[$hourloot] = True Then
			SetDebugLog("Attack plan enabled for now..", $COLOR_DEBUG)
			Return True
		Else
			SetLog("Attack plan enabled today, but not this hour", $COLOR_INFO)
			If _Sleep($DELAYRESPOND) Then Return False
			Return False
		EndIf
	Else
		SetLog("Attack plan not enabled today", $COLOR_INFO)
		If _Sleep($DELAYRESPOND) Then Return False
		Return False
	EndIf
EndFunc   ;==>IsPlannedTimeNow

Func _getPlannedAttackWaitTime()
	Local $sNow = _NowCalc()
	Local $iCurrentDay = @WDAY - 1
	For $iDayOffset = 0 To 7
		Local $iDayIndex = Mod($iCurrentDay + $iDayOffset, 7)
		If Not $g_abPlannedAttackWeekDays[$iDayIndex] Then ContinueLoop
		For $iHour = 0 To 23
			If Not $g_abPlannedAttackHours[$iHour] Then ContinueLoop
			If $iDayOffset = 0 And $iHour <= @HOUR Then ContinueLoop
			Local $sDate = _DateAdd("d", $iDayOffset, _NowCalcDate())
			Local $iWait = _DateDiff("s", $sNow, $sDate & " " & StringFormat("%02d:00:00", $iHour))
			If $iWait > 0 Then Return $iWait
		Next
	Next
	Return 7 * 86400
EndFunc   ;==>_getPlannedAttackWaitTime

Func _OverAttackLimit()
	Local Static $iAttackCountToday = 0
	Local Static $iTotalAttackCount = $g_aiAttackedCount
	Local Static $iNowDay = @YDAY
	If $iNowDay <> @YDAY Then
		$iAttackCountToday = 0
		$iNowDay = @YDAY
		$iTotalAttackCount = $g_aiAttackedCount
	Else
		$iAttackCountToday = $g_aiAttackedCount - $iTotalAttackCount
	EndIf
	SetDebugLog("AttackCountToday: " & $iAttackCountToday & ", AttackedCount: " & $g_aiAttackedCount & "TotalAttackCount: " & $iTotalAttackCount, $COLOR_DEBUG)
	Local $iRandomAttackCountToday = Ceiling(Int($g_iAttackPlannerDayMin) + (_getDailyRandom() * (Int($g_iAttackPlannerDayMax) - Int($g_iAttackPlannerDayMin))))
	If $iRandomAttackCountToday > Int($g_iAttackPlannerDayMax) Then $iRandomAttackCountToday = Int($g_iAttackPlannerDayMax)
	SetDebugLog("RandomAttackCountToday: " & $iRandomAttackCountToday, $COLOR_DEBUG)
	If $iAttackCountToday >= $iRandomAttackCountToday Then Return True
	Return False
EndFunc   ;==>_OverAttackLimit
