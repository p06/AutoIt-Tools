#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <WinAPI.au3>

; Konstanten
Const $editorPath = "%SystemRoot%\system32\NOTEPAD.EXE"
Const $targetWindowClass = "[CLASS:Notepad]"

Func OpenNewEditor()
   Run(_WinAPI_ExpandEnvironmentStrings($editorPath))
   Sleep(2000)
EndFunc

Func GetWindowList()
   Return WinList($targetWindowClass)
EndFunc

; hole oder öffne Notepad Fenster
Do
    $windowList = GetWindowList()
	If $windowlist[0][0] = 0 Then
        $hNotepad = 0
        $msgBoxResult = MsgBox(BitOR($MB_CANCELTRYCONTINUE, $MB_ICONERROR), _
		    "WatchClipBoard - Error", "Editor not found for window class: '" & $targetWindowClass & "'" & @CRLF & _
			"(Press 'Continue' to open a new text editor window)")
		Switch $msgBoxResult
        Case 11   ; Weiter
			OpenNewEditor()
			ContinueCase
		Case 10   ; Wiederholen
		Case Else ; Abbrechen/Dialog-Schließen (2) etc.
            Exit 1
        EndSwitch
	Else
		$allWindowTitles = ""
		For $i = 1 To $windowlist[0][0]
		   $allWindowTitles = $allWindowTitles & $i & "  " & $windowList[$i][0] & @CRLF
		Next
		$j = 1 * InputBox("WatchClipBoard - Choice required", "These editor windows have been found:" & _
			@CRLF & @CRLF & $allWindowTitles & @CRLF & @CRLF & "Enter the number of the editor to use," & @CRLF & _
			"or 0 for a new editor", "0", "", -1, 250)
		If $j = 0 Then
		    OpenNewEditor()
			Do
			  Sleep(300)
			  $newWindowList = GetWindowList()
			  $theNewWindowHandle = 0
			  ; alle neuen Window-Handles prüfen, ob ein bisher unbekanntes dabei ist
			  For $k = 1 To $newWindowlist[0][0]
				 $knownWindow = False
				 For $i = 1 To $windowlist[0][0]
					If $windowList[$i][1] = $newWindowList[$k][1] Then
					   $knownWindow = True
					   ExitLoop
					EndIf
				 Next
				 If Not $knownWindow Then
					$theNewWindowHandle = $newWindowList[$k][1]
					ExitLoop
				 EndIf
			  Next
			Until $theNewWindowHandle <> 0
        	$hNotepad = $theNewWindowHandle
		 Else
			; prüfen, ob der eingegebene Index valide ist
			If $j < 0 Or $j > $windowList[0][0] Then
			   $hNotepad = 0
			Else
			   $hNotepad = $windowList[$j][1]
			EndIf
	    EndIf
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
