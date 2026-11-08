#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>
#include <SendMessage.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Embed Control (v" & @AutoItVersion & ")", 450, 320, 100, 100)

	; defaults to 1 part, no text
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI)

	; Create memo control
	_MemoCreate(2, 8, 444, 259)

	_GUICtrlStatusBar_SetMinHeight($hStatus, 20)

	GUISetState(@SW_SHOW)

	; Initialize parts
	Local $aParts[4] = [80, 160, 300, -1]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Part 0")
	_GUICtrlStatusBar_SetText($hStatus, "Part 1", 1)

	; Embed a progress bar
	Local $hProgress, $idProgress
	If @OSType = "WIN32_WINDOWS" Then
		$idProgress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_SMOOTH)
		$hProgress = GUICtrlGetHandle($idProgress)
		_GUICtrlStatusBar_EmbedControl($hStatus, 2, $hProgress)
	Else
		$idProgress = GUICtrlCreateProgress(0, 0, -1, -1, $PBS_MARQUEE) ; marquee works on Win XP and above
		$hProgress = GUICtrlGetHandle($idProgress)
		_GUICtrlStatusBar_EmbedControl($hStatus, 2, $hProgress)
		_SendMessage($hProgress, $PBM_SETMARQUEE, True, 200) ; marquee works on Win XP and above
	EndIf

	Local $idInput = GUICtrlCreateInput("This is Embedded", 0, 0)
	Local $hInput = GUICtrlGetHandle($idInput)
	_GUICtrlStatusBar_EmbedControl($hStatus, 3, $hInput, 3)

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
