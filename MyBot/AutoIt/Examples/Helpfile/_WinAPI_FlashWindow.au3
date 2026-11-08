#include <GUIConstantsEx.au3>
#include <WinAPISysWin.au3>

Example()

Func Example()
	Local $hWnd, $iMsg, $idBtn_Flash
	$hWnd = GUICreate("_WinAPI_FlashWindow Example", 200, 200)
	$idBtn_Flash = GUICtrlCreateButton("Flash Window", 50, 85, 100, 30)
	GUISetState(@SW_SHOW)
	While 1
		$iMsg = GUIGetMsg()
		Select
			Case $iMsg = $GUI_EVENT_CLOSE
				Exit
			Case $iMsg = $idBtn_Flash
				GUISetState(@SW_MINIMIZE)
				Sleep(1000)
				_WinAPI_FlashWindow($hWnd)
				Sleep(6000)
		EndSelect
	WEnd
EndFunc   ;==>Example
