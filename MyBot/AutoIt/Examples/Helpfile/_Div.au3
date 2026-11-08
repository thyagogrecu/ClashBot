#include <Math.au3>

Local $a = [ _
		[-11, -2], _
		[-11, 2], _
		[11, -2], _
		[11, 2], _
		[10, 3], _
		[10, -3], _
		[10.1, -3.9], _
		[10, 0], _
		[0, 0] _
		]

ConsoleWrite("Integer division" & @TAB & "Integer remainder" & @TAB & "@extended" & @CRLF)

Local $n, $d, $q, $r
For $i = 0 To UBound($a) - 1
	$n = $a[$i][0]
	$d = $a[$i][1]
	$q = _Div($n, $d)
	If @error Then
		$r = 0 / 0 ; as @extended cannot be set to a double
	Else
		$r = @extended
	EndIf

	ConsoleWrite($n & "/" & $d & " = " & $q & @TAB & @TAB & $r & @TAB & @TAB & @TAB & @extended & @CRLF)
Next
