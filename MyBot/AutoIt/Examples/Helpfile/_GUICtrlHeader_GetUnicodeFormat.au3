#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get/Set UnicodeFormat (v" & @AutoItVersion & ")", 450, 300, 100, 100)

	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 52, 444, 220)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Show Unicode format
	_MemoWrite("Using Unicode characters: " & _GUICtrlHeader_GetUnicodeFormat($hHeader))

	; Set ANSI format
	_GUICtrlHeader_SetUnicodeFormat($hHeader, False)

	; Show ANSI format
	_MemoWrite("Using Unicode characters: " & _GUICtrlHeader_GetUnicodeFormat($hHeader))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
