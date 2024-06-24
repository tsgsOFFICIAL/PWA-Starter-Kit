@echo off
rem Set a local scope, allowing for delayed expansion of variables
setlocal EnableDelayedExpansion

rem Get the directory where the script resides using %~dp0
set "search_dir=%~dp0"

rem Loop through all files in the script directory and its subdirectories
echo.
echo Searching for files...
echo.
echo const assets = [
echo     '/',
@REM  Add assests to the array

for /R "%search_dir%" %%i in (*.png *.jpg *.jpeg *.css *.js *.json *.svg) do (
    set "skipFile="

    rem If filename contains sw, skip the file
    echo %%~ni | findstr /I /C:"sw" > nul

    if not errorlevel 1 (
        set "skipFile=1"
    )

    if not defined skipFile (
        rem Output the full path, filename, and extension of each file
        @REM echo File: %%i
        @REM echo Filename without extension: %%~ni
        @REM echo File Extension: %%~xi
        @REM echo Filename and extension: %%~ni%%~xi
        rem remove searchDir from the path
        set "file_path=%%i"
        set "file_path=!file_path:%search_dir%=!"

        rem replace \ with /
        set "file_path=!file_path:\=/!"
        echo     '/!file_path!',
    )
)

echo ];

endlocal

echo.
pause
