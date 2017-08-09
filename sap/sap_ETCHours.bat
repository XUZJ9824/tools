echo off
echo %CD%

start /B /WAIT C:\Windows\SysWOW64\cscript.exe "%CD%\Export_Effort.vbs" ETC

pause