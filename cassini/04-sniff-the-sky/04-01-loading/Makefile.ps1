Function Build
{
    $DB = "enceladus"
    $CSV        = Join-Path -Path $pwd -ChildPath "/data/inms.csv"
    $BUILD      = Join-Path -Path $pwd -ChildPath "/build.sql"

    $SCRIPTS    = Join-Path -Path $pwd -ChildPath "/scripts"
    $IMPORT     = Join-Path -Path $SCRIPTS -ChildPath "q13-import.sql"
    $COPY       = "\copy import.inms FROM '$CSV' DELIMITER ',' HEADER CSV;"
    $CLEAN      = Join-Path -Path $SCRIPTS -ChildPath "q14-clean.sql"

    # Making explicit that the build.sql script is intended for Windows
    Write-Output "-------------------------------------------------------------" | Set-Content $BUILD
    Write-Output "-- Created from 'Makefile.ps1' file, to be used in Windows --" | Add-Content $BUILD
    Write-Output "-------------------------------------------------------------" | Add-Content $BUILD

    # Appending scripts and \copy statement
    Get-Content $IMPORT | Add-Content $BUILD
    Write-Output "-- COPYING DATA FROM CSV FILE" | Add-Content $BUILD
    Write-Output $COPY | Add-Content $BUILD
    Get-Content $CLEAN | Add-Content $BUILD

    # Explicit end of file
    Write-Output "-------------" | Add-Content $BUILD
    Write-Output "-- THE END --" | Add-Content $BUILD
    Write-Output "-------------" | Add-Content $BUILD

    # Running the created "build.sql" script (asks for password)
    psql -U postgres -f $BUILD $DB
}

Build