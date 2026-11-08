#include "Extras\HelpFileInternals.au3"

#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("GDI+", 600, 400)
	_MemoCreate(2, 2, 596, 396, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Initialize GDI+ library
	_GDIPlus_Startup()

	; Show number of decoders/encoders
	_MemoWrite("Decoder count : " & _GDIPlus_DecodersGetCount()) ;
	_MemoWrite("Decoder size .: " & _GDIPlus_DecodersGetSize()) ;
	_MemoWrite("Encoder count : " & _GDIPlus_EncodersGetCount()) ;
	_MemoWrite("Encoder size .: " & _GDIPlus_EncodersGetSize()) ;

	; Shut down GDI+ library
	_GDIPlus_Shutdown()

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
