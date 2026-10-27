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
set "CMAKE="
where cmake >nul 2>nul && set "CMAKE=cmake"

rem If CMake is not on PATH, use the copy that ships with Visual Studio.
if not defined CMAKE (
    set "VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe"
    if exist "%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" (
        for /f "usebackq delims=" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath`) do (
            if exist "%%i\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe" (
                set "CMAKE=%%i\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
            )
        )
    )
)

if not defined CMAKE (
    echo CMake was not found.
    echo Open the Visual Studio Installer, click Modify, and make sure the
    echo "Desktop development with C++" workload is installed. It includes CMake.
    goto fail
)
echo Using CMake: %CMAKE%

echo.
echo [3/3] Building the PC executable...
"%CMAKE%" -S . -B build
if errorlevel 1 goto fail
"%CMAKE%" --build build --config Release
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
