#include "Extras\HelpFileInternals.au3"

#include <GuiAVI.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $sWow64 = ""
	If @AutoItX64 Then $sWow64 = "\Wow6432Node"
	Local $hGUI, $hAVI, $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $sWow64 & "\AutoIt v3\AutoIt", "InstallDir") & "\Examples\GUI\SampleAVI.avi"
	Local $idBtn_StartStop

	; Create GUI
	$hGUI = GUICreate("(External) AVI Open", 300, 200)
	$hAVI = _GUICtrlAVI_Create($hGUI, "", -1, 10, 10)
	$idBtn_StartStop = GUICtrlCreateButton("Start", 50, 10, 75, 25)
	_MemoCreate(10, 50, 276, 144, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Play the sample AutoIt AVI
	_GUICtrlAVI_Open($hAVI, $sFile)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $idBtn_StartStop
				If GUICtrlRead($idBtn_StartStop) = "Start" Then
					_GUICtrlAVI_Play($hAVI)
					GUICtrlSetData($idBtn_StartStop, "Stop")
				Else
					_GUICtrlAVI_Stop($hAVI)
					GUICtrlSetData($idBtn_StartStop, "Start")
				EndIf
				_MemoWrite("Is Playing: " & _GUICtrlAVI_IsPlaying($hAVI))

			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	; Close AVI clip
	_GUICtrlAVI_Close($hAVI)

	GUIDelete()
EndFunc   ;==>Example
