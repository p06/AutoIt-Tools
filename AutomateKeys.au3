#include <MsgBoxConstants.au3>

Global $winDetectExpr = InputBox("Automation window detection", "Please enter a boolean au3 expression", _
  "StringRegExp(WinGetTitle(""[active]""), ""^Dokument"")") ; default
If $winDetectExpr <> "" Then

;Sleep(3000)
While True
;For $i = 1 To 18
  If Execute($winDetectExpr) Then
    Send("^l")
    Sleep(300)
    Send("^x") ;pta{ENTER}
    Sleep(1500)
    ConsoleWrite(ClipGet() & @CRLF)
    Send("^w")
  EndIf
  Sleep(300)
WEnd
;Next

EndIf
