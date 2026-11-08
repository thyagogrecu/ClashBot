; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Donate
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: MonkeyHunter (07-2016), CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Global $g_aiDonIcons[$eTroopCount + 1] = [$eIcnDonBarbarian, $eIcnDonArcher, $eIcnDonGiant, $eIcnDonGoblin, $eIcnDonWallBreaker, $eIcnDonBalloon, $eIcnDonWizard, $eIcnDonHealer, $eIcnDonDragon, $eIcnDonPekka, $eIcnDonBabyDragon, $eIcnDonMiner, $eIcnElectroDragon, $eIcnYeti, $eIcnDragonRider, $eIcnElectroTitan, $eIcnRootRider, $eIcnThrower, $eIcnMeteorGolem, $eIcnDonMinion, $eIcnDonHogRider, $eIcnDonValkyrie, $eIcnDonGolem, $eIcnDonWitch, $eIcnDonLavaHound, $eIcnDonBowler, $eIcnIceGolem, $eIcnHeadhunter, $eIcnAppWard, $eIcnDruid, $eIcnFurnace, $eIcnRuinWitch, $eIcnSuperBarbarian, $eIcnSuperArcher, $eIcnSuperGiant, $eIcnSneakyGoblin, $eIcnSuperWallBreaker, $eIcnRocketBalloon, $eIcnSuperWizard, $eIcnSuperDragon, $eIcnInfernoDragon, $eIcnSuperMiner, $eIcnSuperYeti, $eIcnSuperMinion, $eIcnSuperHogRider, $eIcnSuperValkyrie, $eIcnSuperWitch, $eIcnIceHound, $eIcnSuperBowler, $eIcnDonBlank]

Func btnDonateTroop()
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		If @GUI_CtrlId = $g_ahBtnDonateTroop[$i] Then
			If GUICtrlGetState($g_ahGrpDonateTroop[$i]) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
				_DonateBtn($g_ahGrpDonateTroop[$i], $g_ahTxtBlacklistTroop[$i]) ;Hide/Show controls on Donate tab
			EndIf
			ExitLoop
		EndIf
	Next
EndFunc   ;==>btnDonateTroop

Func btnDonateSpell()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahBtnDonateSpell[$i] Then
			If GUICtrlGetState($g_ahGrpDonateSpell[$i]) = BitOR($GUI_HIDE, $GUI_ENABLE) Then
				_DonateBtn($g_ahGrpDonateSpell[$i], $g_ahTxtBlacklistSpell[$i])
			EndIf
			ExitLoop
		EndIf
	Next
EndFunc   ;==>btnDonateSpell

Func cmbDonateCategory()
	Local $iCategory = _GUICtrlComboBox_GetCurSel($g_hCmbDonateCategory)
	Local $iSlot = 0
	If $iCategory < 0 Then $iCategory = 0

	_DonateHideAllCategoryIcons()

	Switch $iCategory
		Case 0 ; Troops
			For $i = 0 To $eTroopMinion - 1
				If Not _DonateIsSuperTroop($i) Then
					_DonateSetTroopCategoryVisible($i, True, $iSlot)
					$iSlot += 1
				EndIf
			Next
			For $i = $eTroopMinion To $eTroopDebtCollector - 1
				If Not _DonateIsSuperTroop($i) Then
					_DonateSetTroopCategoryVisible($i, True, $iSlot)
					$iSlot += 1
				EndIf
			Next
			For $i = 0 To $iSuperTroopsCount - 1
				_DonateSetTroopCategoryVisible($g_asSuperTroopIndex[$i], True, $iSlot)
				$iSlot += 1
			Next

		Case 1 ; Spells
			For $i = 0 To $eSpellCount - 1
				_DonateSetSpellCategoryVisible($i, True, $iSlot)
				$iSlot += 1
			Next

		Case 2 ; Sieges
			For $i = $eTroopCount + $g_iCustomDonateConfigs To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
				_DonateSetTroopCategoryVisible($i, True, $iSlot)
				$iSlot += 1
			Next
	EndSwitch
EndFunc   ;==>cmbDonateCategory

Func _DonateHideAllCategoryIcons()
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		_DonateSetTroopCategoryVisible($i, False)
	Next
	For $i = 0 To $eSpellCount - 1
		_DonateSetSpellCategoryVisible($i, False)
	Next
EndFunc   ;==>_DonateHideAllCategoryIcons

Func _DonateSetTroopCategoryVisible($iIndex, $bVisible, $iSlot = -1)
	If $iIndex < 0 Or $iIndex > UBound($g_ahBtnDonateTroop) - 1 Then Return
	If $bVisible And $iSlot > -1 Then
		If Not $g_abDonateTroopCategoryPosReady[$iIndex] Or $g_aiDonateTroopCategorySlot[$iIndex] <> $iSlot Then
			Local $aPos = _DonateCategorySlotPos($iSlot)
			If $g_ahBtnDonateTroop[$iIndex] <> 0 Then GUICtrlSetPos($g_ahBtnDonateTroop[$iIndex], $aPos[0] + 2, $aPos[1], 31, 31)
			If $g_ahLblDonateTroop[$iIndex] <> 0 Then GUICtrlSetPos($g_ahLblDonateTroop[$iIndex], $aPos[0], $aPos[1] - 2, 35, 35)
			$g_aiDonateTroopCategorySlot[$iIndex] = $iSlot
			$g_abDonateTroopCategoryPosReady[$iIndex] = True
		EndIf
	EndIf
	If $g_abDonateTroopCategoryStateReady[$iIndex] And $g_abDonateTroopCategoryVisible[$iIndex] = $bVisible Then Return
	If $g_ahBtnDonateTroop[$iIndex] <> 0 Then GUICtrlSetState($g_ahBtnDonateTroop[$iIndex], $bVisible ? $GUI_SHOW : $GUI_HIDE)
	If $g_ahLblDonateTroop[$iIndex] <> 0 Then
		GUICtrlSetState($g_ahLblDonateTroop[$iIndex], $bVisible ? $GUI_SHOW : $GUI_HIDE)
		If $bVisible Then GUICtrlSetState($g_ahLblDonateTroop[$iIndex], $GUI_DISABLE)
	EndIf
	$g_abDonateTroopCategoryVisible[$iIndex] = $bVisible
	$g_abDonateTroopCategoryStateReady[$iIndex] = True
EndFunc   ;==>_DonateSetTroopCategoryVisible

Func _DonateSetSpellCategoryVisible($iIndex, $bVisible, $iSlot = -1)
	If $iIndex < 0 Or $iIndex > UBound($g_ahBtnDonateSpell) - 1 Then Return
	If $bVisible And $iSlot > -1 Then
		If Not $g_abDonateSpellCategoryPosReady[$iIndex] Or $g_aiDonateSpellCategorySlot[$iIndex] <> $iSlot Then
			Local $aPos = _DonateCategorySlotPos($iSlot)
			If $g_ahBtnDonateSpell[$iIndex] <> 0 Then GUICtrlSetPos($g_ahBtnDonateSpell[$iIndex], $aPos[0] + 2, $aPos[1], 31, 31)
			If $g_ahLblDonateSpell[$iIndex] <> 0 Then GUICtrlSetPos($g_ahLblDonateSpell[$iIndex], $aPos[0], $aPos[1] - 2, 35, 35)
			$g_aiDonateSpellCategorySlot[$iIndex] = $iSlot
			$g_abDonateSpellCategoryPosReady[$iIndex] = True
		EndIf
	EndIf
	If $g_abDonateSpellCategoryStateReady[$iIndex] And $g_abDonateSpellCategoryVisible[$iIndex] = $bVisible Then Return
	If $g_ahBtnDonateSpell[$iIndex] <> 0 Then GUICtrlSetState($g_ahBtnDonateSpell[$iIndex], $bVisible ? $GUI_SHOW : $GUI_HIDE)
	If $g_ahLblDonateSpell[$iIndex] <> 0 Then
		GUICtrlSetState($g_ahLblDonateSpell[$iIndex], $bVisible ? $GUI_SHOW : $GUI_HIDE)
		If $bVisible Then GUICtrlSetState($g_ahLblDonateSpell[$iIndex], $GUI_DISABLE)
	EndIf
	$g_abDonateSpellCategoryVisible[$iIndex] = $bVisible
	$g_abDonateSpellCategoryStateReady[$iIndex] = True
EndFunc   ;==>_DonateSetSpellCategoryVisible

Func _DonateCategorySlotPos($iSlot)
	Local Const $iStartX = 0, $iStartY = 5, $iOff = 33, $iPerRow = 13
	Local $aPos[2] = [$iStartX + Mod($iSlot, $iPerRow) * $iOff, $iStartY + Int($iSlot / $iPerRow) * $iOff]
	Return $aPos
EndFunc   ;==>_DonateCategorySlotPos

Func _DonateIsSuperTroop($iTroopIndex)
	For $i = 0 To $iSuperTroopsCount - 1
		If $iTroopIndex = $g_asSuperTroopIndex[$i] Then Return True
	Next
	Return False
EndFunc   ;==>_DonateIsSuperTroop

Func BtnAllSelected()
	For $i = 0 To $eTroopCount - 1
		GUICtrlSetState($g_ahChkDonateTroop[$i], $GUI_CHECKED)
		GUICtrlSetState($g_ahChkDonateAllTroop[$i], $GUI_UNCHECKED)
		GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $COLOR_OLIVE)
	Next
	For $i = $eTroopCount + $g_iCustomDonateConfigs To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		GUICtrlSetState($g_ahChkDonateTroop[$i], $GUI_CHECKED)
		GUICtrlSetState($g_ahChkDonateAllTroop[$i], $GUI_UNCHECKED)
		GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $COLOR_OLIVE)
	Next
	For $i = 0 To $eSpellCount - 1
		GUICtrlSetState($g_ahChkDonateSpell[$i], $GUI_CHECKED)
		GUICtrlSetState($g_ahChkDonateAllSpell[$i], $GUI_UNCHECKED)
		GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $COLOR_OLIVE)
	Next
EndFunc   ;==>BtnAllSelected

Func BtnResetSelected()
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		GUICtrlSetState($g_ahChkDonateTroop[$i], $GUI_UNCHECKED)
		GUICtrlSetState($g_ahChkDonateAllTroop[$i], $GUI_UNCHECKED)
		If $g_ahLblDonateTroop[$i] <> 0 Then GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $GUI_BKCOLOR_TRANSPARENT)
	Next
	For $i = 0 To $eSpellCount - 1
		GUICtrlSetState($g_ahChkDonateSpell[$i], $GUI_UNCHECKED)
		GUICtrlSetState($g_ahChkDonateAllSpell[$i], $GUI_UNCHECKED)
		GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
	Next
EndFunc   ;==>BtnResetSelected

Func chkDonateTroop()
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		If @GUI_CtrlId = $g_ahChkDonateTroop[$i] Then
			If GUICtrlRead($g_ahChkDonateTroop[$i]) = $GUI_CHECKED Then
				_DonateControls($i)
			Else
				If $g_ahLblDonateTroop[$i] <> 0 Then GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $GUI_BKCOLOR_TRANSPARENT)
			EndIf
		EndIf
	Next
EndFunc   ;==>chkDonateTroop

Func chkDonateAllTroop()
	For $i = 0 To $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
		If @GUI_CtrlId = $g_ahChkDonateAllTroop[$i] Then
			_DonateAllControls($i, GUICtrlRead($g_ahChkDonateAllTroop[$i]) = $GUI_CHECKED ? True : False)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>chkDonateAllTroop

Func chkDonateSpell()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahChkDonateSpell[$i] Then
			If GUICtrlRead($g_ahChkDonateSpell[$i]) = $GUI_CHECKED Then
				_DonateControlsSpell($i)
			Else
				GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
			EndIf
		EndIf
	Next
EndFunc   ;==>chkDonateSpell

Func chkDonateAllSpell()
	For $i = 0 To $eSpellCount - 1
		If @GUI_CtrlId = $g_ahChkDonateAllSpell[$i] Then
			_DonateAllControlsSpell($i, GUICtrlRead($g_ahChkDonateAllSpell[$i]) = $GUI_CHECKED ? True : False)
			ExitLoop
		EndIf
	Next
EndFunc   ;==>chkDonateAllSpell

Func cmbDonateCustomA()
	Local $combo1 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomA[0])
	Local $combo2 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomA[1])
	Local $combo3 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomA[2])
	_GUICtrlSetImage($g_ahPicDonateCustomA[0], $g_sLibIconPath, $g_aiDonIcons[$combo1])
	_GUICtrlSetImage($g_ahPicDonateCustomA[1], $g_sLibIconPath, $g_aiDonIcons[$combo2])
	_GUICtrlSetImage($g_ahPicDonateCustomA[2], $g_sLibIconPath, $g_aiDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustomA

Func cmbDonateCustomB()
	Local $combo1 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomB[0])
	Local $combo2 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomB[1])
	Local $combo3 = _GUICtrlComboBox_GetCurSel($g_ahCmbDonateCustomB[2])
	_GUICtrlSetImage($g_ahPicDonateCustomB[0], $g_sLibIconPath, $g_aiDonIcons[$combo1])
	_GUICtrlSetImage($g_ahPicDonateCustomB[1], $g_sLibIconPath, $g_aiDonIcons[$combo2])
	_GUICtrlSetImage($g_ahPicDonateCustomB[2], $g_sLibIconPath, $g_aiDonIcons[$combo3])
EndFunc   ;==>cmbDonateCustomB

Func _DonateBtn($hFirstControl, $hLastControl)
	Static $hLastDonateBtn1 = -1, $hLastDonateBtn2 = -1

	; Hide Controls
	If $hLastDonateBtn1 = -1 Then
		For $i = $g_ahGrpDonateTroop[$eTroopBarbarian] To $g_ahTxtBlacklistTroop[$eTroopBarbarian] ; 1st time use: Hide Barbarian controls
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	Else
		For $i = $hLastDonateBtn1 To $hLastDonateBtn2 ; Hide last used controls on Donate Tab
			GUICtrlSetState($i, $GUI_HIDE)
		Next
	EndIf

	$hLastDonateBtn1 = $hFirstControl
	$hLastDonateBtn2 = $hLastControl

	;Show Controls
	For $i = $hFirstControl To $hLastControl ; Show these controls on Donate Tab
		GUICtrlSetState($i, $GUI_SHOW)
	Next
EndFunc   ;==>_DonateBtn

Func _DonateControls($iTroopIndex)
	Local $iFirstTroop = 0, $iLastTroop = $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
	If $iTroopIndex <= $eTroopCount - 1 + $g_iCustomDonateConfigs Then
		$iLastTroop = $eTroopCount - 1 + $g_iCustomDonateConfigs
	Else
		$iFirstTroop = $eTroopCount + $g_iCustomDonateConfigs
	EndIf

	For $i = $iFirstTroop To $iLastTroop
		If $i = $iTroopIndex Then
			If $g_ahLblDonateTroop[$i] <> 0 Then GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $COLOR_OLIVE)
		Else
			If $g_ahLblDonateTroop[$i] <> 0 And GUICtrlGetBkColor($g_ahLblDonateTroop[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $GUI_BKCOLOR_TRANSPARENT)
		EndIf

		If GUICtrlRead($g_ahChkDonateAllTroop[$i]) = $GUI_CHECKED Then GUICtrlSetState($g_ahChkDonateAllTroop[$i], $GUI_UNCHECKED)

		If BitAND(GUICtrlGetState($g_ahTxtDonateTroop[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtDonateTroop[$i], $GUI_ENABLE)
		If BitAND(GUICtrlGetState($g_ahTxtBlacklistTroop[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtBlacklistTroop[$i], $GUI_ENABLE)
	Next
EndFunc   ;==>_DonateControls

Func _DonateAllControls($iTroopIndex, $Set)
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "_DonateAllControls")

	Local $iFirstTroop = 0, $iLastTroop = $eTroopCount - 1 + $g_iCustomDonateConfigs + $eSiegeMachineCount
	If $iTroopIndex <= $eTroopCount - 1 + $g_iCustomDonateConfigs Then
		$iLastTroop = $eTroopCount - 1 + $g_iCustomDonateConfigs
	Else
		$iFirstTroop = $eTroopCount + $g_iCustomDonateConfigs
	EndIf

	If $Set = True Then
		For $i = $iFirstTroop To $iLastTroop
			If $g_ahLblDonateTroop[$i] <> 0 Then GUICtrlSetBkColor($g_ahLblDonateTroop[$i], $i = $iTroopIndex ? $COLOR_NAVY : $GUI_BKCOLOR_TRANSPARENT)

			If $i <> $iTroopIndex Then
				GUICtrlSetState($g_ahChkDonateAllTroop[$i], $GUI_UNCHECKED)
			EndIf

			GUICtrlSetState($g_ahChkDonateTroop[$i], $GUI_UNCHECKED)
			If BitAND(GUICtrlGetState($g_ahTxtDonateTroop[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_ahTxtDonateTroop[$i], $GUI_DISABLE)
			If BitAND(GUICtrlGetState($g_ahTxtBlacklistTroop[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_ahTxtBlacklistTroop[$i], $GUI_DISABLE)
		Next

	Else
		If $g_ahLblDonateTroop[$iTroopIndex] <> 0 Then GUICtrlSetBkColor($g_ahLblDonateTroop[$iTroopIndex], $GUI_BKCOLOR_TRANSPARENT)

		For $i = $iFirstTroop To $iLastTroop
			If BitAND(GUICtrlGetState($g_ahTxtDonateTroop[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtDonateTroop[$i], $GUI_ENABLE)
			If BitAND(GUICtrlGetState($g_ahTxtBlacklistTroop[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtBlacklistTroop[$i], $GUI_ENABLE)
		Next

	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGUI_DONATE_TAB, "_DonateAllControls") ; cannot use tab item here
EndFunc   ;==>_DonateAllControls

Func _DonateControlsSpell($iSpellIndex)
	For $i = 0 To $eSpellCount - 1
		If $i = $iSpellIndex Then
			GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $COLOR_OLIVE)
		Else
			If GUICtrlGetBkColor($g_ahLblDonateSpell[$i]) = $COLOR_NAVY Then GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
		EndIf

		If GUICtrlRead($g_ahChkDonateAllSpell[$i]) = $GUI_CHECKED Then GUICtrlSetState($g_ahChkDonateAllSpell[$i], $GUI_UNCHECKED)

		If BitAND(GUICtrlGetState($g_ahTxtDonateSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtDonateSpell[$i], $GUI_ENABLE)
		If BitAND(GUICtrlGetState($g_ahTxtBlacklistSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtBlacklistSpell[$i], $GUI_ENABLE)
	Next
EndFunc   ;==>_DonateControlsSpell

Func _DonateAllControlsSpell($iSpellIndex, $Set)
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "_DonateAllControlsSpell")

	If $Set = True Then
		For $i = 0 To $eSpellCount - 1
			If $i = $iSpellIndex Then
				GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $COLOR_NAVY)
			Else
				GUICtrlSetBkColor($g_ahLblDonateSpell[$i], $GUI_BKCOLOR_TRANSPARENT)
			EndIf

			If $i <> $iSpellIndex Then GUICtrlSetState($g_ahChkDonateAllSpell[$i], $GUI_UNCHECKED)

			GUICtrlSetState($g_ahChkDonateSpell[$i], $GUI_UNCHECKED)
			If BitAND(GUICtrlGetState($g_ahTxtDonateSpell[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_ahTxtDonateSpell[$i], $GUI_DISABLE)
			If BitAND(GUICtrlGetState($g_ahTxtBlacklistSpell[$i]), $GUI_ENABLE) = $GUI_ENABLE Then GUICtrlSetState($g_ahTxtBlacklistSpell[$i], $GUI_DISABLE)
		Next

	Else
		GUICtrlSetBkColor($g_ahLblDonateSpell[$iSpellIndex], $GUI_BKCOLOR_TRANSPARENT)

		For $i = 0 To $eSpellCount - 1
			If BitAND(GUICtrlGetState($g_ahTxtDonateSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtDonateSpell[$i], $GUI_ENABLE)
			If BitAND(GUICtrlGetState($g_ahTxtBlacklistSpell[$i]), $GUI_DISABLE) = $GUI_DISABLE Then GUICtrlSetState($g_ahTxtBlacklistSpell[$i], $GUI_ENABLE)
		Next

	EndIf

	SetRedrawBotWindowControls($bWasRedraw, $g_hGUI_DONATE_TAB, "_DonateAllControlsSpell") ; cannot use tab item here
EndFunc   ;==>_DonateAllControlsSpell

Func btnFilterDonationsCC()
	SetLog("open folder " & $g_sProfileDonateCapturePath, $COLOR_AQUA)
	ShellExecute("explorer", $g_sProfileDonateCapturePath)
EndFunc   ;==>btnFilterDonationsCC

Func chkBalanceDR()
	If GUICtrlRead($g_hChkUseCCBalanced) = $GUI_CHECKED Then
		GUICtrlSetState($g_hCmbCCDonated, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbCCReceived, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbCCDonated, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbCCReceived, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkBalanceDR

Func cmbBalanceDR()
	If _GUICtrlComboBox_GetCurSel($g_hCmbCCDonated) = _GUICtrlComboBox_GetCurSel($g_hCmbCCReceived) Then
		_GUICtrlComboBox_SetCurSel($g_hCmbCCDonated, 0)
		_GUICtrlComboBox_SetCurSel($g_hCmbCCReceived, 0)
	EndIf
EndFunc   ;==>cmbBalanceDR

Func Doncheck()
	tabDONATE() ; just call tabDONATE()
EndFunc   ;==>Doncheck

Func ChkDeleteOldFiles()
	If GUICtrlRead($g_hChkDeleteOldFiles) = $GUI_CHECKED Then
		GUICtrlSetState($g_hTxtDeleteOldFilesDays, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hTxtDeleteOldFilesDays, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ChkDeleteOldFiles
