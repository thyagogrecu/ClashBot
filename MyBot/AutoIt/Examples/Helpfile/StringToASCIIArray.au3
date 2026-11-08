#include <Array.au3> ; Required for _ArrayDisplay() only.
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Convert the string to an ASCII array.
	Local $aArray = StringToASCIIArray("This is a sentence with whitespace.")

	; Display the array to see that it contains the ASCII values for each character in the string.
	_ArrayDisplay($aArray)

	; Convert the array into a string.
	Local $sString = StringFromASCIIArray($aArray)

	; Display the string to see that it matches the original string initially converted to an array.
	MsgBox($MB_SYSTEMMODAL, "", $sString)
EndFunc   ;==>Example
