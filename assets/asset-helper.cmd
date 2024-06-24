@echo off
rem Set a local scope, allowing for delayed expansion of variables
setlocal EnableDelayedExpansion

rem Get the directory where the script resides using %~dp0
set "search_dir=%~dp0"

rem Define a blacklist of directories not to process
set "blacklist=pwa"

rem Loop through all files with "-min" in the filename in the script directory and its subdirectories
echo Searching for minified files...
echo.
for /R "%search_dir%" %%i in (*-min.*) do (
    set "skipFile="

    rem Check if the directory is in the blacklist
    for %%b in (%blacklist%) do (
        rem check if %%~dpi starts with %%b using findstr & update skipFile to 1 if true
        echo %%~dpi | findstr /I /C:"%%b" > nul
        
        if not errorlevel 1 (
            set "skipFile=1"
        )
    )

    rem If skipFile variable is not defined, indicating the directory is not in the blacklist
    if not defined skipFile (
        rem Extract filename without extension
        set "filename=%%~ni"
        rem Output the full path, filename, and extension of each file
        echo Deleting Minified File: %%i
        @REM echo Filename without extension: !filename!
        @REM echo File Extension: %%~xi

        rem Remove all files with the -min suffix
        del "%%i"
    )    
)

rem Loop through all image files in the script directory and its subdirectories
echo.
echo Searching for image files...
echo.
for /R "%search_dir%" %%i in (*.png *.jpg *.jpeg) do (
    set "skipFile="

    for %%b in (%blacklist%) do (
        rem check if %%~dpi starts with %%b using findstr & update skipFile to 1 if true
        echo %%~dpi | findstr /I /C:"%%b" > nul

        if not errorlevel 1 (
            set "skipFile=1"
        )
    )

    if not defined skipFile (
        echo Minifiying Image: %%i
        ffmpeg -loglevel quiet -y -i "%%i" -vf scale=20:20 "%%~dpi%%~ni-min%%~xi"
    )
)

rem Loop through all video files in the script directory and its subdirectories
echo.
echo Searching for video files...
echo.
for /R "%search_dir%" %%i in (*.mp4 *.webm *.ogg) do (
    set "skipFile="

    for %%b in (%blacklist%) do (
        rem check if %%~dpi starts with %%b using findstr & update skipFile to 1 if true
        echo %%~dpi | findstr /I /C:"%%b" > nul

        if not errorlevel 1 (
            set "skipFile=1"
        )
    )

    if not defined skipFile (
        set "filename=%%~ni"
        echo Video File: %%i
        echo Filename without extension: !filename!
        echo File Extension: %%~xi
    )
)

endlocal

echo.
pause