; #FUNCTION# ====================================================================================================================
; Name ..........: Upgrade Heroes Continuously
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: z0mbie (2015)
; Modified ......: Master1st (09/2015), ProMac (10/2015), MonkeyHunter (06/2016), Moebius14 (12/2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

; Hero Hall Slot X Positions: King=65, Queen=218, Prince=371, Warden=523, Champion=676, Duke=718 (after 153px left swipe)
Local $bXcoords[6] = [65, 218, 371, 523, 676, 718]

Func _UHR_IsHeroHallPanelOpen()
	Local $aClose = _PixelSearch(790, 135 + $g_iMidOffsetY, 830, 185 + $g_iMidOffsetY, Hex(0xE85762, 6), 35)
	If Not IsArray($aClose) Then $aClose = _PixelSearch(790, 135 + $g_iMidOffsetY, 830, 185 + $g_iMidOffsetY, Hex(0xF05A64, 6), 45)
	If Not IsArray($aClose) Then $aClose = _PixelSearch(790, 135 + $g_iMidOffsetY, 830, 185 + $g_iMidOffsetY, Hex(0xF38E8D, 6), 45)
	If Not IsArray($aClose) Then $aClose = _PixelSearch(790, 135 + $g_iMidOffsetY, 830, 185 + $g_iMidOffsetY, Hex(0xF02227, 6), 35)
	Return IsArray($aClose)
EndFunc   ;==>_UHR_IsHeroHallPanelOpen

Func _UHR_GetUpgradeState($iHeroIndex, $iButtonX)
	If _IsHeroUpgrading($iButtonX, 429) Then Return "Running"
	If IsHeroMaxLevelOnCard($iButtonX) Then Return "Max Level"
	Local $aHeroLevel[6] = [$g_iKingLevel, $g_iQueenLevel, $g_iPrinceLevel, $g_iWardenLevel, $g_iChampionLevel, $g_iDukeLevel]
	If IsHeroAtHeroHallLevelLimit($iHeroIndex, $aHeroLevel[$iHeroIndex]) Then Return "Max Level"
	If IsHeroUpgradeInsufficientResources($iButtonX) Then Return "Insufficient Resources"
	If IsHeroUpgradeButtonGreen($iButtonX) Then Return "Available"
	If IsHeroUpgradeButtonGrey($iButtonX) Then Return "Unavailable"
	Return "Unknown"
EndFunc   ;==>_UHR_GetUpgradeState

Func _UHR_LogUpgradeState($sHeroName, $sState)
	Local $iColor = $COLOR_DEBUG
	Switch $sState
		Case "Available", "Max Level"
			$iColor = $COLOR_SUCCESS
		Case "Running"
			$iColor = $COLOR_INFO
		Case "Unavailable"
			$iColor = $COLOR_WARNING
		Case "Insufficient Resources"
			$iColor = $COLOR_DEBUG
	EndSwitch
	SetLog("[" & $sHeroName & " Upgrade]: " & $sState, $iColor)
EndFunc   ;==>_UHR_LogUpgradeState

Func SetHeroUpgradeRunning($iHeroIndex, $iHeroBit)
	$g_iHeroUpgrading[$iHeroIndex] = 1
	$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $iHeroBit)
	SetHeroGuiRunning($iHeroIndex)
EndFunc   ;==>SetHeroUpgradeRunning

Func ClearHeroUpgradeRunning($iHeroIndex, $iHeroBit)
	$g_iHeroUpgrading[$iHeroIndex] = 0
	$g_iHeroUpgradingBit = BitAND($g_iHeroUpgradingBit, BitNOT($iHeroBit))
	$g_aiHeroUpgradeFinishDate[$iHeroIndex] = ""
EndFunc   ;==>ClearHeroUpgradeRunning

Func HeroCostFormat($iCost)
	Return StringReplace(_NumberFormat($iCost), " ", ",")
EndFunc   ;==>HeroCostFormat

Func IsHeroMaxLevelOnCard($iButtonX)
	Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $iButtonX - 5, 415 + $g_iMidOffsetY, $iButtonX + 120, 465 + $g_iMidOffsetY, True))
	Return IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2
EndFunc   ;==>IsHeroMaxLevelOnCard

Func IsHeroUpgradeButtonGrey($iButtonX)
	Local $iTop = 438 + $g_iMidOffsetY
	Local $iBottom = 446 + $g_iMidOffsetY
	If IsArray(_PixelSearch($iButtonX, $iTop, $iButtonX + 105, $iBottom, Hex(0xADADAD, 6), 20, True)) Then Return True
	If IsArray(_PixelSearch($iButtonX, $iTop, $iButtonX + 105, $iBottom, Hex(0x6D6D6D, 6), 20, True)) Then Return True
	If IsArray(_PixelSearch($iButtonX, $iTop, $iButtonX + 105, $iBottom, Hex(0xD2D2D2, 6), 20, True)) Then Return True
	If IsArray(_PixelSearch($iButtonX, $iTop, $iButtonX + 105, $iBottom, Hex(0x929292, 6), 20, True)) Then Return True
	Return False
EndFunc   ;==>IsHeroUpgradeButtonGrey

Func IsHeroUpgradeButtonGreen($iButtonX)
	Local $iTop = 438 + $g_iMidOffsetY
	Local $iBottom = 446 + $g_iMidOffsetY
	Local $bHasGreen = IsArray(_PixelSearch($iButtonX, $iTop, $iButtonX + 105, $iBottom, Hex(0x8BD43A, 6), 25, True)) Or _
			IsArray(_PixelSearch($iButtonX, $iTop, $iButtonX + 105, $iBottom, Hex(0x70C931, 6), 25, True)) Or _
			IsArray(_PixelSearch($iButtonX, $iTop, $iButtonX + 105, $iBottom, Hex(0xBFEA8E, 6), 25, True))
	If Not $bHasGreen Then Return False
	Return IsArray(_PixelSearch($iButtonX, $iTop, $iButtonX + 105, $iBottom, Hex(0xFFFFFF, 6), 25, True))
EndFunc   ;==>IsHeroUpgradeButtonGreen

Func IsHeroUpgradeInsufficientResources($iButtonX)
	Local $aRedCost = _PixelSearch($iButtonX + 8, 440 + $g_iMidOffsetY, $iButtonX + 90, 450 + $g_iMidOffsetY, Hex(0xFF887F, 6), 18, True)
	Return IsArray($aRedCost)
EndFunc   ;==>IsHeroUpgradeInsufficientResources

Func HandleHeroUpgradeInsufficientResources($iHeroIndex, $iButtonX, $sHeroName)
	If Not IsHeroUpgradeInsufficientResources($iButtonX) Then Return False
	SetLog(($iHeroIndex = 3 ? "Elixir" : "Dark Elixir") & " Insufficient", $COLOR_DEBUG)
	If $g_aiHeroNeededResource[$iHeroIndex] = 0 Then NeededResources($sHeroName)
	Return True
EndFunc   ;==>HandleHeroUpgradeInsufficientResources

Func IsHeroUpgradeWindowOpen()
	Return _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20)
EndFunc   ;==>IsHeroUpgradeWindowOpen

Func WaitForHeroUpgradeWindow($iTimeout = 3000)
	Local $hTimer = TimerInit()
	Do
		If IsHeroUpgradeWindowOpen() Then Return True
		If _Sleep(200) Then Return False
	Until TimerDiff($hTimer) >= $iTimeout
	Return False
EndFunc   ;==>WaitForHeroUpgradeWindow

Func IsHeroUpgradeResourceDisabled()
	If IsArray(_PixelSearch(570, 530 + $g_iMidOffsetY, 690, 580 + $g_iMidOffsetY, Hex(0xFF887F, 6), 25, True)) Then Return True
	Return IsArray(_PixelSearch(570, 530 + $g_iMidOffsetY, 690, 580 + $g_iMidOffsetY, Hex(0xFF7A0D, 6), 25, True))
EndFunc   ;==>IsHeroUpgradeResourceDisabled

Func FindHeroUpgradeConfirmButton(ByRef $aWhiteZeros, ByRef $aColorSearch, $iTimeout = 3000)
	$aWhiteZeros = 0
	$aColorSearch = 0
	Local $hTimer = TimerInit()
	Do
		If Not IsHeroUpgradeWindowOpen() Then ExitLoop

		$aWhiteZeros = decodeSingleCoord(FindImageInPlace2("UpgradeWhiteZero", $g_sImgUpgradeWhiteZero, 540, 525 + $g_iMidOffsetY, 700, 585 + $g_iMidOffsetY, True))
		If IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2 Then Return True

		$aColorSearch = _PixelSearch(560, 525 + $g_iMidOffsetY, 700, 585 + $g_iMidOffsetY, Hex(0xFFF10D, 6), 25, True)
		If Not IsArray($aColorSearch) Then $aColorSearch = _PixelSearch(560, 525 + $g_iMidOffsetY, 700, 585 + $g_iMidOffsetY, Hex(0x8BD43A, 6), 30, True)
		If Not IsArray($aColorSearch) Then $aColorSearch = _PixelSearch(560, 525 + $g_iMidOffsetY, 700, 585 + $g_iMidOffsetY, Hex(0x70C931, 6), 30, True)
		If Not IsArray($aColorSearch) Then $aColorSearch = _PixelSearch(560, 525 + $g_iMidOffsetY, 700, 585 + $g_iMidOffsetY, Hex(0xBFEA8E, 6), 30, True)
		If IsArray($aColorSearch) Then Return True

		If _Sleep(250) Then Return False
	Until TimerDiff($hTimer) >= $iTimeout
	Return False
EndFunc   ;==>FindHeroUpgradeConfirmButton

Func WaitForHeroUpgradeStarted($iButtonX, $iTimeout = 4000)
	Local $hTimer = TimerInit()
	Do
		If Not IsHeroUpgradeWindowOpen() And _IsHeroUpgrading($iButtonX, 429) Then Return True
		If _Sleep(250) Then Return False
	Until TimerDiff($hTimer) >= $iTimeout
	Return False
EndFunc   ;==>WaitForHeroUpgradeStarted

Func SaveHeroUpgradeFailureImage($sHeroName, $sFailure)
	SaveDebugImage("Upgrade" & $sHeroName & $sFailure)
EndFunc   ;==>SaveHeroUpgradeFailureImage

Func SetHeroGuiRunning($iHeroIndex)
	Switch $iHeroIndex
		Case 0
			GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
			GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
		Case 1
			GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
			GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
		Case 2
			GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
			GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
		Case 3
			GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
			GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
		Case 4
			GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
			GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		Case 5
			GUICtrlSetState($g_hPicDukeGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicDukeRed, $GUI_SHOW)
			GUICtrlSetState($g_hPicDukeBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicDukeGreen, $GUI_HIDE)
	EndSwitch
EndFunc   ;==>SetHeroGuiRunning

Func SetHeroGuiReady($iHeroIndex)
	Switch $iHeroIndex
		Case 0
			GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicKingGreen, $GUI_SHOW)
			_GUI_Value_STATE("HIDE", $groupKingSleeping)
		Case 1
			GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicQueenGreen, $GUI_SHOW)
			_GUI_Value_STATE("HIDE", $groupQueenSleeping)
		Case 2
			GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicPrinceGreen, $GUI_SHOW)
			_GUI_Value_STATE("HIDE", $groupPrinceSleeping)
		Case 3
			GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicWardenGreen, $GUI_SHOW)
			_GUI_Value_STATE("HIDE", $groupWardenSleeping)
		Case 4
			GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicChampionGreen, $GUI_SHOW)
			_GUI_Value_STATE("HIDE", $groupChampionSleeping)
		Case 5
			GUICtrlSetState($g_hPicDukeGray, $GUI_HIDE)
			GUICtrlSetState($g_hPicDukeRed, $GUI_HIDE)
			GUICtrlSetState($g_hPicDukeBlue, $GUI_HIDE)
			GUICtrlSetState($g_hPicDukeGreen, $GUI_SHOW)
			_GUI_Value_STATE("HIDE", $groupDukeSleeping)
	EndSwitch
EndFunc   ;==>SetHeroGuiReady

; #FUNCTION# ===========================================================================================================
; Name ..........: MarkHeroUpgradeAtMaxLevel
; Description ...: Records the maximum hero level without changing the user upgrade selection.
; ======================================================================================================================
Func MarkHeroUpgradeAtMaxLevel($iHeroIndex, $bSetLog = True)
	$g_abUpgradeHeroMaxLevel[$iHeroIndex] = True
	Switch $iHeroIndex
		Case 0
			If $bSetLog Then SetLog("Barbarian King Level Maxed", $COLOR_SUCCESS)
			ClearHeroUpgradeRunning(0, $eHeroKing)
			SetHeroGuiReady(0)
		Case 1
			If $bSetLog Then SetLog("Archer Queen Level Maxed", $COLOR_SUCCESS)
			ClearHeroUpgradeRunning(1, $eHeroQueen)
			SetHeroGuiReady(1)
		Case 2
			If $bSetLog Then SetLog("Minion Prince Level Maxed", $COLOR_SUCCESS)
			ClearHeroUpgradeRunning(2, $eHeroPrince)
			SetHeroGuiReady(2)
		Case 3
			If $bSetLog Then SetLog("Grand Warden Level Maxed", $COLOR_SUCCESS)
			ClearHeroUpgradeRunning(3, $eHeroWarden)
			SetHeroGuiReady(3)
		Case 4
			If $bSetLog Then SetLog("Royal Champion Level Maxed", $COLOR_SUCCESS)
			ClearHeroUpgradeRunning(4, $eHeroChampion)
			SetHeroGuiReady(4)
		Case 5
			If $bSetLog Then SetLog("Duke Level Maxed", $COLOR_SUCCESS)
			ClearHeroUpgradeRunning(5, $eHeroDuke)
			SetHeroGuiReady(5)
	EndSwitch
	ReducecmbHeroReservedBuilder()
EndFunc   ;==>MarkHeroUpgradeAtMaxLevel

Func HandleHeroUpgradeAtHeroHallLimit($iHeroIndex)
	SetLog($g_asHeroNames[$iHeroIndex] & " Upgrade: Hero Hall Level Limit", $COLOR_SUCCESS)
	MarkHeroUpgradeAtMaxLevel($iHeroIndex, False)
EndFunc   ;==>HandleHeroUpgradeAtHeroHallLimit

Func IsHeroAtHeroHallLevelLimit($iHeroIndex, $iHeroLevel)
	Local $iHeroHallLevel = Number($g_aiHeroHallPos[2])
	If $iHeroHallLevel < 1 Or $iHeroHallLevel > UBound($g_aaiHeroHallLevelCaps, $UBOUND_ROWS) Then Return False
	If $iHeroIndex < 0 Or $iHeroIndex >= UBound($g_aaiHeroHallLevelCaps, $UBOUND_COLUMNS) Then Return False
	Local $iLevelCap = $g_aaiHeroHallLevelCaps[$iHeroHallLevel - 1][$iHeroIndex]
	Return $iLevelCap >= 0 And $iHeroLevel >= $iLevelCap
EndFunc   ;==>IsHeroAtHeroHallLevelLimit

Func HandleHeroCostOcrFailure($iHeroIndex, $iButtonX, $sHeroName)
	SetLog(($iHeroIndex = 3 ? "Elixir" : "Dark Elixir") & " Insufficient", $COLOR_DEBUG)
	Return True
EndFunc   ;==>HandleHeroCostOcrFailure

Func ReadHeroNeededResource($iHeroIndex, $iButtonX, $bWarden = False)
	Local $sCost = ""
	Click($iButtonX + 55, 433 + $g_iMidOffsetY)
	If _Sleep($DELAYUPGRADEHERO3) Then Return False

	If Not _ColorCheck(_GetPixelColor(800, 88 + $g_iMidOffsetY, True), Hex(0xF38E8D, 6), 20) Then
		$g_aiHeroNeededResource[$iHeroIndex] = 0
		Return SetError(1, 0, False)
	EndIf

	$sCost = getCostsUpgradeRed(552, 541 + $g_iMidOffsetY)
	If $sCost = "" Then $sCost = getCostsUpgradeRed(552, 532 + $g_iMidOffsetY)
	If $sCost = "" Then $sCost = getOcrAndCapture("coc-HeroCost", 572, 568 + $g_iMidOffsetY, 95, 22, True)
	CloseWindow2(1)
	If _Sleep($DELAYUPGRADEHERO3) Then Return False

	If $sCost = "" Then
		$g_aiHeroNeededResource[$iHeroIndex] = 0
		Return SetError(2, 0, False)
	EndIf
	$g_aiHeroNeededResource[$iHeroIndex] = Number($sCost)
	Return True
EndFunc   ;==>ReadHeroNeededResource

Func NeededResources($bHero = "")
	Switch $bHero
		Case "King"
			If Not ReadHeroNeededResource(0, $bXcoords[0]) Then
				If @error = 1 Then
					SetLog("Hero Hall Upgrade Needed", $COLOR_DEBUG)
				Else
					SetLog(($bHero = "Warden" ? "Elixir" : "Dark Elixir") & " Insufficient", $COLOR_DEBUG)
				EndIf
				Return
			EndIf
			SetLog("Cost: " & HeroCostFormat($g_aiHeroNeededResource[0]) & " Dark Elixir")
			If _Sleep(500) Then Return
		Case "Queen"
			If Not ReadHeroNeededResource(1, $bXcoords[1]) Then
				If @error = 1 Then
					SetLog("Hero Hall Upgrade Needed", $COLOR_DEBUG)
				Else
					SetLog(($bHero = "Warden" ? "Elixir" : "Dark Elixir") & " Insufficient", $COLOR_DEBUG)
				EndIf
				Return
			EndIf
			SetLog("Cost: " & HeroCostFormat($g_aiHeroNeededResource[1]) & " Dark Elixir")
			If _Sleep(500) Then Return
		Case "Prince"
			If Not ReadHeroNeededResource(2, $bXcoords[2]) Then
				If @error = 1 Then
					SetLog("Hero Hall Upgrade Needed", $COLOR_DEBUG)
				Else
					SetLog(($bHero = "Warden" ? "Elixir" : "Dark Elixir") & " Insufficient", $COLOR_DEBUG)
				EndIf
				Return
			EndIf
			SetLog("Cost: " & HeroCostFormat($g_aiHeroNeededResource[2]) & " Dark Elixir")
			If _Sleep(500) Then Return
		Case "Warden"
			If Not ReadHeroNeededResource(3, $bXcoords[3], True) Then
				If @error = 1 Then
					SetLog("Hero Hall Upgrade Needed", $COLOR_DEBUG)
				Else
					SetLog(($bHero = "Warden" ? "Elixir" : "Dark Elixir") & " Insufficient", $COLOR_DEBUG)
				EndIf
				Return
			EndIf
			SetLog("Cost: " & HeroCostFormat($g_aiHeroNeededResource[3]) & " Elixir")
			If _Sleep(500) Then Return
		Case "Champion"
			If Not ReadHeroNeededResource(4, $bXcoords[4]) Then
				If @error = 1 Then
					SetLog("Hero Hall Upgrade Needed", $COLOR_DEBUG)
				Else
					SetLog(($bHero = "Warden" ? "Elixir" : "Dark Elixir") & " Insufficient", $COLOR_DEBUG)
				EndIf
				Return
			EndIf
			SetLog("Cost: " & HeroCostFormat($g_aiHeroNeededResource[4]) & " Dark Elixir")
			If _Sleep(500) Then Return
		Case "Duke"
			If Not ReadHeroNeededResource(5, $bXcoords[4]) Then
				If @error = 1 Then
					SetLog("Hero Hall Upgrade Needed", $COLOR_DEBUG)
				Else
					SetLog(($bHero = "Warden" ? "Elixir" : "Dark Elixir") & " Insufficient", $COLOR_DEBUG)
				EndIf
				Return
			EndIf
			SetLog("Cost: " & HeroCostFormat($g_aiHeroNeededResource[5]) & " Dark Elixir")
			If _Sleep(500) Then Return
	EndSwitch
EndFunc   ;==>NeededResources

Func UpgradeHeroes()
	Local $iBuildingReserve = ReservedBuildersForBuildings(False)

	If Not $g_bUpgradeKingEnable And Not $g_bUpgradeQueenEnable And Not $g_bUpgradePrinceEnable And Not $g_bUpgradeWardenEnable And Not $g_bUpgradeChampionEnable And Not $g_bUpgradeDukeEnable Then Return
	If _Sleep(500) Then Return

	If $g_iTownHallLevel < 4 Then
		SetLog("Town Hall Level " & $g_iTownHallLevel & " has no Hero Hall - Skip Locating", $COLOR_DEBUG)
		Return
	EndIf

	If Not $g_bRunState Then Return

	; Close modal windows before reading builders or selecting the Hero Hall.
	For $iCloseWindow = 1 To 3
		If Not $g_bRunState Then Return
		If Not CloseWindow2(1) Then ExitLoop
		If _Sleep(350) Then Return
	Next
	ClearScreen()
	If Not $g_bRunState Then Return
	If Not checkMainScreen(False, False, False) Then Return

	; Check builders before Hero Hall detection to avoid unnecessary image search.
	If Not getBuilderCount() Then Return ; update builder data, return if problem
	If _Sleep($DELAYRESPOND) Then Return

	If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) + $iBuildingReserve Then
		If Not $bCheckValuesForWarden Then
			SetLog("Not enough builders available to upgrade heroes")
			Return
		EndIf
	EndIf

	Local $aiSavedHeroHallPos = $g_aiHeroHallPos
	Local $bHeroHallSelected = ImgLocateHeroHall(True, True)
	If Not $bHeroHallSelected Then
		$g_aiHeroHallPos = $aiSavedHeroHallPos
		If $g_aiHeroHallPos[0] <= 0 Or $g_aiHeroHallPos[1] <= 0 Then Return
		SetLog("Hero Hall Position: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & ")", $COLOR_SUCCESS)
	EndIf

	; Ignore restart flag for hero upgrades to prevent blocking
	If $g_bRestart Then $g_bRestart = False

	$g_aiCurrentLoot[$eLootElixir] = getResourcesMainScreen(690, 59)
	$g_aiCurrentLoot[$eLootDarkElixir] = getResourcesMainScreen(690, 96)

	; Do not skip Hero Hall based on cached running bits or finish dates.
	; Each enabled hero is verified on its card below before deciding to upgrade or skip.

	If BitOR($g_bUpgradeKingEnable, $g_bUpgradeQueenEnable, $g_bUpgradePrinceEnable, $g_bUpgradeWardenEnable, $g_bUpgradeChampionEnable, $g_bUpgradeDukeEnable) Then
		SaveConfig()
	EndIf

	If Not $bCheckValuesForWarden Then
		SetLog("Upgrading Heroes", $COLOR_INFO)
	Else
		SetLog("Checking Warden Values", $COLOR_INFO)
	EndIf

	If Not $g_bRunState Then Return

	If Not $bHeroHallSelected Then
		BuildingClick($g_aiHeroHallPos[0], $g_aiHeroHallPos[1])
		If _Sleep($DELAYBUILDINGINFO1) Then Return
	EndIf
	Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
	If StringInStr($sHeroHallInfo[1], "Hero") Then
		If $g_aiHeroHallPos[2] <> $sHeroHallInfo[2] Then
			$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
		EndIf
		Local $HeroHallButton = FindButton("HeroHallButton")
		If IsArray($HeroHallButton) And UBound($HeroHallButton) = 2 Then
			ClickP($HeroHallButton)
			If _Sleep(Random(1500, 2000, 1)) Then Return
		Else
			SetLog("Hero Hall Button not found", $COLOR_ERROR)
			ClearScreen()
			Return
		EndIf
	Else
		SetLog("Hero Hall not found", $COLOR_ERROR)
		ClearScreen()
		Return
	EndIf


	If $bCheckValuesForWarden Then
		WardenUpgrade()
		CloseWindow()
		$bCheckValuesForWarden = False
		Return
	EndIf

	;Check if Auto Lab Upgrade is enabled and if a Dark Troop/Spell is selected for Upgrade. If yes, it has priority!
	If BitOR($g_bUpgradeKingEnable, $g_bUpgradeQueenEnable, $g_bUpgradePrinceEnable, $g_bUpgradeChampionEnable) Then
		If $g_bAutoLabUpgradeEnable And $g_iLaboratoryDElixirCost > 0 Then
			SetLog("Laboratory needs DE to Upgrade:  " & $g_iLaboratoryDElixirCost)
			SetLog("Skipping the Queen, King, Champion and Prince Upgrade!")
		Else
			; ### Barbarian King ###
			If $g_bUpgradeKingEnable Then
				If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) + $iBuildingReserve Then
					SetLog("Not enough Builders available to upgrade the Barbarian King")
					CloseWindow()
					Return
				EndIf
				KingUpgrade()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
			EndIf
			If Not $g_bRunState Then Return
			; ### Archer Queen ###
			If $g_bUpgradeQueenEnable Then
				If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) + $iBuildingReserve Then
					SetLog("Not enough Builders available to upgrade the Archer Queen")
					CloseWindow()
					Return
				EndIf
				QueenUpgrade()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
			EndIf
			If Not $g_bRunState Then Return
			; ### Minion Prince ###
			If $g_bUpgradePrinceEnable Then
				If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) + $iBuildingReserve Then
					SetLog("Not enough Builders available to upgrade the Minion Prince")
					CloseWindow()
					Return
				EndIf
				PrinceUpgrade()

				If _Sleep($DELAYUPGRADEHERO1) Then Return
			EndIf
			If Not $g_bRunState Then Return
		EndIf
	EndIf

	; ### Grand Warden ###
	;Check if Auto Lab Upgrade is enabled and if a Elixir Troop/Spell is selected for Upgrade. If yes, it has priority!
	If $g_bUpgradeWardenEnable Then
		If $g_bAutoLabUpgradeEnable And $g_iLaboratoryElixirCost > 0 Then
			SetLog("Laboratory needs Elixir to Upgrade:  " & $g_iLaboratoryElixirCost)
			SetLog("Skipping the Warden Upgrade!")
		Else
			If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) + $iBuildingReserve Then
				SetLog("Not enough Builders available to upgrade the Grand Warden")
				CloseWindow()
				Return
			EndIf
			WardenUpgrade()
		EndIf
	EndIf

	If Not $g_bRunState Then Return

	; ### Royal Champion ###
	If $g_bUpgradeChampionEnable Then
		If $g_bAutoLabUpgradeEnable And $g_iLaboratoryDElixirCost > 0 Then
			SetLog("Laboratory needs DE to Upgrade:  " & $g_iLaboratoryDElixirCost)
			SetLog("Skipping the Royal Champion Upgrade!")
		Else
			If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) + $iBuildingReserve Then
				SetLog("Not enough Builders available to upgrade the Royal Champion")
				CloseWindow()
				Return
			EndIf
			ChampionUpgrade()

			If _Sleep($DELAYUPGRADEHERO1) Then Return
		EndIf
	EndIf

	If Not $g_bRunState Then Return

	; ### Duke ### (always last - requires scroll)
	If $g_bUpgradeDukeEnable Then
		If $g_iFreeBuilderCount < 1 + ($g_bAutoUpgradeWallsEnable And $g_bUpgradeWallSaveBuilder ? 1 : 0) + $iBuildingReserve Then
			SetLog("Not enough Builders available to upgrade the Duke")
			CloseWindow()
			Return
		EndIf
		DukeUpgrade()
	EndIf

	If Not $g_bRunState Then Return
	CloseWindow()

EndFunc   ;==>UpgradeHeroes

Func KingUpgrade()

	If Not $g_bUpgradeKingEnable Then Return

	If Not $g_bRunState Then Return

	If $g_iTownHallLevel < 4 Then
		SetLog("Town Hall Upgrade Needed", $COLOR_DEBUG)
		Return
	EndIf
	If _IsHeroUpgrading($bXcoords[0], 429) Then
		SetLog("King Upgrade: Running", $COLOR_INFO)
		SetHeroUpgradeRunning(0, $eHeroKing)
		Return
	EndIf
	If IsHeroAtHeroHallLevelLimit(0, $g_iKingLevel) Then
		HandleHeroUpgradeAtHeroHallLimit(0)
		Return
	EndIf
	If HandleHeroUpgradeInsufficientResources(0, $bXcoords[0], "King") Then Return
	SetLog("Upgrade King", $COLOR_ACTION)
	Local $bOffset = False
	If IsHeroUpgradeButtonGreen($bXcoords[0]) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[0] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[0] + 42, 438 + $g_iMidOffsetY, $bXcoords[0] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[0] + 20, 420 + $g_iMidOffsetY, $bXcoords[0] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			MarkHeroUpgradeAtMaxLevel(0)
			Return
		EndIf
		If IsArray(_PixelSearch($bXcoords[0], 438 + $g_iMidOffsetY, $bXcoords[0] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Dark Elixir Insufficient", $COLOR_DEBUG)
			If $g_aiHeroNeededResource[0] = 0 Then NeededResources("King")
			Return
		EndIf
		If IsHeroUpgradeButtonGrey($bXcoords[0]) Then
			HandleHeroUpgradeAtHeroHallLimit(0)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iKingCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[0] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iKingCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[0] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iKingCostOCR = "" Then
		HandleHeroCostOcrFailure(0, $bXcoords[0], "King")
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[0] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If Not WaitForHeroUpgradeWindow() Then
		SaveHeroUpgradeFailureImage("King", "WindowNotDetected")
		SetLog("King Upgrade Failed - Upgrade window not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf
	Local $g_iKingLevelOCR = getYellowLevel(527, 116)
	$g_iKingLevel = Number($g_iKingLevelOCR - 1)
	If $g_iKingLevel = -1 Then
		SetLog("Unable To Read King Level", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	Else
		SetLog("Barbarian King Level: " & $g_iKingLevel, $COLOR_INFO)
	EndIf

	If IsHeroUpgradeResourceDisabled() Or $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afKingUpgCost[$g_iKingLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
		SetLog("Dark Elixir Insufficient, Requires:" & ($g_afKingUpgCost[$g_iKingLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		CloseWindow2(1)
		Return
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = 0, $YellowSearch = 0
	FindHeroUpgradeConfirmButton($aWhiteZeros, $YellowSearch)
	Local $ahGroupKingWait[4] = [$g_hChkDBKingWait, $g_hChkABKingWait, $g_hPicDBKingWait, $g_hPicABKingWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_03", "ATTENTION: King auto upgrade is currently enabled")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afKingUpgCost[$g_iKingLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("King Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[0]) Then
			SaveHeroUpgradeFailureImage("King", "StartNotConfirmed")
			SetLog("King Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("King Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
		$g_iHeroUpgrading[0] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[0] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("King Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[0], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[0] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afKingUpgCost[$g_iKingLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("King Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[0]) Then
			SaveHeroUpgradeFailureImage("King", "StartNotConfirmed")
			SetLog("King Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("King Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicKingGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicKingBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicKingGreen, $GUI_HIDE)
		$g_iHeroUpgrading[0] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroKing)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[0] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("King Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[0], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[0] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SaveHeroUpgradeFailureImage("King", "ButtonNotDetected")
		SetLog("King Upgrade Failed - Upgrade button not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>KingUpgrade

Func QueenUpgrade()

	If Not $g_bUpgradeQueenEnable Then Return

	If Not $g_bRunState Then Return
	If $g_iTownHallLevel < 8 Then
		SetLog("Town Hall Upgrade Needed", $COLOR_DEBUG)
		Return
	EndIf

	If _IsHeroUpgrading($bXcoords[1], 429) Then
		SetLog("Queen Upgrade: Running", $COLOR_INFO)
		SetHeroUpgradeRunning(1, $eHeroQueen)
		Return
	EndIf
	If IsHeroAtHeroHallLevelLimit(1, $g_iQueenLevel) Then
		HandleHeroUpgradeAtHeroHallLimit(1)
		Return
	EndIf
	If HandleHeroUpgradeInsufficientResources(1, $bXcoords[1], "Queen") Then Return
	SetLog("Upgrade Queen", $COLOR_ACTION)
	Local $bOffset = False
	If IsHeroUpgradeButtonGreen($bXcoords[1]) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[1] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[1] + 42, 438 + $g_iMidOffsetY, $bXcoords[1] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[1] + 20, 420 + $g_iMidOffsetY, $bXcoords[1] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			MarkHeroUpgradeAtMaxLevel(1)
			Return
		EndIf
		If IsArray(_PixelSearch($bXcoords[1], 438 + $g_iMidOffsetY, $bXcoords[1] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Dark Elixir Insufficient", $COLOR_DEBUG)
			If $g_aiHeroNeededResource[1] = 0 Then NeededResources("Queen")
			Return
		EndIf
		If IsHeroUpgradeButtonGrey($bXcoords[1]) Then
			HandleHeroUpgradeAtHeroHallLimit(1)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iQueenCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[1] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iQueenCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[1] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iQueenCostOCR = "" Then
		HandleHeroCostOcrFailure(1, $bXcoords[1], "Queen")
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[1] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If Not WaitForHeroUpgradeWindow() Then
		SaveHeroUpgradeFailureImage("Queen", "WindowNotDetected")
		SetLog("Queen Upgrade Failed - Upgrade window not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf
	Local $g_iQueenLevelOCR = getYellowLevel(518, 116)
	$g_iQueenLevel = Number($g_iQueenLevelOCR - 1)
	If $g_iQueenLevel = -1 Then
		SetLog("Unable To Read Queen Level", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	Else
		SetLog("Archer Queen Level: " & $g_iQueenLevel, $COLOR_INFO)
	EndIf

	If IsHeroUpgradeResourceDisabled() Or $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afQueenUpgCost[$g_iQueenLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
		SetLog("Dark Elixir Insufficient, Requires:" & ($g_afQueenUpgCost[$g_iQueenLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		CloseWindow2(1)
		Return
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = 0, $YellowSearch = 0
	FindHeroUpgradeConfirmButton($aWhiteZeros, $YellowSearch)
	Local $ahGroupQueenWait[4] = [$g_hChkDBQueenWait, $g_hChkABQueenWait, $g_hPicDBQueenWait, $g_hPicABQueenWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_03", "ATTENTION: Queen auto upgrade is currently enabled")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afQueenUpgCost[$g_iQueenLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Queen Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[1]) Then
			SaveHeroUpgradeFailureImage("Queen", "StartNotConfirmed")
			SetLog("Queen Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Queen Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
		$g_iHeroUpgrading[1] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[1] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Queen Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[1], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[1] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afQueenUpgCost[$g_iQueenLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Queen Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[1]) Then
			SaveHeroUpgradeFailureImage("Queen", "StartNotConfirmed")
			SetLog("Queen Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Queen Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicQueenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicQueenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicQueenGreen, $GUI_HIDE)
		$g_iHeroUpgrading[1] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroQueen)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[1] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Queen Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[1], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[1] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SaveHeroUpgradeFailureImage("Queen", "ButtonNotDetected")
		SetLog("Queen Upgrade Failed - Upgrade button not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>QueenUpgrade

Func PrinceUpgrade()

	If Not $g_bUpgradePrinceEnable Then Return

	If Not $g_bRunState Then Return
	If $g_iTownHallLevel < 9 Then
		SetLog("Town Hall Upgrade Needed", $COLOR_DEBUG)
		Return
	EndIf

	If _IsHeroUpgrading($bXcoords[2], 429) Then
		SetLog("Prince Upgrade: Running", $COLOR_INFO)
		SetHeroUpgradeRunning(2, $eHeroPrince)
		Return
	EndIf
	If IsHeroAtHeroHallLevelLimit(2, $g_iPrinceLevel) Then
		HandleHeroUpgradeAtHeroHallLimit(2)
		Return
	EndIf
	If HandleHeroUpgradeInsufficientResources(2, $bXcoords[2], "Prince") Then Return
	SetLog("Upgrade Prince", $COLOR_ACTION)
	Local $bOffset = False
	If IsHeroUpgradeButtonGreen($bXcoords[2]) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[2] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[2] + 42, 438 + $g_iMidOffsetY, $bXcoords[2] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[2] + 20, 420 + $g_iMidOffsetY, $bXcoords[2] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			MarkHeroUpgradeAtMaxLevel(2)
			Return
		EndIf
		If IsArray(_PixelSearch($bXcoords[2], 438 + $g_iMidOffsetY, $bXcoords[2] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Dark Elixir Insufficient", $COLOR_DEBUG)
			If $g_aiHeroNeededResource[2] = 0 Then NeededResources("Prince")
			Return
		EndIf
		If IsHeroUpgradeButtonGrey($bXcoords[2]) Then
			HandleHeroUpgradeAtHeroHallLimit(2)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iPrinceCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[2] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iPrinceCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[2] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iPrinceCostOCR = "" Then
		HandleHeroCostOcrFailure(2, $bXcoords[2], "Prince")
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[2] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If Not WaitForHeroUpgradeWindow() Then
		SaveHeroUpgradeFailureImage("Prince", "WindowNotDetected")
		SetLog("Prince Upgrade Failed - Upgrade window not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf
	Local $g_iPrinceLevelOCR = getYellowLevel(518, 116)
	$g_iPrinceLevel = Number($g_iPrinceLevelOCR - 1)
	If $g_iPrinceLevel = -1 Then
		SetLog("Unable To Read Prince Level", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	Else
		SetLog("Minion Prince Level: " & $g_iPrinceLevel, $COLOR_INFO)
	EndIf

	If IsHeroUpgradeResourceDisabled() Or $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afPrinceUpgCost[$g_iPrinceLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
		SetLog("Dark Elixir Insufficient, Requires:" & ($g_afPrinceUpgCost[$g_iPrinceLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		CloseWindow2(1)
		Return
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = 0, $YellowSearch = 0
	FindHeroUpgradeConfirmButton($aWhiteZeros, $YellowSearch)
	Local $ahGroupPrinceWait[4] = [$g_hChkDBPrinceWait, $g_hChkABPrinceWait, $g_hPicDBPrinceWait, $g_hPicABPrinceWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_03", "ATTENTION: Prince auto upgrade is currently enabled")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afPrinceUpgCost[$g_iPrinceLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Prince Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[2]) Then
			SaveHeroUpgradeFailureImage("Prince", "StartNotConfirmed")
			SetLog("Prince Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Prince Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
		$g_iHeroUpgrading[2] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[2] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Prince Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[2], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[2] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afPrinceUpgCost[$g_iPrinceLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Prince Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[2]) Then
			SaveHeroUpgradeFailureImage("Prince", "StartNotConfirmed")
			SetLog("Prince Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Prince Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicPrinceGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicPrinceBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicPrinceGreen, $GUI_HIDE)
		$g_iHeroUpgrading[2] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroPrince)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[2] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Prince Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[2], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[2] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SaveHeroUpgradeFailureImage("Prince", "ButtonNotDetected")
		SetLog("Prince Upgrade Failed - Upgrade button not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>PrinceUpgrade

Func WardenUpgrade()
	If Not $g_bUpgradeWardenEnable Then Return

	If Not $g_bRunState Then Return
	If $g_iTownHallLevel < 11 Then
		SetLog("Town Hall Upgrade Needed", $COLOR_DEBUG)
		Return
	EndIf

	If _IsHeroUpgrading($bXcoords[3], 429) Then
		SetLog("Warden Upgrade: Running", $COLOR_INFO)
		SetHeroUpgradeRunning(3, $eHeroWarden)
		Return
	EndIf
	If IsHeroAtHeroHallLevelLimit(3, $g_iWardenLevel) Then
		HandleHeroUpgradeAtHeroHallLimit(3)
		Return
	EndIf
	If HandleHeroUpgradeInsufficientResources(3, $bXcoords[3], "Warden") Then Return
	If Not $bCheckValuesForWarden Then SetLog("Upgrade Warden", $COLOR_ACTION)
	Local $bOffset = False
	If IsHeroUpgradeButtonGreen($bXcoords[3]) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[3] + 42, 425 + $g_iMidOffsetY, True), Hex(0xBEEA8C, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[3] + 42, 438 + $g_iMidOffsetY, $bXcoords[3] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[3] + 20, 420 + $g_iMidOffsetY, $bXcoords[3] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			MarkHeroUpgradeAtMaxLevel(3)
			Return
		EndIf
		If IsArray(_PixelSearch($bXcoords[3], 438 + $g_iMidOffsetY, $bXcoords[3] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Elixir Insufficient", $COLOR_DEBUG)
			If $g_aiHeroNeededResource[3] = 0 Then NeededResources("Warden")
			Return
		EndIf
		If IsHeroUpgradeButtonGrey($bXcoords[3]) Then
			HandleHeroUpgradeAtHeroHallLimit(3)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iWardenCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[3] + 32, 433 + $g_iMidOffsetY, 75, 20, True)
	Else
		Local $g_iWardenCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[3] + 10, 433 + $g_iMidOffsetY, 84, 20, True)
	EndIf
	If $g_iWardenCostOCR = "" Then
		HandleHeroCostOcrFailure(3, $bXcoords[3], "Warden")
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[3] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If Not WaitForHeroUpgradeWindow() Then
		SaveHeroUpgradeFailureImage("Warden", "WindowNotDetected")
		SetLog("Warden Upgrade Failed - Upgrade window not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf
	Local $g_iWardenLevelOCR = getYellowLevel(522, 116)
	$g_iWardenLevel = Number($g_iWardenLevelOCR - 1)
	If $g_iWardenLevel = -1 Then
		SetLog("Unable To Read Warden Level", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	Else
		SetLog("Grand Warden Level: " & $g_iWardenLevel, $COLOR_INFO)
	EndIf

	If $bCheckValuesForWarden Then
		If $g_aiHeroNeededResource[3] = 0 Then
			If $g_iWardenLevel < 0 Then
				SetLog("Unable To Read Warden Level For Cost Calculation", $COLOR_ERROR)
				CloseWindow2(1)
				Return
			EndIf
			$g_aiHeroNeededResource[3] = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
			SetLog("Cost: " & HeroCostFormat($g_aiHeroNeededResource[3]) & " Elixir")
			CloseWindow2(1)
			Return
		EndIf
	EndIf

	If IsHeroUpgradeResourceDisabled() Or $g_aiCurrentLoot[$eLootElixir] < ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinElixir Then
		SetLog("Elixir Insufficient, Requires: " & ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinElixir, $COLOR_INFO)
		CloseWindow2(1)
		Return
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = 0, $YellowSearch = 0
	FindHeroUpgradeConfirmButton($aWhiteZeros, $YellowSearch)
	Local $ahGroupWardenWait[4] = [$g_hChkDBWardenWait, $g_hChkABWardenWait, $g_hPicDBWardenWait, $g_hPicABWardenWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_03", "ATTENTION: Warden auto upgrade is currently enabled")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Warden Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[3]) Then
			SaveHeroUpgradeFailureImage("Warden", "StartNotConfirmed")
			SetLog("Warden Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Warden Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
		$g_iHeroUpgrading[3] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfWardenUpped += 1
		$g_iCostElixirWarden += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[3] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Warden Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[3], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[3] = 0
		$g_aiCurrentLoot[$eLootElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afWardenUpgCost[$g_iWardenLevel] * 1000000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Warden Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[3]) Then
			SaveHeroUpgradeFailureImage("Warden", "StartNotConfirmed")
			SetLog("Warden Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Warden Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicWardenGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicWardenBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicWardenGreen, $GUI_HIDE)
		$g_iHeroUpgrading[3] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroWarden)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfWardenUpped += 1
		$g_iCostElixirWarden += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[3] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Warden Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[3], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[3] = 0
		$g_aiCurrentLoot[$eLootElixir] -= $bUpgradeCost
	Else
		SaveHeroUpgradeFailureImage("Warden", "ButtonNotDetected")
		SetLog("Warden Upgrade Failed - Upgrade button not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>WardenUpgrade

Func ChampionUpgrade()

	If Not $g_bUpgradeChampionEnable Then Return

	If Not $g_bRunState Then Return
	If $g_iTownHallLevel < 13 Then
		SetLog("Town Hall Upgrade Needed", $COLOR_DEBUG)
		Return
	EndIf

	If _IsHeroUpgrading($bXcoords[4], 429) Then
		SetLog("Champion Upgrade: Running", $COLOR_INFO)
		SetHeroUpgradeRunning(4, $eHeroChampion)
		Return
	EndIf
	If IsHeroAtHeroHallLevelLimit(4, $g_iChampionLevel) Then
		HandleHeroUpgradeAtHeroHallLimit(4)
		Return
	EndIf
	If HandleHeroUpgradeInsufficientResources(4, $bXcoords[4], "Champion") Then Return
	SetLog("Upgrade Champion", $COLOR_ACTION)
	Local $bOffset = False
	If IsHeroUpgradeButtonGreen($bXcoords[4]) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[4] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[4] + 42, 438 + $g_iMidOffsetY, $bXcoords[4] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[4] + 20, 420 + $g_iMidOffsetY, $bXcoords[4] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			MarkHeroUpgradeAtMaxLevel(4)
			Return
		EndIf
		If IsArray(_PixelSearch($bXcoords[4], 438 + $g_iMidOffsetY, $bXcoords[4] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Dark Elixir Insufficient", $COLOR_DEBUG)
			If $g_aiHeroNeededResource[4] = 0 Then NeededResources("Champion")
			Return
		EndIf
		If IsHeroUpgradeButtonGrey($bXcoords[4]) Then
			HandleHeroUpgradeAtHeroHallLimit(4)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iChampionCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[4] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iChampionCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[4] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iChampionCostOCR = "" Then
		HandleHeroCostOcrFailure(4, $bXcoords[4], "Champion")
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[4] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If Not WaitForHeroUpgradeWindow() Then
		SaveHeroUpgradeFailureImage("Champion", "WindowNotDetected")
		SetLog("Champion Upgrade Failed - Upgrade window not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf
	Local $g_iChampionLevelOCR = getYellowLevel(525, 116)
	$g_iChampionLevel = Number($g_iChampionLevelOCR - 1)
	If $g_iChampionLevel = -1 Then
		SetLog("Unable To Read Champion Level", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	Else
		SetLog("Royal Champion Level: " & $g_iChampionLevel, $COLOR_INFO)
	EndIf

	If IsHeroUpgradeResourceDisabled() Or $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afChampionUpgCost[$g_iChampionLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
		SetLog("Dark Elixir Insufficient, Requires:" & ($g_afChampionUpgCost[$g_iChampionLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		CloseWindow2(1)
		Return
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = 0, $YellowSearch = 0
	FindHeroUpgradeConfirmButton($aWhiteZeros, $YellowSearch)
	Local $ahGroupChampionWait[4] = [$g_hChkDBChampionWait, $g_hChkABChampionWait, $g_hPicDBChampionWait, $g_hPicABChampionWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_03", "ATTENTION: Champion auto upgrade is currently enabled")
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afChampionUpgCost[$g_iChampionLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Champion Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[4]) Then
			SaveHeroUpgradeFailureImage("Champion", "StartNotConfirmed")
			SetLog("Champion Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Champion Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		$g_iHeroUpgrading[4] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[4] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Champion Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[4], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[4] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afChampionUpgCost[$g_iChampionLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Champion Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[4]) Then
			SaveHeroUpgradeFailureImage("Champion", "StartNotConfirmed")
			SetLog("Champion Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Champion Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicChampionGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicChampionBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicChampionGreen, $GUI_HIDE)
		$g_iHeroUpgrading[4] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroChampion)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[4] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Champion Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[4], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[4] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SaveHeroUpgradeFailureImage("Champion", "ButtonNotDetected")
		SetLog("Champion Upgrade Failed - Upgrade button not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf

EndFunc   ;==>ChampionUpgrade

Func DukeUpgrade()

	If Not $g_bUpgradeDukeEnable Then Return

	If Not $g_bRunState Then Return
	If $g_iTownHallLevel < 15 Then
		SetLog("Town Hall Upgrade Needed", $COLOR_DEBUG)
		Return
	EndIf

	; Scroll right to reveal Duke (off-screen, 6th hero slot)
	ClickDrag(400, 300 + $g_iMidOffsetY, 247, 300 + $g_iMidOffsetY, 50) ; Swipe left 153px to reveal Duke
	If _Sleep(800) Then Return ; Wait for scroll animation

	If _IsHeroUpgrading($bXcoords[5], 429) Then
		SetLog("Duke Upgrade: Running", $COLOR_INFO)
		SetHeroUpgradeRunning(5, $eHeroDuke)
		If _Sleep(500) Then Return
		Return
	EndIf
	If IsHeroAtHeroHallLevelLimit(5, $g_iDukeLevel) Then
		HandleHeroUpgradeAtHeroHallLimit(5)
		Return
	EndIf
	If HandleHeroUpgradeInsufficientResources(5, $bXcoords[4], "Duke") Then Return
	SetLog("Upgrade Duke", $COLOR_ACTION)
	Local $bOffset = False
	If IsHeroUpgradeButtonGreen($bXcoords[4]) Then
		SetDebugLog("Green Pixel Check: OK")
	ElseIf _ColorCheck(_GetPixelColor($bXcoords[4] + 42, 438 + $g_iMidOffsetY, True), Hex(0x8BD43A, 6), 20) And _
			IsArray(_PixelSearch($bXcoords[4] + 42, 438 + $g_iMidOffsetY, $bXcoords[4] + 95, 444 + $g_iMidOffsetY, Hex(0xFFFFFF, 6), 20, True)) Then
		SetDebugLog("Green Pixel Check: OK")
		$bOffset = True
	Else
		Local $HeroMaxLevel = decodeSingleCoord(FindImageInPlace2("HeroMaxLevel", $ImgHeroMaxLevel, $bXcoords[4] + 20, 420 + $g_iMidOffsetY, $bXcoords[4] + 100, 445 + $g_iMidOffsetY, True))
		If IsArray($HeroMaxLevel) And UBound($HeroMaxLevel) = 2 Then
			MarkHeroUpgradeAtMaxLevel(5)
			Return
		EndIf
		If IsArray(_PixelSearch($bXcoords[4], 438 + $g_iMidOffsetY, $bXcoords[4] + 95, 444 + $g_iMidOffsetY, Hex(0xFF887F, 6), 20, True)) Then
			SetLog("Dark Elixir Insufficient", $COLOR_DEBUG)
			If $g_aiHeroNeededResource[5] = 0 Then NeededResources("Duke")
			Return
		EndIf
		If IsHeroUpgradeButtonGrey($bXcoords[4]) Then
			HandleHeroUpgradeAtHeroHallLimit(5)
			Return
		EndIf
	EndIf

	If $bOffset Then
		Local $g_iDukeCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[4] + 38, 433 + $g_iMidOffsetY, 65, 20, True)
	Else
		Local $g_iDukeCostOCR = getOcrAndCapture("coc-HeroCost", $bXcoords[4] + 23, 433 + $g_iMidOffsetY, 65, 20, True)
	EndIf
	If $g_iDukeCostOCR = "" Then
		HandleHeroCostOcrFailure(5, $bXcoords[4], "Duke")
		Return
	EndIf

	If _Sleep($DELAYUPGRADEHERO1) Then Return

	Click($bXcoords[4] + 55, 433 + $g_iMidOffsetY) ; Click Upgrade Button
	If _Sleep($DELAYUPGRADEHERO3) Then Return ; Wait for window to open
	If Not $g_bRunState Then Return

	If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn1")
	If Not WaitForHeroUpgradeWindow() Then
		SaveHeroUpgradeFailureImage("Duke", "WindowNotDetected")
		SetLog("Duke Upgrade Failed - Upgrade window not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf
	Local $g_iDukeLevelOCR = getYellowLevel(525, 116)
	$g_iDukeLevel = Number($g_iDukeLevelOCR - 1)
	If $g_iDukeLevel = -1 Then
		SetLog("Unable To Read Duke Level", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	Else
		SetLog("Dragon Duke Level: " & $g_iDukeLevel, $COLOR_INFO)
	EndIf

	If IsHeroUpgradeResourceDisabled() Or $g_aiCurrentLoot[$eLootDarkElixir] < ($g_afDukeUpgCost[$g_iDukeLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) + $g_iUpgradeMinDark Then
		SetLog("Dark Elixir Insufficient, Requires:" & ($g_afDukeUpgCost[$g_iDukeLevel] * 1000) * (1 - Number($g_iBuilderBoostDiscount) / 100) & " + " & $g_iUpgradeMinDark, $COLOR_INFO)
		CloseWindow2(1)
		Return
	EndIf

	Local $g_aUpgradeDuration = getHeroUpgradeTime(715, 544 + $g_iMidOffsetY) ; get duration
	If $g_aUpgradeDuration = "" Then $g_aUpgradeDuration = getHeroUpgradeTime(730, 532 + $g_iMidOffsetY) ; Try to read yellow text (Discount).

	Local $aWhiteZeros = 0, $YellowSearch = 0
	FindHeroUpgradeConfirmButton($aWhiteZeros, $YellowSearch)
	If (IsArray($aWhiteZeros) And UBound($aWhiteZeros, 1) = 2) Then

		Local $bUpgradeCost = ($g_afDukeUpgCost[$g_iDukeLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($aWhiteZeros, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Duke Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[5]) Then
			SaveHeroUpgradeFailureImage("Duke", "StartNotConfirmed")
			SetLog("Duke Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Duke Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicDukeGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicDukeBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeGreen, $GUI_HIDE)
		$g_iHeroUpgrading[5] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroDuke)
		$g_iFreeBuilderCount -= 1
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[5] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Duke Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[5], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[5] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	ElseIf IsArray($YellowSearch) Then

		Local $bUpgradeCost = ($g_afDukeUpgCost[$g_iDukeLevel] * 1000 * (1 - Number($g_iBuilderBoostDiscount) / 100))
		SetLog("Cost: " & _NumberFormat($bUpgradeCost) & " Dark Elixir", $COLOR_INFO)
		If _Sleep(1000) Then Return

		ClickP($YellowSearch, 1, 120)         ; Click upgrade button

		If _Sleep($DELAYUPGRADEHERO1) Then Return
		If $g_bDebugImageSave Then SaveDebugImage("UpgradeDarkBtn2")
		If isGemOpen(True) Then         ; Redundant Safety Check if the use Gem window opens
			SetLog("Duke Upgrade Fail! Gem Window popped up!", $COLOR_ERROR)
			Return
		EndIf
		If Not WaitForHeroUpgradeStarted($bXcoords[5]) Then
			SaveHeroUpgradeFailureImage("Duke", "StartNotConfirmed")
			SetLog("Duke Upgrade Fail! Upgrade start not confirmed!", $COLOR_ERROR)
			Return
		EndIf
		SetLog("Duke Upgrade Complete", $COLOR_SUCCESS)
		GUICtrlSetState($g_hPicDukeGray, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeRed, $GUI_SHOW)
		GUICtrlSetState($g_hPicDukeBlue, $GUI_HIDE)
		GUICtrlSetState($g_hPicDukeGreen, $GUI_HIDE)
		$g_iHeroUpgrading[5] = 1
		$g_iHeroUpgradingBit = BitOR($g_iHeroUpgradingBit, $eHeroDuke)
		If _Sleep($DELAYUPGRADEHERO2) Then Return         ; Wait for window to close
		$g_iNbrOfHeroesUpped += 1
		$g_iCostDElixirHero += $bUpgradeCost
		UpdateStats()
		Local $bFinishTime = ConvertOCRTime("FinishTime", $g_aUpgradeDuration, False)
		$g_aiHeroUpgradeFinishDate[5] = _DateAdd('n', Ceiling($bFinishTime), _NowCalc())
		SetLog("Duke Upgrade Finishes @ " & $g_aiHeroUpgradeFinishDate[5], $COLOR_SUCCESS)
		$g_aiHeroNeededResource[5] = 0
		$g_aiCurrentLoot[$eLootDarkElixir] -= $bUpgradeCost
	Else
		SaveHeroUpgradeFailureImage("Duke", "ButtonNotDetected")
		SetLog("Duke Upgrade Failed - Upgrade button not detected!", $COLOR_ERROR)
		CloseWindow2(1)
		Return
	EndIf
EndFunc   ;==>DukeUpgrade

Func ReservedBuildersForHeroes($aSetLog = True)
	Local $iUsedBuildersForHeroes = Number(BitAND($g_iHeroUpgradingBit, $eHeroKing) = $eHeroKing ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroQueen) = $eHeroQueen ? 1 : 0) + _
			Number(BitAND($g_iHeroUpgradingBit, $eHeroPrince) = $eHeroPrince ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroWarden) = $eHeroWarden ? 1 : 0) + Number(BitAND($g_iHeroUpgradingBit, $eHeroChampion) = $eHeroChampion ? 1 : 0) + _
			Number(BitAND($g_iHeroUpgradingBit, $eHeroDuke) = $eHeroDuke ? 1 : 0)
	If $aSetLog And $g_iHeroReservedBuilder > 0 Then SetLog("Builders upgrading heroes: " & $iUsedBuildersForHeroes)

	Local $iFreeBuildersReservedForHeroes = _Max(Number($g_iHeroReservedBuilder) - $iUsedBuildersForHeroes, 0)
	If $aSetLog And $g_iHeroReservedBuilder > 0 Then SetLog("Free builders reserved for heroes: " & $iFreeBuildersReservedForHeroes)

	If $g_bDebugSetLog Then SetLog("HeroBuilders R|Rn|W|F: " & $g_iHeroReservedBuilder & "|" & Number($g_iHeroReservedBuilder) & "|" & $iUsedBuildersForHeroes & "|" & $iFreeBuildersReservedForHeroes, $COLOR_DEBUG)

	Return $iFreeBuildersReservedForHeroes
EndFunc   ;==>ReservedBuildersForHeroes

Func TakeWardenValues()
	If $g_bUpgradeWardenEnable And $g_bAutoUpgradeWallsEnable Then
		Local $bWardenCheck = False
		If Not _DateIsValid($g_aiHeroUpgradeFinishDate[3]) Then
			If $g_aiHeroNeededResource[3] = 0 Then $bWardenCheck = True
		ElseIf _DateIsValid($g_aiHeroUpgradeFinishDate[3]) Then
			If _DateDiff('n', _NowCalc(), $g_aiHeroUpgradeFinishDate[3]) < 0 Then $bWardenCheck = True
		EndIf
		If $bWardenCheck Then
			$bCheckValuesForWarden = True
			Return True
		EndIf
	EndIf
	Return False
EndFunc   ;==>TakeWardenValues

Func TestUpgradeHeroes()
	If Not _UHR_IsHeroHallPanelOpen() Then
		SetLog("[Hero Hall]: Window not detected", $COLOR_ERROR)
		Return False
	EndIf
	SetLog("[Hero Upgrade Test]: Scanning upgrades", $COLOR_INFO)

	Local $aHeroName[6] = ["King", "Queen", "Prince", "Warden", "Champion", "Duke"]
	For $iHero = 0 To 4
		_UHR_LogUpgradeState($aHeroName[$iHero], _UHR_GetUpgradeState($iHero, $bXcoords[$iHero]))
	Next

	ClickDrag(400, 300 + $g_iMidOffsetY, 247, 300 + $g_iMidOffsetY, 50)
	If _Sleep(800) Then Return False
	_UHR_LogUpgradeState($aHeroName[5], _UHR_GetUpgradeState(5, $bXcoords[5]))
	ClickDrag(247, 300 + $g_iMidOffsetY, 400, 300 + $g_iMidOffsetY, 50)
	If _Sleep(800) Then Return False
	Return True
EndFunc   ;==>TestUpgradeHeroes
