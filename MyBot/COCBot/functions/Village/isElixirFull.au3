; #FUNCTION# ====================================================================================================================
; Name ..........: isElixirFull
; Description ...: Checks if your Elixir Storages are maxed out
; Syntax ........: isElixirFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #34 (yes, the good looking one!)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isElixirFull($bLog = True)
	If _CheckPixel($aMainStorageElixirFullLight, $g_bCapturePixel) And _CheckPixel($aMainStorageElixirFull, $g_bCapturePixel) Then
		If $bLog Then SetLog("Elixir Storages: Full", $COLOR_SUCCESS)
		$g_abFullStorage[$eLootElixir] = True
	ElseIf $g_abFullStorage[$eLootElixir] Then
		If Number($g_aiCurrentLoot[$eLootElixir]) >= Number($g_aiResumeAttackLoot[$eLootElixir]) Then
			If $bLog Then SetLog("Elixir Storages Almost Full: " & $g_aiCurrentLoot[$eLootElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootElixir] = True
		Else
			If $bLog Then SetLog("Resume Normal Mode: Elixir < " & $g_aiResumeAttackLoot[$eLootElixir], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootElixir] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootElixir]
EndFunc   ;==>isElixirFull
