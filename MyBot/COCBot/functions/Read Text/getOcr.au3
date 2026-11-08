; #FUNCTION# ====================================================================================================================
; Name ..........: OCR
; Description ...: Gets complete value of gold/Elixir/DarkElixir/Trophy/Gem xxx,xxx
; Author ........: Didipe (2015)
; Modified ......: ProMac (2015), Hervidero (2015-12), MMHK (2016-12), MR.ViPER (2017-4), Moebius14 (2025-02)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func getYellowLevel($x_start, $y_start) ;  -> Get Hero/TownHall level
	Local $sResult = getOcrAndCapture("coc-YellowLevel", $x_start, $y_start, 170, 20, True)
	Return Number(StringRegExpReplace($sResult, "\D", ""))
EndFunc   ;==>getYellowLevel

Func getNameBuilding($x_start, $y_start) ; getNameBuilding(242,Y) -> Gets complete name and level of the buildings, bottom of screen
	Local Static $aObstacles[10] = ["Broken", "Cart", "Tree", "Mush", "Trunk", "Bush", "Bark", "Gem", "Cake", "Groove"]

	Local $sResult = getOcrAndCapture("coc-build", $x_start, $y_start, 420, 27)

	If StringInStr($sResult, "O T T O", $STR_CASESENSE) Then Return StringReplace($sResult, "O T T O", "O.T.T.O")
	If StringInStr($sResult, "B O B", $STR_CASESENSE) Then Return StringReplace($sResult, "B O B", "B.O.B")
	If StringInStr($sResult, "Helper", $STR_NOCASESENSEBASIC) Then Return $sResult

	For $i = 0 To UBound($aObstacles) - 1
		If StringInStr($sResult, $aObstacles[$i], $STR_NOCASESENSEBASIC) Then Return $sResult
	Next

	; A partial result such as "Builder's Hut (Level )" contains the Level label
	; but cannot be parsed by BuildingInfo. Retry with the alternate OCR only when
	; the complete numeric level is missing, and keep the original name if the
	; alternate read is also incomplete.
	If $sResult = "" Or Not StringRegExp($sResult, "(?i)\(\s*Level\s+\d+\s*\)") Then
		Local $sAlternateResult = getOcrAndCapture("coc-build2", $x_start, $y_start - 27, 420, 27)
		If $sResult = "" Or StringRegExp($sAlternateResult, "(?i)\(\s*Level\s+\d+\s*\)") Then $sResult = $sAlternateResult
	EndIf

	; The current building-title glyph for 8 is returned as "ii" by coc-build.
	; Normalize only that invalid token inside the Level field: "ii" -> 8 and
	; "1 ii" -> 18, while preserving every other OCR result unchanged.
	Local $aInvalidLevel = StringRegExp($sResult, "(?i)\(\s*Level\s+([0-9\s]*ii)\s*\)", 1)
	If IsArray($aInvalidLevel) Then
		Local $sNormalizedLevel = StringStripWS(StringRegExpReplace($aInvalidLevel[0], "(?i)ii", "8"), 8)
		$sResult = StringRegExpReplace($sResult, "(?i)\(\s*Level\s+[0-9\s]*ii\s*\)", "(Level " & $sNormalizedLevel & ")")
	EndIf

	Return $sResult
EndFunc   ;==>getNameBuilding

Func getGoldVillageSearch($x_start, $y_start) ;48, 69 -> Gets complete value of gold xxx,xxx while searching, top left, Getresources.au3
	Return getOcrAndCapture("coc-v-g", $x_start, $y_start, 90, 16, True)
EndFunc   ;==>getGoldVillageSearch

Func getRemainTrainTimer($x_start, $y_start, $bNeedCapture = True) ;
	Return getOcrAndCapture("coc-RemainTrain", $x_start, $y_start, 70, 16, True, False, $bNeedCapture)
EndFunc   ;==>getRemainTrainTimer

Func getElixirVillageSearch($x_start, $y_start) ;48, 69+29 -> Gets complete value of Elixir xxx,xxx, top left,  Getresources.au3
	Return getOcrAndCapture("coc-v-e", $x_start, $y_start, 90, 16, True)
EndFunc   ;==>getElixirVillageSearch

Func getDarkElixirVillageSearch($x_start, $y_start) ;48, 69+57 or 69+69  -> Gets complete value of Dark Elixir xxx,xxx, top left,  Getresources.au3
	Return getOcrAndCapture("coc-v-de", $x_start, $y_start, 75, 18, True)
EndFunc   ;==>getDarkElixirVillageSearch

Func getTrophyVillageSearch($x_start, $y_start) ;48, 69+99 or 69+69 -> Gets complete value of Trophies xxx,xxx , top left, Getresources.au3
	Return getOcrAndCapture("coc-v-t", $x_start, $y_start, 75, 18, True)
EndFunc   ;==>getTrophyVillageSearch

Func getTrophyMainScreen($x_start, $y_start) ; -> Gets trophy value, top left of main screen "VillageReport.au3"
	Local $sResult = StringRegExpReplace(getOcrAndCapture("coc-ms", $x_start, $y_start, 50, 16, True), "\D", "")

	If StringLen($sResult) < 3 Then
		Local Const $aTrophyOcrLanguages[4] = ["coc-cc-trophy", "coc-t-b", "coc-profile", "coc-v-t"]
		Local $sDebug = "coc-ms='" & $sResult & "'"

		For $i = 0 To UBound($aTrophyOcrLanguages) - 1
			Local $sRetry = StringRegExpReplace(getOcrAndCapture($aTrophyOcrLanguages[$i], $x_start - 1, $y_start - 1, 58, 18, True), "\D", "")
			$sDebug &= " " & $aTrophyOcrLanguages[$i] & "='" & $sRetry & "'"
			If StringLen($sRetry) >= 3 And StringLen($sRetry) <= 5 Then
				If $g_bDebugSetLog Then SetDebugLog("Main screen trophy OCR fallback: " & $sDebug, $COLOR_DEBUG)
				Return $sRetry
			EndIf
		Next

		If $g_bDebugSetLog Then SetDebugLog("Main screen trophy OCR fallback failed: " & $sDebug, $COLOR_DEBUG)
	EndIf

	Return $sResult
EndFunc   ;==>getTrophyMainScreen

Func getTrophyBuilderBase($x_start, $y_start) ; -> Gets Builder Base trophy value from the main screen
	; Use the numeric OCR model that has correctly recognized this Builder Base field.
	; Other models produced conflicting values (for example 3527 vs 4527), so voting
	; across different models can reject a valid read or select a wrong one.
	Local Const $aVerticalOffsets[5] = [0, -2, 2, -4, 4]
	Local $aReads[5], $sResult = ""
	For $i = 0 To UBound($aVerticalOffsets) - 1
		$sResult = StringRegExpReplace(getOcrAndCapture("coc-t-b", $x_start + 2, $y_start + $aVerticalOffsets[$i], 50, 18, True), "\D", "")
		$aReads[$i] = (StringLen($sResult) >= 1 And StringLen($sResult) <= 4) ? $sResult : ""
	Next

	; Prefer a result repeated at nearby capture positions.
	For $i = 0 To UBound($aReads) - 1
		If $aReads[$i] = "" Then ContinueLoop
		Local $iMatches = 0
		For $j = 0 To UBound($aReads) - 1
			If $aReads[$i] = $aReads[$j] Then $iMatches += 1
		Next
		If $iMatches >= 2 Then Return Number($aReads[$i])
	Next

	; If no offset agrees, keep the centered OCR result rather than reporting zero.
	Return Number($aReads[0])
EndFunc   ;==>getTrophyBuilderBase

Func getTrophyLossAttackScreen($x_start, $y_start) ; 48,214 or 48,184 WO/DE -> Gets red number of trophy loss from attack screen, top left
	Return getOcrAndCapture("coc-t-p", $x_start, $y_start, 50, 16, True)
EndFunc   ;==>getTrophyLossAttackScreen

Func getResourcesMainScreen($x_start, $y_start) ; -> Gets complete value of Gold/Elixir/Dark Elixir/Trophies/Gems xxx,xxx "VillageReport.au3"
	Return StringReplace(getOcrAndCapture("coc-ms", $x_start, $y_start, 125, 16, True), "-", "")
EndFunc   ;==>getResourcesMainScreen

Func getResourcesLoot($x_start, $y_start) ; -> Gets complete value of Gold/Elixir after attack xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 160, 22, True)
EndFunc   ;==>getResourcesLoot

Func getResourcesLootDE($x_start, $y_start) ; -> Gets complete value of Dark Elixir after attack xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 120, 22, True)
EndFunc   ;==>getResourcesLootDE

Func getResourcesLootT($x_start, $y_start) ; -> Gets complete value of Trophies after attack. xxx,xxx "AttackReport"
	Return getOcrAndCapture("coc-loot", $x_start, $y_start, 50, 22, True)
EndFunc   ;==>getResourcesLootT

Func getResourcesBonus($x_start, $y_start) ; -> Gets complete value of Gold/Elixir bonus loot in "AttackReport.au3"
	Return getOcrAndCapture("coc-bonus", $x_start, $y_start, 98, 20, True)
EndFunc   ;==>getResourcesBonus

Func getCostsUpgrade($x_start, $y_start) ; -> Gets complete value of Gold/Elixir bonus loot in "AttackReport.au3"
	Local $Result = getOcrAndCapture("coc-CostsUpgrades", $x_start, $y_start, 120, 18, True)
	Return StringRegExpReplace($Result, "[^0-9]", "")
EndFunc   ;==>getCostsUpgrade

Func getCostsUpgradeRed($x_start, $y_start) ; -> Gets complete value of Gold/Elixir xxx,xxx , RED text on green upgrade button."UpgradeBuildings.au3"
	Local $Result = StringReplace(getOcrAndCapture("coc-u-r", $x_start, $y_start, 120, 18, True), "b", "")
	Return $Result
EndFunc   ;==>getCostsUpgradeRed

Func getResourcesBonusPerc($x_start, $y_start) ; -> Gets complete value of Bonus % in "AttackReport.au3"
	Return getOcrAndCapture("coc-bonus", $x_start, $y_start, 48, 16, True)
EndFunc   ;==>getResourcesBonusPerc

Func getLabUpgrdResourceWht($x_start, $y_start) ; -> Gets complete value of Elixir/DE on the troop buttons, xxx,xxx for "laboratory.au3" and "starlaboratory.au3" when white text
	Return getOcrAndCapture("coc-lab-w", $x_start, $y_start, 85, 14, True)
EndFunc   ;==>getLabUpgrdResourceWht

Func getLabUpgrdResourceWhtNew($x_start, $y_start) ; -> Gets complete value of Elixir/DE on the troop buttons, xxx,xxx for "laboratory.au3" and "starlaboratory.au3" when white text
	Return getOcrAndCapture("coc-lab-wNew", $x_start, $y_start, 86, 14, True)
EndFunc   ;==>getLabUpgrdResourceWhtNew

Func getLabUpgrdResourceRed($x_start, $y_start) ; -> Gets complete value of Elixir/DE on the troop buttons,  xxx,xxx for "laboratory.au3" when red text
	Return getOcrAndCapture("coc-lab-r", $x_start, $y_start, 86, 14, True)
EndFunc   ;==>getLabUpgrdResourceRed

Func getStarLabUpgrdResourceRed($x_start, $y_start) ; -> Gets complete value of Elixir on the troop buttons,  xxx,xxx for "starlaboratory.au3" when red text
	Return getOcrAndCapture("coc-starlab-r", $x_start, $y_start, 85, 14, True)
EndFunc   ;==>getStarLabUpgrdResourceRed

Func getBldgUpgradeTime($x_start, $y_start) ; -> Gets complete remain building upgrade time
	Local $Result = StringLower(getOcrAndCapture("coc-uptime", $x_start, $y_start, 105, 18, True))
	Return StringRegExpReplace($Result, "[^0-9wdhms]", "")
EndFunc   ;==>getBldgUpgradeTime

Func getBldgUpgradeTime2($x_start, $y_start) ; -> Gets complete remain building upgrade time
	Return getOcrAndCapture("coc-uptime3", $x_start, $y_start, 110, 18, True) ; "12d 19h"
EndFunc   ;==>getBldgUpgradeTime2

Func getLabUpgradeTime($x_start, $y_start) ; -> Gets complete remain lab upgrade time V3 for Dec2022 update
	Return getOcrAndCapture("coc-uptime2", $x_start, $y_start, 100, 24, True) ; 95 is required to upgrades
EndFunc   ;==>getLabUpgradeTime

Func getLabUpgradeTime2($x_start, $y_start) ; -> Gets complete remain lab upgrade time V3 for Dec2022 update
	Return getOcrAndCapture("coc-uptime", $x_start, $y_start, 90, 18, True) ; 90 is required to upgrades > 10 days
EndFunc   ;==>getLabUpgradeTime2

Func getPetUpgradeTime($x_start, $y_start) ; -> Gets complete remain lab upgrade time V4 for Jun2023 update
	Return getOcrAndCapture("coc-uptime2", $x_start, $y_start, 215, 24, True)
EndFunc   ;==>getPetUpgradeTime

Func getHeroUpgradeTime($x_start, $y_start) ; -> Gets complete upgrade time for heroes 595, 490 + $g_iMidOffsetY
	Local $Result = StringReplace(getOcrAndCapture("coc-uptime", $x_start, $y_start, 110, 18, True), "b", "")
	Return $Result
EndFunc   ;==>getHeroUpgradeTime

Func getHeroUpgradeTime2($x_start, $y_start) ; -> Gets complete upgrade time for heroes 595, 490 + $g_iMidOffsetY
	Local $Result = StringReplace(getOcrAndCapture("coc-uptime3", $x_start, $y_start, 110, 18, True), "b", "")
	Return $Result
EndFunc   ;==>getHeroUpgradeTime2

Func getChatString($x_start, $y_start, $language) ; -> Get string chat request - Latin Alphabetic - EN "DonateCC.au3"
	Return getOcrAndCapture($language, $x_start, $y_start, 320, 16)
EndFunc   ;==>getChatString

Func getBuilders($x_start, $y_start, $bWideCrop = False, $bBuilderBase = False, $iCropHeight = Default) ;  -> Gets the free/total builder count
	Local $iWidth = $bWideCrop ? 45 : 40
	Local $iHeight = $bBuilderBase ? 18 : ($bWideCrop ? 24 : 20)
	If $iCropHeight <> Default Then $iHeight = $iCropHeight
	Local $sResult = getOcrAndCapture("coc-Builders", $x_start, $y_start, $iWidth, $iHeight, True)
	If _NormalizeBuilderCount($sResult) <> "" Then Return $sResult
	Local $sRetry = ""
	If $bBuilderBase Then
		$sRetry = getOcrAndCapture("coc-BBAttackAvail", $x_start, $y_start, $iWidth, $iHeight, True)
		If _NormalizeBuilderCount($sRetry) <> "" Then Return $sRetry
	EndIf
	$sRetry = getOcrAndCapture("coc-t-b", $x_start, $y_start, $iWidth, $iHeight, True)
	If _NormalizeBuilderCount($sRetry) <> "" Then Return $sRetry
	If $bBuilderBase Then
		Local $sBuilderDigits = StringRegExpReplace($sRetry, "\D", "")
		If StringLen($sBuilderDigits) = 2 And Number(StringLeft($sBuilderDigits, 1)) <= Number(StringRight($sBuilderDigits, 1)) And Number(StringRight($sBuilderDigits, 1)) > 0 Then
			Return StringLeft($sBuilderDigits, 1) & "#" & StringRight($sBuilderDigits, 1)
		EndIf
	EndIf
	Return $sResult
EndFunc   ;==>getBuilders

Func getProfile($x_start, $y_start) ;  -> Gets Attack Win/Defense Win/Donated/Received values - profile screen --> getProfile(160,268)  troops donation
	Return getOcrAndCapture("coc-profile", $x_start, $y_start, 55, 13, True)
EndFunc   ;==>getProfile

Func getTroopCountSmall($x_start, $y_start, $bNeedNewCapture = Default) ;  -> Gets troop amount on Attack Screen for non-selected troop kind
	Return getOcrAndCapture("coc-t-s", $x_start, $y_start, 57, 16, True, Default, $bNeedNewCapture)
EndFunc   ;==>getTroopCountSmall

Func getTroopCountBig($x_start, $y_start, $bNeedNewCapture = Default) ;  -> Gets troop amount on Attack Screen for selected troop kind
	Return getOcrAndCapture("coc-t-b", $x_start, $y_start, 55, 17, True, Default, $bNeedNewCapture)
EndFunc   ;==>getTroopCountBig

Func getTroopsSpellsLevel($x_start, $y_start, $bDebugImageSave = $g_bDebugImageSave) ;  -> Gets spell level on Attack Screen for selected spell kind (could be used for troops too)
	Local $Result = getOcrAndCapture("coc-spellslevel", $x_start, $y_start, 20, 14, True)
	If $bDebugImageSave Then
		Local $sArea = $x_start & "," & $y_start & "," & $x_start + 20 & "," & $y_start + 14
		SaveDebugRectImage("SpellsOCR" & $Result, $sArea)
	EndIf
	Return $Result
EndFunc   ;==>getTroopsSpellsLevel

Func getPetsLevel($x_start, $y_start, $bDebugImageSave = $g_bDebugImageSave) ;  -> Gets Pets level.
	Local $Result = StringReplace(getOcrAndCapture("coc-petslevel", $x_start, $y_start, 20, 16, True), "b", "")
	If $bDebugImageSave Then
		Local $sArea = $x_start & "," & $y_start & "," & $x_start + 20 & "," & $y_start + 16
		SaveDebugRectImage("PetsOCR" & $Result, $sArea)
	EndIf
	Return $Result
EndFunc   ;==>getPetsLevel

Func getSiegeLevel($x_center, $y_center, $bDebugImageSave = $g_bDebugImageSave) ;  -> Gets Siege level on Attack Screen (x_center/y_center = center of the level digit)
	Local $Result = "", $sRaw = "", $sDigits = ""
	Local $iBestCandidate = 0, $sBestRaw = "", $sBestDigits = ""
	Local Const $iCaptureWidth = 20, $iCaptureHeight = 18
	; Compute top-left corner from digit center so the capture box is centered on the digit
	Local $x_start = $x_center - Int($iCaptureWidth / 2)
	Local $y_start = $y_center - Int($iCaptureHeight / 2)
	Local $iUsedX = $x_start, $iUsedY = $y_start

	; Try at base coords first, then small Y nudges in case of sub-pixel misalignment
	Local $aTryY[3] = [0, -3, 3]
	For $i = 0 To UBound($aTryY) - 1
		$sRaw = StringReplace(getOcrAndCapture("coc-siegelevel", $x_start, $y_start + $aTryY[$i], $iCaptureWidth, $iCaptureHeight, True), "b", "")
		$sDigits = StringRegExpReplace($sRaw, "[^0-9]", "")
		If $sDigits <> "" Then
			Local $iCandidate = Number(StringLeft($sDigits, 1)) ; leftmost digit is the level glyph
			If $iCandidate >= 1 And $iCandidate <= 6 Then
				; Keep first valid read, but prefer a non-1 level if found in later attempts.
				If $iBestCandidate = 0 Or ($iBestCandidate = 1 And $iCandidate > 1) Then
					$iBestCandidate = $iCandidate
					$iUsedY = $y_start + $aTryY[$i]
					$sBestRaw = $sRaw
					$sBestDigits = $sDigits
				EndIf

				; Highest possible level, no need to continue.
				If $iBestCandidate = 6 Then ExitLoop
			EndIf
		EndIf
	Next

	If $iBestCandidate > 0 Then
		$Result = String($iBestCandidate)
		$sRaw = $sBestRaw
		$sDigits = $sBestDigits
	EndIf

	If $g_bDebugSetLog Then SetDebugLog("getSiegeLevel raw='" & $sRaw & "' digits='" & $sDigits & "' -> " & ($Result = "" ? "?" : $Result) & " @ " & $iUsedX & "|" & $iUsedY)

	If $bDebugImageSave Then
		Local $sArea = $iUsedX & "," & $iUsedY & "," & $iUsedX + $iCaptureWidth & "," & $iUsedY + $iCaptureHeight
		SaveDebugRectImage("SiegeOCR" & $Result, $sArea)
	EndIf
	Return $Result
EndFunc   ;==>getSiegeLevel

Func getArmyCampCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Local $sRawResult = getOcrAndCapture("coc-camps", $x_start, $y_start, 55, 12, True, False, $bNeedCapture)
	Return __NormalizeArmyCampCapacity($sRawResult)
EndFunc   ;==>getArmyCampCap

Func __NormalizeArmyCampCapacity($sResult)
	$sResult = StringReplace($sResult, "/", "#")
	$sResult = StringRegExpReplace($sResult, "[^0-9#]", "")

	Local $aCapacity = StringSplit($sResult, "#")
	If IsArray($aCapacity) And $aCapacity[0] = 2 Then
		If $g_iTotalCampSpace > 0 Then
			Local $sProfileTotal = String($g_iTotalCampSpace)
			If StringLen($aCapacity[2]) > StringLen($sProfileTotal) And StringLeft($aCapacity[2], StringLen($sProfileTotal)) = $sProfileTotal Then $aCapacity[2] = $sProfileTotal
		ElseIf StringLen($aCapacity[2]) > 3 Then
			$aCapacity[2] = StringLeft($aCapacity[2], 3)
		EndIf
		If $aCapacity[1] <> "" And $aCapacity[2] <> "" And Number($aCapacity[2]) >= 10 And Number($aCapacity[2]) <= 999 And Number($aCapacity[1]) <= Number($aCapacity[2]) Then Return Number($aCapacity[1]) & "#" & Number($aCapacity[2])
	EndIf

	; Restores a missing separator without Town Hall limits.
	Local $sDigits = StringReplace($sResult, "#", "")
	Local $iLength = StringLen($sDigits), $iTotalDigits
	If $g_iTotalCampSpace > 0 Then
		Local $sKnownTotal = String($g_iTotalCampSpace)
		If $iLength > StringLen($sKnownTotal) And StringRight($sDigits, StringLen($sKnownTotal)) = $sKnownTotal Then
			Local $sKnownCurrent = StringTrimRight($sDigits, StringLen($sKnownTotal))
			; Removes one warning-icon digit only when capacity becomes invalid.
			If Number($sKnownCurrent) > $g_iTotalCampSpace And StringLen($sKnownCurrent) > 1 Then $sKnownCurrent = StringTrimRight($sKnownCurrent, 1)
			If Number($sKnownCurrent) <= $g_iTotalCampSpace Then Return Number($sKnownCurrent) & "#" & $g_iTotalCampSpace
		EndIf
	EndIf
	For $iTotalDigits = 3 To 2 Step -1
		If $iLength <= $iTotalDigits Then ContinueLoop
		Local $sCurrent = StringLeft($sDigits, $iLength - $iTotalDigits)
		Local $sTotal = StringRight($sDigits, $iTotalDigits)
		If StringLeft($sTotal, 1) = "0" Then ContinueLoop
		If Number($sTotal) >= 10 And Number($sTotal) <= 999 And Number($sCurrent) <= Number($sTotal) Then Return Number($sCurrent) & "#" & Number($sTotal)
	Next

	Return $sResult
EndFunc   ;==>__NormalizeArmyCampCapacity

Func getSpellsCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Local $Result = StringRegExpReplace(getOcrAndCapture("coc-camps", $x_start, $y_start, 35, 12, True, False, $bNeedCapture), "[a-z]", "")
	Return $Result
EndFunc   ;==>getSpellsCap

Func getSiegeCampCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Local $Result = StringRegExpReplace(getOcrAndCapture("coc-camps", $x_start, $y_start, 40, 16, True, False, $bNeedCapture), "[a-z]", "")
	Return $Result
EndFunc   ;==>getSiegeCampCap

Func getCCSpellCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Local $Result = StringRegExpReplace(getOcrAndCapture("coc-camps", $x_start, $y_start, 25, 12, True, False, $bNeedCapture), "[a-z]", "")
	Return $Result
EndFunc   ;==>getCCSpellCap

Func getCCSiegeCampCap($x_start, $y_start, $bNeedCapture = True) ;  -> Gets army camp capacity --> train.au3, and used to read CC request time remaining
	Local $Result = StringRegExpReplace(getOcrAndCapture("coc-camps", $x_start, $y_start, 28, 16, True, False, $bNeedCapture), "[a-z]", "")
	Return $Result
EndFunc   ;==>getCCSiegeCampCap

Func getCastleDonateCap($x_start, $y_start) ;  -> Gets clan castle capacity,  --> donatecc.au3
	Return getOcrAndCapture("coc-army", $x_start, $y_start, 40, 14, True)
EndFunc   ;==>getCastleDonateCap

Func getOcrLanguage($x_start, $y_start) ;  -> Get english language - main screen - "Attack" text on attack button
	Return getOcrAndCapture("coc-ms-testl", $x_start, $y_start, 93, 16, True)
EndFunc   ;==>getOcrLanguage

Func getOcrSpaceCastleDonate($x_start, $y_start) ;  -> Get the number of troops donated/capacity from a request
	Local $Result = StringReplace(getOcrAndCapture("coc-totalreq", $x_start, $y_start, 49, 14, True), "b", "")
	Return $Result
EndFunc   ;==>getOcrSpaceCastleDonate

Func getOcrSpaceCastleDonateShort($x_start, $y_start) ;  -> Get the number of troops donated/capacity from a request
	Local $Result = StringReplace(getOcrAndCapture("coc-totalreq", $x_start, $y_start, 35, 14, True), "b", "")
	Return $Result
EndFunc   ;==>getOcrSpaceCastleDonateShort

; #FUNCTION# ===========================================================================================================
; Name ..........: getOcrSpaceCastleDonateSpell
; Description ...: Reads spell donated and total capacity using the donation request digit profile.
; Remarks .......: Excludes the spell icon from the crop; falls back to coc-totalreq when validation fails.
; ======================================================================================================================

Func getOcrSpaceCastleDonateSpell($x_start, $y_start)
	Local $sResult = StringRegExpReplace(getOcrAndCapture("coc-NewSysDonate", $x_start + 10, $y_start, 28, 14, True), "[^0-9]", "")
	If StringRegExp($sResult, "^[0-9]{2}$") Then Return StringLeft($sResult, 1) & "#" & StringRight($sResult, 1)
	Return StringReplace(getOcrAndCapture("coc-totalreq", $x_start + 10, $y_start, 28, 14, True), "b", "")
EndFunc   ;==>getOcrSpaceCastleDonateSpell

Func getOcrOverAllDamage($x_start, $y_start, $iWidth = 50) ;  -> Get the Overall Damage %
	Return getOcrAndCapture("coc-overalldamage", $x_start, $y_start, $iWidth, 20, True)
EndFunc   ;==>getOcrOverAllDamage

Func getOcrGuardShield($x_start, $y_start) ;  -> Get the guard/shield time left, middle top of the screen
	Return getOcrAndCapture("coc-guardshield", $x_start, $y_start, 68, 15)
EndFunc   ;==>getOcrGuardShield

Func getCCBuildingName($x_start, $y_start) ;  -> Get BuildingName on builder menu
	Local $NameTemp = "", $BuildingName = "", $Count = 1
	For $i = 1 To 2
		$NameTemp = getOcrAndCapture("coc-ccbuildermenu-name", $x_start, $y_start, 200, 18, False)
		If $NameTemp = "" Then
			If _Sleep(50) Then Return
			$NameTemp = getOcrAndCapture("coc-ccbuildermenu-name", $x_start, $y_start + $i, 200, 18, False)
		Else
			ExitLoop
		EndIf
	Next
	Local $Name = StringReplace($NameTemp, "n l ", "")
	If StringRegExp($Name, "x\d{1,}") Then
		Local $aCount = StringRegExp($Name, "\d{1,}", 1) ;check if we found count of building
		If IsArray($aCount) Then $Count = $aCount[0]
	EndIf

	If StringLeft($Name, 2) = "l " Then
		$BuildingName = StringTrimLeft($Name, 2) ;remove first "l" because sometimes buildermenu border captured as "l"
	Else
		$BuildingName = $Name
	EndIf

	If StringRegExp($BuildingName, "x\d{1,}") Then
		Local $aReplace = StringRegExp($BuildingName, "( x\d{1,})", 1)
		Local $TmpBuildingName = StringReplace($BuildingName, $aReplace[0], "")
		$BuildingName = StringStripWS($TmpBuildingName, $STR_STRIPTRAILING)
	EndIf

	Local $aResult[2]
	$aResult[0] = $BuildingName
	$aResult[1] = Number($Count)
	Return $aResult
EndFunc   ;==>getCCBuildingName

Func getCCBuildingNameSuggested($x_start, $y_start) ;  -> Get BuildingName on builder menu
	Local $Name = "", $BuildingName = "", $Count = 1
	For $i = 1 To 2
		$Name = getOcrAndCapture("coc-ccbuildermenu-name", $x_start, $y_start, 200, 18, False)
		If $Name = "" Then
			If _Sleep(50) Then Return
			$Name = getOcrAndCapture("coc-ccbuildermenu-name", $x_start, $y_start + $i, 200, 18, False)
		Else
			ExitLoop
		EndIf
	Next

	If StringRegExp($Name, "x\d{1,}") Then
		Local $aCount = StringRegExp($Name, "\d{1,}", 1) ;check if we found count of building
		If IsArray($aCount) Then $Count = $aCount[0]
	EndIf

	If StringLeft($Name, 2) = "l " Then
		$BuildingName = StringTrimLeft($Name, 2) ;remove first "l" because sometimes buildermenu border captured as "l"
	Else
		$BuildingName = $Name
	EndIf

	If StringRegExp($BuildingName, "x\d{1,}") Then
		Local $aReplace = StringRegExp($BuildingName, "(x\d{1,})", 1)
		Local $TmpBuildingName = StringReplace($BuildingName, $aReplace[0], "")
		$BuildingName = StringStripWS($TmpBuildingName, $STR_STRIPTRAILING)
	EndIf

	If StringRight($BuildingName, 2) = " l" Then
		$BuildingName = StringTrimRight($BuildingName, 2) ;remove "l" at the end in some cases
	EndIf

	Local $aResult[2]
	$aResult[0] = $BuildingName
	$aResult[1] = Number($Count)
	Return $aResult
EndFunc   ;==>getCCBuildingNameSuggested

Func getCCBuildingNameBlue($x_start, $y_start) ;  -> Get BuildingName on builder menu
	Local $Name = "", $BuildingName = "", $Count = 1
	For $i = 1 To 2
		$Name = getOcrAndCapture("coc-ccbuildermenu-nameblue", $x_start, $y_start, 200, 18, False)
		If $Name = "" Then
			If _Sleep(50) Then Return
			$Name = getOcrAndCapture("coc-ccbuildermenu-nameblue", $x_start, $y_start + $i, 200, 18, False)
		Else
			ExitLoop
		EndIf
	Next
	If StringRegExp($Name, "x\d{1,}") Then
		Local $aCount = StringRegExp($Name, "\d{1,}", 1) ;check if we found count of building
		If IsArray($aCount) Then $Count = $aCount[0]
	EndIf

	If StringLeft($Name, 2) = "l " Then
		$BuildingName = StringTrimLeft($Name, 2) ;remove first "l" because sometimes buildermenu border captured as "l"
	Else
		$BuildingName = $Name
	EndIf

	If StringRegExp($BuildingName, "x\d{1,}") Then
		Local $aReplace = StringRegExp($BuildingName, "( x\d{1,})", 1)
		Local $TmpBuildingName = StringReplace($BuildingName, $aReplace[0], "")
		$BuildingName = StringStripWS($TmpBuildingName, $STR_STRIPTRAILING)
	EndIf

	If StringRight($BuildingName, 2) = " l" Then
		$BuildingName = StringTrimRight($BuildingName, 2) ;remove "l" at the end in some cases
	EndIf

	Local $aResult[2]
	$aResult[0] = $BuildingName
	$aResult[1] = Number($Count)
	Return $aResult
EndFunc   ;==>getCCBuildingNameBlue

Func getOcrReloadMessage($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	Local $Result = getOcrAndCapture("coc-reloadmsg", $x_start, $y_start, 116, 19, True)
	Local $String = ""
	If $sLogText = Default Then
		$String = "getOcrReloadMessage: " & $Result
	Else
		$String = $sLogText & " " & $Result
	EndIf
	If $g_bDebugSetLog Then ; if enabled generate debug log message
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	ElseIf $Result <> "" Then ;
		SetDebugLog($String, $LogTextColor, True) ; if result found, add to log file
	EndIf
	Return $Result
EndFunc   ;==>getOcrReloadMessage

Func getOcrMaintenanceTime($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	;  -> Get the Text with time till maintenance is over from reload msg(171, 375)
	Local $Result = getOcrAndCapture("coc-maintenance", $x_start, $y_start, 200, 18, True)
	Local $String = ""
	If $sLogText = Default Then
		$String = "getOcrMaintenanceTime: " & $Result
	Else
		$String = $sLogText & " " & $Result
	EndIf
	If $g_bDebugSetLog Then ; if enabled generate debug log message
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	ElseIf $Result <> "" Then ;
		SetDebugLog($String, $LogTextColor, True) ; if result found, add to log file
	EndIf
	Return $Result
EndFunc   ;==>getOcrMaintenanceTime

Func getOcrTimeGameTime($x_start, $y_start) ;  -> Get the guard/shield time left, middle top of the screen
	Return getOcrAndCapture("coc-clangames", $x_start, $y_start, 130, 26, True)
EndFunc   ;==>getOcrTimeGameTime

Func getOcrYourScore($x_start, $y_start) ; -> Gets CheckValuesCost on Train Window
	Return getOcrAndCapture("coc-events", $x_start, $y_start, 120, 16, True)
EndFunc   ;==>getOcrYourScore

Func getOcrEventTime($x_start, $y_start) ; -> Gets CheckValuesCost on Train Window
	Return getOcrAndCapture("coc-events", $x_start, $y_start, 35, 16, True)
EndFunc   ;==>getOcrEventTime

Func getOcrEventPoints($x_start, $y_start) ; -> Gets CheckValuesCost on Train Window
	Return getOcrAndCapture("coc-events", $x_start, $y_start, 68, 19, True)
EndFunc   ;==>getOcrEventPoints

Func getOcrRateCoc($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	;  -> Get the Text with time till maintenance is over from reload msg(228, 402)
	Local $Result = getOcrAndCapture("coc-ratecoc", $x_start, $y_start, 42, 28, True)
	Local $String = ""
	If $sLogText = Default Then
		$String = "getOcrRateCoc: " & $Result
	Else
		$String = $sLogText & " " & $Result
	EndIf
	If $g_bDebugSetLog Then ; if enabled generate debug log message
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	ElseIf $Result <> "" Then ;
		SetDebugLog($String, $LogTextColor, True) ; if result found, add to log file
	EndIf
	Return $Result
EndFunc   ;==>getOcrRateCoc

Func getRemainTLaboratory($x_start, $y_start) ; read actual time remaining in Lab for current upgrade (336,260), changed CoC v9.24 282,277
	Return getOcrAndCapture("coc-RemainLaboratory", $x_start, $y_start, 260, 28, True)
EndFunc   ;==>getRemainTLaboratory

Func _CleanRemainTLaboratoryOCR($sResult)
	$sResult = StringRegExpReplace(StringLower($sResult), "^[^0-9]*", "")
	Return StringRegExpReplace($sResult, "[^0-9dhms]", "")
EndFunc   ;==>_CleanRemainTLaboratoryOCR

Func _IsRemainTLaboratoryOCRValid($sResult)
	Return _RemainTLaboratoryOCRToMinutes($sResult) > 0
EndFunc   ;==>_IsRemainTLaboratoryOCRValid

Func _RemainTLaboratoryOCRToMinutes($sResult)
	If $sResult = "" Then Return -1

	Local $sTime = $sResult, $avResult, $iDay = 0, $iHour = 0, $iMinute = 0, $iSecond = 0

	If StringInStr($sTime, "d") > 1 Then
		$avResult = StringSplit($sTime, "d", $STR_NOCOUNT)
		$iDay = Number($avResult[0])
		$sTime = $avResult[1]
	EndIf
	If StringInStr($sTime, "h") > 1 Then
		$avResult = StringSplit($sTime, "h", $STR_NOCOUNT)
		$iHour = Number($avResult[0])
		$sTime = $avResult[1]
	EndIf
	If StringInStr($sTime, "m") > 1 Then
		$avResult = StringSplit($sTime, "m", $STR_NOCOUNT)
		$iMinute = Number($avResult[0])
		$sTime = $avResult[1]
	EndIf
	If StringInStr($sTime, "s") > 1 Then
		$avResult = StringSplit($sTime, "s", $STR_NOCOUNT)
		$iSecond = Number($avResult[0])
		$sTime = ""
	EndIf

	If $sTime <> "" And StringRegExp($sTime, "\d") Then Return -1
	If $iDay > 60 Or $iHour > 23 Or $iMinute > 59 Or $iSecond > 59 Then Return -1

	Return ($iDay * 1440) + ($iHour * 60) + $iMinute + Ceiling($iSecond / 60)
EndFunc   ;==>_RemainTLaboratoryOCRToMinutes

Func _GetRemainTLaboratoryOCR($sLanguage, $x_start, $y_start, $width, $height)
	Local $sResult = _CleanRemainTLaboratoryOCR(getOcrAndCapture($sLanguage, $x_start, $y_start, $width, $height, True, Default, True))
	If _IsRemainTLaboratoryOCRValid($sResult) Then Return $sResult
	If $sResult <> "" Then SetDebugLog("Rejected Laboratory OCR time: " & $sResult, $COLOR_DEBUG)
	Return ""
EndFunc   ;==>_GetRemainTLaboratoryOCR

Func _PickRemainTLaboratoryOCR(ByRef $sBestResult, ByRef $iBestMinutes, $sLanguage, $x_start, $y_start, $width, $height)
	Local $sResult = _GetRemainTLaboratoryOCR($sLanguage, $x_start - 5, $y_start, $width, $height)
	Local $iMinutes = _RemainTLaboratoryOCRToMinutes($sResult)
	If $iMinutes > $iBestMinutes Then
		$sBestResult = $sResult
		$iBestMinutes = $iMinutes
	EndIf
EndFunc   ;==>_PickRemainTLaboratoryOCR

Func getRemainTLaboratory2($x_start, $y_start) ; read actual time remaining in Lab for current upgrade (336,260), changed CoC v9.24 282,277
	Local $sResult = "", $iBestMinutes = -1
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-RemainLaboratory2", $x_start, $y_start, 180, 40)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-RemainLaboratory", $x_start, $y_start, 180, 40)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-uptime2", $x_start, $y_start, 180, 40)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-uptime", $x_start, $y_start, 180, 40)
	If $iBestMinutes <= 0 Then
		_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-RemainLaboratory2", $x_start, $y_start, 260, 40)
		_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-RemainLaboratory", $x_start, $y_start, 260, 40)
		_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-uptime2", $x_start, $y_start, 260, 40)
		_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-uptime", $x_start, $y_start, 260, 40)
	EndIf
	Return $sResult
EndFunc   ;==>getRemainTLaboratory2

Func getRemainTLaboratoryGob($x_start, $y_start) ; read actual time remaining in Lab for current upgrade (336,260), changed CoC v9.24 282,277
	Local $sResult = "", $iBestMinutes = -1
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-RemainLabGob", $x_start - 30, $y_start - 12, 130, 25)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-RemainLaboratory2", $x_start - 30, $y_start - 12, 130, 25)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-uptime2", $x_start - 30, $y_start - 12, 130, 25)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-uptime", $x_start - 30, $y_start - 12, 130, 25)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-RemainLabGob", $x_start, $y_start, 180, 40)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-RemainLaboratory2", $x_start, $y_start, 180, 40)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-uptime2", $x_start, $y_start, 180, 40)
	_PickRemainTLaboratoryOCR($sResult, $iBestMinutes, "coc-uptime", $x_start, $y_start, 180, 40)
	Return $sResult
EndFunc   ;==>getRemainTLaboratoryGob

Func getRemainTHero($x_start, $y_start, $bNeedCapture = True) ; Get time remaining for hero to be ready for attack from train window
	Local $Result = StringReplace(getOcrAndCapture("coc-remainhero", $x_start, $y_start, 55, 13, True, False, $bNeedCapture), "b", "")
	Return $Result
EndFunc   ;==>getRemainTHero

Func getCloudTextShort($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	; Get 3 characters of yellow text in center of attack search window during extended cloud waiting (388,378)
	; Full text length is 316 pixels, some is covered by chat window when open
	Local $Result = getOcrAndCapture("coc-cloudsearch", $x_start, $y_start, 51, 27)
	If $g_bDebugSetLog And $sLogText <> Default And IsString($sLogText) Then ; if enabled generate debug log message
		Local $String = $sLogText & $Result
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	EndIf
	Return $Result
EndFunc   ;==>getCloudTextShort

Func getCloudFailShort($x_start, $y_start, $sLogText = Default, $LogTextColor = Default, $bSilentSetLog = Default)
	; Get 6 characters of pink text in center of attack search window during failed attack search (271, 381)
	; Full text length is 318 pixels, on checking for 1st 6 characters
	Local $Result = getOcrAndCapture("coc-cloudfail", $x_start, $y_start, 72, 24)
	If $g_bDebugSetLog And $sLogText <> Default And IsString($sLogText) Then ; if enabled generate debug log message
		Local $String = $sLogText & $Result
		SetDebugLog($String, $LogTextColor, $bSilentSetLog)
	EndIf
	Return $Result
EndFunc   ;==>getCloudFailShort

Func getBarracksNewTroopQuantity($x_start, $y_start, $bNeedCapture = True) ;  -> Gets quantity of troops in army Window
	Local $Result = StringReplace(getOcrAndCapture("coc-newarmy", $x_start, $y_start, 31, 12, False, False, $bNeedCapture), "b", "")
	Return $Result
EndFunc   ;==>getBarracksNewTroopQuantity

Func getBarracksNewSpellQuantity($x_start, $y_start, $bNeedCapture = True) ;  -> Gets quantity of troops in army Window
	Local $Result = StringReplace(getOcrAndCapture("coc-newarmy", $x_start, $y_start, 22, 10, False, False, $bNeedCapture), "b", "")
	Return $Result
EndFunc   ;==>getBarracksNewSpellQuantity

Func getArmyCapacityOnTrainTroops($x_start, $y_start, $bNeedCapture = True) ;  -> Gets quantity of troops in army Window
	Local $Result = StringRegExpReplace(getOcrAndCapture("coc-camps", $x_start, $y_start, 55, 12, True, False, $bNeedCapture), "[a-z]", "")
	Return $Result
EndFunc   ;==>getArmyCapacityOnTrainTroops

Func getQueueTroopsQuantity($x_start, $y_start) ;  -> Gets quantity of troops in Queue in Train Tab
	Return StringReplace(getOcrAndCapture("coc-qqtroop", $x_start, $y_start, 40, 13, True), "b", "")
EndFunc   ;==>getQueueTroopsQuantity

Func getQuickTroopsQuantity($x_start, $y_start) ;  -> Gets quantity of troops in Queue in Train Tab
	Return StringReplace(getOcrAndCapture("coc-qqtroop", $x_start, $y_start, 35, 13, True), "b", "")
EndFunc   ;==>getQuickTroopsQuantity

Func getChatStringChinese($x_start, $y_start) ; -> Get string chat request - Chinese - "DonateCC.au3"
	Local $bUseOcrImgLoc = True
	Return getOcrAndCapture("chinese-bundle", $x_start, $y_start, 160, 14, Default, $bUseOcrImgLoc)
EndFunc   ;==>getChatStringChinese

Func getChatStringKorean($x_start, $y_start) ; -> Get string chat request - Korean - "DonateCC.au3"
	Local $bUseOcrImgLoc = True
	Return getOcrAndCapture("korean-bundle", $x_start, $y_start, 160, 14, Default, $bUseOcrImgLoc)
EndFunc   ;==>getChatStringKorean

Func getChatStringPersian($x_start, $y_start, $bConvert = True) ; -> Get string chat request - Persian - "DonateCC.au3"
	Local $bUseOcrImgLoc = True
	Local $OCRString = getOcrAndCapture("persian-bundle", $x_start, $y_start, 325, 23, Default, $bUseOcrImgLoc, True)
	If $bConvert = True Then
		$OCRString = StringReverse($OCRString)

		$OCRString = StringReplace($OCRString, "A", "?")
		$OCRString = StringReplace($OCRString, "B", "?")
		$OCRString = StringReplace($OCRString, "C", "?")
		$OCRString = StringReplace($OCRString, "D", "?")
		$OCRString = StringReplace($OCRString, "E", "?")
		$OCRString = StringReplace($OCRString, "F", "?")
		$OCRString = StringReplace($OCRString, "G", "?")
		$OCRString = StringReplace($OCRString, "H", "?")
		$OCRString = StringReplace($OCRString, "I", "?")
		$OCRString = StringReplace($OCRString, "J", "?")
		$OCRString = StringReplace($OCRString, "K", "?")
		$OCRString = StringReplace($OCRString, "L", "?")
		$OCRString = StringReplace($OCRString, "M", "?")
		$OCRString = StringReplace($OCRString, "N", "?")
		$OCRString = StringReplace($OCRString, "O", "?")
		$OCRString = StringReplace($OCRString, "P", "?")
		$OCRString = StringReplace($OCRString, "Q", "?")
		$OCRString = StringReplace($OCRString, "R", "?")
		$OCRString = StringReplace($OCRString, "S", "?")
		$OCRString = StringReplace($OCRString, "T", "?")
		$OCRString = StringReplace($OCRString, "U", "?")
		$OCRString = StringReplace($OCRString, "V", "?")
		$OCRString = StringReplace($OCRString, "W", "??")
		$OCRString = StringReplace($OCRString, "X", "?")
		$OCRString = StringReplace($OCRString, "Y", "?")
		$OCRString = StringReplace($OCRString, "Z", "?")

		$OCRString = StringReplace($OCRString, "Ä", "?")
		$OCRString = StringReplace($OCRString, "Â", "?")
		$OCRString = StringReplace($OCRString, "À", "?")
		$OCRString = StringReplace($OCRString, "Ç", "?")
		$OCRString = StringReplace($OCRString, "Ë", "?")
		$OCRString = StringReplace($OCRString, "Ê", "?")
		$OCRString = StringReplace($OCRString, "È", "?")
		$OCRString = StringReplace($OCRString, "É", "?")
		$OCRString = StringReplace($OCRString, "Ï", "?")
		$OCRString = StringReplace($OCRString, "Î", "?")
		$OCRString = StringReplace($OCRString, "Ö", "?")
		$OCRString = StringReplace($OCRString, "Ô", "?")
		$OCRString = StringReplace($OCRString, "Ü", "?")
		$OCRString = StringReplace($OCRString, "Û", "?")
		$OCRString = StringReplace($OCRString, "Ù", "?")

		$OCRString = StringReplace($OCRString, "?", "*")
		$OCRString = StringReplace($OCRString, "Y", ":")
		$OCRString = StringReplace($OCRString, "Ì", "/")
		$OCRString = StringReplace($OCRString, "Ò", ".")

		;$OCRString = StringReplace($OCRString, "Á", "")
		;$OCRString = StringReplace($OCRString, "Í", "")
		;$OCRString = StringReplace($OCRString, "Ó", "")
		;$OCRString = StringReplace($OCRString, "Ú", "")
		;$OCRString = StringReplace($OCRString, "S", "")
		;$OCRString = StringReplace($OCRString, "Z", "")

		$OCRString = StringReplace($OCRString, "O", "?")
		$OCRString = StringReplace($OCRString, "~", "?")
		$OCRString = StringReplace($OCRString, "ß", "?")
		$OCRString = StringReplace($OCRString, "´", "?")
		$OCRString = StringReplace($OCRString, "¯", "?")
		$OCRString = StringReplace($OCRString, "`", "?")
		$OCRString = StringReplace($OCRString, "Ø", " ")

		$OCRString = StringReplace($OCRString, "?", "?")
		$OCRString = StringReplace($OCRString, "¹", "?")
		$OCRString = StringReplace($OCRString, "²", "?")
		$OCRString = StringReplace($OCRString, "³", "?")
		$OCRString = StringReplace($OCRString, "?", "?")
		$OCRString = StringReplace($OCRString, "?", "?")
		$OCRString = StringReplace($OCRString, "?", "?")
		$OCRString = StringReplace($OCRString, "?", "?")
		$OCRString = StringReplace($OCRString, "?", "?")
		$OCRString = StringReplace($OCRString, "?", "?")

		$OCRString = StringStripWS($OCRString, 1 + 2)
	EndIf
	Return $OCRString
EndFunc   ;==>getChatStringPersian

Func OcrForceCaptureRegion($bForce = Default)
	If $bForce = Default Then Return $g_bOcrForceCaptureRegion
	Local $wasForce = $g_bOcrForceCaptureRegion
	$g_bOcrForceCaptureRegion = $bForce
	Return $wasForce
EndFunc   ;==>OcrForceCaptureRegion

Func getOcrAndCapture($language, $x_start, $y_start, $width, $height, $removeSpace = Default, $bImgLoc = Default, $bForceCaptureRegion = Default)
	If $removeSpace = Default Then $removeSpace = False
	If $bImgLoc = Default Then $bImgLoc = False
	If $bForceCaptureRegion = Default Then $bForceCaptureRegion = $g_bOcrForceCaptureRegion
	Static $_hHBitmap = 0
	If $bForceCaptureRegion = True Then
		_CaptureRegion2($x_start, $y_start, $x_start + $width, $y_start + $height)
	Else
		$_hHBitmap = GetHHBitmapArea($g_hHBitmap2, $x_start, $y_start, $x_start + $width, $y_start + $height)
	EndIf
	Local $Result
	If $bImgLoc Then
		If $_hHBitmap <> 0 Then
			$Result = getOcrImgLoc($_hHBitmap, $language)
		Else
			$Result = getOcrImgLoc($g_hHBitmap2, $language)
		EndIf
	Else
		If $_hHBitmap <> 0 Then
			$Result = getOcr($_hHBitmap, $language)
		Else
			$Result = getOcr($g_hHBitmap2, $language)
		EndIf
	EndIf
	If $_hHBitmap <> 0 Then
		GdiDeleteHBitmap($_hHBitmap)
	EndIf
	$_hHBitmap = 0
	If ($removeSpace) Then
		$Result = StringReplace($Result, " ", "")
	Else
		$Result = StringStripWS($Result, BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING, $STR_STRIPSPACES))
	EndIf
	Return $Result
EndFunc   ;==>getOcrAndCapture

Func getOcr(ByRef Const $_hHBitmap, $language)
	Local $Result = DllCallMyBot("ocr", "ptr", $_hHBitmap, "str", $language, "int", $g_bDebugOcr ? 1 : 0)
	If IsArray($Result) Then
		Return $Result[0]
	Else
		Return ""
	EndIf
EndFunc   ;==>getOcr

Func getOcrImgLoc(ByRef Const $_hHBitmap, $sLanguage)
	Local $Result = DllCallMyBot("DoOCR", "handle", $_hHBitmap, "str", $sLanguage)

	Local $error = @error ; Store error values as they reset at next function call
	Local $extError = @extended
	If $error Then
		_logErrorDLLCall($g_hLibMyBot, $error)
		SetDebugLog(" imgloc DLL Error : " & $error & " --- " & $extError)
		Return SetError(2, $extError, "") ; Set external error code = 2 for DLL error
	EndIf
	If $g_bDebugImageSave Then SaveDebugImage($sLanguage, False)

	If IsArray($Result) Then
		Return $Result[0]
	Else
		Return ""
	EndIf
EndFunc   ;==>getOcrImgLoc

Func getMatchRemain($x_start = 397, $y_start = 503) ; Gets complete ranked battle match remain
	Local $aRet[0]
	Local $aLanguages[3] = ["coc-BBAttackAvail", "coc-Builders", "coc-t-b"]
	Local $aOffsets[3] = [0, -2, 2]
	If $g_bDebugOcr Then
		_CaptureRegion2($x_start, $y_start, $x_start + 70, $y_start + 22)
		SaveDebugImage("RankedMatchesOCR", False)
	EndIf
	Local $sRet = StringStripWS(StringReplace(getOcrAndCapture("coc-tournament", $x_start, $y_start, 70, 22, True), "/", "#"), $STR_STRIPALL)
	If StringRegExp($sRet, "^\d+#\d+$") Then
		$aRet = StringSplit($sRet, "#", $STR_NOCOUNT)
		If Number($aRet[1]) > 0 And Number($aRet[0]) <= Number($aRet[1]) Then Return $aRet
	EndIf
	For $i = 0 To UBound($aOffsets) - 1
		For $j = 0 To UBound($aLanguages) - 1
			$sRet = StringStripWS(StringReplace(getOcrAndCapture($aLanguages[$j], $x_start, $y_start + $aOffsets[$i], 70, 24, True), "/", "#"), $STR_STRIPALL)
			If StringRegExp($sRet, "^\d+#\d+$") Then
				$aRet = StringSplit($sRet, "#", $STR_NOCOUNT)
				If Number($aRet[1]) > 0 And Number($aRet[0]) <= Number($aRet[1]) Then Return $aRet
			EndIf
		Next
	Next
	Return $aRet
EndFunc   ;==>getMatchRemain
