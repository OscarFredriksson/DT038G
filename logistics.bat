::Laboration 2  i operativsystem
::Kod skriven av: Oscar Fredriksson
::2018-12-07


@ECHO OFF
title Logistikhanterare
chcp 65001 >nul


set filename=%1
Shift

If not exist %filename% (
    echo Felaktigt filnamn
    goto:end
)


:loop
IF NOT "%1"=="" (
    IF "%1"=="/?" ( 
        goto:print_help 
    ) ELSE IF "%1"=="/print" ( 
        goto:print_file 
    ) ELSE IF "%1"=="/backup" (
        goto:backup_file
    ) ELSE IF "%1"=="/sort" (
        set column=%2
        goto:sort_file  
    ) ELSE (
        echo Felaktigt tillval 
    )

    Shift
    goto:loop
)
goto:end

:print_help
ECHO Används för logistikhantering.
ECHO.
ECHO Syntax: logistics [enhet:] sökväg  [/backup ^| /print ^| /sort ^<i ^| n ^| v ^| l ^| b ^| h ^>]
ECHO.
ECHO /backup    Genererar en säkerhetskopia av datafilen i samma katalog.
ECHO /print     Skriver ut innehållet i datafilen.
ECHO /sort      Sorterar och skriver ut innehållet i datafilen.
ECHO             i efter produktnummer      n efter namn
ECHO             v efter vikt               l efter längd
ECHO             b efter bredd              h efter höjd
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

:sort_file
IF "%column%"=="i" ( 
    sort %filename% /O %filename%
) ELSE IF "%column%"=="n" ( 
    set /P "header=" < %filename%
    echo %header%
    for /F "skip=1 tokens=1-3 delims=;" %%a in (%filename%) do set a[%%a,%%b]=%%c
    for /F "tokens=2-4 delims=[;]=" %%a in ('set a[') do echo %%a,%%b,%%c
) ELSE IF "%column%"=="v" (
    echo hej
) ELSE IF "%column%"=="l" (
    echo hej  
) ELSE IF "%column%"=="b" (
    echo hej
) ELSE IF "%column%"=="h" (
    echo hej
) ELSE (
    echo Felaktigt kolumnval
)
goto:eof

:end