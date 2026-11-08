#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <WinAPIConstants.au3>
#include <WinAPIDlg.au3>
#include <WindowsStylesConstants.au3>

_Example_Defaults()
_Example_ExplorerStyle()
_Example_OldStyle()
_Example_ExplorerStyle_NoPlaceBar()

Func _Example_Defaults()
	Local $hGui, $idBtn_Dialog, $aFile, $sError

	; Create GUI
	$hGui = GUICreate("GetSaveFileName use defaults", 400, 296)
	_MemoCreate(2, 32, 396, 226, $WS_HSCROLL)
	$idBtn_Dialog = GUICtrlCreateButton("Save Dialog", 155, 270, 90, 20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $idBtn_Dialog
				$aFile = _WinAPI_GetSaveFileName() ; use defaults
				If @error Then
					Local $iError = @error
					Local $iExtended = @extended
					$sError = _WinAPI_CommDlgExtendedError()
					_MemoWrite("CommDlgExtendedError (" & $iError & "/" & $iExtended & "): " & $sError)
				Else
					For $x = 1 To $aFile[0]
						_MemoWrite($aFile[$x])
					Next
				EndIf
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($hGui)
EndFunc   ;==>_Example_Defaults

Func _Example_ExplorerStyle()
	Local $hGui, $idBtn_Dialog, $aFile, $sError

	; Create GUI
	$hGui = GUICreate("GetSaveFileName use Explorer Style", 400, 296)
	_MemoCreate(2, 32, 396, 226, $WS_HSCROLL)
	$idBtn_Dialog = GUICtrlCreateButton("Save Dialog", 155, 270, 90, 20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $idBtn_Dialog
				$aFile = _WinAPI_GetSaveFileName("My Save File Dialog", _
						"Text File (*.txt)|AutoIt File (*.au3)", ".", _
						"", "au3", 2, 0, 0, $hGui)
				If @error Then
					Local $iError = @error
					Local $iExtended = @extended
					$sError = _WinAPI_CommDlgExtendedError()
					_MemoWrite("CommDlgExtendedError (" & $iError & "/" & $iExtended & "): " & $sError)
				Else
					For $x = 1 To $aFile[0]
						_MemoWrite($aFile[$x])
					Next
				EndIf
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($hGui)
EndFunc   ;==>_Example_ExplorerStyle

Func _Example_OldStyle()
	Local $hGui, $idBtn_Dialog, $aFile, $sError

	; Create GUI
	$hGui = GUICreate("GetSaveFileName use Old Style", 400, 296)
	_MemoCreate(2, 32, 396, 226, $WS_HSCROLL)
	$idBtn_Dialog = GUICtrlCreateButton("Save Dialog", 155, 270, 90, 20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $idBtn_Dialog
				$aFile = _WinAPI_GetSaveFileName("My Save File Dialog", _
						"Text File (*.txt)|AutoIt File (*.au3)", ".", "", _
						"", 2, $OFN_ALLOWMULTISELECT, 0, $hGui)
				If @error Then
					Local $iError = @error
					Local $iExtended = @extended
					$sError = _WinAPI_CommDlgExtendedError()
					_MemoWrite("CommDlgExtendedError (" & $iError & "/" & $iExtended & "): " & $sError)
				Else
					For $x = 1 To $aFile[0]
						_MemoWrite($aFile[$x])
					Next
				EndIf
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($hGui)
EndFunc   ;==>_Example_OldStyle

Func _Example_ExplorerStyle_NoPlaceBar()
	Local $hGui, $idBtn_Dialog, $aFile, $sError

	; Create GUI
	$hGui = GUICreate("GetSaveFileName use Explorer Style No Place Bar", 400, 296)
	_MemoCreate(2, 32, 396, 226, $WS_HSCROLL)
	$idBtn_Dialog = GUICtrlCreateButton("Save Dialog", 155, 270, 90, 20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $idBtn_Dialog
				$aFile = _WinAPI_GetSaveFileName("My Save File Dialog", _
						"Text File (*.txt)|AutoIt File (*.au3)", ".", "", _
						"", 2, 0, $OFN_EX_NOPLACESBAR, $hGui)
				If @error Then
					Local $iError = @error
					Local $iExtended = @extended
					$sError = _WinAPI_CommDlgExtendedError()
					_MemoWrite("CommDlgExtendedError (" & $iError & "/" & $iExtended & "): " & $sError)
				Else
					For $x = 1 To $aFile[0]
						_MemoWrite($aFile[$x])
					Next
				EndIf
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($hGui)
EndFunc   ;==>_Example_ExplorerStyle_NoPlaceBar
