; == Sample 2 script using $sType = "a"

#include <Date.au3>
#include <MsgBoxConstants.au3>

Local $sStartDate = "2024/08/19 18:25:59"
Local $sEndDate = "2024/08/20 16:25:00"

Local $aDiffDate = _DateDiff("a", $sStartDate, $sEndDate)

Local $sAddDate = _DateAdd("a", $aDiffDate, $sStartDate)

Local $iError = 0
If $sAddDate <> $sEndDate Then $iError = $MB_ICONERROR
MsgBox($MB_SYSTEMMODAL + $iError, "Results", "$sStartDate = " & $sStartDate & @CRLF & _
		"$sEndDate = " & $sEndDate & @CRLF & @CRLF & _
		"$Diff Days = " & $aDiffDate[0] & @CRLF & _
		"$Diff Hours = " & $aDiffDate[1] & @CRLF & _
		"$Diff Minutes = " & $aDiffDate[2] & @CRLF & _
		"$Diff Seconds = " & $aDiffDate[3] & @CRLF & @CRLF & _
		"Add Date = " & $sAddDate & @TAB & ($iError ? "<<< KO >>>": "OK"))
