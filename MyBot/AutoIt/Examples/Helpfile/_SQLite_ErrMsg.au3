#include <MsgBoxConstants.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>

_SQLite_Startup()
If @error Then
	MsgBox($MB_SYSTEMMODAL, "SQLite Error", "SQLite3.dll Can't be Loaded!")
	Exit -1
EndIf
ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
_SQLite_Open()
If $SQLITE_OK <> _SQLite_Exec(-1, "CREATE TABLE test (a', 'b');") Then _ ; a Quote is missing
		MsgBox($MB_SYSTEMMODAL, "SQLite Error", "Error Code: " & _SQLite_ErrCode() & @CRLF & "Error Message: " & _SQLite_ErrMsg())
_SQLite_Close()
_SQLite_Shutdown()
