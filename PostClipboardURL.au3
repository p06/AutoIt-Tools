#include <AutoItConstants.au3>
#include <..\..\..\..\uriencode.au3>

Local $iPID = Run(@UserProfileDir & "\getpsi.cmd", @WorkingDir, @SW_HIDE, $STDOUT_CHILD)
ProcessWaitClose($iPID)
Local $psi = StringRegExpReplace(StdoutRead($iPID), "\r?\n", "")
ConsoleWrite("Found $psi = " & $psi & @CRLF)
If $psi <> "" Then

  Global $lastCB
  Global $currCB

  $lastCB = ClipGet()
  While True
    $currCB = ClipGet()
    If $currCB <> $lastCB Then
      ConsoleWrite($currCB & @CRLF)
      $cbWODateTime = StringRegExpReplace($currCB, "^[0-9 :!-]+", "")
      If $currCB <> $cbWODateTime Then
        ConsoleWrite(" --> " & $cbWODateTime & @CRLF)
      EndIf
      If StringRegExp($cbWODateTime, "^[A-Za-z]+://") Then
        $obj = ObjCreate("Microsoft.XMLHTTP")
        $obj.open("GET", "http://192.168.178." & $psi & "/?a=" & _URIEncode(StringRegExpReplace($cbWODateTime, "\s+$", "")), False)
        $obj.send()
        ConsoleWrite("  --> " & $obj.responsetext & @CRLF)
      EndIf
      $lastCB = $currCB
    EndIf
    Sleep(300)
  WEnd

EndIf
