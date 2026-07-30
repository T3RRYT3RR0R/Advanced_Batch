<# : batch portion
:# The above line marks the beginning of a powershell comment block; and the Batch component of the Script. Do not modify.

@Echo off
REM Author: T3RRY : 19/05/2024
REM        updated: 13/07/2026
REM this Script demonstrates various advanced batch techniques by way of
REM a feature rich animated clock, with peristent user configuration.

  if defined WT_Session (
    If /i not "%~1" == "Main" If /i not "%~1" == "XCOPYcontroller" (
      %= preserve font and mode resize capability if run from WindowsTerminal =%
      If /i not "%~1" == "delTemp" call :Set_Font "lucida console" 18 nomax %~1 || EXIT
    )
  ) else (
    %= Default font resize method =%
    if not defined WT_Session call :SetFont 18 "lucida console"
  )

  (Title )
  REM execute target threads
  Set "Script=Main"
  If not "%~1"=="" If not "%~1"=="_" Goto:%1
  Set "thisFile=%~nx0"
  Goto:Setup

:Main
  Setlocal EnableDelayedExpansion

  CHCP 65001 > nul

REM data structures for displaying characters '1'~'9' and ':', with # replaced with literal value for 1~9
  %= move cursor to next X   =% Set ".=%\E%8%\E%[B%\E%7"
  %= move cursor to next Y   =% Set "+=%\E%[4A "

  Set "[9]=%\E%7###%.%# #%.%###%.%  #%.%  #%+%" & Set "[8]=%\E%7###%.%# #%.%###%.%# #%.%###%+%"
  Set "[7]=%\E%7###%.%  #%.%  #%.%  #%.%  #%+%" & Set "[6]=%\E%7#  %.%#  %.%###%.%# #%.%###%+%"
  Set "[5]=%\E%7###%.%#  %.%###%.%  #%.%###%+%" & Set "[4]=%\E%7# #%.%# #%.%###%.%  #%.%  #%+%"
  Set "[3]=%\E%7###%.%  #%.%###%.%  #%.%###%+%" & Set "[2]=%\E%7###%.%  #%.%###%.%#  %.%###%+%"
  Set "[1]=%\E%7 # %.% # %.% # %.% # %.% # %+%" & Set "[0]=%\E%7###%.%# #%.%# #%.%# #%.%###%+%"

  %= HH MM SS CS seperator animation array and config =%
  Set "_1=%\E%7   %.% ♥ %.%   %.% ♥ %.%   %+%"
  Set "_2=%\E%7   %.% ♦ %.%   %.% ♦ %.%   %+%"
  Set "_3=%\E%7   %.% ♣ %.%   %.% ♣ %.%   %+%"
  Set "_4=%\E%7   %.% ♠ %.%   %.% ♠ %.%   %+%"

  %= rotates R G B hues of HH MM SS CS seperator =%
:# rem %= OBSOLETE =% || Set ^"phase.hue=for %%n in (1 2) do if %%n==2 (For /f "tokens=1,*" %%1 in ("^!args^!")do (set /a "p=(%%~2)%%510"^&if ^^^!p^^^! GTR 255 (set /a "%%1%%1=510-p") else set /a "%%1%%1=p")) else set args=^"

  REM %= DEACTIVATED =% Set /a "hue_osc_deg=10"
                        Set /a "hue_acc=1"
  REM %= DEACTIVATED =% Set /a "hue_acc=( hue_osc_deg * 170 / 120 )"

rem 6000 CS / minute. 6000 / 510 steps =11 CS to cycle hue wheel in 1 minute, where hue_acc = 1
  Set /a "_step=1","_stepMax=4,_step_CS=11,_step_CSb=50"

REM Branchless version of phase.hue uses abs from the lib\maths library by IcarusLives
REM https://github.com/IcarusLivesHF/Atlas/blob/main/lib/Math.bat
  Set ^"phase.hue=Set /a "hue.step=hue.step %% 510 + hue_acc","p=(hue.step)-255, rr=255-(M=(p>>31),(p^M)-M)","p=((hue.step+170)%%510)-255, gg=255-(M=(p>>31),(p^M)-M)","p=((hue.step+340)%%510)-255, bb=255-(M=(p>>31),(p^M)-M)","rr1=rr*100/120,gg1=gg*100/120,bb1=bb*100/120,rr2=rr1*100/120,gg2=gg1*100/120,bb2=bb1*100/120,rr3=rr2*100/115,gg3=gg2*100/115,bb3=bb2*100/115"^"


  %phase.hue%

  %= DO NOT MODIFY classKEYS ASSIGNMENTS        =% Set "colorKEYS= R G B "
  %= key literal strings are used in            =% Set "adjustKEYS= + - "
  %= control flow + variable assignments        =% Set "stateKEYS= D spaceBar M H "
  %= prevent action on Substitution Poison Key  =% For %%K in (!colorKeys!!adjustKeys!!stateKeys!) do set "Key%%K=1" 
  rem SPK is: '='
 
  Set "$D[1]=38"
  Set "$D[2]=48"
  Set "Mute[1]=[M]ute"
  Set "Mute[2]=un[M]ute"
  Set "Hide[1]=[H]ide border"
  Set "Hide[2]=un[H]ide border"
  Set "$Domain[1]=Foreground"
  Set "$Domain[2]=Background"
  For %%G in (R G B) do (
    set "$%%G[1=["
    set "$%%G]1=]"
    set "$[]%%G=0"
  )
  Set /A "$[]R=1","$M=1","$H=1","$D=1","$R[1]=145","$G[1]=30","$B[1]=180","$R[2]=12","$G[2]=20","$B[2]=20","$spaceBar=1"
  Set "$C=R"


  More < "%~f0:Config:$Data" 2> nul 1> nul && (
    For /f "UseBackQ Delims=" %%V in ("%~f0:Config:$Data")Do Set "%%V"
  )

  REM clamp macro Authored by IcarusLives and Aacini
  REM clamp Usage: || Set /a "x=VarToClamp, low=minValue, high=maxValue, VarToClamp=%clamp%"
  REM used to bound player and map and apply configuration defaults
  REM Set "clamp= (leq=((low-(x))>>31)+1)*low  +  (geq=(((x)-high)>>31)+1)*high  +  ^^^!(leq+geq)*(x) "

  Set "clamp255=$%%C[%%D]=(leq=((0-($%%C[%%D]))>>31)+1)*0  +  (geq=((($%%C[%%D])-255)>>31)+1)*255  +  ^^^!(leq+geq)*($%%C[%%D])"

:Clock
  Set "Footer=%\E%[!$lines!;1H%\E%[48;2;^!rr3^!;^!gg3^!;^!bb3^!m%\E%[K%\E%[A%\E%[48;2;^!rr2^!;^!gg2^!;^!bb2^!m%\E%[K"
  Set "Header=%\E%[H%\E%[48;2;^!rr3^!;^!gg3^!;^!bb3^!m%\E%[K%\E%[E%\E%[48;2;^!rr2^!;^!gg2^!;^!bb2^!m%\E%[K%\E%[3;1H"

  for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do (
    Set /a "now=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100","next=now+_step_CS","nextb=now+_step_CSb"
    If !now! lss 0 Set /a "now+=24*60*60*100","next=now+_step_CS","nextb=now+_step_CSb"
    Set "second=%%c"
    Set "minute=%%b"
    Set "hour=%%a"
  )

(
  rem prepare header respecting past state
  Set header=%header%
  Set footer=%footer%
  If "!$H!" == "2" (
    Set "header=%\E%[H%\E%[48;2;!$R[2]!;!$G[2]!;!$B[2]!m%\E%[0J"
    Set "footer="
  )

  For /l %%~ in (~)Do (%= infinite loop =%
    For /f "tokens=1,2,3,4,5,6 delims= " %%Q in ("!$D! !$[]R! !$[]G! !$[]B! !$M! !$H!")Do (Title Close:TAB [D]=!$Domain[%%Q]! !$R[%%R!R!$R]%%R!=!$R[%%Q]! !$G[%%S!G!$G]%%S!=!$G[%%Q]! !$B[%%T!B!$B]%%T!=!$B[%%Q]! +/- !mute[%%U]! !hide[%%V]!)
    Set "nKey="
    Set /P "nKey="
    If not "!nKey!"=="" (
      For /f "tokens=1,2,3 Delims=`" %%C in ("!$C!`!$D!`!nKey: =spaceBar!`")Do If defined key%%E (
        If not "!colorKEYS: %%E =!" == "!colorKEYS!"   Set "$C=%%E" & Set /a "$[]R=0,$[]G=0,$[]B=0,$[]%%E=1"
        If not "!adjustKEYS: %%E =!" == "!adjustKEYS!" Set /A "$%%C[%%D]%%E=1","%CLAMP255%"
        If not "!stateKEYS: %%E =!" == "!stateKEYS!"   Set /A "$%%E=$%%E %% 2 + 1"
      )
      If /I "!nKey:~-4!" == "quit" (
        %= save config state on exit =% Set $ >"%~f0:Config:$data"
        Call:Cleanup
      )
    )
    %= parse time =%
    for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!")Do (
      %sound_check% if !$m! leq 1 ( 
        If not "%%c" == "!second!" If "%%b" == "!minute!" (
          %sound.second%
          set "second=%%c"
        )
        If not "%%b" == "!minute!" If "%%a" == "!hour!" (
          %sound.minute%
          set "minute=%%b"
        )
        If not "%%a" == "!hour!" (
          %sound.hour%
          set "hour=%%a"
        )
      )
      Set /a "now=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100"
      If !now! lss 0 Set /a now+=24*60*60*100
      If !now! gtr !next! (%= every at best _step_CS =%
        %phase.hue%,"next+=_step_CS"
        Set header=%header%
        Set footer=%footer%
        If "!$H!" == "2" (
          Set "header=%\E%[H%\E%[48;2;!$R[2]!;!$G[2]!;!$B[2]!m%\E%[0J"
          Set "footer="
        )
      )
      If 1!now! gtr !$spaceBar!!nextb! (%= every at best _step_CSb =%
        Set /a "nextb+=_step_CSb","_step=_step %% !_StepMax! + 1"
      )
      %= assign to variable to tokenize per character. cheaper to substring outside loop =%
      Set "t=%%a%%b%%c%%d"

      %= tokenised character expands $color[tokenIndex] replacing # with token value =%
      %= RESERVED token allows semicolon to be used to reference HH MM SS CS seperator =%
      REM for metavariables adhere to ascii value order ... ,.-/0123456789:; ...
      Set "t=!t:~0,1! !t:~1,1! !t:~2,1! !t:~3,1! !t:~4,1! !t:~5,1! !t:~6,1! !t:~7,1! RESERVED !_step!"
      For /f "tokens=1-10" %%1 in ("!t!")Do (
        Echo(%\E%[48;2;!$R[2]!;!$G[2]!;!$B[2]!m%\E%[38;2;!$R[1]!;!$G[1]!;!$B[1]!m!Header!%\E%[48;2;!$R[2]!;!$G[2]!;!$B[2]!m%\E%[0J%\E%[8;13H![%%1]:#=%%1!![%%2]:#=%%2!%\E%[38;2;!rr!;!gg!;!bb!m!_%%:!%\E%[38;2;!$R[1]!;!$G[1]!;!$B[1]!m![%%3]:#=%%3!![%%4]:#=%%4!%\E%[38;2;!rr!;!gg!;!bb!m!_%%:!%\E%[38;2;!$R[1]!;!$G[1]!;!$B[1]!m![%%5]:#=%%5!![%%6]:#=%%6!%\E%[38;2;!rr!;!gg!;!bb!m!_%%:!%\E%[38;2;!$R[1]!;!$G[1]!;!$B[1]!m![%%7]:#=%%7!![%%8]:#=%%8!%\E%[5E!Footer!%\E%[0m
  ) ) )
)
EXIT

==========================================================================================================
REM no changes should be made to the below utilities
==========================================================================================================
:Setup

REM VT sequence info: https://learn.microsoft.com/en-us/windows/console/console-virtual-terminal-sequences
  for /f "Delims=" %%e in ('Echo Prompt $E^|%comspec%') Do Set "\E=%%e"

  Setlocal DisableDelayedExpansion
  CD /d "%~dp0"

REM Good practice when utilizing other shells / non-batch windows command execution
REM notify user of this scripts supplementary supports and
REM require positive affirmation before continuing.

  2> nul 1> nul ( More < "%~f0:Consent:$Data" ) && (
    goto:accepted
  ) || (
     Echo(%\E%[H%\E%[2J%\E%[0;33m
     Echo(This script uses the following tools to augment Batch's capabilities.
     Echo(%\E%[36m Powershell      %\E%[0m-%\E%[33m Set Font name and size
     Echo(%\E%[0m                 -%\E%[33m Maintain constant console dimensions while running
     Echo(%\E%[0m                   *%\E%[33m not used if run via windows terminal
     Echo(%\E%[36m VbScript        %\E%[0m-%\E%[33m Play windows .wav files for soundFX
     Echo(%\E%[36m NTFS ADS        %\E%[0m-%\E%[33m Save / Load user settings, Persist user options
     Echo(%\E%[0m                   Remove ADS files using cmd commandline:
     Echo(%\E%[38;5;150m powershell -c "remove-item -path '%~nx0' -Stream '*'"
     Echo(%\E%[0;36m Temporary Files %\E%[0m-%\E%[33m Inter-process communication
     Echo(%\E%[0m                   Remove temp files using cmd commandline: 
     Echo(%\E%[38;5;150m call "%~f0" delTemp
     Echo( 
     Echo(%\E%[0m If accepted, this notice will not be displayed again.
     Echo( %\E%7[%\E%[5m%\E%[32mA%\E%[0m]ccept [%\E%[5;31mE%\E%[0m]xit
     For /f "delims=" %%K in ('%systemroot%\system32\choice.exe /n /c:AE') Do (
       If /i "%%K" == "A" (
         set userprofile >"%~f0:Consent:$Data"
         CLS
       ) else (
         Echo(
         <Nul Set /P "=%\E%8%\E%[K%\E%[0;5mExiting..."
         1> nul Timeout /t 2 /NoBreak
         <Nul Set /P "=%\E%[1G%\E%[0m%\E%[K"
         exit /b 0
       )
     )
  )

:accepted
  <Nul Set /P "=%\E%[1;1H%\E%[2J%\E%[?25l%\E%[0;5m..."
 
  2> nul 1> nul ( More < "%~f0:exports:$Data" ) && (
    For /f "UseBackQ Delims=" %%V in ("%~f0:exports:$Data")Do Set "%%V"
  ) || (
    Set "exports=true"
    For /f "tokens=1,* Delims=:" %%N in ('%SystemRoot%\system32\findstr.exe /BRIC:":exports:" "%~f0"') Do For %%E in (%%O) Do (
      If not Exist "%~dp0%%~E" (
        1>"%~dp0%%~E" (
          2>&1 > con Echo(Exporting: %%~E
          For /f "tokens=1,2,* delims=:" %%G in ('%SystemRoot%\system32\findstr.exe /BRIC:":export:%%~E" "%~f0"') do (
            Set "Line=%%I"
            Setlocal EnableDelayedExpansion
            Echo(!Line!
            Endlocal
          )
        )
        If not Exist "%~dp0%%~E" Set "exports="
      )
    )
    if defined exports Set exports >"%~f0:Exports:$Data"
  )
  Endlocal & set "exports=%exports%"

  For /f "delims=" %%G in ('%systemroot%\system32\where.exe PowerShell.exe')Do if /i not "%%~dpG" == "%userprofile%\" if not defined powershell Set powershell="%%~G"


rem Validate exports. If exports failed or removed, and user rejects recovery, disable sound system. 
  if /i "%exports%" == "true" For /f "tokens=1,* Delims=:" %%N in ('%SystemRoot%\system32\findstr.exe /BRIC:":exports:" "%~f0"') Do For %%E in (%%O) Do (
    If not exist "%~dp0%%~E" (
      echo(%\E%[31m%\E%[EAsset "%%~nxE" missing. Attempt Recovery Y/N%\E%[0m
      Set "exports=false"
      For /f "Delims=" %%K in ('%systemRoot%\system32\Choice.exe /n /c:YN') do If "%%K" == "Y" (
        %powershell% -c "remove-item -path '%~f0' -Stream 'Exports'
        goto:setup
      )
    )
  )

  if /i "%exports%" == "true" (set "sound_check=if 1==1 ") else set "sound_check=if 1==0 "
 
  %sound_check% ( Set sound.i=0
    For /f "tokens=1,2,3,* Delims=:" %%M in ('%SystemRoot%\system32\findstr.exe /BRIC:":soundConfig:" "%~f0"') Do (
      if exist "%systemDrive%\%%~P" (
        Set sound.%%~N=CALL "%~dp0playMusic" "%systemDrive%\%%~P" %%~O false
  ) ) )


  REM Define essential vars for multithreaded controller
  REM Signal file that the Controller uses to pass keypress to the game via without blocking execution.
  REM - Note - This is modified later to a Lockfile in format: %TEMP%\%~n0_%PID%_Signal.cmd
  Set "SignalFile=%TEMP%\%~n0__Signal.cmd"

  REM Control Key Definitions
  Call :createChars
  REM QuitKey must be defined prior to starting Multithreaded controller. TAB is recommended
  Set "QUITKEY=%TAB%"

  Set id=%~n0%random%
  (Title %id%)

:GetSession

  Break >"%~dp0cmd.Run" || Goto:GetSession
  cd /d "%~dp0"

  REM get session ID to prevent File Read / write error if multiple instances running
  For /F "Skip=2 tokens=2" %%G in ('Tasklist /fi "windowtitle eq %id%"')Do Set "Lock=%%G"
  CALL Set "SignalFile=%%SignalFile:__=_%Lock%_%%"
  Del /f /q "%~n0*.ps1" 2> nul 1> nul

  For /F "tokens=2 Delims=:" %%G in ('CHCP')Do >"%TEMP%\%~n0_%Lock%_restore.cmd" Echo(@CHCP %%G ^> nul
  Del "%SignalFile:Signal=Abort%" 2> nul

:clonefile
  Copy "%~f0" "%~dp0%id%.ps1" 1> nul 2> nul
  if not exist "%~dp0%id%.ps1" goto:clonefile

  CHCP 65001 > nul

  %sound_check% Call "%~dp0SessionMonitor.bat" start

  Set /a $lines=19,$columns=70

  Mode %$columns%,%$lines%

  If defined WT_SESSION Start /Wait /B "" "%~F0" XCOPYCONTROLLER 1>"%SignalFile%" 2> nul | "%~F0" %Script% <"%SignalFile%" 2> nul
  If not defined WT_SESSION Start /Wait /B "" "%~F0" XCOPYCONTROLLER 1>"%SignalFile%" 2> nul | 1>"%SignalFile:signal=mtPS%" 2>"%SignalFile:signal=mtPS_debug%" powershell.exe -noprofile -ExecutionPolicy Bypass -file "%~dp0%id%.ps1" %$Lines% %$Columns% | "%~F0" %Script% <"%SignalFile%" 2> nul


  REM Processes have resolved; end script. cleanup this processes lock file.
  Del "%SignalFile%"
  Del /f /q "%~dp0%~n0*.ps1" 2> nul 1> nul

Endlocal & Goto:Eof



:XCOPYCONTROLLER
	If not exist "%systemroot%\System32\Xcopy.exe" (
		>"%SignalFile:Signal=Abort%" Echo(Xcopy not found
		<nul Set /P "=quit"
		EXIT
	)
	Setlocal DISABLEdelayedExpansion
	REM Environment handling allows use of ! key
	For /l %%C in () do (

		Set "Key="
		for /f "delims=" %%A in ('%systemroot%\System32\xcopy.exe /w "%~f0" "%~f0" 2^>nul') do If not Defined Key (
	      	set "key=%%A"
			Setlocal ENABLEdelayedExpansion
	      	set key=^!KEY:~-1!
		        If not Exist "%~dp0cmd.Run" (
				Set "key=!QUITKEY!"
			)
			If "!key!" == "!QUITKEY!" (
				<nul Set /P "=quit"
				EXIT
			)
			If not "!Key!" == "%BS%" If not "!Key!" == "!CR!" (%= Echo without Linefeed. Allows output of equals Key and Space =%
				1> %~n0txt.tmp (echo(!key!!sub!)
				copy %~n0txt.tmp /a %~n0txt2.tmp /b > nul
				type %~n0txt2.tmp
				del %~n0txt.tmp %~n0txt2.tmp
			)Else (
				If "!Key!" == "%BS%" <nul Set /p "={BACKSPACE}"
				If "!Key!" == "!CR!" <nul Set /p "={ENTER}"
			)
			Endlocal
		)
	)

%= CALLED FUNCTIONS =%

:createChars
	for /f "delims= " %%T in ('robocopy /L . . /njh /njs' )do set "TAB=%%T"
	for /f %%C in ('copy /Z "%~dpf0" nul') do set "CR=%%C"
	for /F "delims=#" %%B in ('"prompt #$H# &echo on &for %%b in (1) do rem"') do Set "BS=%%B"
	Set "BS=%BS:~0,1%"
	copy nul sub.tmp /a > nul
	for /F %%a in (sub.tmp) DO (
		set "sub=%%a"
	)
	del sub.tmp
	(Set LF=^


	)%= Do Not Modify. Linefeed Variable =%
exit /b


:Cleanup
1> nul 2> nul (
	<Nul Set /P "=%\E%[1;1H%\E%[2J%\E%[?25h%\E%[0;5m..." 1> con
	<"%SignalFile:Signal=Abort%" Set /P "XcopyError="
	If Defined XcopyError Echo(!XcopyError!
	CALL "%TEMP%\%~n0_%Lock%_restore.cmd"
        Del "%~dp0cmd.run"
        %sound_check% Call "%~dp0stopMusic.bat"
	Del "%TEMP%\%~n0_%lock%*.cmd"
        <Nul Set /P "=%\E%[1;1H%\E%[2J%\E%[0m" 1> con
        (title )
)
EXIT

:delTemp
	REM this file creates signal files to identify the session and communicate input.
	REM If the game is force closed instead of Quit with TAB key
	REM the files will persist. To remove them, Call this file from the command line with The argument: deltemp
	Del "%TEMP%\%~n0_*_*.cmd"
        Del "%~dpn0*.ps1"
Goto:Eof

:Set_Font FontName FontSize max/nomax dummy
rem set_font by Einst. modified for use with multiProcess dispatcher
Set "m="
for /f "delims=0123456789" %%V in ("%~2") do EXIT
If /i "%~3" == "max" set "m=/max" 
if "%4"=="" (
	for /f "tokens=1,2 delims=x" %%a in ("%~2") do if "%%b"=="" (set /a "FontSize=%~2*65536") else set /a "FontSize=%%a+%%b*65536"
        Setlocal EnableDelayedExpansion
	reg add "HKCU\Console\%~nx0" /v FontSize /t reg_dword /d !FontSize! /f >nul
	reg add "HKCU\Console\%~nx0" /v FaceName /t reg_sz /d "%~1" /f >nul
        Endlocal
	start "%~nx0" %m% "%ComSpec%" /c "%~f0" _
	exit /b 1
) else ( >nul reg delete "HKCU\Console\%~nx0" /f )
goto:eof

:setFont <integerSize> <stringFontName>
REM setfont + init_setfont are from the StdLibrary created by IcarusLives
REM https://github.com/IcarusLivesHF/Windows-Batch-Library/tree/8812670566744d2ee14a9a68a06be333a27488cc
if "%~2" equ "" goto :eof
call :init_setfont
If not errorlevel 1 Set "SetFont.init=1"
If defined SetFont.init %setFont% %~1 %~2
goto :eof

:init_setfont DON'T CALL
:: - BRIEF -
::  Get or set the console font size and font name.
:: - SYNTAX -
::  %setfont% [fontSize [fontName]]
::    fontSize   Size of the font. (Can be 0 to preserve the size.)
::    fontName   Name of the font. (Can be omitted to preserve the name.)
:: - EXAMPLES -
::  Output the current console font size and font name:
::    %setfont%
::  Set the console font size to 14 and the font name to Lucida Console:
::    %setfont% 14 Lucida Console
setlocal DisableDelayedExpansion
set setfont=for /l %%# in (1 1 2) do if %%#==2 (^
%=% for /f "tokens=1,2*" %%- in ("? ^^!arg^^!") do endlocal^&powershell.exe -nop -ep Bypass -c ^"Add-Type '^
%===% using System;^
%===% using System.Runtime.InteropServices;^
%===% [StructLayout(LayoutKind.Sequential,CharSet=CharSet.Unicode)] public struct FontInfo{^
%=====% public int objSize;^
%=====% public int nFont;^
%=====% public short fontSizeX;^
%=====% public short fontSizeY;^
%=====% public int fontFamily;^
%=====% public int fontWeight;^
%=====% [MarshalAs(UnmanagedType.ByValTStr,SizeConst=32)] public string faceName;}^
%===% public class WApi{^
%=====% [DllImport(\"kernel32.dll\")] public static extern IntPtr CreateFile(string name,int acc,int share,IntPtr sec,int how,int flags,IntPtr tmplt);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void GetCurrentConsoleFontEx(IntPtr hOut,int maxWnd,ref FontInfo info);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void SetCurrentConsoleFontEx(IntPtr hOut,int maxWnd,ref FontInfo info);^
%=====% [DllImport(\"kernel32.dll\")] public static extern void CloseHandle(IntPtr handle);}';^
%=% $hOut=[WApi]::CreateFile('CONOUT$',-1073741824,2,[IntPtr]::Zero,3,0,[IntPtr]::Zero);^
%=% $fInf=New-Object FontInfo;^
%=% $fInf.objSize=84;^
%=% [WApi]::GetCurrentConsoleFontEx($hOut,0,[ref]$fInf);^
%=% If('%%~.'){^
%===% $fInf.nFont=0; $fInf.fontSizeX=0; $fInf.fontFamily=0; $fInf.fontWeight=0;^
%===% If([Int16]'%%~.' -gt 0){$fInf.fontSizeY=[Int16]'%%~.'}^
%===% If('%%~/'){$fInf.faceName='%%~/'}^
%===% [WApi]::SetCurrentConsoleFontEx($hOut,0,[ref]$fInf);}^
%=% Else{(''+$fInf.fontSizeY+' '+$fInf.faceName)}^
%=% [WApi]::CloseHandle($hOut);^") else setlocal EnableDelayedExpansion^&set arg=
endlocal &set "setfont=%setfont%"
if !!# neq # set "setfont=%setfont:^^!=!%"
exit /b


%= CONFIG AND DATA =%

REM :soundConfig:suffix:Volume:"path/to/filename.wav"
REM returned as a macro expanded as %sound.suffix% that invokes playMusic.bat with args: "filepath" volume false
REM where false is a flag for 'no loop' 
:soundConfig:second:10:"Windows\WinSxS\amd64_userexperience-sxs_31bf3856ad364e35_10.0.26100.8737_none_41b2506c7299798e\61869836.InpApp\InputApp\Assets\KbdSwipeGesture.wav"
:soundConfig:minute:90:"Windows\Media\Windows Balloon.wav"
:soundConfig:hour:60:"Windows\Media\Windows Information Bar.wav"

:exports: "stopMusic.bat" "playMusic.bat" "SessionMonitor.bat"

:export:stopMusic.bat: @echo off
:export:stopMusic.bat: PUSHD "%~dp0"
:export:stopMusic.bat: (For /F "Delims=" %%G in ('Dir *.vbs /B')Do If /I not "%%~nxG" == "monitor.vbs" (Del %%G)) 2> nul
:export:stopMusic.bat: taskkill /pid WScript.exe /f /t >nul 2>nul
:export:stopMusic.bat: If /I not "%~1" == "running" (
:export:stopMusic.bat:   (For /F "Delims=" %%G in ('Dir *.vbs /B /S')Do (Del %%G)) 2> nul
:export:stopMusic.bat: )Else (For /F "Delims=" %%G in ('Dir %~dp0Play_*.vbs /B /S')Do (Del %%G)) 2> nul
:export:stopMusic.bat: POPD
:export:stopMusic.bat: exit /b 0

:export:playMusic.bat: @echo off
:export:playMusic.bat: If "%~1" == "" (
:export:playMusic.bat:  Echo Play Music Usage:
:export:playMusic.bat:  Echo/Parameters required For Player: "filepath.ext" 0-100 1^|0
:export:playMusic.bat:  Echo/Arg 3: 1^|0 flags loop true / false respectively
:export:playMusic.bat:  pause
:export:playMusic.bat:  Exit /B
:export:playMusic.bat: )
:export:playMusic.bat: If Not exist "%~1" (
:export:playMusic.bat:  Cls
:export:playMusic.bat:  Echo/Track "%~1" Not found
:export:playMusic.bat:  Pause
:export:playMusic.bat:  Exit
:export:playMusic.bat: )
:export:playMusic.bat: Set "MusicPath=%~1"
:export:playMusic.bat: For %%T in ("%~1")Do Set "trackname=%~n1"
:export:playMusic.bat: Set /A vol=Loop_TF=0
:export:playMusic.bat: Set /A "vol+=%~2 + 0" 2> nul
:export:playMusic.bat: Set /A "Loop_TF=%~3 + 0" 2> nul
:export:playMusic.bat: Setlocal EnableDelayedExpansion
:export:playMusic.bat: IF Not !Vol! GTR 0 (  Cls & Echo/Invalid "%~2" - Integer GTR 0 LEQ 100 required for arg %%2 ; Volume & Pause & Exit)
:export:playMusic.bat: IF Not !Vol! LEQ 100 (Cls & Echo/Invalid "%~2" - Integer GTR 0 LEQ 100 required for arg %%2 ; Volume & Pause & Exit)
:export:playMusic.bat: IF !Loop_TF! GTR 1 (Cls & Echo/Invalid "%~3" - Integer 0 or 1 required for arg %%3 ; Loop True / False & Pause & Exit)
:export:playMusic.bat: Endlocal
:export:playMusic.bat: PUSHD "%~dp0" 
:export:playMusic.bat: If not exist "Play_%trackname%.vbs" (
:export:playMusic.bat:  >"Play_%trackname%.vbs" (
:export:playMusic.bat:   echo Set Sound = CreateObject^("WMPlayer.OCX.7"^)
:export:playMusic.bat:   echo Sound.URL = "%MusicPath%"
:export:playMusic.bat:   echo Sound.settings.volume = %vol%
:export:playMusic.bat:   echo Sound.settings.setMode "loop", %Loop_TF%
:export:playMusic.bat:   echo Sound.Controls.play
:export:playMusic.bat:   echo While Sound.playState ^<^> 1
:export:playMusic.bat:   echo WScript.Sleep 100
:export:playMusic.bat:   echo Wend
:export:playMusic.bat:  )
:export:playMusic.bat: )
:export:playMusic.bat: start /min "" "Play_%trackname%.vbs"
:export:playMusic.bat: POPD
:export:playMusic.bat:Exit /b 0

:export:sessionMonitor.bat: @echo off
:export:SessionMonitor.bat: If /I not "%~1" == "start" (
:export:SessionMonitor.bat:  Echo/VBS monitoring of Cmd.exe process to call stopmusic on close is not required at this time.
:export:SessionMonitor.bat:  Pause
:export:SessionMonitor.bat:  Exit /B
:export:SessionMonitor.bat: )
:export:SessionMonitor.bat: (
:export:SessionMonitor.bat:  ECHO Set objWMIService = GetObject ("winmgmts:"^)
:export:SessionMonitor.bat:  ECHO Set proc = objWMIService.ExecQuery("select * from Win32_Process Where Name='cmd.exe'"^)
:export:SessionMonitor.bat:  ECHO DO while proc.count ^> 0
:export:SessionMonitor.bat:  ECHO Set proc = objWMIService.ExecQuery("select * from Win32_Process Where Name='cmd.exe'"^)
:export:SessionMonitor.bat:  ECHO if proc.count ^< 1 then exit do
:export:SessionMonitor.bat:  ECHO wscript.sleep 500 'time delay between process checks. Increase this number to decrease cpu usage.
:export:SessionMonitor.bat:  ECHO loop
:export:SessionMonitor.bat:  ECHO Set WshShell=createobject("wscript.shell"^)
:export:SessionMonitor.bat:  ECHO WshShell.run "%~dp0StopMusic.bat", 0, true
:export:SessionMonitor.bat: )>"%~dp0Monitor.vbs"
:export:SessionMonitor.bat: Start /Min "" "%~dp0Monitor.vbs"
:export:SessionMonitor.bat: Exit /b 0


:# The below line Marks the end of a Powershell comment Block; And the End of the Batch Script. Do not Modify.
:# Demoscript. This utility reverts the console window to startup arg Dimensions if changed. exludes fullscreen
: end batch / begin powershell #>

$Lines = $Args[0]; $Columns = $Args[1]

While (test-path $PSScriptRoot\cmd.Run){
  $Height = (Get-Host).UI.RawUI.MaxWindowSize.Height; $Width = (Get-Host).UI.RawUI.MaxWindowSize.Width
  If ("$Height" -ne "$Lines" -or "$Width" -ne "$Columns"){
    $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.size($Columns,$Lines); $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($Columns,$Lines)
  }
  Start-Sleep -Millisecond 100
}
return 0
