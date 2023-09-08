!1::  ; Ctrl+Alt+N
{
    if WinExist("tmux")
        WinActivate
    else
        Run "wt.exe"
}