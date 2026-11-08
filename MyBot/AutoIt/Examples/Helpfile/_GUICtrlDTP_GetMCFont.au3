#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiDateTimePicker.au3>
#include <StructureConstants.au3>
#include <WinAPIGdi.au3>

Example()

Func Example()
	; Create GUI
	Local $hGui = GUICreate("DateTimePick Get/Set MCFont (v" & @AutoItVersion & ")", 400, 300)
	Local $hDTP = _GUICtrlDTP_Create($hGui, 2, 6, 190)
	_MemoCreate(2, 32, 396, 266, 0)
	GUISetState(@SW_SHOW)

	; Set the display format
	_GUICtrlDTP_SetFormat($hDTP, "ddd MMM dd, yyyy hh:mm ttt")

	; Create a new font for the month control
	Local $tLOGFONT = DllStructCreate($tagLOGFONT)
	DllStructSetData($tLOGFONT, "Height", 13)
	DllStructSetData($tLOGFONT, "Weight", 400)
	DllStructSetData($tLOGFONT, "FaceName", "Verdana")
	Local $hFont = _WinAPI_CreateFontIndirect($tLOGFONT)
	_GUICtrlDTP_SetMCFont($hDTP, $hFont)

	; Get month control font handle
	_MemoWrite("Font Handle: " & "0x" & Hex(_GUICtrlDTP_GetMCFont($hDTP), 6))
	_MemoWrite("IsPtr  = " & IsPtr(_GUICtrlDTP_GetMCFont($hDTP)) & " IsHWnd  = " & IsHWnd(_GUICtrlDTP_GetMCFont($hDTP)))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
