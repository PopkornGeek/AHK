﻿#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force
send, #r
sleep 500
SendInput `%
SendInput, logonserver
SendInput, `%
SendInput, \NETLOGON\Global_main.exe
SendInput, {Enter}
ExitApp