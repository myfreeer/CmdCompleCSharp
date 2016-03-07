@echo off
setlocal EnableExtensions EnableDelayedExpansion
color 1f
:--------------------------------------------------------------------------
REG QUERY "HKU\S-1-5-19" >nul 2>&1
if %errorlevel% NEQ 0 goto :UACPrompt
goto :gotAdmin
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~fs0 %*", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
del "%temp%\getadmin.vbs"
exit /b
:gotAdmin
pushd "%~dp0"
:--------------------------------------------------------------------------
title CMD Compile C# Release 1.0
:CheckRuntime
if exist %windir%\Microsoft.NET\Framework64 (set "_p=%windir%\Microsoft.NET\Framework64") else if exist %windir%\Microsoft.NET\Framework (set "_p=%windir%\Microsoft.NET\Framework") else goto :RuntimeNotFound
for /f %%a in ('"dir "%_p%\v*.*" /B"') do dir "%_p%\%%a\csc.exe" /B >nul 2>&1 &&set "_q=%_p%\%%a\csc.exe" >nul 2>&1
echo %_q%|find /I "csc.exe" >nul 2>&1||goto :RuntimeNotFound

:Main
if exist "%~1" call :Build "%~1"
:Loop
if not exist "%~1" set /p "_f=Enter or Drag .cs File Here:"
call :Build %_f%
set /p "_y=Enter Y to Build Another File"
if not defined _y exit /B
if "%_y%"=="y" goto :Loop
exit /B

:Build
if not exist "%~1" exit /B
"%_q%" "%~1"
exit /B %errorlevel%

:RuntimeNotFound
echo  
REM this command makes the sound
echo Microsoft .NET Framework Needed But Not Found.
echo Install it and run this script again.
echo  
REM this command makes the sound
timeout /t 123
exit /B -1
exit
