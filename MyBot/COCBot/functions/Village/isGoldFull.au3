; #FUNCTION# ====================================================================================================================
; Name ..........: isGoldFull
; Description ...: Checks if your Gold Storages are maxed out
; Syntax ........: isGoldFull()
; Parameters ....:
; Return values .: True or False
; Author ........: Code Monkey #57 (send more bananas please!)
; Modified ......: Hervidero (2015)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================

Func isGoldFull($bLog = True)
	If _CheckPixel($aMainStorageGoldFullLight, $g_bCapturePixel) And _CheckPixel($aMainStorageGoldFull, $g_bCapturePixel) Then
		If $bLog Then SetLog("Gold Storages: Full", $COLOR_SUCCESS)
		$g_abFullStorage[$eLootGold] = True
	ElseIf $g_abFullStorage[$eLootGold] Then
		If Number($g_aiCurrentLoot[$eLootGold]) >= Number($g_aiResumeAttackLoot[$eLootGold]) Then
			If $bLog Then SetLog("Gold Storages Almost Full: " & $g_aiCurrentLoot[$eLootGold], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootGold] = True
		Else
			If $bLog Then SetLog("Resume Normal Mode: Gold < " & $g_aiResumeAttackLoot[$eLootGold], $COLOR_SUCCESS)
			$g_abFullStorage[$eLootGold] = False
		EndIf
	EndIf
	Return $g_abFullStorage[$eLootGold]
EndFunc   ;==>isGoldFull
