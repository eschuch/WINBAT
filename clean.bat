@echo off
:: Clean before commit
:: Just a small tool to clean up some junk
:: before commit to repository

SET mypath=%~dp0
cd %mypath:~0,-1%

attrib -a -h *.*
del *.tmp
del *.log
