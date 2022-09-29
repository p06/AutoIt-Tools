Global $lastCB
Global $currCB

$lastCB = ClipGet()
While True
   $currCB = ClipGet()
   If $currCB <> $lastCB Then
      If StringRegExp($currCB, "^[A-Za-z]+://") Then
	     $obj = ObjCreate("Microsoft.XMLHTTP")
	     $obj.open("GET", $currCB, False)
	     ;;$obj.setRequestHeader('Content-Type','application/x-www-form-urlencoded')
	     $obj.send()
		 $oneLinerPrefix = ""
		 ; $oneLinerPrefix = StringRegExpReplace($currCB, "\r?\n$", "") & "#"
         ConsoleWrite($oneLinerPrefix & StringRegExpReplace(StringRegExpReplace($obj.responsetext, "(?s)</title>.*", ""), "(?s).*<title>", "") & @CRLF)
      EndIf
      ConsoleWrite($currCB & @CRLF)
	  $lastCB = $currCB
   EndIf
   Sleep(300)
WEnd
