#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <NetShare.au3>
#include <WindowsStylesConstants.au3>

#RequireAdmin ; needed for _Net_Share_ShareAdd() if needed

Example()

Func Example()
	Local $iI, $aInfo
	Local Const $sShareName = "AutoIt Share"
	Local Const $sResourcePath = "C:\"

	; Create GUI
	GUICreate("NetShare", 400, 300)

	; Create memo control
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	Local $bShareAdded = False
	; See if the share exists
	If _Net_Share_ShareCheck(@ComputerName, $sResourcePath) = -1 Then
		; Create a share on the local computer
		$bShareAdded = _Net_Share_ShareAdd(@ComputerName, $sShareName, 0, $sResourcePath, "AutoIt Share Comment")
		If @error Then MsgBox($MB_SYSTEMMODAL, "Information", "Share add error : " & @error)
		_MemoWrite("Share added")
	Else
		_MemoWrite("Share exists")
	EndIf

	; Show information about all local shares
	$aInfo = _Net_Share_ShareEnum(@ComputerName)
	_MemoWrite("Entries read ............: " & $aInfo[0][0])
	For $iI = 1 To $aInfo[0][0]
		_MemoWrite("Share name ..............: " & $aInfo[$iI][0])
		_MemoWrite("Share type...............: " & _Net_Share_ResourceStr($aInfo[$iI][1]))
		_MemoWrite("Comment .................: " & $aInfo[$iI][2])
		_MemoWrite("Permissions .............: " & _Net_Share_PermStr($aInfo[$iI][3]))
		_MemoWrite("Maximum connections .....: " & $aInfo[$iI][4])
		_MemoWrite("Current connections .....: " & $aInfo[$iI][5])
		_MemoWrite("Local path ..............: " & $aInfo[$iI][6])
		_MemoWrite("Password ................: " & $aInfo[$iI][7])
		_MemoWrite()
	Next

	If $bShareAdded Then
		; Delete the share
		_Net_Share_ShareDel(@ComputerName, $sShareName)
		If @error Then MsgBox($MB_SYSTEMMODAL, "Information", "Share delete error : " & @error)
		_MemoWrite("Share deleted")
	EndIf
	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
