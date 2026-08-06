@echo off
REM upload_to_github.bat - Simple batch file for GitHub upload
REM OPPO F3 (CPH1609) TWRP Project

echo =========================================
echo OPPO F3 TWRP - GitHub Upload Helper
echo =========================================
echo.

REM Check if Git is installed
git --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Git nahi mila!
    echo.
    echo Pehle Git install karo:
    echo    https://git-scm.com/download/win
    echo.
    echo Git install karne ke baad PC restart karo
    echo Phir ye script dobara run karo
    echo.
    pause
    exit /b 1
)

echo ✅ Git installed hai
echo.

REM Go to project folder
cd /d D:\oppo\oppo-f3-twrp
if %errorlevel% neq 0 (
    echo ❌ Project folder nahi mila!
    echo    D:\oppo\oppo-f3-twrp check karo
    pause
    exit /b 1
)

echo ✅ Project folder mila
echo.

REM Initialize Git
if not exist ".git" (
    echo Git initialize kar raha hai...
    git init
)
echo.

REM Add files
echo Files add kar raha hai...
git add .
echo.

REM Commit
echo Commit kar raha hai...
git commit -m "Initial commit - OPPO F3 TWRP Recovery"
echo.

REM Ask for GitHub username
echo.
echo ⚠️  Pehle GitHub par repository banao:
echo    1. https://github.com par jao
echo    2. '+' icon par click karo
echo    3. 'New repository' select karo
echo    4. Name: oppo-f3-twrp
echo    5. 'Public' select karo
echo    6. 'Create repository' par click karo
echo.
set /p username="Apna GitHub username daalo: "

if "%username%"=="" (
    echo ❌ Username nahi daala!
    pause
    exit /b 1
)

REM Add remote
echo.
echo Remote add kar raha hai...
git remote add origin https://github.com/%username%/oppo-f3-twrp.git
git branch -M main
echo.

REM Push
echo Code push kar raha hai...
echo ⚠️  GitHub login info daalo jab puche
echo.
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo =========================================
    echo 🎉 SAB HO GAYA!
    echo =========================================
    echo.
    echo Ab GitHub par check karo:
    echo    https://github.com/%username%/oppo-f3-twrp
    echo.
    echo GitHub Actions automatically build karega!
    echo    - 'Actions' tab par build dikhega
    echo    - Build complete hone par email aayega
    echo    - 'Releases' se recovery image download kar sako
    echo.
    echo Recovery Image Download:
    echo    1. https://github.com/%username%/oppo-f3-twrp/releases
    echo    2. Latest release par click karo
    echo    3. twrp_CPH1609.img download karo
    echo.
    echo Phone Par Flash:
    echo    adb reboot bootloader
    echo    fastboot flash recovery twrp_CPH1609.img
    echo    fastboot boot twrp_CPH1609.img
) else (
    echo.
    echo ❌ Push Failed! Common reasons:
    echo    1. GitHub username galat hai
    echo    2. Repository nahi bana
    echo    3. Internet connection issue
    echo.
    echo Try karo manually:
    echo    git push -u origin main
)

echo.
pause
