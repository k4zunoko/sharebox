@echo off
setlocal

cd /d "%~dp0"

git add -A

git diff --cached --quiet
set DIFF_EXIT=%errorlevel%

if "%DIFF_EXIT%"=="0" (
    echo No changes to publish.
    pause
    exit /b 0
)

if not "%DIFF_EXIT%"=="1" (
    echo git diff failed with exit code %DIFF_EXIT%.
    pause
    exit /b %DIFF_EXIT%
)

git rev-parse --verify HEAD >nul 2>nul
if %errorlevel%==0 (
    git commit --amend --allow-empty -m "Publish latest snapshot"
) else (
    git commit --allow-empty -m "Publish latest snapshot"
)

if errorlevel 1 (
    echo Commit failed.
    pause
    exit /b 1
)

git push --force-with-lease origin main

if errorlevel 1 (
    echo Push failed.
    pause
    exit /b 1
)

endlocal
