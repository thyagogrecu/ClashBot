; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: GkevinOD (2014)
; Modified ......: Hervidero (2015), kaganus (August 2015), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func btnResetStats()
	ResetStats()
EndFunc   ;==>btnResetStats

Func btnDonTroopPage()
	$g_iStatsDonateTroopPage = ($g_iStatsDonateTroopPage = 0) ? 1 : 0
	UpdateDonTroopPage()
EndFunc   ;==>btnDonTroopPage

Func UpdateDonTroopPage()
	Local $iSlots = UBound($g_ahPicDonTroopSlot)
	If $g_iStatsDonateTroopPage > 1 Then $g_iStatsDonateTroopPage = 0
	Local $bTroopsPage = ($g_iStatsDonateTroopPage = 0)

	If $g_iStatsDonateLastPage <> $g_iStatsDonateTroopPage Then
		If $g_hLblDonTroopsHeader <> 0 Then GUICtrlSetState($g_hLblDonTroopsHeader, $bTroopsPage ? $GUI_SHOW : $GUI_HIDE)
		If $g_hLblDonSuperTroopsHeader <> 0 Then GUICtrlSetState($g_hLblDonSuperTroopsHeader, $bTroopsPage ? $GUI_SHOW : $GUI_HIDE)
		StatsDonateSetCtrlRangeState($g_hDonTroopsPageFirst, $g_hDonTroopsPageLast, $bTroopsPage ? $GUI_SHOW : $GUI_HIDE)
		StatsDonateSetCtrlRangeState($g_hDonSiegesSpellsPageFirst, $g_hDonSiegesSpellsPageLast, $bTroopsPage ? $GUI_HIDE : $GUI_SHOW)
		StatsDonateSetSlotVisibleCache($bTroopsPage)
		$g_iStatsDonateLastPage = $g_iStatsDonateTroopPage
	EndIf

	If Not $bTroopsPage Then
		StatsDonateUpdatePageButton()
		Return
	EndIf

	Local $aiTroops = StatsDonateGetTroopDisplayOrder()
	Local $iTroopCount = UBound($aiTroops)
	Local $iNormalSlot = 0, $iSuperSlot = 0
	For $iSlot = 0 To $iSlots - 1
		If $iSlot < $iTroopCount Then
			Local $iTroop = $aiTroops[$iSlot]
			Local $bSuperTroop = StatsDonateIsSuperTroop($iTroop)
			If $bSuperTroop Then
				StatsDonateUpdateTroopSlotPos($iSlot, $iSuperSlot, True)
				$iSuperSlot += 1
			Else
				StatsDonateUpdateTroopSlotPos($iSlot, $iNormalSlot, False)
				$iNormalSlot += 1
			EndIf
			If Not $g_abDonTroopSlotReady[$iSlot] Or $g_aiDonTroopSlotIndex[$iSlot] <> $iTroop Then
				_GUICtrlSetImage($g_ahPicDonTroopSlot[$iSlot], $g_sLibIconPath, $g_aTroopsIcon[$iTroop])
				$g_aiDonTroopSlotIndex[$iSlot] = $iTroop
				$g_abDonTroopSlotReady[$iSlot] = True
			EndIf
			GUICtrlSetData($g_ahLblDonTroopSlot[$iSlot], _NumberFormat($g_aiDonateStatsTroops[$iTroop][0], True))
			StatsDonateSetTroopSlotState($iSlot, True)
		Else
			StatsDonateSetTroopSlotState($iSlot, False)
		EndIf
	Next

	StatsDonateUpdatePageButton()
EndFunc   ;==>UpdateDonTroopPage

Func StatsDonateUpdatePageButton()
	If $g_hBtnDonTroopPage = 0 Then Return
	GUICtrlSetData($g_hBtnDonTroopPage, ($g_iStatsDonateTroopPage = 0) ? ">" : "<")
	_GUICtrlSetTip($g_hBtnDonTroopPage, ($g_iStatsDonateTroopPage = 0) ? "Sieges and Spells" : "Troops")
	GUICtrlSetState($g_hBtnDonTroopPage, $GUI_SHOW)
EndFunc   ;==>StatsDonateUpdatePageButton

Func StatsDonateUpdateTroopSlotPos($iSlot, $iDisplaySlot, $bSuperTroop)
	If $g_abDonTroopSlotPosReady[$iSlot] And $g_aiDonTroopSlotDisplay[$iSlot] = $iDisplaySlot And $g_abDonTroopSlotSuper[$iSlot] = $bSuperTroop Then Return
	StatsDonateSetTroopSlotPos($iSlot, $iDisplaySlot, $bSuperTroop)
	$g_aiDonTroopSlotDisplay[$iSlot] = $iDisplaySlot
	$g_abDonTroopSlotSuper[$iSlot] = $bSuperTroop
	$g_abDonTroopSlotPosReady[$iSlot] = True
EndFunc   ;==>StatsDonateUpdateTroopSlotPos

Func StatsDonateSetTroopSlotState($iSlot, $bShow)
	If $g_abDonTroopSlotVisible[$iSlot] = $bShow Then Return
	Local $iState = $bShow ? $GUI_SHOW : $GUI_HIDE
	GUICtrlSetState($g_ahPicDonTroopSlot[$iSlot], $iState)
	GUICtrlSetState($g_ahLblDonTroopSepSlot[$iSlot], $iState)
	GUICtrlSetState($g_ahLblDonTroopSlot[$iSlot], $iState)
	$g_abDonTroopSlotVisible[$iSlot] = $bShow
EndFunc   ;==>StatsDonateSetTroopSlotState

Func StatsDonateSetSlotVisibleCache($bVisible)
	For $iSlot = 0 To UBound($g_abDonTroopSlotVisible) - 1
		$g_abDonTroopSlotVisible[$iSlot] = $bVisible
	Next
EndFunc   ;==>StatsDonateSetSlotVisibleCache

Func StatsDonateSetTroopSlotPos($iSlot, $iDisplaySlot, $bSuperTroop)
	Local Const $iStartX = 12, $iTroopStartY = 48, $iSuperStartY = 180, $iSplitX = 54, $iSplitY = 28, $iPerRow = 8
	Local $iYStart = $iTroopStartY
	If $bSuperTroop Then $iYStart = $iSuperStartY
	Local $x = $iStartX + Mod($iDisplaySlot, $iPerRow) * $iSplitX
	Local $y = $iYStart + Int($iDisplaySlot / $iPerRow) * $iSplitY

	GUICtrlSetPos($g_ahPicDonTroopSlot[$iSlot], $x, $y, 24, 24)
	GUICtrlSetPos($g_ahLblDonTroopSepSlot[$iSlot], $x + 28, $y + 4)
	GUICtrlSetPos($g_ahLblDonTroopSlot[$iSlot], $x + 15, $y + 6, 35, 17)
EndFunc   ;==>StatsDonateSetTroopSlotPos

Func StatsDonateGetTroopDisplayOrder()
	Local $aiOrder[0]

	For $i = $eTroopBarbarian To $eTroopMeteorGolem
		If Not StatsDonateIsSuperTroop($i) Then StatsDonateAddTroop($aiOrder, $i)
	Next

	For $i = $eTroopMinion To $eTroopRuinWitch
		If Not StatsDonateIsSuperTroop($i) Then StatsDonateAddTroop($aiOrder, $i)
	Next

	For $i = 0 To $iSuperTroopsCount - 1
		StatsDonateAddTroop($aiOrder, $g_asSuperTroopIndex[$i])
	Next

	Return $aiOrder
EndFunc   ;==>StatsDonateGetTroopDisplayOrder

Func StatsDonateAddTroop(ByRef $aiOrder, $iTroop)
	Local $iSize = UBound($aiOrder)
	ReDim $aiOrder[$iSize + 1]
	$aiOrder[$iSize] = $iTroop
EndFunc   ;==>StatsDonateAddTroop

Func StatsDonateIsSuperTroop($iTroopIndex)
	For $i = 0 To $iSuperTroopsCount - 1
		If $iTroopIndex = $g_asSuperTroopIndex[$i] Then Return True
	Next
	Return False
EndFunc   ;==>StatsDonateIsSuperTroop

Func StatsDonateSetCtrlRangeState($hFirst, $hLast, $iState)
	If $hFirst = 0 Or $hLast = 0 Then Return
	For $hCtrl = $hFirst To $hLast
		GUICtrlSetState($hCtrl, $iState)
	Next
EndFunc   ;==>StatsDonateSetCtrlRangeState

Func UpdateMultiStats($bForceUpdate = False)
	If Not $g_bMultiStatsCreated Then Return
	If $g_bRunState And Not $bForceUpdate Then Return

	Local $bEnableSwitchAcc = ($g_iCmbSwitchAcc > 0 And ($g_bChkSwitchAcc Or GUICtrlRead($g_hChkSwitchAcc) = $GUI_CHECKED))
	Local $iCmbTotalAcc = _GUICtrlComboBox_GetCurSel($g_hCmbTotalAccount) + 1 ; combobox data starts with 2
	If $g_iTotalAcc > $iCmbTotalAcc Then $iCmbTotalAcc = $g_iTotalAcc

	Local $iActiveTotal = 0
	For $i = 0 To UBound($g_ahGrpVillageAcc) - 1
		If ($iCmbTotalAcc >= 0 And $i <= $iCmbTotalAcc) And MultiStatsAccountActive($i) Then $iActiveTotal += 1
	Next

	If $iActiveTotal <= $g_iSwitchAccAccountsPerPage Then $g_iMultiStatsPage = 0

	Local $iPageStart = $g_iMultiStatsPage * $g_iSwitchAccAccountsPerPage
	Local $iPageEnd = $iPageStart + $g_iSwitchAccAccountsPerPage - 1
	If $iPageStart >= $iActiveTotal Then
		$g_iMultiStatsPage = 0
		$iPageStart = 0
		$iPageEnd = $g_iSwitchAccAccountsPerPage - 1
	EndIf

	Local $iActiveIndex = 0
	For $i = 0 To UBound($g_ahGrpVillageAcc) - 1
		Local $bConfigured = ($iCmbTotalAcc >= 0 And $i <= $iCmbTotalAcc)
		Local $bActive = MultiStatsAccountActive($i)
		Local $bOnPage = False, $iSlot = 0
		If $bConfigured And $bActive Then
			$bOnPage = ($iActiveIndex >= $iPageStart And $iActiveIndex <= $iPageEnd)
			If $bOnPage Then $iSlot = $iActiveIndex - $iPageStart
			$iActiveIndex += 1
		EndIf

		If $bEnableSwitchAcc And $bConfigured And $bOnPage And $bActive Then
			MultiStatsSetAccountSlot($i, $iSlot)
			_GUI_Value_STATE("SHOW", $g_ahGrpDefaultAcc[$i])
			_GUI_Value_STATE("SHOW", $g_ahGrpReportAcc[$i])
			_SetMultiVillagePage($i)

			GUICtrlSetData($g_ahGrpVillageAcc[$i], MultiStatsAccountProfile($i) & " (Active)")
		Else
			_GUI_Value_STATE("HIDE", $g_ahGrpDefaultAcc[$i] & "#" & $g_ahGrpReportAcc[$i] & "#" & $g_ahGrpStatsAcc[$i] & "#" & $g_ahGrpStats2Acc[$i] & "#" & $g_ahGrpHelpersAcc[$i])
		EndIf
	Next

	MultiStatsUpdatePageButton($bEnableSwitchAcc, $iActiveTotal)
EndFunc   ;==>UpdateMultiStats

Func MultiStatsAccountActive($i)
	If $i < 0 Or $i >= UBound($g_abAccountNo) Then Return False
	Return ($g_abAccountNo[$i] Or GUICtrlRead($g_ahChkAccount[$i]) = $GUI_CHECKED)
EndFunc   ;==>MultiStatsAccountActive

Func MultiStatsAccountProfile($i)
	If $i >= 0 And $i < UBound($g_asProfileName) And $g_asProfileName[$i] <> "" Then Return $g_asProfileName[$i]
	Return GUICtrlRead($g_ahCmbProfile[$i])
EndFunc   ;==>MultiStatsAccountProfile

Func btnMultiStatsPage()
	If Not $g_bMultiStatsCreated Then Return

	$g_iMultiStatsPage = ($g_iMultiStatsPage = 0) ? 1 : 0
	UpdateMultiStats(True)
EndFunc   ;==>btnMultiStatsPage

Func MultiStatsUpdatePageButton($bEnableSwitchAcc, $iActiveTotal)
	If $g_hBtnMultiStatsPage = 0 Then Return
	If Not $bEnableSwitchAcc Or $iActiveTotal <= $g_iSwitchAccAccountsPerPage Then
		GUICtrlSetState($g_hBtnMultiStatsPage, $GUI_HIDE)
		Return
	EndIf
	GUICtrlSetData($g_hBtnMultiStatsPage, ($g_iMultiStatsPage = 0) ? ">" : "<")
	_GUICtrlSetTip($g_hBtnMultiStatsPage, ($g_iMultiStatsPage = 0) ? "Next page" : "Previous page")
	GUICtrlSetState($g_hBtnMultiStatsPage, $GUI_SHOW)
EndFunc   ;==>MultiStatsUpdatePageButton

Func MultiStatsSetAccountSlot($i, $iSlot)
	Local $x = 25, $y = 27
	Local $i_X = Mod($iSlot, 2), $i_Y = Int($iSlot / 2)
	Local $delY = 20, $delY2 = 95, $delX = 90, $delX2 = 215

	GUICtrlSetPos($g_ahGrpVillageAcc[$i], $x - 3 + $i_X * $delX2, $y + $i_Y * $delY2, 160, 85)

	GUICtrlSetPos($g_ahLblResultGoldNowAcc[$i], $x + 6 + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicResultGoldNowAcc[$i], $x + 66 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahPic2ResultGoldNowAcc[$i], $x + 66 + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahLblResultTrophyNowAcc[$i], $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicResultTrophyNowAcc[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

	GUICtrlSetPos($g_ahLblResultElixirNowAcc[$i], $x + 6 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicResultElixirNowAcc[$i], $x + 66 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahPic2ResultElixirNowAcc[$i], $x + 66 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahLblResultBuilderNowAcc[$i], $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicResultBuilderNowAcc[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 16, 14)

	GUICtrlSetPos($g_ahLblResultDENowAcc[$i], $x + 6 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicResultDENowAcc[$i], $x + 66 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahPic2ResultDENowAcc[$i], $x + 66 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahLblResultGemNowAcc[$i], $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicResultGemNowAcc[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 16, 14)

	GUICtrlSetPos($g_ahLblLabTime[$i], $x + 6 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicLabTime[$i], $x + 66 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahLbLPetTime[$i], $x + 6 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicPetTime[$i], $x + 66 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 16, 16)

	GUICtrlSetPos($g_ahPicArrowLeft[$i], $x - 20 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahPicArrowRight[$i], $x + 160 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)

	GUICtrlSetPos($g_ahLblHourlyStatsGoldAcc[$i], $x + 6 + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahLblResultRuntimeNowAcc[$i], $x - 4 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 45, 15)
	GUICtrlSetPos($g_ahPicResultRuntimeNowAcc[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2, 16, 16)

	GUICtrlSetPos($g_ahLblHourlyStatsElixirAcc[$i], $x + 6 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahLblResultAttacked[$i], $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicResultAttacked[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 14)

	GUICtrlSetPos($g_ahLblHourlyStatsDarkAcc[$i], $x + 6 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahLblResultSkipped[$i], $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicResultSkipped[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 16, 14)

	GUICtrlSetPos($g_ahLblTroopTime[$i], $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicTroopTime[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)
	GUICtrlSetPos($g_ahLblTroopTimeRep[$i], $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicTroopTimeRep[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)

	GUICtrlSetPos($g_ahLbLLootBB[$i][$eLootGoldBB], $x + 6 + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicResultLootBBGold[$i], $x + 66 + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 15, 15)
	GUICtrlSetPos($g_ahLbLLootBB[$i][$eLootElixirBB], $x + 6 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicResultLootBBElix[$i], $x + 66 + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 1, 15, 15)
	GUICtrlSetPos($g_ahLbLLootBB[$i][$eLootTrophyBB], $x + 6 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicResultLootBBTr[$i], $x + 66 + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 1, 15, 15)

	GUICtrlSetPos($g_ahLbLLootCCGold[$i], $x + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicResultCCGold[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY + $i_Y * $delY2 - 1, 16, 16)
	GUICtrlSetPos($g_ahLbLLootCCMedal[$i], $x + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2 + 2, 41, 15)
	GUICtrlSetPos($g_ahPicResultCCMedal[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 2 + $i_Y * $delY2, 16, 16)
	GUICtrlSetPos($g_ahLbLStarLabTime[$i], $x + 6 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 56, 15)
	GUICtrlSetPos($g_ahPicStarLabTime[$i], $x + 66 + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2, 15, 16)
	GUICtrlSetPos($g_ahLblTrophiesCC[$i], $x + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2 + 2, 41, 15)
	GUICtrlSetPos($g_ahPicTrophiesCC[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 3 + $i_Y * $delY2, 17, 17)
	GUICtrlSetPos($g_ahLblResultBBuilderNowAcc[$i], $x + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 41, 15)
	GUICtrlSetPos($g_ahPicResultBBuilderNowAcc[$i], $x + 45 + $delX + $i_X * $delX2, $y + $delY * 4 + $i_Y * $delY2 + 1, 15, 14)
	Local $aCells = [[$g_ahLblLabTime[$i], $g_ahPicLabTime[$i], 0, 0], [$g_ahLbLPetTime[$i], $g_ahPicPetTime[$i], 0, 1], [$g_ahLbLStarLabTime[$i], $g_ahPicStarLabTime[$i], 0, 2], [$g_ahMultiBuilderTimer[$i], $g_ahMultiBuilderIcon[$i], 1, 0], [$g_ahMultiLabTimer[$i], $g_ahMultiLabIcon[$i], 1, 1], [$g_ahLbLLootBB[$i][$eLootGoldBB], $g_ahPicResultLootBBGold[$i], 0, 0], [$g_ahLbLLootBB[$i][$eLootElixirBB], $g_ahPicResultLootBBElix[$i], 0, 1], [$g_ahLbLLootCCGold[$i], $g_ahPicResultCCGold[$i], 0, 2], [$g_ahLbLLootBB[$i][$eLootTrophyBB], $g_ahPicResultLootBBTr[$i], 1, 0], [$g_ahLblResultBBuilderNowAcc[$i], $g_ahPicResultBBuilderNowAcc[$i], 1, 1], [$g_ahLbLLootCCMedal[$i], $g_ahPicResultCCMedal[$i], 1, 2]]
	For $j = 0 To UBound($aCells) - 1
		Local $iCellX = $x + $i_X * $delX2 + ($aCells[$j][2] = 0 ? 6 : 90)
		Local $iCellY = $y + $delY * ($aCells[$j][3] + 1) + $i_Y * $delY2
		GUICtrlSetPos($aCells[$j][0], $iCellX - (($aCells[$j][0] = $g_ahMultiBuilderTimer[$i] Or $aCells[$j][0] = $g_ahMultiLabTimer[$i]) ? 4 : 0), $iCellY + 1, $aCells[$j][2] = 0 ? 56 : (($aCells[$j][0] = $g_ahMultiBuilderTimer[$i] Or $aCells[$j][0] = $g_ahMultiLabTimer[$i]) ? 45 : 41), 15)
		GUICtrlSetPos($aCells[$j][1], $iCellX + ($aCells[$j][2] = 0 ? 60 : 45), $iCellY, 16, 16)
	Next
EndFunc   ;==>MultiStatsSetAccountSlot

Func SwitchVillageInfo()
	For $i = 0 To UBound($g_ahPicArrowLeft) - 1
		If @GUI_CtrlId = $g_ahPicArrowLeft[$i] Then Return _SwitchVillageInfo($i)
	Next
EndFunc   ;==>SwitchVillageInfo

Func SwitchVillageInfo2()
	For $i = 0 To UBound($g_ahPicArrowRight) - 1
		If @GUI_CtrlId = $g_ahPicArrowRight[$i] Then Return _SwitchVillageInfo2($i)
	Next
EndFunc   ;==>SwitchVillageInfo2

Func _SwitchVillageInfo($i)
	$g_aiMultiVillagePage[$i] = Mod($g_aiMultiVillagePage[$i] + 3, 4)
	_SetMultiVillagePage($i)
EndFunc

Func _SwitchVillageInfo2($i)
	$g_aiMultiVillagePage[$i] = Mod($g_aiMultiVillagePage[$i] + 1, 4)
	_SetMultiVillagePage($i)
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: _SetMultiVillagePage
; Description ...: Selects one of four information pages for an account.
; ======================================================================================================================
Func _SetMultiVillagePage($i)
	Local $aPages = [$g_ahGrpReportAcc[$i], $g_ahGrpStatsAcc[$i], $g_ahGrpStats2Acc[$i], $g_ahGrpHelpersAcc[$i]]
	For $j = 0 To 3
		_GUI_Value_STATE($j = $g_aiMultiVillagePage[$i] ? "SHOW" : "HIDE", $aPages[$j])
	Next
EndFunc