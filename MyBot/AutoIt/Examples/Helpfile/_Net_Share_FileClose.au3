#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <NetShare.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $sServer, $aInfo

	; Create GUI
	GUICreate("NetShare", 400, 300)

	; Create memo control
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get server and share information
	$sServer = InputBox("NetWork Demo", "Enter Server Name:", "\\MyServer", "", 200, 130)
	If @error Then Exit

	; Enumerate open files on the server
	$aInfo = _Net_Share_FileEnum($sServer)
	_MemoWrite("Error ...................: " & @error)
	_MemoWrite("Entries read ............: " & $aInfo[0][0])

	; Force close any file open named "Test.txt"
	For $iI = 1 To $aInfo[0][0]
		If StringInStr($aInfo[$iI][3], "Test.txt") > 0 Then
			_Net_Share_FileClose($sServer, $aInfo[$iI][0])
			_MemoWrite("Closed file")
		EndIf
	Next

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
