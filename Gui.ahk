#NoEnv  													; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  													; Enable warnings to assist with detecting common errors.
#SingleInstance force
;SendMode Input  											; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%									; Ensures a consistent starting directory.
#include C:\Users\mpp486\Desktop\AHK\#Include\Edit\_Functions
#include Edit.ahk
#include Fnt.ahk
;#include C:\Users\mpp486\Desktop\AHK\#Include\CMDret_RunReturn.ahk


													;name of each network device
global LAC1Name:="Local Area Connection"
global LAC2Name:="Local Area Connection 2"
global WifiName:="Wireless Network Connection"
													;found in regedit
													;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\
													;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters\Interfaces
													;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\													
global LAC1Key:="{E23055D8-D1E3-4448-B98B-EB1798F6BDF7}"
global LAC2Key:="{070D5348-3994-4343-8A41-9EDB2ACC6860}"
global WifiKey:="{A1160A2D-817C-406B-97E2-E1666A206D9C}"

													;preferred starting position
global xPos=1500
global yPos=400
global firstRun=1									;starts at (xPos, yPos) then stays whereever moved

global LAC1Enabled:=0								;network adapter states
global LAC2Enabled:=0
global WifiEnabled:=0

global LAC1DHCP
global LAC1IP										;actual LAC values
global LAC1Mask
global LAC1Gate
global LAC1DNS

global LAC2DHCP
global LAC2IP										;actual LAC 2 values
global LAC2Mask
global LAC2Gate
global LAC2DNS

global WifiDHCP
global WifiIP										;actaul wireless network values
global WifiMask
global WifiGate
global WifiDNS

global IPAdress										;'working' values to either be stored or displayed
global SubnetMask
global DefaultGateway
global PreferredDNSServer

global 2H250IPAdress:="192.168.1.250"				;2H's static settings
global 2H250SubnetMask:="255.255.0.0"
global 2H250DefaultGateway:="192.168.1.1"
global 2H250PreferredDNSServer:="192.168.1.1"

global 2H254IPAdress:="192.168.1.254"				;2H's static settings
global 2H254SubnetMask:="255.255.0.0"
global 2H254DefaultGateway:="192.168.1.1"
global 2H254PreferredDNSServer:="192.168.1.1"

global Wifi46IPAdress:="138.84.46.254"				;Wireless's static settings when switching between 46 & 57
global Wifi46SubnetMask:="255.255.255.0"
global Wifi46DefaultGateway:="138.84.46.1"
global Wifi46PreferredDNSServer:="138.84.46.1"

global S4IPAdress:="192.168.125.82"					;S4C+ static settings
global S4SubnetMask:="255.255.255.240"
global S4DefaultGateway:="192.168.125.81"
global S4PreferredDNSServer:="192.168.125.81"

global hIPAdressEdit								;not actually used, can be deleted?
global hSubnetMaskEdit
global hDefaultGatewayEdit
global hPreferredDNSServerEdit

global LAC1IPRadio									;network choice radio variables
global WifiIPRadio
global LAC2IPRadio

global EnterButton									;button variables
global DHCPButton
global 2H250Button
global 2H254Button
global Wifi46Button
global S4Button

global editBox										;other needed variables
global L
global RetrievedAdapterState
global EnableDHCPNext


x:=RetrieveNetworkStatus()							;so enabled checkboxes are correct upon gui starting
x:=GetLocalNetwork()								;gets Setting of network
x:=DisplayGui()										;displays gui
;`::Reload											;reloads script on ` press - for testing purposes


;============================================================================================================================================================================
DisplayGui(){										;displays gui
Gui, Name: New, +HwndMyGuiHwnd, IP
Gui IP: font, underline
Gui IP: Add, Text, x70, Enabled
Gui IP: font, norm

Gui IP:  Add, Checkbox, x10 y20 vLAC1Enabled hwndhLAC1Enabled gOnLAC1EnabledChange Checked%LAC1Enabled%, LAC
Gui IP:  Add, Checkbox, xp+60 yp vWifiEnabled hwndhWifiEnabled gOnWifiEnabledChange Checked%WifiEnabled%, Wifi
Gui IP:  Add, Checkbox, xp+60 yp vLAC2Enabled hwndhLAC2Enabled gOnLAC2EnabledChange Checked%LAC2Enabled%, LAC 2

Gui IP: Add, Text, x10 y40 w170 h1 0x7
Gui IP: Add, Text, x60 yp w1 h90 0x7  ;Line > Black
Gui IP: Add, Text, x10 y130 w170 h1 0x7
Gui IP: Add, Text, xp yp+60 w170 h1 0x7
Gui IP: Add, Text, xp yp+60 w170 h1 0x7
Gui IP: Add, Text, xp yp+60 w170 h1 0x7

Gui IP:  Add, Radio, x0 y50 Group vLAC1IPRadio hwndhLAC1IPRadio x10 gOnLAC1IPRadioChange Checked%LAC1IPRadio%, LAC
Gui IP:  Add, Radio, xp yp+20 vWifiIPRadio hwndhWifiIPRadio x10 gOnWifiIPRadioChange Checked%WifiIPRadio%, Wifi
Gui IP:  Add, Radio, xp yp+20 vLAC2IPRadio hwndhLAC2IPRadio x10 gOnLAC2IPRadioChange Checked%LAC2IPRadio%, LAC 2
Gui IP:  Add, Button, xp-5 yp+18 w50 vEnterButton hwndhEnterButton gOnEnterButtonPress Default, Enter

Gui IP:  Add, Text, x70 y50 w28 right, IP:
Gui IP:  Add, Edit, R1 vIPAdress xp+30 yp-3 w80 Limit15 -wrap hwndhIPAdressEdit gOnIPAdressEditChange, %IPAdress%

Gui IP:  Add, Text, x70 y70 w28 right, Mask:
Gui IP:  Add, Edit, R1 vSubnetMask xp+30 yp-3 w80 Limit15 -wrap hwndhSubnetMaskEdit gOnSubnetMaskEditChange, %SubnetMask%

Gui IP:  Add, Text, x70 y90 w28 right, Gate:
Gui IP:  Add, Edit, R1 vDefaultGateway xp+30 yp-3 w80 Limit15 -wrap hwndhDefaultGatewayEdit gOnDefaultGatewayEditChange, %DefaultGateway%

Gui IP:  Add, Text, x70 y110 w28 right, DNS:
Gui IP:  Add, Edit, R1 vPreferredDNSServer xp+30 yp-3 w80 Limit15 -wrap hwndhPreferredDNSServerEdit gOnPreferredDNSServerEditChange, %PreferredDNSServer%


Gui IP:  Add, Text, x50 y132 w28 right, IP:
Gui IP:  Add, Text, xp+30 yp, %LAC1IP%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Mask:
Gui IP:  Add, Text, xp+30 yp, %LAC1Mask%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Gate:
Gui IP:  Add, Text, xp+30 yp, %LAC1Gate%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, DNS:
Gui IP:  Add, Text, xp+30 yp, %LAC1DNS%
Gui IP: font, bold
Gui IP:  Add, Text, x5 y140  , LAC
Gui IP: font, norm
If (LAC1DHCP == 1){
Gui IP:  Add, Text, xp yp+20  , DHCP
}
Gui IP:  Add, Text, x50 y192 w28 right, IP:
Gui IP:  Add, Text, xp+30 yp, %WifiIP%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Mask:
Gui IP:  Add, Text, xp+30 yp, %WifiMask%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Gate:
Gui IP:  Add, Text, xp+30 yp, %WifiGate%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, DNS:
Gui IP:  Add, Text, xp+30 yp, %WifiDNS%
Gui IP: font, bold
Gui IP:  Add, Text, x5 y200  , Wifi
Gui IP: font, norm
If (WifiDHCP == 1){
Gui IP:  Add, Text, xp yp+20  , DHCP
}
Gui IP:  Add, Text, x50 y252 w28 right, IP:
Gui IP:  Add, Text, xp+30 yp, %LAC2IP%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Mask:
Gui IP:  Add, Text, xp+30 yp, %LAC2Mask%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Gate:
Gui IP:  Add, Text, xp+30 yp, %LAC2Gate%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, DNS:
Gui IP:  Add, Text, xp+30 yp, %LAC2DNS%
Gui IP: font, bold
Gui IP:  Add, Text, x5 y260  , LAC 2
Gui IP: font, norm
If (WifiDHCP == 1){
Gui IP:  Add, Text, xp yp+20  , DHCP
}

Gui IP:  Add, Button, x10 y312 w50 vDHCPButton hwndhDHCPButton gOnDHCPButtonPress, DHCP
Gui IP:  Add, Button, xp+60 yp w50 v2H250Button hwndh2H250Button gOn2H250ButtonPress, 2H (250)
Gui IP:  Add, Button, xp+60 yp w50 v2H254Button hwndh2H254Button gOn2H254ButtonPress, 2H (254)
Gui IP:  Add, Button, xp-120 yp+25 w50 h30 vWifi46Button hwndhWifi46Button gOnWifi46ButtonPress, Wifi (46.254)
Gui IP:  Add, Button, xp+60 yp+3 w50 vS4Button hwndhS4Button gOnS4ButtonPress, S4C+


 
if (firstRun = 0){											;show Gui
	Gui IP: Show, AutoSize ; x%xPos% y%yPos% w200 h200
	firstRun:=1
}Else{
	Gui IP: Show, x%xPos% y%yPos% ;w200 h200
}
Gui IP: +AlwaysOnTop
WinWait, Gui, , 5
;loop % 4 {													;removes . at the end of each Edit ; not actually needed due to DAF
;	ControlFocus, Edit%A_Index%, Gui
;	SendInput, {End}{BS}
;}
}
;============================================================================================================================================================================
SetNetworkConnection(NetworkName, DHCPEnabled, NewIPAddress, NewMask, NewGateway, NewDNS){ ;pretty self explanatory
If (DHCPEnabled == 1){
FileAppend, netsh interface ipv4 set address name="%NetworkName%" source=dhcp`nnetsh interface ipv4 set dnsservers name="%NetworkName%" source=dhcp, %A_ScriptDir%\SetNetworkConnection.bat
}Else{
FileAppend, netsh interface ipv4 set address name="%NetworkName%" source=static address=%NewIPAddress% mask=%NewMask% gateway=%NewGateway%`nnetsh interface ipv4 set dnsservers name="%NetworkName%" source=static address=%NewDNS%, %A_ScriptDir%\SetNetworkConnection.bat
}
RunWait, SetNetworkConnection.bat, %A_ScriptDir%
FileDelete, %A_ScriptDir%\SetNetworkConnection.bat
}
;============================================================================================================================================================================
GetLocalNetwork(){									;gets settings of each adapter
RegRead, LAC1DHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, EnableDHCP
RegRead, LAC2DHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, EnableDHCP
RegRead, WifiDHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, EnableDHCP

If (LAC1DHCP == 1) {
RegRead, LAC1IP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpIPAddress 
RegRead, LAC1Mask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpSubnetMask
RegRead, LAC1Gate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpDefaultGateway
RegRead, LAC1DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpNameServer

}Else{
RegRead, LAC1IP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, IPAddress
RegRead, LAC1Mask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%,SubnetMask
RegRead, LAC1Gate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DefaultGateway
RegRead, LAC1DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, NameServer
}

If (LAC2DHCP == 1) {
RegRead, LAC2IP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpIPAddress 
RegRead, LAC2Mask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpSubnetMask
RegRead, LAC2Gate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpDefaultGateway
RegRead, LAC2DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpNameServer

}Else{
RegRead, LAC2IP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, IPAddress
RegRead, LAC2Mask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%,SubnetMask
RegRead, LAC2Gate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DefaultGateway
RegRead, LAC2DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, NameServer
}

If (WifiDHCP == 1) {
RegRead, WifiIP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpIPAddress 
RegRead, WifiMask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpSubnetMask
RegRead, WifiGate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpDefaultGateway
RegRead, WifiDNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpNameServer

}Else{
RegRead, WifiIP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, IPAddress
RegRead, WifiMask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%,SubnetMask
RegRead, WifiGate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DefaultGateway
RegRead, WifiDNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, NameServer
}

;some DNS have > 1 address
LAC1IP:=SubStr(LAC1IP, 1, 15)
LAC1Mask:=SubStr(LAC1Mask, 1, 15)
LAC1Gate:=SubStr(LAC1Gate, 1, 15)
LAC1DNS:=SubStr(LAC1DNS, 1, 15)

LAC2IP:=SubStr(LAC2IP, 1, 15)
LAC2Mask:=SubStr(LAC2Mask, 1, 15)
LAC2Gate:=SubStr(LAC2Gate, 1, 15)
LAC2DNS:=SubStr(LAC2DNS, 1, 15)

WifiIP:=SubStr(WifiIP, 1, 15)
WifiMask:=SubStr(WifiMask, 1, 15)
WifiGate:=SubStr(WifiGate, 1, 15)
WifiDNS:=SubStr(WifiDNS, 1, 15)

LAC1IP:=RemoveLineFeeds(LAC1IP)
LAC1Mask:=RemoveLineFeeds(LAC1Mask)
LAC1Gate:=RemoveLineFeeds(LAC1Gate)
LAC1DNS:=RemoveLineFeeds(LAC1DNS)

LAC2IP:=RemoveLineFeeds(LAC2IP)
LAC2Mask:=RemoveLineFeeds(LAC2Mask)
LAC2Gate:=RemoveLineFeeds(LAC2Gate)
LAC2DNS:=RemoveLineFeeds(LAC2DNS)

WifiIP:=RemoveLineFeeds(WifiIP)
WifiMask:=RemoveLineFeeds(WifiMask)
WifiGate:=RemoveLineFeeds(WifiGate)
WifiDNS:=RemoveLineFeeds(WifiDNS)


}
;============================================================================================================================================================================
ChangeNetworkConnection(NetworkName, Status){		;Enabled, Disabled
FileAppend, netsh interface set interface "%NetworkName%" admin=%Status%, %A_ScriptDir%\ChangeNetworkConnection.bat
RunWait, ChangeNetworkConnection.bat, %A_ScriptDir%
FileDelete, %A_ScriptDir%\ChangeNetworkConnection.bat
}
;============================================================================================================================================================================
RemoveLineFeeds(StringVariable){					;removes `n & `r from strings - editbox's were displaying multiple lines after GetLocalNetwork() was called
StringReplace, StringVariable,StringVariable, `r,, All
StringReplace, StringVariable,StringVariable, `n,, All
Return StringVariable
}
;============================================================================================================================================================================
ButtonPress(){ 										;sets network connection based on radio &| dhcp(all blank inputs)
;MsgBox, %LAC1IPRadio%|%WifiIPRadio%|%LAC2IPRadio%
If (IPAdress == "") and (SubnetMask == "") and (DefaultGateway == "") and (PreferredDNSServer == ""){
	EnableDHCPNext:=1
}Else{
	EnableDHCPNext:=0
}
If (LAC1IPRadio == 1){
	If (EnableDHCPNext == 1){
		LAC1DHCP:=1
	}Else{
		LAC1DHCP:=0
	}
	SetNetworkConnection(LAC1Name, LAC1DHCP, IPAdress, SubnetMask, DefaultGateway, PreferredDNSServer)
}Else If (LAC2IPRadio == 1){
	If (EnableDHCPNext == 1){
		LAC2DHCP:=1
	}Else{
		LAC2DHCP:=0
	}
	SetNetworkConnection(LAC2Name, LAC2DHCP, IPAdress, SubnetMask, DefaultGateway, PreferredDNSServer)
}Else If (WifiIPRadio == 1){
	If (EnableDHCPNext == 1){
		WifiDHCP:=1
	}Else{
		WifiDHCP:=0
	}
	SetNetworkConnection(WifiName, WifiDHCP, IPAdress, SubnetMask, DefaultGateway, PreferredDNSServer)
}
}
;============================================================================================================================================================================
RetrieveNetworkStatus(){							;so enabled checkboxes are correct upon gui starting -  may need to call on EnterButtonPress to ensure accurate display
StatePosition=
														;Get LAC1 state
FileAppend, netsh interface show interface "%LAC1Name%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, %A_ScriptDir%\RetrieveNetworkStatus.bat
RunWait, RetrieveNetworkStatus.bat, %A_ScriptDir%
FileReadLine, RetrievedAdapterState, %A_ScriptDir%\RetrieveNetworkStatus.txt, 1
StatePosition:=InStr(RetrievedAdapterState,": ")
RetrievedAdapterState:= SubStr(RetrievedAdapterState, StatePosition + 2, 7)
If (InStr(RetrievedAdapterState,"Enabled") = 1){
LAC1Enabled:=1
}Else{
LAC1Enabled:=0
}
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.bat
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.txt

														;Get LAC2 state
FileAppend, netsh interface show interface "%LAC2Name%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, %A_ScriptDir%\RetrieveNetworkStatus.bat
RunWait, RetrieveNetworkStatus.bat, %A_ScriptDir%
FileReadLine, RetrievedAdapterState, %A_ScriptDir%\RetrieveNetworkStatus.txt, 1
StatePosition:=InStr(RetrievedAdapterState,": ")
RetrievedAdapterState:= SubStr(RetrievedAdapterState, StatePosition + 2, 7)
If (RetrievedAdapterState == "Enabled"){
LAC2Enabled:=1
}Else{
LAC2Enabled:=0
}
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.bat
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.txt


														;Get Wifi state
FileAppend, netsh interface show interface "%WifiName%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, %A_ScriptDir%\RetrieveNetworkStatus.bat
RunWait, RetrieveNetworkStatus.bat, %A_ScriptDir%
FileReadLine, RetrievedAdapterState, %A_ScriptDir%\RetrieveNetworkStatus.txt, 1
StatePosition:=InStr(RetrievedAdapterState,": ")
RetrievedAdapterState:= SubStr(RetrievedAdapterState, StatePosition + 2, 7)
If (RetrievedAdapterState == "Enabled"){
WifiEnabled:=1
}Else{
WifiEnabled:=0
}
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.bat
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.txt
}


 

;============================================================================================================================================================================
OnLAC1EnabledChange:								;checkbox enables or disables connection. EnterButton isn't pressed
Gui IP: Hide										;so stuff doesn't get messed with while settings are being changed
GuiControlGet, LAC1Enabled							;gets checked state
If (LAC1Enabled == 1){								;sets network based on state
ChangeNetworkConnection(LAC1Name, "Enabled")
}Else{
ChangeNetworkConnection(LAC1Name, "Disabled")
}
Gui IP: Show										;show gui once network change is complete
Return
;============================================================================================================================================================================
OnLAC2EnabledChange:								;checkbox enables or disables connection. EnterButton isn't pressed
Gui IP: Hide										;so stuff doesn't get messed with while settings are being changed
GuiControlGet, LAC2Enabled							;gets checked state
If (LAC2Enabled == 1){								;sets network based on state
ChangeNetworkConnection(LAC2Name, "Enabled")
}Else{
ChangeNetworkConnection(LAC2Name, "Disabled")
}
Gui IP: Show										;show gui once network change is complete
Return
;============================================================================================================================================================================
OnWifiEnabledChange:								;checkbox enables or disables connection. EnterButton isn't pressed
Gui IP: Hide										;so stuff doesn't get messed with while settings are being changed
GuiControlGet, WifiEnabled							;gets checked state
If (WifiEnabled == 1){								;sets network based on state
ChangeNetworkConnection(WifiName, "Enabled")
}Else{
ChangeNetworkConnection(WifiName, "Disabled")
}
Gui IP: Show										;show gui once network change is complete
Return
;============================================================================================================================================================================
OnLAC1IPRadioChange:								;loads current network settings into edit box's
x:=GetLocalNetwork()
GuiControl,,IPAdress,%LAC1IP%
GuiControl,,SubnetMask,%LAC1Mask%
GuiControl,,DefaultGateway,%LAC1Gate%
GuiControl,,PreferredDNSServer,%LAC1DNS%
Return
;============================================================================================================================================================================
OnLAC2IPRadioChange:								;loads current network settings into edit box's
x:=GetLocalNetwork()
GuiControl,,IPAdress,%LAC2IP%
GuiControl,,SubnetMask,%LAC2Mask%
GuiControl,,DefaultGateway,%LAC2Gate%
GuiControl,,PreferredDNSServer,%LAC2DNS%
Return 
;============================================================================================================================================================================
OnWifiIPRadioChange:								;loads current network settings into edit box's
x:=GetLocalNetwork()
GuiControl,,IPAdress,%WifiIP%
GuiControl,,SubnetMask,%WifiMask%
GuiControl,,DefaultGateway,%WifiGate%
GuiControl,,PreferredDNSServer,%WifiDNS%
Return
;============================================================================================================================================================================
OnIPAdressEditChange:
Return
;============================================================================================================================================================================
OnSubnetMaskEditChange:
Return
;============================================================================================================================================================================
OnDefaultGatewayEditChange:
Return
;============================================================================================================================================================================
OnPreferredDNSServerEditChange:
Return
;============================================================================================================================================================================
OnEnterButtonPress:									;sets adapter of selected radio with settings in edit boxes 
Gui IP: Submit, NoHide
WinGetPos, xPos, yPos
Gui IP: Destroy
x:=ButtonPress()
x:=GetLocalNetwork()
x:=DisplayGui()
Return
;============================================================================================================================================================================
OnDHCPButtonPress:									;submits to get radio status, then sets 'working' network vars to blank so DHCP becomes enabled
Gui IP: Submit, NoHide
IPAdress:=""
SubnetMask:=""
DefaultGateway:=""
PreferredDNSServer:=""
WinGetPos, xPos, yPos
Gui IP: Destroy
x:=ButtonPress()
x:=GetLocalNetwork()
x:=DisplayGui()
Return
/*
;============================================================================================================================================================================
OnLAC1DHCPCheckboxChange:							;Was going to have DCHP checkbox's but ended up not needing them...
RegRead, LAC1DHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\{E23055D8-D1E3-4448-B98B-EB1798F6BDF7}, EnableDHCP
GuiControl, , hLAC1DHCPCheckbox, %LAC1DHCP%
Return
;============================================================================================================================================================================
OnLAC2DHCPCheckboxChange:							;Was going to have DCHP checkbox's but ended up not needing them...
RegRead, LAC2DHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\{070D5348-3994-4343-8A41-9EDB2ACC6860}, EnableDHCP
GuiControl, , hLAC2DHCPCheckbox, %LAC2DHCP%
Return
;============================================================================================================================================================================
OnWifiDHCPCheckboxChange:							;Was going to have DCHP checkbox's but ended up not needing them...
RegRead, WifiDHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\{A1160A2D-817C-406B-97E2-E1666A206D9C}, EnableDHCP
GuiControl, , hWifiDHCPCheckbox, %WifiDHCP%
Return
*/
;============================================================================================================================================================================
On2H250ButtonPress:									;sets based on var settings. 
Gui IP: Submit, NoHide
IPAdress:=2H250IPAdress
SubnetMask:=2H250SubnetMask
DefaultGateway:=2H250DefaultGateway
PreferredDNSServer:=2H250PreferredDNSServer
WinGetPos, xPos, yPos
Gui IP: Destroy
x:=ButtonPress()
x:=GetLocalNetwork()
x:=DisplayGui()

Return
;============================================================================================================================================================================
On2H254ButtonPress:									;sets based on var settings. 
Gui IP: Submit, NoHide
IPAdress:=2H254IPAdress
SubnetMask:=2H254SubnetMask
DefaultGateway:=2H254DefaultGateway
PreferredDNSServer:=2H254PreferredDNSServer
WinGetPos, xPos, yPos
Gui IP: Destroy
x:=ButtonPress()
x:=GetLocalNetwork()
x:=DisplayGui()

Return
;============================================================================================================================================================================
OnWifi46ButtonPress:								;sets based on var settings - may need FORCE wifi to be changed... 
Gui IP: Submit, NoHide
IPAdress:=Wifi46IPAdress
SubnetMask:=Wifi46SubnetMask
DefaultGateway:=Wifi46DefaultGateway
PreferredDNSServer:=Wifi46PreferredDNSServer
WinGetPos, xPos, yPos
Gui IP: Destroy
x:=ButtonPress()
x:=GetLocalNetwork()
x:=DisplayGui()

Return
;============================================================================================================================================================================
OnS4ButtonPress:									;sets based on var settings - may need to FORCE LAC to be changed....
Gui IP: Submit, NoHide
IPAdress:=S4IPAdress
SubnetMask:=S4SubnetMask
DefaultGateway:=S4DefaultGateway
PreferredDNSServer:=S4PreferredDNSServer
WinGetPos, xPos, yPos
Gui IP: Destroy
x:=ButtonPress()
x:=GetLocalNetwork()
x:=DisplayGui()

Return
;============================================================================================================================================================================

Return
;============================================================================================================================================================================


GuiClose:
    ExitApp
Return



