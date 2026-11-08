#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>

Example()

Func Example()

	Local $hGui = GUICreate("IP Address Control Get/Set Array (v" & @AutoItVersion & ")", 400, 300)
	Local $hIPAddress = _GUICtrlIpAddress_Create($hGui, 2, 4, 125, 20)
	_MemoCreate(2, 28, 396, 270, 0)
	GUISetState(@SW_SHOW)

	Local $aIP[4] = [24, 168, 2, 128]
	_GUICtrlIpAddress_SetArray($hIPAddress, $aIP)

	$aIP = _GUICtrlIpAddress_GetArray($hIPAddress)

	_MemoWrite("Field 1 .....: " & $aIP[0])
	_MemoWrite("Field 2 .....: " & $aIP[1])
	_MemoWrite("Field 3 .....: " & $aIP[2])
	_MemoWrite("Field 4 .....: " & $aIP[3])

	; Wait for user to close GUI
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
