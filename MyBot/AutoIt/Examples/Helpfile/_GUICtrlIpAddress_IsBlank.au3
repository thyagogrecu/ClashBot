#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>

Example()

Func Example()
	Local $hGui, $hIPAddress

	$hGui = GUICreate("IP Address Control IsBlank Example", 400, 300)
	$hIPAddress = _GUICtrlIpAddress_Create($hGui, 2, 4)
	_MemoCreate(2, 28, 396, 270, 0)
	GUISetState(@SW_SHOW)

	; See if IP Address is blank
	_MemoWrite("Blank: " & _GUICtrlIpAddress_IsBlank($hIPAddress))

	Sleep(1000)

	_GUICtrlIpAddress_Set($hIPAddress, "24.168.2.128")

	; See if IP Address is blank
	_MemoWrite("Blank: " & _GUICtrlIpAddress_IsBlank($hIPAddress))

	; Wait for user to close GUI
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
