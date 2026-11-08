#include <GUIConstantsEx.au3>
#include <WinAPISysWin.au3>

Example()

Func Example()
	Local $hWnd, $idInp_Flash, $idInp_Timeout, $idBtn_Flash, $iMsg, $iFlashrate, $iTimeoutrate, $bFlashing = False
	$hWnd = GUICreate("Form1", 229, 170, 193, 125)
	$idInp_Flash = GUICtrlCreateInput("20", 80, 72, 121, 21)
	$idInp_Timeout = GUICtrlCreateInput("500", 80, 103, 121, 21)
	GUICtrlCreateLabel("Please input the flash rate, and the time between flashes", 8, 24, 214, 41)
	GUICtrlCreateLabel("Flash Rate:", 16, 72, 58, 17)
	GUICtrlCreateLabel("Timeout (ms)", 16, 104, 64, 17)
	$idBtn_Flash = GUICtrlCreateButton("Flash Window", 80, 136, 75, 25, 0)
	GUISetState(@SW_SHOW)

	While 1
		$iMsg = GUIGetMsg()
		Switch $iMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $idBtn_Flash
				If $bFlashing Then
					_WinAPI_FlashWindowEx($hWnd, 0)
					$bFlashing = False
				Else
					$iFlashrate = GUICtrlRead($idInp_Flash)
					$iTimeoutrate = GUICtrlRead($idInp_Timeout)
					_WinAPI_FlashWindowEx($hWnd, 2, $iFlashrate, $iTimeoutrate)
					GUICtrlSetData($idBtn_Flash, "Stop Flashing")
					$bFlashing = True
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Example
