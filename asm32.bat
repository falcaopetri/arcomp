@echo off
rem 
rem  This is a MS-Windows batch file for assembling and linking assembly language 
rem  source files. It is designed to be used with the book entitled: Assembly 
rem  Language for x86 Processors, 7th edition, by Kip R. Irvine. The 
rem  configuration used here assumes that you are using Microsoft MASM and
rem Visual Studio 2013 (or Visual Studio 2013 Express).  This batch file runs
rem  under Windows XP, Windows 7 (32-bit), and Windows Vista. 
rem                                                                    
rem  Copy this file to a location on your system path.                 
rem                                                                    
rem  Customization: 
rem  -----------------------------------------------------------------
rem  If Visual Studio is installed in some other directory than 
rem  C:\Program Files\Microsoft Visual Studio 12.0, you must modify the 
rem  SET VSHOME statement  (on or near line 130).
rem                                                                    
rem  Syntax for running this file:                                     
rem  ------------------------------------------------------------------
rem     asm32                 -  display help                             
rem     asm32 [/H|/h|-H|-h]   -  display help                             
rem     asm32 filelist        -  assemble and link                        
rem     asm32 /D filelist     -  assemble, link, and debug                
rem     asm32 /C filelist     -  assemble only                            
rem                                                                    
rem  A filelist is a list of up to 5 filenames, separated by spaces.   
rem  The filenames must not have extensions, because .asm is assumed.
rem  The first filename determines the name of the exe file produced 
rem  by the linker.
rem   
rem  Examples:
rem  -----------------------------------------------------------------
rem  Display help information (5 ways to do this):
rem     asm32
rem     asm32 /H
rem     asm32 /h
rem     asm32 -H
rem     asm32 -h
rem
rem  Assemble and link myprog.asm, producing myprog.obj and myprog.exe:
rem     asm32 myprog
rem 
rem  Assemble main.asm, producing main.obj:
rem     asm32 /C main
rem
rem  Assemble main.asm, print.asm, and sum.asm. Then link all three,
rem  producing main.exe:
rem     asm32 main print sum
rem
rem  Assemble main.asm, print.asm, and sum.asm. Then link all three,
rem  producing main.exe. Then start main.exe in the debugger:
rem     asm32 /D main print sum
rem
rem  Credits:
rem  -------------------------------------------------------------------
rem  This batch file was the result of a collaboration between the     
rem  following individuals:                                            
rem  (1) Kip Irvine, http://asmirvine.com, mailto:kip@asmirvine.com                                           
rem  (2) John I. Moore, Jr., Department of Mathematics and Computer    
rem     Science, The Citadel, http://mathcs.citadel.edu                   
rem  (3) Gerald Cahill, Antelope Valley College                        
rem  (4) James Brink, Pacific Lutheran University                      
rem                                                                    
rem  Update History: 
rem  -------------------------------------------------------------------
rem   02/23/07:  created by Kip Irvine and John Moore                    
rem   02/23/07:  revised to display help if no arguments are given       
rem   02/24/07:  debugging /D switch enabled                             
rem   02/25/07:  linking /L switch removed, /C switch added              
rem   02/25/07:  permits up to 5 source files to be assembled            
rem   02/28/07:  when setting INCLUDE, LIB, and PATH commands, existing  
rem            		     values values are appended to our settings. Additional   
rem                       command line switches added for displaying help.        
rem   03/04/07:  Created a loop to permit the linker to link multiple 
rem                       obj files. Examples added to remarks section.
rem   11/21/2012: Revised for Visual Studio 2012
rem   4/24/2014: Revised for Visual Studio 2013
rem  --------------------------------------------------------------------

rem -------------------- BEGIN ACTIVE COMMANDS -----------------------
 
rem The SETLOCAL command makes all subsequent settings of environment 
rem settings local to this batch file. The settings will disappear when 
rem the batch file reaches the ENDLOCAL command.
SETLOCAL

rem Check for the /H (help) command
 
if "%1"=="" goto HELP
if %1==/H goto HELP
if %1==/h goto HELP
if %1==-H goto HELP
if %1==-h goto HELP

rem -----------------------------------------------------------------
rem             CHECK COMMAND-LINE SWITCHES
rem -----------------------------------------------------------------
rem  If the first argument is /C, disable LINKING and shift the 
rem  remaining arguments backward one position.
rem -----------------------------------------------------------------

set LINKING=yes
if %1 NEQ /C goto CHECK_DEBUG_SWITCH
shift
set LINKING=no

:CHECK_DEBUG_SWITCH
rem -----------------------------------------------------------------
rem  If the first argument is /D, enable the DEBUG option 
rem  and shift the remaining arguments backward one position.
rem -----------------------------------------------------------------

set DEBUG=no
if %1 NEQ /D goto DELETE_FILES
shift
set DEBUG=yes

:DELETE_FILES
rem ----------------------------------
rem Delete the old object file
rem ----------------------------------
if exist %1.obj del %1.obj

rem -----------------------------------------------------------------
rem             PREPARE THE ENVIRONMENT VARIABLES
rem 
rem  Set the VS_HOME environment variable to the location of Visual 
rem  Studio 2013 (or Visual C++ 2013 Express)
rem -----------------------------------------------------------------
rem set VS_HOME=C:\Program Files\Microsoft Visual Studio 12.0

rem -----------------------------------------------------------------
rem Add Visual Studio to the system path.
rem -----------------------------------------------------------------
rem set PATH=%VS_HOME%\VC\bin;%VS_HOME%\Common7\IDE;%PATH%

rem -----------------------------------------------------------------
rem  Set the INCLUDE environment variable to the location of the 
rem  MASM include files used by Irvine's book.
rem -----------------------------------------------------------------
set INCLUDE=C:\Irvine;%INCLUDE%

rem -----------------------------------------------------------------
rem  Set the LIB environment variable to the location of the 
rem  Link libraries used by Irvine's book.
rem -----------------------------------------------------------------
rem set LIB=%VS_HOME%\VC\LIB;C:\Irvine;%LIB%
set LIB=C:\Irvine;%LIB%
set PATH=C:\Irvine;%PATH%

rem -----------------------------------------------------------------
rem                   EXECUTE THE ASSEMBLER
rem Parameters:
rem  -nologo           suppress the Microsoft logo
rem  -c                assemble only
rem  -Zi               generate debugging information
rem  %%F               source filename, held in loop variable
rem -----------------------------------------------------------------

rem for %%F in (%1 %2 %3 %4 %5) do ml -nologo -c -Zi -Fl %%F.asm
for %%F in (%1 %2 %3 %4 %5) do ml /nologo /c /coff /Zi /Zd /W3 /FR /Fm /Fl %%F.asm

if errorlevel 1 goto QUIT
rem (the preceding IF statement only affects the last source file to be assembled)


rem ---------------------------------
rem Find out if linking is disabled
rem ---------------------------------
if %LINKING%==no goto QUIT

rem -----------------------------------------------------------------------------------------
rem                   EXECUTE THE LINKER
rem Parameters:
rem   /NOLOGO                                   (suppress the Microsoft logo display)
rem   /DEBUG                                       (include debugging information)
rem   /SUBSYSTEM:CONSOLE         (generate a Windows Console-aware application)
rem   irvine32.lib, kernel32.lib, user32.lib    (link libraries)
rem   %1                                                (EXE filename produced by the linker)
rem ------------------------------------------------------------------------------------------

echo.
echo Linking Assembler output files to the Irvine32, Kernel32, and User32 libraries.

rem SET LINKCMD=link /NOLOGO /DEBUG /SUBSYSTEM:CONSOLE irvine32.lib kernel32.lib user32.lib
SET LINKCMD=link /NOLOGO /SUBSYSTEM:CONSOLE /DEBUG /PDB:%1.pdb /DEBUGTYPE:CV irvine32.lib kernel32.lib user32.lib
SET FILELIST=%1.obj
SET EXENAME=%1.exe

:LINKLOOP
if !%2==! goto ENDLINKLOOP
SET FILELIST=%FILELIST% %2.obj
shift
goto LINKLOOP

:ENDLINKLOOP

rem -------------------------------------------------------------------
rem Execute the linker, using the command line and list of input files.
rem -------------------------------------------------------------------
%LINKCMD% %FILELIST%

if errorlevel 1 goto QUIT

echo.
echo Linker successful. The executable file %EXENAME% was produced.
echo ..................................
echo.

rem Find out if debugging was disabled

if %DEBUG%==no goto QUIT

rem -----------------------------------------------------------------
rem              LAUNCH THE VISUAL STUDIO DEBUGGER
rem -----------------------------------------------------------------

rem echo Launching the Visual Studio debugger...
echo Launching the Windbg debugger...

rem devenv %1.exe /debugexe
rem THE FIRST LINE OF ASM SOURCE FILE HAS BE INT3 
..\windbg -QY -g -G -y "C:\Irvine\;c:\windows\system32\;SRV*C:\symbols*http://msdl.microsoft.com/download/symbols" -WF "C:\Irvine\wkp.wew" -srcpath "C:\Irvine\arcomp\" %1.exe

goto QUIT


rem -----------------------------------------------------------------
rem                    SHOW HELP INFORMATION
rem -----------------------------------------------------------------
:HELP
cls
echo This file assembles, links, and debugs a single assembly language 
echo source file. Before using it, install Visual Studio 2013 in the following 
echo directory: C:\Program Files\Microsoft Visual Studio 12.0
echo.
echo Next, install the Irvine 6th edition link libraires and include files 
echo in the following directory: C:\Irvine
echo.
echo Finally, copy this batch file to a location on your system path. We recommend 
echo the following directory: C:\Program Files\Microsoft Visual Studio 12.0\VC\bin
echo.
echo Command-line syntax:
echo.
echo    asm32 [/H ^| /h ^| -H ^| -h]  -- display this help information
echo    asm32 filelist             -- assemble and link all files
echo    asm32 /D filelist          -- assemble, link, and debug
echo    asm32 /C filelist          -- assemble only
echo.
echo ^<filelist^> is a list of up to 5 filenames (without extensions), 
echo separated by spaces. The filenames are assumed to refer to files
echo having .asm extensions. Command-line switches are case-sensitive.

rem -----------------------------------------------------------------
rem                   BATCH FILE EXIT POINT
rem -----------------------------------------------------------------
:QUIT

rem ENDLOCAL clears all local environment variable settings.

ENDLOCAL
