#include <MsgBoxConstants.au3>
#include <WinAPI.au3>

Const $skipWindowClassNameRE = "^Notepad\+*$";
Const $skipMessage = "- Skipping Notepad(++) windows -" & @CRLF

; Frage Benutzer, ob Strg-C gesendet werden soll (anstatt direkt den Titel des Fensters zu verwenden) - nützlich mit Firefox + CopyFixer Add-On,
;   weil dann noch die URL dazu ermittelt werden kann!
$sendCtrlC = False
$msgBoxResult = MsgBox(BitOR($MB_YESNOCANCEL, $MB_ICONQUESTION), _
    "AutoCopy changing window titles", $skipMessage & @CRLF & "Send Ctrl-C on window change?" & @CRLF & @CRLF & "YES/NO (or CANCEL to exit)")
Switch $msgBoxResult
    Case $IDNO
    Case $IDYES
        $sendCtrlC = True
    Case Else
        Exit 1
EndSwitch

Func GetActiveWindowInfo()
    Local $result[3]
    $windowHandle = WinGetHandle("[active]")
    $result[0] = WinGetTitle($windowHandle)
    $result[1] = _WinAPI_GetClassName($windowHandle)
    $result[2] = $windowHandle
    Return $result
EndFunc

; Hauptschleife
$lastActiveWindowInfo = GetActiveWindowInfo()
While True
    $activeWindowInfo = GetActiveWindowInfo()
    If Not @error And $activeWindowInfo[0] <> "" And Not StringRegExp($activeWindowInfo[1], $skipWindowClassNameRE) _
	   And $activeWindowInfo[2] <> $lastActiveWindowInfo[2] Then ; title of active window has changed (or active window has changed  ;-) )
         If $sendCtrlC Then
            Send("^c")
            Sleep(500)
         Else
            ClipPut($activeWindowInfo[0])
         EndIf
         $lastActiveWindowInfo = $activeWindowInfo
    EndIf
    Sleep(300)
WEnd
