@echo off
cd "%~dp0"
%~d0
cls
powershell -executionpolicy remotesigned -Command "& ([scriptblock]::Create((irm https://raw.githubusercontent.com/AQtun81/HostsFileMerge/main/MergeHosts.ps1)))"
pause
@echo on