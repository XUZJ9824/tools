echo off
echo %CD%

del /F C:\Temp\*.XLS*

start /B /WAIT C:\Windows\SysWOW64\cscript.exe "%CD%\Export_Effort.vbs" ALL

pause