#NoEnv  													; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  													; Enable warnings to assist with detecting common errors.
#SingleInstance force
;SendMode Input  											; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%									; Ensures a consistent starting directory.

;If the script is not elevated, relaunch as administrator and kill current instance
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}



global AutoSaveEnabled:=1
global ClipboardHistoryEnabled:=1
global KeyBoardEnabled:=1
global PVEnabled:=0
global IPEnabled:=0
global NPPEnabled
global EverythingButton
global GDriveButton
global NetworkButton
global KillAllButton
global TestButton
global ExcelIP
global Calc
global TICalc
global Word
global Excel
global PowerPoint
global QuitButton
global hw_gui
global FirstRun:=1
global xPos:=600
global yPos:=0
;global ExcelFile:="'G:\Depts\Process\WORKCELL\00 - SUBMIT\CALEB-mpp486\Ethernet_Device_Master_Listing_Caleb.xlsx'"



x:=UnPinToTaskbar("C:\Program Files\Internet Explorer\iexplore.exe")
x:=UnPinToTaskbar("C:\Windows\explorer.exe")
x:=KillAll()
x:=DisplayGui()
WinMinimize, Sticky Notes
FileDelete, C:\Users\mpp486\Desktop\PK-Info.lnk
Gosub, OnKeyBoardEnabledChange
Gosub, OnClipboardHistoryEnabledChange
Gosub, OnAutoSaveEnabledChange


`::Reload
/*											;reloads script on ` press - for testing purposes
RButton Up::
SendInput, {RButton}
;MouseGetPos, [OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 1|2|3]
Gui Toggle: -AlwaysOnTop 
Gui Toggle: +AlwaysOnTop +MinSize +MaxSize
Return
/*
LButton Up::
Send, {LButton}
MouseGetPos, [OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 1|2|3]
Gui Toggle: -AlwaysOnTop 
Gui Toggle: +AlwaysOnTop +MinSize +MaxSize
Return
#If MouseIsOver("ahk_class Shell_TrayWnd")
x:=MakeOnTop()
MakeOnTop(){
Gui Toggle: -AlwaysOnTop 
Gui Toggle: +AlwaysOnTop +MinSize +MaxSize
Sleep 1000
}
*/
;============================================================================================================================================================================
DisplayGui(){										;displays gui

NPPCheck()
Gui Toggle: New, +hwndhMyGuiHwnd, Toggle
Gui Toggle: Font, cFFFFFF S7 , Segoe UI
Gui Toggle: Color, AAAAAA

Gui Toggle: Add, Text, x10 y1 w260 h1 0x7
Gui Toggle: Add, Text, xp+43 yp w2 h15 0x7
Gui Toggle: Add, Text, xp+54 yp w2 h15 0x7
Gui Toggle: Add, Text, xp+42 yp w2 h15 0x7
Gui Toggle: Add, Text, xp+40 yp w2 h15 0x7
Gui Toggle: Add, Text, xp+41 yp w2 h15 0x7
Gui Toggle: Add, Text, xp+29 yp w2 h15 0x7

Gui Toggle: Add, Text, x10 yp+15 w260 h1 0x7

Gui Toggle: Add, Checkbox, xp-1 yp-13 w44 vAutoSaveEnabled hwndhAutoSaveEnabled gOnAutoSaveEnabledChange Checked%AutoSaveEnabled%, AutoS
Gui Toggle: Add, Checkbox, xp+47 yp w51 vClipboardHistoryEnabled hwndhClipboardHistoryEnabled gOnClipboardHistoryEnabledChange Checked%ClipboardHistoryEnabled%, ClipHist
Gui Toggle: Add, Checkbox, xp+54 yp w39 vKeyBoardEnabled hwndhKeyBoardEnabled gOnKeyBoardEnabledChange Checked%KeyBoardEnabled%, KeyB
Gui Toggle: Add, Checkbox, xp+42 yp w36 vPVEnabled hwndhPVEnabled gOnPVEnabledChange Checked%PVEnabled%, PV+
Gui Toggle: Add, Checkbox, xp+39 yp w38 vNPPEnabled hwndhNPPEnabled gOnNPPEnabledChange Checked%NPPEnabled%, N++
Gui Toggle: Add, Checkbox, xp+41 yp w26 vIPEnabled hwndhIPEnabled gOnIPEnabledChange Checked%IPEnabled%, IP

Gui Toggle: Font,  S7 , Futura
Gui Toggle:  Add, Button, xp-220 yp+17 w37 h19 cFAF287 vEverythingButton hwndhEverythingButton gOnEverythingButtonPress, Search
Gui Toggle:  Add, Button, xp+35 yp w47 h19 cFAF287 vGDriveButton hwndhGDriveButton gOnGDriveButtonPress , G Drive
Gui Toggle:  Add, Button, xp+41 yp w47 h19 cFAF287 vNetworkButton hwndhNetworkButton gOnNetworkButtonPress , Network
Gui Toggle:  Add, Button, xp+44 yp w31 h19 cFAF287 vKillAllButton hwndhKillAllButton gOnKillAllButtonPress , KillAll
Gui Toggle:  Add, Button, xp+27 yp w27 h19 cFAF287 vTestButton hwndhTestButton gOnTestButtonPress , Test
Gui Toggle:  Add, Button, xp+23 yp w23 h19 cFAF287 vExcelIP hwndhExcelIP gOnExcelIPButtonPress, XIP
Gui Toggle:  Add, Button, xp+27 yp w22 h19 cFAF287 vTICalc hwndhTICalc gOnTICalcButtonPress, 89
Gui Toggle:  Add, Button, xp+21 yp w27 h19 cFAF287 vCalc hwndhCalc gOnCalcButtonPress, Calc
Gui Toggle:  Add, Button, xp+26 yp w18 h19 cFAF287 vWord hwndhWord gOnWordButtonPress, W
Gui Toggle:  Add, Button, xp+17 yp w18 h19 cFAF287 vExcel hwndhExcel gOnExcelButtonPress, X
Gui Toggle:  Add, Button, xp+17 yp w18 h19 cFAF287 vPowerPoint hwndhPowerPoint gOnPowerPointButtonPress, P

Gui Toggle:  Add, Button, x1 y1 w7 h37 cFAF287 vQuitButton hwndhQuitButton gOnQuitButtonPress , 


Gui Toggle: Margin, 1, 1
Gui Toggle: +ToolWindow -Caption ;-Border -SysMenu  ;;;these do almost the same as -caption by itself 
Gui Toggle: Color, 000000

if (FirstRun = 0){											;show Gui
	Gui Toggle: Show, AutoSize ; x%xPos% y%yPos% w200 h200
	;x:=AlwaysOnTopOfTaskBar()
	FirstRun:=1
}Else{
	Gui Toggle: Show, x%xPos% y%yPos% ;w200 h200
	;x:=AlwaysOnTopOfTaskBar()
}
Gui Toggle: +AlwaysOnTop +MaxSize +MinSize
x:=AlwaysOnTopOfTaskBar()
if (A_ScreenWidth = 1600){
xPos:=900
}Else{
xPos:=1350 ;1275  ;1375 ;A_ScreenWidth-600-0 ;A_GuiWidth            moved here so gui can't be moved. 
}

yPos:=2  ;2 ;A_ScreenHeight-40 ;A_GuiHeight
Gui Toggle: Show, x%xPos% y%yPos% ;w200 h200
WinSet, Transparent, 255, ahk_class BaseBar
WinSet, Transparent, 255, ahk_class Shell_TrayWnd
WinSet, Transparent, 0, ahk_class AutoHotkeyGUI

}
;============================================================================================================================================================================
ControlGui(){										;updates gui

IFWinExist, ahk_class Notepad++
	NPPEnabled=1
Else
	NPPEnabled:=0


GuiControl, ,NPPEnabled, %NPPEnabled%

}
;============================================================================================================================================================================
KillAll(){											;Kills All AHK Scripts
DetectHiddenWindows, On 
WinGet, List, List, ahk_class AutoHotkey 

Loop %List% 
  { 
    WinGet, PID, PID, % "ahk_id " List%A_Index% 
    If ( PID <> DllCall("GetCurrentProcessId") ) 
         PostMessage,0x111,65405,0,, % "ahk_id " List%A_Index% 
  }
}
;============================================================================================================================================================================
CloseScript(Name){				;case insensitive, doesn't work on scrips with GUI
DetectHiddenWindows On
SetTitleMatchMode RegEx
IfWinExist, i)%Name%.* ahk_class AutoHotkey
	{
	WinClose
	WinWaitClose, i)%Name%.* ahk_class AutoHotkey, , 2
	If ErrorLevel
		return "Unable to close " . Name
	else
		return "Closed " . Name
	}
else
	return Name . " not found"
}
;============================================================================================================================================================================
KillScript(Name){											;Kills AHK Scripts with GUI
DetectHiddenWindows, On 
WinGet, List, List, %Name% 

Loop %List% 
  { 
    WinGet, PID, PID, % "ahk_id " List%A_Index% 
    If ( PID <> DllCall("GetCurrentProcessId") ) 
         PostMessage,0x111,65405,0,, % "ahk_id " List%A_Index% 
  }
}
;============================================================================================================================================================================
AlwaysOnTopOfTaskBar(){											;keeps on top of taskbar
DetectHiddenWindows, On 
Process, Exist
WinGet, hw_gui, ID, ahk_class AutoHotkeyGUI ahk_pid %ErrorLevel%
hw_tray := DllCall( "FindWindowEx", "uint", 0, "uint", 0, "str", "Shell_TrayWnd", "uint", 0 )
DllCall( "SetParent", "uint", hw_gui, "uint", hw_tray )

}
;============================================================================================================================================================================
NPPCheck(){													;Checks if notepad++ is open
IFWinExist, ahk_class Notepad++
	NPPEnabled=1
Else
	NPPEnabled:=0
}
;============================================================================================================================================================================
UnPinToTaskbar(FilePath)
{
    SplitPath,FilePath,File,Dir
    For i in ComObjCreate("Shell.Application").Namespace(Dir).ParseName(File).Verbs()
        if (i.Name = "Unpin from Tas&kbar")
            return i.DoIt()
}
;============================================================================================================================================================================

;============================================================================================================================================================================
															;button and checkbox actions below
OnAutoSaveEnabledChange: 
Gui Toggle: Submit, NoHide
If (AutoSaveEnabled == 1){
	Run, Autosave.ahk
}Else{
	x:=CloseScript("AutoSave.ahk")
}
x:=ControlGui()
Return
;============================================================================================================================================================================
OnClipboardHistoryEnabledChange: 
Gui Toggle: Submit, NoHide
If (ClipboardHistoryEnabled == 1){
	Run, ClipboardHistory.ahk, , ,ClipboardHistoryPID
}Else{
	x:=CloseScript("ClipboardHistory.ahk")
}
x:=ControlGui()
Return
;============================================================================================================================================================================
OnKeyBoardEnabledChange: 
Gui Toggle: Submit, NoHide
If (KeyBoardEnabled == 1){
	Run, *RunAs Keyboard.ahk, , ,KeyBoardPID
}Else{

	x:=CloseScript("Keyboard.ahk")
}
x:=ControlGui()
Return
;============================================================================================================================================================================
OnPVEnabledChange: 
Gui Toggle: Submit, NoHide
If (PVEnabled == 1){
	Run, PV+.ahk, , ,PVPID
}Else{
	x:=KillScript("PV+.ahk")
}
x:=ControlGui()
Return
;============================================================================================================================================================================
OnIPEnabledChange: 
Gui Toggle: Submit, NoHide
If (IPEnabled == 1){
	Run,*RunAs zIP.ahk, , ,IPPID
}Else{
	x:=KillScript("zIP.ahk")
}
x:=ControlGui()
Return
;============================================================================================================================================================================
OnNPPEnabledChange: 
Gui Toggle: Submit, NoHide
IFWinExist, ahk_class Notepad++
	NPPEnabled=1
Else
	NPPEnabled:=0
	
If (NPPEnabled == 1){
	WinActivate, ahk_class Notepad++
}Else{
	ShellRun("C:\Program Files (x86)\Notepad++\notepad++.exe")
}

x:=ControlGui()
Return
;============================================================================================================================================================================
OnEverythingButtonPress:
Gui Toggle: Submit, NoHide
Run, Everything.exe, C:\Program Files (x86)\Everything\ , , Everything
x:=ControlGui()
Return
;============================================================================================================================================================================
OnGDriveButtonPress:
Gui Toggle: Submit, NoHide
Run, GDrive.ahk, , , GDrive
x:=ControlGui()
Return
;============================================================================================================================================================================
OnNetworkButtonPress:
Gui Toggle: Submit, NoHide
Run, ncpa.cpl, C:\Windows\System32\, , Network
x:=ControlGui()
Return
;============================================================================================================================================================================
OnKillAllButtonPress:
x:=KillAll()
WinGetPos, xPos, yPos
Gui Toggle: Destroy
AutoSaveEnabled:=0
ClipboardHistoryEnabled:=0
KeyBoardEnabled:=0
PVEnabled:=0
IPEnabled:=0
x:=DisplayGui()
Return
;============================================================================================================================================================================
OnTestButtonPress:
Gui Toggle: Submit, NoHide
Run, Test.ahk, , , Test
x:=ControlGui()
Return
;============================================================================================================================================================================
OnExcelIPButtonPress:
Gui Toggle: Submit, NoHide
IfWinExist, Microsoft Excel - Ethernet Device Master Listing Caleb.xlsx
{
;msgbox, excel exists
WinActivate, Microsoft Excel - Ethernet Device Master Listing Caleb.xlsx
SendInput, ^s
WinClose, Microsoft Excel - Ethernet Device Master Listing Caleb.xlsx
}Else{
global Quote=""" "

global whyarevariablesdumb="\ExelIP.bat"
global ExcelFile:="""" . A_ScriptDir . "\"""


;MsgBox, %ExcelFile%
FileAppend,"G:\Depts\Process\WORKCELL\00 - SUBMIT\CALEB-mpp486\Ethernet Device Master Listing Caleb.xlsx", %A_ScriptDir%\ExcelIP.bat
ShellRun("C:/Users/mpp486/Desktop/AHK/ExcelIP.bat")
;RunWait, ExcelIP.bat, %A_ScriptDir%

WinWait, Microsoft Excel - Ethernet Device Master Listing Caleb.xlsx
WinClose, C:\Windows\system32\cmd.exe
FileDelete, %A_ScriptDir%\ExcelIP.bat
;SendInput,"G:\Depts\Process\WORKCELL\00 - SUBMIT\CALEB-mpp486\Ethernet_Device_Master_Listing_Caleb.xlsx"

;ShellRun("Excel",%ExcelFile%)
;Run %comspec% "G:\Depts\Process\WORKCELL\00 - SUBMIT\CALEB-mpp486\Ethernet Device Master Listing Caleb.xlsx"
;Run, *RunAs "Ethernet Device Master Listing Caleb.xlsx",%ExcelDir%  
;Run, *RunAs "reee.txt",G:\Depts\Process\WORKCELL\00 - SUBMIT\CALEB-mpp486, max  
}
x:=ControlGui()
Return
;============================================================================================================================================================================
OnCalcButtonPress:
Gui Toggle: Submit, NoHide
ShellRun("calc.exe") 
;Run, calc.exe, C:\Windows\System32\
x:=ControlGui()
Return
;============================================================================================================================================================================
OnTICalcButtonPress:
Gui Toggle: Submit, NoHide
ShellRun("C:\Program Files (x86)\TiEmu3-gdb\tiemu.exe")
x:=ControlGui()
Return 
;============================================================================================================================================================================
OnWordButtonPress:
Gui Toggle: Submit, NoHide
ShellRun("C:/Program Files (x86)/Microsoft Office/Office14/WINWORD.exe") 
;Run, calc.exe, C:\Windows\System32\
x:=ControlGui()
Return 
;============================================================================================================================================================================
OnExcelButtonPress:
Gui Toggle: Submit, NoHide
ShellRun("C:/Program Files (x86)/Microsoft Office/Office14/EXCEL.exe") 
;Run, calc.exe, C:\Windows\System32\
x:=ControlGui()
Return 
;============================================================================================================================================================================
OnPowerPointButtonPress:
Gui Toggle: Submit, NoHide
ShellRun("C:/Program Files (x86)/Microsoft Office/Office14/POWERPNT.exe") 
;Run, calc.exe, C:\Windows\System32\
x:=ControlGui()
Return 
;============================================================================================================================================================================
OnQuitButtonPress:
Gui Toggle: Destroy
;ExitApp
Return
;,"C:/Users/mpp486/Desktop/AHK" "/C"


;Parameters for ShellRun
;1 application to launch
;2 command line parameters
;3 working directory for the new process
;4 "Verb" (For example, pass "RunAs" to run as administrator)
;5 Suggestion to the application about how to show its window - see the msdn link for possible values

;ShellRun("Taskmgr.exe")  ;Task manager
;ShellRun("Notepad", A_ScriptFullPath)  ;Open a file with notepad
;ShellRun("Notepad",,,"RunAs")  ;Open untitled notepad as administrator

/*
  ShellRun by Lexikos
    requires: AutoHotkey_L
    license: http://creativecommons.org/publicdomain/zero/1.0/

  Credit for explaining this method goes to BrandonLive:
  http://brandonlive.com/2008/04/27/getting-the-shell-to-run-an-application-for-you-part-2-how/
 
  Shell.ShellExecute(File [, Arguments, Directory, Operation, Show])
  http://msdn.microsoft.com/en-us/library/windows/desktop/gg537745
*/
ShellRun(prms*)
{
    shellWindows := ComObjCreate("{9BA05972-F6A8-11CF-A442-00A0C90A8F39}")
    
    desktop := shellWindows.Item(ComObj(19, 8)) ; VT_UI4, SCW_DESKTOP                
   
    ; Retrieve top-level browser object.
    if ptlb := ComObjQuery(desktop
        , "{4C96BE40-915C-11CF-99D3-00AA004AE837}"  ; SID_STopLevelBrowser
        , "{000214E2-0000-0000-C000-000000000046}") ; IID_IShellBrowser
    {
        ; IShellBrowser.QueryActiveShellView -> IShellView
        if DllCall(NumGet(NumGet(ptlb+0)+15*A_PtrSize), "ptr", ptlb, "ptr*", psv:=0) = 0
        {
            ; Define IID_IDispatch.
            VarSetCapacity(IID_IDispatch, 16)
            NumPut(0x46000000000000C0, NumPut(0x20400, IID_IDispatch, "int64"), "int64")
           
            ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
            DllCall(NumGet(NumGet(psv+0)+15*A_PtrSize), "ptr", psv
                , "uint", 0, "ptr", &IID_IDispatch, "ptr*", pdisp:=0)
           
            ; Get Shell object.
            shell := ComObj(9,pdisp,1).Application
           
            ; IShellDispatch2.ShellExecute
            shell.ShellExecute(prms*)
           
            ObjRelease(psv)
        }
        ObjRelease(ptlb)
    }
}

MouseIsOver(WinTitle) {
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}