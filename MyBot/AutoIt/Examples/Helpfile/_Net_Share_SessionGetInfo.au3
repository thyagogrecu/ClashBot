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

	; Get session information
	$aInfo = _Net_Share_SessionGetInfo($sServer, @ComputerName, "Administrator")
	_MemoWrite("Error ..........: " & @error)
	_MemoWrite("Computer name ..: " & $aInfo[0])
	_MemoWrite("User name ......: " & $aInfo[1])
	_MemoWrite("Resources open .: " & $aInfo[2])
	_MemoWrite("Seconds active .: " & $aInfo[3])
	_MemoWrite("Seconds idle ...: " & $aInfo[4])
	_MemoWrite("Connection type : " & $aInfo[5])
	_MemoWrite("Client type ....: " & $aInfo[6])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
