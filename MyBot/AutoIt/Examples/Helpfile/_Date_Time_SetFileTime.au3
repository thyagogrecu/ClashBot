#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIError.au3>
#include <WinAPIFiles.au3>
#include <WinAPIHObj.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $hFile, $tFile, $aTime
	Local $sTempFile = @TempDir & "\Test.xyz"

	; Create GUI
	GUICreate("Time", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Create test file and set file times
	$hFile = _WinAPI_CreateFile($sTempFile, 1)
	If $hFile = 0 Then _WinAPI_ShowError("Unable to create file")
	$tFile = _Date_Time_EncodeFileTime(@MON, @MDAY, @YEAR, @HOUR, @MIN, @SEC)
	_Date_Time_SetFileTime($hFile, $tFile, $tFile, $tFile)
	_WinAPI_CloseHandle($hFile)

	; Read file times
	$hFile = _WinAPI_CreateFile($sTempFile, 2)
	If $hFile = 0 Then _WinAPI_ShowError("Unable to open file")
	$aTime = _Date_Time_GetFileTime($hFile)
	_WinAPI_CloseHandle($hFile)

	_MemoWrite("Created ..: " & _Date_Time_FileTimeToStr($aTime[0]))
	_MemoWrite("Accessed .: " & _Date_Time_FileTimeToStr($aTime[1]))
	_MemoWrite("Modified .: " & _Date_Time_FileTimeToStr($aTime[2]))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	FileDelete($sTempFile)
EndFunc   ;==>Example
