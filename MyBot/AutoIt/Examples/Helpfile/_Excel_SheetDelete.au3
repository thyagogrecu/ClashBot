#include "Extras\HelpFileInternals.au3"

#include <Excel.au3>
#include <MsgBoxConstants.au3>

; Create application object and open an example workbook
Local $oExcel = _Excel_Open()
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_SheetDelete Example 1", "Error creating the Excel application object." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
Local $oWorkbook = _Excel_BookOpen($oExcel, _Extras_PathFull("_Excel1.xls"))
If @error Then
	MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_SheetDelete Example 1", "Error opening workbook '" & _Extras_PathFull("_Excel1.xls'.") & @CRLF & "@error = " & @error & ", @extended = " & @extended)
	_Excel_Close($oExcel)
	Exit
EndIf

; Delete sheet number 1 of the specified workbook
_Excel_SheetDelete($oWorkbook, 1)
If @error Then Exit MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_SheetDelete Example 1", "Error deleting sheet." & @CRLF & "@error = " & @error & ", @extended = " & @extended)
MsgBox($MB_SYSTEMMODAL, "Excel UDF: _Excel_SheetDelete Example 1", "First sheet has been deleted.")
