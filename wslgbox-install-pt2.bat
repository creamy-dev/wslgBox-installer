@echo off
set VERSION=1.0.1
title wslgBox Installer v%VERSION%
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------  
cls
echo                _       ____              
echo               ^| ^|     ^|  _ \             
echo  __      _____^| ^| __ _^| ^|_) ^| _____  __  
echo  \ \ /\ / / __^| ^|/ _. ^|  _ ^< / _ \ \/ /  
echo   \ V  V /\__ \ ^| (_^| ^| ^|_) ^| (_) ^>  ^<   
echo    \_/\_/ ^|___/_^|\__. ^|____/ \___/_/\_\  
echo                   __/ ^|                  
echo                   \___/         v%VERSION%          
echo ----------------
echo wslgBox installer v%VERSION% by creamy-dev
echo de's on wslg
echo ----------------
echo Setting up... (2/3)
wsl --set-default-version 2
ubuntu2004.exe install
echo Installing wslgBox... (3/3)
wslconfig /setdefault Ubuntu-20.04
wsl /bin/bash -c "$(cd ~ && curl https://raw.githubusercontent.com/creamy-dev/wslgBox/main/wslgbox --output wslgbox && chmod +x wslgbox)"
wsl /bin/bash -c "cd ~ && ./wslgbox --install"
wsl --shutdown
echo Done! Starting wslgBox, for the first time! To do this later, open cmd, type wsl, type cd ~, and then type ./wslgbox!
echo Press any key to start...
pause > nul
start wsl /bin/bash -c "cd ~ && ./wslgbox"
del %0 && exit
