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

For /f "delims=124456-? " %%V in ('echo %*') do goto:skip
if not %errorlevel% == 0 goto:skip

Set args= 1:Dimensions 2:Walker.Count 3:Speed.Mode 4:Screen.Clearing 5:Color.Mode
Set "argV= 64322"
Set "argHelp="
For /l %%i in (1 1 5) Do (
  Call set "arg%%~i=%%%%~i"
  if "%%i:!arg1!" == "1:-?" Set "argHelp=1" & Set "arg1="
  if defined argHelp For /f "tokens=1 delims= " %%G in ("!args:*%%i:=!") Do (Set "arg=%%~G"
    Echo( Arg:%%i  1~!argV:~%%i,1! : !arg:.= !
  )
  If defined arg%%i (
    if !arg%%i! GTR !argV:~%%i^,1! Set "arg%%i=!argV:~%%i,1!"
    Set "arg%%i=Echo !arg%%i!^^|"
) )

if defined argHelp (
  Timeout /t 5
  exit /b 0
)
:skip


(Set \n=^^^

%= do not modify this \n newline defintion =%)

Set menu=For %%n in (1 2) Do if %%n == 2 (%\n%
  Set "choices="%\n%
  For /f "tokens=1 Delims=?" %%Q in ("^!Args^!") Do (%\n%
    Set "Options=^!Args:%%~Q? =^!"%\n%
    if not defined arg# Echo(%\E%[H%\E%[2J%\E%[E%%Q?%\n%
    For %%G in (^^!Options^^!) Do (%\n%
      Set "arg=%%~G"%\n%
      Set "choices=^!choices^!^!arg:~0,1^!"%\n%
      if not defined arg# Echo( %%~G%\n%
    )%\n%
  )%\n%
  Set "menu.Ask=^!arg#^!choice /n /c:^!choices^! 2^^^^> nul"%\n%
)Else set Args=

<nul Set /p "=%\E%[H%\E%[2J%\E%[48;2;12;12;60m%\E%[38;2;210;120;30m"

%menu:#=1% dimensions? 1:12x36 2:16x48 3:20x60 4:24x72 5:28x84 6:32x96
For /f "Delims=" %%K in ('%menu.Ask%') Do (
  For /f "tokens=1,2 delims=x " %%G in ("!Options:*%%K:=!") Do (
   Set /a "hei=%%G","wid=%%H","shei=hei+1"
) )

%menu:#=2% how many 'walkers?  1:12 2:18 3:24 4:30
For /f "Delims=" %%K in ('%menu.Ask%') Do (
  For /f "tokens=1 delims= " %%G in ("!Options:*%%K:=!") Do (
    Set /a "#=%%G"
) )

Set "mode="
%menu:#=3% Walker Mode? 1:default 2:chase 3:Delta 4:burst
For /f "Delims=" %%K in ('%menu.Ask%') Do ( 
  For /f "tokens=1 delims= " %%G in ("!Options:*%%K:=!") Do set "mode=%%G"
)

%menu:#=4% Screen Clearing? 1:no 2:yes
Set "clearing="
For /f "Delims=" %%K in ('%menu.Ask%') Do If "%%K" == "2" Set "clearing=%\E%[H%\E%[2J"


%menu:#=5% Color Mode? 1:Red 2:Random
For /f "Delims=" %%K in ('%menu.Ask%') Do (
  For /f "tokens=1 delims= " %%G in ("!Options:*%%K:=!") Do set "colorMode=%%G"
)

rem random seed method by IcarusLives
set /a "'=(%RANDOM%<<15)|%RANDOM%,'+=((('-1)>>31)&1)"
set /a "`=(!RANDOM!<<15)|!RANDOM!,`+=(((`-1)>>31)&1)"
set /a "prox=4"

if /i "!colorMode!" == "Random" Set rand.hue="rr=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,gg=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,bb=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(255-35+1)))+35,rr=rr*100/125,gg=gg*100/125,bb=bb*100/125"

if /i "!colorMode!" == "Red" Set rand.hue="rr=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(200-45+1)))+45,gg=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(25-10+1)))+10,bb=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(25-10+1)))+10,rr=rr*100/125,gg=gg*100/125,bb=bb*100/125"
(title )


rem constrain deltaTime of MoveRate to representable tElapse ; 1= 100cs, 2 = 50cs, 3 = 33cs, 100 = 1cs
rem 1, 2 and 3cs tick rates only likely to be achieved with low entitiy count or when using delta catch up mode
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
  Set /a "_%%i.fL=(!random! %% 3 + 3)+1,_%%i.xL=1,_%%i.xH=wid-(%%i %%2),_%%i.w=1,_%%i.x=!random! %% (wid/2) + (wid/4)"
  Set /a "_%%i.fH=(!random! %% 8 + 6)+1,_%%i.yL=1,_%%i.yH=hei+(%%i %%2),_%%i.h=1,_%%i.y=!random! %% (hei/2) + (hei/4)"
)

mode %wid%,%sHei%

Set /a "p.mr=100/10"
Set /a "p.fL=(!random! %% 3 + 3)+1,p.xL=1,p.xH=wid,p.w=1,p.x=!random! %% (wid/2) + (wid/4)"
Set /a "p.fH=(!random! %% 8 + 6)+1,p.yL=1,p.yH=hei,p.h=1,p.y=!random! %% (hei/2) + (hei/4)"

if /i "!mode!" == "default" Set "rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-et)>>31)|(_%%i.rc*-1)),_%%i.mn=_%%i.md*(et+_%%i.mr)+((1-_%%i.md)*_%%i.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),_%%i.x+=_%%i.md*_%%i.sx,_%%i.x-=-1*((_%%i.xH-(_%%i.x+_%%i.w))>>31),_%%i.x+=-1*((_%%i.x-_%%i.xL)>>31),_%%i.y+=_%%i.md*_%%i.sy,_%%i.y-=-1*((_%%i.yH-(_%%i.y+_%%i.h))>>31),_%%i.y+=-1*((_%%i.y-_%%i.yL)>>31),_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=_%%i.rc,_%%i.yc|=_%%i.rc"

if /i "!mode!" == "delta" Set "rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-1-et)>>31)|(_%%i.rc*-1)),cu=(-1*((_%%i.mn-1-et))/_%%i.mr),cu=((cu>>31)*cu)+cu+(((cu|-cu))>>31)+1,cu+=(((cu|-cu))>>31)+1,_%%i.mn=_%%i.md*(et+_%%i.mr)+((1-_%%i.md)*_%%i.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),_%%i.x+=_%%i.md*_%%i.sx*cu,_%%i.y+=_%%i.md*_%%i.sy*cu,_%%i.x+=((_%%i.x-_%%i.xL)>>31)*(-1*(_%%i.xL-_%%i.x)),_%%i.y+=((_%%i.y-_%%i.yL)>>31)*(-1*(_%%i.yL-_%%i.y)),?=(_%%i.x+_%%i.w-1)-_%%i.xH,_%%i.x=_%%i.xH+(?&(?>>31)),?=(_%%i.y+_%%i.h-1)-_%%i.yH,_%%i.y=_%%i.yH+(?&(?>>31)),_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=_%%i.rc,_%%i.yc|=_%%i.rc"

if /i "!mode!" == "chase" Set "rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-1-et)>>31)|(_%%i.rc*-1)),cu=(-1*((_%%i.mn-1-et))/_%%i.mr),cu=((cu>>31)*cu)+cu+(((cu|-cu))>>31)+1,cu+=(((cu|-cu))>>31)+1,_%%i.mn=_%%i.md*(et+_%%i.mr)+((1-_%%i.md)*_%%i.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),dx=(_.px-_%%i.x),?=dx>>31,abX=(dx^?)-?,dx=?|-((_%%i.x-_.px)>>31),dy=(_.py-_%%i.y),?=dy>>31,abY=(dy^?)-?,dy=?|-((_%%i.y-_.py)>>31),chase=-1*(((abY-prox)>>31)&((abX-prox)>>31)),_%%i.sx=chase*dx+((1-chase)*_%%i.sx),_%%i.sy=chase*dy+((1-chase)*_%%i.sy),_%%i.x+=_%%i.md*_%%i.sx*cu,_%%i.y+=_%%i.md*_%%i.sy*cu,_%%i.x+=((_%%i.x-_%%i.xL)>>31)*(-1*(_%%i.xL-_%%i.x)),_%%i.y+=((_%%i.y-_%%i.yL)>>31)*(-1*(_%%i.yL-_%%i.y)),?=(_%%i.x+_%%i.w-1)-_%%i.xH,_%%i.x=_%%i.xH+(?&(?>>31)),?=(_%%i.y+_%%i.h-1)-_%%i.yH,_%%i.y=_%%i.yH+(?&(?>>31)),_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=_%%i.rc,_%%i.yc|=_%%i.rc"

if /i "!mode!" == "chase" Set "rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-1-et)>>31)|(_%%i.rc*-1)),cu=(-1*((_%%i.mn-1-et))/_%%i.mr),cu=((cu>>31)*cu)+cu+(((cu|-cu))>>31)+1,cu+=(((cu|-cu))>>31)+1,_%%i.mn=_%%i.md*(et+_%%i.mr)+((1-_%%i.md)*_%%i.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),dx=(p.x-_%%i.x),?=dx>>31,abX=(dx^?)-?,dx=?|-((_%%i.x-p.x)>>31),dy=(p.y-_%%i.y),?=dy>>31,abY=(dy^?)-?,dy=?|-((_%%i.y-p.y)>>31),chase=-1*(((abY-prox)>>31)&((abX-prox)>>31)),_%%i.sx=chase*dx+((1-chase)*_%%i.sx),cu=chase*1+((1-chase)*cu),_%%i.sy=chase*dy+((1-chase)*_%%i.sy),_%%i.x+=_%%i.md*_%%i.sx*cu,_%%i.y+=_%%i.md*_%%i.sy*cu,_%%i.x+=((_%%i.x-_%%i.xL)>>31)*(-1*(_%%i.xL-_%%i.x)),_%%i.y+=((_%%i.y-_%%i.yL)>>31)*(-1*(_%%i.yL-_%%i.y)),?=(_%%i.x+_%%i.w-1)-_%%i.xH,_%%i.x=_%%i.xH+(?&(?>>31)),?=(_%%i.y+_%%i.h-1)-_%%i.yH,_%%i.y=_%%i.yH+(?&(?>>31)),_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=_%%i.rc,_%%i.yc|=_%%i.rc"

if /i "!mode!" == "burst" Set "rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-et)>>31)|(_%%i.rc*-1)),_%%i.mn=_%%i.md*(et+(_%%i.mr-(_%%i.fH*_%%i.xc)))+((1-_%%i.md)*_%%i.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31),_%%i.xc+=_%%i.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL,_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31),_%%i.yc+=_%%i.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy),_%%i.x+=_%%i.md*_%%i.sx,_%%i.x-=-1*((_%%i.xH-(_%%i.x+_%%i.w))>>31),_%%i.x+=-1*((_%%i.x-_%%i.xL)>>31),_%%i.y+=_%%i.md*_%%i.sy,_%%i.y-=-1*((_%%i.yH-(_%%i.y+_%%i.h))>>31),_%%i.y+=-1*((_%%i.y-_%%i.yL)>>31),_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|-(-1*~((_%%i.xL-_%%i.x)>>31))|-(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|-(-1*~((_%%i.yL-_%%i.y)>>31))|-(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31)),_%%i.xc|=_%%i.rc,_%%i.yc|=_%%i.rc"

Set "Walker=Dirty|=(p.md=-1*((p.mn-et)>>31)|(p.rc*-1)),p.mn=p.md*(et+(p.mr-(p.fH*p.xc)))+((1-p.md)*p.mn),xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(p.fH-p.fL+1)))+p.fL,p.xd=-1*((p.xc-=p.md*-1*~((p.xc)>>31))>>31),p.xc+=p.xd*xe,rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2,p.sx=p.xd*rx+((1-p.xd)*p.sx),ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(p.fH-p.fL+1)))+p.fL,p.yd=-1*((p.yc-=p.md*-1*~((p.yc)>>31))>>31),p.yc+=p.yd*ye,ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2,p.sy=p.yd*ry+((1-p.yd)*p.sy),p.x+=p.md*p.sx,p.x-=-1*((p.xH-(p.x+p.w))>>31),p.x+=-1*((p.x-p.xL)>>31),p.y+=p.md*p.sy,p.y-=-1*((p.yH-(p.y+p.h))>>31),p.y+=-1*((p.y-p.yL)>>31),p.rc=-(-1*(-1-((p.sx|p.sy)|-(p.sy|p.sx))))|-(-1*~((p.xL-p.x)>>31))|-(-1*((p.xH-(p.x+p.w)-1)>>31))|-(-1*~((p.yL-p.y)>>31))|-(-1*((p.yH-(p.y+p.h)-1)>>31)),p.xc|=p.rc,p.yc|=p.rc"


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


Set "metaVars=%=_whitespace_intended_=% @ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}"
( Set "entities=" & Set "screen=%clearing%"
  for /l %%i in (1 1 !#!) Do (
    Set "metaVar=^^!metaVars:~%%i,1!"
    For /f "delims=" %%} in ("!metaVar!") Do (
      Set "entities=!entities! ^!_%%i.sy^!^!_%%i.sx^!"
      set "screen=!screen!!_%%i.c!%\E%[^!_%%i.y^!;^!_%%i.x^!H^!.%%%%}^!%\E%[0m"
  ) )
  Set "metaVars="
)
Set Frame=For /f "tokens=1-!#! delims= " %%@ in ("!entities:~1!") Do Echo(!Screen!%\E%[0m


<nul set /p "=%\E%[?25l%\E%[H%\E%[0m%\E%[2J"


2> nul ( %= unload =%
  For %%U in ("MoveRate" "Arg" "Screen") Do For /f "tokens=1 delims==" %%G in ('Set %%~U') Do Set "%%G="
  for /l %%i in (1 1 !#!) Do Set "_%%i.c="

  Set "rWalker="
  Set "Walker="
  Set "frame="
  Set "rand.hue="
  Set "@mark="
  
  set "clock=!time: =0!"
  set /a "et=%@mark%, et+=(e>>31&1)*8640000","lt=et","frame=0"
  for /l %%i in () Do (
    if not "!time: =0!" == "!clock!" (
      set "clock=!time: =0!"
      set /a "et=%@mark%, et+=((et-lt)>>31&1)*8640000","Dirty=0",
      set /a "%walker%"
      For /l %%i in (1 1 !#!) Do Set /a "%rWalker%"
      If !Dirty! NEQ 0 (
        Set /a "frame+=1,ttlE+=(et-lt),ips=100/(ttlE/frame),ttlE/=(-1*((999-frame)>>31))+1,frame/=(-1*((999-frame)>>31))+1,lt=et"
        Title ips:!ips!
        %frame%%\E%[!p.y!;!p.x!HX
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

Chase:
rWalker=Dirty|=(_%%i.md=-1*((_%%i.mn-1-et)>>31)|(_%%i.rc*-1))                                  ; flag Dirty if 'Move Do' or 'Reset Cooldown' equ -1
cu=(-1*((_%%i.mn-1-et))/_%%i.mr),cu=((cu>>31)*cu)+cu+(((cu|-cu))>>31)+1,cu+=(((cu|-cu))>>31)+1 ; cu = 'catchup' coefficient multiplier for frames due since last evaluation
_%%i.mn=_%%i.md*(et+_%%i.mr)+((1-_%%i.md)*_%%i.mn)                                             ; preserve or set new 'Move Next' time if 'Move Do' equ 1
xe=(`^=`<<13,`^=`>>17,`^=`<<5,((`&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL                   ; generate cooldown magnitude for next x movement cycle
_%%i.xd=-1*((_%%i.xc-=_%%i.md*-1*~((_%%i.xc)>>31))>>31)                                        ; decrease x cooldown if md equ 1 and xc geq 0
_%%i.xc+=_%%i.xd*xe                                                                            ; increase x cooldown duration if 'x do' equ 1
rx=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%3+1))-2                                         ; generate random sign for next x movement change
_%%i.sx=_%%i.xd*rx+((1-_%%i.xd)*_%%i.sx)                                                       ; apply sign change if 'x do' equ 1
ye=('^='<<13,'^='>>17,'^='<<5,(('&0x7FFFFFFF)%%(_%%i.fH-_%%i.fL+1)))+_%%i.fL                   ; as above for y axis
_%%i.yd=-1*((_%%i.yc-=_%%i.md*-1*~((_%%i.yc)>>31))>>31)
_%%i.yc+=_%%i.yd*ye
ry=(`^=`<<13,`^=`>>17,`^=`<<5,(('&0x7FFFFFFF)%%3+1))-2
_%%i.sy=_%%i.yd*ry+((1-_%%i.yd)*_%%i.sy)
dx=(_.px-_%%i.x),?=dx>>31,abX=(dx^?)-?,dx=?|-((_%%i.x-_.px)>>31)                               ; generate player relative x sign and Abs distance
dy=(_.py-_%%i.y),?=dy>>31,abY=(dy^?)-?,dy=?|-((_%%i.y-_.py)>>31)                               ; generate player relative y sign and Abs distance
chase=-1*(((abY-prox)>>31)&((abX-prox)>>31))                                                   ; if prox lss ABs radius for both x and y, chase equ 1
_%%i.sx=chase*dx+((1-chase)*_%%i.sx)                                                           ; preserve current 'sign x' if chase equ 0; else adopt player relative sign
_%%i.sy=chase*dy+((1-chase)*_%%i.sy)                                                           ; as above for y axis
_%%i.x+=_%%i.md*_%%i.sx*cu                                                                     ; apply movement at intended magnitude for time Elapsed
_%%i.y+=_%%i.md*_%%i.sy*cu
_%%i.x+=((_%%i.x-_%%i.xL)>>31)*(-1*(_%%i.xL-_%%i.x))                                           ; clamp min
_%%i.y+=((_%%i.y-_%%i.yL)>>31)*(-1*(_%%i.yL-_%%i.y))
?=(_%%i.x+_%%i.w-1)-_%%i.xH,_%%i.x=_%%i.xH+(?&(?>>31))                                         ; clamp max
?=(_%%i.y+_%%i.h-1)-_%%i.yH,_%%i.y=_%%i.yH+(?&(?>>31))
_%%i.rc=-(-1*(-1-((_%%i.sx|_%%i.sy)|-(_%%i.sy|_%%i.sx))))|^                                    ; rc equ -1 if any condition true. deny idling by forcing vector change
        -(-1*~((_%%i.xL-_%%i.x)>>31))|^                                                        ; left boundary bounce by forcing vector change
        -(-1*((_%%i.xH-(_%%i.x+_%%i.w)-1)>>31))|^                                              ; right boundary bounce ...
        -(-1*~((_%%i.yL-_%%i.y)>>31))|^                                                        ; top boundary ...
        -(-1*((_%%i.yH-(_%%i.y+_%%i.h)-1)>>31))                                                ; bottom boundary ...
_%%i.xc|=_%%i.rc                                                                               ; xc = xc or -1
_%%i.yc|=_%%i.rc                                                                               ; yc = yc or -1


