#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>
#include <Timers.au3>
#include <WindowsStylesConstants.au3>

Global $g_hStatus, $g_idProgress, $g_iPercent = 0, $g_iDirection = 1

_Example_CallBack()

Func _Example_CallBack()
	Local $hGUI, $iTimerProgress, $idBtn_Change, $iWait = 10, $idBtn_State
	Local $aParts[3] = [75, 330, -1]

	$hGUI = GUICreate("Timers Using CallBack Function(s)", 400, 320)
	_MemoCreate(2, 32, 396, 226, BitOR($WS_HSCROLL, $WS_VSCROLL))
	$idBtn_State = GUICtrlCreateButton("Start Progress Bar", 70, 270, 100, 25)
	$idBtn_Change = GUICtrlCreateButton("Change", 215, 270, 90, 25)
	GUICtrlSetState($idBtn_Change, $GUI_DISABLE)
	$g_hStatus = _GUICtrlStatusBar_Create($hGUI, $aParts)
	_GUICtrlStatusBar_SetText($g_hStatus, "Timers")
	_GUICtrlStatusBar_SetText($g_hStatus, @TAB & @TAB & StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC), 2)
	$g_idProgress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
	GUICtrlSetColor($g_idProgress, 0xff0000)
	_GUICtrlStatusBar_EmbedControl($g_hStatus, 1, GUICtrlGetHandle($g_idProgress))
	GUISetState(@SW_SHOW)

	_Timer_SetTimer($hGUI, 1000, "_UpdateStatusBarClock") ; create timer

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idBtn_State
				If GUICtrlRead($idBtn_State) = "Start Progress Bar" Then
					$iTimerProgress = _Timer_SetTimer($hGUI, $iWait, "_UpdateProgressBar") ; create timer
					If @error Or $iTimerProgress = 0 Then ContinueLoop
					GUICtrlSetData($idBtn_State, "Stop Progress Bar")
					GUICtrlSetState($idBtn_Change, $GUI_ENABLE)
				Else
					GUICtrlSetState($idBtn_Change, $GUI_DISABLE)
					_Timer_KillTimer($hGUI, $iTimerProgress)
					GUICtrlSetData($idBtn_State, "Start Progress Bar")
				EndIf

			Case $idBtn_Change
				If $iWait = 10 Then
					$iWait = 250
				Else
					$iWait = 10
				EndIf
				_MemoWrite("Timer for _UpdateProgressBar set at: " & $iWait & " milliseconds")
				$iTimerProgress = _Timer_SetTimer($hGUI, $iWait, "", $iTimerProgress) ; reuse timer with different interval
		EndSwitch
	WEnd
	ConsoleWrite("Killed All Timers? " & _Timer_KillAllTimers($hGUI) & @CRLF) ; must be True as the timer to "_UpdateStatusBarClock" have not been killed
	GUIDelete()
EndFunc   ;==>_Example_CallBack

; call back function
Func _UpdateStatusBarClock($hWnd, $iMsg, $iIDTimer, $iTime)
	#forceref $hWnd, $iMsg, $iIDTimer, $iTime
	_GUICtrlStatusBar_SetText($g_hStatus, @TAB & @TAB & StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC), 2)
EndFunc   ;==>_UpdateStatusBarClock

; call back function
Func _UpdateProgressBar($hWnd, $iMsg, $iIDTimer, $iTime)
	#forceref $hWnd, $iMsg, $iIDTimer, $iTime
	$g_iPercent += 5 * $g_iDirection
	GUICtrlSetData($g_idProgress, $g_iPercent)
	If $g_iPercent = 100 Or $g_iPercent = 0 Then $g_iDirection *= -1
	If $g_iPercent = 100 Then
		GUICtrlSetColor($g_idProgress, 0xff0000)
	ElseIf $g_iPercent = 0 Then
		GUICtrlSetColor($g_idProgress, 0x0000ff)
	EndIf
EndFunc   ;==>_UpdateProgressBar
