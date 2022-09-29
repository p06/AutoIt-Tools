#include <Date.au3>

Global $lastCB
Global $currCB

$lastCB = ClipGet()
While True
   $currCB = ClipGet()
   If $currCB <> $lastCB Then
      $tempPNGName = "fromClip-" & StringReplace(StringRegExpReplace(_Date_Time_SystemTimeToDateTimeStr(_Date_Time_GetLocalTime(), 1), "[/ ]", "-"), ":", "") & ".png"
	  ; TODO escape MORE characters? Newline?!! AND create generic clipboard-tool..? (targets: paste to window, show qr, ...)
	  $commandString = @ComSpec & ' /C ' & @UserProfileDir & '\Downloads\installiert\qrencode.exe -s 16 -o ' & $tempPNGName & ' "' & StringReplace(StringReplace($currCB, '"', '""'), '%', '%%') & '"'
	  ;ConsoleWrite("COMMAND: " & $commandString & @CRLF)
	  Local $iPID = Run($commandString, @UserProfileDir & "\Desktop")
	  ProcessWaitClose($iPID)
	  ;ConsoleWrite(StdoutRead($iPID) & @CRLF)
	  ;ConsoleWriteError(StderrRead($iPID) & @CRLF)
	  $commandString = @ComSpec & ' /C start ""Viewer"" "' & $tempPNGName & '"'
	  ;ConsoleWrite("COMMAND: " & $commandString & @CRLF)
	  Run($commandString, @UserProfileDir & "\Desktop")
	  Sleep(3000)
	  FileDelete(@UserProfileDir & "\Desktop\" & $tempPNGName)
	  $lastCB = $currCB
   EndIf
   Sleep(300)
WEnd
