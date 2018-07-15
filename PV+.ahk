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

GroupAdd, TextBox, Text Properties
GroupAdd, TextBox, Goto Display Button Properties
GroupAdd, TextBox, Return to Display Button Properties
GroupAdd, TextBox, Numeric Input Enable Properties
GroupAdd, TextBox, Goto Configure Mode Button Properties
GroupAdd, TextBox, Move Up Button Properties
GroupAdd, TextBox, Move Down Button Properties
GroupAdd, TextBox, Move Left Button Properties
GroupAdd, TextBox, Move Right Button Properties
GroupAdd, TextBox, Page Up Button Properties
GroupAdd, TextBox, Page Down Button Properties
GroupAdd, TextBox, Enter Button Properties
GroupAdd, Multistate, Multistate Indicator Properties
GroupAdd, Multistate, Multistate Push Button Properties
GroupAdd, Multistate, Momentary Push Button Properties
GroupAdd, Multistate, Maintained Push Button Properties


;MButton & 5::Function1()
;MButton & 6::Function2()

;arial (goto), tomaha, ocr a, courier, calabri,
global mFontName:=["arial", "calabri", "courier", "ocr a", "tomaha"]
global fontSize = 12
global fontSizeText
global fontName:=mFontName[fontNameIndex]
global height
global heightText
global width
global widthText 
global top
global topText
global left
global leftText
global fontNameIndex = 1
global editBox
global xPos
global yPos
global firstRun=0
global fontNameText
global isBold=0
global whichTab = 2
global whichTabText
global numberOfStates = 2
x:=DisplayGui()
Gosub, OnRadioChange

;IfWinActive, Text Properties 

;`::Reload
;#IfWinActive, ahk_group Multistate 
MButton & e::
	IfWinNotActive, Text Properties
	{
	SendMessage, 0x1330, %whichTab%, , SysTabControl321, ahk_class #32770
	}
	IfWinActive, Text Properties
	{
	SendMessage, 0x1330, 1, , SysTabControl321, ahk_class #32770
	}
	If (height != "") Then{
	ControlFocus, Edit2, ahk_class #32770
	Send {DEL 4}
	Send {BACKSPACE 4}
	send, %height%
	sleep 100
	}

	If (width != "") Then{
	ControlFocus, Edit3, ahk_class #32770
	Send {DEL 4}
	Send {BACKSPACE 4}
	send, %width%
	sleep 100
	}

	If (top != "") Then{
	ControlFocus, Edit4, ahk_class #32770
	Send {DEL 4}
	Send {BACKSPACE 4}
	send, %top%
	sleep 100
	}

	If (left != "") Then{
	ControlFocus, Edit5, ahk_class #32770
	Send {DEL 4}
	Send {BACKSPACE 4}
	send, %left%
	sleep 100
	}

Return



#IfWinActive, ahk_group Multistate 
MButton & f::
	SendMessage, 0x1330, 1, , SysTabControl321, ahk_class #32770 ;does not check *whichTab
	;Control, ShowDropDown, , ComboBox2, ahk_class #32770

	Loop % numberOfStates
	{
		ControlFocus, ListBox1, ahk_class #32770
		if (A_Index == 1) {
			sendInput, {up}{up} ;ListBox1
			SetKeyDelay, 1, 5
		}Else{
			send, {down} ;ListBox1
			Control, ShowDropDown, , ComboBox2, ahk_class #32770
			SetKeyDelay, 1, 50
		}
	

		ControlSend, ComboBox2, %fontName%, ahk_class #32770
		ControlSend, ComboBox4, transparent, ahk_class #32770
		ControlFocus, Edit3, ahk_class #32770
		Send, %fontSize%
		if (isBold == 1) {
			sleep 100
			ControlClick, Button12, ahk_class #32770, , , 1, NA
		}
		sleep 100
		IfWinNotActive, Multistate 
		{
			ControlClick, Button21, ahk_class #32770, , , 1, NA ;center justification
		}
		
		IfWinActive, Multistate	
		{
			ControlClick, Button23, ahk_class #32770, , , 1, NA ;center justification
		}
		
		sleep 100
		;justification most multistate - not Multistate is -2
		;19 20 21
		;22 23 24
		;25 26 27
	}

	sleep 100
	ControlClick, Button45, ahk_class #32770, , , 1, NA
	sleep 100
	ControlClick, Button45, ahk_class #32770, , , 1, NA
Return



#IfWinActive, ahk_group TextBox
MButton & f::
	IfWinNotActive, Text Properties
	{
	;if (whichTab == 2) {
		SendMessage, 0x1330, 1, , SysTabControl321, ahk_class #32770
	}
	IfWinActive, Text Properties
	{
		SendMessage, 0x1330, 0, , SysTabControl321, ahk_class #32770
	}
	SetKeyDelay, 1, 10
	ControlSend, ComboBox1, %fontName%, ahk_class #32770
	sleep 500
	ControlFocus, ComboBox2, ahk_class #32770
	send, %fontSize%
	
	sleep 200
	IfWinNotActive, Text Properties
	{
		ControlClick, Button14, ahk_class #32770, , , 1, NA ;center justification - 14
		sleep 100
		ControlSend, ComboBox4, transparent, ahk_class #32770
		sleep 100
		ControlClick, Button36, ahk_class #32770, , , 1, NA ;apply
	}
	IfWinActive, Text Properties
	{
		ControlClick, Button15, ahk_class #32770, , , 1, NA ;center justification button 15
		sleep 100
		ControlSend, ComboBox3, transparent, ahk_class #32770
		sleep 100
		ControlClick, Button22, ahk_class #32770, , , 1, NA ;apply
	}
	sleep 100
	
	if (isBold == 1) {
		sleep 100
		ControlClick, Button3, ahk_class #32770, , , 1, NA
	}



Return












;============================================================================================================================================================================
Function1(){
	Run, Edit %A_ScriptName%
	WinMenuSelectItem, ahk_class Notepad++, , File, Save
return
}
Function2(){
	Run, open %A_ScriptName%
	return
}	
;============================================================================================================================================================================
DisplayGui(){
Gui, Name: New, +HwndhMyPVGuiHwnd, PV
Gui PV: Add, Text, , Font Size:
Gui PV: Add, Edit, R1 vfontSize x60 y5 w25 Limit3 hwndhEdit21 gOnChangeMyText1, %fontSize%
Gui PV: Add, Text,x90 y6 w20 vfontSizeText, %fontSize%

Gui PV: Add, Radio, Group vfontNameIndex x10 gOnRadioChange, Arial
Gui PV: Add, Radio, xp+60 yp -wrap gOnRadioChange, Calabri
Gui PV: Add, Radio, xp+60 yp -wrap gOnRadioChange, Courier
Gui PV: Add, Radio, xp-120 yp+20 -wrap gOnRadioChange, OCR A
Gui PV: Add, Radio, xp+60 yp -wrap gOnRadioChange, Tomaha
 
Gui PV: Add, Text, xp-60 yp+20, Height:
Gui PV: Add, Edit, R1 vheight xp+35 yp-3 w25 Limit3  hwndhEdit2 gOnChangeMyText2, %height% 
Gui PV: Add, Text,xp+27 yp+3 w20 vheightText, %height%

Gui PV: Add, Text, xp+40 yp , Width:
Gui PV: Add, Edit, R1 vwidth xp+35 yp-3 w25 Limit3  hwndhEdit3 gOnChangeMyText3, %width%
Gui PV: Add, Text,xp+27 yp+3 w20 vwidthText, %width%

Gui PV: Add, Text, xp-155 yp+20, Top:
Gui PV: Add, Edit, R1 vtop xp+25 yp-3 w25 Limit3  hwndhEdit4 gOnChangeMyText4, %top% 
Gui PV: Add, Text,xp+27 yp+3 w20 vtopText, %top%

Gui PV: Add, Text, xp+50 yp, Left:
Gui PV: Add, Edit, R1 vleft xp+25 yp-3 w25 Limit3  hwndhEdit5 gOnChangeMyText5, %left% 
Gui PV: Add, Text, xp+27 yp+3 w20 vleftText, %left%

Gui PV: Add, Checkbox, xp-155 yp+20 visBold hwndhCheckBox1 gOnBoldChange Checked%isBold%, Bold?

Gui PV: Add, Text, xp yp+20, Tabs:
Gui PV: Add, Edit, R1 vwhichTab xp+25 yp-3 w20 Limit2  hwndhEdit6 gOnChangeMyText6, %whichTab% 
Gui PV: Add, Text, xp+27 yp+3 w20 vwhichTabText, %whichTab%

GuiControl, , Button%fontNameIndex%, 1
fontName:=mFontName[fontNameIndex]
Gui PV: Add, Text, x10 y150 w50 vfontNameText, %fontName%
Gui PV: Add,Button,Default gGuiSubmit,Enter

if (firstRun = 0){
	Gui PV: Show, AutoSize ; x%xPos% y%yPos% w200 h200
	firstRun:=1
}Else{
	Gui PV: Show, x%xPos% y%yPos% ;w200 h200
}
Gui PV: +AlwaysOnTop +Owner
}

;============================================================================================================================================================================
GuiSubmit:
loop % 6 {
	GuiControlGet, editBox, , Edit%A_Index%
	if !(editBox > 0){
	GuiControl, ,Edit%A_Index%,""
	}
	NewText := RegExReplace(editBox, "[^0-9]", "") ;Allow digits letters underscore_ apostrophe' space dash-
	;MsgBox, editBox: %editBox% `nNewText: %NewText%
	If (NewText != editBox) ; Check if any invalid characters were removed
	{
		Edit_GetSel(hButton%A_Index%,StartSelPos,EndSelPos)    ;-- Get caret position
		GuiControl, ,Edit%A_Index%,%NewText%              ;-- Replace text
		NewSelPos:=EndSelPos-(StrLen(MyText)-StrLen(NewText))
		Edit_SetSel(hButton%A_Index%,NewSelPos,NewSelPos)      ;-- Reposition caret
	}
}
Gui, Submit, NoHide
WinGetPos, xPos, yPos
Gui, Destroy
x:=DisplayGui()
Return
;============================================================================================================================================================================
OnBoldChange:
Return
;============================================================================================================================================================================
OnRadioChange:
	Gui, Submit, NoHide
	fontName:=mFontName[fontNameIndex]
	GuiControl, , fontNameText, %fontName%
	If (fontName =="ocr a") Then{
		isBold = 1
	}
	
Return
;============================================================================================================================================================================
OnChangeMyText1:
	GuiControlGet, editBox, , Edit1
	NewText := RegExReplace(editBox, "[^0-9]", "") ;Allow digits letters underscore_ apostrophe' space dash-
	;MsgBox, editBox: %editBox% `nNewText: %NewText%
	If (NewText != editBox) ; Check if any invalid characters were removed
	{
		Edit_GetSel(hEdit1,StartSelPos,EndSelPos)    ;-- Get caret position
		GuiControl, ,Edit1,%NewText%              ;-- Replace text
		NewSelPos:=EndSelPos-(StrLen(MyText)-StrLen(NewText))
		Edit_SetSel(hEdit1,NewSelPos,NewSelPos)      ;-- Reposition caret
	}
Gui, Submit, NoHide
GuiControl, ,fontSizeText,%fontSize%
Return
;============================================================================================================================================================================
OnChangeMyText2:
	GuiControlGet, editBox, , Edit2
	NewText := RegExReplace(editBox, "[^0-9]", "") ;Allow digits letters underscore_ apostrophe' space dash-
	;MsgBox, editBox: %editBox% `nNewText: %NewText%
	If (NewText != editBox) ; Check if any invalid characters were removed
	{
		Edit_GetSel(hEdit2,StartSelPos,EndSelPos)    ;-- Get caret position
		GuiControl, ,Edit2,%NewText%              ;-- Replace text
		NewSelPos:=EndSelPos-(StrLen(MyText)-StrLen(NewText))
		Edit_SetSel(hEdit2,NewSelPos,NewSelPos)      ;-- Reposition caret
	}
Gui, Submit, NoHide
GuiControl, ,heightText,%height%
Return
;============================================================================================================================================================================
OnChangeMyText3:
	GuiControlGet, editBox, , Edit3
	NewText := RegExReplace(editBox, "[^0-9]", "") ;Allow digits letters underscore_ apostrophe' space dash-
	;MsgBox, editBox: %editBox% `nNewText: %NewText%
	If (NewText != editBox) ; Check if any invalid characters were removed
	{
		Edit_GetSel(hEdit3,StartSelPos,EndSelPos)    ;-- Get caret position
		GuiControl, ,Edit3,%NewText%              ;-- Replace text
		NewSelPos:=EndSelPos-(StrLen(MyText)-StrLen(NewText))
		Edit_SetSel(hEdit3,NewSelPos,NewSelPos)      ;-- Reposition caret
	}
Gui, Submit, NoHide
GuiControl, ,widthText,%width%
Return
;============================================================================================================================================================================
OnChangeMyText4:
	GuiControlGet, editBox, , Edit4
	NewText := RegExReplace(editBox, "[^0-9]", "") ;Allow digits letters underscore_ apostrophe' space dash-
	;MsgBox, editBox: %editBox% `nNewText: %NewText%
	If (NewText != editBox) ; Check if any invalid characters were removed
	{
		Edit_GetSel(hEdit4,StartSelPos,EndSelPos)    ;-- Get caret position
		GuiControl, ,Edit4,%NewText%              ;-- Replace text
		NewSelPos:=EndSelPos-(StrLen(MyText)-StrLen(NewText))
		Edit_SetSel(hEdit4,NewSelPos,NewSelPos)      ;-- Reposition caret
	}
Gui, Submit, NoHide
GuiControl, ,topText,%top%
Return
;============================================================================================================================================================================
OnChangeMyText5:
	GuiControlGet, editBox, , Edit5
	NewText := RegExReplace(editBox, "[^0-9]", "") ;Allow digits letters underscore_ apostrophe' space dash-
	;MsgBox, editBox: %editBox% `nNewText: %NewText%
	If (NewText != editBox) ; Check if any invalid characters were removed
	{
		Edit_GetSel(hEdit5,StartSelPos,EndSelPos)    ;-- Get caret position
		GuiControl, ,Edit5,%NewText%              ;-- Replace text
		NewSelPos:=EndSelPos-(StrLen(MyText)-StrLen(NewText))
		Edit_SetSel(hEdit5,NewSelPos,NewSelPos)      ;-- Reposition caret
	}
Gui, Submit, NoHide
GuiControl, ,leftText,%left%
Return
;============================================================================================================================================================================
OnChangeMyText6:
	GuiControlGet, editBox, , Edit6
	NewText := RegExReplace(editBox, "[^0-9]", "") ;Allow digits letters underscore_ apostrophe' space dash-
	;MsgBox, editBox: %editBox% `nNewText: %NewText%
	If (NewText != editBox) ; Check if any invalid characters were removed
	{
		Edit_GetSel(hEdit6,StartSelPos,EndSelPos)    ;-- Get caret position
		GuiControl, ,Edit6,%NewText%              ;-- Replace text
		NewSelPos:=EndSelPos-(StrLen(MyText)-StrLen(NewText))
		Edit_SetSel(hEdit5,NewSelPos,NewSelPos)      ;-- Reposition caret
	}
Gui, Submit, NoHide
GuiControl, ,whichTabText,%whichTab%

;whichTab:=whichTab-1
Return