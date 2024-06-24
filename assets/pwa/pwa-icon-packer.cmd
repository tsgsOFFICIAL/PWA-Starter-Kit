@echo off
rem Set a local scope, allowing for delayed expansion of variables
setlocal EnableDelayedExpansion

rem Get the directory where the script resides using %~dp0
set "search_dir=%~dp0"

rem Define a output directory
set "output_dir=icons"

rem Loop through all files with "x" in the filename in the script directory and its subdirectories
echo Searching for x files...
echo.
for /R "%search_dir%" %%i in (*x*.*) do (
    rem Output the full path, filename, and extension of each file
    echo X File: %%i
    echo Filename without extension: %%~ni
    echo File Extension: %%~xi
    
    rem Remove all files with the "x" in the filename
    del "%%i"
)

rem Loop through all image files in the script directory and its subdirectories
echo.
echo Searching for logo...
echo.

rem look for a "logo.png" file in %search_dir%..\img\
for /R "%search_dir%..\img\" %%i in (logo.png) do (
    ffmpeg -loglevel quiet -y -i "%%i" -vf scale=72:72 "%~dp0%output_dir%/72x72%%~xi"
    ffmpeg -loglevel quiet -y -i "%%i" -vf scale=96:96 "%~dp0%output_dir%/96x96%%~xi"
    ffmpeg -loglevel quiet -y -i "%%i" -vf scale=128:128 "%~dp0%output_dir%/128x128%%~xi"
    ffmpeg -loglevel quiet -y -i "%%i" -vf scale=144:144 "%~dp0%output_dir%/144x144%%~xi"
    ffmpeg -loglevel quiet -y -i "%%i" -vf scale=152:152 "%~dp0%output_dir%/152x152%%~xi"
    ffmpeg -loglevel quiet -y -i "%%i" -vf scale=192:192 "%~dp0%output_dir%/192x192%%~xi"
    ffmpeg -loglevel quiet -y -i "%%i" -vf scale=384:384 "%~dp0%output_dir%/384x384%%~xi"
    ffmpeg -loglevel quiet -y -i "%%i" -vf scale=512:512 "%~dp0%output_dir%/512x512%%~xi"
)

endlocal

echo.
pause
