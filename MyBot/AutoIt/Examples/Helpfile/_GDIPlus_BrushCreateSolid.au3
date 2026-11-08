#include "Extras\HelpFileInternals.au3"

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hBrush1, $hBrush2

	; Create GUI
	GUICreate("GDI+", 400, 300)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Create brushes
	_GDIPlus_Startup()
	$hBrush1 = _GDIPlus_BrushCreateSolid()
	$hBrush2 = _GDIPlus_BrushClone($hBrush1)

	; Show brush information
	_MemoWrite("Brush 1 handle : 0x" & Hex($hBrush1))
	_MemoWrite("Brush 1 type ..: " & _GDIPlus_BrushGetType($hBrush1))
	_MemoWrite("Brush 2 handle : 0x" & Hex($hBrush2))
	_MemoWrite("Brush 2 type ..: " & _GDIPlus_BrushGetType($hBrush2))

	; Clean up resources
	_GDIPlus_BrushDispose($hBrush2)
	_GDIPlus_BrushDispose($hBrush1)
	_GDIPlus_Shutdown()

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
