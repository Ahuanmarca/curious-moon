Function Build
{
    $DB = "enceladus"
    $CSV        = Join-Path -Path $pwd -ChildPath "/data/master_plan.csv"
    $BUILD      = Join-Path -Path $pwd -ChildPath "/build.sql"

    $SCRIPTS    = Join-Path -Path $pwd -ChildPath "/scripts"
    $IMPORT     = Join-Path -Path $SCRIPTS -ChildPath "import.sql"
    $NORMALIZE  = Join-Path -Path $SCRIPTS -ChildPath "normalize.sql"
    $VIEWS      = Join-Path -Path $SCRIPTS -ChildPath "views.sql"

    # Making explicit that the build.sql script is intended for Windows
    Write-Output "-------------------------------------------------------------" | Set-Content $BUILD
    Write-Output "-- Created from 'Makefile.ps1' file, to be used in Windows --" | Add-Content $BUILD
    Write-Output "-------------------------------------------------------------" | Add-Content $BUILD

    # Creating import.master_plan schema and IMPORTING master_plan.csv data
    Get-Content $IMPORT | Add-Content $BUILD
    Write-Output "-- COPYING DATA FROM CSV FILE" | Add-Content $BUILD
    Write-Output "\copy import.master_plan FROM '$CSV' WITH DELIMITER ',' HEADER CSV;" | Add-Content $BUILD
    
    # NORMALIZING data (source table, lookup tables)
    Get-Content $NORMALIZE | Add-Content $BUILD

    # VIEWS
    Get-Content $VIEWS | Add-Content $BUILD

    # Explicit end of file
    Write-Output "-------------" | Add-Content $BUILD
    Write-Output "-- THE END --" | Add-Content $BUILD
    Write-Output "-------------" | Add-Content $BUILD

    # Running the created "build.sql" script (asks for password)
    psql -U postgres -f $BUILD $DB
}

Build