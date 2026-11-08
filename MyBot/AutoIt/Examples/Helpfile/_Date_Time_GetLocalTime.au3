#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIError.au3>
#include <WindowsStylesConstants.au3>

; Under Vista and over the Windows API "SetLocalTime" may be rejected due to system security

Example()

Func Example()
	; Create GUI
	GUICreate("Date_Time Get/Set LocalTime (v" & @AutoItVersion & ")", 400, 300)
	_MemoCreate(2, 2, 396, 296, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Show current local time
	Local $tCur = _Date_Time_GetLocalTime()
	_MemoWrite("Current date/time .: " & _Date_Time_SystemTimeToDateTimeStr($tCur))

	; Set new local time
	Local $tNew = _Date_Time_EncodeSystemTime(8, 19, @YEAR, 3, 10, 45)
	If Not _Date_Time_SetLocalTime($tNew) Then
		MsgBox($MB_SYSTEMMODAL, "Error", "System clock cannot be SET" & @CRLF & @CRLF & _WinAPI_GetLastErrorMessage())
		Exit
	EndIf
	$tNew = _Date_Time_GetLocalTime()
	_MemoWrite("New date/time .....: " & _Date_Time_SystemTimeToDateTimeStr($tNew))

	; Reset local time
	_Date_Time_SetLocalTime($tCur)

	; Show current local time
	$tCur = _Date_Time_GetLocalTime()
	_MemoWrite("Current date/time .: " & _Date_Time_SystemTimeToDateTimeStr($tCur))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
