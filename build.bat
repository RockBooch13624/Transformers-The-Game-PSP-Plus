@echo off
setlocal
cd /d "%~dp0"
title Transformers PC Builder

echo ==================================================
echo   Transformers: The Game (PSP) - PC Builder
echo   Requires your own copy: ULUS-10274, version 1.02
echo ==================================================
echo.

rem You can drag and drop the ISO onto this file, or pick it from a dialog.
set "ISO=%~1"

echo [1/3] Extracting game data from your ISO...
powershell -NoProfile -ExecutionPolicy Bypass -File "tools\extract_iso.ps1" -IsoPath "%ISO%"
if errorlevel 1 goto fail

echo.
echo [2/3] Checking build tools...
where cmake >nul 2>nul
if errorlevel 1 (
    echo CMake was not found. Install it from https://cmake.org/download/
    echo and tick "Add CMake to the system PATH" during setup.
    goto fail
)

echo.
echo [3/3] Building the PC executable...
cmake -S . -B build
if errorlevel 1 goto fail
cmake --build build --config Release
if errorlevel 1 goto fail

echo.
echo Done! Your executable is in the "bin" folder.
pause
exit /b 0

:fail
echo.
echo Build failed. See the messages above.
pause
exit /b 1
