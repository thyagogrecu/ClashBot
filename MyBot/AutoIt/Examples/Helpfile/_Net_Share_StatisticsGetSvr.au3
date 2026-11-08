#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <NetShare.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $aInfo

	; Create GUI
	GUICreate("NetShare", 400, 300)

	; Create memo control
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get server statistics
	$aInfo = _Net_Share_StatisticsGetSvr(@ComputerName)
	_MemoWrite("Statistics started ......: " & $aInfo[0])
	_MemoWrite("Times file opened .......: " & $aInfo[1])
	_MemoWrite("Times device opened .....: " & $aInfo[2])
	_MemoWrite("Print jobs spooled ......: " & $aInfo[3])
	_MemoWrite("Sessions started ........: " & $aInfo[4])
	_MemoWrite("Sessions disconnected ...: " & $aInfo[5])
	_MemoWrite("Session errors ..........: " & $aInfo[6])
	_MemoWrite("Password violations .....: " & $aInfo[7])
	_MemoWrite("Permission errors .......: " & $aInfo[8])
	_MemoWrite("Server system errors ....: " & $aInfo[9])
	_MemoWrite("Network bytes sent ......: " & $aInfo[10])
	_MemoWrite("Network bytes recv ......: " & $aInfo[11])
	_MemoWrite("Average response time ...: " & $aInfo[12])
	_MemoWrite("Req buffer failures .....: " & $aInfo[13])
	_MemoWrite("Big buffer failures .....: " & $aInfo[14])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
