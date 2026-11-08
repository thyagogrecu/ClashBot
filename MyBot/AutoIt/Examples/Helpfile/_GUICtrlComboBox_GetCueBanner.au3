#include "Extras\HelpFileInternals.au3"

#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("ComboBox Get/Set Cue Banner (v" & @AutoItVersion & ")", 400, 296)
	Local $idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	_GUICtrlComboBox_SetCueBanner($idCombo, "Select an Item")
	_MemoCreate(10, 50, 376, 234, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_BeginUpdate($idCombo)
	_GUICtrlComboBox_AddDir($idCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($idCombo)

	_MemoWrite("Cue Banner: " & _GUICtrlComboBox_GetCueBanner($idCombo))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
