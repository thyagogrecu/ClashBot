#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Tab Control Get/Set Item State (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $idTab = GUICtrlCreateTab(2, 2, 446, 266, $TCS_BUTTONS)
	_MemoMsgBoxStatus() ; Status creation

	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 0")
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 1")
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 2")

	; Get/Set tab 1 state
	_GUICtrlTab_SetItemState($idTab, 1, $TCIS_BUTTONPRESSED)
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Tab 1 state: " & _ExplainItemState(_GUICtrlTab_GetItemState($idTab, 1)))

	; Get/Set tab 2 state
	_MemoMsgBox($MB_SYSTEMMODAL, "Information", "Tab 2 state: " & _ExplainItemState(_GUICtrlTab_GetItemState($idTab, 2)))

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example

Func _ExplainItemState($iState)
	Local $sText = ""
	If $iState = 0 Then $sText &= "No state set on this item" & @CRLF
	If BitAND($iState, $TCIS_BUTTONPRESSED) Then $sText &= "Button Pressed" & @CRLF
	If BitAND($iState, $TCIS_HIGHLIGHTED) Then $sText &= "Button Highlighted"
	Return $sText
EndFunc   ;==>_ExplainItemState
