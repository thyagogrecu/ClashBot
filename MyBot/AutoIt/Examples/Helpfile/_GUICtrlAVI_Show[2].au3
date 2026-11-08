#include <GuiAVI.au3>
#include <GUIConstantsEx.au3>

_Example_External()

Func _Example_External()
	Local $hGUI, $hAVI, $idBtn_Start, $idBtn_Stop, $idBtn_Show

	; Create GUI
	$hGUI = GUICreate("(External) AVI Play", 350, 200)
	$hAVI = _GUICtrlAVI_Create($hGUI, @SystemDir & "\Shell32.dll", 160, 10, 10)
	$idBtn_Start = GUICtrlCreateButton("start", 25, 150, 70, 22)
	$idBtn_Stop = GUICtrlCreateButton("stop", 125, 150, 70, 22)
	$idBtn_Show = GUICtrlCreateButton("hide", 225, 150, 70, 22)
	GUISetState(@SW_SHOW)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idBtn_Start
				; Play part of the AVI clip
				_GUICtrlAVI_Play($hAVI)
			Case $idBtn_Stop
				; Stop AVI clip
				_GUICtrlAVI_Stop($hAVI)
			Case $idBtn_Show
				If GUICtrlRead($idBtn_Show) = "hide" Then
					_GUICtrlAVI_Show($hAVI, @SW_HIDE)
					GUICtrlSetData($idBtn_Show, "show")
				Else
					_GUICtrlAVI_Show($hAVI, @SW_SHOW)
					GUICtrlSetData($idBtn_Show, "hide")
				EndIf
		EndSwitch
	WEnd

	; Close AVI clip
	_GUICtrlAVI_Close($hAVI)

	GUIDelete()
EndFunc   ;==>_Example_External
