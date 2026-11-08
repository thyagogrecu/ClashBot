#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $idSlider, $aTics

	; Create GUI
	GUICreate("Slider Get Logical Tic Positions", 400, 296)
	$idSlider = GUICtrlCreateSlider(2, 2, 300, 20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS))
	_MemoCreate(2, 32, 396, 266, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	$aTics = _GUICtrlSlider_GetLogicalTics($idSlider)
	_MemoWrite("Number Tics Excluding 1st and last .....: " & UBound($aTics))
	For $x = 0 To UBound($aTics) - 1
		_MemoWrite(StringFormat("(%02d) Logical Tick Position .............: %d", $x, $aTics[$x]))
	Next

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
