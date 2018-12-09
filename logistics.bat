::Laboration 2  i operativsystem
::Kod skriven av: Oscar Fredriksson
::2018-12-07

@ECHO OFF

title Logistikhanterare

chcp 65001 >nul
setlocal enabledelayedexpansion


if "%1"=="" (
    goto:interactive_mode
)

if "%1"=="/?" (
    call:print_help
)

set filename=%1
Shift

If not exist %filename% (
    echo Felaktigt filnamn
    set filename=
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
goto:eof

:interactive_mode
ECHO.
ECHO Vad vill du göra?
ECHO (p): skriva ut innehållet i filen  (b): göra en backup av filen
ECHO (s): sortera filen (h): skriva ut hjälptext (e): avsluta programmet

set /P "input=Skriv en bokstav: "

IF %input%==p (
    call:get_filename
    call:print_file
) ELSE IF %input%==b (
    call:get_filename
    call:backup_file 
) ELSE IF %input%==s (
    call:get_filename
    ECHO .
    ECHO Vilken kolumn vill du sortera på?
    ECHO i: ID, n: Namn, v: Vikt, l: Längd, b: Bredd, h: höjd          
    set /P "column=Skriv en bokstav: "
    call:sort_file
) ELSE IF %input%==h (
    call:print_help
) ELSE IF %input%==e (
    goto:eof
) ELSE (
    ECHO felaktig inmatning
)
goto:interactive_mode


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

:get_filename
set /P "filename=Skriv in filnamn: "

if not exist %filename% (
    echo felaktigt filnamn
    goto:get_filename
)
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
    goto:eof
) ELSE IF "%column%"=="n" ( 

    set sortcol=2

) ELSE IF "%column%"=="v" (

    set sortcol=3

) ELSE IF "%column%"=="l" (

    set sortcol=4

) ELSE IF "%column%"=="b" (

    set sortcol=5

) ELSE IF "%column%"=="h" (

    set sortcol=6

) ELSE (
    echo Felaktigt kolumnval
    goto:eof
)

(
    for /F "tokens=1-6 delims=;" %%A in (%filename%) DO (
        set col1=%%A
        set col2=%%B
        set col3=%%C
        set col4=%%D
        set col5=%%E
        set col6=%%F


        IF %sortcol%==2 (
            echo !col2!;!col1!;!col3!;!col4!;!col5!;!col6! 
        ) ELSE IF %sortcol%==3 (
            echo !col3!;!col2!;!col1!;!col4!;!col5!;!col6! 
        ) ELSE IF %sortcol%==4 (
            echo !col4!;!col2!;!col3!;!col1!;!col5!;!col6! 
        ) ELSE IF %sortcol%==5 (
            echo !col5!;!col2!;!col3!;!col4!;!col1!;!col6! 
        ) ELSE IF %sortcol%==6 (
            echo !col6!;!col2!;!col3!;!col4!;!col5!;!col1! 
        )

        
    )
) > %filename%.tmp

sort %filename%.tmp /O %filename%.tmp
(
    for /F "tokens=1-6 delims=;" %%A in (%filename%.tmp) DO (
        set col1=%%A
        set col2=%%B
        set col3=%%C
        set col4=%%D
        set col5=%%E
        set col6=%%F


        IF %sortcol%==2 (
            echo !col2!;!col1!;!col3!;!col4!;!col5!;!col6! 
        ) ELSE IF %sortcol%==3 (
            echo !col3!;!col2!;!col1!;!col4!;!col5!;!col6! 
        ) ELSE IF %sortcol%==4 (
            echo !col4!;!col2!;!col3!;!col1!;!col5!;!col6! 
        ) ELSE IF %sortcol%==5 (
            echo !col5!;!col2!;!col3!;!col4!;!col1!;!col6! 
        ) ELSE IF %sortcol%==6 (
            echo !col6!;!col2!;!col3!;!col4!;!col5!;!col1! 
        )
    )
) > %filename%

del "%filename%.tmp"

goto:eof