::@echo off
:: bat ping tool
:: exit 0 = ok
:: exit 1 = nao existe/nao responde/FAIL
:: Por els.net.br (eschuch@gmail.com)
::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Verifica se há parametros ::
if [%~1]==[] goto :blank
if [%~1]==[-h] goto :blank
if [%~1]==[/h] goto :blank
if [%~1]==[/?] goto :blank
if [%~1]==[-?] goto :blank
if [%~1]==[?] goto :blank

:: Variaveis ::
setlocal enableextensions disabledelayedexpansion
SET "destination=%cd%\tmp_%RANDOM%.log"
set "found=true"
set "words=A Esgotado PING: Falha Fail Exhausted An"

ping %~1 %~2 > "%destination%" 2>&1
if [%ERRORLEVEL%]==[1]  (
	set "found=false"
) else (
	for /f %%a in ('type "%destination%"') do (
<<<<<<< HEAD
		for /l %%n in (%words%) do (
			if [%%a]==[%%n] set "found=false"
			)
		)
=======
		if [%%a]==[A] set "found=false"
		if [%%a]==[Esgotado] set "found=false"
		if [%%a]==[PING:] set "found=false"
		if [%%a]==[Falha] set "found=false"
		if [%%a]==[Fail] set "found=false"
		if [%%a]==[Exhausted] set "found=false"
		if [%%a]==[An] set "found=false"
>>>>>>> parent of e7011cd... Update BAT_PING.bat
	)
)

::. Exits .::
type "%destination%"
del "%destination%"
if %found% == true (
	echo SUCESSO
	exit /b 0
) else (
	echo FALHA
	exit /b 1
)
	
	
:: Help caso sem parametros ou help ::

:blank
echo %~nx0
echo.
echo.	Uso:
echo.	%~nx0 "DESTINO"
echo.
echo.Onde:
echo.	DESTINO 	: Obrigatorio: Destino final para ICMP
echo.
echo.Erros podem ser capturados com ERRORLEVEL 1.
echo.Sucessos podem ser capturados com ERRORLEVEL 0.
echo.
echo.els.net.br https://github.com/eschuch/WINBAT (eschuch@gmail.com) BAT_PING.bat
echo.
echo.-------------------------------------------------------------------

goto:eof