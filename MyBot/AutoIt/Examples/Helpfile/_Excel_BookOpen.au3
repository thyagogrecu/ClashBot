#include "Extras\HelpFileInternals.au3"

#include <Excel.au3>
#include <MsgBoxConstants.au3>

; Create application object
Local $oExcel = _Excel_Open()
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_BookOpen Example 1", "Error creating the Excel application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)

; Open an existing workbook and display the creating date
Local $sWorkbook = _Extras_PathFull("_Excel1.xls")
Local $oWorkbook = _Excel_BookOpen($oExcel, $sWorkbook)
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_BookOpen Example 1", "Error opening '" & $sWorkbook & "'." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_BookOpen Example", "Workbook '" & $sWorkbook & "' has been opened successfully." & @CRLF & @CRLF & "Creation Date: " & $oWorkbook.BuiltinDocumentProperties("Creation Date").Value)
