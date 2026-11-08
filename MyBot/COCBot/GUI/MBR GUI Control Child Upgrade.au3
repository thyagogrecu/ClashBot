; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Upgrade
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

Func btnLocateUpgrades()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	LocateUpgrades()
	$g_bRunState = $wasRunState
EndFunc   ;==>btnLocateUpgrades

Func cmbBuildingReservedBuilder()
	$g_iBuildingReservedBuilder = _GUICtrlComboBox_GetCurSel($g_hCmbBuildingReservedBuilder)
	If $g_iBuildingReservedBuilder < 0 Then $g_iBuildingReservedBuilder = 0
	If $g_iBuildingReservedBuilder > 6 Then $g_iBuildingReservedBuilder = 6
	_GUICtrlComboBox_SetCurSel($g_hCmbBuildingReservedBuilder, $g_iBuildingReservedBuilder)
EndFunc   ;==>cmbBuildingReservedBuilder

Func btnchkbxUpgrade()
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgrade[$i]) = $GUI_CHECKED Then
			$g_abBuildingUpgradeEnable[$i] = True
		Else
			$g_abBuildingUpgradeEnable[$i] = False
		EndIf
	Next
EndFunc   ;==>btnchkbxUpgrade

Func btnchkbxRepeat()
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgradeRepeat[$i]) = $GUI_CHECKED Then
			$g_abUpgradeRepeatEnable[$i] = True
		Else
			$g_abUpgradeRepeatEnable[$i] = False
		EndIf
	Next
EndFunc   ;==>btnchkbxRepeat

Func picUpgradeTypeLocation()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	PureClick(1, 40, 1, 100, "#9999") ; Clear screen
	Sleep(100)
	ZoomOut() ; Zoom out if needed
	Local $inum
	For $inum = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If @GUI_CtrlId = $g_hPicUpgradeType[$inum] Then
			Local $x = $g_avBuildingUpgrades[$inum][0]
			Local $y = $g_avBuildingUpgrades[$inum][1]
			Local $n = $g_avBuildingUpgrades[$inum][4]
			SetDebugLog("Selecting #" & $inum + 1 & ": " & $n & ", " & $x & "/" & $y)
			If isInsideDiamondXY($x, $y) Then ; check for valid location
				BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1], "#9999")
				Sleep(100)
				If StringInStr($n, "collect", $STR_NOCASESENSEBASIC) Or _
						StringInStr($n, "mine", $STR_NOCASESENSEBASIC) Or _
						StringInStr($n, "drill", $STR_NOCASESENSEBASIC) Then
					Click(1, 40, 1, 0, "#0999") ;Click away to deselect collector if was not full, and collected with previous click
					Sleep(100)
					BuildingClick($g_avBuildingUpgrades[$inum][0], $g_avBuildingUpgrades[$inum][1], "#9999") ;Select collector
				EndIf
			EndIf
			ExitLoop
		EndIf
	Next
	$g_bRunState = $wasRunState
EndFunc   ;==>picUpgradeTypeLocation

Func btnResetUpgrade()
	Local $iEmptyRow = -1 ;-1 means no empty row found yet.
	Local $j = 0 ;temp upgrade type or status
	;Sleep(5000)
	;SetDebugLog("Reset Upgarde *******************************************")
	For $i = 0 To UBound($g_avBuildingUpgrades, 1) - 1
		If GUICtrlRead($g_hChkUpgradeRepeat[$i]) = $GUI_CHECKED Then
			;SetDebugLog("Row to keep " & $i)
			If $iEmptyRow <> -1 Then ;Is there an empty row to fill?
				;SetDebugLog("Moving from " & $i)
				;SetDebugLog("Moving to " & $iEmptyRow)
				;Move this row up...
				$g_aiPicUpgradeStatus[$iEmptyRow] = $g_aiPicUpgradeStatus[$i] ; Upgrade status
				$g_avBuildingUpgrades[$iEmptyRow][0] = $g_avBuildingUpgrades[$i][0] ;Upgrade Location X
				$g_avBuildingUpgrades[$iEmptyRow][1] = $g_avBuildingUpgrades[$i][1] ;Upgrade Location Y
				$g_avBuildingUpgrades[$iEmptyRow][2] = $g_avBuildingUpgrades[$i][2] ;Upgrade Value
				;SetDebugLog("Type setting to " & $g_avBuildingUpgrades[$i][3])
				$g_avBuildingUpgrades[$iEmptyRow][3] = $g_avBuildingUpgrades[$i][3] ;Upgrade Type
				;SetDebugLog("Name in global setting to " & $g_avBuildingUpgrades[$i][4])
				$g_avBuildingUpgrades[$iEmptyRow][4] = $g_avBuildingUpgrades[$i][4] ;Upgrade Unit Name
				;SetDebugLog("Level in global setting to " & $g_avBuildingUpgrades[$i][5])
				$g_avBuildingUpgrades[$iEmptyRow][5] = $g_avBuildingUpgrades[$i][5] ;Upgrade Level
				$g_avBuildingUpgrades[$iEmptyRow][6] = $g_avBuildingUpgrades[$i][6] ;Upgrade Duration
				$g_avBuildingUpgrades[$iEmptyRow][7] = $g_avBuildingUpgrades[$i][7] ;Upgrade Finish Time

				;Set the GUI data for new row and clear the GUI data for the cleared row.
				;GUI Unit Name
				;SetDebugLog("Setting name " & $g_avBuildingUpgrades[$iEmptyRow][4])
				GUICtrlSetData($g_hTxtUpgradeName[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][4])
				GUICtrlSetData($g_hTxtUpgradeName[$i], "")
				;GUI Unit Level
				;SetDebugLog("Setting level " & $g_avBuildingUpgrades[$iEmptyRow][5])
				GUICtrlSetData($g_hTxtUpgradeLevel[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][5])
				GUICtrlSetData($g_hTxtUpgradeLevel[$i], "")
				;Upgrade value in GUI
				GUICtrlSetData($g_hTxtUpgradeValue[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][2])
				GUICtrlSetData($g_hTxtUpgradeValue[$i], "")
				;Upgrade duration in GUI
				GUICtrlSetData($g_hTxtUpgradeTime[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][6])
				GUICtrlSetData($g_hTxtUpgradeTime[$i], "")

				;GUI upgrade type image
				$j = $eIcnElixir
				If $g_avBuildingUpgrades[$iEmptyRow][3] = "GOLD" Then $j = $eIcnGold
				;SetDebugLog("Setting GUI type to " & $j)
				_GUICtrlSetImage($g_hPicUpgradeType[$iEmptyRow], $g_sLibIconPath, $j)
				_GUICtrlSetImage($g_hPicUpgradeType[$i], $g_sLibIconPath, $eIcnBlank)

				;GUI Status icon : Still not working right!
				;$eIcnTroops=43, $eIcnGreenLight=69, $eIcnRedLight=71 or $eIcnYellowLight=73
				;SetDebugLog("Setting status to " & $g_aiPicUpgradeStatus[$i])
				;$j=$g_aiPicUpgradeStatus[$i]
				;No idea why this crap is needed, but I can't pass a variable to _GUICtrlSetImage
				$j = $eIcnGreenLight
				If $g_aiPicUpgradeStatus[$i] = $eIcnYellowLight Then $j = $eIcnYellowLight
				$g_aiPicUpgradeStatus[$iEmptyRow] = $j
				_GUICtrlSetImage($g_hPicUpgradeStatus[$iEmptyRow], $g_sLibIconPath, $j)
				;SetDebugLog("Clearing old status to red light " & $eIcnRedLight)
				$g_aiPicUpgradeStatus[$i] = $eIcnRedLight ;blank row goes red
				_GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, $eIcnRedLight)

				;Upgrade selection box
				GUICtrlSetState($g_hChkUpgrade[$iEmptyRow], $GUI_CHECKED)
				GUICtrlSetState($g_hChkUpgrade[$i], $GUI_UNCHECKED)
				;Upgrade finish time in GUI
				GUICtrlSetData($g_hTxtUpgradeEndTime[$iEmptyRow], $g_avBuildingUpgrades[$iEmptyRow][7])
				GUICtrlSetData($g_hTxtUpgradeEndTime[$i], "")
				;Repeat box
				GUICtrlSetState($g_hChkUpgradeRepeat[$iEmptyRow], $GUI_CHECKED)
				GUICtrlSetState($g_hChkUpgradeRepeat[$i], $GUI_UNCHECKED)

				;Now clear the row we just moved from.
				$g_avBuildingUpgrades[$i][0] = -1 ;Upgrade Location X
				$g_avBuildingUpgrades[$i][1] = -1 ;Upgrade Location Y
				$g_avBuildingUpgrades[$i][2] = -1 ;Upgrade Value
				$g_avBuildingUpgrades[$i][3] = "" ;Upgrade Type
				$g_avBuildingUpgrades[$i][4] = "" ;Upgrade Unit Name
				$g_avBuildingUpgrades[$i][5] = "" ;Upgrade Level
				$g_avBuildingUpgrades[$i][6] = "" ;Upgrade Duration
				$g_avBuildingUpgrades[$i][7] = "" ;Upgrade Finish Time


				$i = $iEmptyRow ;Reset counter to this row so we continue forward from here.
				$iEmptyRow = -1 ;This should be the first empty row now.

			Else
				;set these to clear up old status icon issues on rows not moved
				;SetDebugLog("Not moving row " & $i)
				$j = $g_aiPicUpgradeStatus[$i]
				;SetDebugLog("Setting GUI status to " & $j) ;
				;Following works if a constant is used, but not an variable?
				If $j = 69 Then _GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, 69)
				If $j = 73 Then _GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, 73)
				ContinueLoop
			EndIf
		Else ;Row not checked.  Clear it.
			;SetDebugLog("Row not checked, clearing row " & $i)
			$g_avBuildingUpgrades[$i][0] = -1 ;Upgrade position x
			$g_avBuildingUpgrades[$i][1] = -1 ;Upgrade position y
			$g_avBuildingUpgrades[$i][2] = -1 ;Upgrade value
			$g_avBuildingUpgrades[$i][3] = "" ;Upgrade Type
			$g_avBuildingUpgrades[$i][4] = "" ;Upgrade Unit Name
			$g_avBuildingUpgrades[$i][5] = "" ;Upgrade Level
			$g_avBuildingUpgrades[$i][6] = "" ;Upgrade Duration
			$g_avBuildingUpgrades[$i][7] = "" ;Upgrade Finish Time
			GUICtrlSetData($g_hTxtUpgradeName[$i], "") ;GUI Unit Name
			GUICtrlSetData($g_hTxtUpgradeLevel[$i], "") ;GUI Unit Level
			GUICtrlSetData($g_hTxtUpgradeValue[$i], "") ;Upgrade value in GUI
			GUICtrlSetData($g_hTxtUpgradeTime[$i], "") ;Upgrade duration in GUI
			_GUICtrlSetImage($g_hPicUpgradeType[$i], $g_sLibIconPath, $eIcnBlank) ;Upgrade type blank
			$g_aiPicUpgradeStatus[$i] = $eIcnRedLight
			_GUICtrlSetImage($g_hPicUpgradeStatus[$i], $g_sLibIconPath, $eIcnRedLight) ;Upgrade status to not ready
			GUICtrlSetState($g_hChkUpgrade[$i], $GUI_UNCHECKED) ;Change upgrade selection box to unchecked
			GUICtrlSetData($g_hTxtUpgradeEndTime[$i], "") ;Clear Upgrade time in GUI
			GUICtrlSetState($g_hChkUpgradeRepeat[$i], $GUI_UNCHECKED) ;Change repeat box to unchecked
			If $iEmptyRow = -1 Then $iEmptyRow = $i ;This row is now empty.
		EndIf
	Next
EndFunc   ;==>btnResetUpgrade

Func chkLab()
	If GUICtrlRead($g_hChkAutoLabUpgrades) = $GUI_CHECKED Then
		$g_bAutoLabUpgradeEnable = True
		For $i = 0 To 2
			GUICtrlSetState($g_ahCmbLabPriority[$i], $GUI_ENABLE)
			GUICtrlSetState($g_ahPicLabPriority[$i], $GUI_SHOW)
		Next
		; Update icons
		For $i = 0 To 2
			If $g_aiLabUpgradePriority[$i] > 0 Then
				_GUICtrlSetImage($g_ahPicLabPriority[$i], $g_sLibIconPath, $g_avLabTroops[$g_aiLabUpgradePriority[$i]][1])
			Else
				_GUICtrlSetImage($g_ahPicLabPriority[$i], $g_sLibIconPath, $eIcnBlank)
			EndIf
		Next
	Else
		$g_bAutoLabUpgradeEnable = False
		For $i = 0 To 2
			GUICtrlSetState($g_ahCmbLabPriority[$i], $GUI_DISABLE)
			GUICtrlSetState($g_ahPicLabPriority[$i], $GUI_HIDE)
		Next
	EndIf
	LabStatusGUIUpdate()
EndFunc   ;==>chkLab

Func chkStarLab()
	If GUICtrlRead($g_hChkAutoStarLabUpgrades) = $GUI_CHECKED Then
		$g_bAutoStarLabUpgradeEnable = True
		For $i = 0 To 2
			GUICtrlSetState($g_ahCmbStarLabPriority[$i], $GUI_ENABLE)
			GUICtrlSetState($g_ahPicStarLabPriority[$i], $GUI_SHOW)
		Next
		; Update icons
		For $i = 0 To 2
			If $g_aiStarLabUpgradePriority[$i] > 0 Then
				_GUICtrlSetImage($g_ahPicStarLabPriority[$i], $g_sLibIconPath, $g_avStarLabTroops[$g_aiStarLabUpgradePriority[$i]][4])
			Else
				_GUICtrlSetImage($g_ahPicStarLabPriority[$i], $g_sLibIconPath, $eIcnBlank)
			EndIf
		Next
	Else
		$g_bAutoStarLabUpgradeEnable = False
		For $i = 0 To 2
			GUICtrlSetState($g_ahCmbStarLabPriority[$i], $GUI_DISABLE)
			GUICtrlSetState($g_ahPicStarLabPriority[$i], $GUI_HIDE)
		Next
	EndIf
	StarLabStatusGUIUpdate()
EndFunc   ;==>chkStarLab

Func LabStatusGUIUpdate()
	If _DateIsValid($g_sLabUpgradeTime) Then
		_GUICtrlSetTip($g_hBtnResetLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_06", "Troop Upgrade started") & ", " & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_07", "Will begin to check completion at:") & " " & $g_sLabUpgradeTime & @CRLF & " ")
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_HIDE) ; comment this line out to edit GUI
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>LabStatusGUIUpdate

Func StarLabStatusGUIUpdate()
	If _DateIsValid($g_sStarLabUpgradeTime) Then
		_GUICtrlSetTip($g_hBtnResetStarLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_06", "Troop Upgrade started") & ", " & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_07", "Will begin to check completion at:") & " " & $g_sStarLabUpgradeTime & @CRLF & " ")
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_HIDE)
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>StarLabStatusGUIUpdate

Func cmbLabPriority()
	Local $iCtrlId = @GUI_CtrlId
	Local $iIndex = -1
	For $i = 0 To 2
		If $iCtrlId = $g_ahCmbLabPriority[$i] Then
			$iIndex = $i
			ExitLoop
		EndIf
	Next
	For $i = 0 To 2
		$g_aiLabUpgradePriority[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbLabPriority[$i])
	Next
	If $iIndex <> -1 Then
		If $g_aiLabUpgradePriority[$iIndex] > 0 Then
			_GUICtrlSetImage($g_ahPicLabPriority[$iIndex], $g_sLibIconPath, $g_avLabTroops[$g_aiLabUpgradePriority[$iIndex]][1])
		Else
			_GUICtrlSetImage($g_ahPicLabPriority[$iIndex], $g_sLibIconPath, $eIcnBlank)
		EndIf
	EndIf
EndFunc   ;==>cmbLabPriority

Func cmbStarLabPriority()
	Local $iCtrlId = @GUI_CtrlId
	Local $iIndex = -1
	For $i = 0 To 2
		$g_aiStarLabUpgradePriority[$i] = _GUICtrlComboBox_GetCurSel($g_ahCmbStarLabPriority[$i])
		If $g_ahCmbStarLabPriority[$i] = $iCtrlId Then $iIndex = $i
	Next
	; Update the specific icon
	If $iIndex >= 0 Then
		If $g_aiStarLabUpgradePriority[$iIndex] > 0 Then
			_GUICtrlSetImage($g_ahPicStarLabPriority[$iIndex], $g_sLibIconPath, $g_avStarLabTroops[$g_aiStarLabUpgradePriority[$iIndex]][4])
		Else
			_GUICtrlSetImage($g_ahPicStarLabPriority[$iIndex], $g_sLibIconPath, $eIcnBlank)
		EndIf
	EndIf
EndFunc   ;==>cmbStarLabPriority

Func ResetLabUpgradeTime()
	; Display are you sure message
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_07", "Are you 100% sure you want to reset lab upgrade timer?") & @CRLF & _
			GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_08", "Click OK to reset") & @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_09", "Or Click Cancel to exit") & @CRLF
	Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_10", "Reset timer") & "|" & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_11", "Cancel and Return"), _
			GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_12", "Reset laboratory upgrade timer?"), $stext, 120, $g_hFrmBot)
	If $g_bDebugSetLog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
	If $MsgBox = 1 Then
		$g_sLabUpgradeTime = ""
		_GUICtrlSetTip($g_hBtnResetLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	EndIf
	If _DateIsValid($g_sLabUpgradeTime) Then
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_HIDE)
		GUICtrlSetState($g_hBtnResetLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ResetLabUpgradeTime

Func ResetStarLabUpgradeTime()
	; Display are you sure message
	_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
	Local $stext = @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_07", "Are you 100% sure you want to reset lab upgrade timer?") & @CRLF & _
			GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_08", "Click OK to reset") & @CRLF & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_09", "Or Click Cancel to exit") & @CRLF
	Local $MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_10", "Reset timer") & "|" & GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_11", "Cancel and Return"), _
			GetTranslatedFileIni("MBR Func_Village_Upgrade", "Lab_GUIUpdate_Info_12", "Reset laboratory upgrade timer?"), $stext, 120, $g_hFrmBot)
	If $g_bDebugSetLog Then SetDebugLog("$MsgBox= " & $MsgBox, $COLOR_DEBUG)
	If $MsgBox = 1 Then
		$g_sStarLabUpgradeTime = ""
		_GUICtrlSetTip($g_hBtnResetStarLabUpgradeTime, GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_01", "Visible Red button means that laboratory upgrade in process") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_02", "This will automatically disappear when near time for upgrade to be completed.") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_03", "If upgrade has been manually finished with gems before normal end time,") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_04", "Click red button to reset internal upgrade timer BEFORE STARTING NEW UPGRADE") & @CRLF & _
				GetTranslatedFileIni("MBR Func_Village_Upgrade", "BtnResetLabUpgradeTime_Info_05", "Caution - Unnecessary timer reset will force constant checks for lab status"))
	EndIf
	If _DateIsValid($g_sStarLabUpgradeTime) Then
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_SHOW)
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_HIDE)
		GUICtrlSetState($g_hBtnResetStarLabUpgradeTime, $GUI_DISABLE)
	EndIf
EndFunc   ;==>ResetStarLabUpgradeTime


Func chkUpgradeKing()
	Local $ahGroupKingWait[4] = [$g_hChkDBKingWait, $g_hChkABKingWait, $g_hPicDBKingWait, $g_hPicABKingWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtKingWait_Info_03", "ATTENTION: King auto upgrade is currently enable.")
	If $g_iTownHallLevel > 6 Then ; Must be TH7 or above to have King
		GUICtrlSetState($g_hChkUpgradeKing, $GUI_ENABLE)

		If GUICtrlRead($g_hChkUpgradeKing) = $GUI_CHECKED Then
			$g_bUpgradeKingEnable = True
			For $i In $ahGroupKingWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeKingEnable = False
			_GUI_Value_STATE("HIDE", $groupKingSleeping)
			For $i In $ahGroupKingWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeKing, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		$g_bUpgradeKingEnable = False
		_GUI_Value_STATE("HIDE", $groupKingSleeping)
		For $i In $ahGroupKingWait
			_GUICtrlSetTip($i, $TxtTip)
		Next
	EndIf
EndFunc   ;==>chkUpgradeKing

Func chkUpgradeQueen()
	Local $ahGroupQueenWait[4] = [$g_hChkDBQueenWait, $g_hChkABQueenWait, $g_hPicDBQueenWait, $g_hPicABQueenWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtQueenWait_Info_03", "ATTENTION: Queen auto upgrade is currently enable.")
	If $g_iTownHallLevel > 7 Then ; Must be TH8 or above to have Queen
		GUICtrlSetState($g_hChkUpgradeQueen, $GUI_ENABLE)

		If GUICtrlRead($g_hChkUpgradeQueen) = $GUI_CHECKED Then
			$g_bUpgradeQueenEnable = True
			For $i In $ahGroupQueenWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeQueenEnable = False
			_GUI_Value_STATE("HIDE", $groupQueenSleeping)
			For $i In $ahGroupQueenWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeQueen, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		$g_bUpgradeQueenEnable = False
		_GUI_Value_STATE("HIDE", $groupQueenSleeping)
		For $i In $ahGroupQueenWait
			_GUICtrlSetTip($i, $TxtTip)
		Next
	EndIf
EndFunc   ;==>chkUpgradeQueen

Func chkUpgradePrince()
	Local $ahGroupPrinceWait[4] = [$g_hChkDBPrinceWait, $g_hChkABPrinceWait, $g_hPicDBPrinceWait, $g_hPicABPrinceWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtPrinceWait_Info_03", "ATTENTION: Prince auto upgrade is currently enable.")
	If $g_iTownHallLevel > 8 Then ; Must be TH9 or above to have Prince
		GUICtrlSetState($g_hChkUpgradePrince, $GUI_ENABLE)

		If GUICtrlRead($g_hChkUpgradePrince) = $GUI_CHECKED Then
			$g_bUpgradePrinceEnable = True
			For $i In $ahGroupPrinceWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradePrinceEnable = False
			_GUI_Value_STATE("HIDE", $groupPrinceSleeping)
			For $i In $ahGroupPrinceWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradePrince, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		$g_bUpgradePrinceEnable = False
		_GUI_Value_STATE("HIDE", $groupPrinceSleeping)
		For $i In $ahGroupPrinceWait
			_GUICtrlSetTip($i, $TxtTip)
		Next
	EndIf
EndFunc   ;==>chkUpgradePrince

Func chkUpgradeWarden()
	Local $ahGroupWardenWait[4] = [$g_hChkDBWardenWait, $g_hChkABWardenWait, $g_hPicDBWardenWait, $g_hPicABWardenWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtWardenWait_Info_03", "ATTENTION: Warden auto upgrade is currently enable.")
	If $g_iTownHallLevel > 10 Then ; Must be TH11 to have warden
		GUICtrlSetState($g_hChkUpgradeWarden, $GUI_ENABLE)

		If GUICtrlRead($g_hChkUpgradeWarden) = $GUI_CHECKED Then
			$g_bUpgradeWardenEnable = True
			For $i In $ahGroupWardenWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeWardenEnable = False
			_GUI_Value_STATE("HIDE", $groupWardenSleeping)
			For $i In $ahGroupWardenWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeWarden, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		$g_bUpgradeWardenEnable = False
		_GUI_Value_STATE("HIDE", $groupWardenSleeping)
		For $i In $ahGroupWardenWait
			_GUICtrlSetTip($i, $TxtTip)
		Next
	EndIf
EndFunc   ;==>chkUpgradeWarden

Func chkUpgradeChampion()
	Local $ahGroupChampionWait[4] = [$g_hChkDBChampionWait, $g_hChkABChampionWait, $g_hPicDBChampionWait, $g_hPicABChampionWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtChampionWait_Info_03", "ATTENTION: Champion auto upgrade is currently enable.")
	If $g_iTownHallLevel > 12 Then ; Must be TH13 to have Champion
		GUICtrlSetState($g_hChkUpgradeChampion, $GUI_ENABLE)

		If GUICtrlRead($g_hChkUpgradeChampion) = $GUI_CHECKED Then
			$g_bUpgradeChampionEnable = True
			For $i In $ahGroupChampionWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeChampionEnable = False
			_GUI_Value_STATE("HIDE", $groupChampionSleeping)
			For $i In $ahGroupChampionWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeChampion, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		$g_bUpgradeChampionEnable = False
		_GUI_Value_STATE("HIDE", $groupChampionSleeping)
		For $i In $ahGroupChampionWait
			_GUICtrlSetTip($i, $TxtTip)
		Next
	EndIf
EndFunc   ;==>chkUpgradeChampion

Func chkUpgradeDuke()
	Local $ahGroupDukeWait[1] = [$g_hPicChkDukeSleepWait]
	Local $TxtTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtDukeWait_Info_01", -1) & @CRLF & _
			GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtDukeWait_Info_02", -1)
	Local $TxtWarningTip = GetTranslatedFileIni("MBR GUI Design Child Attack - Search", "TxtDukeWait_Info_03", "ATTENTION: Dragon Duke auto upgrade is currently enable.")
	If $g_iTownHallLevel >= 15 Then ; Must be TH15 to have Dragon Duke
		If GUICtrlRead($g_hChkUpgradeDuke) = $GUI_CHECKED Then
			$g_bUpgradeDukeEnable = True
			For $i In $ahGroupDukeWait
				_GUICtrlSetTip($i, $TxtTip & @CRLF & $TxtWarningTip)
			Next
		Else
			$g_bUpgradeDukeEnable = False
			_GUI_Value_STATE("HIDE", $groupDukeSleeping)
			For $i In $ahGroupDukeWait
				_GUICtrlSetTip($i, $TxtTip)
			Next
		EndIf
	Else
		GUICtrlSetState($g_hChkUpgradeDuke, BitOR($GUI_DISABLE, $GUI_UNCHECKED))
		$g_bUpgradeDukeEnable = False
		_GUI_Value_STATE("HIDE", $groupDukeSleeping)
		For $i In $ahGroupDukeWait
			_GUICtrlSetTip($i, $TxtTip)
		Next
	EndIf
EndFunc   ;==>chkUpgradeDuke

Func chkUpgradePets()
	If $g_iTownHallLevel = 14 Then ; Must be TH14 to have Pets 1->4
		For $i = 0 To $ePetCount - 8
			GUICtrlSetState($g_hChkUpgradePets[$i], $GUI_ENABLE)
			If GUICtrlRead($g_hChkUpgradePets[$i]) = $GUI_CHECKED Then
				$g_bUpgradePetsEnable[$i] = True
				SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " enabled")
			Else
				$g_bUpgradePetsEnable[$i] = False
				SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " disabled")
			EndIf
		Next
		For $i = $ePetCount - 7 To $ePetCount - 1
			GUICtrlSetState($g_hChkUpgradePets[$i], $GUI_DISABLE + $GUI_UNCHECKED)
			$g_bUpgradePetsEnable[$i] = False
			SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " disabled")
		Next
	ElseIf $g_iTownHallLevel = 15 Then ; TH15 : Pets 1->8
		For $i = 0 To $ePetCount - 4
			GUICtrlSetState($g_hChkUpgradePets[$i], $GUI_ENABLE)
			If GUICtrlRead($g_hChkUpgradePets[$i]) = $GUI_CHECKED Then
				$g_bUpgradePetsEnable[$i] = True
				SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " enabled")
			Else
				$g_bUpgradePetsEnable[$i] = False
				SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " disabled")
			EndIf
		Next
		For $i = $ePetCount - 3 To $ePetCount - 1
			GUICtrlSetState($g_hChkUpgradePets[$i], $GUI_DISABLE + $GUI_UNCHECKED)
			$g_bUpgradePetsEnable[$i] = False
			SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " disabled")
		Next
	ElseIf $g_iTownHallLevel = 16 Then ; TH16 : Pets 1->10
		For $i = 0 To $ePetSneezy - 1
			GUICtrlSetState($g_hChkUpgradePets[$i], $GUI_ENABLE)
			If GUICtrlRead($g_hChkUpgradePets[$i]) = $GUI_CHECKED Then
				$g_bUpgradePetsEnable[$i] = True
				SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " enabled")
			Else
				$g_bUpgradePetsEnable[$i] = False
				SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " disabled")
			EndIf
		Next
		For $i = $ePetSneezy To $ePetCount - 1
			GUICtrlSetState($g_hChkUpgradePets[$i], $GUI_DISABLE + $GUI_UNCHECKED)
			$g_bUpgradePetsEnable[$i] = False
			SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " disabled")
		Next
	ElseIf $g_iTownHallLevel >= 17 Then ; TH17 : Pets 1->11
 		For $i = 0 To $ePetCount - 1
 			GUICtrlSetState($g_hChkUpgradePets[$i], $GUI_ENABLE)
 			If GUICtrlRead($g_hChkUpgradePets[$i]) = $GUI_CHECKED Then
				$g_bUpgradePetsEnable[$i] = True
				SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " enabled")
			Else
				$g_bUpgradePetsEnable[$i] = False
				SetDebugLog("Upgrade: " & $g_asPetNames[$i] & " disabled")
			EndIf
		Next
	Else
		For $i = 0 To $ePetCount - 1
			GUICtrlSetState($g_hChkUpgradePets[$i], $GUI_DISABLE + $GUI_UNCHECKED)
			$g_bUpgradePetsEnable[$i] = False
		Next
	EndIf
EndFunc   ;==>chkUpgradePets


Func cmbHeroReservedBuilder()
	$g_iHeroReservedBuilder = _GUICtrlComboBox_GetCurSel($g_hCmbHeroReservedBuilder)
	If $g_iTownHallLevel > 6 Then ; Must be TH7 or above to have Heroes
		If $g_iTownHallLevel > 12 Then ; For TH13 enable up to 6 reserved builders
			If $g_aiHeroHallPos[2] > 5 Then GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2|3|4|5|6", "0")
		ElseIf $g_iTownHallLevel > 10 Then ; For TH13 enable up to 4 reserved builders
			If $g_aiHeroHallPos[2] > 4 Then GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2|3|4", "0")
		ElseIf $g_iTownHallLevel > 8 Then ; For TH9 enable up to 3 reserved builders
			If $g_aiHeroHallPos[2] > 2 Then GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2|3", "0")
		ElseIf $g_iTownHallLevel > 7 Then ; For TH8 enable up to 2 reserved builders
			If $g_aiHeroHallPos[2] > 1 Then GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1|2", "0")
		Else ; For TH7 enable up to 1 reserved builder
			GUICtrlSetData($g_hCmbHeroReservedBuilder, "|0|1", "0")
		EndIf
		GUICtrlSetState($g_hCmbHeroReservedBuilder, $GUI_ENABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderTop, $GUI_ENABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderBottom, $GUI_ENABLE)
	Else
		GUICtrlSetState($g_hCmbHeroReservedBuilder, $GUI_DISABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderTop, $GUI_DISABLE)
		GUICtrlSetState($g_hLblHeroReservedBuilderBottom, $GUI_DISABLE)
	EndIf
	_GUICtrlComboBox_SetCurSel($g_hCmbHeroReservedBuilder, $g_iHeroReservedBuilder)
EndFunc   ;==>cmbHeroReservedBuilder

Func ReducecmbHeroReservedBuilder()
	Local $IsToUpNrbHeroes = 0
	Local $CheckedHeroes[6] = [$g_bUpgradeKingEnable, $g_bUpgradeQueenEnable, $g_bUpgradePrinceEnable, $g_bUpgradeWardenEnable, $g_bUpgradeChampionEnable, $g_bUpgradeDukeEnable]
	For $i = 0 To UBound($CheckedHeroes) - 1
		If $CheckedHeroes[$i] Then $IsToUpNrbHeroes += 1
	Next
	If $g_iHeroReservedBuilder > $IsToUpNrbHeroes Then
		SetLog("Reduce Reserved Builder" & ($IsToUpNrbHeroes > 1 ? "s To " : " To ") & $IsToUpNrbHeroes, $COLOR_ACTION)
		$g_iHeroReservedBuilder = $IsToUpNrbHeroes
		_GUICtrlComboBox_SetCurSel($g_hCmbHeroReservedBuilder, $g_iHeroReservedBuilder)
	EndIf
EndFunc   ;==>ReducecmbHeroReservedBuilder

Func EnableUpgradeEquipment()
	If $g_iTownHallLevel < 8 Then
		GUICtrlSetState($g_hBtnHeroEquipment, $GUI_DISABLE)
		GUICtrlSetState($g_hChkCustomEquipmentOrderEnable, $GUI_UNCHECKED)
		GUICtrlSetState($g_hChkFinishCurrentEquipmentFirst, $GUI_UNCHECKED)
		btnRemoveEquipment()
	Else
		GUICtrlSetState($g_hBtnHeroEquipment, $GUI_ENABLE)
	EndIf
EndFunc   ;==>EnableUpgradeEquipment

Func BtnHeroEquipment()
	GUISetState(@SW_SHOW, $g_hGUI_HeroEquipment)
EndFunc   ;==>BtnHeroEquipment

Func CloseHeroEquipment()
	GUISetState(@SW_HIDE, $g_hGUI_HeroEquipment)
EndFunc   ;==>CloseHeroEquipment

Func chkEquipmentOrder()
	If GUICtrlRead($g_hChkCustomEquipmentOrderEnable) = $GUI_CHECKED Then
		For $i = $g_hChkFinishCurrentEquipmentFirst To $g_ahImgEquipmentOrderSet
			GUICtrlSetState($i, $GUI_ENABLE)
		Next
	Else
		For $i = $g_hChkFinishCurrentEquipmentFirst To $g_ahImgEquipmentOrderSet
			GUICtrlSetState($i, $GUI_DISABLE)
		Next
	EndIf
EndFunc   ;==>chkEquipmentOrder

Func GUIRoyalEquipmentOrder()
	Local $bDuplicate = False
	Local $iGUI_CtrlId = @GUI_CtrlId
	Local $iCtrlIdImage = $iGUI_CtrlId + 1
	Local $iCtrlIdImage2 = $iGUI_CtrlId + 2
	Local $iEquipmentIndex = _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) + 1

	If $iEquipmentIndex < UBound($g_ahCmbEquipmentOrder) + 1 Then
		_GUICtrlSetImage($iCtrlIdImage, $g_sLibIconPath, $g_aiEquipmentOrderIcon[$iEquipmentIndex][0]) ; set proper equipment icon
		_GUICtrlSetImage($iCtrlIdImage2, $g_sLibIconPath, $g_aiEquipmentOrderIcon[$iEquipmentIndex][1]) ; set proper hero icon
	EndIf

	For $i = 0 To UBound($g_ahCmbEquipmentOrder) - 1 ; check for duplicate combobox index and flag problem
		If $iGUI_CtrlId = $g_ahCmbEquipmentOrder[$i] Then ContinueLoop
		If _GUICtrlComboBox_GetCurSel($iGUI_CtrlId) = _GUICtrlComboBox_GetCurSel($g_ahCmbEquipmentOrder[$i]) Then
			GUICtrlSetState($g_hChkCustomEquipmentOrder[$i], $GUI_UNCHECKED)
			_GUICtrlSetImage($g_ahImgEquipmentOrder[$i], $g_sLibIconPath, $eIcnOptions)
			_GUICtrlSetImage($g_ahImgEquipmentOrder2[$i], $g_sLibIconPath, $eIcnOptions)
			_GUICtrlComboBox_SetCurSel($g_ahCmbEquipmentOrder[$i], -1)
			GUISetState()
			$bDuplicate = True
		EndIf
	Next
	If $bDuplicate Then
		GUICtrlSetState($g_hBtnEquipmentOrderSet, $GUI_ENABLE) ; enable button to apply new order
		_GUICtrlSetImage($g_ahImgEquipmentOrderSet, $g_sLibIconPath, $eIcnRedLight) ; set status indicator to show need to apply new order
		Return
	Else
		GUICtrlSetState($g_hBtnEquipmentOrderSet, $GUI_ENABLE) ; enable button to apply new order
	EndIf
EndFunc   ;==>GUIRoyalEquipmentOrder

Func btnRemoveEquipment()
	Local $sComboData = ""
	For $j = 0 To UBound($g_asEquipmentOrderList) - 1
		$sComboData &= $g_asEquipmentOrderList[$j][0] & "|"
	Next
	For $i = 0 To UBound($g_ahCmbEquipmentOrder) - 1
		$g_aiCmbCustomEquipmentOrder[$i] = -1
		$g_bChkCustomEquipmentOrder[$i] = 0
		_GUICtrlComboBox_ResetContent($g_ahCmbEquipmentOrder[$i])
		GUICtrlSetState($g_hChkCustomEquipmentOrder[$i], $GUI_UNCHECKED)
		GUICtrlSetData($g_ahCmbEquipmentOrder[$i], $sComboData, "")
		GUICtrlSetState($g_ahCmbEquipmentOrder[$i], $GUI_ENABLE)
		_GUICtrlSetImage($g_ahImgEquipmentOrder[$i], $g_sLibIconPath, $eIcnOptions)
		_GUICtrlSetImage($g_ahImgEquipmentOrder2[$i], $g_sLibIconPath, $eIcnOptions)
	Next
	GUICtrlSetState($g_hBtnEquipmentOrderSet, $GUI_DISABLE)
	_GUICtrlSetImage($g_ahImgEquipmentOrderSet, $g_sLibIconPath, $eIcnSilverStar)
	SetDefaultEquipmentGroup(False)
EndFunc   ;==>btnRemoveEquipment

Func SetDefaultEquipmentGroup($bSetLog = True)
	For $i = 0 To $eEquipmentCount - 1
		$g_aiEquipmentOrder[$i] = $i
	Next
EndFunc   ;==>SetDefaultEquipmentGroup

Func btnEquipmentOrderSet()
	Local $bWasRedraw = SetRedrawBotWindow(False, Default, Default, Default, "btnEquipmentOrderSet")
	Local $bReady = True ; Initialize ready to record troop order flag
	Local $sNewEquipmentList = ""

	Local $aiUsedEquipment = $g_aiEquipmentOrder
	Local $aTmpEquipmentOrder[0], $iStartShuffle = 0

	For $i = 0 To UBound($g_ahCmbEquipmentOrder) - 1
		Local $iValue = _GUICtrlComboBox_GetCurSel($g_ahCmbEquipmentOrder[$i])
		If $iValue <> -1 Then
			_ArrayAdd($aTmpEquipmentOrder, $iValue)
			Local $iEmpty = _ArraySearch($aiUsedEquipment, $iValue)
			If $iEmpty > -1 Then $aiUsedEquipment[$iEmpty] = -1
		EndIf
	Next

	$iStartShuffle = UBound($aTmpEquipmentOrder)

	_ArraySort($aiUsedEquipment)

	For $i = 0 To UBound($aTmpEquipmentOrder) - 1
		If $aiUsedEquipment[$i] = -1 Then $aiUsedEquipment[$i] = $aTmpEquipmentOrder[$i]
	Next

	_ArrayShuffle($aiUsedEquipment, $iStartShuffle)

	For $i = 0 To UBound($g_ahCmbEquipmentOrder) - 1
		GUICtrlSetState($g_ahCmbEquipmentOrder[$i], $GUI_ENABLE)
		_GUICtrlComboBox_SetCurSel($g_ahCmbEquipmentOrder[$i], $aiUsedEquipment[$i])
		_GUICtrlSetImage($g_ahImgEquipmentOrder[$i], $g_sLibIconPath, $g_aiEquipmentOrderIcon[$aiUsedEquipment[$i] + 1][0])
		_GUICtrlSetImage($g_ahImgEquipmentOrder2[$i], $g_sLibIconPath, $g_aiEquipmentOrderIcon[$aiUsedEquipment[$i] + 1][1])
	Next

	$g_aiCmbCustomEquipmentOrder = $aiUsedEquipment
	If $bReady Then
		ChangeEquipmentOrder() ; code function to record new order
		If @error Then
			Switch @error
				Case 1
					SetLog("Code problem, can not continue till fixed!", $COLOR_ERROR)
				Case 2
					SetLog("Bad Combobox selections, please fix!", $COLOR_ERROR)
				Case 3
					SetLog("Unable to Change Equipment Upgrade Order due bad change count!", $COLOR_ERROR)
				Case Else
					SetLog("Monkey ate bad banana, something wrong with ChangeEquipmentOrder() code!", $COLOR_ERROR)
			EndSwitch
			_GUICtrlSetImage($g_ahImgEquipmentOrderSet, $g_sLibIconPath, $eIcnRedLight)
		Else
			SetLog("Equipment upgrade order changed successfully!", $COLOR_SUCCESS)
			Local $iEquipmentLogCount = 0
			For $i = 0 To $eEquipmentCount - 1
				If GUICtrlRead($g_hChkCustomEquipmentOrder[$i]) <> $GUI_CHECKED Then ContinueLoop
				$sNewEquipmentList &= $g_asEquipmentOrderList[$aiUsedEquipment[$i]][0] & ", "
				$iEquipmentLogCount += 1
				If $iEquipmentLogCount = 10 Then ExitLoop
			Next

			If $sNewEquipmentList = "" Then
				For $i = 0 To $eEquipmentCount - 1
					$sNewEquipmentList &= $g_asEquipmentOrderList[$aiUsedEquipment[$i]][0] & ", "
					$iEquipmentLogCount += 1
					If $iEquipmentLogCount = 10 Then ExitLoop
				Next
			EndIf

			$sNewEquipmentList = StringTrimRight($sNewEquipmentList, 2)
			SetLog("Equipment Order: " & $sNewEquipmentList, $COLOR_INFO)
		EndIf
	Else
		SetLog("Must use all Equipment and No duplicate equipment names!", $COLOR_ERROR)
		_GUICtrlSetImage($g_ahImgEquipmentOrderSet, $g_sLibIconPath, $eIcnRedLight)
	EndIf
	SetRedrawBotWindow($bWasRedraw, Default, Default, Default, "btnEquipmentOrderSet")
EndFunc   ;==>btnEquipmentOrderSet

Func ChangeEquipmentOrder()
	Local $iUpdateCount = 0, $aUnique

	If Not IsUseCustomEquipmentOrder() Then ; check if no custom values saved yet.
		SetError(2, 0, False)
		Return
	EndIf

	$aUnique = _ArrayUnique($g_aiCmbCustomEquipmentOrder, 0, 0, 0, 0)
	$iUpdateCount = UBound($aUnique)

	If $iUpdateCount = $eEquipmentCount Then ; safety check that all troops properly assigned to new array.
		$g_aiEquipmentOrder = $aUnique
		_GUICtrlSetImage($g_ahImgEquipmentOrderSet, $g_sLibIconPath, $eIcnGreenLight)
	Else
		SetLog($iUpdateCount & "|" & $eEquipmentCount & " - Error - Bad equipment assignment in ChangeEquipmentOrder()", $COLOR_ERROR)
		SetError(3, 0, False)
		Return
	EndIf

	Return True
EndFunc   ;==>ChangeEquipmentOrder

Func IsUseCustomEquipmentOrder()
	For $i = 0 To UBound($g_aiCmbCustomEquipmentOrder) - 1 ; Check if custom order has been used, to select log message
		If $g_aiCmbCustomEquipmentOrder[$i] = -1 Then Return False
	Next
	Return True
EndFunc   ;==>IsUseCustomEquipmentOrder

Func chkWalls()
	If GUICtrlRead($g_hChkWalls) = $GUI_CHECKED Then
		$g_bAutoUpgradeWallsEnable = True
		GUICtrlSetState($g_hRdoUseGold, $GUI_ENABLE)
		GUICtrlSetState($g_hRdoUseElixir, $GUI_ENABLE)
		GUICtrlSetState($g_hRdoUseElixirGold, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbWalls, $GUI_ENABLE)
		GUICtrlSetState($g_hCmbUpgradeWallStorageLimit, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtWallMinGold, $GUI_ENABLE)
		GUICtrlSetState($g_hTxtWallMinElixir, $GUI_ENABLE)
		cmbWalls()
	Else
		$g_bAutoUpgradeWallsEnable = False
		GUICtrlSetState($g_hRdoUseGold, $GUI_DISABLE)
		GUICtrlSetState($g_hRdoUseElixir, $GUI_DISABLE)
		GUICtrlSetState($g_hRdoUseElixirGold, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbWalls, $GUI_DISABLE)
		GUICtrlSetState($g_hCmbUpgradeWallStorageLimit, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtWallMinGold, $GUI_DISABLE)
		GUICtrlSetState($g_hTxtWallMinElixir, $GUI_DISABLE)
	EndIf
EndFunc   ;==>chkWalls

; #FUNCTION# ===========================================================================================================
; Name ..........: chkWallHammerJam
; Description ...: Selects the half-price Wall cost table and refreshes the displayed cost.
; ======================================================================================================================
Func chkWallHammerJam()
	$g_bWallHammerJam = (GUICtrlRead($g_hChkWallHammerJam) = $GUI_CHECKED)
	cmbWalls()
EndFunc

Func chkSaveWallBldr()
	$g_bUpgradeWallSaveBuilder = (GUICtrlRead($g_hChkSaveWallBldr) = $GUI_CHECKED)
EndFunc   ;==>chkSaveWallBldr

Func cmbUpgradeWallStorageLimit()
	$g_iCmbUpgradeWallStorageLimit = _GUICtrlComboBox_GetCurSel($g_hCmbUpgradeWallStorageLimit)
	If $g_iCmbUpgradeWallStorageLimit < 0 Or $g_iCmbUpgradeWallStorageLimit > 2 Then $g_iCmbUpgradeWallStorageLimit = 1
	SetDebugLog("Wall Storage Limit: " & UpgradeWallStorageLimitPercent() & "%", $COLOR_DEBUG)
EndFunc   ;==>cmbUpgradeWallStorageLimit

Func cmbWalls()
	$g_iCmbUpgradeWallsLevel = _GUICtrlComboBox_GetCurSel($g_hCmbWalls)
	GUICtrlSetData($g_hLblWallCost, _NumberFormat(UpgradeWallCurrentCost()))

	For $i = 4 To $g_iCmbUpgradeWallsLevel + 5
		GUICtrlSetState($g_ahWallsCurrentCount[$i], $GUI_SHOW)
		GUICtrlSetState($g_ahPicWallsLevel[$i], $GUI_SHOW)
	Next

	For $i = $g_iCmbUpgradeWallsLevel + 6 To 19
		GUICtrlSetState($g_ahWallsCurrentCount[$i], $GUI_HIDE)
		GUICtrlSetState($g_ahPicWallsLevel[$i], $GUI_HIDE)
	Next
EndFunc   ;==>cmbWalls

Func btnWalls()
	Local $wasRunState = $g_bRunState
	$g_bRunState = True
	ZoomOut()
	$g_iCmbUpgradeWallsLevel = _GUICtrlComboBox_GetCurSel($g_hCmbWalls)
	If imglocCheckWall() Then SetLog("Hey Chef! We found the Wall!")
	$g_bRunState = $wasRunState
	AndroidShield("btnWalls") ; Update shield status due to manual $g_bRunState
EndFunc   ;==>btnWalls

Func btnResetWallCounter()
	For $i = 4 To 19
		$g_aiWallsCurrentCount[$i] = 0
		GUICtrlSetData($g_ahWallsCurrentCount[$i], 0)
	Next
	SaveConfig()
	SetLog("Wall Counters Reset", $COLOR_SUCCESS)
EndFunc   ;==>btnResetWallCounter

Func chkAutoUpgrade()
	$g_bAutoUpgradeEnabled = (GUICtrlRead($g_hChkAutoUpgrade) = $GUI_CHECKED)
	Local $aControls[5] = [$g_hCmbAutoUpgradeResource, $g_hCmbAutoUpgradeType, $g_hCmbAutoUpgradeSorting, $g_hPicAutoUpgradeResource, $g_hPicAutoUpgradeType]
	_AutoUpgradeSetFilterControls($g_bAutoUpgradeEnabled, $aControls)
	Local $aSortingIcon[1] = [$g_hPicAutoUpgradeSorting]
	_AutoUpgradeSetFilterControls($g_bAutoUpgradeEnabled, $aSortingIcon)
EndFunc   ;==>chkAutoUpgrade

Func chkAutoLabUpgrade()
	$g_bAutoLabUpgradeAutoEnabled = (GUICtrlRead($g_hChkAutoLabUpgrade) = $GUI_CHECKED)
	Local $aControls[6] = [$g_hCmbAutoLabUpgradeResource, $g_hCmbAutoLabUpgradeType, $g_hCmbAutoLabUpgradeSorting, $g_hPicAutoLabUpgradeResource, $g_hPicAutoLabUpgradeType, $g_hPicAutoLabUpgradeSorting]
	_AutoUpgradeSetFilterControls($g_bAutoLabUpgradeAutoEnabled, $aControls)
EndFunc   ;==>chkAutoLabUpgrade

Func chkAutoUpgradeBB()
	$g_bAutoUpgradeBBEnabled = (GUICtrlRead($g_hChkAutoUpgradeBB) = $GUI_CHECKED)
	Local $aControls[6] = [$g_hCmbAutoUpgradeBBResource, $g_hCmbAutoUpgradeBBType, $g_hCmbAutoUpgradeBBSorting, $g_hPicAutoUpgradeBBResource, $g_hPicAutoUpgradeBBType, $g_hPicAutoUpgradeBBSorting]
	_AutoUpgradeSetFilterControls($g_bAutoUpgradeBBEnabled, $aControls)
EndFunc   ;==>chkAutoUpgradeBB

Func chkAutoStarUpgradeBB()
	$g_bAutoStarUpgradeBBEnabled = (GUICtrlRead($g_hChkAutoStarUpgradeBB) = $GUI_CHECKED)
	Local $aControls[2] = [$g_hCmbAutoLabUpgradeBBSorting, $g_hPicAutoLabUpgradeBBSorting]
	_AutoUpgradeSetFilterControls($g_bAutoStarUpgradeBBEnabled, $aControls)
EndFunc   ;==>chkAutoStarUpgradeBB

Func _AutoUpgradeSetFilterControls($bEnabled, ByRef $aControls)
	Local $iControlState = $bEnabled ? $GUI_ENABLE : $GUI_DISABLE
	For $i = 0 To UBound($aControls) - 1
		GUICtrlSetState($aControls[$i], $iControlState)
	Next
EndFunc   ;==>_AutoUpgradeSetFilterControls

Func cmbAutoUpgradeResource()
	Local $iResource = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeResource)
	Local $iIcon = -1
	Switch $iResource
		Case 1
			$iIcon = $eIcnGold
		Case 2
			$iIcon = $eIcnElixir
		Case 3
			$iIcon = $eIcnDark
	EndSwitch
	_AutoUpgradeSetFilterIcon($g_hPicAutoUpgradeResource, $iIcon)
EndFunc   ;==>cmbAutoUpgradeResource

Func cmbAutoLabUpgradeResource()
	Local $iResource = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeResource)
	Local $iIcon = -1
	Switch $iResource
		Case 1
			$iIcon = $eIcnElixir
		Case 2
			$iIcon = $eIcnDark
	EndSwitch
	_AutoUpgradeSetFilterIcon($g_hPicAutoLabUpgradeResource, $iIcon)
EndFunc   ;==>cmbAutoLabUpgradeResource

Func cmbAutoUpgradeType()
	Local $iType = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeType)
	Local $iIcon = -1
	Switch $iType
		Case 1
			$iIcon = $eIcnBarrack
		Case 2
			$iIcon = $eIcnRicochetCannon
		Case 3
			$iIcon = $eIcnHeroHall
		Case 4
			$iIcon = $eIcnDrill
		Case 5
			$iIcon = $eIcnTH18
	EndSwitch
	_AutoUpgradeSetFilterIcon($g_hPicAutoUpgradeType, $iIcon)
EndFunc   ;==>cmbAutoUpgradeType

Func cmbAutoUpgradeBBType()
	Local $iType = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeBBType)
	Local $iIcon = -1
	Switch $iType
		Case 1
			$iIcon = $eIcnBuilderBarrack
		Case 2
			$iIcon = $eIcnMultiMortar8
		Case 3
			$iIcon = $eIcnBattleMachine
		Case 4
			$iIcon = $eIcnGemMine
		Case 5
			$iIcon = $eIcnBuilderHall
	EndSwitch
	_AutoUpgradeSetFilterIcon($g_hPicAutoUpgradeBBType, $iIcon)
EndFunc   ;==>cmbAutoUpgradeBBType

Func cmbAutoUpgradeSorting()
	_AutoUpgradeSetFilterIconVisibility($g_hCmbAutoUpgradeSorting, $g_hPicAutoUpgradeSorting)
EndFunc   ;==>cmbAutoUpgradeSorting

Func cmbAutoLabUpgradeSorting()
	_AutoUpgradeSetFilterIconVisibility($g_hCmbAutoLabUpgradeSorting, $g_hPicAutoLabUpgradeSorting)
EndFunc   ;==>cmbAutoLabUpgradeSorting

Func cmbAutoUpgradeBBSorting()
	_AutoUpgradeSetFilterIconVisibility($g_hCmbAutoUpgradeBBSorting, $g_hPicAutoUpgradeBBSorting)
EndFunc   ;==>cmbAutoUpgradeBBSorting

Func cmbAutoLabUpgradeBBSorting()
	_AutoUpgradeSetFilterIconVisibility($g_hCmbAutoLabUpgradeBBSorting, $g_hPicAutoLabUpgradeBBSorting)
EndFunc   ;==>cmbAutoLabUpgradeBBSorting

Func cmbAutoLabUpgradeType()
	Local $iType = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeType)
	Local $iIcon = -1
	Switch $iType
		Case 1
			$iIcon = _AutoUpgradeGetRandomTroopIcon()
		Case 2
			$iIcon = $g_aSpellsIcon[Random(0, UBound($g_aSpellsIcon) - 1, 1)]
		Case 3
			$iIcon = $g_aSiegesIcon[Random(0, UBound($g_aSiegesIcon) - 1, 1)]
	EndSwitch
	_AutoUpgradeSetFilterIcon($g_hPicAutoLabUpgradeType, $iIcon)
EndFunc   ;==>cmbAutoLabUpgradeType

Func _AutoUpgradeGetRandomTroopIcon()
	Local $aTroopIcons[$eTroopDebtCollector], $iCount = 0, $bSuper
	For $i = 0 To $eTroopDebtCollector - 1
		$bSuper = False
		For $j = 0 To $iSuperTroopsCount - 1
			If $i = $g_asSuperTroopIndex[$j] Then
				$bSuper = True
				ExitLoop
			EndIf
		Next
		If Not $bSuper Then
			$aTroopIcons[$iCount] = $g_aTroopsIcon[$i]
			$iCount += 1
		EndIf
	Next
	If $iCount = 0 Then Return $eIcnBarbarian
	Return $aTroopIcons[Random(0, $iCount - 1, 1)]
EndFunc   ;==>_AutoUpgradeGetRandomTroopIcon

Func cmbAutoUpgradeBBResource()
	Local $iResource = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeBBResource)
	Local $iIcon = -1
	Switch $iResource
		Case 1
			$iIcon = $eIcnBBGold
		Case 2
			$iIcon = $eIcnBBElix
	EndSwitch
	_AutoUpgradeSetFilterIcon($g_hPicAutoUpgradeBBResource, $iIcon)
EndFunc   ;==>cmbAutoUpgradeBBResource

Func _AutoUpgradeSetFilterIcon($hIcon, $iIcon)
	If $iIcon < 0 Then
		GUICtrlSetState($hIcon, $GUI_HIDE)
		Return
	EndIf
	_GUICtrlSetImage($hIcon, $g_sLibIconPath, $iIcon)
	GUICtrlSetState($hIcon, $GUI_SHOW)
EndFunc   ;==>_AutoUpgradeSetFilterIcon

Func _AutoUpgradeSetFilterIconVisibility($hCombo, $hIcon)
	If _GUICtrlComboBox_GetCurSel($hCombo) = 0 Then
		GUICtrlSetState($hIcon, $GUI_HIDE)
	Else
		GUICtrlSetState($hIcon, $GUI_SHOW)
	EndIf
EndFunc   ;==>_AutoUpgradeSetFilterIconVisibility

Func UpgradeHeroesSelectAll()
	Local $aHeroCheckboxes[6] = [$g_hChkUpgradeKing, $g_hChkUpgradeQueen, $g_hChkUpgradePrince, $g_hChkUpgradeWarden, $g_hChkUpgradeChampion, $g_hChkUpgradeDuke]
	For $i = 0 To UBound($aHeroCheckboxes) - 1
		$g_abUpgradeHeroMaxLevel[$i] = False
		If $aHeroCheckboxes[$i] <> 0 Then GUICtrlSetState($aHeroCheckboxes[$i], BitOR($GUI_ENABLE, $GUI_CHECKED))
	Next
	chkUpgradeKing()
	chkUpgradeQueen()
	chkUpgradePrince()
	chkUpgradeWarden()
	chkUpgradeChampion()
	chkUpgradeDuke()
	UpgradePetsSelectAll()
EndFunc   ;==>UpgradeHeroesSelectAll

Func UpgradeHeroesResetAll()
	Local $aHeroCheckboxes[6] = [$g_hChkUpgradeKing, $g_hChkUpgradeQueen, $g_hChkUpgradePrince, $g_hChkUpgradeWarden, $g_hChkUpgradeChampion, $g_hChkUpgradeDuke]
	For $i = 0 To UBound($aHeroCheckboxes) - 1
		$g_abUpgradeHeroMaxLevel[$i] = False
		If $aHeroCheckboxes[$i] <> 0 Then GUICtrlSetState($aHeroCheckboxes[$i], BitOR($GUI_ENABLE, $GUI_UNCHECKED))
	Next
	chkUpgradeKing()
	chkUpgradeQueen()
	chkUpgradePrince()
	chkUpgradeWarden()
	chkUpgradeChampion()
	chkUpgradeDuke()
	UpgradePetsResetAll()
EndFunc   ;==>UpgradeHeroesResetAll

Func UpgradePetsSelectAll()
	For $i = 0 To UBound($g_hChkUpgradePets) - 1
		$g_bPetMaxLevel[$i] = False
		If $g_hChkUpgradePets[$i] <> 0 Then GUICtrlSetState($g_hChkUpgradePets[$i], BitOR($GUI_ENABLE, $GUI_CHECKED))
	Next
	chkUpgradePets()
EndFunc   ;==>UpgradePetsSelectAll

Func UpgradePetsResetAll()
	For $i = 0 To UBound($g_hChkUpgradePets) - 1
		$g_bPetMaxLevel[$i] = False
		If $g_hChkUpgradePets[$i] <> 0 Then GUICtrlSetState($g_hChkUpgradePets[$i], BitOR($GUI_ENABLE, $GUI_UNCHECKED))
	Next
	chkUpgradePets()
EndFunc   ;==>UpgradePetsResetAll


; #FUNCTION# ===========================================================================================================
; Name ..........: chkAutoPetUpgrade
; Description ...: Updates the automatic Pet menu upgrade option.
; ======================================================================================================================
Func chkAutoPetUpgrade()
	$g_bAutoPetUpgradeEnabled = (GUICtrlRead($g_hChkAutoPetUpgrade) = $GUI_CHECKED)
EndFunc
; #FUNCTION# ===========================================================================================================
; Name ..........: chkWallGoldPass
; Description ...: Enables the manual Gold Pass wall discount and updates the shown cost.
; ======================================================================================================================
Func chkWallGoldPass()
	$g_bWallGoldPass = (GUICtrlRead($g_hChkWallGoldPass) = $GUI_CHECKED)
	GUICtrlSetState($g_hCmbWallGoldPass, $g_bWallGoldPass ? $GUI_ENABLE : $GUI_DISABLE)
	cmbWallGoldPass()
EndFunc

; #FUNCTION# ===========================================================================================================
; Name ..........: cmbWallGoldPass
; Description ...: Selects the 10, 15 or 20 percent wall discount.
; ======================================================================================================================
Func cmbWallGoldPass()
	$g_iWallGoldPassDiscount = (_GUICtrlComboBox_GetCurSel($g_hCmbWallGoldPass) = 2 ? 20 : (_GUICtrlComboBox_GetCurSel($g_hCmbWallGoldPass) = 1 ? 15 : 10))
	cmbWalls()
EndFunc