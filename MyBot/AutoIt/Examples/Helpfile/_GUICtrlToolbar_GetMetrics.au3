#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiToolbar.au3>
#include <WinAPIConstants.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Toolbar Get/Set Metrics (v" & @AutoItVersion & ")", 400, 300)
	Local $hToolbar = _GUICtrlToolbar_Create($hGUI)
	_MemoCreate(2, 36, 396, 262, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlToolbar_SetUnicodeFormat($hToolbar, False)

	; Add standard system bitmaps
	Switch _GUICtrlToolbar_GetBitmapFlags($hToolbar)
		Case 0
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_SMALL_COLOR)
		Case 2
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)
	EndSwitch

	; Add buttons
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $e_idHelp
	_GUICtrlToolbar_AddButton($hToolbar, $e_idNew, $STD_FILENEW)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idOpen, $STD_FILEOPEN)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idSave, $STD_FILESAVE)
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idHelp, $STD_HELP)

	_MemoWrite("Before _GUICtrlToolbar_SetMetrics")

	Sleep(1000)
	GUISetState(@SW_LOCK)
	; Set control metrics
	_MemoWrite("Step 1:")
	_MemoWrite("$iXPad = 10")
	_GUICtrlToolbar_SetMetrics($hToolbar, 10, 0, 0, 0)
	GUISetState(@SW_UNLOCK)
	_MemoWrite("==> No effect")

	Sleep(2000)
	GUISetState(@SW_LOCK)
	; Set control metrics
	_MemoWrite("Step 2:")
	_MemoWrite("$iYPad = 10")
	_GUICtrlToolbar_SetMetrics($hToolbar, 0, 10, 0, 0)
	GUISetState(@SW_UNLOCK)
	_MemoWrite("==> No effect")

	Sleep(2000)
	GUISetState(@SW_LOCK)
	; Set control metrics
	_MemoWrite("Step 3:")
	_MemoWrite("$iXSpacing = 10")
	_GUICtrlToolbar_SetMetrics($hToolbar, 0, 0, 10, 0)
	GUISetState(@SW_UNLOCK)
	_MemoWrite("==> buttons are spaced")

	Sleep(2000)
	GUISetState(@SW_LOCK)
	; Set control metrics
	_MemoWrite("Step 4:")
	_MemoWrite("$iYSpacing = 10")
	_GUICtrlToolbar_SetMetrics($hToolbar, 0, 0, 0, 10)
	GUISetState(@SW_UNLOCK)
	_MemoWrite("==> No effect has only one line of buttons")

	Sleep(2000)
	GUISetState(@SW_LOCK)
	; Set control metrics
	_MemoWrite("")
	_MemoWrite("Step 5:")
	_MemoWrite("$iXPad = 10")
	_MemoWrite("$iYPad = 10")
	_MemoWrite("$iXSpacing = 10")
	_MemoWrite("$iYSpacing = 10")
	_GUICtrlToolbar_SetMetrics($hToolbar, 10, 10, 10, 10)
	GUISetState(@SW_UNLOCK)
	_MemoWrite("==> Spaced just because $iXpacing is not 0")

	; Show control metrics
	Local $aMetrics = _GUICtrlToolbar_GetMetrics($hToolbar)
	_MemoWrite("")
	_MemoWrite("Button padding width ...: " & $aMetrics[0])
	_MemoWrite("Button padding height ..: " & $aMetrics[1])
	_MemoWrite("Button spacing width ...: " & $aMetrics[2])
	_MemoWrite("Button spacing height ..: " & $aMetrics[3])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
