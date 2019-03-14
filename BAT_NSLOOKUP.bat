@echo off
:: bat nslookup
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


nslookup %~1 %~2 > "%destination%" 2>&1


for /f %%a in ('type "%destination%"') do if [%%a]==[***] set "found=false"
if %found% == true (
	type "%destination%"
	del "%destination%"
	echo SUCESSO
	exit /b 0
) else (
	type "%destination%"
	del "%destination%"
	echo FALHA
	exit /b 1
)


:: Help caso sem parametros ou help ::

:blank
echo %~nx0
echo.
echo.	Uso:
echo.	%~nx0 "HOST" "SERVIDOR"
echo.
echo.Onde:
echo.	HOST		:	Obrigatorio: Nome do host que se quer pesquisar.
echo.					Se fornecido IP, retorna reverso.
echo.
echo.	SERVIDOR	:	Opcional: Caso fornecido, usa este servidor para
echo.					pesquisar pelo HOST.
echo.
echo.Caso erro, pode ser capturado com ERRORLEVEL 1.
echo.
echo.Sempre retorna a saida do comando NSLOOKUP
echo.
echo.els.net.br https://github.com/eschuch/WINBAT (eschuch@gmail.com) BAT_NSLOOKUP.bat
echo.
echo.-------------------------------------------------------------------
