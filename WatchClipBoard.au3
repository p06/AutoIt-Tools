#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <WinAPI.au3>

; Konstanten
Const $targetWindowName = "Unbenannt - Editor"

; hole oder öffne Notepad Fenster
Do
    $hNotepad = WinGetHandle($targetWindowName)
	If @error Then
        $hNotepad = 0
        $msgBoxResult = MsgBox(BitOR($MB_CANCELTRYCONTINUE, $MB_ICONERROR), _
		    "WatchClipBoard - Error", "Window not found: '" & $targetWindowName & "'" & @CRLF & _
			"(Press 'Continue' to open a new text editor window)")
		Switch $msgBoxResult
        Case 11   ; Weiter
            $txtOpenCommand = RegRead("HKEY_CLASSES_ROOT\txtfile\shell\open\command", "")
			Run(_WinAPI_ExpandEnvironmentStrings(StringRegExpReplace($txtOpenCommand, "( +""?%.""?)+$", "")))
			Sleep(2000)
			ContinueCase
		Case 10   ; Wiederholen
		Case Else ; insbesondere 2 = Abbrechen/Dialog-Schließen
            Exit 1
        EndSwitch
	EndIf
Until $hNotepad <> 0

; Hauptschleife
$lastClipContents = ClipGet()
While True
    $clipContents = ClipGet()
    If Not @error And $clipContents <> $lastClipContents Then
        $hCurrentWin = WinGetHandle("")
        WinActivate($hNotepad)
        Sleep(300)
		If Not StringRegExp($clipContents, "^\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d") Then
            Send(StringReplace(_Date_Time_SystemTimeToDateTimeStr(_Date_Time_GetLocalTime(), 1), "/", "-") & " -")
			If Not StringRegExp($clipContents, "^\s") Then
                Send(" ")
			EndIf
		EndIf
        Send("^v")
		If StringRight($clipContents, 2) <> @CRLF Then
            Send("{ENTER}")
	    EndIf
        Sleep(300)
        WinActivate($hCurrentWin)
        $lastClipContents = $clipContents
    EndIf
    Sleep(300)
WEnd
