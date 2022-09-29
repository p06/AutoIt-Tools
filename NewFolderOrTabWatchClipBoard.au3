#include <MsgBoxConstants.au3>
#include <Date.au3>
#include <WinAPI.au3>
#include <StringConstants.au3>

; see NewFolderName()
$desktop = EnvGet("USERPROFILE") & "\Desktop"

; Register Ctrl-Alt-C
HotKeySet("^!c", "NewFolderPrompt")

Func NewFolderPrompt()
   NewFolder(InputBox("Neuer Ordner", "Bitte kompletten Pfad eingeben", NewFolderName()))
EndFunc

Func NewFolder($folderName)
  DirCreate($folderName)
  Run("explorer /e, " & '"' & $folderName & '"')
EndFunc

Func NewFolderName()
   Return $desktop & "\" & StringRegExpReplace(_Date_Time_SystemTimeToDateTimeStr(_Date_Time_GetLocalTime(), 1), "[/:]", "-") & " "
EndFunc

Func OpenClipContentsInFirefox($url)
   If Not StringRegExp($url, "^https?://") Then
	  Return
   EndIf
   WinActivate("[CLASS:MozillaWindowClass]")
   Sleep(500)
   Send("^t^v{ENTER}")
EndFunc

; Hauptschleife
$lastClipContents = ClipGet()
While True
    $clipContents = ClipGet()
    If Not @error And $clipContents <> $lastClipContents Then
	  ;NewFolder(NewFolderName() & StringRegExpReplace(StringRegExpReplace($clipContents, "[\\/:*?""<>|\v\t\xA0]+", " "), " {2,}", " "))
	  OpenClipContentsInFirefox($clipContents)
	  ;ConsoleWrite($clipContents & @CRLF)
      $lastClipContents = $clipContents
    EndIf
    Sleep(300)
WEnd
