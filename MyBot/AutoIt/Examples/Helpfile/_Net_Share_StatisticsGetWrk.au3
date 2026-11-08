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

	; Get workstation statistics
	$aInfo = _Net_Share_StatisticsGetWrk(@ComputerName)
	_MemoWrite("NetStatisticsGetWrk")
	_MemoWrite("Statistics started ......: " & $aInfo[0])
	_MemoWrite("Bytes received ..........: " & $aInfo[1])
	_MemoWrite("SMBs received ...........: " & $aInfo[2])
	_MemoWrite("Paging I/O bytes ........: " & $aInfo[3])
	_MemoWrite("Non-paging I/O bytes ....: " & $aInfo[4])
	_MemoWrite("Cache I/O bytes ..... ...: " & $aInfo[5])
	_MemoWrite("Disk I/O bytes ..........: " & $aInfo[6])
	_MemoWrite("Bytes transmitted .......: " & $aInfo[7])
	_MemoWrite("SMBs transmitted ........: " & $aInfo[8])
	_MemoWrite("Paging I/O bytes ........: " & $aInfo[9])
	_MemoWrite("Non-paging I/O bytes ....: " & $aInfo[10])
	_MemoWrite("Cache I/O bytes .........: " & $aInfo[11])
	_MemoWrite("Disk I/O bytes ..........: " & $aInfo[12])
	_MemoWrite("Failed ops begin ........: " & $aInfo[13])
	_MemoWrite("Failed ops completed ....: " & $aInfo[14])
	_MemoWrite("Read operations .........: " & $aInfo[15])
	_MemoWrite("Random access reads .....: " & $aInfo[16])
	_MemoWrite("Read requests sent ......: " & $aInfo[17])
	_MemoWrite("Read requests big .......: " & $aInfo[18])
	_MemoWrite("Read requests small .....: " & $aInfo[19])
	_MemoWrite("Write operations ........: " & $aInfo[20])
	_MemoWrite("Random access writes ....: " & $aInfo[21])
	_MemoWrite("Write requests sent .....: " & $aInfo[22])
	_MemoWrite("Write requests big ......: " & $aInfo[23])
	_MemoWrite("Write requests small ....: " & $aInfo[24])
	_MemoWrite("Denied raw reads ........: " & $aInfo[25])
	_MemoWrite("Denied raw writes .......: " & $aInfo[26])
	_MemoWrite("Network errors ..........: " & $aInfo[27])
	_MemoWrite("Sessions established ....: " & $aInfo[28])
	_MemoWrite("Failed sessions .........: " & $aInfo[29])
	_MemoWrite("Failed connections ......: " & $aInfo[30])
	_MemoWrite("PCNET connections .......: " & $aInfo[31])
	_MemoWrite("NetShare 20 connections .: " & $aInfo[32])
	_MemoWrite("NetShare 21 connections .: " & $aInfo[33])
	_MemoWrite("WinNT connections .......: " & $aInfo[34])
	_MemoWrite("Disconnects .............: " & $aInfo[35])
	_MemoWrite("Sessions expired ........: " & $aInfo[36])
	_MemoWrite("Connections made ........: " & $aInfo[37])
	_MemoWrite("Connections failed ......: " & $aInfo[38])
	_MemoWrite("Incomplete requests .....: " & $aInfo[39])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
