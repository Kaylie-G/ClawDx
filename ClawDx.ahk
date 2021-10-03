#NoEnv
#KeyHistory, 0
#SingleInstance Off
SetBatchLines, -1
SetWinDelay, -1
SetKeyDelay, -1
SetWorkingDir, % (i:=A_ScriptDir)
FileEncoding

x( !FileExist("D3DWindower.exe") , """D3DWindower.exe"" not found!" )
x( !FileExist("CLAW.EXE") , """CLAW.EXE"" not found!" )
IniRead, i, hook.ini, KnownProgram, % i "\CLAW.EXE"
If  ( i="ERROR" )
GoSub, H
GoSub, A

DetectHiddenWindows, On
If  ( !M && WinExist("ahk_exe CLAW.exe") )  {
	WinShow
	WinActivate
	Exitapp
}  DetectHiddenWindows, Off

;;  ··································································································
If  ( WinExist("ahk_exe D3DWindower.exe") )
Sleep, 250
Run, "D3DWindower.exe",,, j
WinWait, % (i:="DirectX Windower v1.88 ahk_pid " j),, 20
x( ErrorLevel , """D3DWindower.exe"" not load!" )
Loop, % ( 15 , (a:=A_ScreenWidth) , b:=A_ScreenHeight ) {
	DllCall("SetWindowPos", "UInt", WinExist(""), "UInt", 0
		, "Int" , a, "Int" , b, "Int"
		, 358, "Int" , 227, "UInt", 0x0400)
	WinGetPos, M
	If  (M=a)
	Break
	Sleep, 10
}

SetTitleMatchMode, 3
	j:="ahk_class #32768 ahk_exe D3DWindower.exe ahk_pid " j
	Loop 10 {
		If  ( !WinExist(j) )  {
			GoSub, R
		}  Sleep, 50
		ControlSend,, {r Down}
		Sleep, 50
		ControlSend,, {r Up}
		Random, M, 1, 5
		Sleep, % M*75
		Loop, 60 {
			Sleep, 50
			If  (  WinExist("Claw ahk_exe CLAW.EXE")  ) {
				WinSetTitle, % (  "Claw ",M:=-1  )
				WinClose, % i
				Break, 2
			}
		}  If  (  WinExist("Windows Features ahk_exe Fondue.exe")  )  {
			WinClose, % i
			xx()   ,   x( 1 , """DirectPlay"" not activate!" )
			}
	}  If  (M<>-1)  {
		WinWait, % "Claw ahk_exe CLAW.EXE",, 10
		WinClose, % i
		x( ErrorLevel , """CLAW.EXE"" not load!" )
		WinSetTitle, % "Claw "
	}
GoSub, S



For R,R in % ( R,rr:=A_ScriptDir )
{
try Run, % """"  (instr(R,":")?"":rr "\") trim(R,""" ")  """"
Sleep, 50
} WinActivate
Exitapp


;;  ··································································································

x(a,b) {
	If  ( a )  {
	MsgBox, 64, Error, % b "`n  \> closing ClawDx..."
	Exitapp
}} xx() {
	q:="Select * from Win32_Process  where Name = 'CLAW.exe'"
	FOR p IN ComObjGet("winmgmts:").ExecQuery(q)  {
	Process, Close, % p.ProcessId
	Sleep, 50
}} S:
	(   W&&!H   ?   H:=round(W*0.79,0)   :   H&&!W   ?   W:=round(H*1.27,0)   :   ""    )
	If  ( !F )  {
		F:=A_ScreenWidth   ,   i:=A_ScreenHeight
		If  ( W>0 && H>0 )  {
			If  !( X>=0 && Y>=0 )
			X:=round((F-W)/2,0)  , Y:=round((i-H)/2,0)
			X:=(X+W>F?F-W:X)  ,  Y:=(Y+H>i?i-H:Y)
			WinMove,,, % (X<0?0:X), % (Y<0?0:Y), % (W>F?F:W), % (H>i?i:H)
		}  Else If  ( X>=0 && Y>=0 )
			WinMove,,, % (X+646>F?F-646:X), % (Y+509>i?i-509:Y), 646,509
	}  Else  {
		X:=Y:=0 , W:=A_ScreenWidth,H:=A_ScreenHeight
		WinSet, Style, -0xC40000
		try  DllCall("SetWindowPos", "UInt", WinExist(""), "UInt"
		, 0, "Int" , 0, "Int" , 0, "Int", W, "Int" , H, "UInt", 0x0400)
	} Return

A:
	If  (   !FileExist("ClawDx-Settings.ini")   )  {
		FileAppend,, % A_ScriptDir "\ClawDx-Settings.ini"
		IniWrite, 1, ClawDx-Settings.ini, Claw, FullScreen
		IniWrite, % "", ClawDx-Settings.ini, Claw, X
		IniWrite, % "", ClawDx-Settings.ini, Claw, Y
		IniWrite, % "", ClawDx-Settings.ini, Claw, W
		IniWrite, % "", ClawDx-Settings.ini, Claw, H
		IniWrite, % "", ClawDx-Settings.ini, Claw, MultiWin
		IniWrite, % "", ClawDx-Settings.ini, Claw, Run
	}  For i,i in ( A_Args   ,   X:=Y:=W:=H:=""   ,   R:=[],rr:=xy:=0   )
	(    i="xy"   ?   xy:=1   :    (j:=substr(i,1,1))="x"   ?   X:=substr(i,2)
	:   j="y"   ?   Y:=substr(i,2)   :   j="w"   ?   W:=substr(i,2)
	:   j="h"   ?   H:=substr(i,2)  :   j="f"   ?   F:=substr(i,2)   :   j="m"  ?   M:=substr(i,2)
	:   i="r-"  ?   rr:=1   :     j="r"   ?   R.push(substr(i,2))   :   "")
	If  !(  F  ||  X  ||  Y  ||  W  ||  H  )
		IniRead, F, ClawDx-Settings.ini, Claw, FullScreen
	If  ( !xy )  {
	If  !(  X+1>0  )
		IniRead, X, ClawDx-Settings.ini, Claw, X
	If  !(  Y+1>0  )
		IniRead, Y, ClawDx-Settings.ini, Claw, Y
	}  Else  X:=Y:=""
	If  !(  W*1>0  )
		IniRead, W, ClawDx-Settings.ini, Claw, W
	If  !(  H*1>0  )
		IniRead, H, ClawDx-Settings.ini, Claw, H 
	If  !(  M+1  )
		IniRead, M, ClawDx-Settings.ini, Claw, MultiWin
	If  !(  rr  )  {
		IniRead, rr, ClawDx-Settings.ini, Claw, Run
		R.push(  StrSplit(rr,"|")*  )
	}  Return
R:
	Loop, 10 {
		ControlFocus, TListView1, % i
		ControlClick, x32 y65, % i,, RIGHT
		WinWait, % j,, 1
	}  Until  ( WinExist(j) )
	If  (  !WinExist(j)  )  {
		WinClose, % i
		x( 1,"Error in Macro for [ Right Click ]" )
	}  Return
H:
	FileDelete, % (i:=A_ScriptDir) "\hook.ini"
	FileAppend,, % i "\hook.ini"
	IniWrite, Claw, hook.ini, KnownProgram, % i "\CLAW.EXE"
	IniWrite, 0, hook.ini, Prog.Claw, UseWindowMode
	IniWrite, 0, hook.ini, Prog.Claw, UseGDI
	IniWrite, 0, hook.ini, Prog.Claw, UseDirect3D
	IniWrite, 0, hook.ini, Prog.Claw, UseDirectInput
	IniWrite, 1, hook.ini, Prog.Claw, UseDirectDraw
	IniWrite, % "", hook.ini, Prog.Claw, CommandLine
	IniWrite, 0, hook.ini, Prog.Claw, Width
	IniWrite, 0, hook.ini, Prog.Claw, Height
	IniWrite, % "", hook.ini, Prog.Claw, MenuId
	IniWrite, 0, hook.ini, Prog.Claw, ShowFps
	IniWrite, 0, hook.ini, Prog.Claw, UseForegroundControl
	IniWrite, 1, hook.ini, Prog.Claw, UseDDrawColorEmulate
	IniWrite, 0, hook.ini, Prog.Claw, UseDDrawFlipBlt
	IniWrite, 1, hook.ini, Prog.Claw, UseDDrawColorConvert
	IniWrite, 0, hook.ini, Prog.Claw, UseDDrawPrimaryBlt
	IniWrite, 0, hook.ini, Prog.Claw, UseDDrawAutoBlt
	IniWrite, 0, hook.ini, Prog.Claw, UseDDrawEmulate
	IniWrite, 0, hook.ini, Prog.Claw, UseDDrawPrimaryLost
	IniWrite, % "", hook.ini, Prog.Claw, SubModule0
	IniWrite, 0, hook.ini, Prog.Claw, UseCursorMsg
	IniWrite, 0, hook.ini, Prog.Claw, UseCursorSet
	IniWrite, 0, hook.ini, Prog.Claw, UseCursorGet
	IniWrite, 0, hook.ini, Prog.Claw, UseCursorClip
	IniWrite, 0, hook.ini, Prog.Claw, UseSpeedHack
	IniWrite, 10, hook.ini, Prog.Claw, SpeedHackMultiple
	IniWrite, 0, hook.ini, Prog.Claw, UseBackgroundResize
	IniWrite, 1, hook.ini, Prog.Claw, UseBackgroundPriority
	IniWrite, 0, hook.ini, Prog.Claw, DDrawBltWait
	IniWrite, 0, hook.ini, Prog.Claw, UseFGCGetActiveWindow
	IniWrite, 0, hook.ini, Prog.Claw, UseFGCGetForegroundWindow
	IniWrite, 0, hook.ini, Prog.Claw, UseFGCFixedWindowPosition
	IniWrite, 0, hook.ini, Prog.Claw, EnableExtraKey
	Sleep, 350
	Return