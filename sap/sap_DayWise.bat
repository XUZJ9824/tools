echo off
echo %CD%

del /F C:\Temp\*.XLS*

rem start /B /WAIT C:\Windows\SysWOW64\cscript.exe //X C:\home\sw\script\SAP\Export_Effort.vbs DAYWISE

start /B /WAIT C:\Windows\SysWOW64\cscript.exe C:\home\sw\script\SAP\Export_Effort.vbs DAYWISE

pause