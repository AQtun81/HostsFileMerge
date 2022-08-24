@echo off
cd "%~dp0"
%~d0
cls
powershell -executionpolicy remotesigned -Command "(Invoke-WebRequest 'https://raw.githubusercontent.com/AQtun81/aqtun81.github.io/master/ps/hosts/MergeHosts.ps1').Content | Invoke-Expression"
pause
@echo on