#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WinAPISysWin.au3>

Example()

Func Example()
	Local $iMsg, $idBtn_Focus, $hWin, $sText
	GUICreate("__WinAPI_GetFocus Example", 200, 200)
	$idBtn_Focus = GUICtrlCreateButton("Get Focus", 50, 85, 100, 30)
	GUISetState(@SW_SHOW)
	While 1
		$iMsg = GUIGetMsg()
		Select
			Case $iMsg = $GUI_EVENT_CLOSE
				Exit
			Case $iMsg = $idBtn_Focus
				$hWin = _WinAPI_GetFocus()
				$sText = "Full Title: " & WinGetTitle($hWin) & @CRLF
				$sText &= "Full Text: " & WinGetText($hWin) & @CRLF
				$sText &= "Handle: " & WinGetHandle($hWin) & @CRLF
				$sText &= "Process: " & WinGetProcess($hWin) & @CRLF
				MsgBox($MB_SYSTEMMODAL, "", $sText)
		EndSelect
	WEnd
EndFunc   ;==>Example
