; #FUNCTION# ====================================================================================================================
; Name ..........: IsSearchModeActive
; Description ...:
; Syntax ........: IsSearchModeActive($g_iMatchMode)
; Parameters ....:
; Return values .: None
; Author ........: Sardo (2016-01)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func IsSearchModeActive($g_iMatchMode, $bDontCheckHeroes = False, $bNoLog = False)
	Local $currentSearch = $g_iSearchCount + 1
	Local $bSkipTraining = $g_bSkipTrainingSystem
	Local $currentArmyCamps = $bSkipTraining ? 100 : ($g_iTotalCampSpace > 0 ? Int($g_CurrentCampUtilization / $g_iTotalCampSpace * 100) : 0)
	Local $bMatchModeEnabled = False

	Local $checkSearches = Int($currentSearch) >= Int($g_aiSearchSearchesMin[$g_iMatchMode]) And Int($currentSearch) <= Int($g_aiSearchSearchesMax[$g_iMatchMode]) And $g_abSearchSearchesEnable[$g_iMatchMode]
	Local $checkArmyCamps = $bSkipTraining Or (Int($currentArmyCamps) >= Int($g_aiSearchCampsPct[$g_iMatchMode]) And $g_abSearchCampsEnable[$g_iMatchMode])

	Switch $g_iMatchMode
		Case $DB
			$bMatchModeEnabled = $g_abAttackTypeEnable[$DB]
		Case $LB
			$bMatchModeEnabled = $g_abAttackTypeEnable[$LB]
		Case Else
			$bMatchModeEnabled = False
	EndSwitch

	If Not $bMatchModeEnabled Then Return False ; exit if no DB, LB, TS mode enabled

	If ($checkSearches Or $g_abSearchSearchesEnable[$g_iMatchMode] = False) And ($checkArmyCamps Or $g_abSearchCampsEnable[$g_iMatchMode] = False) Then
		If $g_bDebugSetLog And Not $bNoLog Then SetLog($g_asModeText[$g_iMatchMode] & " active! ($checkSearches=" & $checkSearches & _
				",$checkArmyCamps=" & $checkArmyCamps & ")", $COLOR_INFO)
		Return True
	EndIf

	If $g_bDebugSetLog And Not $bNoLog Then
		SetLog($g_asModeText[$g_iMatchMode] & " not active!", $COLOR_INFO)
		Local $txtsearches = "Fail"
		If $checkSearches Then $txtsearches = "Success"
		Local $txtArmyCamp = "Fail"
		If $checkArmyCamps Then $txtArmyCamp = "Success"
		If $g_abSearchSearchesEnable[$g_iMatchMode] Then SetLog("searches range: " & $g_aiSearchSearchesMin[$g_iMatchMode] & "-" & $g_aiSearchSearchesMax[$g_iMatchMode] & "  actual value: " & $currentSearch & " - " & $txtsearches, $COLOR_INFO)
		If $g_abSearchCampsEnable[$g_iMatchMode] Then SetLog("Army camps % range >=: " & $g_aiSearchCampsPct[$g_iMatchMode] & " actual value: " & $currentArmyCamps & " | " & $txtArmyCamp, $COLOR_INFO)
	EndIf

	Return False
EndFunc   ;==>IsSearchModeActive

Func IsSearchModeActiveMini(Const $iMatchMode)
	Return $g_abAttackTypeEnable[$iMatchMode]
EndFunc   ;==>IsSearchModeActiveMini
