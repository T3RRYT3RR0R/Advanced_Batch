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

Echo( dimensions?
echo 1 : 12x36
echo 2 : 16x48
echo 3 : 20x60
echo 4 : 24x72
For /f "Delims=" %%K in ('choice /n /c:1234') Do (
  Set /a "hei=(((%%K + 3) * 4)-4)","wid=hei*3"
)

Echo(
Echo how many 'walkers?
Echo 1 : 12
Echo 2 : 18
Echo 3 : 24
Echo 4 : 30

For /f "Delims=" %%K in ('choice /n /c:1234') Do (
  Set /a "#=(%%K+1)*6"
)

Echo(
Echo Target FPS?
Echo 1 : 11
Echo 2 : 25
Echo 3 : 33
Echo 4 : 50

For /f "Delims=" %%K in ('choice /n /c:1234') Do (
  Set /a "step=10000/(%%K*11),step/=99,maxCatchUp=step-1"
)

Echo(
Echo Screen clearing?
Echo 1: no
Echo 2: yes
Set "clearing="
For /f "Delims=" %%K in ('choice /n /c:12') Do If "%%K" == "2" Set "clearing=%\E%[H%\E%[2J"

rem random seed method by IcarusLives
set /a "'=(%RANDOM%<<15)|%RANDOM%,'+=((('-1)>>31)&1)"
set /a "`=(!RANDOM!<<15)|!RANDOM!,`+=(((`-1)>>31)&1)"


Set rand.hue="rr=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,gg=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,bb=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,rr=rr*100/125,gg=gg*100/125,bb=bb*100/125"
if not defined clearing Set rand.hue="rr=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(200-45+1)))+45,gg=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(25-10+1)))+10,bb=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(25-10+1)))+10,rr=rr*100/125,gg=gg*100/125,bb=bb*100/125"

For /l %%i in (1 1 !#!) do if %%i lss 31 (rem frame generator restriction
  Set /a !rand.hue!
  Set "_%%i.c=%\E%[38;2;!rr!;!gg!;!bb!m"
  Set /a "_%%i.fL=(!random! %% 3 + 3)+1,_%%i.xL=1,_%%i.xH=wid-(%%i %%2),_%%i.w=1,_%%i.x=!random! %% (wid/2) + (wid/4)" || pause
  Set /a "_%%i.fH=(!random! %% 8 + 6)+1,_%%i.yL=1,_%%i.yH=hei+(%%i %%2),_%%i.h=1,_%%i.y=!random! %% (hei/2) + (hei/4)" || pause
)

mode %wid%,%hei%


Set "rWalker=xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*(xe+1),rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*(ye+1),ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),_%%i.x+=_%%i.sx,_%%i.x-=(-1*((_%%i.xH-(_%%i.x+_%%i.w))>>31)),_%%i.x+=(-1*((_%%i.x-_%%i.xL)>>31)),_%%i.y+=_%%i.sy,_%%i.y-=(-1*((_%%i.yH-(_%%i.y+_%%i.h))>>31)),_%%i.y+=(-1*((_%%i.y-_%%i.yL)>>31)),rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=rc,_%%i.yc|=rc"


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

set "clock=!time: =0!"
set /a "t1=%@mark%, e=t1-t0, e+=(e>>31&1)*8640000"
<nul set /p "=%\E%[?25l"

rem maximum per character cost = 30 "\[XX;X;XXX;XXX;XXXx\[YY;XXXH?"
rem          30 character cap  = 900 + 11 "\[H\[2J\[0m"
rem set /p supports up to 1024 ; 

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
Set Frame=For /f "tokens=1-!#! delims= " %%@ in ("!entities:~1!") Do ^<nul set /p=!Screen!%\E%[0m



2> nul ( %= unload =%
  for /l %%i in (1 1 !#!) Do Set "_%%i.c="

  Set "rWalker="
  Set "frame="
  Set "rand.hue="
  Set "screen="
  Set "@mark="
  
  for /l %%i in () Do (
    if not "!time: =0!" == "!clock!" (
      set "clock=!time: =0!"
      set /a "t1=%@mark%, e=t1-t0, e+=(e>>31&1)*8640000"

      if !e! geq %step% (

        set /a "k=e/step", "ec+=1"
        if !k! gtr %maxCatchUp% (
          set /a "k=maxCatchUp, t0=t1"
        ) else (
          set /a "t0=(t0+k*step) %% 8640000"
        )
        For /l %%i in (1 1 !#!) Do Set /a "%rWalker%"

        %frame%

        rem display fps in title
        if !ec! geq 30 (
          set /a "d=t1-tp, d+=(d>>31&1)*8640000, d+=((d-1)>>31&1)*(1-d)",^
                 "ips=ec*10000/d, tp=t1, ec=0, ipi=ips/100, ipf=ips %% 100,100!ipf!"
          title !ipi!.!ipf:~-2! fps
) ) ) ) )
Echo(%\E%[?25h
PAUSE
Endlocal
goto:eof


EXIT %= the below is not intended to be executed - hence the hard exit.  =%


xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL     ; generate random cd coefficient: xe 'x expiry' Value in range : [ high-low ... + low ]
_%%i.xd=-1*((_%%i.xc-=-1*~((_%%i.xc)>>31))>>31)                                  ; decrease cooldown timer if timer gtr -1 ; flag 'do' true : xd == 1 if cd == -1
_%%i.xc+=_%%i.xd*(xe+1)                                                          ; new cd value added from xe if xd == 1 
rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2                           ; generate random sign x -1 0 or 1
_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx)                                         ; selectively assign new sx if xd == 1 
ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL     ; repeat above logic for y using a different random seed
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
