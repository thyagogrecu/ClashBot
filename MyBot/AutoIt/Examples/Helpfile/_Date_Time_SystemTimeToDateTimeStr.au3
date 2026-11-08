#include "Extras\HelpFileInternals.au3"

#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsStylesConstants.au3>

Example()

Func Example()
	Local $tTime

	; Create GUI
	GUICreate("Date/Time", 500, 350)
	_MemoCreate(2, 2, 496, 346, $WS_VSCROLL)
	GUISetState(@SW_SHOW)

	_MemoWrite("Current local time = " & _Now())
	_MemoWrite()

	; Show current time zone information
	Local $aOld = _Date_Time_GetTimeZoneInformation()
	ShowTimeZoneInformation($aOld, "Time Zone info")

	$tTime = _Date_Time_GetSystemTime() ; UTC
	; just formatting $tTime not $iType dependent
	_MemoWrite("System date/time (0)       : " & _Date_Time_SystemTimeToDateTimeStr($tTime, 0)) ; mm/dd/yyyy hh:mm:ss
	_MemoWrite("System date/time (1)       : " & _Date_Time_SystemTimeToDateTimeStr($tTime, 1)) ; yyyy/mm/dd hh:mm:ss
	_MemoWrite()

	; Show system date/time
	_MemoWrite("System date/time (UTC)     : " & _Date_Time_SystemTimeToDateTimeStr($tTime, 2, 1)) ; wday, nn MMM yyyy hh:mm:ss UTC : System time
	_MemoWrite("System date/time (ISO8601) : " & _Date_Time_SystemTimeToDateTimeStr($tTime, 3, 1)) ; yyyy/mm/ddThh:mm:ssZ : System time
	_MemoWrite()

	; Show local date/time
	$tTime = _Date_Time_GetLocalTime()
	_MemoWrite("Local  date/time (UTC)     : " & _Date_Time_SystemTimeToDateTimeStr($tTime, 2)) ; wday, nn MMM yyyy hh:mm:ss UTC : Local time
	_MemoWrite("Local  date/time (ISO8601) : " & _Date_Time_SystemTimeToDateTimeStr($tTime, 3)) ; yyyy/mm/ddThh:mm:ss-hh:mm : Local time

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
	_MemoWrite()
EndFunc   ;==>ShowTimeZoneInformation
