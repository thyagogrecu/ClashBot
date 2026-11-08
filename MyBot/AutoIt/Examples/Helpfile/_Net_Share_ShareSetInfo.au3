#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <NetShare.au3>
#include <WindowsStylesConstants.au3>

#RequireAdmin ; needed for _Net_Share_ShareAdd()

Example()

Func Example()
	Local $aInfo
	Local Const $sShareName = "AutoIt Share"
	Local Const $sResourcePath = "C:\"

	; Create GUI
	GUICreate("NetShare", 400, 300)

	; Create memo control
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	Local $bShareAdded = False
	; See if the share exists
	If _Net_Share_ShareCheck(@ComputerName, "") = -1 Then
		; Create a share on the local computer
		$bShareAdded = _Net_Share_ShareAdd(@ComputerName, $sShareName, 0, $sResourcePath, "AutoIt Share Comment")
		If @error Then
			MsgBox($MB_SYSTEMMODAL, "Information", "Share add error : " & @error)
		Else
			_MemoWrite("Share added" & @CRLF)
		EndIf
	Else
		_MemoWrite("Share exists" & @CRLF)
	EndIf

	If $bShareAdded Then
		; Change share information
		_Net_Share_ShareSetInfo(@ComputerName, $sShareName, "New Comment", 4)

		; Show information about the share we added
		$aInfo = _Net_Share_ShareGetInfo(@ComputerName, $sShareName)
		_MemoWrite("Share name ..............: " & $aInfo[0])
		_MemoWrite("Share type...............: " & _Net_Share_ResourceStr($aInfo[1]))
		_MemoWrite("Comment .................: " & $aInfo[2])
		_MemoWrite("Permissions .............: " & _Net_Share_PermStr($aInfo[3]))
		_MemoWrite("Maximum connections .....: " & $aInfo[4])
		_MemoWrite("Current connections .....: " & $aInfo[5])
		_MemoWrite("Local path ..............: " & $aInfo[6])
		_MemoWrite("Password ................: " & $aInfo[7])

		; Delete the share
		_Net_Share_ShareDel(@ComputerName, $sShareName)
		If @error Then MsgBox($MB_SYSTEMMODAL, "Information", "Share delete error : " & @error)
		_MemoWrite(@CRLF & "Share deleted")

		; Loop until the user exits.
		Do
		Until GUIGetMsg() = $GUI_EVENT_CLOSE
	EndIf
EndFunc   ;==>Example
