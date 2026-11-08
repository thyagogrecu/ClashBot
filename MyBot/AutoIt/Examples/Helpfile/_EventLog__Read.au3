#include "Extras\HelpFileInternals.au3"

#include <EventLog.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	Local $hEventLog, $aEvent

	; Create GUI
	GUICreate("EventLog", 600, 300)
	_MemoCreate(2, 2, 596, 294, 0)
	GUISetState(@SW_SHOW)

	; Read most current event record
	$hEventLog = _EventLog__Open("", "Application")
	$aEvent = _EventLog__Read($hEventLog, True, False) ; read last event
	; $hEventLog = _EventLog__Open("", "System")
	; $aEvent = _EventLog__Read($hEventLog)
	; $aEvent = _EventLog__Read($hEventLog, True, False)
	_MemoWrite("Result ............: " & $aEvent[0])
	_MemoWrite("Record number .....: " & $aEvent[1])
	_MemoWrite("Submitted .........: " & $aEvent[2] & " " & $aEvent[3])
	_MemoWrite("Generated .........: " & $aEvent[4] & " " & $aEvent[5])
	_MemoWrite("Event ID ..........: " & $aEvent[6])
	_MemoWrite("Type ..............: " & $aEvent[8])
	_MemoWrite("Category ..........: " & $aEvent[9])
	_MemoWrite("Source ............: " & $aEvent[10])
	_MemoWrite("Computer ..........: " & $aEvent[11])
	_MemoWrite("Username ..........: " & $aEvent[12])
	_MemoWrite("Description .......: " & $aEvent[13])
	_EventLog__Close($hEventLog)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example
