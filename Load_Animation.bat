@echo off
rem multithread dispatcher
If not "%~1" == "" Goto:%~1

REM define Virtual terminal escape character
For /f "delims=" %%E in ('echo prompt $E^|%comspec%') Do set \E=%%E

rem open/close.LoadScreen rely on a temporary file as IPC signal.
Set open.LoadScreen=(Call:WaitFor)^&^&Start /b "" "%~f0" LoadScreen 61 20
Set close.LoadScreen=break ^>"%~dp0stop%~n0.cmd"

%open.LoadScreen% Demo title

rem simulate some work.
Echo(%\E%[H%\E%7
For /l %%i in (1 1 10) Do (
  Echo(%\E%8 .%\E%[1D%\E%7
  > nul timeout /t 1 /NoBreak
)

%close.LoadScreen%

<nul Set /p "=%\E%[H%\E%[J%\E%[?25h"
Pause
cls
Endlocal & Goto:Eof


:WaitFor
If exist "%~dp0stop%~n0.cmd" Del "%~dp0stop%~n0.cmd" > nul 2> nul || goto:WaitFor
Exit /b 0

:LoadScreen

For /f "tokens=1,2,3,* Delims= " %%G in ("%*") Do if not "%%~J" == "" (
  (title %%~J)
) else (title Loading)

Setlocal EnableDelayedExpansion

2> nul set /a wid=%~2,hei=%~3 || set /a wid=51,hei=25

rem recommended = y6 x10
Set /a _1yDim=6,_1xDim=10
Set /a _1.x1=1,_1.y1=0,_1.i1=_1xDim
Set /a _1.x2=0,_1.y2=1,_1.i2=_1yDim
Set /a _1.x3=-1,_1.y3=0,_1.i3=_1xDim
Set /a _1.x4=0,_1.y4=-1,_1.i4=_1yDim
Set /a _1.x5=-1,_1.y5=0,_1.i5=_1xDim
Set /a _1.x6=0,_1.y6=1,_1.i6=_1yDim
Set /a _1.x7=1,_1.y7=0,_1.i7=_1xDim
Set /a _1.x8=0,_1.y8=-1,_1.i8=_1yDim

Set /a _1.pl=8,_1.y=(((hei-_1yDim)/2))+(1-(_1yDim %% 2)),_1.x=(wid/2)+(_1xDim-10)+(wid %%2),_1.pn=1,_1.pc=_1.i1,cShift.1=8

rem recommended = 5
Set /a _2Dim=5
Set /a _2.x1=1,_2.y1=-1,_2.i1=_2Dim
Set /a _2.x2=1,_2.y2=1,_2.i2=_2Dim
Set /a _2.x3=-1,_2.y3=1,_2.i3=_2Dim
Set /a _2.x4=-1,_2.y4=-1,_2.i4=_2Dim
Set /a _2.x5=-1,_2.y5=-1,_2.i5=_2Dim
Set /a _2.x6=-1,_2.y6=1,_2.i6=_2Dim
Set /a _2.x7=1,_2.y7=1,_2.i7=_2Dim
Set /a _2.x8=1,_2.y8=-1,_2.i8=_2Dim

Set /a _2.pl=8,_2.y=(hei/2)+1-(_2Dim-5),_2.x=(wid/2)+(_2Dim-5)+(wid %%2),_2.pn=1,_2.pc=_2.i1,cShift.2=12

rem IF single line program, index _ID.i# is previous value as delayed expansion value is parsed prior line evaluation
Set "partA=_%%i.pd=-1*((_%%i.pc-=-1*~((_%%i.pc)>>31))>>31),_%%i.pn+=_%%i.pd,_%%i.pn+=(_%%i.pl)*((_%%i.pl - _%%i.pn)>>31)"
Set "partB=_%%i.pc+=(_%%i.i^!_%%i.pn^!)*_%%i.pd,_%%i.x+=_%%i.x^!_%%i.pn^!,_%%i.y+=_%%i.y^!_%%i.pn^!"

if not defined \E For /f "delims=" %%E in ('echo prompt $E^|%comspec%') Do set \E=%%E
mode %wid%,%hei%
cls
<nul set /p "=%\E%[?25l"

For /l %%n in () Do (
  If exist "%~dp0stop%~n0.cmd" (
    (Title )
    <nul set /p "=%\E%[?25h"
    EXIT
  )
  For /l %%i in (1 1 2) do (
    Set /a "C%%i=C%%i %% (255-cShift.%%i) + cShift.%%i"
    Set /a "%partA%"
    Set /a "%partB%"
  )
  Echo(%\E%[38;2;!C2!;12;12m%\E%[!_2.y!;!_2.x!H#%\E%[38;2;12;!C3!;12m%\E%[!_3.y!;!_3.x!H#%\E%[38;2;12;12;!C1!m%\E%[!_1.y!;!_1.x!H#%\E%[0m
  For /l %%z in (1 1 500) do rem delay
)
EXIT

rem programmed entity movement where:
rem _#.x  = current x position
rem _#.y  = current y position
rem _#.xN = x sign          ;      set when pn = N and pd == 1
rem _#.yN = y sign          ;      set when pn = N and pd == 1
rem _#.iN = index number    ; selected when pn = N and pd == 1
rem _#.pc = program counter ; accessed from _#.in via _#.pn when _#.pd == 1
rem _#.pd = program do      ; flags current action finished ; if pd == 1 set new .pc and .pn
rem _#.pn = program next    ; used to index program parameters for current step _#i!_#.pn!
rem _#.pl = program length  ; used to reset pn to 1 when program complete

REM partA
_%%i.pd=-1*((_%%i.pc-=-1*~((_%%i.pc)>>31))>>31) ; decrease program counter 'pc' if pc GTR -1 ; invert sign [ -1 == 1 ]
_%%i.pn+=_%%i.pd                                ; increase program next by program do 'pd' value [ 1 or 0 ]
_%%i.pn+=(_%%i.pl)*((_%%i.pl - _%%i.pn)>>31)    ; decrease by program length 'pl' if _#.pn exceeds _#.pl [ _#.pl * (0 or -1) ]

REM part B
_%%i.pc+=(_%%i.i^!_%%i.pn^!)*_%%i.pd            ; increase program counter by _#.i!_#.pn! if _#.pd == 1
_%%i.x+=_%%i.x^!_%%i.pn^!                       ; modify .x by sign of _#.x!_#.pn!
_%%i.y+=_%%i.y^!_%%i.pn^!                       ; modify .y by sign of _#.y!_#.pn!


