#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <NetShare.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $sServer

	; Create GUI
	GUICreate("NetShare", 400, 300)

	; Create memo control
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Get server and share information
	$sServer = InputBox("NetWork Demo", "Enter Server Name:", "\\MyServer", "", 200, 130)
	If @error Then Exit

	; Delete all our sessions on the server
	_Net_Share_SessionDel($sServer, @ComputerName)
	_MemoWrite("Error ...................: " & @error)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
