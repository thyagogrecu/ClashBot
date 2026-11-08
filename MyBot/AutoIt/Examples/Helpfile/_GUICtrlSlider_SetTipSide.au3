#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>

Example()

Func Example()
	Local $idRdo_Bottom, $idRdo_Left, $idRdo_Right, $idRdo_Top, $idSlider, $idSlider2

	; Create GUI
	GUICreate("Slider Set Tip Side", 400, 296)
	$idSlider = GUICtrlCreateSlider(2, 2, 375, 20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	$idSlider2 = GUICtrlCreateSlider(380, 2, 20, 292, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS, $TBS_VERT))
	GUISetState(@SW_SHOW)

	GUICtrlCreateGroup("Tip Side Horiz", 2, 25, 120, 120)
	$idRdo_Bottom = GUICtrlCreateRadio("Bottom", 5, 40, 108, 20)
	$idRdo_Top = GUICtrlCreateRadio("Top", 5, 115, 108, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetState($idRdo_Top, $GUI_CHECKED)

	GUICtrlCreateGroup("Tip Side Vert", 130, 25, 120, 120)
	$idRdo_Left = GUICtrlCreateRadio("Left", 132, 65, 108, 20)
	$idRdo_Right = GUICtrlCreateRadio("Right", 132, 90, 108, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetState($idRdo_Left, $GUI_CHECKED)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $idRdo_Bottom
				_GUICtrlSlider_SetTipSide($idSlider, $TBTS_BOTTOM)
			Case $idRdo_Left
				_GUICtrlSlider_SetTipSide($idSlider2, $TBTS_LEFT)
			Case $idRdo_Right
				_GUICtrlSlider_SetTipSide($idSlider2, $TBTS_RIGHT)
			Case $idRdo_Top
				_GUICtrlSlider_SetTipSide($idSlider, $TBTS_TOP)
		EndSwitch
	WEnd
	GUIDelete()
EndFunc   ;==>Example
