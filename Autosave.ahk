#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
#Persistent
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.



SetTimer, AutoSaveTimer, 900000

AutoSaveTimer:
WinMenuSelectItem, ahk_exe Rs500.exe, , File, Save
send, {Enter}
Return
