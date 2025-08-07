@echo off
:: This script will relaunch itself as administrator and open PowerShell

:: Check for admin rights
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Start PowerShell
powershell.exe