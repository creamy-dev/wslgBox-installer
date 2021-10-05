@echo off
set VERSION=1.0.2
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
echo Welcome to wslgBox installer! This will install wslgBox.
echo All you need for this version is Windows 10 Insider Preview build 21362+.
echo Press any key to continue if you meet those requirements.
echo NOTE: This will reboot your computer.
pause > null
echo Installing wsl1. (1/3)
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
curl https://raw.githubusercontent.com/creamy-dev/wslgBox-installer/main/wslgbox-install-pt2.bat > "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\wslgbox-installer.bat"
shutdown /r /t 15 -c "wslgBox: Required reboot in 15 seconds to finish installation."
del %0 && exit
