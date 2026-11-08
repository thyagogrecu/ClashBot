; using AutoIt Function

#include <GuiAVI.au3>
#include <GUIConstantsEx.au3>

_Example_Internal()

Func _Example_Internal()
	Local $idAvi_AVI, $idBtn_Start, $idBtn_Stop, $idBtn_Show

	; Create GUI
	GUICreate("(Internal) AVI Play", 350, 200)
	$idAvi_AVI = GUICtrlCreateAvi(@SystemDir & "\shell32.dll", 160, 10, 10)
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
				_GUICtrlAVI_Play($idAvi_AVI)
			Case $idBtn_Stop
				; Stop AVI clip
				_GUICtrlAVI_Stop($idAvi_AVI)
			Case $idBtn_Show
				If GUICtrlRead($idBtn_Show) = "hide" Then
					_GUICtrlAVI_Show($idAvi_AVI, @SW_HIDE)
					GUICtrlSetData($idBtn_Show, "show")
				Else
					_GUICtrlAVI_Show($idAvi_AVI, @SW_SHOW)
					GUICtrlSetData($idBtn_Show, "hide")
				EndIf
		EndSwitch
	WEnd

	; Close AVI clip
	_GUICtrlAVI_Close($idAvi_AVI)

	GUIDelete()
EndFunc   ;==>_Example_Internal
