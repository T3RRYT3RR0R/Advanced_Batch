@echo off 

rem randomWalker by T3RRY
CLS
Setlocal EnableDelayedExpansion

(
  For /f "tokens=1 Delims==" %%G in ('Set ""') Do Set "%%G="
  Set "comspec=%comspec%"
  Set "path=%path%"
  Set "systemroot=%systemroot%"
)

For /f %%E in ('echo prompt $E^|%comspec%') do set \E=%%E

For /f "delims=1234 " %%V in ('echo %*') do goto:skip
if not %errorlevel% == 0 goto:skip

Set "argV= 4432"
For /l %%i in (1 1 4) Do (
  Call set "arg%%~i=%%%%~i"
  If defined arg%%i (
    if !arg%%i! GTR !argV:~%%i^,1! Set "arg%%i=!argV:~%%i,1!"
    Set "arg%%i=Echo !arg%%i!^^|"
) )
:skip
cls
if not defined arg1 (
  Echo( dimensions?
  echo 1 : 12x36
  echo 2 : 16x48
  echo 3 : 20x60
  echo 4 : 24x72
)
For /f "Delims=" %%K in ('%arg1%choice /n /c:1234 2^> nul') Do (
  Set /a "hei=(((%%K + 3) * 4)-4)","wid=hei*3","shei=hei+1"
)

if not defined arg2 (
  Echo(
  Echo how many 'walkers?
  Echo 1 : 12
  Echo 2 : 18
  Echo 3 : 24
  Echo 4 : 30
)
For /f "Delims=" %%K in ('%arg2%choice /n /c:1234 2^> nul') Do (
  Set /a "#=(%%K+1)*6"
)

if not defined arg3 (
  Echo(
  Echo speed mode?
  Echo 1: default
  Echo 2: Delta Catchup
  Echo 3: Burst
)
Set "mode="& Set "modes=1:default 2:delta 3:burst"
For /f "Delims=" %%K in ('%arg3%choice /n /c:123 2^> nul') Do (
  For /f "tokens=1 delims= " %%G in ("!modes:*%%K:=!") Do set "mode=%%G"
)

if not defined arg4 (
  Echo(
  Echo Screen clearing?
  Echo 1: no
  Echo 2: yes
)
Set "clearing="
For /f "Delims=" %%K in ('%arg4%choice /n /c:12 2^> nul') Do If "%%K" == "2" Set "clearing=%\E%[H%\E%[2J"

rem random seed method by IcarusLives
set /a "'=(%RANDOM%<<15)|%RANDOM%,'+=((('-1)>>31)&1)"
set /a "`=(!RANDOM!<<15)|!RANDOM!,`+=(((`-1)>>31)&1)"


Set rand.hue="rr=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,gg=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,bb=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,rr=rr*100/125,gg=gg*100/125,bb=bb*100/125"

if not defined clearing Set rand.hue="rr=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(200-45+1)))+45,gg=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(25-10+1)))+10,bb=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(25-10+1)))+10,rr=rr*100/125,gg=gg*100/125,bb=bb*100/125"
(title )

rem constrain deltaTime of MoveRate to representable tElapse ; 1= 100cs, 2 = 50cs, 3 = 33cs, 100 = 1cs
Set "MoveRate=100,50,33,21,18,16,14,12,11,10,9,8,7,6,5,4,3,2"
If /i "!mode!" == "burst" Set "MoveRate=!MoveRate:*18,=!"
rem Dirty is unlikely to be false for MoveRates GEQ 18 [ corresponding to 6 'ticks' or more per second ]

Set i=1
Set /a "MoveRate!i!=100/%MoveRate:,=" & Set /a "i+=1" & Set /a "MoveRate!i!=100/%"

For /l %%i in (1 1 !#!) do if %%i lss 31 (rem frame generator restriction
  Set /a !rand.hue!
  Set "_%%i.c=%\E%[38;2;!rr!;!gg!;!bb!m"
  Set /a "delta=!random! %% !i! + 1"
  For /f "delims=" %%T in ("!Delta!") Do Set /a "_%%i.mr=!MoveRate%%T!"
  Set /a "_%%i.fL=(!random! %% 3 + 3)+1,_%%i.xL=1,_%%i.xH=wid-(%%i %%2),_%%i.w=1,_%%i.x=!random! %% (wid/2) + (wid/4)" || pause
  Set /a "_%%i.fH=(!random! %% 8 + 6)+1,_%%i.yL=1,_%%i.yH=hei+(%%i %%2),_%%i.h=1,_%%i.y=!random! %% (hei/2) + (hei/4)" || pause
)
For /f "tokens=1 delims==" %%G in ('Set MoveRate') Do Set "%%G="

mode %wid%,%sHei%



rem requires - + by sign value when prforming min / max boundary test

if /i "!mode!" == "default" Set "rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-et)>>31)|(_%%i.rc*-1)),_%%i.mn=_%%i.md*(et+_%%i.mr)+((1-_%%i.md)*_%%i.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),_%%i.x+=_%%i.md*_%%i.sx,_%%i.x-=-1*((_%%i.xH-(_%%i.x+_%%i.w))>>31),_%%i.x+=-1*((_%%i.x-_%%i.xL)>>31),_%%i.y+=_%%i.md*_%%i.sy,_%%i.y-=-1*((_%%i.yH-(_%%i.y+_%%i.h))>>31),_%%i.y+=-1*((_%%i.y-_%%i.yL)>>31),_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=_%%i.rc,_%%i.yc|=_%%i.rc"

if /i "!mode!" == "delta" Set "rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-et)>>31)|(_%%i.rc*-1)),_%%i.mn=_%%i.md*(et+_%%i.mr)+((1-_%%i.md)*_%%i.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),cu=((-1*((_%%i.mn-et))/_%%i.mr),cu=cu+((cu|-cu)>>31)+1,_%%i.cd-=cu,_%%i.x+=_%%i.md*_%%i.sx*cu,_%%i.y+=_%%i.md*_%%i.sy*cu,_%%i.y+=_%%i.md*_%%i.sy,_%%i.y+=-1*((_%%i.y-_%%i.yL)>>31),_%%i.x+=((_%%i.x-_%%i.xL)>>31)*(-1*(_%%i.xL-_%%i.x)),_%%i.y+=((_%%i.y-_%%i.yL)>>31)*(-1*(_%%i.yL-_%%i.y)),?=(_%%i.x+_%%i.w-1)-_%%i.xH,_%%i.x=_%%i.xH+(?&(?>>31)),?=(_%%i.y+_%%i.h-1)-_%%i.yH,_%%i.y=_%%i.yH+(?&(?>>31)),_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=_%%i.rc,_%%i.yc|=_%%i.rc"

if /i "!mode!" == "burst" Set "rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-et)>>31)|(_%%i.rc*-1)),_%%i.mn=_%%i.md*(et+(_%%i.mr-(_%%i.fH*_%%i.xc)))+((1-_%%i.md)*_%%i.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),_%%i.x+=_%%i.md*_%%i.sx,_%%i.x-=-1*((_%%i.xH-(_%%i.x+_%%i.w))>>31),_%%i.x+=-1*((_%%i.x-_%%i.xL)>>31),_%%i.y+=_%%i.md*_%%i.sy,_%%i.y-=-1*((_%%i.yH-(_%%i.y+_%%i.h))>>31),_%%i.y+=-1*((_%%i.y-_%%i.yL)>>31),_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=_%%i.rc,_%%i.yc|=_%%i.rc"


Set ".-1-1=\" &REM ;||  vector 'array' is indexed in accordance with
Set ".-10=^"  &REM ;||  with the Y;X representation virtual terminal
Set ".-11=/"  &REM ;||  sequences are implemented in by windows.
Set ".0-1=<"  &REM ;||
Set ".00=o"   &REM ;||   \^/  -1,-1 -1,0 -1,1
Set ".01=>"   &REM ;||   <O>   0,-1  0,0  0,1
Set ".1-1=/"  &REM ;||   /v\   1,-1  1,0  1,1
Set ".10=v"   &REM ;||    
Set ".11=\"   &REM ;||    

rem @mark clock by IcarusLives
set "@mark=((((1^!clock:~0,2^!-100)*60+(1^!clock:~3,2^!-100))*60+(1^!clock:~6,2^!-100))*100+(1^!clock:~9,2^!-100))"
rem set /a "step=%~1, maxCatchUp=step-1" 2> nul || Set /a "step=4, maxCatchUp=step-1" 

<nul set /p "=%\E%[?25l"


Set "metaVars=%=_whitespace_intended_=% @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}"

( Set "entities=" & Set "screen=%clearing%"
  for /l %%i in (1 1 !#!) Do (
    Set "metaVar=^^!metaVars:~%%i,1!"
    For /f "delims=" %%} in ("!metaVar!") Do (
      Set "entities=!entities! ^!_%%i.sy^!^!_%%i.sx^!"
      set "screen=!screen!!_%%i.c!%\E%[^!_%%i.y^!;^!_%%i.x^!H^!.%%%%}^!"
  ) )
  Set "metaVars="
)
Set Frame=For /f "tokens=1-!#! delims= " %%@ in ("!entities:~1!") Do Echo(!Screen!%\E%[0m



2> nul ( %= unload =%
  for /l %%i in (1 1 !#!) Do Set "_%%i.c="

  Set "rWalker="
  Set "frame="
  Set "rand.hue="
  Set "screen="
  Set "@mark="
  
  set "clock=!time: =0!"
  set /a "et=%@mark%, et+=(e>>31&1)*8640000","lt=et","frame=0"
  for /l %%i in () Do (
    if not "!time: =0!" == "!clock!" (
      set "clock=!time: =0!"
      set /a "et=%@mark%, et+=((et-lt)>>31&1)*8640000","Dirty=0"

      For /l %%i in (1 1 !#!) Do Set /a "%rWalker%"
      If !Dirty! NEQ 0 (
        Set /a "frame+=1,ttlE+=(et-lt),ips=100/(ttlE/frame),ttlE/=(-1*((999-frame)>>31))+1,frame/=(-1*((999-frame)>>31))+1,lt=et"
        Title ips:!ips!
        %frame%
      )
) ) )

Echo(%\E%[?25h
PAUSE
Endlocal
goto:eof


EXIT %= the below is not intended to be executed - hence the hard exit.  =%

Dirty|=(_%%i.md=-1*((_%%i.mn-et)>>31)|(_%%i.rc*-1))                           ; flag dirty and md 'move do' if et 'elapsed time' gtr mn 'move next' or rc 'reset cooldown' == 1
_%%i.mn=_%%i.md*(et+_%%i.mr)+((1-_%%i.md)*_%%i.mn)                            ; preserve current mn if not yet md; else set new mn
xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL  ; generate random cd coefficient: xe 'x expiry' Value in range : [ high-low ... + low ]
_%%i.xd=-1*((_%%i.xc-=-1*~((_%%i.xc)>>31))>>31)                               ; decrease cooldown timer if timer gtr -1 ; flag 'do' true : xd == 1 if cd == -1
_%%i.xc+=_%%i.xd*(xe+1)                                                       ; new cd value added from xe if xd == 1 
rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2                        ; generate random sign x -1 0 or 1
_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx)                                      ; selectively assign new sx if xd == 1 
ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL  ; repeat above logic for y using a different random seed
_%%i.yd=-1*((_%%i.yc-=-1*~((_%%i.yc)>>31))>>31)
_%%i.yc+=_%%i.yd*(ye+1)
ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2
_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy)
_%%i.x+=_%%i.sx,_%%i.x-=(-1*((_%%i.xH-(_%%i.x+_%%i.w))>>31)),_%%i.x+=(-1*((_%%i.x-_%%i.xL)>>31)) ; increment by ( sx - (1 if x gtr x max) + ( 1 if x lss x min )
_%%i.y+=_%%i.sy,_%%i.y-=(-1*((_%%i.yH-(_%%i.y+_%%i.h))>>31)),_%%i.y+=(-1*((_%%i.y-_%%i.yL)>>31)) ; clamped sign modification as above for y
,...                                                               F     T reset _#.cd 'rc' if:
rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|^          ;  0  | -1       sy,sX == 0,0
   -(-1*~((_%%i.xL-_%%i.x)>>31))|^                              ;  0  | -1       _#.x  == min X
   -(-1*((_%%i.xH-(_%%i.x+_%%i.w))>>31)-1)|^                    ;  0  | -1       _#.x  == max x 
   -(-1*~((_%%i.yL-_%%i.y)>>31))|^                              ;  0  | -1       _#.y  == min y
   -(-1*((_%%i.yH-(_%%i.y+_%%i.h))>>31)-1)                      ;  0  | -1       _#.y  == max y
_%%i.xc|=rc                                                     ; xc  | -1         rc  == -1
_%%i.yc|=rc                                                     ; yc  | -1         rc  == -1
