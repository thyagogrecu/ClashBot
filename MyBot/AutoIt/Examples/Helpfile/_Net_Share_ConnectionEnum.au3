#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <NetShare.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $sServer, $sShare, $aInfo

	; Create GUI
	GUICreate("NetShare", 400, 300)

	; Create memo control
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get server and share information
	$sServer = InputBox("NetWork Demo", "Enter Server Name:", "\\MyServer", "", 200, 130)
	If @error Then Exit
	$sShare = InputBox("NetWork Demo", "Enter Share Name:", "MyShare", "", 200, 130)
	If @error Then Exit

	; Enumerate network connections
	$aInfo = _Net_Share_ConnectionEnum($sServer, $sShare)
	_MemoWrite("Error ...................: " & @error)
	_MemoWrite("Entries read ............: " & $aInfo[0][0])
	For $iI = 1 To $aInfo[0][0]
		_MemoWrite("Connection ID ...........: " & $aInfo[$iI][0])
		_MemoWrite("Connection type..........: " & _Net_Share_ResourceStr($aInfo[$iI][1]))
		_MemoWrite("Number of files open ....: " & $aInfo[$iI][2])
		_MemoWrite("Number of users .........: " & $aInfo[$iI][3])
		_MemoWrite("Connection time .........: " & $aInfo[$iI][4])
		_MemoWrite("Username ................: " & $aInfo[$iI][5])
		_MemoWrite("Network name ............: " & $aInfo[$iI][6])
		_MemoWrite()
	Next

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
