@ECHO OFF
title logistics
chcp 65001 >nul


set filename=%1
Shift

If not exist %filename% (
    echo Invalid filename
    goto:end
)


:loop
IF NOT "%1"=="" (
    IF "%1"=="/?" (
        goto:print_help
    )
    If "%1" == "/print" (
        goto:print_file
    )
    IF "%1"=="/backup" (
        goto:backup_file
    )

    Shift
    goto :loop
)
goto :end

:print_help
ECHO Används för logistikhantering.
ECHO Syntax: logistics [enhet:] sökväg  [Rem/backup ^| /print ^| /sort ^<i ^| n ^| v ^| l ^| b ^| h ^>]
ECHO /backup Genererar en säkerhetskopia av datafilen i samma katalog.
ECHO /print Skriver ut innehållet i datafilen.
ECHO /sort Sorterar och skriver ut innehållet i datafilen.
ECHO i efter produktnummer\t n efter namn.
ECHO v efter vikt l\t efter längd
ECHO b efter bredd h\t efter höjd
ECHO:/? Skriver ut den här hjälptexten.
goto:eof

:print_file
for /f "tokens= 1,2,3,4,5,6 delims=;" %%a in (%filename%) do (
    echo %%a %%b %%c %%d %%e %%f
)
goto:eof


:backup_file
FOR %%i IN ("%filename%") DO ( set backupname=%%~ni.backup )    
copy %filename% %backupname%
goto:eof

:end