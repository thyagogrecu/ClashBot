#include "Extras\HelpFileInternals.au3"

#include <AutoItConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiReBar.au3>
#include <WinAPIError.au3>
#include <WinAPIRes.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hGUI, $idInput, $idBtn_Get, $hReBar, $hInstance, $sText
	; Create GUI
	$hGUI = GUICreate("WinAPI", 400, 396)

	$idInput = GUICtrlCreateInput("4209", 0, 0, 100, 20)

	; create the rebar control
	$hReBar = _GUICtrlRebar_Create($hGUI, BitOR($CCS_TOP, $WS_BORDER, $RBS_VARHEIGHT, $RBS_AUTOSIZE, $RBS_BANDBORDERS))

	_MemoCreate(2, 55, 396, 200, BitOR($WS_VSCROLL, $WS_HSCROLL))

	;add band containing the  control
	_GUICtrlRebar_AddBand($hReBar, GUICtrlGetHandle($idInput), 120, 200, "String ID:")

	$idBtn_Get = GUICtrlCreateButton("Get String", 0, 0, 90, 20)

	;add band containing the  control
	_GUICtrlRebar_AddBand($hReBar, GUICtrlGetHandle($idBtn_Get), 120, 200)

	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $idBtn_Get
				GUICtrlSetData($_g_idLst_Memo, "")
				$hInstance = _WinAPI_LoadLibraryEx("shell32.dll", $LOAD_LIBRARY_AS_DATAFILE)
				If $hInstance Then
					$sText = _WinAPI_LoadString($hInstance, GUICtrlRead($idInput))
					If Not @error Then
						_MemoWrite('Got the String (chars: ' & @extended & '): ' & @CRLF & $sText)
					Else
						_MemoWrite("Last Error Message: " & @CRLF & _WinAPI_GetLastErrorMessage())
					EndIf
					_MemoWrite(@CRLF & "Success Freeing? " & _WinAPI_FreeLibrary($hInstance))
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Example
