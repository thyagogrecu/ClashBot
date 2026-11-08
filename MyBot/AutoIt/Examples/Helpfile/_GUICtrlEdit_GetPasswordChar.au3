#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Edit Get/Set Password Char (v" & @AutoItVersion & ")", 400, 300)
	Local $idInp_11111 = GUICtrlCreateInput("Test of build-in control", 2, 2, 394, 25, $ES_PASSWORD)
	GUISetState(@SW_SHOW)

	MsgBox($MB_SYSTEMMODAL, "Information", "Password Char: " & _GUICtrlEdit_GetPasswordChar($idInp_11111))

	_GUICtrlEdit_SetPasswordChar($idInp_11111, "$") ; change password char to $

	MsgBox($MB_SYSTEMMODAL, "Information", "Password Char: " & _GUICtrlEdit_GetPasswordChar($idInp_11111))

	_GUICtrlEdit_SetPasswordChar($idInp_11111) ; display characters typed by the user.

	MsgBox($MB_SYSTEMMODAL, "Information", "Password Char: " & _GUICtrlEdit_GetPasswordChar($idInp_11111))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
