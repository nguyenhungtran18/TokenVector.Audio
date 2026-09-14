@echo off
title Build TokenVector.Audio DLL and NUPKG
cd /d "%~dp0"
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_package.ps1"
pause
