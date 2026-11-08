#include <Date.au3>
#include <MsgBoxConstants.au3>

Local $aMyDate, $aMyTime, $sMsg
_DateTimeSplit("2005/01/01 11:30", $aMyDate, $aMyTime)
If @error Then
	MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Result", "Error")
Else
	$sMsg = "Year = " & @TAB & $aMyDate[1] & @CRLF
	$sMsg &= "Month = " & $aMyDate[2] & @CRLF
	$sMsg &= "Day = " & @TAB & $aMyDate[3] & @CRLF
	If $aMyTime[0] Then
		$sMsg &= "Hour = " & @TAB & $aMyTime[1] & @CRLF
		$sMsg &= "Min = " & @TAB & $aMyTime[2] & @CRLF
		If $aMyTime[0] = 3 Then $sMsg &= "Sec = " & @TAB & $aMyTime[3] & @CRLF
	EndIf
	MsgBox($MB_SYSTEMMODAL, "Results", $sMsg)
EndIf

_DateTimeSplit("2005/01/01", $aMyDate, $aMyTime)
If @error Then
	MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Result", "Error")
Else
	$sMsg = "Year = " & @TAB & $aMyDate[1] & @CRLF
	$sMsg &= "Month = " & $aMyDate[2] & @CRLF
	$sMsg &= "Day = " & @TAB & $aMyDate[3] & @CRLF
	If $aMyTime[0] Then
		$sMsg &= "Hour = " & @TAB & $aMyTime[1] & @CRLF
		$sMsg &= "Min = " & @TAB & $aMyTime[2] & @CRLF
		If $aMyTime[0] = 3 Then $sMsg &= "Sec = " & @TAB & $aMyTime[3] & @CRLF
	EndIf
	MsgBox($MB_SYSTEMMODAL, "Results Date only", $sMsg)
EndIf
