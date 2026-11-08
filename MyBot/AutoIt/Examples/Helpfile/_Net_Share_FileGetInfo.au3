#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <NetShare.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $sServer, $aFile, $aInfo

	; Create GUI
	GUICreate("NetShare", 400, 300)

	; Create memo control
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get server and share information
	$sServer = InputBox("NetWork Demo", "Enter Server Name:", "\\MyServer", "", 200, 130)
	If @error Then Exit

	; Enumerate open files on the server
	$aFile = _Net_Share_FileEnum($sServer)
	_MemoWrite("Error ...................: " & @error)
	_MemoWrite("Entries read ............: " & $aFile[0][0])
	_MemoWrite()

	; Get information for each open file (same as $aFile info)
	For $iI = 1 To $aFile[0][0]
		$aInfo = _Net_Share_FileGetInfo($sServer, $aFile[$iI][0])
		_MemoWrite("Error ...................: " & @error)
		_MemoWrite("File permissions ........: " & _Net_Share_PermStr($aInfo[1]))
		_MemoWrite("File locks ..............: " & $aInfo[2])
		_MemoWrite("File path ...............: " & $aInfo[3])
		_MemoWrite("File user ...............: " & $aInfo[4])
		_MemoWrite()
	Next

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
