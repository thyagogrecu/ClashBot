#include "Extras\HelpFileInternals.au3"

#include <EventLog.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $hEventLog

	; Create GUI
	GUICreate("EventLog", 600, 300)
	_MemoCreate(2, 2, 596, 294, 0)
	GUISetState(@SW_SHOW)

	$hEventLog = _EventLog__Open("", "Application")
	_MemoWrite("Log full ........: " & _EventLog__Full($hEventLog))
	_MemoWrite("Log record count : " & _EventLog__Count($hEventLog))
	_MemoWrite("Log oldest record: " & _EventLog__Oldest($hEventLog))
	_EventLog__Close($hEventLog)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
