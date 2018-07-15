#NoEnv  													; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  														; Enable warnings to assist with detecting common errors.
#SingleInstance force
;SendMode Input  											; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%	

Run, *RunAs Keyboard.ahk, , , Keyboard
Run, ClipboardHistory.ahk
Run, Autosave.ahk, , , Autosave
Run, AlwaysMouseWheel_x64.exe
ExitApp