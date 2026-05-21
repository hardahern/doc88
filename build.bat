@echo off
setlocal enabledelayedexpansion

cd /d "%~dp0"

echo [build] cleaning old build artifacts...
if exist build\main rmdir /s /q build\main
if exist dist\main rmdir /s /q dist\main

echo [build] running PyInstaller...
python -m PyInstaller --clean --noconfirm main.spec
if errorlevel 1 (
    echo [build] PyInstaller failed.
    exit /b 1
)

echo [build] replacing exe and _internal in dist\doc88_extractor ^(preserving docs / logs / config.json / ffdec^)...
if not exist dist\doc88_extractor mkdir dist\doc88_extractor
if exist dist\doc88_extractor\doc88_extractor.exe del /q dist\doc88_extractor\doc88_extractor.exe
if exist dist\doc88_extractor\_internal rmdir /s /q dist\doc88_extractor\_internal

move /y dist\main\doc88_extractor.exe dist\doc88_extractor\ >nul
move /y dist\main\_internal dist\doc88_extractor\ >nul
rmdir dist\main

echo [build] generating dist\doc88_extractor_win64.zip ^(excludes docs/ logs/ config.json^)...
python make_zip.py
if errorlevel 1 (
    echo [build] zip step failed.
    exit /b 1
)

echo [build] done. output: dist\doc88_extractor\doc88_extractor.exe
echo [build] zip:    dist\doc88_extractor_win64.zip
endlocal
