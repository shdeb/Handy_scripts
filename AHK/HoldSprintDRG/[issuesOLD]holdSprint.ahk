#InstallKeybdHook
#InstallMouseHook
KeyHistory
#Persistent
SetTimer, autorepeat, 100, -2
SetTimer, autorepeat, Off
SetTimer, timeout, -100, 2
SetTimer, timeout, Off
toggleFlag := 0
switchWord := {0:"Off", 1:"On"}

Thread, NoTimers
;~ Hotkey, ~LButton, lmb, UseErrorLevel P1
MsgBox, %ErrorLevel%

RCtrl & /::
SendInput, {Blind}{LShift Up}
ExitApp, 0

RShift & /::
toggleFlag := !toggleFlag
;~ MsgBox , , hello, % switchWord[toggleFlag]
SetTimer, autorepeat, % switchWord[toggleFlag]
if ( toggleFlag==0 ) {
	SendInput, {Blind}{LShift Up}
}
return

*RButton::
SendInput, {Blind}{LShift Up}
Sleep, 1
SendInput, {Blind}{RButton DownTemp}
return

*RButton UP::
SendInput, {Blind}{RButton Up}
Sleep, 1
SendInput, {Blind}{LShift DownR}
return

*LButton::
SendInput, {Blind}{LShift DownTemp}
SendInput, {LShift}
SendInput, {Blind}{LButton DownTemp}
return

*LButton UP::
SendInput, {Blind}{LButton Up}
SendInput, {Blind}{LShift DownR}
return

;~ lmb:
;~ SetTimer, timeout
;~ SetTimer, autorepeat, Off
;~ SendInput, {Blind}{LShift Up}
;~ SendInput, {Blind}{LButton DownTemp}
;~ SendInput, {LButton up}
;~ KeyWait, LButton,
;~ SendInput, {Blind}{LButton Up}
;~ SetTimer, autorepeat,On
return

timeout:
SendInput, w
SendInput, {Blind}{LShift}
SendInput, {Blind}{LShift DownR}

autorepeat:
SendInput, {Blind}{LShift DownTemp}
return