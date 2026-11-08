#include "Extras\HelpFileInternals.au3"

#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Hit Test (v" & @AutoItVersion & ")", 450, 300, 100, 100)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_MemoCreate(2, 52, 444, 220)

;~ 	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)

	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Do a hit test on column 1
	Local $aHT = _GUICtrlHeader_HitTest($hHeader, 110, 10)
	_MemoWrite("Item index ...................: " & $aHT[0])
	_MemoWrite("In client window .............: " & $aHT[1])
	_MemoWrite("In control rectangle .........: " & $aHT[2])
	_MemoWrite("On divider ...................: " & $aHT[3])
	_MemoWrite("On zero width divider ........: " & $aHT[4])
	_MemoWrite("Over filter area .............: " & $aHT[5])
	_MemoWrite("Over filter button ...........: " & $aHT[6])
	_MemoWrite("Above bounding rectangle .....: " & $aHT[7])
	_MemoWrite("Below bounding rectangle .....: " & $aHT[8])
	_MemoWrite("To right of bounding rectangle: " & $aHT[9])
	_MemoWrite("To left of bounding rectangle : " & $aHT[10])

	_MemoMsgBoxStatus("", -1, $hGUI) ; no more action, wait GUI for closing

EndFunc   ;==>Example
