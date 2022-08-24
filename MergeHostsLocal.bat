@echo off
cd "%~dp0"
%~d0
cls
powershell.exe -executionpolicy remotesigned -File "MergeHosts.ps1"
pause
@echo on