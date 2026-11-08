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

	; Enumerate network sessions
	$aInfo = _Net_Share_SessionEnum($sServer, @ComputerName)
	_MemoWrite("Error ..........: " & @error)
	_MemoWrite("Entries read ...: " & $aInfo[0][0])
	For $iI = 1 To $aInfo[0][0]
		_MemoWrite("Computer name ..: " & $aInfo[$iI][0])
		_MemoWrite("User name.......: " & $aInfo[$iI][1])
		_MemoWrite("Resources open .: " & $aInfo[$iI][2])
		_MemoWrite("Seconds active .: " & $aInfo[$iI][3])
		_MemoWrite("Seconds idle ...: " & $aInfo[$iI][4])
		_MemoWrite("Connection type : " & $aInfo[$iI][5])
		_MemoWrite("Client type ....: " & $aInfo[$iI][6])
		_MemoWrite("Transport ......: " & $aInfo[$iI][7])
		_MemoWrite()
	Next

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
