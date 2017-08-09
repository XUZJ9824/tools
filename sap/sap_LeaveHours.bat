echo off
echo %CD%

start /B /WAIT C:\Windows\SysWOW64\cscript.exe //X "%CD%\Export_Effort.vbs" LEAVE

pause