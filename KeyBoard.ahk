#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;vk codes http://www.kbdedit.com/manual/low_level_vk_list.html
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}

SysGet, monCount, MonitorCount	; Retrieving the number of monitors.
Loop, %monCount%
{
	SysGet, mon%A_Index%, Monitor, %A_Index%	; Retrieving monitors' positions data.
	SysGet, UA%A_Index%, MonitorWorkArea, %A_Index%	; Getting Usable Area info.
	; Defining variables' values for later use.
	UA%A_Index%centerX := UA%A_Index%Left + (UA%A_Index%halfW := (UA%A_Index%Right - UA%A_Index%Left) / 2)
	UA%A_Index%centerY := UA%A_Index%Top + (UA%A_Index%halfH := (UA%A_Index%Bottom - UA%A_Index%Top) / 2)
}

GroupAdd, Explorer, ahk_exe explorer.exe
GroupAdd, Explorer, ahk_exe ApplicationManager.exe
GroupAdd, Explorer, ahk_class #32770

/*
F5::
;deletes spaces/lines between IO in robot EIO config
SendInput, {END}
SendInput, {DEL}
SendInput, {DOWN}
Return
F4::
;Deletes spaces/lines and double lines in robot EIO config
SendInput, {DOWN}
SendInput, {END}{DEL}{END}{DEL}
Return

*/
^!::

+NumpadAdd::Send, :
+NumpadSub::Send, {;}
+NumpadEnter::Send, {,}

;PrintScreen::
;				SendInput, PrintScreen
;				Run, "SnippingTool.exe",C:\Windows\system32\
;				WinWait, Snipping Tool
;				Send, !n
;				Send, r
;Return
CapsLock::SendInput, {Enter}
;MButton & e::SendInput, A1:O66
MButton & l::WinRestore, A
MButton & m::	
				GoSub, WhatMonitor
				WinMove, A,, UA%winCenterIsOnMonN%Left, UA%winCenterIsOnMonN%Top, UA%winCenterIsOnMonN%Right - UA%winCenterIsOnMonN%Left, UA%winCenterIsOnMonN%Bottom - UA%winCenterIsOnMonN%Top
Return
MButton & n::WinMinimize, A

	;{ Quarter the active window	(LWin + LCtrl + q/e/z/c)
<#<^vk51::	; Top left	(q).
	GoSub, WhatMonitor
	WinMove, A,, UA%winCenterIsOnMonN%Left, UA%winCenterIsOnMonN%Top, UA%winCenterIsOnMonN%halfW, UA%winCenterIsOnMonN%halfH
Return
<#<^vk45::	; Top right	(e).
	GoSub, WhatMonitor
	WinMove, A,, UA%winCenterIsOnMonN%centerX, UA%winCenterIsOnMonN%Top, UA%winCenterIsOnMonN%halfW, UA%winCenterIsOnMonN%halfH
Return
<#<^vk5A::	; Bottom left	(z).
	GoSub, WhatMonitor
	WinMove, A,, UA%winCenterIsOnMonN%Left, UA%winCenterIsOnMonN%centerY, UA%winCenterIsOnMonN%halfW, UA%winCenterIsOnMonN%halfH
Return
<#<^vk43::	; Bottom right	(c).
	GoSub, WhatMonitor
	WinMove, A,, UA%winCenterIsOnMonN%centerX, UA%winCenterIsOnMonN%centerY, UA%winCenterIsOnMonN%halfW, UA%winCenterIsOnMonN%halfH
Return
	;}
	;{ Half the active window	(LWin + LCtrl + w/x/a/d)
<#<^vk57::	; Top	(w).
	GoSub, WhatMonitor
	WinMove, A,, UA%winCenterIsOnMonN%Left, UA%winCenterIsOnMonN%Top, UA%winCenterIsOnMonN%Right - UA%winCenterIsOnMonN%Left, (UA%winCenterIsOnMonN%Bottom - UA%winCenterIsOnMonN%Top) / 2
Return
<#<^vk58::	; Bottom	(x).
	GoSub, WhatMonitor
	WinMove, A,, UA%winCenterIsOnMonN%Left, UA%winCenterIsOnMonN%centerY, UA%winCenterIsOnMonN%Right - UA%winCenterIsOnMonN%Left, (UA%winCenterIsOnMonN%Bottom - UA%winCenterIsOnMonN%Top) / 2
Return
<#<^vk41::	; Left	(a).
	GoSub, WhatMonitor
	WinMove, A,, UA%winCenterIsOnMonN%Left, UA%winCenterIsOnMonN%Top, (UA%winCenterIsOnMonN%Right - UA%winCenterIsOnMonN%Left) / 2, UA%winCenterIsOnMonN%Bottom - UA%winCenterIsOnMonN%Top
Return
<#<^vk44::	; Right	(d).
	GoSub, WhatMonitor
	WinMove, A,, UA%winCenterIsOnMonN%centerX, UA%winCenterIsOnMonN%Top, (UA%winCenterIsOnMonN%Right - UA%winCenterIsOnMonN%Left) / 2, UA%winCenterIsOnMonN%Bottom - UA%winCenterIsOnMonN%Top
Return


MButton & g::		;moves mouse to middle of screen
				CoordMode, Mouse, Screen
				MouseMove, (A_ScreenWidth // 2), (A_ScreenHeight // 2)
Return 

#If MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send {Volume_Up}
WheelDown::Send {Volume_Down}

Return





#IfWinActive ahk_exe Rs500.exe 
				^WheelUp::WinMenuSelectItem ahk_exe Rs500.exe, , View, Zoom In					;zooms in (RS5000 does this already) "ctrl+scroll"
				^WheelDown::WinMenuSelectItem ahk_exe Rs500.exe, , View, Zoom Out 					;zooms out (RS5000 does this already)"ctrl+scroll"
				MButton & c::					;toggles i/o cross references
					WinMenuSelectItem ahk_exe Rs500.exe, , View, Properties...
					SetKeyDelay 0, 50
					SendInput, +{Tab}
					SendInput, {Right}

					loop, 5 {
					SendInput, {Tab}
					}
					SendInput, {space}
					SendInput, {Tab} 
					SendInput, {space}				
					SendInput, {Enter}
Return
				MButton & w::
					WinMenuSelectItem ahk_exe Rs500.exe, , Window, Arrange...
					SetKeyDelay 0, 500
					SendInput, {Enter}
Return
				MButton & o::
					WinMenuSelectItem ahk_exe Rs500.exe, , Comms, Who Active Go Online
					;SetKeyDelay 0, 500
					;SendInput, {Enter}
Return
				MButton & d::
					Send, {Tab}
					Send, g
					Send, +{Tab}
					Sleep 100
					Send, g{Enter}{Down}
					
					Send, d{Enter}{Down}
					Send, p
					Send, r{Enter}{Down}
					Send, w{Enter}{Down}
Return


;=====================================================================================================================================================================================================================================================================
					
#IfWinActive ahk_class PanelBuilder32AppClass 
				^WheelUp::WinMenuSelectItem ahk_class PanelBuilder32AppClass, , View, Zoom In			;zooms in "ctrl+scroll"
				^WheelDown::WinMenuSelectItem ahk_class PanelBuilder32AppClass, , View, Zoom Out		;zooms out "ctrl+scroll"
				MButton & w::
					WinMenuSelectItem ahk_class PanelBuilder32AppClass, , Window, Cascade
					ControlMove, MDIClient1,
Return

;=====================================================================================================================================================================================================================================================================
#IfWinActive ahk_exe VStudio.exe
				^WheelUp::WinMenuSelectItem ahk_exe VStudio.exe, , View, Zoom In			;zooms in "ctrl+scroll"
				^WheelDown::WinMenuSelectItem ahk_exe VStudio.exe, , View, Zoom Out		;zooms out "ctrl+scroll"

				+vkdb::SendInput,{{}[PLC]{}}{Left}



;=====================================================================================================================================================================================================================================================================
#IfWinActive ahk_class Qt5QWindowIcon ;types 4h & 14h ip addresses into VISOR vision
				i & p::
					MouseClick, left, 95, 620, , 0
					SendInput, 138.84.46.213
					SendInput, {Tab}
					SendInput, {Enter}
					SendInput, +{Tab}
					SendInput, 138.84.46.187
					SendInput, {Tab}
					SendInput, {Enter}
Return

;=====================================================================================================================================================================================================================================================================
#IfWinActive ahk_group Explorer ;fills search bar with directory
				MButton & d::
					SendInput, !d
					SendInput, G:\Depts\Process\WORKCELL\00 - SUBMIT\CALEB-mpp486
					SendInput, {Enter}
Return
				MButton & f::
					SendInput, !d
					SendInput, C:\Users\Public\Documents\RSView Enterprise\ME
					SendInput, {Enter}
Return
				MButton & w::
					SendInput, !d
					SendInput, G:\Depts\Process\WORKCELL
					SendInput, {Enter}
Return
				MButton & s:: ;sorts to detail and recent

					explorerHwnd := WinActive("ahk_class CabinetWClass")

					Windows := ComObjCreate("Shell.Application").Windows
					for window in Windows
						;Send, {MButton UP}
						if (window.hWnd == explorerHwnd)
							sFolder := window.Document
						if (sFolder.CurrentViewMode != 4)
							sFolder.CurrentViewMode := 4 ; Details.
						;typedef enum FOLDERVIEWMODE { 
						;  FVM_AUTO        = -1,
						;  FVM_FIRST       = 1,
						;  FVM_ICON        = 1,
						;  FVM_SMALLICON   = 2,
						;  FVM_LIST        = 3,
						;  FVM_DETAILS     = 4,
						;  FVM_THUMBNAIL   = 5,
						;  FVM_TILE        = 6,
						;  FVM_THUMBSTRIP  = 7,
						;  FVM_CONTENT     = 8,
						;  FVM_LAST        = 8
						;} FOLDERVIEWMODE;
						Sleep 100
						SendInput, !vo{Down}{Enter} 			;view>sort by> date modified
						Sleep 300
						SendInput, !vo{Up 2}{Enter} 			;view>sort by>descending
						;Sleep 100
						;SendInput, !va{Down 2}{Enter} 			;view>add coumn>modified
						Sleep 100
						SendInput, !vht 						;view>item check box
						Sleep 1000
						Send, !vsf 								;view>size all columns to fit
						;} else if (sFolder.CurrentViewMode == 1) {
						;	if (sFolder.IconSize == 256)
						;		sFolder.CurrentViewMode := 8 ; Go back to content view
						;	else if (sFolder.IconSize == 48)
						;		sFolder.IconSize := 96 ; Large icons
						;	else
						;		sFolder.IconSize := 256 ; Extra large icons
						;}
					;}
					;WinGetClass, vWinClass, A
					;PostMessage, 0x111, 31002,, SHELLDLL_DefView1, A ;WM_COMMAND ;Invert Selection


					;PostMessage, 0x111, 30983, , , ahk_group Explorer  ;refresh
					;Sleep 50
					;PostMessage, 0x111, 31007, , , ahk_group Explorer ;set listview mode detail
					;Sleep 20
					;PostMessage, 0x111, 31002, , , ahk_group Explorer ; sort Date modified
					;Sleep 20
					;PostMessage, 0x111, 30997, , , ahk_group Explorer ;to get sort reversed 
Return

;=====================================================================================================================================================================================================================================================================
#IfWinActive ahk_exe RSLINX.EXE ;'autofills' window
				MButton & w::WinMenuSelectItem ahk_exe RSLINX.EXE, , Window, Tile

;=====================================================================================================================================================================================================================================================================
#IfWinActive ahk_exe RS5000.Exe ;'autofills' window
				MButton & w::WinMenuSelectItem ahk_exe RS5000.Exe, , Window, 4&
				MButton & t::Send, ^t
				MButton & e::Send, ^e
				MButton & q::Send, ^w
				;Tab::Right
				;+Tab::SendInput,{Left}{Left}
				+Space::_
				RShift::Right
				
;=====================================================================================================================================================================================================================================================================
#IfWinActive ahk_exe DWGSeePro.exe
^WheelUp::
	Send, {VK21}									;"ctrl+PgUp "
	Sleep 1
	SendInput, p
Return
^WheelDown::
	Send, {VK22}									;"ctrl+PgDn "
	Sleep 1
	SendInput, p
Return
WheelUp::
	WinMenuSelectItem ahk_exe DWGSeePro.exe, , View, Zoom In			;zooms in 
	Sleep 1
	SendInput, p
Return
WheelDown::
	WinMenuSelectItem ahk_exe DWGSeePro.exe, , View, Zoom Out		;zooms out "ctrl+scroll"
	Sleep 1
	SendInput, p
Return

;=====================================================================================================================================================================================================================================================================
#IfWinActive MATLAB Online R2018a - Google Chrome
vkdb::Send, [{End}]{Left}	;[
+vk39::Send, ({End}){Left}	;(
+vkdb::Send, {{}{End}{}}{Left}	;{ doesn't work
;'::Send, ''{Left}		;'
;'::Send, '{Space}		;'
,::Send, {,}{Space}
vkba::Send, {Space}{;}`%{Space}{Right} ;{asc 0037}
=::Send, {Space}={Space}
+=::Send, {Space}{VK6B}{Space}		;+
vk6b::Send, {Space}{VK6B}{Space}	;+
vkbd::Send, {Space}{VKBD}{Space}	;-
vk6d::Send, {Space}{VK6D}{Space}	;-
vkbf::Send, {Space}{VKBF}{Space} 	;/
vk6f::Send, {Space}{VKBF}{Space}	;/
+sc009::Send, {Space}{VK6A}{Space}	;*
vk6A::Send, {Space}{VK6A}{Space}	;*

;::Send, {Space}{Space}
;::Send, {Space}{Space}

Return
;=====================================================================================================================================================================================================================================================================




/*
#IfWinActive ahk_class Notepad++
				::sor::
					SendInput, SOREOR
					Send, {Left 3}{Space}
				
				::bst::
					SendInput, BSTBND
					Send, {Left 3}{Space}

				::xic::XIC 
				::xio::XIO 
				::ote::OTE
				::cpt::CPT
				::les::LES
				::grt::GRT
				::geq::GEQ
				::leq::LEQ
				::lim::LIM
				::otl::OTL
				::otu::OTU
				::mov::MOV
				::ons::ONS
				::ton::TON
				::cop::COP
				::equ::EQU
				::osr::OSR
				::mul::MUL
				::mvm::MVM
				::add::ADD
				::sub::SUB
				::div::DIV
				::scp::SCP
				::iim::IIM
				::swp::SWP
				::jsr::JSR
Return
*/
;=====================================================================================================================================================================================================================================================================
#IfWinActive


WhatMonitor:
	centerCoord := getActiveWindowCenterCoords()
	Loop, %monCount%
	{
		If (monCount == "1") || (monCount == A_Index) || (((mon%A_Index%Left < centerCoord[1]) && (centerCoord[1] < mon%A_Index%Right)) && ((mon%A_Index%Top < centerCoord[2]) && (centerCoord[2] < mon%A_Index%Bottom)))
		{
			winCenterIsOnMonN := A_Index
			Break
		}
	}
Return
activeWinMoveResize(dx, dy, dw, dh)
{
	WinGetPos, X, Y, W, H, A
	WinMove, A,, (X + dx), (Y + dy), (W + dw), (H + dh)
}
		;}
		;{ getActiveWindowCenterCoords()
; Get the coordinates of the center of the active window.
getActiveWindowCenterCoords()
{
	WinGetPos, x, y, w, h, A
	Return, [(w // 2) + x, (h // 2) + y]
}



MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}
