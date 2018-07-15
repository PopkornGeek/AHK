#NoEnv  													; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  													; Enable warnings to assist with detecting common errors.
#SingleInstance force
;SendMode Input  											; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%	

LAC1Enabled:=1
LAC2Enabled:=0
wifiEnabled:=0
LAC1DHCP:=1
LAC2DHCP:=0
wifiDHCP:=0
ipAddress:=192.168.1.250
subnetMask:=255.255.0.0
defaultGateway:=192.168.1.1
preferredDNSServer:=192.168.1.1

global LAC1Name:="Local Area Connection"
global LAC2Name:="Local Area Connection 2"
global WifiName:="Wireless Network Connection"


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
Sleep 500



;============================================================================================================================================================================
OnLAC1EnabledChange:
SendInput, L
If (LAC1Enabled == 1){
	SendInput, !f
	SendInput, a
	;WinMenuSelectItem, ahk_class CabinetWClass, , File, Enable
}
Else {
	SendInput, !f
	SendInput, b
	;WinMenuSelectItem, ahk_class CabinetWClass, , File, Disable
}
Return
;============================================================================================================================================================================
OnLAC2EnabledChange:
SendInput, L
SendInput, L
If (LAC2Enabled == 1){
	SendInput, !f
	SendInput, a
	;WinMenuSelectItem, ahk_class CabinetWClass, , File, Enable
}
Else {
	SendInput, !f
	SendInput, b
	;WinMenuSelectItem, ahk_class CabinetWClass, , File, Disable
}
Return
;============================================================================================================================================================================
OnWifiEnabledChange:
If (wifiEnabled == 1){
	SendInput, !f
	SendInput, a
	;WinMenuSelectItem, ahk_class CabinetWClass, , File, Enable
}
Else {
	SendInput, !f
	SendInput, b
	;WinMenuSelectItem, ahk_class CabinetWClass, , File, Disable
}
Return
;============================================================================================================================================================================
OnLAC1IpChange:
SendInput, %LAC1Name%								;selects connection
SendInput, !f										;file menu


SendInput, r										;properties
WinWait, %LAC1Name% Properties, , 5					;wait for properties to load
;WinActivate, Local Area Connection Properties
Send, {Down 5}										;selects IPv4
SendInput, !r										;properties
If (LAC1DHCP == 1){
	SendInput, !o									;obtain IP automatically
	SendInput, !b									;obtain DNS server automatically
}
Else{
	SendInput, !s									;use following IP
	Send, {Tab}										
	Send, %ipAddress%								
	Send, {Tab}										
	Send, %subnetMask%								
	Send, {Tab}
	Send, %defaultGateway%
	SendInput, !e									;use following DNS server
	Send, {Tab}
	Send, %preferredDNSServer%
}
ControlClick, Button9, Internet Protocol Version 4 (TCP/IPv4) Properties, , , , NA
WinWait, %LAC1Name% Properties, , 5
ControlClick, Button6, %LAC1Name% Properties, , , , NA

Return
;============================================================================================================================================================================
OnLAC2IpChange:
SendInput, l										;selects connection
SendInput, !f										;file menu
SendInput, r										;properties
WinWait, %LAC2Name% Properties, , 5	;wait for properties to load
;WinActivate, Local Area Connection Properties
Send, {Down 5}										;selects IPv4
SendInput, !r										;properties
If (LAC2DHCP == 1){
	SendInput, !o									;obtain IP automatically
	SendInput, !b									;obtain DNS server automatically
}
Else{
	SendInput, !s									;use following IP
	Send, {Tab}										
	Send, %ipAddress%								
	Send, {Tab}										
	Send, %subnetMask%								
	Send, {Tab}
	Send, %defaultGateway%
	SendInput, !e									;use following DNS server
	Send, {Tab}
	Send, %preferredDNSServer%
}
ControlClick, Button9, Internet Protocol Version 4 (TCP/IPv4) Properties, , , , NA
WinWait, %LAC2Name% Properties, , 5
ControlClick, Button6, %LAC2Name% Properties, , , , NA

Return
;============================================================================================================================================================================
OnWifiIpChange:
SendInput, l										;selects connection
SendInput, !f										;file menu
SendInput, r										;properties
WinWait, %WifiName% Properties, , 5	;wait for properties to load
;WinActivate, Local Area Connection Properties
Send, {Down 5}										;selects IPv4
SendInput, !r										;properties
If (wifiDHCP == 1){
	SendInput, !o									;obtain IP automatically
	SendInput, !b									;obtain DNS server automatically
}
Else{
	SendInput, !s									;use following IP
	Send, {Tab}										
	Send, %ipAddress%								
	Send, {Tab}										
	Send, %subnetMask%								
	Send, {Tab}
	Send, %defaultGateway%
	SendInput, !e									;use following DNS server
	Send, {Tab}
	Send, %preferredDNSServer%
}
ControlClick, Button9, Internet Protocol Version 4 (TCP/IPv4) Properties, , , , NA
WinWait, %WifiName% Properties, , 5
ControlClick, Button6, %WifiName% Properties, , , , NA

Return


