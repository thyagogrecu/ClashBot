; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Attack Scripted
; Description ...: This file Includes all functions to current GUI
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: MyBot.run team
; Modified ......: CodeSlinger69 (2017), MMHK (01-2008)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once
#include "..\functions\Attack\DirectAttack.au3"

Global $g_hGUI_CSVShortNamesHelp = 0, $g_hRichEditCSVShortNamesHelp = 0

Func ShowCSVShortNamesHelp()
	If $g_hGUI_CSVShortNamesHelp And WinExists($g_hGUI_CSVShortNamesHelp) Then
		WinActivate($g_hGUI_CSVShortNamesHelp)
		Return
	EndIf

	UpdateBotTitle()
	Local Const $iWidth = 650, $iHeight = 650
	$g_hGUI_CSVShortNamesHelp = GUICreate($g_sBotTitle & " - CSV Unit Shortnames", $iWidth, $iHeight, -1, -1, _
			BitOR($WS_CAPTION, $WS_POPUPWINDOW, $WS_SIZEBOX), $WS_EX_TOPMOST, $g_hFrmBot)
	GUISetIcon($g_sLibIconPath, $eIcnGUI, $g_hGUI_CSVShortNamesHelp)
	GUISetBkColor(0xF4F6F8, $g_hGUI_CSVShortNamesHelp)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseCSVShortNamesHelp", $g_hGUI_CSVShortNamesHelp)

	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "LblCSVHelp_Title", "CSV Attack Unit Shortnames"), 20, 15, 610, 25)
	GUICtrlSetFont(-1, 12, $FW_BOLD, Default, "Arial")
	GUICtrlSetColor(-1, $COLOR_NAVY)
	GUICtrlCreateLabel(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "LblCSVHelp_Description", _
			"Use these exact, case-sensitive shortnames in TRAIN, CCSPL and DROP commands."), 20, 42, 610, 20)
	GUICtrlSetColor(-1, 0x555555)

	$g_hRichEditCSVShortNamesHelp = _GUICtrlRichEdit_Create($g_hGUI_CSVShortNamesHelp, "", 20, 70, 610, 520, _
			BitOR($WS_VSCROLL, $ES_MULTILINE), $WS_EX_CLIENTEDGE)
	_GUICtrlRichEdit_SetBkColor($g_hRichEditCSVShortNamesHelp, 0xFFFFFF)
	_GUICtrlRichEdit_StreamFromVar($g_hRichEditCSVShortNamesHelp, BuildCSVShortNamesHelpRTF())
	_GUICtrlRichEdit_SetReadOnly($g_hRichEditCSVShortNamesHelp)
	_GUICtrlRichEdit_SetScrollPos($g_hRichEditCSVShortNamesHelp, 0, 0)

	Local $hClose = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Attack - Attack Scripted", "BtnCSVHelpClose", "Close"), 530, 602, 100, 30)
	GUICtrlSetFont(-1, 9, $FW_BOLD)
	GUICtrlSetOnEvent($hClose, "CloseCSVShortNamesHelp")

	GUISetState(@SW_SHOW, $g_hGUI_CSVShortNamesHelp)
	GUISwitch($g_hFrmBotEx)
EndFunc   ;==>ShowCSVShortNamesHelp

Func BuildCSVShortNamesHelpRTF()
	Local $sRTF = "{\rtf1\ansi\ansicpg1252\deff0" & _
			"{\fonttbl{\f0\fswiss Segoe UI;}}" & _
			"{\colortbl;\red30\green45\blue60;\red0\green96\blue160;\red90\green100\blue110;\red232\green238\blue244;}" & _
			"\viewkind4\uc1\pard\sa120\sl276\slmult1\f0\fs20\cf1 "

	$sRTF &= _CSVShortNamesRTFHeading("Troops")
	For $i = 0 To $eTroopDebtCollector - 1
		If Not _CSVIsSuperTroop($g_asTroopShortNames[$i]) Then $sRTF &= _CSVShortNamesRTFRow($g_asTroopShortNames[$i], $g_asTroopNames[$i])
	Next

	$sRTF &= _CSVShortNamesRTFHeading("Super Troops")
	Local Const $aiSuperTroopHelpOrder[$iSuperTroopsCount] = [0, 1, 3, 4, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 15]
	For $i = 0 To UBound($aiSuperTroopHelpOrder) - 1
		Local $iSuperTroop = $aiSuperTroopHelpOrder[$i]
		$sRTF &= _CSVShortNamesRTFRow($g_asSuperTroopShortNames[$iSuperTroop], $g_asSuperTroopNames[$iSuperTroop])
	Next

	$sRTF &= _CSVShortNamesRTFHeading("Event Troops")
	For $i = $eTroopDebtCollector To $eTroopCount - 1
		$sRTF &= _CSVShortNamesRTFRow($g_asTroopShortNames[$i], $g_asTroopNames[$i])
	Next

	$sRTF &= _CSVShortNamesRTFSection("Spells", $g_asSpellNames, $g_asSpellShortNames)
	$sRTF &= _CSVShortNamesRTFSection("Siege Machines", $g_asSiegeMachineNames, $g_asSiegeMachineShortNames)
	$sRTF &= _CSVShortNamesRTFSection("Heroes", $g_asHeroNames, $g_asHeroShortNames)
	Return $sRTF & "}"
EndFunc   ;==>BuildCSVShortNamesHelpRTF

Func _CSVShortNamesRTFSection($sTitle, Const ByRef $asNames, Const ByRef $asShortNames)
	Local $sRTF = _CSVShortNamesRTFHeading($sTitle)
	For $i = 0 To UBound($asNames) - 1
		$sRTF &= _CSVShortNamesRTFRow($asShortNames[$i], $asNames[$i])
	Next
	Return $sRTF
EndFunc   ;==>_CSVShortNamesRTFSection

Func _CSVShortNamesRTFHeading($sTitle)
	Return "\pard\sb140\sa80\b\fs23\cf1 " & _CSVShortNamesRTFEscape($sTitle) & "\b0\fs20\par" & _
			"\pard\tx2700\sa55\b\cf3 Shortname\tab Name\b0\cf1\par"
EndFunc   ;==>_CSVShortNamesRTFHeading

Func _CSVShortNamesRTFRow($sShortName, $sName)
	Return "\pard\tx2700\sa55\b\cf2 " & _CSVShortNamesRTFEscape($sShortName) & _
			"\b0\cf1\tab " & _CSVShortNamesRTFEscape($sName) & "\par"
EndFunc   ;==>_CSVShortNamesRTFRow

Func _CSVShortNamesRTFEscape($sText)
	$sText = StringReplace($sText, "\", "\\")
	$sText = StringReplace($sText, "{", "\{")
	Return StringReplace($sText, "}", "\}")
EndFunc   ;==>_CSVShortNamesRTFEscape

Func _CSVIsSuperTroop($sShortName)
	For $i = 0 To UBound($g_asSuperTroopShortNames) - 1
		If $g_asSuperTroopShortNames[$i] = $sShortName Then Return True
	Next
	Return False
EndFunc   ;==>_CSVIsSuperTroop

Func CloseCSVShortNamesHelp()
	If $g_hRichEditCSVShortNamesHelp Then
		_GUICtrlRichEdit_Destroy($g_hRichEditCSVShortNamesHelp)
		$g_hRichEditCSVShortNamesHelp = 0
	EndIf
	If $g_hGUI_CSVShortNamesHelp Then
		GUIDelete($g_hGUI_CSVShortNamesHelp)
		$g_hGUI_CSVShortNamesHelp = 0
	EndIf
	GUISwitch($g_hFrmBotEx)
EndFunc   ;==>CloseCSVShortNamesHelp

Func PopulateComboScriptsFilesDB()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($g_hCmbScriptNameDB)
	;set combo box
	GUICtrlSetData($g_hCmbScriptNameDB, $output)
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameDB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameDB, ""))
	GUICtrlSetData($g_hLblNotesScriptDB, "")
EndFunc   ;==>PopulateComboScriptsFilesDB

Func PopulateComboScriptsFilesAB()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
	Dim $output = ""
	While True
		$NewFile = FileFindNextFile($FileSearch)
		If @error Then ExitLoop
		$output = $output & StringLeft($NewFile, StringLen($NewFile) - 4) & "|"
	WEnd
	FileClose($FileSearch)
	;remove last |
	$output = StringLeft($output, StringLen($output) - 1)
	;reset combo box
	_GUICtrlComboBox_ResetContent($g_hCmbScriptNameAB)
	;set combo box
	GUICtrlSetData($g_hCmbScriptNameAB, $output)
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameAB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameAB, ""))
	GUICtrlSetData($g_hLblNotesScriptAB, "")
EndFunc   ;==>PopulateComboScriptsFilesAB

Func SyncDBAttackHeroesFromGUI()
	$g_aiAttackUseHeroes[$DB] = BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion, $eHeroDuke)
EndFunc   ;==>SyncDBAttackHeroesFromGUI

Func SyncABAttackHeroesFromGUI()
	$g_aiAttackUseHeroes[$LB] = BitOR($eHeroKing, $eHeroQueen, $eHeroPrince, $eHeroWarden, $eHeroChampion, $eHeroDuke)
EndFunc   ;==>SyncABAttackHeroesFromGUI


Func cmbScriptNameDB()

	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameDB)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t

	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		$f = FileOpen($g_sCSVAttacksPath & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$tempvect = StringSplit($line, "|", 2)
			If UBound($tempvect) >= 2 Then
				If StringStripWS(StringUpper($tempvect[0]), 2) = "NOTE" Then $result &= $tempvect[1] & @CRLF
			EndIf
		WEnd
		FileClose($f)

	EndIf
	GUICtrlSetData($g_hLblNotesScriptDB, $result)

EndFunc   ;==>cmbScriptNameDB

Func cmbScriptNameAB()

	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameAB)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t

	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		$f = FileOpen($g_sCSVAttacksPath & "\" & $filename & ".csv", 0)
		; Read in lines of text until the EOF is reached
		While 1
			$line = FileReadLine($f)
			If @error = -1 Then ExitLoop
			$tempvect = StringSplit($line, "|", 2)
			If UBound($tempvect) >= 2 Then
				If StringStripWS(StringUpper($tempvect[0]), 2) = "NOTE" Then $result &= $tempvect[1] & @CRLF
			EndIf
		WEnd
		FileClose($f)

	EndIf
	GUICtrlSetData($g_hLblNotesScriptAB, $result)

EndFunc   ;==>cmbScriptNameAB


Func UpdateComboScriptNameDB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameDB, $indexofscript, $scriptname)
	PopulateComboScriptsFilesDB()
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameDB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameDB, $scriptname))
	cmbScriptNameDB()
EndFunc   ;==>UpdateComboScriptNameDB

Func UpdateComboScriptNameAB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameAB, $indexofscript, $scriptname)
	PopulateComboScriptsFilesAB()
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameAB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameAB, $scriptname))
	cmbScriptNameAB()
EndFunc   ;==>UpdateComboScriptNameAB


Func EditScriptDB()
	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameDB)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		ShellExecute("notepad.exe", $g_sCSVAttacksPath & "\" & $filename & ".csv")
	EndIf
EndFunc   ;==>EditScriptDB

Func EditScriptAB()
	Local $tempvect1 = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameAB)
	Local $filename = $tempvect1[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB) + 1]
	Local $f, $result = ""
	Local $tempvect, $line, $t
	If FileExists($g_sCSVAttacksPath & "\" & $filename & ".csv") Then
		ShellExecute("notepad.exe", $g_sCSVAttacksPath & "\" & $filename & ".csv")
	EndIf
EndFunc   ;==>EditScriptAB


Func AttackCSVAssignDefaultScriptName()
	Dim $FileSearch, $NewFile
	$FileSearch = FileFindFirstFile($g_sCSVAttacksPath & "\*.csv")
	Dim $output = ""
	$NewFile = FileFindNextFile($FileSearch)
	If @error Then $output = ""
	$output = StringLeft($NewFile, StringLen($NewFile) - 4)
	FileClose($FileSearch)
	;remove last |
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameDB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameDB, $output))
	_GUICtrlComboBox_SetCurSel($g_hCmbScriptNameAB, _GUICtrlComboBox_FindStringExact($g_hCmbScriptNameAB, $output))

	cmbScriptNameDB()
	cmbScriptNameAB()
EndFunc   ;==>AttackCSVAssignDefaultScriptName

;Parse this first on load of bot, needed outside the function to update current language.ini file. Used on Func NewABScript() and NewDBScript()
Local $temp1 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Create", "Create New Script File"), $temp2 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_0", "New Script Filename")
Local $temp3 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", "File exists, please input a new name"), $temp4 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", "An error occurred when creating the file.")
Local $temp1 = 0, $temp2 = 0, $temp3 = 0, $temp4 = 0 ; empty temp vars

Func NewScriptDB()
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Create", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_0", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileOpen($g_sCSVAttacksPath & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptName[$DB] = $filenameScript
				UpdateComboScriptNameDB()
				UpdateComboScriptNameAB()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>NewScriptDB

Func NewScriptAB()
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Create", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_0", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileOpen($g_sCSVAttacksPath & "\" & $filenameScript & ".csv", $FO_APPEND)
			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptName[$LB] = $filenameScript
				UpdateComboScriptNameAB()
				UpdateComboScriptNameDB()

			EndIf
		EndIf
	EndIf
EndFunc   ;==>NewScriptAB


;Parse this first on load of bot, needed outside the function to update current language.ini file. Used on Func DuplicateABScript() and DuplicateDBScript()
Local $temp1 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_0", "Copy to New Script File"), $temp2 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_1", "Copy"), $temp3 = GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_1", "to New Script Filename")
Local $temp1 = 0, $temp2 = 0, $temp3 = 0 ; empty temp vars

Func DuplicateScriptDB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameDB, $indexofscript, $scriptname)
	$g_sAttackScrScriptName[$DB] = $scriptname
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_0", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_1", -1) & ": <" & $g_sAttackScrScriptName[$DB] & ">" & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_1", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileCopy($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$DB] & ".csv", $g_sCSVAttacksPath & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptName[$DB] = $filenameScript
				UpdateComboScriptNameDB()
				UpdateComboScriptNameAB()

			EndIf
		EndIf
	EndIf
EndFunc   ;==>DuplicateScriptDB

Func DuplicateScriptAB()
	Local $indexofscript = _GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB)
	Local $scriptname
	_GUICtrlComboBox_GetLBText($g_hCmbScriptNameAB, $indexofscript, $scriptname)
	$g_sAttackScrScriptName[$LB] = $scriptname
	Local $filenameScript = InputBox(GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_0", -1), GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Copy_1", -1) & ": <" & $g_sAttackScrScriptName[$LB] & ">" & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_New_1", -1) & ":")
	If StringLen($filenameScript) > 0 Then
		If FileExists($g_sCSVAttacksPath & "\" & $filenameScript & ".csv") Then
			MsgBox("", "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_File-exists", -1))
		Else
			Local $hFileOpen = FileCopy($g_sCSVAttacksPath & "\" & $g_sAttackScrScriptName[$LB] & ".csv", $g_sCSVAttacksPath & "\" & $filenameScript & ".csv")

			If $hFileOpen = -1 Then
				MsgBox($MB_SYSTEMMODAL, "", GetTranslatedFileIni("MBR Popups", "Func_AttackCSVAssignDefaultScriptName_Error", -1))
				Return False
			Else
				FileClose($hFileOpen)
				$g_sAttackScrScriptName[$LB] = $filenameScript
				UpdateComboScriptNameAB()
				UpdateComboScriptNameDB()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>DuplicateScriptAB

Func ApplyScriptDB($bUpdateGUI = True, $bApplySpells = True)
	Local $iApply = 0
	Local $iApplySieges = 0
	Local $iApplyTroops = 0
	Local $iApplySpells = 0
 	Local $iSlot = 0
 	Local $aiCSVTroops[$eTroopCount]
	Local $aiCSVSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $sCSVCCSpl[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
 	Local $ToIgnore[$eSpellCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
 	Local $aiCSVSieges[$eSiegeMachineCount]
 	Local $aiCSVHeros[$eHeroCount][2] = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
	Local $iCSVRedlineRoutineItem = 0, $iCSVDroplineEdgeItem = 0
	Local $sCSVCCReq = ""
	Local $aTemp = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameDB)
	Local $sFilename = $aTemp[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameDB) + 1]

	SetLog("CSV Scripted Attack Applied: " & $sFilename, $COLOR_INFO)
	$iApply = ParseAttackCSV_Settings_variables($aiCSVTroops, $aiCSVSpells, $aiCSVSieges, $aiCSVHeros, $iCSVRedlineRoutineItem, $iCSVDroplineEdgeItem, $sCSVCCReq, $sCSVCCSpl, $sFilename)
	If Not $iApply Then
		SetLog("CSV settings apply failed", $COLOR_ERROR)
		Return
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVTroops) - 1
		If $aiCSVTroops[$i] > 0 Then $iApplyTroops += 1
	Next
	For $i = 0 To UBound($aiCSVSpells) - 1
		If $aiCSVSpells[$i] > 0 Then $iApplySpells += 1
	Next
	For $i = 0 To UBound($aiCSVSieges) - 1
		If $aiCSVSieges[$i] > 0 Then $iApplySieges += 1
	Next
	$iApply = $iApplyTroops + $iApplySpells + $iApplySieges
	If $iApply > 0 Then
		If $iApplyTroops > 0 Then
			$g_aiArmyCustomTroops = $aiCSVTroops
			$g_aiArmyCompTroops = $aiCSVTroops
		EndIf
		If $iApplySpells > 0 Then
			$g_aiArmyCustomSpells = $aiCSVSpells
			$g_aiArmyCompSpells = $aiCSVSpells
		EndIf
		If $iApplySieges > 0 Then $g_aiArmyCompSiegeMachines = $aiCSVSieges
		ApplyConfig_600_52_2("Read")
		SetComboTroopComp() ; GUI refresh
		lblTotalCountSpell()
		lblTotalCountSiege()
		SetLog("CSV Train settings applied", $COLOR_SUCCESS)
	EndIf

	If IsArray($aiCSVSieges) And $iApplySieges > 0 Then
		Local $aMachine = _ArrayMaxIndex($aiCSVSieges)
		_GUICtrlComboBox_SetCurSel($g_hCmbDBSiege, $aMachine + 3)
		UpdateAttackSiegeIcon($g_hCmbDBSiege, $g_hPicDBDropCC)
		GUICtrlSetState($g_hChkDBDropCC, $GUI_CHECKED)
		GUICtrlSetState($g_hCmbDBSiege, $GUI_ENABLE)
		SetLog("CSV Sieges settings applied", $COLOR_SUCCESS)
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVHeros) - 1
		If $aiCSVHeros[$i][0] > 0 Then $iApply += 1
	Next
	If $iApply > 0 Then
		For $h = 0 To UBound($aiCSVHeros) - 1
			If $aiCSVHeros[$h][0] > 0 Then
				Switch $h
					Case $eHeroBarbarianKing
						$g_iActivateKing = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateKing = $aiCSVHeros[$h][1]
					Case $eHeroArcherQueen
						$g_iActivateQueen = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateQueen = $aiCSVHeros[$h][1]
					Case $eHeroMinionPrince
						$g_iActivatePrince = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivatePrince = $aiCSVHeros[$h][1]
					Case $eHeroGrandWarden
						$g_iActivateWarden = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateWarden = $aiCSVHeros[$h][1]
					Case $eHeroRoyalChampion
						$g_iActivateChampion = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateChampion = $aiCSVHeros[$h][1]
					Case $eHeroDukeIndex
						$g_iActivateDuke = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateDuke = $aiCSVHeros[$h][1]
				EndSwitch
			EndIf
		Next
		radHerosApply()
		SetLog("CSV Hero Ability settings applied", $COLOR_SUCCESS)

		GUICtrlSetState($g_hChkDBKingAttack, $aiCSVHeros[$eHeroBarbarianKing][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBKingAttack))
		GUICtrlSetState($g_hChkDBQueenAttack, $aiCSVHeros[$eHeroArcherQueen][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBQueenAttack))
		GUICtrlSetState($g_hChkDBPrinceAttack, $aiCSVHeros[$eHeroMinionPrince][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBPrinceAttack))
		GUICtrlSetState($g_hChkDBWardenAttack, $aiCSVHeros[$eHeroGrandWarden][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBWardenAttack))
		GUICtrlSetState($g_hChkDBChampionAttack, $aiCSVHeros[$eHeroRoyalChampion][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBChampionAttack))
		GUICtrlSetState($g_hChkDBDukeAttack, $aiCSVHeros[$eHeroDukeIndex][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkDBDukeAttack))
		SyncDBAttackHeroesFromGUI()
		SetLog("CSV 'Attack with' Hero settings applied", $COLOR_SUCCESS)
	EndIf

	If $sCSVCCReq <> "" Then
		GUICtrlSetState($g_hChkDBDropCC, $GUI_CHECKED)
	EndIf

	$iApply = 0
	Local $ahChkDBSpell = StringSplit($g_aGroupAttackDBSpell, "#", 2)
	If IsArray($ahChkDBSpell) Then
		For $i = 0 To UBound($ahChkDBSpell) - 1
			GUICtrlSetState($ahChkDBSpell[$i], $aiCSVSpells[$i] > 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $sCSVCCSpl[$i] = 1 Then GUICtrlSetState($ahChkDBSpell[$i], $GUI_CHECKED)
			If $aiCSVSpells[$i] > 0 Then $iApply += 1
		Next
		If $iApply > 0 Then SetLog("CSV 'Attack with' Spell settings applied", $COLOR_SUCCESS)
	EndIf

	For $t = 0 To UBound($sCSVCCSpl) - 1
		If $sCSVCCSpl[$t] = 1 Then $iSlot += 1
	Next
	If $iSlot > 0 Then
		GUICtrlSetState($g_hChkRequestType_Spells, $GUI_CHECKED)
		For $x = 0 To UBound($g_ahCmbClanCastleSpell) - 1
			_GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$x], 0) ;Reset To Any
		Next
		chkRequestCountCC()
	EndIf
	For $i = 0 To UBound($g_ahCmbClanCastleSpell) - 1
		If $i > $iSlot - 1 Then ExitLoop
		For $z = 0 To UBound($sCSVCCSpl) - 1
			If $sCSVCCSpl[$z] = 1 And $z <> $ToIgnore[$z] Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$i], $z + 1)
				If $ToIgnore[$z] = -1 Then $ToIgnore[$z] = $z
				ExitLoop
			EndIf
		Next
	Next

	If $iCSVRedlineRoutineItem > 0 And $iCSVRedlineRoutineItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptRedlineImplDB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptRedlineImplDB, $iCSVRedlineRoutineItem - 1)
		cmbScriptRedlineImplDB()
	Else
		If $iCSVRedlineRoutineItem <> 0 Then SetLog("CSV Red Line settings out of bounds", $COLOR_ERROR)
	EndIf
	If $iCSVDroplineEdgeItem > 0 And $iCSVDroplineEdgeItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptDroplineDB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptDroplineDB, $iCSVDroplineEdgeItem - 1)
		cmbScriptDroplineDB()
		SetLog("CSV Drop Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVDroplineEdgeItem <> 0 Then SetLog("CSV Drop Line settings out of bounds", $COLOR_ERROR)
	EndIf

	If $sCSVCCReq <> "" Then
		$g_bRequestTroopsEnable = True
		$g_sRequestTroopsText = $sCSVCCReq
		ApplyConfig_600_11("Read")
	EndIf
EndFunc   ;==>ApplyScriptDB

Func ApplyScriptAB($bUpdateGUI = True, $bApplySpells = True)
	Local $iApply = 0
	Local $iApplySieges = 0
	Local $iApplyTroops = 0
	Local $iApplySpells = 0
	Local $iSlot = 0
	Local $aiCSVTroops[$eTroopCount]
	Local $aiCSVSpells[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Local $sCSVCCSpl[$eSpellCount] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
 	Local $ToIgnore[$eSpellCount] = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
 	Local $aiCSVSieges[$eSiegeMachineCount]
 	Local $aiCSVHeros[$eHeroCount][2] = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]]
	Local $iCSVRedlineRoutineItem = 0, $iCSVDroplineEdgeItem = 0
	Local $sCSVCCReq = ""
	Local $aTemp = _GUICtrlComboBox_GetListArray($g_hCmbScriptNameAB)
	Local $sFilename = $aTemp[_GUICtrlComboBox_GetCurSel($g_hCmbScriptNameAB) + 1]

	SetLog("CSV Scripted Attack Applied: " & $sFilename, $COLOR_INFO)
	$iApply = ParseAttackCSV_Settings_variables($aiCSVTroops, $aiCSVSpells, $aiCSVSieges, $aiCSVHeros, $iCSVRedlineRoutineItem, $iCSVDroplineEdgeItem, $sCSVCCReq, $sCSVCCSpl, $sFilename)
	If Not $iApply Then
		SetLog("CSV settings apply failed", $COLOR_ERROR)
		Return
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVTroops) - 1
		If $aiCSVTroops[$i] > 0 Then $iApplyTroops += 1
	Next
	For $i = 0 To UBound($aiCSVSpells) - 1
		If $aiCSVSpells[$i] > 0 Then $iApplySpells += 1
	Next
	For $i = 0 To UBound($aiCSVSieges) - 1
		If $aiCSVSieges[$i] > 0 Then $iApplySieges += 1
	Next
	$iApply = $iApplyTroops + $iApplySpells + $iApplySieges
	If $iApply > 0 Then
		If $iApplyTroops > 0 Then
			$g_aiArmyCustomTroops = $aiCSVTroops
			$g_aiArmyCompTroops = $aiCSVTroops
		EndIf
		If $iApplySpells > 0 Then
			$g_aiArmyCustomSpells = $aiCSVSpells
			$g_aiArmyCompSpells = $aiCSVSpells
		EndIf
		If $iApplySieges > 0 Then $g_aiArmyCompSiegeMachines = $aiCSVSieges
		ApplyConfig_600_52_2("Read")
		SetComboTroopComp() ; GUI refresh
		lblTotalCountSpell()
		lblTotalCountSiege()
		SetLog("CSV Train settings applied", $COLOR_SUCCESS)
	EndIf

	If IsArray($aiCSVSieges) And $iApplySieges > 0 Then
		Local $aMachine = _ArrayMaxIndex($aiCSVSieges, 0, 1)
		_GUICtrlComboBox_SetCurSel($g_hCmbABSiege, $aMachine + 3)
		UpdateAttackSiegeIcon($g_hCmbABSiege, $g_hPicABDropCC)
		GUICtrlSetState($g_hChkABDropCC, $GUI_CHECKED)
		GUICtrlSetState($g_hCmbABSiege, $GUI_ENABLE)
		SetLog("CSV Sieges settings applied", $COLOR_SUCCESS)
	EndIf

	$iApply = 0
	For $i = 0 To UBound($aiCSVHeros) - 1
		If $aiCSVHeros[$i][0] > 0 Then $iApply += 1
	Next
	If $iApply > 0 Then
		For $h = 0 To UBound($aiCSVHeros) - 1
			If $aiCSVHeros[$h][0] > 0 Then
				Switch $h
					Case $eHeroBarbarianKing
						$g_iActivateKing = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateKing = $aiCSVHeros[$h][1]
					Case $eHeroArcherQueen
						$g_iActivateQueen = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateQueen = $aiCSVHeros[$h][1]
					Case $eHeroMinionPrince
						$g_iActivatePrince = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivatePrince = $aiCSVHeros[$h][1]
					Case $eHeroGrandWarden
						$g_iActivateWarden = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateWarden = $aiCSVHeros[$h][1]
					Case $eHeroRoyalChampion
						$g_iActivateChampion = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateChampion = $aiCSVHeros[$h][1]
					Case $eHeroDukeIndex
						$g_iActivateDuke = $aiCSVHeros[$h][0] - 1
						$g_iDelayActivateDuke = $aiCSVHeros[$h][1]
				EndSwitch
			EndIf
		Next
		radHerosApply()
		SetLog("CSV Hero Ability settings applied", $COLOR_SUCCESS)

		GUICtrlSetState($g_hChkABKingAttack, $aiCSVHeros[$eHeroBarbarianKing][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABKingAttack))
		GUICtrlSetState($g_hChkABQueenAttack, $aiCSVHeros[$eHeroArcherQueen][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABQueenAttack))
		GUICtrlSetState($g_hChkABPrinceAttack, $aiCSVHeros[$eHeroMinionPrince][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABPrinceAttack))
		GUICtrlSetState($g_hChkABWardenAttack, $aiCSVHeros[$eHeroGrandWarden][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABWardenAttack))
		GUICtrlSetState($g_hChkABChampionAttack, $aiCSVHeros[$eHeroRoyalChampion][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABChampionAttack))
		GUICtrlSetState($g_hChkABDukeAttack, $aiCSVHeros[$eHeroDukeIndex][0] > 0 ? $GUI_CHECKED : GUICtrlGetState($g_hChkABDukeAttack))
		SyncABAttackHeroesFromGUI()
		SetLog("CSV 'Attack with' Hero settings applied", $COLOR_SUCCESS)
	EndIf

	If $sCSVCCReq <> "" Then
		GUICtrlSetState($g_hChkABDropCC, $GUI_CHECKED)
	EndIf

	$iApply = 0
	Local $ahChkABSpell = StringSplit($GroupAttackABSpell, "#", 2)
	If IsArray($ahChkABSpell) Then
		For $i = 0 To UBound($ahChkABSpell) - 1
			GUICtrlSetState($ahChkABSpell[$i], $aiCSVSpells[$i] > 0 ? $GUI_CHECKED : $GUI_UNCHECKED)
			If $sCSVCCSpl[$i] = 1 Then GUICtrlSetState($ahChkABSpell[$i], $GUI_CHECKED)
			If $aiCSVSpells[$i] > 0 Then $iApply += 1
		Next
		If $iApply > 0 Then SetLog("CSV 'Attack with' Spell settings applied", $COLOR_SUCCESS)
	EndIf

	For $t = 0 To UBound($sCSVCCSpl) - 1
		If $sCSVCCSpl[$t] = 1 Then $iSlot += 1
	Next
	If $iSlot > 0 Then
		GUICtrlSetState($g_hChkRequestType_Spells, $GUI_CHECKED)
		For $x = 0 To UBound($g_ahCmbClanCastleSpell) - 1
			_GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$x], 0) ;Reset To Any
		Next
		chkRequestCountCC()
	EndIf
	For $i = 0 To UBound($g_ahCmbClanCastleSpell) - 1
		If $i > $iSlot - 1 Then ExitLoop
		For $z = 0 To UBound($sCSVCCSpl) - 1
			If $sCSVCCSpl[$z] = 1 And $z <> $ToIgnore[$z] Then
				_GUICtrlComboBox_SetCurSel($g_ahCmbClanCastleSpell[$i], $z + 1)
				If $ToIgnore[$z] = -1 Then $ToIgnore[$z] = $z
				ExitLoop
			EndIf
		Next
	Next

	If $iCSVRedlineRoutineItem > 0 And $iCSVRedlineRoutineItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptRedlineImplAB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptRedlineImplAB, $iCSVRedlineRoutineItem - 1)
		cmbScriptRedlineImplAB()
	Else
		If $iCSVRedlineRoutineItem <> 0 Then SetLog("CSV Red Line settings out of bounds", $COLOR_ERROR)
	EndIf
	If $iCSVDroplineEdgeItem > 0 And $iCSVDroplineEdgeItem <= _GUICtrlComboBox_GetCount($g_hCmbScriptDroplineAB) + 1 Then
		_GUICtrlComboBox_SetCurSel($g_hCmbScriptDroplineAB, $iCSVDroplineEdgeItem - 1)
		cmbScriptDroplineAB()
		SetLog("CSV Drop Line settings applied", $COLOR_SUCCESS)
	Else
		If $iCSVDroplineEdgeItem <> 0 Then SetLog("CSV Drop Line settings out of bounds", $COLOR_ERROR)
	EndIf

	If $sCSVCCReq <> "" Then
		$g_bRequestTroopsEnable = True
		$g_sRequestTroopsText = $sCSVCCReq
		ApplyConfig_600_11("Read")
	EndIf
EndFunc   ;==>ApplyScriptAB

Func cmbScriptRedlineImplDB()
	$g_aiAttackScrRedlineRoutine[$DB] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptRedlineImplDB)
	If $g_aiAttackScrRedlineRoutine[$DB] = 3 Then
		GUICtrlSetState($g_hCmbScriptDroplineDB, $GUI_HIDE)
		$g_aiAttackScrDroplineEdge[$DB] = $DROPLINE_FULL_EDGE_FIXED
	Else
		GUICtrlSetState($g_hCmbScriptDroplineDB, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbScriptRedlineImplDB

Func cmbScriptRedlineImplAB()
	$g_aiAttackScrRedlineRoutine[$LB] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptRedlineImplAB)
	If $g_aiAttackScrRedlineRoutine[$LB] = 3 Then
		GUICtrlSetState($g_hCmbScriptDroplineAB, $GUI_HIDE)
		$g_aiAttackScrDroplineEdge[$LB] = $DROPLINE_FULL_EDGE_FIXED
	Else
		GUICtrlSetState($g_hCmbScriptDroplineAB, $GUI_SHOW)
	EndIf
EndFunc   ;==>cmbScriptRedlineImplAB

Func cmbScriptDroplineDB()
	$g_aiAttackScrDroplineEdge[$DB] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptDroplineDB)
EndFunc   ;==>cmbScriptDroplineDB

Func cmbScriptDroplineAB()
	$g_aiAttackScrDroplineEdge[$LB] = _GUICtrlComboBox_GetCurSel($g_hCmbScriptDroplineAB)
EndFunc   ;==>cmbScriptDroplineAB
