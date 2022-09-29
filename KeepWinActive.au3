#include <Timers.au3>
#include <TrayConstants.au3>

TraySetToolTip("Keep Win active")

; TODO config über Tray context menü? https://www.autoitscript.com/autoit3/docs/functions/TrayCreateMenu.htm

Const $limitMillis = 250000 ; ~ 5 min
;Const $limitMillis = 550000 ; ~ 10 min
Const $sendString = "LCTRL"

While True
   Sleep($limitMillis - _Timer_GetIdleTime())
   If _Timer_GetIdleTime() > $limitMillis Then
      TrayTip("Keep Win active", "About to send " & $sendString, 5, $TIP_ICONEXCLAMATION + $TIP_NOSOUND)
      Sleep(3000)
      If _Timer_GetIdleTime() > $limitMillis Then
         Send("{" & $sendString & "}")
         TrayTip("Keep Win active", "Sent " & $sendString, 5, $TIP_NOSOUND)
      Else
         TrayTip("Keep Win active", "Didn't send " & $sendString, 5, $TIP_NOSOUND)
      EndIf
   EndIf
WEnd
