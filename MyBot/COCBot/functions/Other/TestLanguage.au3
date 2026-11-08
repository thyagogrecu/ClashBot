; #FUNCTION# ====================================================================================================================
; Name ..........: TestLanguage
; Description ...: This function tests if the game is in english language
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........: Sardo (2015-06) , MHK2012 (2018-02)
; Modified ......: Hervidero(2015)
;
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func TestLanguage()
	If Not $g_bRunState Then Return
	Local $aBattleButton = findButton("AttackButton", Default, 1, True)
	If IsArray($aBattleButton) And UBound($aBattleButton, 1) = 2 Then
		SetLog("Language Setting: English", $COLOR_INFO)
		Return True
	EndIf

	SetLog("Unable to confirm English language from Battle button", $COLOR_ERROR)
	btnStop()
	Return False
EndFunc   ;==>TestLanguage
