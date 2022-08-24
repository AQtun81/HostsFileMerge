@echo off
cd "%~dp0"
%~d0
cls
powershell -executionpolicy remotesigned -Command "(Invoke-WebRequest 'https://raw.githubusercontent.com/AQtun81/HostsFileMerge/main/MergeHosts.ps1').Content | Invoke-Expression"
pause
@echo on