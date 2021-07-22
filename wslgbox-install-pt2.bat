@echo off
set VERSION=1.0.0
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
echo Installing wsl2... (2/3)
del wsl2.msi 2> nul
curl https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi --output wsl2.msi
msiexec /qn /i wsl2.msi
wsl --set-default-version 2
wsl --update
echo Installing Ubuntu... (3/3)
curl https://wsldownload.azureedge.net/Ubuntu_2004.2020.424.0_x64.appx --output ubuntu.appx
powershell Add-AppxPackage .\ubuntu.appx
echo Deleting temp files...
del wsl2.msi 2> nul
del ubuntu.appx 2> nul
echo Installing rootfs...
ubuntu2004.exe install
echo Installing wslgBox...
wslconfig /setdefault Ubuntu-20.04
wsl /bin/bash -c "$(cd ~ && curl https://raw.githubusercontent.com/creamy-dev/wslgBox/main/wslgbox --output wslgbox && chmod +x wslgbox)"
wsl /bin/bash -c "cd ~ && ./wslgbox --install"
wsl --shutdown
echo Done! Starting wslgBox, for the first time! To do this later, open cmd, type wsl, type cd ~, and then type ./wslgbox!
echo Press any key to start...
pause > nul
start wsl /bin/bash -c "cd ~ && ./wslgbox"
del %0 && exit
