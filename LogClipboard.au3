Global $lastCB
Global $currCB

$lastCB = ClipGet()
While True
   $currCB = ClipGet()
   If $currCB <> $lastCB Then
	  ;;fetch heading (see below) of HTML document at given URL
	  ;$obj = ObjCreate("Microsoft.XMLHTTP")
	  ;$obj.open("GET", $currCB, False)
	  ;;$obj.setRequestHeader('Content-Type','application/x-www-form-urlencoded')
	  ;$obj.send()
      ;ConsoleWrite(StringRegExpReplace($currCB, "\r?\n$", "") & "#" & StringRegExpReplace(StringRegExpReplace($obj.responsetext, "(?s)</h3>.*", ""), "(?s).*<h3>", "") & @CRLF)
      ConsoleWrite($currCB & @CRLF) ; newline?
	  $lastCB = $currCB
   EndIf
   Sleep(300)
WEnd
