echo off
echo %CD%

start /B /WAIT C:\Windows\SysWOW64\cscript.exe C:\home\sw\script\SAP\Export_Effort.vbs ETC

pause