@echo off
:: bat http download
:: exit 0 = ok
:: exit 1 = nao existe/nao responde/FAIL
:: Por els.net.br (eschuch@gmail.com)
:: baseado em "https://stackoverflow.com/questions/43059943/how-to-force-exit-command-line-bat-file-when-occur-download-error"
::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Verifica se há parametros ::
if [%~1]==[] goto :blank
if [%~1]==[-h] goto :blank
if [%~1]==[/h] goto :blank
if [%~1]==[/?] goto :blank
if [%~1]==[-?] goto :blank
if [%~1]==[?] goto :blank


:: Variaveis ::
SET "destination=%cd%\tmp_%RANDOM%.log"
set "taskName=[Bat_Get_HTTP_%RANDOM%]"
SET "source=%~1"
setlocal enableextensions disabledelayedexpansion


:: Testa task ::
>nul (
        rem remove task if already present
        bitsadmin /list | find "%taskName%" && bitsadmin /cancel "%taskName%" > nul 2>&1
        rem create the task
        bitsadmin /create "%taskName%" > nul 2>&1
        rem include our file in the task
        bitsadmin /ADDFILEWITHRANGES "%taskName%" "%source%" "%destination%" 0:eof > nul 2>&1
        rem start the download
        bitsadmin /resume "%taskName%" > nul 2>&1
    )

:: Downloading ::
    set "exitCode="
    for /l %%a in (1 1 10) do if not defined exitCode for /f "delims=" %%a in ('
        bitsadmin /info "%taskName%"
        ^| findstr /b /l /c:"{"  
    ')  do for /f "tokens=3,*" %%b in ("%%a") do (
        if "%%~b"=="TRANSFERRED" ( 
            set "exitCode=0"
            >nul bitsadmin /complete "%taskName%" > nul 2>&1
        )
        if "%%~b"=="ERROR" ( 
            set "exitCode=1"
            bitsadmin /geterror "%taskName%" | findstr /b /c:"ERROR"
            >nul bitsadmin /cancel "%taskName%"
        )
        if not defined exitCode (
            echo(%%b %%c
            timeout /t 2 >nul 
        )
    ) > nul 2>&1
	
:: Saida com falhas ::
    if not defined exitCode ( echo FALHA TIMEOUT & exit /b 1 )
    if not exist "%destination%" ( echo FALHA ERROR & exit /b 1 )


:: Saida se ok ::
	type "%destination%"
	del "%destination%"
	echo SUCESSO
	exit /b 0
	
	
:: Help caso sem parametros ou help ::

:blank
echo %~nx0
echo.
echo.	Uso:
echo.	%~nx0 "URL"
echo.
echo.Onde:
echo.	URL 	: Obrigatorio: URL Completa para download
echo.
echo.Retorna um dos eventos abaixo em falha para STDOUT:
echo.	TIMEOUT : Tempo de comunicacao com destino URL atingido. 
echo.	ERROR   : Falha de destino, não existe, URL nao encontrado. 
echo.Ambos os erros podem ser capturados com ERRORLEVEL 1.
echo.
echo.Caso sucesso, retorna o destino da URL passada para STDOUT e
echo.pode ser capturado com ERRORLEVEL 0.
echo.
echo.els.net.br https://github.com/eschuch/WINBAT (eschuch@gmail.com) BAT_HTML_DOWNLOAD.bat
echo.Baseado em https://stackoverflow.com/questions/43059943/
echo.
echo.-------------------------------------------------------------------

goto:eof