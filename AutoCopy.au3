#include <MsgBoxConstants.au3>

$sendCtrlC = False
$msgBoxResult = MsgBox(BitOR($MB_YESNOCANCEL, $MB_ICONQUESTION), _
    "AutoCopy", "Send Ctrl-C on window change?" & @CRLF & @CRLF & _
    "YES/NO (or CANCEL to exit)")
Switch $msgBoxResult
    Case $IDNO
    Case $IDYES
        $sendCtrlC = True
    Case Else
        Exit 1
EndSwitch
;  10 $IDTRYAGAIN
;  11 $IDCONTINUE

; Hauptschleife
$lastActiveWindowTitle = WinGetTitle("[active]")
While True
    $activeWindowTitle = WinGetTitle("[active]")
    If Not @error And $activeWindowTitle <> "" And $activeWindowTitle <> "Unbenannt - Editor" And $activeWindowTitle <> $lastActiveWindowTitle Then
        ;ConsoleWrite("last: " & $lastActiveWindowTitle & @CRLF & "*now: " & $activeWindowTitle & @CRLF & "send: " & $sendCtrlC & @CRLF)
        If $sendCtrlC Then
            Send("^c")
            Sleep(500)
        Else
            ClipPut($activeWindowTitle)
        EndIf
        $lastActiveWindowTitle = $activeWindowTitle
    EndIf
    Sleep(300)
WEnd
