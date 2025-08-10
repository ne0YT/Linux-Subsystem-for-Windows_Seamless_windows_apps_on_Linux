@echo off
REM Give the shell a moment to start
timeout /t 3 /nobreak >nul 2>&1
REM Kill Explorer to hide the taskbar for seamless mode
taskkill /F /IM explorer.exe >nul 2>&1
REM Always succeed even if explorer was not running
exit /b 0