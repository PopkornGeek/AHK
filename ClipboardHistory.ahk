#NoTrayIcon
SendMode Input  ; Forces Send and SendRaw to use SendInput buffering for speed.
#SingleInstance force


^+v::
;Flush the old menu
Menu, ClipboardHistory, Add
Menu, ClipboardHistory, DeleteAll
;Create the menu items
Loop 10 {
	;Translate this loop iteration into a bucket number based upon decrementing circular bucket from CurBucket
	ThisIndexBucketNum := CurBucket - A_Index + 1
	If (ThisIndexBucketNum < 1)
		ThisIndexBucketNum := ThisIndexBucketNum + 10
	; Make 10 Display as 0 for correct keyboard shortcut
	ThisMenuItemNumber := A_Index
	If (ThisMenuItemNumber = 10)
		ThisMenuItemNumber := 0
	;Create Short Display of this Item
	StringReplace, ThisItemShortDisplay, ClipBucket%ThisIndexBucketNum%, `n, |, All ;show | for newline in menu preview
	ThisItemShortDisplay := RegExReplace(ThisItemShortDisplay, "[[:blank:]]+", " ") ;remove double spaces
	StringLeft, ThisItemShortDisplay, ThisItemShortDisplay, 64
	;Add into the menu
	Menu, ClipboardHistory, Add, % "&" . ThisMenuItemNumber . " " . ThisItemShortDisplay, PasteClipFromMenu
}
MenuShowPosY := A_CaretY + 16
Menu, ClipboardHistory, Show, %A_CaretX%, %MenuShowPosY%
Return

PasteClipFromMenu:
ThisSelectionBucketNum := CurBucket - A_ThisMenuItemPos + 1
If (ThisSelectionBucketNum < 1)
	ThisSelectionBucketNum := ThisSelectionBucketNum + 10
SendRaw % ClipBucket%ThisSelectionBucketNum%
Return

OnClipboardChange:
If (A_EventInfo = 1) {
	CurBucket++	; on first copy this will become 1
	If (CurBucket > 10)
		CurBucket := 1
	StringReplace, ClipBucket%CurBucket%, Clipboard, `r`n, `n, All ;Fix for SendInput sending Windows linebreaks 
}
Return
