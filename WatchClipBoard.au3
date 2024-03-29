#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <WinAPI.au3>

Const $editorPath = "%SystemRoot%\system32\NOTEPAD.EXE"
Const $targetWindowClass = "[CLASS:Notepad]"
Const $targetWindowClassRE = "[REGEXPCLASS:^((Notepad\+*)|(SunAwtFrame)|(TEditorForm)|(WinMergeWindowClassW)|(OpusApp))$]" ; Word: maybe +{ENTER} - see below!

; von Funktionen als Seiteneffekt �nderbare Werte
Global $userRequestedNewEditor = False
Global $hNotepad

Func OpenNewEditor()
    $userRequestedNewEditor = True
    Run(_WinAPI_ExpandEnvironmentStrings($editorPath))
    Sleep(2000)
EndFunc

Func GetWindowList()
    Return WinList($targetWindowClassRE)
EndFunc

; hole oder �ffne Notepad Fenster
Func GetWindow()
  Do
    $windowList = GetWindowList()
	If $windowlist[0][0] = 0 Then
        $hNotepad = 0
        $msgBoxResult = MsgBox(BitOR($MB_CANCELTRYCONTINUE, $MB_ICONERROR), _
		    "WatchClipBoard - Error", "No editor window found!" & @CRLF & @CRLF & _
			"  CANCEL" & Chr(9) & Chr(9) & "exit" & @CRLF & _
			"  RETRY" & Chr(9) & Chr(9) & "try again" & @CRLF & _
			"  CONTINUE" & Chr(9) & "open a new text editor window")
		Switch $msgBoxResult
          Case $IDCONTINUE
			OpenNewEditor()
			ContinueCase
		  Case $IDTRYAGAIN
		  Case Else
            Exit 1
        EndSwitch
	Else
        If $windowlist[0][0] = 1 And ($userRequestedNewEditor Or _WinAPI_GetClassName($windowList[1][1]) = $targetWindowClass) Then
            $j = 1
        Else
            $allWindowTitles = ""
		    For $i = 1 To $windowlist[0][0]
		        $allWindowTitles = $allWindowTitles & $i & "  " & $windowList[$i][0] & @CRLF
		    Next
		    $inputBoxResult = InputBox("WatchClipBoard - Choice required", "These editor windows have been found:" & _
			    @CRLF & @CRLF & $allWindowTitles & @CRLF & @CRLF & "Enter the number of the editor to use," & @CRLF & _
			    "or 0 for a new editor", "0", "", -1, 250)
            If @error Then
                Exit 1
            EndIf
            $j = 1 * $inputBoxResult
        EndIf
		If $j = 0 Then
		    OpenNewEditor()
			Do
			  Sleep(300)
			  $newWindowList = GetWindowList()
			  $theNewWindowHandle = 0
			  ; alle neuen Window-Handles pr�fen, ob ein bisher unbekanntes dabei ist
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
			; pr�fen, ob der eingegebene Index valide ist
			If $j < 0 Or $j > $windowList[0][0] Then
			   $hNotepad = 0
			Else
			   $hNotepad = $windowList[$j][1]
			EndIf
	    EndIf
    EndIf
  Until $hNotepad <> 0
EndFunc

GetWindow()

; Hauptschleife
$lastClipContents = ClipGet()
While True
    $clipContents = ClipGet()
    If Not @error And $clipContents <> $lastClipContents Then
	   ;ConsoleWrite($clipContents & @CRLF)
	   ;$lastClipContents = $clipContents
	   ;ContinueLoop

        $hCurrentWin = WinGetHandle("")
        If WinActivate($hNotepad) = 0 Then
            MsgBox($MB_ICONERROR, "WatchClipBoard - Error", "Editor window no more available!" & @CRLF & "Please restart.")
            Exit 1
        EndIf
        Sleep(300)
		If StringRegExp($clipContents, "^#") Then
			If MsgBox($MB_YESNO, "WatchClipBoard - User choice", "Text starts with a '#' - paste it?") = $IDNO Then
                $lastClipContents = $clipContents
                ContinueLoop
			EndIf
		EndIf
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
