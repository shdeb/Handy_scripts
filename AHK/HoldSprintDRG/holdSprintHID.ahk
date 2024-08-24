#NoEnv                          ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input                  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%     ; Ensures a consistent starting directory.
#SingleInstance force
; #InstallKeybdHook
; #InstallMouseHook
SetKeyDelay, -1 
#Include ../AHKHID.ahk

Hotkey, *LButton, ret, UseErrorLevel
Hotkey, *RButton, ret, UseErrorLevel
Hotkey, *LShift, ret, UseErrorLevel

Menu, Tray, Add, Show Debug, toggleDebug

Gui +LastFound -Resize -MaximizeBox -MinimizeBox
Gui, Font, w700 s8, Courier New
Gui, Add, ListBox, h600 w500 vlbxInput hwndhlbxInput,


; variables
showDebug:=false
toggleFlag := 0
switchWord := {0:"Off", 1:"On"}
hidPage := 1
hidUsage := 2
ld := 0
rd := 0


GuiHandle := WinExist()                               ; Keep handle

myFlags :=  RIDEV_INPUTSINK ;| RIDEV_CAPTUREMOUSE | RIDEV_PAGEONLY
; MsgBox,% myFlags
r := AHKHID_Register(hidPage, hidUsage, GuiHandle, myFlags) ; register

;Intercept WM_INPUT
OnMessage(0x00FF, "InputMsg")

Hotkey, *LButton, % switchWord[toggleFlag]
Hotkey, *RButton, % switchWord[toggleFlag]
Hotkey, *LShift, Off

;Show or hide GUI
Gui, Show
If (!showDebug)
    Gui, Show, Hide

Return

toggleDebug:
showDebug:=!showDebug
If (showDebug){
    Menu, Tray, Check, Show Debug
    Gui, Show
} Else {
    Menu, Tray, UnCheck, Show Debug
    Gui, Show, Hide
}
return

ret:
return

GuiEscape:
GuiClose:
AHKHID_Register(hidPage,hidUsage,0,RIDEV_REMOVE)
tooltip,
ExitApp, 0

; callback function
InputMsg(wParam, lParam) {
    Local flags, s, r ; , x, y
    Critical
    Hotkey, *LShift, On
    Sleep, -1
    if ( getGlobalVar("toggleFlag")==0 ) {
        SendInput, {Blind}{LShift Up}
        Return
    }
    ;Get movement ;and add to listbox
    ;~ x := AHKHID_GetInputInfo(lParam, II_MSE_LASTX) + 0.0
    ;~ y := AHKHID_GetInputInfo(lParam, II_MSE_LASTY) + 0.0
    ;~ If (x Or y)
        ;~ GuiControl,, lbxMove, % x A_Tab y

    ;~ ;Auto-scroll
    ;~ SendMessage, 0x018B, 0, 0,, ahk_id %hlbxMove%
    ;~ SendMessage, 0x0186, ErrorLevel - 1, 0,, ahk_id %hlbxMove

    ;Get flags and add to
    r := AHKHID_GetInputInfo(lParam, II_DEVTYPE)
    If (r = -1)
        OutputDebug %ErrorLevel%
    If (r = RIM_TYPEMOUSE) {
        flags := AHKHID_GetInputInfo(lParam, II_MSE_BUTTONFLAGS)
        If (flags & RI_MOUSE_LEFT_BUTTON_DOWN AND not (getGlobalVar("ld") & RI_MOUSE_LEFT_BUTTON_DOWN)){
            setGlobalVar("ld",flags)
            s := "You pressed the left button "
            SendInput, {Blind}{LShift Up}{LButton Down}
            ; Sleep, -1
            ; SendInput, {Blind}{LButton Down}
        }
        If (flags & RI_MOUSE_LEFT_BUTTON_UP AND not (getGlobalVar("ld") & RI_MOUSE_LEFT_BUTTON_UP)){
            setGlobalVar("ld",flags)
            s .= (s <> "" ? "and" : "You") " released the left button "
            SendInput, {Blind}{LButton Up}{LShift DownR}
            ; Sleep, -1
            ; SendInput, {Blind}{LShift DownR}
        }
        If (flags & RI_MOUSE_RIGHT_BUTTON_DOWN AND not (getGlobalVar("rd") & RI_MOUSE_RIGHT_BUTTON_DOWN)){
            setGlobalVar("rd",flags)
            s .= (s <> "" ? "and" : "You") " pressed the right button "
            SendInput, {Blind}{LShift Up}{RButton Down}
            Sleep, -1
            ; SendInput, {Blind}{RButton Down}
        }
        If (flags & RI_MOUSE_RIGHT_BUTTON_UP AND not (getGlobalVar("rd") & RI_MOUSE_RIGHT_BUTTON_UP)){
            setGlobalVar("rd",flags)
            s .= (s <> "" ? "and" : "You") " released the right button "
            SendInput, {RButton Up}{LShift DownR}
            Sleep, -1
            ; SendInput, {Blind}{LShift DownR}
        }
        ;~ If (flags & RI_MOUSE_MIDDLE_BUTTON_DOWN)
            ;~ s .= (s <> "" ? "and" : "You") " pressed the middle button "
        ;~ If (flags & RI_MOUSE_MIDDLE_BUTTON_UP)
            ;~ s .= (s <> "" ? "and" : "You") " released the middle button "
        ;~ If (flags & RI_MOUSE_BUTTON_4_DOWN)
            ;~ s .= (s <> "" ? "and" : "You") " pressed XButton1 "
        ;~ If (flags & RI_MOUSE_BUTTON_4_UP)
            ;~ s .= (s <> "" ? "and" : "You") " released XButton1 "
        ;~ If (flags & RI_MOUSE_BUTTON_5_DOWN)
            ;~ s .= (s <> "" ? "and" : "You") " pressed XButton2 "
        ;~ If (flags & RI_MOUSE_BUTTON_5_UP)
            ;~ s .= (s <> "" ? "and" : "You") " released XButton2 "
        ;~ If (flags & RI_MOUSE_WHEEL)
            ;~ s .= (s <> "" ? "and" : "You") " turned the wheel by " Round(AHKHID_GetInputInfo(lParam, II_MSE_BUTTONDATA) / 120) " notches "

        ;Add background/foreground info
        ;~ s .= (InputSink And s <> "") ? (wParam ? "in the background" : "in the foreground") : ""

    }
    ;~ Else If (r = RIM_TYPEKEYBOARD) {
        ;~ GuiControl,, lbxInput, % ""
        ;~ . " MakeCode: "    AHKHID_GetInputInfo(lParam, II_KBD_MAKECODE)
        ;~ . " Flags: "       AHKHID_GetInputInfo(lParam, II_KBD_FLAGS)
        ;~ . " VKey: "        AHKHID_GetInputInfo(lParam, II_KBD_VKEY)
        ;~ . " Message: "     AHKHID_GetInputInfo(lParam, II_KBD_MSG)
        ;~ . " ExtraInfo: "   AHKHID_GetInputInfo(lParam, II_KBD_EXTRAINFO)
    ;~ }

    Hotkey, *LShift, Off

    GuiControl,, lbxInput,%s%

    ;Auto-scroll
    SendMessage, 0x018B, 0, 0,, ahk_id %hlbxInput%
    SendMessage, 0x0186, ErrorLevel - 1, 0,, ahk_id %hlbxInput%
}

setGlobalVar(var,value){
    global ld, rd ;
    ; (%var% := value)
    If (var = "ld")
        ld := value
    Else If (var = "rd")
        rd := value

}
getGlobalVar(var){
    global ld, rd, toggleFlag ;
    ; Return (%var%)
    If (var = "ld")
        Return ld
    Else If (var = "rd")
        return rd
    Else If (var = "toggleFlag")
        return toggleFlag

}

RShift & /::
toggleFlag := !toggleFlag
Hotkey, *LButton, % switchWord[toggleFlag]
Hotkey, *RButton, % switchWord[toggleFlag]
; Pause, Toggle
return

*>^/::
SendInput, {Blind}{LShift Up}
goto GuiClose


