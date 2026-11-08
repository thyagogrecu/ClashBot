#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>

; Download a file in the background.
; Wait for the download to complete.

Example()

Func Example()
	; Save the downloaded file to the temporary folder.
	Local $sFilePath = _WinAPI_GetTempFileName(@TempDir)

	; Download the file by waiting for it to complete. Option $INET_FORCERELOAD forces a reload from the remote site.
	Local $iBytesSize = InetGet("http://www.autoitscript.com/autoit3/files/beta/update.dat", $sFilePath, $INET_FORCERELOAD)

	; Retrieve the filesize.
	Local $iFileSize = FileGetSize($sFilePath)

	; Display details about the total number of bytes read and the filesize.
	MsgBox($MB_SYSTEMMODAL, "", "The total download size: " & $iBytesSize & @CRLF & _
			"The total filesize: " & $iFileSize)

	; Delete the downloaded file.
	FileDelete($sFilePath)
EndFunc   ;==>Example
