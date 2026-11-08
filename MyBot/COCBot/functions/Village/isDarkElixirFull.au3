; #FUNCTION# ====================================================================================================================
; Name ..........: isDarkElixirFull
; Description ...: Checks if your Gold Storages are maxed out
; Syntax ........: isDarkElixirFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #57 (send more bananas please!)
; Modified ......: MonkeyHunter (2015-12)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isDarkElixirFull($bLog = True)

	If Not _CheckPixel($aVillageHasDarkElixir, $g_bCapturePixel) Then Return ; check if the village have a Dark Elixir Storage

	If _CheckPixel($aMainStorageDarkFullLight, $g_bCapturePixel) And _CheckPixel($aMainStorageDarkFull, $g_bCapturePixel) Then
		If $bLog Then SetLog("Dark Elixir Storage: Full", $COLOR_SUCCESS)
		$g_abFullStorage[$eLootDarkElixir] = True
	ElseIf $g_abFullStorage[$eLootDarkElixir] Then
		If Number($g_aiCurrentLoot[$eLootDarkElixir]) >= Number($g_aiResumeAttackLoot[$eLootDarkElixir]) Then
			If $bLog Then SetLog("Dark Elixir Storages Almost Full: " & $g_aiCurrentLoot[$eLootDarkElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootDarkElixir] = True
		Else
			If $bLog Then SetLog("Resume Normal Mode: Dark Elixir < " & $g_aiResumeAttackLoot[$eLootDarkElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootDarkElixir] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootDarkElixir]
EndFunc   ;==>isDarkElixirFull
