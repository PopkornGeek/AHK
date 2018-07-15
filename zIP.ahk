#NoTrayIcon
#NoEnv  													; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  													; Enable warnings to assist with detecting common errors.
#SingleInstance force
;SendMode Input  											; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%									; Ensures a consistent starting directory.
;#NoTrayIcon
#include C:\Users\mpp486\Desktop\AHK\#Include\Edit\_Functions
#include Edit.ahk
#include Fnt.ahk
;#include C:\Users\mpp486\Desktop\AHK\#Include\CMDret_RunReturn.ahk


													;name of each network device
global LAC1Name:="Ethernet"
global LAC2Name:="Ethernet 3"
global WifiName:="Wi-Fi"
													;found in regedit
													;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\
													;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\TCPIP6\Parameters\Interfaces\
													;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\													
global LAC1Key:="{ad8060f1-decb-4e6c-866a-490a4126fd10}" ;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\
global LAC2Key:="{d4c8087b-83cc-4005-87da-e69b667a941e}"
global WifiKey:="{6a9c9426-708e-4f2a-a1ed-5c6658c83594}" ;HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\

													;preferred starting position
global xPos=A_ScreenWidth-100

global yPos=A_ScreenHeight-593
global firstRun=1									;starts at (xPos, yPos) then stays whereever moved

global LAC1Prefix:= "LAC1"							;kinda redundant but whatever
global LAC2Prefix:= "LAC2"
global WifiPrefix:= "Wifi"

global LAC1Enabled:=1								;network adapter states
global LAC2Enabled:=0
global WifiEnabled:=0

global LAC1DHCP
global LAC1IP										;actual LAC values
global LAC1Mask
global LAC1Gate
global LAC1DNS
global LAC1CustomDNS:=0

global LAC2DHCP
global LAC2IP										;actual LAC 2 values
global LAC2Mask
global LAC2Gate
global LAC2DNS
global LAC2CustomDNS:=0

global WifiDHCP
global WifiIP										;actaul wireless network values
global WifiMask
global WifiGate
global WifiDNS
global WifiCustomDNS:=0

global IPAdress										;'working' values to either be stored or displayed
global SubnetMask
global DefaultGateway
global PreferredDNSServer

global 2H250IPAdress:="192.168.1.250"				;2H's static settings
global 2H250SubnetMask:="255.255.0.0"
global 2H250DefaultGateway:="192.168.1.1"
global 2H250PreferredDNSServer:="192.168.1.1"

global 2H254IPAdress:="138.84.57.254"				;LAC static settings setup for network connection when not working
global 2H254SubnetMask:="255.255.255.0"
global 2H254DefaultGateway:="138.84.57.1"
global 2H254PreferredDNSServer:="138.84.57.1"

global Wifi46IPAdress:="138.84.46.254"				;Wireless's static settings when switching between 46 & 57
global Wifi46SubnetMask:="255.255.255.0"
global Wifi46DefaultGateway:="138.84.46.1"
global Wifi46PreferredDNSServer:="138.84.46.1"

global S4IPAdress:="192.168.125.82"					;S4C+ static settings
global S4SubnetMask:="255.255.255.240"
global S4DefaultGateway:="192.168.125.81"
global S4PreferredDNSServer:="192.168.125.81"

global 6HIPAdress:="192.168.60.4"					;6h static settings
global 6HSubnetMask:="255.255.0.0"
global 6HDefaultGateway:="192.168.60.1"
global 6HPreferredDNSServer:="192.168.60.1" 

global DNSPrimary:="1.1.1.1"
global DNSSecondary:="1.0.0.1"

global hIPAdressEdit								;not actually used, can be deleted?
global hSubnetMaskEdit
global hDefaultGatewayEdit
global hPreferredDNSServerEdit

global LAC1IPRadio:=0									;network choice radio variables
global WifiIPRadio:=1
global LAC2IPRadio:=0

global EnterButton									;button variables
global DHCPButton
global 2H250Button
global 2H254Button
global Wifi46Button
global S4Button
global 6HButton
global LAC1DetailsButton
global WifiDetailsButton
global LAC2DetailsButton
global LAC1PropertiesButton
global WifiPropertiesButton
global LAC2PropertiesButton
global DNSButton

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

Gui IP:  Add, Checkbox, xp-60 yp+15 vLAC1Enabled hwndhLAC1Enabled gOnLAC1EnabledChange Checked%LAC1Enabled%, LAC
Gui IP:  Add, Checkbox, xp+60 yp vWifiEnabled hwndhWifiEnabled gOnWifiEnabledChange Checked%WifiEnabled%, Wifi
Gui IP:  Add, Checkbox, xp+60 yp vLAC2Enabled hwndhLAC2Enabled gOnLAC2EnabledChange Checked%LAC2Enabled%, LAC 2


Gui IP:  Add, Button, xp-120 yp+18 w50 h14 vLAC1DetailsButton hwndhLAC1DetailsButton gOnLAC1DetailsButtonPress, Details
Gui IP:  Add, Button, xp+60 yp w50 h14 vWifiDetailsButton hwndhWifiDetailsButton gOnWifiDetailsButtonPress, Details
Gui IP:  Add, Button, xp+60 yp w50 h14 vLAC2DetailsButton hwndhLAC2DetailsButton gOnLAC2DetailsButtonPress, Details

Gui IP:  Add, Button, xp-120 yp+16 w50 h14 vLAC1PropertiesButton hwndhLAC1PropertiesButton gOnLAC1PropertiesButtonPress, Prop
Gui IP:  Add, Button, xp+60 yp w50 h14 vWifiPropertiesButton hwndhWifiPropertiesButton gOnWifiPropertiesButtonPress, Prop
Gui IP:  Add, Button, xp+60 yp w50 h14 vLAC2PropertiesButton hwndhLAC2PropertiesButton gOnLAC2PropertiesButtonPress, Prop

Gui IP: Add, Text, xp-120 yp+20 w170 h1 0x7
Gui IP: Add, Text, xp+50 yp w1 h90 0x7  ;Line > Black
Gui IP: Add, Text, xp-50 yp+90 w170 h1 0x7
Gui IP: Add, Text, xp yp+60 w170 h1 0x7
Gui IP: Add, Text, xp yp+60 w170 h1 0x7
Gui IP: Add, Text, xp yp+60 w170 h1 0x7

Gui IP:  Add, Radio, xp yp-260 Group vLAC1IPRadio hwndhLAC1IPRadio x10 gOnLAC1IPRadioChange Checked%LAC1IPRadio%, LAC
Gui IP:  Add, Radio, xp yp+20 h15 vWifiIPRadio hwndhWifiIPRadio x10 gOnWifiIPRadioChange Checked%WifiIPRadio%, Wifi
Gui IP:  Add, Radio, xp yp+20 w50 h15 vLAC2IPRadio hwndhLAC2IPRadio x10 gOnLAC2IPRadioChange Checked%LAC2IPRadio%, LAC 2
Gui IP:  Add, Button, xp-5 yp+16 w50 vEnterButton hwndhEnterButton gOnEnterButtonPress , Enter 	;used to have 'default' property to be selected automatically
GuiControl, IP:,  LAC1IPRadio, %LAC1IPRadio%													;must have 'IP:' as second property or does nothing to the gui

Gui IP:  Add, Text, xp+65 yp-58 w28 right, IP:
Gui IP:  Add, Edit, R1 vIPAdress xp+30 yp-3 w80 Limit15 -wrap hwndhIPAdressEdit gOnIPAdressEditChange, %IPAdress%

Gui IP:  Add, Text, xp-30 yp+23 w28 right, Mask:
Gui IP:  Add, Edit, R1 vSubnetMask xp+30 yp-3 w80 Limit15 -wrap hwndhSubnetMaskEdit gOnSubnetMaskEditChange, %SubnetMask%

Gui IP:  Add, Text, xp-30 yp+23 w28 right, Gate:
Gui IP:  Add, Edit, R1 vDefaultGateway xp+30 yp-3 w80 Limit15 -wrap hwndhDefaultGatewayEdit gOnDefaultGatewayEditChange, %DefaultGateway%

Gui IP:  Add, Text, xp-30 yp+23 w28 right, DNS:
Gui IP:  Add, Edit, R1 vPreferredDNSServer xp+30 yp-3 w80 Limit15 -wrap hwndhPreferredDNSServerEdit gOnPreferredDNSServerEditChange, %PreferredDNSServer%


Gui IP:  Add, Text, xp-50 yp+27 w28 right, IP:
Gui IP:  Add, Text, xp+30 yp, %LAC1IP%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Mask:
Gui IP:  Add, Text, xp+30 yp, %LAC1Mask%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Gate:
Gui IP:  Add, Text, xp+30 yp, %LAC1Gate%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, DNS:
Gui IP:  Add, Text, xp+30 yp, %LAC1DNS%
Gui IP: font, bold
Gui IP:  Add, Text, xp-75 yp-37  , LAC
Gui IP: font, norm
If (LAC1DHCP == 1){
Gui IP:  Add, Text, xp yp+20  , DHCP
}Else{
Gui IP:  Add, Text, xp yp+20  ,
}
Gui IP:  Add, Text, xp+45 yp+31 w28 right, IP:
Gui IP:  Add, Text, xp+30 yp, %WifiIP%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Mask:
Gui IP:  Add, Text, xp+30 yp, %WifiMask%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Gate:
Gui IP:  Add, Text, xp+30 yp, %WifiGate%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, DNS:
Gui IP:  Add, Text, xp+30 yp, %WifiDNS%
Gui IP: font, bold
Gui IP:  Add, Text, xp-75 yp-37  , Wifi
Gui IP: font, norm
If (WifiDHCP == 1){
Gui IP:  Add, Text, xp yp+20  , DHCP
}Else{
Gui IP:  Add, Text, xp yp+20  ,
}
Gui IP:  Add, Text, xp+45 yp+32 w28 right, IP:
Gui IP:  Add, Text, xp+30 yp, %LAC2IP%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Mask:
Gui IP:  Add, Text, xp+30 yp, %LAC2Mask%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, Gate:
Gui IP:  Add, Text, xp+30 yp, %LAC2Gate%
Gui IP:  Add, Text, xp-30 yp+15 w28 right, DNS:
Gui IP:  Add, Text, xp+30 yp, %LAC2DNS%
Gui IP: font, bold
Gui IP:  Add, Text, xp-75 yp-37  , LAC 2
Gui IP: font, norm
If (LAC2DHCP == 1){
Gui IP:  Add, Text, xp yp+20  , DHCP
}Else{
Gui IP:  Add, Text, xp yp+20  ,
}

Gui IP:  Add, Button, xp+5 yp+32 w50 vDHCPButton hwndhDHCPButton gOnDHCPButtonPress, DHCP
Gui IP:  Add, Button, xp+60 yp w50 v2H250Button hwndh2H250Button gOn2H250ButtonPress, 2H (250)
Gui IP:  Add, Button, xp+60 yp w50 v2H254Button hwndh2H254Button gOn2H254ButtonPress, 84.57
Gui IP:  Add, Button, xp-120 yp+25 w50 h30 vWifi46Button hwndhWifi46Button gOnWifi46ButtonPress, Wifi (46.254)
Gui IP:  Add, Button, xp+60 yp+3 w50 vS4Button hwndhS4Button gOnS4ButtonPress, S4C+
Gui IP:  Add, Button, xp+60 yp w50 v6HButton hwndh6HButton gOn6HButtonPress, 6H (4)
Gui IP:  Add, Button, xp-120 yp+30 w50 vDNSButton hwndhDNSButton gOnDNSButtonPress, DNS

Gui IP:  Color, AEE7F0
if (firstRun = 1){											;show Gui
	xPos:=A_ScreenWidth-247+30 ;A_GuiWidth
	yPos:=A_ScreenHeight-473 ;A_GuiHeight
	Gui IP: Show, x%xPos% y%yPos% h405
	firstRun:=0
}Else{
	Gui IP: Show, x%xPos% y%yPos% h405 ;w200
}
Gui IP: +AlwaysOnTop -Border +Owner +MinSize +MaxSize
;WinWait, Gui, , 5
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
SetDNS(NetworkName, CustomDNS, DNS1, DNS2){ ;pretty self explanatory
If (CustomDNS == 0){
FileAppend, netsh interface ipv4 set dnsservers name="%NetworkName%" source=dhcp, %A_ScriptDir%\SetDNS.bat
}Else{
FileAppend, netsh interface ipv4 set dnsservers "%NetworkName%" static %DNS1% both, %A_ScriptDir%\SetDNS.bat
RunWait, SetDNS.bat, %A_ScriptDir%
FileDelete, %A_ScriptDir%\SetDNS.bat ;wouldn't work as 2 lines in 1 .bat, so ran 1st, then run 2nd
sleep 100
FileAppend, netsh interface ip add dns name="%NetworkName%" %DNS2% index=2, %A_ScriptDir%\SetDNS.bat
}
RunWait, SetDNS.bat, %A_ScriptDir%
FileDelete, %A_ScriptDir%\SetDNS.bat
}

;============================================================================================================================================================================
GetLocalNetwork(){									;gets settings of each adapter

RegRead, LAC1DHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, EnableDHCP
RegRead, LAC2DHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, EnableDHCP
RegRead, WifiDHCP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, EnableDHCP

RegRead, LAC1DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, NameServer
RegRead, LAC2DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, NameServer
RegRead, WifiDNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, NameServer
;msgbox, LAC1CustomDNS =%LAC1CustomDNS% `nLAC2CustomDNS =%LAC2CustomDNS% `n WifiCustomDNS =%WifiCustomDNS%`n`nLAC1DNS=%LAC1DNS%`nWifiDNS=%WifiDNS%`nLAC2DNS=%LAC2DNS%`nPreferredDNSServer=%PreferredDNSServer%

If (LAC1DNS == ""){
RegRead, LAC1DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpNameServer
LAC1CustomDNS = 0
}Else{
LAC1CustomDNS = 1
}
If (LAC2DNS == ""){
RegRead, LAC2DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpNameServer
LAC2CustomDNS = 0
}Else{
LAC2CustomDNS = 1
}
If (WifiDNS == ""){
RegRead, WifiDNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpNameServer
WifiCustomDNS = 0
}Else{
WifiCustomDNS = 1
}

If (LAC1DHCP == 1) {
RegRead, LAC1IP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpIPAddress 
RegRead, LAC1Mask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpSubnetMask
RegRead, LAC1Gate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpDefaultGateway
;RegRead, LAC1DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DhcpNameServer

}Else{
RegRead, LAC1IP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, IPAddress
RegRead, LAC1Mask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%,SubnetMask
RegRead, LAC1Gate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, DefaultGateway
;RegRead, LAC1DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, NameServer
}
;If (LAC1CustomDNS == 1) {
;RegRead, LAC1DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC1Key%, NameServer
;}

If (LAC2DHCP == 1) {
RegRead, LAC2IP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpIPAddress 
RegRead, LAC2Mask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpSubnetMask
RegRead, LAC2Gate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpDefaultGateway
;RegRead, LAC2DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DhcpNameServer

}Else{
RegRead, LAC2IP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, IPAddress
RegRead, LAC2Mask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%,SubnetMask
RegRead, LAC2Gate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, DefaultGateway
;RegRead, LAC2DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, NameServer
}
;If (LAC2CustomDNS == 1) {
;RegRead, LAC2DNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%LAC2Key%, NameServer
;}

If (WifiDHCP == 1) {
RegRead, WifiIP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpIPAddress 
RegRead, WifiMask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpSubnetMask
RegRead, WifiGate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpDefaultGateway
;RegRead, WifiDNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DhcpNameServer
}Else{
RegRead, WifiIP, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, IPAddress
RegRead, WifiMask, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%,SubnetMask
RegRead, WifiGate, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, DefaultGateway
;RegRead, WifiDNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, NameServer
}
;If (WifiCustomDNS == 1) {
;RegRead, WifiDNS, HKEY_LOCAL_MACHINE, SYSTEM\CurrentControlSet\services\Tcpip\Parameters\Interfaces\%WifiKey%, NameServer
;}

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
;msgbox, LAC1CustomDNS =%LAC1CustomDNS% `nLAC2CustomDNS =%LAC2CustomDNS% `n WifiCustomDNS =%WifiCustomDNS%`n`nWifiDNS=%WifiDNS%`nPreferredDNSServer=%PreferredDNSServer%


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
		LAC1CustomDNS:=0
	}Else{
		LAC1DHCP:=0
	}
	SetNetworkConnection(LAC1Name, LAC1DHCP, IPAdress, SubnetMask, DefaultGateway, PreferredDNSServer)
}Else If (LAC2IPRadio == 1){
	If (EnableDHCPNext == 1){
		LAC2DHCP:=1
		LAC2CustomDNS:=0
	}Else{
		LAC2DHCP:=0
	}
	SetNetworkConnection(LAC2Name, LAC2DHCP, IPAdress, SubnetMask, DefaultGateway, PreferredDNSServer)
}Else If (WifiIPRadio == 1){
	If (EnableDHCPNext == 1){
		WifiDHCP:=1
		WifiCustomDNS:=0
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
;FileAppend, netsh interface show interface "%LAC1Name%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, %A_ScriptDir%\RetrieveNetworkStatus.bat
;RunWait, RetrieveNetworkStatus.bat, %A_ScriptDir%

RunWait, %comspec% /c netsh interface show interface "%LAC1Name%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, ,Hide ,CMD
FileReadLine, RetrievedAdapterState, %A_ScriptDir%\RetrieveNetworkStatus.txt, 1
StatePosition:=InStr(RetrievedAdapterState,": ")
RetrievedAdapterState:= SubStr(RetrievedAdapterState, StatePosition + 2, 7)
If (InStr(RetrievedAdapterState,"Enabled") = 1){
LAC1Enabled:=1
}Else{
LAC1Enabled:=0
}
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.txt

														;Get LAC2 state
;FileAppend, netsh interface show interface "%LAC2Name%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, %A_ScriptDir%\RetrieveNetworkStatus.bat
;RunWait, RetrieveNetworkStatus.bat, %A_ScriptDir%
RunWait, %comspec% /c netsh interface show interface "%LAC2Name%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, ,Hide ,CMD
FileReadLine, RetrievedAdapterState, %A_ScriptDir%\RetrieveNetworkStatus.txt, 1
StatePosition:=InStr(RetrievedAdapterState,": ")
RetrievedAdapterState:= SubStr(RetrievedAdapterState, StatePosition + 2, 7)
If (RetrievedAdapterState == "Enabled"){
LAC2Enabled:=1
}Else{
LAC2Enabled:=0
}
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.txt


														;Get Wifi state
;FileAppend, netsh interface show interface "%WifiName%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, %A_ScriptDir%\RetrieveNetworkStatus.bat
;RunWait, RetrieveNetworkStatus.bat, %A_ScriptDir%

RunWait, %comspec% /c netsh interface show interface "%WifiName%" |find /I "Administrative State: " >%A_ScriptDir%\RetrieveNetworkStatus.txt, ,Hide ,CMD
FileReadLine, RetrievedAdapterState, %A_ScriptDir%\RetrieveNetworkStatus.txt, 1
StatePosition:=InStr(RetrievedAdapterState,": ")
RetrievedAdapterState:= SubStr(RetrievedAdapterState, StatePosition + 2, 7)
If (RetrievedAdapterState == "Enabled"){
WifiEnabled:=1
}Else{
WifiEnabled:=0
}
FileDelete, %A_ScriptDir%\RetrieveNetworkStatus.txt
}
;============================================================================================================================================================================
OpenNetworkAndSharing(){
while WinExist("Network Connections")																						;kill Internet Explorer if open
{
WinKill, Network Connections 
sleep 100
}

Run, ncpa.cpl, C:\Windows\System32
WinWait, ahk_class CabinetWClass, , 5
WinActivate, ahk_class CabinetWClass
WinMove, ahk_class CabinetWClass, , 350, 200, 1500,700
MouseClick, R, 250, 350, 1, 1
SendInput, v
SendInput, d
}
;============================================================================================================================================================================
OpenIPProperties(ConnectionName, NamePrefix){
x:=OpenNetworkAndSharing()
SendInput, %ConnectionName%							;selects connection
SendInput, {Enter}										;file menu
If (%NamePrefix%Enabled == 1){
	WinWait, %ConnectionName% Properties, , 1
	IfWinExist, %ConnectionName% Status
	{
		Sleep, 250
		SendInput, !p
	}
	
}	
WinWait, %ConnectionName% Properties, , 5					;wait for properties to load
;WinActivate, Local Area Connection Properties
Send, {Down 3}										;selects IPv4
SendInput, !r
}
;============================================================================================================================================================================
OpenIPDetails(ConnectionName, NamePrefix){
x:=OpenNetworkAndSharing()
SendInput, %ConnectionName%								;selects connection
SendInput, {Enter}										;file menu
If (%NamePrefix%Enabled == 1){
	WinWait, %ConnectionName% Properties, , 1
	IfWinExist, %ConnectionName% Status
	{
		SendInput, !e
	}
}
}
;============================================================================================================================================================================
 ShellRun(prms*){ 									;copied from toggle.ahk
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
 ;============================================================================================================================================================================
 
Return												;was running OnLAC1EnabledChange everytime anything was done....
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

x:=RetrieveNetworkStatus()
GuiControl,,LAC1Enabled, %LAC1Enabled%
GuiControl,,LAC2Enabled, %LAC2Enabled%
GuiControl,,WifiEnabled, %WifiEnabled%
Return
;============================================================================================================================================================================
OnLAC2IPRadioChange:								;loads current network settings into edit box's
x:=GetLocalNetwork()
GuiControl,,IPAdress,%LAC2IP%
GuiControl,,SubnetMask,%LAC2Mask%
GuiControl,,DefaultGateway,%LAC2Gate%
GuiControl,,PreferredDNSServer,%LAC2DNS%
x:=RetrieveNetworkStatus()
GuiControl,,LAC1Enabled, %LAC1Enabled%
GuiControl,,LAC2Enabled, %LAC2Enabled%
GuiControl,,WifiEnabled, %WifiEnabled%
Return 
;============================================================================================================================================================================
OnWifiIPRadioChange:								;loads current network settings into edit box's
x:=GetLocalNetwork()
GuiControl,,IPAdress,%WifiIP%
GuiControl,,SubnetMask,%WifiMask%
GuiControl,,DefaultGateway,%WifiGate%
GuiControl,,PreferredDNSServer,%WifiDNS%
x:=RetrieveNetworkStatus()
GuiControl,,LAC1Enabled, %LAC1Enabled%
GuiControl,,LAC2Enabled, %LAC2Enabled%
GuiControl,,WifiEnabled, %WifiEnabled%
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
x:=RetrieveNetworkStatus()
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
x:=RetrieveNetworkStatus()
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
ChangeNetworkConnection(WifiName, "Disabled")
ChangeNetworkConnection(LAC1Name, "Enabled")
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
ChangeNetworkConnection(WifiName, "Disabled")
ChangeNetworkConnection(LAC1Name, "Enabled")
IPAdress:=S4IPAdress
SubnetMask:=S4SubnetMask
DefaultGateway:=S4DefaultGateway
PreferredDNSServer:=S4PreferredDNSServer
WinGetPos, xPos, yPos
Gui IP: Destroy
LAC1IPRadio = 1
x:=ButtonPress()
x:=GetLocalNetwork()
x:=DisplayGui()

IfWinExist ahk_exe filezilla.exe
	{
}Else{
	ShellRun("C:\Program Files\FileZilla FTP Client\filezilla.exe")

}
Return
;============================================================================================================================================================================
On6HButtonPress:									;sets based on var settings - may need to FORCE LAC to be changed....
Gui IP: Submit, NoHide
IPAdress:=6HIPAdress
SubnetMask:=6HSubnetMask
DefaultGateway:=6HDefaultGateway
PreferredDNSServer:=6HPreferredDNSServer
WinGetPos, xPos, yPos
Gui IP: Destroy
x:=ButtonPress()
x:=GetLocalNetwork()
x:=DisplayGui()
Return

;============================================================================================================================================================================
OnDNSButtonPress:									;sets based on var settings - may need to FORCE LAC to be changed....
Gui IP: Submit, NoHide

;PreferredDNSServer:=DNSPrimary
DNSPrimary:="1.1.1.1"
DNSSecondary:="1.0.0.1"

If (LAC1IPRadio == 1){
	If (LAC1CustomDNS == 0){
		LAC1CustomDNS=1
	}Else{
		LAC1CustomDNS:=0
	}
	x:=SetDNS(LAC1Name, LAC1CustomDNS, DNSPrimary, DNSSecondary)
}Else If (LAC2IPRadio == 1){
	If (LAC2CustomDNS == 0){
		LAC2CustomDNS:=1
	}Else{
		LAC2CustomDNS:=0
	}
	x:=SetDNS(LAC2Name, LAC2CustomDNS, DNSPrimary, DNSSecondary)
}Else If (WifiIPRadio == 1){
	If (WifiCustomDNS == 0){
		WifiCustomDNS:=1
	}Else{
		WifiCustomDNS:=0
	}
	x:=SetDNS(WifiName, WifiCustomDNS, DNSPrimary, DNSSecondary)
}

WinGetPos, xPos, yPos
Gui IP: Destroy
x:=GetLocalNetwork()
If (LAC1IPRadio == 1){
PreferredDNSServer:=LAC1DNS
}Else If (LAC2IPRadio == 1){
PreferredDNSServer:=LAC2DNS
}Else If (WifiIPRadio == 1){
PreferredDNSServer:=WifiDNS
}
x:=DisplayGui()
Return
;============================================================================================================================================================================
OnLAC1DetailsButtonPress:
OpenIPDetails(LAC1Name, LAC1Prefix)
Return
;============================================================================================================================================================================
OnWifiDetailsButtonPress:
OpenIPDetails(WifiName, WifiPrefix)
Return
;============================================================================================================================================================================
OnLAC2DetailsButtonPress:
OpenIPDetails(LAC2Name, LAC2Prefix)
Return
;============================================================================================================================================================================
OnLAC1PropertiesButtonPress:
OpenIPProperties(LAC1Name, LAC1Prefix)
Return
;============================================================================================================================================================================
OnWifiPropertiesButtonPress:
OpenIPProperties(WifiName, WifiPrefix)
Return
;============================================================================================================================================================================
OnLAC2PropertiesButtonPress:
OpenIPProperties(LAC2Name, LAC2Prefix)
Return


GuiClose:
    ExitApp
Return





