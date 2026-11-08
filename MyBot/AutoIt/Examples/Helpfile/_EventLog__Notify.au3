#include "Extras\HelpFileInternals.au3"

#include <EventLog.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIHObj.au3>
#include <WinAPIProc.au3>

Example()

Func Example()
	Local $hEventLog, $hEvent, $iResult

	; Create GUI
	GUICreate("EventLog", 600, 300)
	_MemoCreate(2, 2, 596, 294, 0)
	GUISetState(@SW_SHOW)

	; Set up event
	$hEventLog = _EventLog__Open("", "Security")
	$hEvent = _WinAPI_CreateEvent(0, False, False, "")
	_EventLog__Notify($hEventLog, $hEvent)

	; Wait for new event to occur
	_MemoWrite("Waiting for new event")
	$iResult = _WinAPI_WaitForSingleObject($hEvent)
	_WinAPI_CloseHandle($hEvent)
	_EventLog__Close($hEventLog)

	; Write results
	If $iResult = -1 Then
		_MemoWrite("Wait failed")
	Else
		_MemoWrite("New event occurred")
	EndIf

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
