;~ #RequireAdmin
; the Windows API "SetTimeZoneInformation" need "SeTimeZonePrivilege" so you have to use #RequireAdmin

#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIError.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Date_Time Get/Set Time ZoneInformation (v" & @AutoItVersion & ")", 460, 460)
	_MemoCreate(2, 2, 456, 456, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	; Show current time zone information
	Local $aOld = _Date_Time_GetTimeZoneInformation()
	ShowTimeZoneInformation($aOld, "Current")

	; Set new time zone information , just name's updates
	If Not _Date_Time_SetTimeZoneInformation($aOld[1], "A3L CST", $aOld[3], $aOld[4], "A3L CDT", $aOld[6], $aOld[7]) Then
		MsgBox($MB_SYSTEMMODAL, "Error", "System timezone cannot be SET @error=" & @error & @CRLF & @CRLF & _WinAPI_GetErrorMessage(@extended))
		Exit
	EndIf

	; Show new time zone information
	Local $aNew = _Date_Time_GetTimeZoneInformation()
	ShowTimeZoneInformation($aNew, "New")

	; Reset original time zone information
	_Date_Time_SetTimeZoneInformation($aOld[1], $aOld[2], $aOld[3], $aOld[4], $aOld[5], $aOld[6], $aOld[7])

	; Show current time zone information
	$aOld = _Date_Time_GetTimeZoneInformation()
	ShowTimeZoneInformation($aOld, "Reset")

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Show time zone information
Func ShowTimeZoneInformation(ByRef $aInfo, $sComment)
	_MemoWrite("******************* " & $sComment & " *******************")
	Local $sResult = "TIME_ZONE_ID_INVALID"
	Switch $aInfo[0]
		Case 0
			$sResult = "TIME_ZONE_ID_UNKNOWN"
		Case 1
			$sResult = "TIME_ZONE_ID_STANDARD"
		Case 2
			$sResult = "TIME_ZONE_ID_DAYLIGHT"
	EndSwitch
	_MemoWrite("Result ............: " & $sResult)
	_MemoWrite("Current bias ......: " & $aInfo[1])
	_MemoWrite("Standard name .....: " & $aInfo[2])
	_MemoWrite("Standard date/time : " & _Date_Time_SystemTimeToDateTimeStr($aInfo[3]))
	_MemoWrite("Standard bias......: " & $aInfo[4])
	_MemoWrite("Daylight name .....: " & $aInfo[5])
	_MemoWrite("Daylight date/time : " & _Date_Time_SystemTimeToDateTimeStr($aInfo[6]))
	_MemoWrite("Daylight bias......: " & $aInfo[7])
EndFunc   ;==>ShowTimeZoneInformation
