; #FUNCTION# ====================================================================================================================
; Name ..........: SmartZap
; Description ...: This file Includes all functions to current GUI
; Syntax ........: SmartZap()
; Parameters ....: None
; Return values .: None
; Author ........: LunaEclipse(03-2016)
; Modified ......: TheRevenor(11-2016), ProMac(12-2016), TheRevenor(12-2016), TripleM(01-2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Global $g_sSmartZapLastMatchedImages = ""

Func SmartZapDrillLevelIndex($iDrillLevel)
	Local $iIndex = Number($iDrillLevel) - 1
	Local $iMaxIndex = _Min(UBound($g_aDrillLevelTotal), UBound($g_aDrillLevelHP)) - 1
	If $iIndex < 0 Then $iIndex = 0
	If $iIndex > $iMaxIndex Then
		$iIndex = $iMaxIndex
	EndIf
	Return $iIndex
EndFunc   ;==>SmartZapDrillLevelIndex

Func SmartZapLightningCount(Const ByRef $aSpells)
	Return Number($aSpells[0][4]) + Number($aSpells[1][4])
EndFunc   ;==>SmartZapLightningCount

Func SmartZapEarthquakeCount(Const ByRef $aSpells)
	Return Number($aSpells[2][4])
EndFunc   ;==>SmartZapEarthquakeCount

Func SmartZapLightningGain($iDrillLevel, $iLightningLevel)
	Local $iDrillLevelIndex = SmartZapDrillLevelIndex($iDrillLevel)
	Local $iSpellLevelIndex = _Max(Number($iLightningLevel) - 1, 0)
	$iSpellLevelIndex = _Min($iSpellLevelIndex, UBound($g_aLSpellDmg) - 1)
	Return Ceiling(Number($g_aDrillLevelTotal[$iDrillLevelIndex] / $g_aDrillLevelHP[$iDrillLevelIndex] * $g_fDarkStealFactor * $g_aLSpellDmg[$iSpellLevelIndex] * $g_fDarkFillLevel))
EndFunc   ;==>SmartZapLightningGain

Func SmartZapTargetName($iTarget = Default)
	If $iTarget = Default Then $iTarget = $g_iSmartZapTarget
	Switch $iTarget
		Case $eSmartZapTargetAirDefense
			Return "Air Defense"
		Case $eSmartZapTargetAirSweeper
			Return "Air Sweeper"
		Case $eSmartZapTargetEagle
			Return "Eagle"
		Case $eSmartZapTargetFirespitter
			Return "Firespitter"
		Case $eSmartZapTargetInferno
			Return "Infernos"
		Case $eSmartZapTargetMonolith
			Return "Monolith"
		Case $eSmartZapTargetMortar
			Return "Mortars"
		Case $eSmartZapTargetRevengeTower
			Return "Revenge Tower"
		Case $eSmartZapTargetScatterShot
			Return "Scattershot"
		Case $eSmartZapTargetWizardTower
			Return "Wizard Towers"
		Case $eSmartZapTargetXBow
			Return "XBow"
		Case Else
			Return "Drills"
	EndSwitch
EndFunc   ;==>SmartZapTargetName

Func SmartZapTargetImageDir($iTarget = Default)
	If $iTarget = Default Then $iTarget = $g_iSmartZapTarget
	Switch $iTarget
		Case $eSmartZapTargetAirDefense
			Return $g_sImgWeakBaseBuildingsAirDefenseDir
		Case $eSmartZapTargetAirSweeper
			Return @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\AirSweeper"
		Case $eSmartZapTargetEagle
			Return $g_sImgWeakBaseBuildingsEagleDir
		Case $eSmartZapTargetFirespitter
			Return $g_sImgWeakBaseBuildingsFirespitterDir
		Case $eSmartZapTargetInferno
			Return $g_sImgWeakBaseBuildingsInfernoDir
		Case $eSmartZapTargetMonolith
			Return $g_sImgWeakBaseBuildingsMonolithDir
		Case $eSmartZapTargetMortar
			Return $g_sImgWeakBaseBuildingsMortarsDir
		Case $eSmartZapTargetRevengeTower
			Return $g_sImgWeakBaseBuildingsRevengeTowerDir
		Case $eSmartZapTargetScatterShot
			Return $g_sImgWeakBaseBuildingsScatterDir
		Case $eSmartZapTargetWizardTower
			Return ($g_iDetectedImageType = 1 ? $g_sImgWeakBaseBuildingsWizTowerSnowDir : $g_sImgWeakBaseBuildingsWizTowerDir)
		Case $eSmartZapTargetXBow
			Return $g_sImgWeakBaseBuildingsXbowDir
		Case Else
			Return $g_sImgSearchDrill
	EndSwitch
EndFunc   ;==>SmartZapTargetImageDir

Func SmartZapDeadEagleImageDir()
	Return @ScriptDir & "\ImgXML\Buildings\Home Village\Defenses\DeadEagle"
EndFunc   ;==>SmartZapDeadEagleImageDir

Func SmartZapTargetOffset($iTarget = Default)
	If $iTarget = Default Then $iTarget = $g_iSmartZapTarget
	Local $aOffset[2] = [0, 0]
	If $iTarget = $eSmartZapTargetDrill Then $aOffset[1] = 14
	Return $aOffset
EndFunc   ;==>SmartZapTargetOffset

Func SmartZapTargetList()
	Local $aTargets[1] = [$g_iSmartZapTarget]
	If $g_iSmartZapSecondaryTarget >= $eSmartZapTargetDrill And $g_iSmartZapSecondaryTarget <= $eSmartZapTargetXBow And $g_iSmartZapSecondaryTarget <> $g_iSmartZapTarget Then
		_ArrayAdd($aTargets, $g_iSmartZapSecondaryTarget)
	EndIf
	Return $aTargets
EndFunc   ;==>SmartZapTargetList

Func SmartZap()
	Local $performedZap = False
	Local $aSpells[3][5] = [["Own", $eLSpell, -1, -1, 0] _         ; Own/Donated, SpellType, AttackbarPosition, Level, Count
			, ["Donated", $eLSpell, -1, -1, 0] _
			, ["Donated", $eESpell, -1, -1, 0]]
	Local Const $iDoubleZapDelay = 64
	Local Const $iFastZapDelay = 256
	Local Const $iVerifyDelay = 192

	If $g_bSmartZapEnable = False Then Return $performedZap
	If $g_iSmartZapTarget = $eSmartZapTargetDrill Then
		If $g_iTownHallLevel < 2 Then
			SetLog("Town Hall level is unknown; locate it manually in Village > Misc", $COLOR_ERROR)
			Return $performedZap
		ElseIf $g_iTownHallLevel < 7 Then
			SetLog("Town Hall level is too low to store Dark Elixir", $COLOR_ERROR)
			Return $performedZap
		EndIf
	EndIf

	For $i = 0 To UBound($g_avAttackTroops) - 1
		If $g_avAttackTroops[$i][0] = $eLSpell Then
			If $aSpells[0][4] = 0 Then
				$aSpells[0][2] = $i
				$aSpells[0][3] = Number($g_iLSpellLevel)
				$aSpells[0][4] = $g_avAttackTroops[$i][1]
			Else
				$aSpells[1][2] = $i
				$aSpells[1][3] = Number($g_iLSpellLevel)
				$aSpells[1][4] = $g_avAttackTroops[$i][1]
			EndIf
		EndIf
		If $g_avAttackTroops[$i][0] = $eESpell Then
			$aSpells[2][2] = $i
			$aSpells[2][3] = Number($g_iESpellLevel)
			$aSpells[2][4] = $g_avAttackTroops[$i][1]
		EndIf
	Next
	If Not $g_bSmartZapUseLightning Then
		$aSpells[0][4] = 0
		$aSpells[1][4] = 0
	EndIf
	If Not $g_bEarthQuakeZap Then $aSpells[2][4] = 0

	If SmartZapLightningCount($aSpells) = 0 And SmartZapEarthquakeCount($aSpells) = 0 Then
		SetLog("No SmartZap Spells Available", $COLOR_ERROR)
		Return $performedZap
	EndIf

	Local $aTargetList = SmartZapTargetList()
	For $iTargetFallback = 0 To UBound($aTargetList) - 1
		If Not IsAttackPage() Or (SmartZapLightningCount($aSpells) = 0 And SmartZapEarthquakeCount($aSpells) = 0) Then ExitLoop

		Local $iTargetType = $aTargetList[$iTargetFallback]
		Local $strikeOffsets = SmartZapTargetOffset($iTargetType)
		Local $aTargets = SmartZapTargetSearch($iTargetType)
		If UBound($aTargets) = 0 Then
			SetLog(SmartZapTargetName($iTargetType) & " not detected", $COLOR_DEBUG)
			ContinueLoop
		EndIf

		_ArraySort($aTargets, 1, 0, 0, 3)
		SetLog(SmartZapTargetName($iTargetType) & " Detected: " & UBound($aTargets), $COLOR_INFO)
		If $g_bDebugBuildingPos And $g_sSmartZapLastMatchedImages <> "" Then SmartZapLogMatchedImages()

		If SmartZapEarthquakeCount($aSpells) > 0 Then
			For $i = 0 To UBound($aTargets) - 1
				For $iZap = 1 To $g_iSmartZapEarthquakesPerTarget
					If SmartZapEarthquakeCount($aSpells) = 0 Then ExitLoop 2
					If zapBuilding($aSpells, Number($aTargets[$i][0]) + $strikeOffsets[0], Number($aTargets[$i][1]) + $strikeOffsets[1], $eESpell) = -1 Then ExitLoop 2
					$performedZap = True
					$g_iNumEQSpellsUsed += 1
					If _Sleep($iFastZapDelay) Then Return
				Next
			Next
		EndIf

		Local $iTargetIndex = 0
		While IsAttackPage() And SmartZapLightningCount($aSpells) > 0 And $iTargetIndex < UBound($aTargets)
			CheckHeroesHealth()
			Local $iTargetX = Number($aTargets[$iTargetIndex][0])
			Local $iTargetY = Number($aTargets[$iTargetIndex][1])
			Local $iTargetLevel = Number($aTargets[$iTargetIndex][2])

			For $iZap = 1 To $g_iSmartZapSpellsPerTarget
				If SmartZapLightningCount($aSpells) = 0 Then ExitLoop
				If SmartZapDropLightning($aSpells, $iTargetX + $strikeOffsets[0], $iTargetY + $strikeOffsets[1], $iTargetLevel, $iTargetType) = -1 Then ExitLoop
				$performedZap = True
				If $iZap < $g_iSmartZapSpellsPerTarget And SmartZapLightningCount($aSpells) > 0 Then
					If _Sleep($iDoubleZapDelay) Then Return
				EndIf
			Next

			If _Sleep($iVerifyDelay) Then Return
			If Not SmartZapTargetExists($iTargetX, $iTargetY, $iTargetType) Then
				_ArrayDelete($aTargets, $iTargetIndex)
			Else
				$iTargetIndex += 1
			EndIf
		WEnd

		$iTargetIndex = 0
		While IsAttackPage() And SmartZapLightningCount($aSpells) > 0 And UBound($aTargets) > 0
			If $iTargetIndex >= UBound($aTargets) Then $iTargetIndex = 0
			Local $iTargetX = Number($aTargets[$iTargetIndex][0])
			Local $iTargetY = Number($aTargets[$iTargetIndex][1])
			Local $iTargetLevel = Number($aTargets[$iTargetIndex][2])

			If Not SmartZapTargetExists($iTargetX, $iTargetY, $iTargetType) Then
				_ArrayDelete($aTargets, $iTargetIndex)
				ContinueLoop
			EndIf
			If SmartZapDropLightning($aSpells, $iTargetX + $strikeOffsets[0], $iTargetY + $strikeOffsets[1], $iTargetLevel, $iTargetType) = -1 Then ExitLoop
			$performedZap = True
			If _Sleep($iFastZapDelay) Then Return
			If _Sleep($iVerifyDelay) Then Return
			If Not SmartZapTargetExists($iTargetX, $iTargetY, $iTargetType) Then
				_ArrayDelete($aTargets, $iTargetIndex)
			Else
				$iTargetIndex += 1
			EndIf
		WEnd
	Next

	Return $performedZap
EndFunc   ;==>SmartZap

Func SmartZapDropLightning(ByRef $aSpells, $x, $y, $iTargetLevel, $iTargetType)
	Local $iResult = zapBuilding($aSpells, $x, $y, $eLSpell)
	If $iResult = -1 Then Return -1
	$g_iNumLSpellsUsed += 1
	If $iTargetType = $eSmartZapTargetDrill Then $g_iSmartZapGain += SmartZapLightningGain($iTargetLevel, $g_iLSpellLevel)
	Return $iResult
EndFunc   ;==>SmartZapDropLightning

; This function taken and modified by the CastSpell function to make Zapping works
Func zapBuilding(ByRef $Spells, $x, $y, $iPreferredSpell = -1)
	Local Const $iEarthquakeSelectDelay = 256
	Local $iSpell = -1
	For $i = 0 To UBound($Spells) - 1
		If $Spells[$i][4] > 0 And ($iPreferredSpell = -1 Or $Spells[$i][1] = $iPreferredSpell) Then
			$iSpell = $i
		EndIf
	Next
	If $iSpell = -1 Then Return -1
	If $Spells[$iSpell][2] > -1 Then
		SetLog("Dropping " & String(GetTroopName($Spells[$iSpell][1])))
		Local $iSlot = $Spells[$iSpell][2]
		Local $iSelectSlot = $iSlot
		If $iSlot >= 0 And $iSlot < 11 Then
			If $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, True)
		ElseIf $iSlot > 10 Then
			If Not $g_bDraggedAttackBar Then DragAttackBar($g_iTotalAttackSlot, False)
			$iSelectSlot = $iSlot - ($g_iTotalAttackSlot - 10)
		EndIf
		SelectDropTroop($iSelectSlot)
		If _Sleep(($Spells[$iSpell][1] = $eESpell) ? $iEarthquakeSelectDelay : $DELAYCASTSPELL1) Then Return
		If IsAttackPage() Then Click($x, $y, 1, 100, "#0029")
		$Spells[$iSpell][4] -= 1
		If $iSlot >= 0 And $iSlot < UBound($g_avAttackTroops, 1) And $g_avAttackTroops[$iSlot][1] > 0 Then $g_avAttackTroops[$iSlot][1] -= 1
	Else
		SetLog("No " & String(GetTroopName($Spells[$iSpell][1])) & " found", $COLOR_ERROR)
		$Spells[$iSpell][4] = 0
		Return -1
	EndIf
	Return $Spells[$iSpell][1]
EndFunc   ;==>zapBuilding

Func ReCheckDrillExist($x, $y)
	_CaptureRegion2($x - 25, $y - 25, $x + 25, $y + 25)

	Local $aResult = multiMatches($g_sImgSearchDrill, 1, "FV", "FV", "", 0, 1000, False)
	Return UBound($aResult) > 1
EndFunc   ;==>ReCheckDrillExist

Func SmartZapTargetExists($x, $y, $iTarget = Default)
	If $iTarget = Default Then $iTarget = $g_iSmartZapTarget
	If $iTarget = $eSmartZapTargetDrill Then Return ReCheckDrillExist($x, $y)

	_CaptureRegion2($x - 30, $y - 30, $x + 30, $y + 30)
	Local $aResult = multiMatches(SmartZapTargetImageDir($iTarget), 1, "FV", "FV", "", 0, 1000, False)
	If UBound($aResult) > 1 Then Return True
	If $iTarget = $eSmartZapTargetEagle Then $aResult = multiMatches(SmartZapDeadEagleImageDir(), 1, "FV", "FV", "", 0, 1000, False)
	Return UBound($aResult) > 1
EndFunc   ;==>SmartZapTargetExists

Func SmartZapTargetSearch($iTarget = Default)
	If $iTarget = Default Then $iTarget = $g_iSmartZapTarget
	$g_sSmartZapLastMatchedImages = ""
	If $iTarget = $eSmartZapTargetDrill Then Return drillSearch()
	If $iTarget = $eSmartZapTargetEagle Then Return SmartZapEagleSearch()
	Return SmartZapBuildingSearch(SmartZapTargetImageDir($iTarget), SmartZapTargetName($iTarget))
EndFunc   ;==>SmartZapTargetSearch

Func SmartZapEagleSearch()
	Local $aTargets = SmartZapBuildingSearch($g_sImgWeakBaseBuildingsEagleDir, SmartZapTargetName($eSmartZapTargetEagle))
	Local $aDeadTargets = SmartZapBuildingSearch(SmartZapDeadEagleImageDir(), SmartZapTargetName($eSmartZapTargetEagle))
	If UBound($aDeadTargets) > 0 Then _ArrayAdd($aTargets, $aDeadTargets, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	Return SmartZapRemoveDuplicateTargets($aTargets, 22, SmartZapTargetName($eSmartZapTargetEagle))
EndFunc   ;==>SmartZapEagleSearch

Func SmartZapBuildingSearch($sImageDir, $sTargetName)
	Local $aReturnResult[0][5]
	Local $pixelerror = 18
	Local $aResult = multiMatches($sImageDir, 0, $CocDiamondECD, $CocDiamondECD)
	If UBound($aResult) > 1 Then SmartZapAppendMatchedImages(SmartZapImageFiles($sImageDir))

	For $iResult = 1 To UBound($aResult) - 1
		If _Sleep(10) Then Return
		Local $aTemp[0][2]
		_ArrayAdd($aTemp, $aResult[$iResult][5], 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
		_ArrayColInsert($aTemp, 2)
		_ArrayColInsert($aTemp, 3)
		_ArrayColInsert($aTemp, 4)
		For $iRow = 0 To UBound($aTemp) - 1
			$aTemp[$iRow][2] = $aResult[$iResult][2]
			$aTemp[$iRow][3] = $aResult[$iResult][2]
			$aTemp[$iRow][4] = 0
		Next
		_ArrayAdd($aReturnResult, $aTemp, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	Next

	Return SmartZapRemoveDuplicateTargets($aReturnResult, $pixelerror, $sTargetName)
EndFunc   ;==>SmartZapBuildingSearch

Func SmartZapLogMatchedImages()
	Local $aImages = StringSplit($g_sSmartZapLastMatchedImages, ",", $STR_NOCOUNT)
	For $i = 0 To UBound($aImages) - 1
		Local $sImage = StringStripWS($aImages[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		If $sImage = "" Then ContinueLoop
		SetLog($sImage, $COLOR_INFO)
	Next
EndFunc   ;==>SmartZapLogMatchedImages

Func SmartZapImageFiles($sImageDir)
	Local $sImages = ""
	Local $aExtensions[3] = ["bmp", "png", "xml"]

	For $iExtension = 0 To UBound($aExtensions) - 1
		Local $hSearch = FileFindFirstFile($sImageDir & "\*." & $aExtensions[$iExtension])
		If $hSearch = -1 Then ContinueLoop

		While 1
			Local $sImage = FileFindNextFile($hSearch)
			If @error Then ExitLoop
			If $sImages <> "" Then $sImages &= ", "
			$sImages &= $sImage
		WEnd

		FileClose($hSearch)
	Next

	Return $sImages
EndFunc   ;==>SmartZapImageFiles

Func SmartZapAppendMatchedImages($sImages)
	If $sImages = "" Then Return
	Local $aImages = StringSplit($sImages, ",", $STR_NOCOUNT)
	For $i = 0 To UBound($aImages) - 1
		Local $sImage = StringStripWS($aImages[$i], $STR_STRIPLEADING + $STR_STRIPTRAILING)
		If $sImage = "" Then ContinueLoop
		If StringInStr("|" & $g_sSmartZapLastMatchedImages & "|", "|" & $sImage & "|") Then ContinueLoop
		If $g_sSmartZapLastMatchedImages <> "" Then $g_sSmartZapLastMatchedImages &= ", "
		$g_sSmartZapLastMatchedImages &= $sImage
	Next
EndFunc   ;==>SmartZapAppendMatchedImages

Func SmartZapMatchedImages(ByRef $aResult)
	Local $sImages = ""
	For $i = 1 To UBound($aResult) - 1
		If $aResult[$i][0] = "" Then ContinueLoop
		If StringInStr("|" & $sImages & "|", "|" & $aResult[$i][0] & "|") Then ContinueLoop
		If $sImages <> "" Then $sImages &= ", "
		$sImages &= $aResult[$i][0]
	Next
	Return $sImages
EndFunc   ;==>SmartZapMatchedImages

Func SmartZapRemoveDuplicateTargets(ByRef $aReturnResult, $pixelerror, $sTargetName)
	Local $iResult = 0
	While $iResult < UBound($aReturnResult)
		If _Sleep(10) Then Return
		Local $jResult = $iResult + 1
		While $jResult < UBound($aReturnResult)
			If Abs($aReturnResult[$iResult][0] - $aReturnResult[$jResult][0]) <= $pixelerror And Abs($aReturnResult[$iResult][1] - $aReturnResult[$jResult][1]) <= $pixelerror Then
				$aReturnResult[$iResult][2] = _Max(Number($aReturnResult[$iResult][2]), Number($aReturnResult[$jResult][2]))
				$aReturnResult[$iResult][3] = $aReturnResult[$iResult][2]
				If $g_bDebugSmartZap Then SetLog("Found Duplicate " & $sTargetName & ": [" & $aReturnResult[$jResult][0] & "," & $aReturnResult[$jResult][1] & "], Level: " & $aReturnResult[$jResult][2], $COLOR_DEBUG)
				_ArrayDelete($aReturnResult, $jResult)
			Else
				$jResult += 1
			EndIf
		WEnd
		If $g_bDebugSmartZap Then SetLog(($iResult + 1) & ". Valid " & $sTargetName & ": [" & $aReturnResult[$iResult][0] & "," & $aReturnResult[$iResult][1] & "], Level: " & $aReturnResult[$iResult][2], $COLOR_DEBUG)
		$iResult += 1
	WEnd

	Return $aReturnResult
EndFunc   ;==>SmartZapRemoveDuplicateTargets

Func drillSearch()
	Local $aReturnResult[0][5]
	Local $pixelerror = 15

	Local $Maxpositions = 0
	Local $aResult = multiMatches($g_sImgSearchDrill, $Maxpositions, $CocDiamondECD, $CocDiamondECD)
	If UBound($aResult) > 1 Then SmartZapAppendMatchedImages(SmartZapImageFiles($g_sImgSearchDrill))

	For $iResult = 1 To UBound($aResult) - 1
		If _Sleep(10) Then Return
		Local $aTemp[0][2]
		_ArrayAdd($aTemp, $aResult[$iResult][5], 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
		_ArrayColInsert($aTemp, 2)
		_ArrayColInsert($aTemp, 3)
		_ArrayColInsert($aTemp, 4)
		For $iRow = 0 To UBound($aTemp) - 1
			$aTemp[$iRow][2] = $aResult[$iResult][2]
			$aTemp[$iRow][4] = 0
		Next
		_ArrayAdd($aReturnResult, $aTemp, 0, "|", @CRLF, $ARRAYFILL_FORCE_STRING)
	Next

	Local $iResult = 0
	While $iResult < UBound($aReturnResult)
		If _Sleep(10) Then Return
		Local $jResult = $iResult + 1
		While $jResult < UBound($aReturnResult)
			If Abs($aReturnResult[$iResult][0] - $aReturnResult[$jResult][0]) <= $pixelerror And Abs($aReturnResult[$iResult][1] - $aReturnResult[$jResult][1]) <= $pixelerror Then
				$aReturnResult[$iResult][2] = _Min(Number($aReturnResult[$iResult][2]), Number($aReturnResult[$jResult][2]))
				If $g_bDebugSmartZap Then SetLog("Found Duplicate Dark Elixir Drill: [" & $aReturnResult[$jResult][0] & "," & $aReturnResult[$jResult][1] & "], Level: " & $aReturnResult[$jResult][2], $COLOR_DEBUG)
				_ArrayDelete($aReturnResult, $jResult)
			Else
				$jResult += 1
			EndIf
		WEnd

		Local $iDrillLevel = CheckDrillLvl($aReturnResult[$iResult][0], $aReturnResult[$iResult][1])
		If $iDrillLevel > 0 And $aReturnResult[$iResult][2] <> $iDrillLevel Then
			If $g_bDebugSmartZap Then SetLog("Correcting Drill Level, old = " & $aReturnResult[$iResult][2] & ", new = " & $iDrillLevel, $COLOR_DEBUG)
			$aReturnResult[$iResult][2] = $iDrillLevel
		EndIf

		$aReturnResult[$iResult][3] = Ceiling(Number($g_aDrillLevelTotal[SmartZapDrillLevelIndex($aReturnResult[$iResult][2])] * $g_fDarkStealFactor))
		If $g_bDebugSmartZap Then SetLog(($iResult + 1) & ". Valid Drill: [" & $aReturnResult[$iResult][0] & "," & $aReturnResult[$iResult][1] & "], Level: " & $aReturnResult[$iResult][2] & ", Hold: " & $aReturnResult[$iResult][3], $COLOR_DEBUG)
		$iResult += 1
	WEnd

	Return $aReturnResult
EndFunc   ;==>drillSearch

Func CheckDrillLvl($x, $y)
	_CaptureRegion2($x - 25, $y - 25, $x + 25, $y + 25)

	Local $aResult = multiMatches($g_sImgSearchDrillLevel, 1, "FV", "FV", "", 0, 1000, False)

	If $g_bDebugSmartZap Then SetLog("CheckDrillLvl: UBound($aresult) = " & UBound($aResult), $COLOR_DEBUG)
	If UBound($aResult) > 1 Then
		If $g_bDebugSmartZap Then SetLog("CheckDrillLvl: $aresult[" & (UBound($aResult) - 1) & "][2] = " & $aResult[UBound($aResult) - 1][2], $COLOR_DEBUG)
		Return $aResult[UBound($aResult) - 1][2]
	EndIf
	Return 0
EndFunc   ;==>CheckDrillLvl
