#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Set HotDivider (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 52, 444, 220)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	Local $iIndex, $hBegin

	; Loop until the user exits.
	Do
		If TimerDiff($hBegin) > 500 Then
			$iIndex = Mod($iIndex + 1, 4)
			_GUICtrlHeader_SetHotDivider($hHeader, False, $iIndex)
			$hBegin = TimerInit()
		EndIf
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

EndFunc   ;==>Example
