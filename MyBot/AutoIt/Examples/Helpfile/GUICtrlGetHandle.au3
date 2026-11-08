#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	GUICreate("My GUI", 300, 200)

	Local $idMnu_File = GUICtrlCreateMenu("&File")
	GUICtrlCreateMenuItem("&Open", $idMnu_File)
	GUICtrlCreateMenuItem("&Save", $idMnu_File)
	GUICtrlCreateMenuItem("", $idMnu_File)

	Local $idMnu_Options = GUICtrlCreateMenu("O&ptions", $idMnu_File)
	GUICtrlCreateMenuItem("View", $idMnu_Options)
	GUICtrlCreateMenuItem("", $idMnu_Options)
	GUICtrlCreateMenuItem("Tools", $idMnu_Options)

	GUICtrlCreateMenuItem("", $idMnu_File)
	Local $idMni_Exit = GUICtrlCreateMenuItem("&Exit", $idMnu_File)

	Local $idMnu_Help = GUICtrlCreateMenu("&?")
	Local $idMni_About = GUICtrlCreateMenuItem("&About", $idMnu_Help)

	Local $idBtn_End = GUICtrlCreateButton("End", 110, 140, 70, 20)

	SetMenuColor($idMnu_File, 0xEEBB99) ; BGR color value
	SetMenuColor($idMnu_Options, 0x66BB99) ; BGR color value
	SetMenuColor($idMnu_Help, 0x99BBEE) ; BGR color value

	GUISetState(@SW_SHOW)

	Local $idMsg
	; Loop until the user exits.
	While 1
		$idMsg = GUIGetMsg()

		Switch $idMsg
			Case $idMni_Exit, $idBtn_End, $GUI_EVENT_CLOSE
				ExitLoop

			Case $idMni_About
				MsgBox($MB_SYSTEMMODAL, "About...", "Colored menu sample")
		EndSwitch
	WEnd
EndFunc   ;==>Example

; Apply the color to the menu
Func SetMenuColor($nMenuID, $nColor)
	Local Const $MIM_APPLYTOSUBMENUS = 0x80000000
	Local Const $MIM_BACKGROUND = 0x00000002

	Local $hMenu = GUICtrlGetHandle($nMenuID)

	Local $hBrush = DllCall("gdi32.dll", "hwnd", "CreateSolidBrush", "int", $nColor)
	$hBrush = $hBrush[0]

	Local $tMenuInfo = DllStructCreate("dword;dword;dword;uint;dword;dword;ptr")
	DllStructSetData($tMenuInfo, 1, DllStructGetSize($tMenuInfo))
	DllStructSetData($tMenuInfo, 2, BitOR($MIM_APPLYTOSUBMENUS, $MIM_BACKGROUND))
	DllStructSetData($tMenuInfo, 5, $hBrush)

	DllCall("user32.dll", "int", "SetMenuInfo", "hwnd", $hMenu, "struct*", $tMenuInfo)

	; release Struct not really needed as it is a local
	$tMenuInfo = 0
EndFunc   ;==>SetMenuColor
