@if (@CodeSection == @Batch) @then
@echo off
:: GET FROM WINDOWS CLIPBOARD
:: Using https://stackoverflow.com/questions/6832203
:: Por els.net.br (eschuch@gmail.com)
:: https://github.com/eschuch/WINBAT BAT_GETCLIP.bat
::::::::::::::::::::::::::::::::::::::::::::::::::::::


setlocal

set "getclip=cscript /nologo /e:JScript "%~f0""

rem // If you want to process the contents of the clipboard line-by-line, use
rem // something like this to preserve blank lines:
::for /f "delims=" %%I in ('%getclip% ^| findstr /n "^"') do (
::    setlocal enabledelayedexpansion
::    set "line=%%I" & set "line=!line:*:=!"
::    echo(!line!
::    endlocal
::)

rem // If all you need is to output the clipboard text to the console without
rem // any processing, then remove the "for /f" loop above and uncomment the
rem // following line:
%getclip%

goto :EOF

@end // begin JScript hybrid chimera
WSH.Echo(WSH.CreateObject('htmlfile').parentWindow.clipboardData.getData('text'));